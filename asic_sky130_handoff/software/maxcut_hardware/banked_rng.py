"""Share one RNG transform among 32 nodes without changing their streams."""


def service_block(nodes):
    if nodes <= 0 or nodes % 32:
        raise ValueError("RNG banks require a positive multiple of 32 nodes")
    return f'''    localparam integer RNG_BANKS={nodes // 32};
    wire [31:0] local_rng_word[0:{nodes - 1}];
    wire [RNG_BANKS-1:0] rng_bank_ready;
    wire local_commit=(phase==LOCAL) && (&rng_bank_ready);
    // Service independent streams; commit the color only when every bank is ready.
    for(genvar b=0;b<RNG_BANKS;b=b+1) begin: rng_bank
        logic [31:0] state[0:31];
        logic [31:0] served;
        wire [31:0] requests=refresh_mask[32*b+:32] & ~served;
        logic [4:0] service_node;
        logic service_valid;
        always_comb begin
            service_node=0;
            service_valid=0;
            for(integer j=0;j<32;j=j+1) begin
                if(requests[j] && !service_valid) begin
                    service_node=5'(j);
                    service_valid=1;
                end
            end
        end
        wire [31:0] service_word=advance(state[service_node]);
        assign rng_bank_ready[b]=((requests & (requests-1'b1))==0);
        for(genvar j=0;j<32;j=j+1) begin: word_read
            // Earlier words are already in state; bypass the word produced now.
            assign local_rng_word[32*b+j]=(service_valid && service_node==5'(j)) ?
                service_word : state[j];
        end
        always_ff @(posedge clk) begin
            if(rst) begin
                served<=0;
                for(integer j=0;j<32;j=j+1) state[j]<=0;
            end else begin
                if(seed_we && phase==IDLE && (seed_addr/32)==b)
                    state[seed_addr[4:0]]<=data_in;
                if(phase!=LOCAL || local_commit) served<=0;
                else if(service_valid) served[service_node]<=1;
                if(phase==LOCAL && service_valid) state[service_node]<=service_word;
            end
        end
    end
'''


def bank_solver(source, nodes):
    """Replace lane transforms in an otherwise unchanged generated solver."""
    def replace(before, after, count=1):
        nonlocal source
        if source.count(before) != count:
            raise ValueError("Unexpected solver anchor: " + before)
        source = source.replace(before, after)

    anchor = "    wire [3:0] bank_clock"
    replace(anchor, service_block(nodes) + anchor)
    replace("(phase==LOCAL && replica==r && color==c)",
            "(local_commit && replica==r && color==c)")
    replace("        logic [31:0] rng_state;\n", "")
    replace("wire [31:0] next_rng=advance(rng_state);",
            "wire [31:0] next_rng=local_rng_word[i];")
    start = source.index("        wire rng_clock;")
    end = source.index("        for(genvar r=", start)
    source = source[:start] + source[end:]
    replace("if(selected && replica==r)", "if(local_commit && selected && replica==r)")
    replace("LOCAL: begin", "LOCAL: if(local_commit) begin")
    source = source.replace("// Each physical node has a distinct RNG; replica states are time-shared.",
                            "// Each node retains its stream; replicas share the node bank.")
    return source


def update_config(config):
    nodes = config['n']
    rng = config['rng']
    rng.update(local_generators=nodes // 32, nodes_per_engine=32,
               local_stream_states=nodes, local_state_bits=32 * nodes,
               service_order='ascending node within each contiguous 32-node bank')
    gates = config['clock_gating']
    gates.update(local_rng_integrated_gates=0,
                 total_integrated_gates=gates['storage_integrated_gates'],
                 topology='four color storage clocks per replica; enabled RNG bank registers')
    config['colors'].pop('local_and_score_cycles_per_full_sweep', None)
    config['colors']['local_service_cycles'] = 'maximum fresh requests per bank, minimum one'
    config['colors']['score_cycles_per_local_update'] = 1
    return config
