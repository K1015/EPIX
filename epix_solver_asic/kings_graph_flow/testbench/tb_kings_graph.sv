`timescale 1ns/1ps

// One testbench serves both source-separated RTL variants. Compile with
// -DEPIX_DUT and rtl/epix/kings_epix.sv for EPIX; otherwise compile the
// baseline source. ROWS and COLS select the rectangular King's graph size.
module tb_kings_graph #(
    parameter integer ROWS = 10,
    parameter integer COLS = 10,
    parameter integer N = ROWS * COLS,
    parameter integer NODE_W = (N <= 2) ? 1 : $clog2(N),
    parameter integer FIELD_W = 8
);
`ifdef EPIX_DUT
    localparam integer USE_EPIX = 1;
`else
    localparam integer USE_EPIX = 0;
`endif
    localparam integer CYCLES_PER_UPDATE = 9;
    localparam integer EXPECTED_EDGES =
        ROWS * (COLS-1) + (ROWS-1) * COLS +
        2 * (ROWS-1) * (COLS-1);

    logic clk;
    logic rst;
    logic start;
    logic stop;
    logic [N-1:0] initial_state;
    logic [31:0] seed;
    logic [31:0] update_limit;
    logic ready;
    logic busy;
    logic done;
    logic [N-1:0] state_out;
    logic [31:0] visits;
    logic [31:0] fresh_words;
    logic [31:0] reuse_events;
    logic [63:0] cycle_count;
    logic [NODE_W-1:0] active_node;
    logic signed [FIELD_W-1:0] sampled_field;

`ifdef EPIX_DUT
    kings_epix_solver #(
        .ROWS(ROWS), .COLS(COLS), .N(N), .NODE_W(NODE_W),
        .FIELD_W(FIELD_W), .PROB_GAIN(1024),
        .DELTA_FIELD(2), .MAX_REUSE(2)
    ) dut (.*);
`else
    kings_baseline_solver #(
        .ROWS(ROWS), .COLS(COLS), .N(N), .NODE_W(NODE_W),
        .FIELD_W(FIELD_W), .PROB_GAIN(1024)
    ) dut (.*);
