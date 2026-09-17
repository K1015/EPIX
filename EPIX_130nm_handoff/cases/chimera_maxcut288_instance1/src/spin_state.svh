wire spin_clk_0_0;
sky130_fd_sc_hd__dlclkp_1 spin_gate_0_0(.CLK(clk),.GATE(rst||test_enable||(start_accept&&phase==IDLE)||(init_we&&phase==IDLE)||(local_commit&&replica==0&&color==0)),.GCLK(spin_clk_0_0));
if(1) begin:state_0_0
reg spin,invalid;
assign state_bits[0]=spin;
assign dirty_bits[0]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[0];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[0];invalid<=0;end
 end
end
end
if(1) begin:state_0_1
reg spin,invalid;
assign state_bits[1]=spin;
assign dirty_bits[1]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[1];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[1];invalid<=0;end
 end
end
end
if(1) begin:state_0_2
reg spin,invalid;
assign state_bits[2]=spin;
assign dirty_bits[2]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[2];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[2];invalid<=0;end
 end
end
end
if(1) begin:state_0_3
reg spin,invalid;
assign state_bits[3]=spin;
assign dirty_bits[3]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[3];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[3];invalid<=0;end
 end
end
end
if(1) begin:state_0_12
reg spin,invalid;
assign state_bits[12]=spin;
assign dirty_bits[12]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[12];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[12];invalid<=0;end
 end
end
end
if(1) begin:state_0_13
reg spin,invalid;
assign state_bits[13]=spin;
assign dirty_bits[13]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[13];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[13];invalid<=0;end
 end
end
end
if(1) begin:state_0_14
reg spin,invalid;
assign state_bits[14]=spin;
assign dirty_bits[14]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[14];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[14];invalid<=0;end
 end
end
end
if(1) begin:state_0_15
reg spin,invalid;
assign state_bits[15]=spin;
assign dirty_bits[15]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[15];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[15];invalid<=0;end
 end
end
end
if(1) begin:state_0_16
reg spin,invalid;
assign state_bits[16]=spin;
assign dirty_bits[16]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[16];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[16];invalid<=0;end
 end
end
end
if(1) begin:state_0_17
reg spin,invalid;
assign state_bits[17]=spin;
assign dirty_bits[17]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[17];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[17];invalid<=0;end
 end
end
end
if(1) begin:state_0_18
reg spin,invalid;
assign state_bits[18]=spin;
assign dirty_bits[18]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[18];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[18];invalid<=0;end
 end
end
end
if(1) begin:state_0_19
reg spin,invalid;
assign state_bits[19]=spin;
assign dirty_bits[19]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[19];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[19];invalid<=0;end
 end
end
end
if(1) begin:state_0_28
reg spin,invalid;
assign state_bits[28]=spin;
assign dirty_bits[28]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[28];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[28];invalid<=0;end
 end
end
end
if(1) begin:state_0_29
reg spin,invalid;
assign state_bits[29]=spin;
assign dirty_bits[29]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[29];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[29];invalid<=0;end
 end
end
end
if(1) begin:state_0_30
reg spin,invalid;
assign state_bits[30]=spin;
assign dirty_bits[30]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[30];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[30];invalid<=0;end
 end
end
end
if(1) begin:state_0_31
reg spin,invalid;
assign state_bits[31]=spin;
assign dirty_bits[31]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[31];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[31];invalid<=0;end
 end
end
end
if(1) begin:state_0_32
reg spin,invalid;
assign state_bits[32]=spin;
assign dirty_bits[32]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[0];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[32];invalid<=0;end
 end
end
end
if(1) begin:state_0_33
reg spin,invalid;
assign state_bits[33]=spin;
assign dirty_bits[33]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[1];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[33];invalid<=0;end
 end
end
end
if(1) begin:state_0_34
reg spin,invalid;
assign state_bits[34]=spin;
assign dirty_bits[34]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[2];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[34];invalid<=0;end
 end
end
end
if(1) begin:state_0_35
reg spin,invalid;
assign state_bits[35]=spin;
assign dirty_bits[35]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[3];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[35];invalid<=0;end
 end
end
end
if(1) begin:state_0_44
reg spin,invalid;
assign state_bits[44]=spin;
assign dirty_bits[44]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[12];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[44];invalid<=0;end
 end
end
end
if(1) begin:state_0_45
reg spin,invalid;
assign state_bits[45]=spin;
assign dirty_bits[45]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[13];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[45];invalid<=0;end
 end
end
end
if(1) begin:state_0_46
reg spin,invalid;
assign state_bits[46]=spin;
assign dirty_bits[46]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[14];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[46];invalid<=0;end
 end
end
end
if(1) begin:state_0_47
reg spin,invalid;
assign state_bits[47]=spin;
assign dirty_bits[47]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[15];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[47];invalid<=0;end
 end
end
end
if(1) begin:state_0_52
reg spin,invalid;
assign state_bits[52]=spin;
assign dirty_bits[52]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[20];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[52];invalid<=0;end
 end
end
end
if(1) begin:state_0_53
reg spin,invalid;
assign state_bits[53]=spin;
assign dirty_bits[53]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[21];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[53];invalid<=0;end
 end
end
end
if(1) begin:state_0_54
reg spin,invalid;
assign state_bits[54]=spin;
assign dirty_bits[54]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[22];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[54];invalid<=0;end
 end
end
end
if(1) begin:state_0_55
reg spin,invalid;
assign state_bits[55]=spin;
assign dirty_bits[55]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[23];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[55];invalid<=0;end
 end
end
end
if(1) begin:state_0_56
reg spin,invalid;
assign state_bits[56]=spin;
assign dirty_bits[56]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[24];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[56];invalid<=0;end
 end
end
end
if(1) begin:state_0_57
reg spin,invalid;
assign state_bits[57]=spin;
assign dirty_bits[57]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[25];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[57];invalid<=0;end
 end
end
end
if(1) begin:state_0_58
reg spin,invalid;
assign state_bits[58]=spin;
assign dirty_bits[58]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[26];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[58];invalid<=0;end
 end
end
end
if(1) begin:state_0_59
reg spin,invalid;
assign state_bits[59]=spin;
assign dirty_bits[59]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[27];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[59];invalid<=0;end
 end
end
end
if(1) begin:state_0_68
reg spin,invalid;
assign state_bits[68]=spin;
assign dirty_bits[68]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[4];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[68];invalid<=0;end
 end
end
end
if(1) begin:state_0_69
reg spin,invalid;
assign state_bits[69]=spin;
assign dirty_bits[69]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[5];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[69];invalid<=0;end
 end
