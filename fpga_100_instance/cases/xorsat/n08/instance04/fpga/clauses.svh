localparam integer CLAUSES=24;
function automatic [23:0] clause_rom(input logic [15:0] index);
    begin case(index)
        16'd0: clause_rom=24'h858683;
        16'd1: clause_rom=24'h050683;
        16'd2: clause_rom=24'h058603;
        16'd3: clause_rom=24'h850603;
        16'd4: clause_rom=24'h868482;
        16'd5: clause_rom=24'h060482;
        16'd6: clause_rom=24'h068402;
        16'd7: clause_rom=24'h860402;
        16'd8: clause_rom=24'h868781;
        16'd9: clause_rom=24'h060781;
        16'd10: clause_rom=24'h068701;
        16'd11: clause_rom=24'h860701;
        16'd12: clause_rom=24'h808185;
        16'd13: clause_rom=24'h000185;
        16'd14: clause_rom=24'h008105;
        16'd15: clause_rom=24'h800105;
        16'd16: clause_rom=24'h878482;
        16'd17: clause_rom=24'h070482;
        16'd18: clause_rom=24'h078402;
        16'd19: clause_rom=24'h870402;
        16'd20: clause_rom=24'h008583;
        16'd21: clause_rom=24'h800583;
        16'd22: clause_rom=24'h808503;
        16'd23: clause_rom=24'h000503;
        default: clause_rom=0;
    endcase end
endfunction