`endif

    integer graph_weight [0:N-1][0:N-1];
    integer graph_vertices;
    integer graph_edges;
    integer graph_optimum;
    integer graph_fd;
    integer output_fd;
    integer scan_status;
    integer parsed_edges;
    integer u;
    integer v;
    integer weight;
    integer trials;
    integer visit_budget;
    string graph_path;
    string output_path;
    string vcd_path;
    bit vcd_enabled;
    bit vcd_active;
    integer vcd_trial;
    reg [7:0] token_p;
    reg [31:0] token_edge;

    always #1 clk = ~clk;

    function automatic integer abs_integer(input integer value);
        begin
            abs_integer = (value < 0) ? -value : value;
        end
    endfunction

    function automatic integer cut_score(input logic [N-1:0] state);
        integer i;
        integer j;
        integer score;
        begin
            score = 0;
            for (i = 0; i < N; i = i + 1)
                for (j = i + 1; j < N; j = j + 1)
                    if ((graph_weight[i][j] == 1) && (state[i] != state[j]))
                        score = score + 1;
            cut_score = score;
        end
    endfunction

    function automatic logic [31:0] lcg_next(input logic [31:0] value);
        begin
            lcg_next = 32'd1664525 * value + 32'd1013904223;
        end
    endfunction

    task automatic drive_reset;
        begin
            @(negedge clk);
            rst = 1'b1;
            repeat (2) @(negedge clk);
            rst = 1'b0;
            @(negedge clk);
            if (!ready)
                $fatal(1, "solver did not become ready after reset");
        end
    endtask

    task automatic load_and_check_graph;
        integer i;
        integer j;
        integer row_i;
        integer col_i;
        integer row_j;
        integer col_j;
        integer expected;
        begin
            for (i = 0; i < N; i = i + 1)
                for (j = 0; j < N; j = j + 1)
                    graph_weight[i][j] = 0;

            graph_fd = $fopen(graph_path, "r");
            if (graph_fd == 0)
                $fatal(1, "cannot open graph file %s", graph_path);
            scan_status = $fscanf(graph_fd, "%c %s %d %d %d\n",
                                  token_p, token_edge, graph_vertices,
                                  graph_edges, graph_optimum);
            if ((scan_status != 5) || (token_p != "p") ||
                (graph_vertices != N) || (graph_edges != EXPECTED_EDGES))
                $fatal(1,
                    "graph header does not describe King's %0dx%0d (N=%0d edges=%0d)",
                    ROWS, COLS, N, EXPECTED_EDGES);

            parsed_edges = 0;
            while (!$feof(graph_fd)) begin
                scan_status = $fscanf(graph_fd, "e %d %d %d\n", u, v, weight);
                if (scan_status == 3) begin
                    if ((u < 0) || (u >= N) || (v < 0) || (v >= N) ||
                        (u == v) || (weight != 1))
                        $fatal(1, "invalid unit King's edge (%0d,%0d,w=%0d)",
                               u, v, weight);
                    row_i = u / COLS;
                    col_i = u % COLS;
                    row_j = v / COLS;
                    col_j = v % COLS;
                    if ((abs_integer(row_i-row_j) > 1) ||
                        (abs_integer(col_i-col_j) > 1))
                        $fatal(1, "non-King edge (%0d,%0d)", u, v);
                    if (graph_weight[u][v] != 0)
                        $fatal(1, "duplicate edge (%0d,%0d)", u, v);
                    graph_weight[u][v] = 1;
                    graph_weight[v][u] = 1;
                    parsed_edges = parsed_edges + 1;
                end
            end
            $fclose(graph_fd);
            if (parsed_edges != EXPECTED_EDGES)
                $fatal(1, "parsed %0d edges; expected %0d",
                       parsed_edges, EXPECTED_EDGES);

            // Prove every and only open-boundary King neighbor pair exists.
            for (i = 0; i < N; i = i + 1) begin
                for (j = i + 1; j < N; j = j + 1) begin
                    row_i = i / COLS;
                    col_i = i % COLS;
                    row_j = j / COLS;
                    col_j = j % COLS;
                    expected = ((abs_integer(row_i-row_j) <= 1) &&
                                (abs_integer(col_i-col_j) <= 1));
                    if (graph_weight[i][j] != expected)
                        $fatal(1, "King topology mismatch at (%0d,%0d)", i, j);
                end
            end
        end
    endtask

    initial begin : campaign
        integer i;
        integer trial;
        integer score;
        integer best_score;
        integer hit_updates;
        integer hit_fresh;
        integer previous_visits;
        integer watchdog_cycles;
        logic [31:0] campaign_prng;

        clk = 1'b0;
        rst = 1'b1;
        start = 1'b0;
        stop = 1'b0;
        initial_state = '0;
        seed = 32'd1;
        update_limit = '0;
        trials = 4;
        visit_budget = 20000;
        vcd_enabled = $value$plusargs("VCD=%s", vcd_path);
        vcd_active = 1'b0;
        vcd_trial = 0;
        void'($value$plusargs("VCD_TRIAL=%d", vcd_trial));
        if (vcd_enabled) begin
`ifdef XCELIUM19
            // Xcelium 19 does not accept a string variable in $dumpfile.
            $dumpfile("kings_activity.vcd");