end
end
if(1) begin:state_0_70
reg spin,invalid;
assign state_bits[70]=spin;
assign dirty_bits[70]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[6];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[70];invalid<=0;end
 end
end
end
if(1) begin:state_0_71
reg spin,invalid;
assign state_bits[71]=spin;
assign dirty_bits[71]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[7];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[71];invalid<=0;end
 end
end
end
if(1) begin:state_0_72
reg spin,invalid;
assign state_bits[72]=spin;
assign dirty_bits[72]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[8];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[72];invalid<=0;end
 end
end
end
if(1) begin:state_0_73
reg spin,invalid;
assign state_bits[73]=spin;
assign dirty_bits[73]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[9];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[73];invalid<=0;end
 end
end
end
if(1) begin:state_0_74
reg spin,invalid;
assign state_bits[74]=spin;
assign dirty_bits[74]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[10];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[74];invalid<=0;end
 end
end
end
if(1) begin:state_0_75
reg spin,invalid;
assign state_bits[75]=spin;
assign dirty_bits[75]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[11];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[75];invalid<=0;end
 end
end
end
if(1) begin:state_0_84
reg spin,invalid;
assign state_bits[84]=spin;
assign dirty_bits[84]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[20];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[84];invalid<=0;end
 end
end
end
if(1) begin:state_0_85
reg spin,invalid;
assign state_bits[85]=spin;
assign dirty_bits[85]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[21];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[85];invalid<=0;end
 end
end
end
if(1) begin:state_0_86
reg spin,invalid;
assign state_bits[86]=spin;
assign dirty_bits[86]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[22];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[86];invalid<=0;end
 end
end
end
if(1) begin:state_0_87
reg spin,invalid;
assign state_bits[87]=spin;
assign dirty_bits[87]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[23];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[87];invalid<=0;end
 end
end
end
if(1) begin:state_0_88
reg spin,invalid;
assign state_bits[88]=spin;
assign dirty_bits[88]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[24];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[88];invalid<=0;end
 end
end
end
if(1) begin:state_0_89
reg spin,invalid;
assign state_bits[89]=spin;
assign dirty_bits[89]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[25];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[89];invalid<=0;end
 end
end
end
if(1) begin:state_0_90
reg spin,invalid;
assign state_bits[90]=spin;
assign dirty_bits[90]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[26];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[90];invalid<=0;end
 end
end
end
if(1) begin:state_0_91
reg spin,invalid;
assign state_bits[91]=spin;
assign dirty_bits[91]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[27];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[91];invalid<=0;end
 end
end
end
if(1) begin:state_0_96
reg spin,invalid;
assign state_bits[96]=spin;
assign dirty_bits[96]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[0];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[96];invalid<=0;end
 end
end
end
if(1) begin:state_0_97
reg spin,invalid;
assign state_bits[97]=spin;
assign dirty_bits[97]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[1];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[97];invalid<=0;end
 end
end
end
if(1) begin:state_0_98
reg spin,invalid;
assign state_bits[98]=spin;
assign dirty_bits[98]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[2];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[98];invalid<=0;end
 end
end
end
if(1) begin:state_0_99
reg spin,invalid;
assign state_bits[99]=spin;
assign dirty_bits[99]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[3];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[99];invalid<=0;end
 end
end
end
if(1) begin:state_0_108
reg spin,invalid;
assign state_bits[108]=spin;
assign dirty_bits[108]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[12];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[108];invalid<=0;end
 end
end
end
if(1) begin:state_0_109
reg spin,invalid;
assign state_bits[109]=spin;
assign dirty_bits[109]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[13];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[109];invalid<=0;end
 end
end
end
if(1) begin:state_0_110
reg spin,invalid;
assign state_bits[110]=spin;
assign dirty_bits[110]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[14];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[110];invalid<=0;end
 end
end
end
if(1) begin:state_0_111
reg spin,invalid;
assign state_bits[111]=spin;
assign dirty_bits[111]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[15];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[111];invalid<=0;end
 end
end
end
if(1) begin:state_0_112
reg spin,invalid;
assign state_bits[112]=spin;
assign dirty_bits[112]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[16];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[112];invalid<=0;end
 end
end
end
if(1) begin:state_0_113
reg spin,invalid;
assign state_bits[113]=spin;
assign dirty_bits[113]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[17];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[113];invalid<=0;end
 end
end
end
if(1) begin:state_0_114
reg spin,invalid;
assign state_bits[114]=spin;
assign dirty_bits[114]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[18];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[114];invalid<=0;end
 end
end
end
if(1) begin:state_0_115
reg spin,invalid;
assign state_bits[115]=spin;
assign dirty_bits[115]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[19];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[115];invalid<=0;end
 end
end
end
if(1) begin:state_0_124
reg spin,invalid;
assign state_bits[124]=spin;
assign dirty_bits[124]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[28];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[124];invalid<=0;end
 end
end
end
if(1) begin:state_0_125
reg spin,invalid;
assign state_bits[125]=spin;
assign dirty_bits[125]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[29];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[125];invalid<=0;end
 end
end
end
if(1) begin:state_0_126
reg spin,invalid;
assign state_bits[126]=spin;
assign dirty_bits[126]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[30];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[126];invalid<=0;end
 end
end
end
if(1) begin:state_0_127
reg spin,invalid;
assign state_bits[127]=spin;
assign dirty_bits[127]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[31];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[127];invalid<=0;end
 end
end
end
if(1) begin:state_0_128
reg spin,invalid;
assign state_bits[128]=spin;
assign dirty_bits[128]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[0];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[128];invalid<=0;end
 end
end
end
if(1) begin:state_0_129
reg spin,invalid;
assign state_bits[129]=spin;
assign dirty_bits[129]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[1];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[129];invalid<=0;end
 end
end
end
if(1) begin:state_0_130
reg spin,invalid;
assign state_bits[130]=spin;
assign dirty_bits[130]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[2];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[130];invalid<=0;end
 end
end
end
if(1) begin:state_0_131
reg spin,invalid;
assign state_bits[131]=spin;
assign dirty_bits[131]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[3];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[131];invalid<=0;end
 end
end
end
if(1) begin:state_0_140
reg spin,invalid;
assign state_bits[140]=spin;
assign dirty_bits[140]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[12];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[140];invalid<=0;end
 end
end
end
if(1) begin:state_0_141
reg spin,invalid;
assign state_bits[141]=spin;
assign dirty_bits[141]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[13];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[141];invalid<=0;end
 end
end
end
if(1) begin:state_0_142
reg spin,invalid;
assign state_bits[142]=spin;
assign dirty_bits[142]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[14];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[142];invalid<=0;end
 end
