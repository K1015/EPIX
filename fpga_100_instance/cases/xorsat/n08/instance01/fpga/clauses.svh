localparam integer CLAUSES=24;
function automatic [23:0] clause_rom(input logic [15:0] index);
    begin case(index)
        16'd0: clause_rom=24'h018680;
        16'd1: clause_rom=24'h810680;
        16'd2: clause_rom=24'h818600;
        16'd3: clause_rom=24'h010600;
        16'd4: clause_rom=24'h878083;
        16'd5: clause_rom=24'h070083;
        16'd6: clause_rom=24'h078003;
        16'd7: clause_rom=24'h870003;
        16'd8: clause_rom=24'h038281;
        16'd9: clause_rom=24'h830281;
        16'd10: clause_rom=24'h838201;
        16'd11: clause_rom=24'h030201;
        16'd12: clause_rom=24'h818485;
        16'd13: clause_rom=24'h010485;
        16'd14: clause_rom=24'h018405;
        16'd15: clause_rom=24'h810405;
        16'd16: clause_rom=24'h028780;
        16'd17: clause_rom=24'h820780;
        16'd18: clause_rom=24'h828700;
        16'd19: clause_rom=24'h020700;
        16'd20: clause_rom=24'h058684;
        16'd21: clause_rom=24'h850684;
        16'd22: clause_rom=24'h858604;
        16'd23: clause_rom=24'h050604;
        default: clause_rom=0;
    endcase end
endfunction
