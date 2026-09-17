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
if(1) begin:state_0_36
reg spin,invalid;
assign state_bits[36]=spin;
assign dirty_bits[36]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[4];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[36];invalid<=0;end
 end
end
end
if(1) begin:state_0_37
reg spin,invalid;
assign state_bits[37]=spin;
assign dirty_bits[37]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[5];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[37];invalid<=0;end
 end
end
end
if(1) begin:state_0_38
reg spin,invalid;
assign state_bits[38]=spin;
assign dirty_bits[38]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[6];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[38];invalid<=0;end
 end
end
end
if(1) begin:state_0_39
reg spin,invalid;
assign state_bits[39]=spin;
assign dirty_bits[39]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[7];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[39];invalid<=0;end
 end
end
end
if(1) begin:state_0_40
reg spin,invalid;
assign state_bits[40]=spin;
assign dirty_bits[40]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[8];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[40];invalid<=0;end
 end
end
end
if(1) begin:state_0_41
reg spin,invalid;
assign state_bits[41]=spin;
assign dirty_bits[41]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[9];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[41];invalid<=0;end
 end
end
end
if(1) begin:state_0_42
reg spin,invalid;
assign state_bits[42]=spin;
assign dirty_bits[42]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[10];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[42];invalid<=0;end
 end
end
end
if(1) begin:state_0_43
reg spin,invalid;
assign state_bits[43]=spin;
assign dirty_bits[43]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[11];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[43];invalid<=0;end
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
if(1) begin:state_0_64
reg spin,invalid;
assign state_bits[64]=spin;
assign dirty_bits[64]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[0];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[64];invalid<=0;end
 end
end
end
if(1) begin:state_0_65
reg spin,invalid;
assign state_bits[65]=spin;
assign dirty_bits[65]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[1];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[65];invalid<=0;end
 end
end
end
if(1) begin:state_0_66
reg spin,invalid;
assign state_bits[66]=spin;
assign dirty_bits[66]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[2];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[66];invalid<=0;end
 end
end
end
if(1) begin:state_0_67
reg spin,invalid;
assign state_bits[67]=spin;
assign dirty_bits[67]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[3];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[67];invalid<=0;end
 end
end
end
if(1) begin:state_0_76
reg spin,invalid;
assign state_bits[76]=spin;
assign dirty_bits[76]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[12];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[76];invalid<=0;end
 end
end
end
if(1) begin:state_0_77
reg spin,invalid;
assign state_bits[77]=spin;
assign dirty_bits[77]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[13];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[77];invalid<=0;end
 end
end
end
if(1) begin:state_0_78
reg spin,invalid;
assign state_bits[78]=spin;
assign dirty_bits[78]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[14];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[78];invalid<=0;end
 end
end
end
if(1) begin:state_0_79
reg spin,invalid;
assign state_bits[79]=spin;
assign dirty_bits[79]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[15];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[79];invalid<=0;end
 end
end
end
if(1) begin:state_0_80
reg spin,invalid;
assign state_bits[80]=spin;
assign dirty_bits[80]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[16];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[80];invalid<=0;end
 end
end
end
if(1) begin:state_0_81
reg spin,invalid;
assign state_bits[81]=spin;
assign dirty_bits[81]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[17];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[81];invalid<=0;end
 end
end
end
if(1) begin:state_0_82
reg spin,invalid;
assign state_bits[82]=spin;
assign dirty_bits[82]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[18];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[82];invalid<=0;end
 end
end
end
if(1) begin:state_0_83
reg spin,invalid;
assign state_bits[83]=spin;
assign dirty_bits[83]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[19];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[83];invalid<=0;end
 end
end
end
if(1) begin:state_0_92
reg spin,invalid;
assign state_bits[92]=spin;
assign dirty_bits[92]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[28];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[92];invalid<=0;end
 end
end
end
if(1) begin:state_0_93
reg spin,invalid;
assign state_bits[93]=spin;
assign dirty_bits[93]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[29];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[93];invalid<=0;end
 end
end
end
if(1) begin:state_0_94
reg spin,invalid;
assign state_bits[94]=spin;
assign dirty_bits[94]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[30];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[94];invalid<=0;end
 end
end
end
if(1) begin:state_0_95
reg spin,invalid;
assign state_bits[95]=spin;
assign dirty_bits[95]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[31];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[95];invalid<=0;end
 end
end
end
if(1) begin:state_0_100
reg spin,invalid;
assign state_bits[100]=spin;
assign dirty_bits[100]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[4];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[100];invalid<=0;end
 end
end
end
if(1) begin:state_0_101
reg spin,invalid;
assign state_bits[101]=spin;
assign dirty_bits[101]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[5];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[101];invalid<=0;end
 end
end
end
if(1) begin:state_0_102
reg spin,invalid;
assign state_bits[102]=spin;
assign dirty_bits[102]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[6];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[102];invalid<=0;end
 end