end
end
if(1) begin:state_0_143
reg spin,invalid;
assign state_bits[143]=spin;
assign dirty_bits[143]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[15];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[143];invalid<=0;end
 end
end
end
if(1) begin:state_0_148
reg spin,invalid;
assign state_bits[148]=spin;
assign dirty_bits[148]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[20];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[148];invalid<=0;end
 end
end
end
if(1) begin:state_0_149
reg spin,invalid;
assign state_bits[149]=spin;
assign dirty_bits[149]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[21];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[149];invalid<=0;end
 end
end
end
if(1) begin:state_0_150
reg spin,invalid;
assign state_bits[150]=spin;
assign dirty_bits[150]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[22];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[150];invalid<=0;end
 end
end
end
if(1) begin:state_0_151
reg spin,invalid;
assign state_bits[151]=spin;
assign dirty_bits[151]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[23];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[151];invalid<=0;end
 end
end
end
if(1) begin:state_0_152
reg spin,invalid;
assign state_bits[152]=spin;
assign dirty_bits[152]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[24];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[152];invalid<=0;end
 end
end
end
if(1) begin:state_0_153
reg spin,invalid;
assign state_bits[153]=spin;
assign dirty_bits[153]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[25];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[153];invalid<=0;end
 end
end
end
if(1) begin:state_0_154
reg spin,invalid;
assign state_bits[154]=spin;
assign dirty_bits[154]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[26];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[154];invalid<=0;end
 end
end
end
if(1) begin:state_0_155
reg spin,invalid;
assign state_bits[155]=spin;
assign dirty_bits[155]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[27];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[155];invalid<=0;end
 end
end
end
if(1) begin:state_0_164
reg spin,invalid;
assign state_bits[164]=spin;
assign dirty_bits[164]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[4];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[164];invalid<=0;end
 end
end
end
if(1) begin:state_0_165
reg spin,invalid;
assign state_bits[165]=spin;
assign dirty_bits[165]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[5];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[165];invalid<=0;end
 end
end
end
if(1) begin:state_0_166
reg spin,invalid;
assign state_bits[166]=spin;
assign dirty_bits[166]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[6];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[166];invalid<=0;end
 end
end
end
if(1) begin:state_0_167
reg spin,invalid;
assign state_bits[167]=spin;
assign dirty_bits[167]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[7];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[167];invalid<=0;end
 end
end
end
if(1) begin:state_0_168
reg spin,invalid;
assign state_bits[168]=spin;
assign dirty_bits[168]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[8];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[168];invalid<=0;end
 end
end
end
if(1) begin:state_0_169
reg spin,invalid;
assign state_bits[169]=spin;
assign dirty_bits[169]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[9];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[169];invalid<=0;end
 end
end
end
if(1) begin:state_0_170
reg spin,invalid;
assign state_bits[170]=spin;
assign dirty_bits[170]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[10];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[170];invalid<=0;end
 end
end
end
if(1) begin:state_0_171
reg spin,invalid;
assign state_bits[171]=spin;
assign dirty_bits[171]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[11];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[171];invalid<=0;end
 end
end
end
if(1) begin:state_0_180
reg spin,invalid;
assign state_bits[180]=spin;
assign dirty_bits[180]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[20];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[180];invalid<=0;end
 end
end
end
if(1) begin:state_0_181
reg spin,invalid;
assign state_bits[181]=spin;
assign dirty_bits[181]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[21];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[181];invalid<=0;end
 end
end
end
if(1) begin:state_0_182
reg spin,invalid;
assign state_bits[182]=spin;
assign dirty_bits[182]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[22];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[182];invalid<=0;end
 end
end
end
if(1) begin:state_0_183
reg spin,invalid;
assign state_bits[183]=spin;
assign dirty_bits[183]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[23];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[183];invalid<=0;end
 end
end
end
if(1) begin:state_0_184
reg spin,invalid;
assign state_bits[184]=spin;
assign dirty_bits[184]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[24];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[184];invalid<=0;end
 end
end
end
if(1) begin:state_0_185
reg spin,invalid;
assign state_bits[185]=spin;
assign dirty_bits[185]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[25];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[185];invalid<=0;end
 end
end
end
if(1) begin:state_0_186
reg spin,invalid;
assign state_bits[186]=spin;
assign dirty_bits[186]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[26];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[186];invalid<=0;end
 end
end
end
if(1) begin:state_0_187
reg spin,invalid;
assign state_bits[187]=spin;
assign dirty_bits[187]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[27];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[187];invalid<=0;end
 end
end
end
if(1) begin:state_0_192
reg spin,invalid;
assign state_bits[192]=spin;
assign dirty_bits[192]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[0];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[192];invalid<=0;end
 end
end
end
if(1) begin:state_0_193
reg spin,invalid;
assign state_bits[193]=spin;
assign dirty_bits[193]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[1];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[193];invalid<=0;end
 end
end
end
if(1) begin:state_0_194
reg spin,invalid;
assign state_bits[194]=spin;
assign dirty_bits[194]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[2];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[194];invalid<=0;end
 end
end
end
if(1) begin:state_0_195
reg spin,invalid;
assign state_bits[195]=spin;
assign dirty_bits[195]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[3];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[195];invalid<=0;end
 end
end
end
if(1) begin:state_0_204
reg spin,invalid;
assign state_bits[204]=spin;
assign dirty_bits[204]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[12];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[204];invalid<=0;end
 end
end
end
if(1) begin:state_0_205
reg spin,invalid;
assign state_bits[205]=spin;
assign dirty_bits[205]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[13];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[205];invalid<=0;end
 end
end
end
if(1) begin:state_0_206
reg spin,invalid;
assign state_bits[206]=spin;
assign dirty_bits[206]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[14];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[206];invalid<=0;end
 end
end
end
if(1) begin:state_0_207
reg spin,invalid;
assign state_bits[207]=spin;
assign dirty_bits[207]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[15];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[207];invalid<=0;end
 end
end
end
if(1) begin:state_0_208
reg spin,invalid;
assign state_bits[208]=spin;
assign dirty_bits[208]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[16];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[208];invalid<=0;end
 end
end
end
if(1) begin:state_0_209
reg spin,invalid;
assign state_bits[209]=spin;
assign dirty_bits[209]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[17];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[209];invalid<=0;end
 end
end
end
if(1) begin:state_0_210
reg spin,invalid;
assign state_bits[210]=spin;
assign dirty_bits[210]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[18];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[210];invalid<=0;end
 end
