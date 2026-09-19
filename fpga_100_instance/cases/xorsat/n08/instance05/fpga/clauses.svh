localparam integer CLAUSES=24;
function automatic [23:0] clause_rom(input logic [15:0] index);
    begin case(index)
        16'd0: clause_rom=24'h858680;
        16'd1: clause_rom=24'h050680;
        16'd2: clause_rom=24'h058600;
        16'd3: clause_rom=24'h850600;
        16'd4: clause_rom=24'h848387;
        16'd5: clause_rom=24'h040387;
        16'd6: clause_rom=24'h048307;
        16'd7: clause_rom=24'h840307;
        16'd8: clause_rom=24'h008381;
        16'd9: clause_rom=24'h800381;
        16'd10: clause_rom=24'h808301;
        16'd11: clause_rom=24'h000301;
        16'd12: clause_rom=24'h868182;
        16'd13: clause_rom=24'h060182;
        16'd14: clause_rom=24'h068102;
        16'd15: clause_rom=24'h860102;
        16'd16: clause_rom=24'h078485;
        16'd17: clause_rom=24'h870485;
        16'd18: clause_rom=24'h878405;
        16'd19: clause_rom=24'h070405;
        16'd20: clause_rom=24'h838182;
        16'd21: clause_rom=24'h030182;
        16'd22: clause_rom=24'h038102;
        16'd23: clause_rom=24'h830102;
        default: clause_rom=0;
    endcase end
endfunction
