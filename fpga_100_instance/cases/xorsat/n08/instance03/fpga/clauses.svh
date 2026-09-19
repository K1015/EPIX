localparam integer CLAUSES=24;
function automatic [23:0] clause_rom(input logic [15:0] index);
    begin case(index)
        16'd0: clause_rom=24'h068785;
        16'd1: clause_rom=24'h860785;
        16'd2: clause_rom=24'h868705;
        16'd3: clause_rom=24'h060705;
        16'd4: clause_rom=24'h808187;
        16'd5: clause_rom=24'h000187;
        16'd6: clause_rom=24'h008107;
        16'd7: clause_rom=24'h800107;
        16'd8: clause_rom=24'h028486;
        16'd9: clause_rom=24'h820486;
        16'd10: clause_rom=24'h828406;
        16'd11: clause_rom=24'h020406;
        16'd12: clause_rom=24'h858086;
        16'd13: clause_rom=24'h050086;
        16'd14: clause_rom=24'h058006;
        16'd15: clause_rom=24'h850006;
        16'd16: clause_rom=24'h818384;
        16'd17: clause_rom=24'h010384;
        16'd18: clause_rom=24'h018304;
        16'd19: clause_rom=24'h810304;
        16'd20: clause_rom=24'h838782;
        16'd21: clause_rom=24'h030782;
        16'd22: clause_rom=24'h038702;
        16'd23: clause_rom=24'h830702;
        default: clause_rom=0;
    endcase end
endfunction