end
end
if(1) begin:state_0_211
reg spin,invalid;
assign state_bits[211]=spin;
assign dirty_bits[211]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[19];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[211];invalid<=0;end
 end
end
end
if(1) begin:state_0_220
reg spin,invalid;
assign state_bits[220]=spin;
assign dirty_bits[220]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[28];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[220];invalid<=0;end
 end
end
end
if(1) begin:state_0_221
reg spin,invalid;
assign state_bits[221]=spin;
assign dirty_bits[221]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[29];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[221];invalid<=0;end
 end
end
end
if(1) begin:state_0_222
reg spin,invalid;
assign state_bits[222]=spin;
assign dirty_bits[222]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[30];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[222];invalid<=0;end
 end
end
end
if(1) begin:state_0_223
reg spin,invalid;
assign state_bits[223]=spin;
assign dirty_bits[223]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[31];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[223];invalid<=0;end
 end
end
end
if(1) begin:state_0_224
reg spin,invalid;
assign state_bits[224]=spin;
assign dirty_bits[224]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[0];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[224];invalid<=0;end
 end
end
end
if(1) begin:state_0_225
reg spin,invalid;
assign state_bits[225]=spin;
assign dirty_bits[225]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[1];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[225];invalid<=0;end
 end
end
end
if(1) begin:state_0_226
reg spin,invalid;
assign state_bits[226]=spin;
assign dirty_bits[226]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[2];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[226];invalid<=0;end
 end
end
end
if(1) begin:state_0_227
reg spin,invalid;
assign state_bits[227]=spin;
assign dirty_bits[227]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[3];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[227];invalid<=0;end
 end
end
end
if(1) begin:state_0_236
reg spin,invalid;
assign state_bits[236]=spin;
assign dirty_bits[236]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[12];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[236];invalid<=0;end
 end
end
end
if(1) begin:state_0_237
reg spin,invalid;
assign state_bits[237]=spin;
assign dirty_bits[237]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[13];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[237];invalid<=0;end
 end
end
end
if(1) begin:state_0_238
reg spin,invalid;
assign state_bits[238]=spin;
assign dirty_bits[238]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[14];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[238];invalid<=0;end
 end
end
end
if(1) begin:state_0_239
reg spin,invalid;
assign state_bits[239]=spin;
assign dirty_bits[239]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[15];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[239];invalid<=0;end
 end
end
end
if(1) begin:state_0_244
reg spin,invalid;
assign state_bits[244]=spin;
assign dirty_bits[244]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[20];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[244];invalid<=0;end
 end
end
end
if(1) begin:state_0_245
reg spin,invalid;
assign state_bits[245]=spin;
assign dirty_bits[245]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[21];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[245];invalid<=0;end
 end
end
end
if(1) begin:state_0_246
reg spin,invalid;
assign state_bits[246]=spin;
assign dirty_bits[246]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[22];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[246];invalid<=0;end
 end
end
end
if(1) begin:state_0_247
reg spin,invalid;
assign state_bits[247]=spin;
assign dirty_bits[247]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[23];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[247];invalid<=0;end
 end
end
end
if(1) begin:state_0_248
reg spin,invalid;
assign state_bits[248]=spin;
assign dirty_bits[248]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[24];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[248];invalid<=0;end
 end
end
end
if(1) begin:state_0_249
reg spin,invalid;
assign state_bits[249]=spin;
assign dirty_bits[249]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[25];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[249];invalid<=0;end
 end
end
end
if(1) begin:state_0_250
reg spin,invalid;
assign state_bits[250]=spin;
assign dirty_bits[250]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[26];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[250];invalid<=0;end
 end
end
end
if(1) begin:state_0_251
reg spin,invalid;
assign state_bits[251]=spin;
assign dirty_bits[251]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[27];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[251];invalid<=0;end
 end
end
end
if(1) begin:state_0_260
reg spin,invalid;
assign state_bits[260]=spin;
assign dirty_bits[260]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[4];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[260];invalid<=0;end
 end
end
end
if(1) begin:state_0_261
reg spin,invalid;
assign state_bits[261]=spin;
assign dirty_bits[261]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[5];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[261];invalid<=0;end
 end
end
end
if(1) begin:state_0_262
reg spin,invalid;
assign state_bits[262]=spin;
assign dirty_bits[262]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[6];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[262];invalid<=0;end
 end
end
end
if(1) begin:state_0_263
reg spin,invalid;
assign state_bits[263]=spin;
assign dirty_bits[263]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[7];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[263];invalid<=0;end
 end
end
end
if(1) begin:state_0_264
reg spin,invalid;
assign state_bits[264]=spin;
assign dirty_bits[264]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[8];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[264];invalid<=0;end
 end
end
end
if(1) begin:state_0_265
reg spin,invalid;
assign state_bits[265]=spin;
assign dirty_bits[265]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[9];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[265];invalid<=0;end
 end
end
end
if(1) begin:state_0_266
reg spin,invalid;
assign state_bits[266]=spin;
assign dirty_bits[266]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[10];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[266];invalid<=0;end
 end
end
end
if(1) begin:state_0_267
reg spin,invalid;
assign state_bits[267]=spin;
assign dirty_bits[267]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[11];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[267];invalid<=0;end
 end
end
end
if(1) begin:state_0_276
reg spin,invalid;
assign state_bits[276]=spin;
assign dirty_bits[276]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[20];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[276];invalid<=0;end
 end
end
end
if(1) begin:state_0_277
reg spin,invalid;
assign state_bits[277]=spin;
assign dirty_bits[277]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[21];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[277];invalid<=0;end
 end
end
end
if(1) begin:state_0_278
reg spin,invalid;
assign state_bits[278]=spin;
assign dirty_bits[278]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[22];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[278];invalid<=0;end
 end
end
end
if(1) begin:state_0_279
reg spin,invalid;
assign state_bits[279]=spin;
assign dirty_bits[279]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[23];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[279];invalid<=0;end
 end
end
end
if(1) begin:state_0_280
reg spin,invalid;
assign state_bits[280]=spin;
assign dirty_bits[280]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[24];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[280];invalid<=0;end
 end
end
end
if(1) begin:state_0_281
reg spin,invalid;
assign state_bits[281]=spin;
assign dirty_bits[281]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[25];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[281];invalid<=0;end
 end
end
end
if(1) begin:state_0_282
reg spin,invalid;
assign state_bits[282]=spin;
assign dirty_bits[282]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[26];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[282];invalid<=0;end
 end
end
end
if(1) begin:state_0_283
reg spin,invalid;
assign state_bits[283]=spin;
assign dirty_bits[283]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[27];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[283];invalid<=0;end
 end