end
end
if(1) begin:state_0_103
reg spin,invalid;
assign state_bits[103]=spin;
assign dirty_bits[103]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[7];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[103];invalid<=0;end
 end
end
end
if(1) begin:state_0_104
reg spin,invalid;
assign state_bits[104]=spin;
assign dirty_bits[104]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[8];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[104];invalid<=0;end
 end
end
end
if(1) begin:state_0_105
reg spin,invalid;
assign state_bits[105]=spin;
assign dirty_bits[105]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[9];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[105];invalid<=0;end
 end
end
end
if(1) begin:state_0_106
reg spin,invalid;
assign state_bits[106]=spin;
assign dirty_bits[106]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[10];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[106];invalid<=0;end
 end
end
end
if(1) begin:state_0_107
reg spin,invalid;
assign state_bits[107]=spin;
assign dirty_bits[107]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[11];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[107];invalid<=0;end
 end
end
end
if(1) begin:state_0_116
reg spin,invalid;
assign state_bits[116]=spin;
assign dirty_bits[116]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[20];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[116];invalid<=0;end
 end
end
end
if(1) begin:state_0_117
reg spin,invalid;
assign state_bits[117]=spin;
assign dirty_bits[117]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[21];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[117];invalid<=0;end
 end
end
end
if(1) begin:state_0_118
reg spin,invalid;
assign state_bits[118]=spin;
assign dirty_bits[118]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[22];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[118];invalid<=0;end
 end
end
end
if(1) begin:state_0_119
reg spin,invalid;
assign state_bits[119]=spin;
assign dirty_bits[119]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[23];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[119];invalid<=0;end
 end
end
end
if(1) begin:state_0_120
reg spin,invalid;
assign state_bits[120]=spin;
assign dirty_bits[120]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[24];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[120];invalid<=0;end
 end
end
end
if(1) begin:state_0_121
reg spin,invalid;
assign state_bits[121]=spin;
assign dirty_bits[121]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[25];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[121];invalid<=0;end
 end
end
end
if(1) begin:state_0_122
reg spin,invalid;
assign state_bits[122]=spin;
assign dirty_bits[122]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[26];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[122];invalid<=0;end
 end
end
end
if(1) begin:state_0_123
reg spin,invalid;
assign state_bits[123]=spin;
assign dirty_bits[123]=invalid;
always @(posedge spin_clk_0_0) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[27];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==0)begin spin<=update_bits[123];invalid<=0;end
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
if(1) begin:state_0_32
reg spin,invalid;
assign state_bits[32]=spin;
assign dirty_bits[32]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[0];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[32];invalid<=0;end
 end
end
end
if(1) begin:state_0_33
reg spin,invalid;
assign state_bits[33]=spin;
assign dirty_bits[33]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[1];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[33];invalid<=0;end
 end
end
end
if(1) begin:state_0_34
reg spin,invalid;
assign state_bits[34]=spin;
assign dirty_bits[34]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[2];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[34];invalid<=0;end
 end
end
end
if(1) begin:state_0_35
reg spin,invalid;
assign state_bits[35]=spin;
assign dirty_bits[35]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[3];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[35];invalid<=0;end
 end
end
end
if(1) begin:state_0_44
reg spin,invalid;
assign state_bits[44]=spin;
assign dirty_bits[44]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[12];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[44];invalid<=0;end
 end
end
end
if(1) begin:state_0_45
reg spin,invalid;
assign state_bits[45]=spin;
assign dirty_bits[45]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[13];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[45];invalid<=0;end
 end
end
end
if(1) begin:state_0_46
reg spin,invalid;
assign state_bits[46]=spin;
assign dirty_bits[46]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[14];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[46];invalid<=0;end
 end
end
end
if(1) begin:state_0_47
reg spin,invalid;
assign state_bits[47]=spin;
assign dirty_bits[47]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==1)spin<=data_in[15];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[47];invalid<=0;end
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
if(1) begin:state_0_68
reg spin,invalid;
assign state_bits[68]=spin;
assign dirty_bits[68]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[4];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[68];invalid<=0;end
 end
end
end
if(1) begin:state_0_69
reg spin,invalid;
assign state_bits[69]=spin;
assign dirty_bits[69]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[5];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[69];invalid<=0;end
 end
end
end
if(1) begin:state_0_70
reg spin,invalid;
assign state_bits[70]=spin;
assign dirty_bits[70]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[6];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[70];invalid<=0;end
 end
end
end
if(1) begin:state_0_71
reg spin,invalid;
assign state_bits[71]=spin;
assign dirty_bits[71]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[7];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[71];invalid<=0;end
 end
end
end
if(1) begin:state_0_72
reg spin,invalid;
assign state_bits[72]=spin;
assign dirty_bits[72]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[8];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[72];invalid<=0;end
 end
end
end
if(1) begin:state_0_73
reg spin,invalid;
assign state_bits[73]=spin;
assign dirty_bits[73]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[9];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[73];invalid<=0;end
 end
end
end
if(1) begin:state_0_74
reg spin,invalid;
assign state_bits[74]=spin;
assign dirty_bits[74]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[10];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[74];invalid<=0;end
 end