`else
            $dumpfile(vcd_path);
`endif
            $dumpvars(0, dut);
            $dumpoff;
        end

        if (!$value$plusargs("GRAPH=%s", graph_path))
            $fatal(1, "+GRAPH=<King's-edge-list> is required");
        if (!$value$plusargs("OUT=%s", output_path))
            output_path = USE_EPIX ? "kings_epix_trials.csv" :
                                     "kings_baseline_trials.csv";
        void'($value$plusargs("TRIALS=%d", trials));
        void'($value$plusargs("VISITS=%d", visit_budget));
        load_and_check_graph();

        output_fd = $fopen(output_path, "w");
        if (output_fd == 0)
            $fatal(1, "cannot open output file %s", output_path);
        $fwrite(output_fd,
            "engine,mode,rows,cols,n,edges,optimum,trial,seed_hex,initial_hex,visit_budget,best_cut,success,first_hit_updates,first_hit_cycles,first_hit_fresh_words,final_fresh_words,final_reuse_events,total_cycles\n");

        drive_reset();
        campaign_prng = 32'h97128127;
        for (trial = 0; trial < trials; trial = trial + 1) begin
            campaign_prng = lcg_next(campaign_prng);
            seed = campaign_prng | 32'd1;
            for (i = 0; i < N; i = i + 1) begin
                campaign_prng = lcg_next(campaign_prng);
                initial_state[i] = campaign_prng[31];
            end
            update_limit = visit_budget;
            @(negedge clk);
            start = 1'b1;
            @(negedge clk);
            start = 1'b0;
            if (vcd_enabled && trial == vcd_trial) begin
                $dumpon;
                vcd_active = 1'b1;
            end

            best_score = cut_score(state_out);
            hit_updates = ((graph_optimum >= 0) &&
                           (best_score == graph_optimum)) ? 0 : -1;
            hit_fresh = (hit_updates == 0) ? 0 : -1;
            previous_visits = 0;
            watchdog_cycles = 0;
            while (!done) begin
                @(negedge clk);
                watchdog_cycles = watchdog_cycles + 1;
                if (watchdog_cycles > visit_budget * CYCLES_PER_UPDATE + 4)
                    $fatal(1, "solver exceeded nine clocks/update");
                if (visits != previous_visits) begin
                    previous_visits = visits;
                    score = cut_score(state_out);
                    if (score > best_score)
                        best_score = score;
                    if ((graph_optimum >= 0) && (hit_updates < 0) &&
                        (score == graph_optimum)) begin
                        hit_updates = visits;
                        hit_fresh = fresh_words;
                    end
                end
            end
            if (vcd_active) begin
                $dumpoff;
                vcd_active = 1'b0;
            end

            if (USE_EPIX != 0)
                $fwrite(output_fd,
                    "rtl,epix,%0d,%0d,%0d,%0d,%0d,%0d,0x%08x,0x%0h,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d\n",
                    ROWS, COLS, N, graph_edges, graph_optimum, trial, seed,
                    initial_state, visit_budget, best_score,
                    (hit_updates >= 0), hit_updates,
                    (hit_updates >= 0) ? hit_updates*CYCLES_PER_UPDATE : -1,
                    hit_fresh, fresh_words, reuse_events, cycle_count);
            else
                $fwrite(output_fd,
                    "rtl,baseline,%0d,%0d,%0d,%0d,%0d,%0d,0x%08x,0x%0h,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d\n",
                    ROWS, COLS, N, graph_edges, graph_optimum, trial, seed,
                    initial_state, visit_budget, best_score,
                    (hit_updates >= 0), hit_updates,
                    (hit_updates >= 0) ? hit_updates*CYCLES_PER_UPDATE : -1,
                    hit_fresh, fresh_words, reuse_events, cycle_count);
            $display(
                "TRIAL mode=%s rows=%0d cols=%0d index=%0d best=%0d hit=%0d fresh=%0d cycles=%0d",
                USE_EPIX ? "epix" : "baseline", ROWS, COLS, trial,
                best_score, hit_updates, fresh_words, cycle_count);
        end
        $fclose(output_fd);
        $display("PASS mode=%s King's=%0dx%0d trials=%0d edges=%0d",
                 USE_EPIX ? "epix" : "baseline",
                 ROWS, COLS, trials, graph_edges);
        $finish;
    end
endmodule