end
end
wire spin_clk_0_1;
sky130_fd_sc_hd__dlclkp_1 spin_gate_0_1(.CLK(clk),.GATE(rst||test_enable||(start_accept&&phase==IDLE)||(init_we&&phase==IDLE)||(local_commit&&replica==0&&color==1)),.GCLK(spin_clk_0_1));
if(1) begin:state_0_4
reg spin,invalid;
assign state_bits[4]=spin;
assign dirty_bits[4]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[4];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[4];invalid<=0;end
 end
end
end
if(1) begin:state_0_5
reg spin,invalid;
assign state_bits[5]=spin;
assign dirty_bits[5]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[5];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[5];invalid<=0;end
 end
end
end
if(1) begin:state_0_6
reg spin,invalid;
assign state_bits[6]=spin;
assign dirty_bits[6]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[6];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[6];invalid<=0;end
 end
end
end
if(1) begin:state_0_7
reg spin,invalid;
assign state_bits[7]=spin;
assign dirty_bits[7]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[7];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[7];invalid<=0;end
 end
end
end
if(1) begin:state_0_8
reg spin,invalid;
assign state_bits[8]=spin;
assign dirty_bits[8]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[8];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[8];invalid<=0;end
 end
end
end
if(1) begin:state_0_9
reg spin,invalid;
assign state_bits[9]=spin;
assign dirty_bits[9]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[9];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[9];invalid<=0;end
 end
end
end
if(1) begin:state_0_10
reg spin,invalid;
assign state_bits[10]=spin;
assign dirty_bits[10]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[10];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[10];invalid<=0;end
 end
end
end
if(1) begin:state_0_11
reg spin,invalid;
assign state_bits[11]=spin;
assign dirty_bits[11]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[11];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[11];invalid<=0;end
 end
end
end
if(1) begin:state_0_20
reg spin,invalid;
assign state_bits[20]=spin;
assign dirty_bits[20]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[20];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[20];invalid<=0;end
 end
end
end
if(1) begin:state_0_21
reg spin,invalid;
assign state_bits[21]=spin;
assign dirty_bits[21]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[21];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[21];invalid<=0;end
 end
end
end
if(1) begin:state_0_22
reg spin,invalid;
assign state_bits[22]=spin;
assign dirty_bits[22]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[22];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[22];invalid<=0;end
 end
end
end
if(1) begin:state_0_23
reg spin,invalid;
assign state_bits[23]=spin;
assign dirty_bits[23]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[23];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[23];invalid<=0;end
 end
end
end
if(1) begin:state_0_24
reg spin,invalid;
assign state_bits[24]=spin;
assign dirty_bits[24]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[24];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[24];invalid<=0;end
 end
end
end
if(1) begin:state_0_25
reg spin,invalid;
assign state_bits[25]=spin;
assign dirty_bits[25]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[25];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[25];invalid<=0;end
 end
end
end
if(1) begin:state_0_26
reg spin,invalid;
assign state_bits[26]=spin;
assign dirty_bits[26]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[26];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[26];invalid<=0;end
 end
end
end
if(1) begin:state_0_27
reg spin,invalid;
assign state_bits[27]=spin;
assign dirty_bits[27]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==0)spin<=data_in[27];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[27];invalid<=0;end
 end
end
end
if(1) begin:state_0_36
reg spin,invalid;
assign state_bits[36]=spin;
assign dirty_bits[36]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[4];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[36];invalid<=0;end
 end
end
end
if(1) begin:state_0_37
reg spin,invalid;
assign state_bits[37]=spin;
assign dirty_bits[37]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[5];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[37];invalid<=0;end
 end
end
end
if(1) begin:state_0_38
reg spin,invalid;
assign state_bits[38]=spin;
assign dirty_bits[38]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[6];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[38];invalid<=0;end
 end
end
end
if(1) begin:state_0_39
reg spin,invalid;
assign state_bits[39]=spin;
assign dirty_bits[39]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[7];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[39];invalid<=0;end
 end
end
end
if(1) begin:state_0_40
reg spin,invalid;
assign state_bits[40]=spin;
assign dirty_bits[40]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[8];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[40];invalid<=0;end
 end
end
end
if(1) begin:state_0_41
reg spin,invalid;
assign state_bits[41]=spin;
assign dirty_bits[41]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[9];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[41];invalid<=0;end
 end
end
end
if(1) begin:state_0_42
reg spin,invalid;
assign state_bits[42]=spin;
assign dirty_bits[42]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[10];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[42];invalid<=0;end
 end
end
end
if(1) begin:state_0_43
reg spin,invalid;
assign state_bits[43]=spin;
assign dirty_bits[43]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[11];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[43];invalid<=0;end
 end
end
end
if(1) begin:state_0_48
reg spin,invalid;
assign state_bits[48]=spin;
assign dirty_bits[48]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[16];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[48];invalid<=0;end
 end
end
end
if(1) begin:state_0_49
reg spin,invalid;
assign state_bits[49]=spin;
assign dirty_bits[49]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[17];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[49];invalid<=0;end
 end
end
end
if(1) begin:state_0_50
reg spin,invalid;
assign state_bits[50]=spin;
assign dirty_bits[50]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[18];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[50];invalid<=0;end
 end
end
end
if(1) begin:state_0_51
reg spin,invalid;
assign state_bits[51]=spin;
assign dirty_bits[51]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[19];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[51];invalid<=0;end
 end
end
end
if(1) begin:state_0_60
reg spin,invalid;
assign state_bits[60]=spin;
assign dirty_bits[60]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[28];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[60];invalid<=0;end
 end
end
end
if(1) begin:state_0_61
reg spin,invalid;
assign state_bits[61]=spin;
assign dirty_bits[61]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[29];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[61];invalid<=0;end
 end
end
end
if(1) begin:state_0_62
reg spin,invalid;
assign state_bits[62]=spin;
assign dirty_bits[62]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[30];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[62];invalid<=0;end
 end
end
end
if(1) begin:state_0_63
reg spin,invalid;
assign state_bits[63]=spin;
assign dirty_bits[63]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[31];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[63];invalid<=0;end
 end
end
end
if(1) begin:state_0_64
reg spin,invalid;
assign state_bits[64]=spin;
assign dirty_bits[64]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[0];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[64];invalid<=0;end
 end
end
end
if(1) begin:state_0_65
reg spin,invalid;
assign state_bits[65]=spin;
assign dirty_bits[65]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[1];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[65];invalid<=0;end
 end
end
end
if(1) begin:state_0_66
reg spin,invalid;
assign state_bits[66]=spin;
assign dirty_bits[66]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[2];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[66];invalid<=0;end
 end
