#!/usr/bin/env python3
"""Reproduce each Chimera design from its input and shared templates."""
from pathlib import Path
import argparse,json,math,re,shutil,subprocess,sys
HERE=Path(__file__).resolve().parent

def build(case):
    case=Path(case).resolve();g=json.loads((case/'graph.json').read_text());s=json.loads((case/'software_spec.json').read_text())
    n=g['n'];side=s['side'];target=s['target'];norm=max(abs(w) for _,_,w in g['edges']);words=n//32
    assert n in (32,128,288,512,800) and n==8*side*side and norm in (3,4)
    assert s['beta_values']==[i/2 for i in range(1,15)] and s['sweeps_per_beta']==937 and s['maximum_sweeps']==13118
    assert s['field_refresh_delta']==.05 and s['max_hold_age']==2
    rawmax=max(sum(abs(w) for u,v,w in g['edges'] if i in (u,v)) for i in range(n))
    assert rawmax<128 and 14*rawmax<32768 and sum(abs(w) for _,_,w in g['edges'])<32768
    def template(name):return (HERE/'templates'/name).read_text()
    ref=template('reference.py')
    ref=ref.replace("assert NORMALIZER == 3", "N=GRAPH['n']\nSIDE=SPEC['side']\nTARGET=SPEC['target']\nFIELD_DENOMINATOR=2*NORMALIZER\nassert NORMALIZER in (3,4)\nassert SPEC['field_refresh_delta']==.05 and SPEC['max_hold_age']==2\nassert 1/FIELD_DENOMINATOR > .05")
    for old,new in [('np.zeros((128, 128)','np.zeros((N, N)'),('range(128)','range(N)'),('np.zeros(128','np.zeros(N'),('size == 128','size == N')]:ref=ref.replace(old,new)
    ref=ref.replace('for i in range(N)], dtype=np.uint64)', 'for i in range(128)], dtype=np.uint64)')
    ref=ref.replace('return sum(w * int(state[u] != state[v]) for u, v, w in EDGES)', "state=np.asarray(state)\n    return int(np.sum(EDGE_W*(state[EDGE_U]!=state[EDGE_V]),dtype=np.int64))")
    ref=ref.replace("GROUPS = [", "EDGE_U=np.asarray([u for u,v,w in EDGES]); EDGE_V=np.asarray([v for u,v,w in EDGES]); EDGE_W=np.asarray([w for u,v,w in EDGES])\nGROUPS = [")
    ref=ref.replace('2026091401280000 + trial',"int(json.loads((ROOT/'metadata.json').read_text())['replay_seed_base']) + trial")
    ref=ref.replace('(4*np.abs(numerator)+1)//3','(4*np.abs(numerator)+NORMALIZER//2)//NORMALIZER')
    ref=re.sub(r'\b68\b','TARGET',ref)
    ref=ref.replace("GRAPH['name'], 4,", "GRAPH['name'], SIDE,")
    ref=ref.replace('for raw in range(-10, 11):', 'for raw in range(-128,128):')
    ref=ref.replace('(4 * abs(step*raw) + 1)//3','(4 * abs(step*raw) + NORMALIZER//2)//NORMALIZER').replace('8*(step/2)*raw/3','8*(step/2)*raw/NORMALIZER')
    ref=ref.replace('numerator/6','numerator/FIELD_DENOMINATOR')
    (case/'reference.py').write_text(ref)
    vectors=template('make_vectors.py').replace('from reference import ROOT, NATIVE, GROUPS, run, validate_native','from reference import ROOT, NATIVE, N, GROUPS, run, validate_native').replace('for k in range(4)]','for k in range(N//32)]')
    vectors=vectors.replace("'certificate.json']","'certificate.json','metadata.json']")
    (case/'make_vectors.py').write_text(vectors)
    portable=template('portable.py').replace('("--trials", type=int, default=2)', '("--trials", type=int, default=1)')
    (case/'portable.py').write_text(portable)
    driver=template('sim_main.cpp').replace('std::array<uint32_t,4>','std::array<uint32_t,'+str(words)+'>').replace('get_array<4>','get_array<'+str(words)+'>').replace('get_array<128>','get_array<'+str(n)+'>').replace('i<128','i<'+str(n)).replace('j<4','j<'+str(words))
    driver=driver.replace('int signed10(unsigned value){return (value&512)?int(value)-1024:int(value);}', 'int signed10(unsigned value){return (value&32768)?int(value)-65536:int(value);}')
    if words==1:
        driver=driver.replace('dut->state_read[j]','dut->state_read').replace('dut->witness[j]','dut->witness')
    (case/'sim_main.cpp').write_text(driver)
    sv=template('solver_template.sv')
    sv=sv.replace('RNG_BANKS=128/32',f'RNG_BANKS={n}/32').replace('[0:127]',f'[0:{n-1}]')
    sv=sv.replace('[127:0]',f'[{n-1}:0]').replace('i<128',f'i<{n}').replace('[6:0] seed_addr',f'[{max(1,(n-1).bit_length())-1}:0] seed_addr').replace('[1:0] init_word',f'[{max(1,(words-1).bit_length())-1}:0] init_word')
    sv=sv.replace('[9:0] best_cut','[15:0] best_cut').replace('[9:0] current_cut','[15:0] current_cut')
    sv=sv.replace('[7:0] fresh_count,fire_count','[15:0] fresh_count,fire_count').replace("{7'b0,refresh_mask", "{15'b0,refresh_mask").replace("{7'b0,fire_mask","{15'b0,fire_mask")
    sv=sv.replace("{24'b0,fresh_count}","{16'b0,fresh_count}").replace("{24'b0,fire_count}","{16'b0,fire_count}").replace('node_visits+64',f'node_visits+32\'d{n//2}')
    sv=sv.replace("((i/32)+(i/8)%4+(i/4)%2)%2",f"((i/{8*side})+(i/8)%{side}+(i/4)%2)%2")
    sv=sv.replace("logic [1:0] NODE_WORD=2'(i/32)",f"logic [{max(1,(words-1).bit_length())-1}:0] NODE_WORD={max(1,(words-1).bit_length())}'(i/32)")
    sv=sv.replace('[8:0] saved_numerator','[15:0] saved_numerator').replace('[5:0] raw_value','[7:0] raw_value').replace('[8:0] numerator','[15:0] numerator').replace('[8:0] magnitude','[15:0] magnitude')
    sv=sv.replace("wire [10:0] unbounded_address=({2'b00,magnitude}*4+1)/3;",f"wire [17:0] unbounded_address=({{2'b00,magnitude}}*18'd4+18'd{norm//2})/18'd{norm};")
    sv=sv.replace('current_cut==68',f'current_cut=={target}')
    sv=sv.replace('128-bit native colored Gibbs',f'{n}-bit native colored Gibbs').replace('1/6, greater',f'1/{2*norm}, greater')
    (case/'solver_template.sv').write_text(sv)
    gen=template('generate_rtl.py').replace('from reference import EDGES, GRAPH, LUT','from reference import EDGES, GRAPH, LUT, N')
    gen=gen.replace('range(128)',f'range({n})').replace('[127:0]',f'[{n-1}:0]').replace('signed [5:0] raw_field','signed [7:0] raw_field').replace('signed [9:0] score','signed [15:0] score').replace('total[9:0]','total[15:0]')
    gen=gen.replace('setup_rng_words=256',f'setup_rng_words={2*n}').replace('128 fresh initialization words and 128 lane seed words',f'{n} fresh initialization words and {n} lane seed words').replace('expected_registers=4096',f'expected_registers={32*n}').replace('expected_icg_count=256',f'expected_icg_count={2*n}')
    (case/'generate_rtl.py').write_text(gen)
    subprocess.run([sys.executable,str(case/'generate_rtl.py')],check=True)
    metadata=json.loads((case/'metadata.json').read_text())
    metadata.update(hardware_rng_engines=words,hardware_rng_lanes=words,
                    hardware_rng_streams=n,hardware_rng_state_bits=32*n,
                    stored_pbits_per_rng_engine=32)
    (case/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
    print('GENERATED',case.name,flush=True)

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('case',type=Path)
    build(parser.parse_args().case)