end
end
if(1) begin:state_0_75
reg spin,invalid;
assign state_bits[75]=spin;
assign dirty_bits[75]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[11];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[75];invalid<=0;end
 end
end
end
if(1) begin:state_0_84
reg spin,invalid;
assign state_bits[84]=spin;
assign dirty_bits[84]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[20];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[84];invalid<=0;end
 end
end
end
if(1) begin:state_0_85
reg spin,invalid;
assign state_bits[85]=spin;
assign dirty_bits[85]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[21];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[85];invalid<=0;end
 end
end
end
if(1) begin:state_0_86
reg spin,invalid;
assign state_bits[86]=spin;
assign dirty_bits[86]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[22];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[86];invalid<=0;end
 end
end
end
if(1) begin:state_0_87
reg spin,invalid;
assign state_bits[87]=spin;
assign dirty_bits[87]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[23];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[87];invalid<=0;end
 end
end
end
if(1) begin:state_0_88
reg spin,invalid;
assign state_bits[88]=spin;
assign dirty_bits[88]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[24];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[88];invalid<=0;end
 end
end
end
if(1) begin:state_0_89
reg spin,invalid;
assign state_bits[89]=spin;
assign dirty_bits[89]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[25];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[89];invalid<=0;end
 end
end
end
if(1) begin:state_0_90
reg spin,invalid;
assign state_bits[90]=spin;
assign dirty_bits[90]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[26];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[90];invalid<=0;end
 end
end
end
if(1) begin:state_0_91
reg spin,invalid;
assign state_bits[91]=spin;
assign dirty_bits[91]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==2)spin<=data_in[27];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[91];invalid<=0;end
 end
end
end
if(1) begin:state_0_96
reg spin,invalid;
assign state_bits[96]=spin;
assign dirty_bits[96]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[0];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[96];invalid<=0;end
 end
end
end
if(1) begin:state_0_97
reg spin,invalid;
assign state_bits[97]=spin;
assign dirty_bits[97]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[1];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[97];invalid<=0;end
 end
end
end
if(1) begin:state_0_98
reg spin,invalid;
assign state_bits[98]=spin;
assign dirty_bits[98]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[2];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[98];invalid<=0;end
 end
end
end
if(1) begin:state_0_99
reg spin,invalid;
assign state_bits[99]=spin;
assign dirty_bits[99]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[3];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[99];invalid<=0;end
 end
end
end
if(1) begin:state_0_108
reg spin,invalid;
assign state_bits[108]=spin;
assign dirty_bits[108]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[12];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[108];invalid<=0;end
 end
end
end
if(1) begin:state_0_109
reg spin,invalid;
assign state_bits[109]=spin;
assign dirty_bits[109]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[13];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[109];invalid<=0;end
 end
end
end
if(1) begin:state_0_110
reg spin,invalid;
assign state_bits[110]=spin;
assign dirty_bits[110]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[14];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[110];invalid<=0;end
 end
end
end
if(1) begin:state_0_111
reg spin,invalid;
assign state_bits[111]=spin;
assign dirty_bits[111]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[15];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[111];invalid<=0;end
 end
end
end
if(1) begin:state_0_112
reg spin,invalid;
assign state_bits[112]=spin;
assign dirty_bits[112]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[16];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[112];invalid<=0;end
 end
end
end
if(1) begin:state_0_113
reg spin,invalid;
assign state_bits[113]=spin;
assign dirty_bits[113]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[17];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[113];invalid<=0;end
 end
end
end
if(1) begin:state_0_114
reg spin,invalid;
assign state_bits[114]=spin;
assign dirty_bits[114]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[18];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[114];invalid<=0;end
 end
end
end
if(1) begin:state_0_115
reg spin,invalid;
assign state_bits[115]=spin;
assign dirty_bits[115]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[19];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[115];invalid<=0;end
 end
end
end
if(1) begin:state_0_124
reg spin,invalid;
assign state_bits[124]=spin;
assign dirty_bits[124]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[28];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[124];invalid<=0;end
 end
end
end
if(1) begin:state_0_125
reg spin,invalid;
assign state_bits[125]=spin;
assign dirty_bits[125]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[29];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[125];invalid<=0;end
 end
end
end
if(1) begin:state_0_126
reg spin,invalid;
assign state_bits[126]=spin;
assign dirty_bits[126]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[30];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[126];invalid<=0;end
 end
end
end
if(1) begin:state_0_127
reg spin,invalid;
assign state_bits[127]=spin;
assign dirty_bits[127]=invalid;
always @(posedge spin_clk_0_1) begin
 if(rst)begin spin<=0;invalid<=1;end
 else begin
  if(init_we&&phase==IDLE&&init_word==3)spin<=data_in[31];
  if(start_accept&&phase==IDLE)invalid<=1;
  if(local_commit&&replica==0&&color==1)begin spin<=update_bits[127];invalid<=0;end
 end
end
end