end
end
if(1) begin:state_0_67
reg spin,invalid;
assign state_bits[67]=spin;
assign dirty_bits[67]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[3];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[67];invalid<=0;end
 end
end
end
if(1) begin:state_0_76
reg spin,invalid;
assign state_bits[76]=spin;
assign dirty_bits[76]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[12];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[76];invalid<=0;end
 end
end
end
if(1) begin:state_0_77
reg spin,invalid;
assign state_bits[77]=spin;
assign dirty_bits[77]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[13];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[77];invalid<=0;end
 end
end
end
if(1) begin:state_0_78
reg spin,invalid;
assign state_bits[78]=spin;
assign dirty_bits[78]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[14];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[78];invalid<=0;end
 end
end
end
if(1) begin:state_0_79
reg spin,invalid;
assign state_bits[79]=spin;
assign dirty_bits[79]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[15];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[79];invalid<=0;end
 end
end
end
if(1) begin:state_0_80
reg spin,invalid;
assign state_bits[80]=spin;
assign dirty_bits[80]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[16];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[80];invalid<=0;end
 end
end
end
if(1) begin:state_0_81
reg spin,invalid;
assign state_bits[81]=spin;
assign dirty_bits[81]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[17];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[81];invalid<=0;end
 end
end
end
if(1) begin:state_0_82
reg spin,invalid;
assign state_bits[82]=spin;
assign dirty_bits[82]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[18];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[82];invalid<=0;end
 end
end
end
if(1) begin:state_0_83
reg spin,invalid;
assign state_bits[83]=spin;
assign dirty_bits[83]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[19];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[83];invalid<=0;end
 end
end
end
if(1) begin:state_0_92
reg spin,invalid;
assign state_bits[92]=spin;
assign dirty_bits[92]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[28];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[92];invalid<=0;end
 end
end
end
if(1) begin:state_0_93
reg spin,invalid;
assign state_bits[93]=spin;
assign dirty_bits[93]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[29];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[93];invalid<=0;end
 end
end
end
if(1) begin:state_0_94
reg spin,invalid;
assign state_bits[94]=spin;
assign dirty_bits[94]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[30];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[94];invalid<=0;end
 end
end
end
if(1) begin:state_0_95
reg spin,invalid;
assign state_bits[95]=spin;
assign dirty_bits[95]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[31];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[95];invalid<=0;end
 end
end
end
if(1) begin:state_0_100
reg spin,invalid;
assign state_bits[100]=spin;
assign dirty_bits[100]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[4];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[100];invalid<=0;end
 end
end
end
if(1) begin:state_0_101
reg spin,invalid;
assign state_bits[101]=spin;
assign dirty_bits[101]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[5];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[101];invalid<=0;end
 end
end
end
if(1) begin:state_0_102
reg spin,invalid;
assign state_bits[102]=spin;
assign dirty_bits[102]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[6];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[102];invalid<=0;end
 end
end
end
if(1) begin:state_0_103
reg spin,invalid;
assign state_bits[103]=spin;
assign dirty_bits[103]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[7];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[103];invalid<=0;end
 end
end
end
if(1) begin:state_0_104
reg spin,invalid;
assign state_bits[104]=spin;
assign dirty_bits[104]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[8];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[104];invalid<=0;end
 end
end
end
if(1) begin:state_0_105
reg spin,invalid;
assign state_bits[105]=spin;
assign dirty_bits[105]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[9];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[105];invalid<=0;end
 end
end
end
if(1) begin:state_0_106
reg spin,invalid;
assign state_bits[106]=spin;
assign dirty_bits[106]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[10];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[106];invalid<=0;end
 end
end
end
if(1) begin:state_0_107
reg spin,invalid;
assign state_bits[107]=spin;
assign dirty_bits[107]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[11];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[107];invalid<=0;end
 end
end
end
if(1) begin:state_0_116
reg spin,invalid;
assign state_bits[116]=spin;
assign dirty_bits[116]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[20];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[116];invalid<=0;end
 end
end
end
if(1) begin:state_0_117
reg spin,invalid;
assign state_bits[117]=spin;
assign dirty_bits[117]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[21];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[117];invalid<=0;end
 end
end
end
if(1) begin:state_0_118
reg spin,invalid;
assign state_bits[118]=spin;
assign dirty_bits[118]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[22];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[118];invalid<=0;end
 end
end
end
if(1) begin:state_0_119
reg spin,invalid;
assign state_bits[119]=spin;
assign dirty_bits[119]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[23];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[119];invalid<=0;end
 end
end
end
if(1) begin:state_0_120
reg spin,invalid;
assign state_bits[120]=spin;
assign dirty_bits[120]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[24];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[120];invalid<=0;end
 end
end
end
if(1) begin:state_0_121
reg spin,invalid;
assign state_bits[121]=spin;
assign dirty_bits[121]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[25];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[121];invalid<=0;end
 end
end
end
if(1) begin:state_0_122
reg spin,invalid;
assign state_bits[122]=spin;
assign dirty_bits[122]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[26];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[122];invalid<=0;end
 end
end
end
if(1) begin:state_0_123
reg spin,invalid;
assign state_bits[123]=spin;
assign dirty_bits[123]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[27];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[123];invalid<=0;end
 end
end
end
if(1) begin:state_0_132
reg spin,invalid;
assign state_bits[132]=spin;
assign dirty_bits[132]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[4];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[132];invalid<=0;end
 end
end
end
if(1) begin:state_0_133
reg spin,invalid;
assign state_bits[133]=spin;
assign dirty_bits[133]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[5];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[133];invalid<=0;end
 end
end
end
if(1) begin:state_0_134
reg spin,invalid;
assign state_bits[134]=spin;
assign dirty_bits[134]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[6];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[134];invalid<=0;end
 end
end
end
if(1) begin:state_0_135
reg spin,invalid;
assign state_bits[135]=spin;
assign dirty_bits[135]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[7];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[135];invalid<=0;end
 end
end
end
if(1) begin:state_0_136
reg spin,invalid;
assign state_bits[136]=spin;
assign dirty_bits[136]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[8];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[136];invalid<=0;end
 end
end
end
if(1) begin:state_0_137
reg spin,invalid;
assign state_bits[137]=spin;
assign dirty_bits[137]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[9];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[137];invalid<=0;end
 end
end
end
if(1) begin:state_0_138
reg spin,invalid;
assign state_bits[138]=spin;
assign dirty_bits[138]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[10];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[138];invalid<=0;end
 end
