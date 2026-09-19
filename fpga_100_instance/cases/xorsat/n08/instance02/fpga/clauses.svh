localparam integer CLAUSES=24;
function automatic [23:0] clause_rom(input logic [15:0] index);
    begin case(index)
        16'd0: clause_rom=24'h848081;
        16'd1: clause_rom=24'h040081;
        16'd2: clause_rom=24'h048001;
        16'd3: clause_rom=24'h840001;
        16'd4: clause_rom=24'h058784;
        16'd5: clause_rom=24'h850784;
        16'd6: clause_rom=24'h858704;
        16'd7: clause_rom=24'h050704;
        16'd8: clause_rom=24'h878183;
        16'd9: clause_rom=24'h070183;
        16'd10: clause_rom=24'h078103;
        16'd11: clause_rom=24'h870103;
        16'd12: clause_rom=24'h038681;
        16'd13: clause_rom=24'h830681;
        16'd14: clause_rom=24'h838601;
        16'd15: clause_rom=24'h030601;
        16'd16: clause_rom=24'h008682;
        16'd17: clause_rom=24'h800682;
        16'd18: clause_rom=24'h808602;
        16'd19: clause_rom=24'h000602;
        16'd20: clause_rom=24'h878285;
        16'd21: clause_rom=24'h070285;
        16'd22: clause_rom=24'h078205;
        16'd23: clause_rom=24'h870205;
        default: clause_rom=0;
    endcase end
endfunction
