"""Display captured spin maps from a completed board run."""
import argparse,json
from pathlib import Path

def show(run,mode=1,trial=0):
    import numpy as np
    import matplotlib.pyplot as plt
    rows=[json.loads(line) for line in (Path(run)/'trials.jsonl').read_text().splitlines()]
    row=next(r for r in rows if r['mode']==mode and r['trial']==trial)
    problem=json.loads(Path(__file__).with_name('problem.json').read_text())
    inversion=row['trace'][-1][0]&1
    fig,axes=plt.subplots(3,4,figsize=(12,6.8))
    for index,(axis,frame) in enumerate(zip(axes.flat,row['trace'])):
        bits=[((frame[n//32]>>(n%32))&1)^inversion for n in range(288)]
        energy=frame[9] if frame[9]<2**31 else frame[9]-2**32
        axis.imshow(np.array(bits).reshape(12,24),cmap='gray_r',vmin=0,vmax=1,interpolation='nearest')
        axis.set_title('Sweep {} | {:.1f} ms | H={}'.format(problem['trace_sweeps'][index],frame[10]/1e5,energy),fontsize=9)
        axis.axis('off')
    fig.suptitle('Captured FPGA states | {} | seed {}\nOne fixed display inversion; full run includes all 1024 sweeps'.format('EPIX' if mode else 'IID',row['seed']))
    fig.tight_layout(rect=(0,0,1,.92))
    return fig
if __name__=='__main__':
    import matplotlib
    matplotlib.use('Agg')
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('run',type=Path);parser.add_argument('--mode',choices=['iid','epix'],default='epix')
    parser.add_argument('--trial',type=int,default=0);parser.add_argument('--output',type=Path,required=True)
    a=parser.parse_args();show(a.run,int(a.mode=='epix'),a.trial).savefig(str(a.output),dpi=150)