end
end
if(1) begin:state_0_139
reg spin,invalid;
assign state_bits[139]=spin;
assign dirty_bits[139]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[11];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[139];invalid<=0;end
 end
end
end
if(1) begin:state_0_144
reg spin,invalid;
assign state_bits[144]=spin;
assign dirty_bits[144]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[16];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[144];invalid<=0;end
 end
end
end
if(1) begin:state_0_145
reg spin,invalid;
assign state_bits[145]=spin;
assign dirty_bits[145]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[17];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[145];invalid<=0;end
 end
end
end
if(1) begin:state_0_146
reg spin,invalid;
assign state_bits[146]=spin;
assign dirty_bits[146]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[18];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[146];invalid<=0;end
 end
end
end
if(1) begin:state_0_147
reg spin,invalid;
assign state_bits[147]=spin;
assign dirty_bits[147]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[19];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[147];invalid<=0;end
 end
end
end
if(1) begin:state_0_156
reg spin,invalid;
assign state_bits[156]=spin;
assign dirty_bits[156]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[28];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[156];invalid<=0;end
 end
end
end
if(1) begin:state_0_157
reg spin,invalid;
assign state_bits[157]=spin;
assign dirty_bits[157]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[29];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[157];invalid<=0;end
 end
end
end
if(1) begin:state_0_158
reg spin,invalid;
assign state_bits[158]=spin;
assign dirty_bits[158]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[30];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[158];invalid<=0;end
 end
end
end
if(1) begin:state_0_159
reg spin,invalid;
assign state_bits[159]=spin;
assign dirty_bits[159]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==4)spin<=data_in[31];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[159];invalid<=0;end
 end
end
end
if(1) begin:state_0_160
reg spin,invalid;
assign state_bits[160]=spin;
assign dirty_bits[160]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[0];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[160];invalid<=0;end
 end
end
end
if(1) begin:state_0_161
reg spin,invalid;
assign state_bits[161]=spin;
assign dirty_bits[161]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[1];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[161];invalid<=0;end
 end
end
end
if(1) begin:state_0_162
reg spin,invalid;
assign state_bits[162]=spin;
assign dirty_bits[162]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[2];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[162];invalid<=0;end
 end
end
end
if(1) begin:state_0_163
reg spin,invalid;
assign state_bits[163]=spin;
assign dirty_bits[163]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[3];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[163];invalid<=0;end
 end
end
end
if(1) begin:state_0_172
reg spin,invalid;
assign state_bits[172]=spin;
assign dirty_bits[172]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[12];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[172];invalid<=0;end
 end
end
end
if(1) begin:state_0_173
reg spin,invalid;
assign state_bits[173]=spin;
assign dirty_bits[173]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[13];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[173];invalid<=0;end
 end
end
end
if(1) begin:state_0_174
reg spin,invalid;
assign state_bits[174]=spin;
assign dirty_bits[174]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[14];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[174];invalid<=0;end
 end
end
end
if(1) begin:state_0_175
reg spin,invalid;
assign state_bits[175]=spin;
assign dirty_bits[175]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[15];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[175];invalid<=0;end
 end
end
end
if(1) begin:state_0_176
reg spin,invalid;
assign state_bits[176]=spin;
assign dirty_bits[176]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[16];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[176];invalid<=0;end
 end
end
end
if(1) begin:state_0_177
reg spin,invalid;
assign state_bits[177]=spin;
assign dirty_bits[177]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[17];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[177];invalid<=0;end
 end
end
end
if(1) begin:state_0_178
reg spin,invalid;
assign state_bits[178]=spin;
assign dirty_bits[178]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[18];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[178];invalid<=0;end
 end
end
end
if(1) begin:state_0_179
reg spin,invalid;
assign state_bits[179]=spin;
assign dirty_bits[179]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[19];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[179];invalid<=0;end
 end
end
end
if(1) begin:state_0_188
reg spin,invalid;
assign state_bits[188]=spin;
assign dirty_bits[188]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[28];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[188];invalid<=0;end
 end
end
end
if(1) begin:state_0_189
reg spin,invalid;
assign state_bits[189]=spin;
assign dirty_bits[189]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[29];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[189];invalid<=0;end
 end
end
end
if(1) begin:state_0_190
reg spin,invalid;
assign state_bits[190]=spin;
assign dirty_bits[190]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[30];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[190];invalid<=0;end
 end
end
end
if(1) begin:state_0_191
reg spin,invalid;
assign state_bits[191]=spin;
assign dirty_bits[191]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==5)spin<=data_in[31];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[191];invalid<=0;end
 end
end
end
if(1) begin:state_0_196
reg spin,invalid;
assign state_bits[196]=spin;
assign dirty_bits[196]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[4];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[196];invalid<=0;end
 end
end
end
if(1) begin:state_0_197
reg spin,invalid;
assign state_bits[197]=spin;
assign dirty_bits[197]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[5];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[197];invalid<=0;end
 end
end
end
if(1) begin:state_0_198
reg spin,invalid;
assign state_bits[198]=spin;
assign dirty_bits[198]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[6];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[198];invalid<=0;end
 end
end
end
if(1) begin:state_0_199
reg spin,invalid;
assign state_bits[199]=spin;
assign dirty_bits[199]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[7];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[199];invalid<=0;end
 end
end
end
if(1) begin:state_0_200
reg spin,invalid;
assign state_bits[200]=spin;
assign dirty_bits[200]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[8];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[200];invalid<=0;end
 end
end
end
if(1) begin:state_0_201
reg spin,invalid;
assign state_bits[201]=spin;
assign dirty_bits[201]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[9];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[201];invalid<=0;end
 end
end
end
if(1) begin:state_0_202
reg spin,invalid;
assign state_bits[202]=spin;
assign dirty_bits[202]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[10];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[202];invalid<=0;end
 end
end
end
if(1) begin:state_0_203
reg spin,invalid;
assign state_bits[203]=spin;
assign dirty_bits[203]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[11];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[203];invalid<=0;end
 end
end
end
if(1) begin:state_0_212
reg spin,invalid;
assign state_bits[212]=spin;
assign dirty_bits[212]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[20];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[212];invalid<=0;end
 end
end
end
if(1) begin:state_0_213
reg spin,invalid;
assign state_bits[213]=spin;
assign dirty_bits[213]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[21];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[213];invalid<=0;end
 end
end
end
if(1) begin:state_0_214
reg spin,invalid;
assign state_bits[214]=spin;
assign dirty_bits[214]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[22];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[214];invalid<=0;end
 end
end
end
if(1) begin:state_0_215
reg spin,invalid;
assign state_bits[215]=spin;
assign dirty_bits[215]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[23];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[215];invalid<=0;end
 end
end
end
if(1) begin:state_0_216
reg spin,invalid;
assign state_bits[216]=spin;
assign dirty_bits[216]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[24];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[216];invalid<=0;end
 end
end
end
if(1) begin:state_0_217
reg spin,invalid;
assign state_bits[217]=spin;
assign dirty_bits[217]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[25];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[217];invalid<=0;end
 end
end
end
if(1) begin:state_0_218
reg spin,invalid;
assign state_bits[218]=spin;
assign dirty_bits[218]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[26];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[218];invalid<=0;end
 end
end
end
if(1) begin:state_0_219
reg spin,invalid;
assign state_bits[219]=spin;
assign dirty_bits[219]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==6)spin<=data_in[27];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[219];invalid<=0;end
 end
end
end
if(1) begin:state_0_228
reg spin,invalid;
assign state_bits[228]=spin;
assign dirty_bits[228]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[4];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[228];invalid<=0;end
 end
end
end
if(1) begin:state_0_229
reg spin,invalid;
assign state_bits[229]=spin;
assign dirty_bits[229]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[5];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[229];invalid<=0;end
 end
end
end
if(1) begin:state_0_230
reg spin,invalid;
assign state_bits[230]=spin;
assign dirty_bits[230]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[6];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[230];invalid<=0;end
 end
end
end
if(1) begin:state_0_231
reg spin,invalid;
assign state_bits[231]=spin;
assign dirty_bits[231]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[7];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[231];invalid<=0;end
 end
end
end
if(1) begin:state_0_232
reg spin,invalid;
assign state_bits[232]=spin;
assign dirty_bits[232]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[8];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[232];invalid<=0;end
 end
end
end
if(1) begin:state_0_233
reg spin,invalid;
assign state_bits[233]=spin;
assign dirty_bits[233]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[9];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[233];invalid<=0;end
 end
end
end
if(1) begin:state_0_234
reg spin,invalid;
assign state_bits[234]=spin;
assign dirty_bits[234]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[10];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[234];invalid<=0;end
 end
end
end
if(1) begin:state_0_235
reg spin,invalid;
assign state_bits[235]=spin;
assign dirty_bits[235]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[11];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[235];invalid<=0;end
 end
end
end
if(1) begin:state_0_240
reg spin,invalid;
assign state_bits[240]=spin;
assign dirty_bits[240]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[16];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[240];invalid<=0;end
 end
end
end
if(1) begin:state_0_241
reg spin,invalid;
assign state_bits[241]=spin;
assign dirty_bits[241]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[17];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[241];invalid<=0;end
 end
end
end
if(1) begin:state_0_242
reg spin,invalid;
assign state_bits[242]=spin;
assign dirty_bits[242]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[18];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[242];invalid<=0;end
 end
end
end
if(1) begin:state_0_243
reg spin,invalid;
assign state_bits[243]=spin;
assign dirty_bits[243]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[19];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[243];invalid<=0;end
 end
end
end
if(1) begin:state_0_252
reg spin,invalid;
assign state_bits[252]=spin;
assign dirty_bits[252]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[28];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[252];invalid<=0;end
 end
end
end
if(1) begin:state_0_253
reg spin,invalid;
assign state_bits[253]=spin;
assign dirty_bits[253]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[29];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[253];invalid<=0;end
 end
end
end
if(1) begin:state_0_254
reg spin,invalid;
assign state_bits[254]=spin;
assign dirty_bits[254]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[30];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[254];invalid<=0;end
 end
end
end
if(1) begin:state_0_255
reg spin,invalid;
assign state_bits[255]=spin;
assign dirty_bits[255]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==7)spin<=data_in[31];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[255];invalid<=0;end
 end
end
end
if(1) begin:state_0_256
reg spin,invalid;
assign state_bits[256]=spin;
assign dirty_bits[256]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[0];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[256];invalid<=0;end
 end
end
end
if(1) begin:state_0_257
reg spin,invalid;
assign state_bits[257]=spin;
assign dirty_bits[257]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[1];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[257];invalid<=0;end
 end
end
end
if(1) begin:state_0_258
reg spin,invalid;
assign state_bits[258]=spin;
assign dirty_bits[258]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[2];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[258];invalid<=0;end
 end
end
end
if(1) begin:state_0_259
reg spin,invalid;
assign state_bits[259]=spin;
assign dirty_bits[259]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[3];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[259];invalid<=0;end
 end
end
end
if(1) begin:state_0_268
reg spin,invalid;
assign state_bits[268]=spin;
assign dirty_bits[268]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[12];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[268];invalid<=0;end
 end
end
end
if(1) begin:state_0_269
reg spin,invalid;
assign state_bits[269]=spin;
assign dirty_bits[269]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[13];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[269];invalid<=0;end
 end
end
end
if(1) begin:state_0_270
reg spin,invalid;
assign state_bits[270]=spin;
assign dirty_bits[270]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[14];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[270];invalid<=0;end
 end
end
end
if(1) begin:state_0_271
reg spin,invalid;
assign state_bits[271]=spin;
assign dirty_bits[271]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[15];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[271];invalid<=0;end
 end
end
end
if(1) begin:state_0_272
reg spin,invalid;
assign state_bits[272]=spin;
assign dirty_bits[272]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[16];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[272];invalid<=0;end
 end
end
end
if(1) begin:state_0_273
reg spin,invalid;
assign state_bits[273]=spin;
assign dirty_bits[273]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[17];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[273];invalid<=0;end
 end
end
end
if(1) begin:state_0_274
reg spin,invalid;
assign state_bits[274]=spin;
assign dirty_bits[274]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[18];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[274];invalid<=0;end
 end
end
end
if(1) begin:state_0_275
reg spin,invalid;
assign state_bits[275]=spin;
assign dirty_bits[275]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[19];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[275];invalid<=0;end
 end
end
end
if(1) begin:state_0_284
reg spin,invalid;
assign state_bits[284]=spin;
assign dirty_bits[284]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[28];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[284];invalid<=0;end
 end
end
end
if(1) begin:state_0_285
reg spin,invalid;
assign state_bits[285]=spin;
assign dirty_bits[285]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[29];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[285];invalid<=0;end
 end
end
end
if(1) begin:state_0_286
reg spin,invalid;
assign state_bits[286]=spin;
assign dirty_bits[286]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[30];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[286];invalid<=0;end
 end
end
end
if(1) begin:state_0_287
reg spin,invalid;
assign state_bits[287]=spin;
assign dirty_bits[287]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==8)spin<=data_in[31];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[287];invalid<=0;end
 end
end
end
