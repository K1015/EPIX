// One field/score lane. Each replica and site owns its LFSR and history.
module a2_cluster_0 #(parameter EPIX=1)(
 input wire clk,rst,test_enable,active,score_active,accept,
 input wire seed_we,cfg_we,
 input wire [15:0] seed_addr,
 input wire [9:0] cfg_addr,
 input wire [31:0] data_in,
 input wire [5:0] context_id,beta,
 input wire [1:0] color,
 input wire [2:0] sweep_tag,
 input wire [9:0] beta_sweep,
 input wire [511:0] current,
 input wire [127:0] dirty,
 output reg [127:0] next_bits,
 output wire ready,configured,
 output reg [15:0] fresh_count,
 output reg signed [15:0] score_value);
 localparam N=512,L=128,R=1,BASE=0,FW=5,TW=2,AGE=2;
 localparam IDLE=0,SCAN=1,CALCULATE=2,DECIDE=3,SAMPLE=4,READY=5;
 reg [2:0] phase;
 reg [6:0] slot;
 reg scoring;
 reg signed [FW-1:0] raw_value;
 wire nonnegative=raw_value>=0;
 wire [15:0] magnitude=nonnegative ? 16'($signed(raw_value)) : 16'(-$signed(raw_value));
 function automatic [31:0] probability(input logic [7:0] address);
begin
case(address)
8'd0: probability=32'h80000000;
8'd1: probability=32'h8feacc96;
8'd2: probability=32'h9f597ea7;
8'd3: probability=32'haddea7bd;
8'd4: probability=32'hbb26a7af;
8'd5: probability=32'hc6fd1fab;
8'd6: probability=32'hd14c8f95;
8'd7: probability=32'hda19942e;
8'd8: probability=32'he17bead4;
8'd9: probability=32'he7972d6f;
8'd10: probability=32'hec948eee;
8'd11: probability=32'hf09e294b;
8'd12: probability=32'hf3dbe5e2;
8'd13: probability=32'hf671bec0;
8'd14: probability=32'hf87efe60;
8'd15: probability=32'hfa1e27b4;
8'd16: probability=32'hfb654178;
8'd17: probability=32'hfc66537e;
8'd18: probability=32'hfd2ff5b1;
8'd19: probability=32'hfdcdddad;
8'd20: probability=32'hfe496098;
8'd21: probability=32'hfea9e4d3;
8'd22: probability=32'hfef5426c;
8'd23: probability=32'hff301337;
8'd24: probability=32'hff5df444;
8'd25: probability=32'hff81bac2;
8'd26: probability=32'hff9d9e57;
8'd27: probability=32'hffb35ae0;
8'd28: probability=32'hffc44b19;
8'd29: probability=32'hffd17db5;
8'd30: probability=32'hffdbc5ea;
8'd31: probability=32'hffe3c873;
8'd32: probability=32'hffea05c2;
8'd33: probability=32'hffeee1f4;
8'd34: probability=32'hfff2ab10;
8'd35: probability=32'hfff59de2;
8'd36: probability=32'hfff7e9c8;
8'd37: probability=32'hfff9b3ab;
8'd38: probability=32'hfffb184a;
8'd39: probability=32'hfffc2e09;
8'd40: probability=32'hfffd065a;
8'd41: probability=32'hfffdaed2;
8'd42: probability=32'hfffe3207;
8'd43: probability=32'hfffe9837;
8'd44: probability=32'hfffee7cc;
8'd45: probability=32'hffff25c7;
8'd46: probability=32'hffff560c;
8'd47: probability=32'hffff7ba4;
8'd48: probability=32'hffff98eb;
8'd49: probability=32'hffffafb8;
8'd50: probability=32'hffffc17a;
8'd51: probability=32'hffffcf4f;
8'd52: probability=32'hffffda14;
8'd53: probability=32'hffffe277;
8'd54: probability=32'hffffe900;
8'd55: probability=32'hffffee16;
8'd56: probability=32'hfffff20d;
8'd57: probability=32'hfffff523;
8'd58: probability=32'hfffff78a;
8'd59: probability=32'hfffff969;
8'd60: probability=32'hfffffade;
8'd61: probability=32'hfffffc01;
8'd62: probability=32'hfffffce3;
8'd63: probability=32'hfffffd93;
8'd64: probability=32'hfffffe1d;
8'd65: probability=32'hfffffe88;
8'd66: probability=32'hfffffedb;
8'd67: probability=32'hffffff1c;
8'd68: probability=32'hffffff4e;
8'd69: probability=32'hffffff76;
8'd70: probability=32'hffffff94;
8'd71: probability=32'hffffffac;
8'd72: probability=32'hffffffbf;
8'd73: probability=32'hffffffcd;
8'd74: probability=32'hffffffd8;
8'd75: probability=32'hffffffe1;
8'd76: probability=32'hffffffe8;
8'd77: probability=32'hffffffed;
8'd78: probability=32'hfffffff1;
8'd79: probability=32'hfffffff5;
8'd80: probability=32'hfffffff7;
8'd81: probability=32'hfffffff9;
8'd82: probability=32'hfffffffb;
8'd83: probability=32'hfffffffc;
8'd84: probability=32'hffffffff;
8'd85: probability=32'hffffffff;
8'd86: probability=32'hffffffff;
8'd87: probability=32'hffffffff;
8'd88: probability=32'hffffffff;
8'd89: probability=32'hffffffff;
8'd90: probability=32'hffffffff;
8'd91: probability=32'hffffffff;
8'd92: probability=32'hffffffff;
8'd93: probability=32'hffffffff;
8'd94: probability=32'hffffffff;
8'd95: probability=32'hffffffff;
8'd96: probability=32'hffffffff;
8'd97: probability=32'hffffffff;
8'd98: probability=32'hffffffff;
8'd99: probability=32'hffffffff;
8'd100: probability=32'hffffffff;
8'd101: probability=32'hffffffff;
8'd102: probability=32'hffffffff;
8'd103: probability=32'hffffffff;
8'd104: probability=32'hffffffff;
8'd105: probability=32'hffffffff;
8'd106: probability=32'hffffffff;
8'd107: probability=32'hffffffff;
8'd108: probability=32'hffffffff;
8'd109: probability=32'hffffffff;
8'd110: probability=32'hffffffff;
8'd111: probability=32'hffffffff;
8'd112: probability=32'hffffffff;
8'd113: probability=32'hffffffff;
8'd114: probability=32'hffffffff;
8'd115: probability=32'hffffffff;
8'd116: probability=32'hffffffff;
8'd117: probability=32'hffffffff;
8'd118: probability=32'hffffffff;
8'd119: probability=32'hffffffff;
8'd120: probability=32'hffffffff;
8'd121: probability=32'hffffffff;
8'd122: probability=32'hffffffff;
8'd123: probability=32'hffffffff;
8'd124: probability=32'hffffffff;
8'd125: probability=32'hffffffff;
8'd126: probability=32'hffffffff;
8'd127: probability=32'hffffffff;
default: probability=32'hffffffff;
endcase
end
endfunction
 function automatic [7:0] neighbors(input [6:0] node,input [511:0] bits); begin case(node)
0: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[64],bits[6]};
1: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
2: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[66],bits[6]};
3: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
4: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
5: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
6: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[2],bits[0]};
7: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
8: neighbors={1'b0,1'b0,1'b0,bits[72],bits[15],bits[14],bits[13],bits[12]};
9: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[14],bits[12]};
10: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[14],bits[13],bits[12]};
11: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[75],bits[14]};
12: neighbors={1'b0,1'b0,1'b0,1'b0,bits[20],bits[10],bits[9],bits[8]};
13: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[21],bits[10],bits[8]};
14: neighbors={1'b0,1'b0,1'b0,1'b0,bits[11],bits[10],bits[9],bits[8]};
15: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[23],bits[8]};
16: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[23],bits[21]};
17: neighbors={1'b0,1'b0,1'b0,1'b0,bits[23],bits[22],bits[21],bits[20]};
18: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
19: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[22],bits[21],bits[20]};
20: neighbors={1'b0,1'b0,1'b0,1'b0,bits[28],bits[19],bits[17],bits[12]};
21: neighbors={1'b0,1'b0,1'b0,bits[29],bits[19],bits[17],bits[16],bits[13]};
22: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[19],bits[17]};
23: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[17],bits[16],bits[15]};
24: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
25: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
26: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[29]};
27: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[29],bits[28]};
28: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[27],bits[20]};
29: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[27],bits[26],bits[21]};
30: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
31: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
32: neighbors={1'b0,1'b0,1'b0,1'b0,bits[39],bits[38],bits[37],bits[36]};
33: neighbors={1'b0,1'b0,1'b0,1'b0,bits[97],bits[38],bits[37],bits[36]};
34: neighbors={1'b0,1'b0,1'b0,1'b0,bits[98],bits[39],bits[38],bits[36]};
35: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[39],bits[36]};
36: neighbors={1'b0,1'b0,1'b0,1'b0,bits[35],bits[34],bits[33],bits[32]};
37: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[33],bits[32]};
38: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[34],bits[33],bits[32]};
39: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[35],bits[34],bits[32]};
40: neighbors={1'b0,1'b0,1'b0,1'b0,bits[104],bits[47],bits[46],bits[44]};
41: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[47],bits[44]};
42: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[46],bits[45],bits[44]};
43: neighbors={1'b0,1'b0,1'b0,1'b0,bits[107],bits[47],bits[45],bits[44]};
44: neighbors={1'b0,1'b0,1'b0,1'b0,bits[43],bits[42],bits[41],bits[40]};
45: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[53],bits[43],bits[42]};
46: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[54],bits[42],bits[40]};
47: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[43],bits[41],bits[40]};
48: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[54],bits[52]};
49: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[54],bits[53],bits[52]};
50: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[55],bits[52]};
51: neighbors={1'b0,1'b0,1'b0,1'b0,bits[55],bits[54],bits[53],bits[52]};
52: neighbors={1'b0,1'b0,1'b0,1'b0,bits[51],bits[50],bits[49],bits[48]};
53: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[51],bits[49],bits[45]};
54: neighbors={1'b0,1'b0,1'b0,1'b0,bits[51],bits[49],bits[48],bits[46]};
55: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[51],bits[50]};
56: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[63],bits[62],bits[60]};
57: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[62],bits[60]};
58: neighbors={1'b0,1'b0,1'b0,1'b0,bits[63],bits[62],bits[61],bits[60]};
59: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[63],bits[61],bits[60]};
60: neighbors={1'b0,1'b0,1'b0,1'b0,bits[59],bits[58],bits[57],bits[56]};
61: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[59],bits[58]};
62: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[58],bits[57],bits[56]};
63: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[59],bits[58],bits[56]};
64: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[69],bits[68],bits[0]};
65: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
66: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[69],bits[2]};
67: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
68: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[64]};
69: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[66],bits[64]};
70: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
71: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
72: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[79],bits[8]};
73: neighbors={1'b0,1'b0,1'b0,1'b0,bits[137],bits[79],bits[77],bits[76]};
74: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[138],bits[79],bits[77]};
75: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[79],bits[76],bits[11]};
76: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[75],bits[73]};
77: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[74],bits[73]};
78: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
79: neighbors={1'b0,1'b0,1'b0,1'b0,bits[75],bits[74],bits[73],bits[72]};
80: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[87],bits[84]};
81: neighbors={1'b0,1'b0,1'b0,1'b0,bits[87],bits[86],bits[85],bits[84]};
82: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[87],bits[86]};
83: neighbors={1'b0,1'b0,1'b0,1'b0,bits[87],bits[86],bits[85],bits[84]};
84: neighbors={1'b0,1'b0,1'b0,1'b0,bits[92],bits[83],bits[81],bits[80]};
85: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[83],bits[81]};
86: neighbors={1'b0,1'b0,1'b0,1'b0,bits[94],bits[83],bits[82],bits[81]};
87: neighbors={1'b0,1'b0,1'b0,1'b0,bits[83],bits[82],bits[81],bits[80]};
88: neighbors={1'b0,1'b0,1'b0,1'b0,bits[95],bits[94],bits[93],bits[92]};
89: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
90: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[95],bits[94],bits[92]};
91: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[93],bits[92]};
92: neighbors={1'b0,1'b0,1'b0,1'b0,bits[91],bits[90],bits[88],bits[84]};
93: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[91],bits[88]};
94: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[90],bits[88],bits[86]};
95: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[90],bits[88]};
96: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
97: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[102],bits[33]};
98: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[102],bits[34]};
99: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
100: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
101: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
102: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[98],bits[97]};
103: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
104: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[168],bits[109],bits[40]};
105: neighbors={1'b0,1'b0,1'b0,1'b0,bits[111],bits[110],bits[109],bits[108]};
106: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[170],bits[108]};
107: neighbors={1'b0,1'b0,1'b0,1'b0,bits[111],bits[110],bits[108],bits[43]};
108: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[107],bits[106],bits[105]};
109: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[105],bits[104]};
110: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[107],bits[105]};
111: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[107],bits[105]};
112: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[176],bits[119],bits[116]};
113: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
114: neighbors={1'b0,1'b0,1'b0,1'b0,bits[178],bits[119],bits[117],bits[116]};
115: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[119],bits[117]};
116: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[114],bits[112]};
117: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[115],bits[114]};
118: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
119: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[115],bits[114],bits[112]};
120: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
121: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
122: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
123: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
124: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
125: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
126: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
127: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
default: neighbors=0;endcase end endfunction
function automatic [7:0] present(input [6:0] node); begin case(node)
0: present=8'd3;
1: present=8'd0;
2: present=8'd3;
3: present=8'd0;
4: present=8'd0;
5: present=8'd0;
6: present=8'd3;
7: present=8'd0;
8: present=8'd31;
9: present=8'd3;
10: present=8'd7;
11: present=8'd3;
12: present=8'd15;
13: present=8'd7;
14: present=8'd15;
15: present=8'd3;
16: present=8'd3;
17: present=8'd15;
18: present=8'd0;
19: present=8'd7;
20: present=8'd15;
21: present=8'd31;
22: present=8'd3;
23: present=8'd7;
24: present=8'd0;
25: present=8'd0;
26: present=8'd1;
27: present=8'd3;
28: present=8'd3;
29: present=8'd7;
30: present=8'd0;
31: present=8'd0;
32: present=8'd15;
33: present=8'd15;
34: present=8'd15;
35: present=8'd3;
36: present=8'd15;
37: present=8'd3;
38: present=8'd7;
39: present=8'd7;
40: present=8'd15;
41: present=8'd3;
42: present=8'd7;
43: present=8'd15;
44: present=8'd15;
45: present=8'd7;
46: present=8'd7;
47: present=8'd7;
48: present=8'd3;
49: present=8'd7;
50: present=8'd3;
51: present=8'd15;
52: present=8'd15;
53: present=8'd7;
54: present=8'd15;
55: present=8'd3;
56: present=8'd7;
57: present=8'd3;
58: present=8'd15;
59: present=8'd7;
60: present=8'd15;
61: present=8'd3;
62: present=8'd7;
63: present=8'd7;
64: present=8'd7;
65: present=8'd0;
66: present=8'd3;
67: present=8'd0;
68: present=8'd1;
69: present=8'd3;
70: present=8'd0;
71: present=8'd0;
72: present=8'd3;
73: present=8'd15;
74: present=8'd7;
75: present=8'd7;
76: present=8'd3;
77: present=8'd3;
78: present=8'd0;
79: present=8'd15;
80: present=8'd3;
81: present=8'd15;
82: present=8'd3;
83: present=8'd15;
84: present=8'd15;
85: present=8'd3;
86: present=8'd15;
87: present=8'd15;
88: present=8'd15;
89: present=8'd0;
90: present=8'd7;
91: present=8'd3;
92: present=8'd15;
93: present=8'd3;
94: present=8'd7;
95: present=8'd3;
96: present=8'd0;
97: present=8'd3;
98: present=8'd3;
99: present=8'd0;
100: present=8'd0;
101: present=8'd0;
102: present=8'd3;
103: present=8'd0;
104: present=8'd7;
105: present=8'd15;
106: present=8'd3;
107: present=8'd15;
108: present=8'd7;
109: present=8'd3;
110: present=8'd3;
111: present=8'd3;
112: present=8'd7;
113: present=8'd0;
114: present=8'd15;
115: present=8'd3;
116: present=8'd3;
117: present=8'd3;
118: present=8'd0;
119: present=8'd7;
120: present=8'd0;
121: present=8'd0;
122: present=8'd0;
123: present=8'd0;
124: present=8'd0;
125: present=8'd0;
126: present=8'd0;
127: present=8'd0;
default: present=0;endcase end endfunction
function automatic [7:0] forward(input [6:0] node); begin case(node)
0: forward=8'd3;
1: forward=8'd0;
2: forward=8'd3;
3: forward=8'd0;
4: forward=8'd0;
5: forward=8'd0;
6: forward=8'd0;
7: forward=8'd0;
8: forward=8'd31;
9: forward=8'd3;
10: forward=8'd7;
11: forward=8'd3;
12: forward=8'd8;
13: forward=8'd4;
14: forward=8'd0;
15: forward=8'd2;
16: forward=8'd3;
17: forward=8'd15;
18: forward=8'd0;
19: forward=8'd7;
20: forward=8'd8;
21: forward=8'd16;
22: forward=8'd0;
23: forward=8'd0;
24: forward=8'd0;
25: forward=8'd0;
26: forward=8'd1;
27: forward=8'd3;
28: forward=8'd0;
29: forward=8'd0;
30: forward=8'd0;
31: forward=8'd0;
32: forward=8'd15;
33: forward=8'd15;
34: forward=8'd15;
35: forward=8'd3;
36: forward=8'd0;
37: forward=8'd0;
38: forward=8'd0;
39: forward=8'd0;
40: forward=8'd15;
41: forward=8'd3;
42: forward=8'd7;
43: forward=8'd15;
44: forward=8'd0;
45: forward=8'd4;
46: forward=8'd4;
47: forward=8'd0;
48: forward=8'd3;
49: forward=8'd7;
50: forward=8'd3;
51: forward=8'd15;
52: forward=8'd0;
53: forward=8'd0;
54: forward=8'd0;
55: forward=8'd0;
56: forward=8'd7;
57: forward=8'd3;
58: forward=8'd15;
59: forward=8'd7;
60: forward=8'd0;
61: forward=8'd0;
62: forward=8'd0;
63: forward=8'd0;
64: forward=8'd6;
65: forward=8'd0;
66: forward=8'd2;
67: forward=8'd0;
68: forward=8'd0;
69: forward=8'd0;
70: forward=8'd0;
71: forward=8'd0;
72: forward=8'd2;
73: forward=8'd15;
74: forward=8'd7;
75: forward=8'd6;
76: forward=8'd0;
77: forward=8'd0;
78: forward=8'd0;
79: forward=8'd0;
80: forward=8'd3;
81: forward=8'd15;
82: forward=8'd3;
83: forward=8'd15;
84: forward=8'd8;
85: forward=8'd0;
86: forward=8'd8;
87: forward=8'd0;
88: forward=8'd15;
89: forward=8'd0;
90: forward=8'd7;
91: forward=8'd3;
92: forward=8'd0;
93: forward=8'd0;
94: forward=8'd0;
95: forward=8'd0;
96: forward=8'd0;
97: forward=8'd2;
98: forward=8'd2;
99: forward=8'd0;
100: forward=8'd0;
101: forward=8'd0;
102: forward=8'd0;
103: forward=8'd0;
104: forward=8'd6;
105: forward=8'd15;
106: forward=8'd3;
107: forward=8'd14;
108: forward=8'd0;
109: forward=8'd0;
110: forward=8'd0;
111: forward=8'd0;
112: forward=8'd7;
113: forward=8'd0;
114: forward=8'd15;
115: forward=8'd3;
116: forward=8'd0;
117: forward=8'd0;
118: forward=8'd0;
119: forward=8'd0;
120: forward=8'd0;
121: forward=8'd0;
122: forward=8'd0;
123: forward=8'd0;
124: forward=8'd0;
125: forward=8'd0;
126: forward=8'd0;
127: forward=8'd0;
default: forward=0;endcase end endfunction
function automatic [1:0] node_color(input [6:0] node); begin case(node)
0: node_color=2'd0;
1: node_color=2'd0;
2: node_color=2'd0;
3: node_color=2'd0;
4: node_color=2'd1;
5: node_color=2'd1;
6: node_color=2'd1;
7: node_color=2'd1;
8: node_color=2'd1;
9: node_color=2'd1;
10: node_color=2'd1;
11: node_color=2'd1;
12: node_color=2'd0;
13: node_color=2'd0;
14: node_color=2'd0;
15: node_color=2'd0;
16: node_color=2'd0;
17: node_color=2'd0;
18: node_color=2'd0;
19: node_color=2'd0;
20: node_color=2'd1;
21: node_color=2'd1;
22: node_color=2'd1;
23: node_color=2'd1;
24: node_color=2'd1;
25: node_color=2'd1;
26: node_color=2'd1;
27: node_color=2'd1;
28: node_color=2'd0;
29: node_color=2'd0;
30: node_color=2'd0;
31: node_color=2'd0;
32: node_color=2'd0;
33: node_color=2'd0;
34: node_color=2'd0;
35: node_color=2'd0;
36: node_color=2'd1;
37: node_color=2'd1;
38: node_color=2'd1;
39: node_color=2'd1;
40: node_color=2'd1;
41: node_color=2'd1;
42: node_color=2'd1;
43: node_color=2'd1;
44: node_color=2'd0;
45: node_color=2'd0;
46: node_color=2'd0;
47: node_color=2'd0;
48: node_color=2'd0;
49: node_color=2'd0;
50: node_color=2'd0;
51: node_color=2'd0;
52: node_color=2'd1;
53: node_color=2'd1;
54: node_color=2'd1;
55: node_color=2'd1;
56: node_color=2'd1;
57: node_color=2'd1;
58: node_color=2'd1;
59: node_color=2'd1;
60: node_color=2'd0;
61: node_color=2'd0;
62: node_color=2'd0;
63: node_color=2'd0;
64: node_color=2'd1;
65: node_color=2'd1;
66: node_color=2'd1;
67: node_color=2'd1;
68: node_color=2'd0;
69: node_color=2'd0;
70: node_color=2'd0;
71: node_color=2'd0;
72: node_color=2'd0;
73: node_color=2'd0;
74: node_color=2'd0;
75: node_color=2'd0;
76: node_color=2'd1;
77: node_color=2'd1;
78: node_color=2'd1;
79: node_color=2'd1;
80: node_color=2'd1;
81: node_color=2'd1;
82: node_color=2'd1;
83: node_color=2'd1;
84: node_color=2'd0;
85: node_color=2'd0;
86: node_color=2'd0;
87: node_color=2'd0;
88: node_color=2'd0;
89: node_color=2'd0;
90: node_color=2'd0;
91: node_color=2'd0;
92: node_color=2'd1;
93: node_color=2'd1;
94: node_color=2'd1;
95: node_color=2'd1;
96: node_color=2'd1;
97: node_color=2'd1;
98: node_color=2'd1;
99: node_color=2'd1;
100: node_color=2'd0;
101: node_color=2'd0;
102: node_color=2'd0;
103: node_color=2'd0;
104: node_color=2'd0;
105: node_color=2'd0;
106: node_color=2'd0;
107: node_color=2'd0;
108: node_color=2'd1;
109: node_color=2'd1;
110: node_color=2'd1;
111: node_color=2'd1;
112: node_color=2'd1;
113: node_color=2'd1;
114: node_color=2'd1;
115: node_color=2'd1;
116: node_color=2'd0;
117: node_color=2'd0;
118: node_color=2'd0;
119: node_color=2'd0;
120: node_color=2'd0;
121: node_color=2'd0;
122: node_color=2'd0;
123: node_color=2'd0;
124: node_color=2'd1;
125: node_color=2'd1;
126: node_color=2'd1;
127: node_color=2'd1;
default: node_color=0;endcase end endfunction

 wire [31:0] threshold=probability(8'((magnitude*beta*4+2)/4>127 ? 127 : (magnitude*beta*4+2)/4));
 wire selected=node_color(slot)==color;
 wire configured_write=cfg_we && cfg_addr>=BASE && cfg_addr<BASE+L;
 reg [L-1:0] loaded;
 wire configuration_clock,controller_clock;
 sky130_fd_sc_hd__dlclkp_1 configuration_gate(.CLK(clk),.GATE(rst||test_enable||configured_write),.GCLK(configuration_clock));
 sky130_fd_sc_hd__dlclkp_1 controller_gate(.CLK(clk),.GATE(rst||test_enable||active||score_active||(phase!=IDLE)),.GCLK(controller_clock));
 always @(posedge configuration_clock) begin
   if(rst) loaded<=0;
   else if(configured_write) loaded[7'(cfg_addr-BASE)]<=1'b1;
 end
 assign configured=&loaded;
 wire [39:0] coefficients;
 wire read_coeff=(phase==SCAN)&&(scoring||selected);
 a2_coefficient_memory #(.WORDS(128)) coefficient_memory(
   .clk(clk),.access(configured_write||read_coeff),
   .write_enable(configured_write),
   .address(configured_write ? 8'(cfg_addr-BASE) : {1'b0,slot}),
   .write_data({8'b0,data_in}),.mask(2'b11),.read_data(coefficients));
 wire [7:0] neighbor_bits=neighbors(slot,current);
 wire [7:0] edge_present=present(slot),edge_forward=forward(slot);
 reg signed [15:0] field_sum,row_cut;
 reg signed [15:0] weight;
 always_comb begin
   field_sum=0;row_cut=0;weight=0;
   // Run field arithmetic only after a coefficient read.
   if(phase==CALCULATE) for(integer e=0;e<8;e=e+1) begin
     weight={{12{coefficients[4*e+3]}},coefficients[4*e+:4]};
     if(edge_present[e]) begin
       if(!scoring)field_sum=field_sum+(neighbor_bits[e] ? -weight : weight);
       if(scoring&&edge_forward[e]&&(current[BASE+slot]!=neighbor_bits[e])) row_cut=row_cut+weight;
     end
   end
 end
 wire [31:0] retained [0:R*L-1];
 wire signed [FW-1:0] fields [0:R*L-1];
 wire [TW-1:0] tags [0:R*L-1];
 localparam CW=$clog2(R*L+1);
 wire [CW-1:0] address=CW'(context_id*L+slot);
 wire [TW-1:0] age=TW'(sweep_tag)-tags[address];
 wire signed [FW-1:0] saved_raw=fields[address];
 wire [5:0] saved_beta=beta-6'((beta>1)&&(beta_sweep<age));
 wire changed=16'($signed(saved_raw))*16'($signed({1'b0,saved_beta}))!=16'($signed(raw_value))*16'($signed({1'b0,beta}));
 wire refresh=!EPIX||dirty[slot]||(age>AGE)||current[BASE+slot]!=nonnegative||changed;
 // Each replica and p-bit has separate LFSR state and feedback logic.
 for(genvar r=0;r<R;r=r+1) begin:replica_bank
   wire replica_clock;
   wire seed_replica=seed_we&&(seed_addr>=r*N+BASE)&&(seed_addr<r*N+BASE+L);
   wire fresh_replica=(phase==SAMPLE)&&(context_id==r);
   // Stop the clock upstream of inactive replicas.
   sky130_fd_sc_hd__dlclkp_1 replica_gate(.CLK(clk),
     .GATE(rst||test_enable||seed_replica||fresh_replica),.GCLK(replica_clock));
   for(genvar i=0;i<L;i=i+1) begin:site_bank
     wire seeded=seed_we&&(seed_addr==r*N+BASE+i);
     wire consume=(phase==SAMPLE)&&(context_id==r)&&(slot==i);
     wire rng_clock;
     reg [31:0] state;
     function automatic [31:0] advance(input [31:0] x0);
       reg [31:0] x;
       begin
         x=x0;
         for(integer k=0;k<32;k=k+1)x={x[30:0],~(x[31]^x[21]^x[1]^x[0])};
         advance=x;
       end
     endfunction
     // Holding LFSR state also holds its feedback logic. Keep consume out of this path.
     wire [31:0] evolved=advance(state);
     sky130_fd_sc_hd__dlclkp_1 gate(.CLK(replica_clock),.GATE(rst||test_enable||seeded||consume),.GCLK(rng_clock));
     always @(posedge rng_clock) begin
       if(rst) state<=0;
       else if(seeded) state<=(data_in==32'hffffffff)?32'b0:data_in;
       else if(consume) state<=evolved;
     end
     // SAMPLE reads the next random word. Reuse holds the spin.
     assign retained[r*L+i]=evolved;
     if(EPIX) begin:metadata
       reg signed [FW-1:0] saved_field;
       reg [TW-1:0] saved_tag;
       always @(posedge rng_clock) begin
         if(rst)begin saved_field<=0;saved_tag<=0;end
         else if(consume)begin saved_field<=raw_value;saved_tag<=TW'(sweep_tag);end
       end
       assign fields[r*L+i]=saved_field;
       assign tags[r*L+i]=saved_tag;
     end else begin
       assign fields[r*L+i]=0;
       assign tags[r*L+i]=0;
     end
   end
 end
 // Save the RNG address one cycle before a fresh sample. Hold it during reuse.
 reg [CW-1:0] rng_address;
 wire rng_address_clock;
 wire fresh_request=(phase==DECIDE)&&refresh;
 sky130_fd_sc_hd__dlclkp_1 rng_address_gate(.CLK(clk),
   .GATE(rst||test_enable||fresh_request),.GCLK(rng_address_clock));
 always @(posedge rng_address_clock) begin
   if(rst)rng_address<=0;
   else if(fresh_request)rng_address<=address;
 end
 wire [31:0] random_word=retained[rng_address];
`ifndef SYNTHESIS
 always @(posedge clk) if(!rst&&phase==SAMPLE)
   assert(rng_address==address) else $fatal(1,"RNG read address mismatch");
`endif
 wire sampled_bit=nonnegative ? threshold>random_word : random_word>threshold;
 assign ready=phase==READY;
 task automatic next_site;
   begin
     if(slot==L-1)phase<=READY;
     else begin slot<=slot+1'b1;phase<=SCAN;end
   end
 endtask
 // Clock each data bank only when needed.
 wire begin_operation=(phase==IDLE)&&(active||score_active);
 wire raw_write=(phase==CALCULATE)&&!scoring;
 wire score_write=((phase==CALCULATE)&&scoring)||
                  ((phase==SAMPLE)&&(sampled_bit!=current[BASE+slot]));
 wire raw_clock,count_clock,score_clock;
 sky130_fd_sc_hd__dlclkp_1 raw_gate(.CLK(clk),
   .GATE(rst||test_enable||raw_write),.GCLK(raw_clock));
 sky130_fd_sc_hd__dlclkp_1 count_gate(.CLK(clk),
   .GATE(rst||test_enable||begin_operation||(phase==SAMPLE)),.GCLK(count_clock));
 sky130_fd_sc_hd__dlclkp_1 score_gate(.CLK(clk),
   .GATE(rst||test_enable||begin_operation||score_write),.GCLK(score_clock));
 always @(posedge raw_clock) begin
   if(rst)raw_value<=0;
   else if(raw_write)raw_value<=FW'(field_sum);
 end
 always @(posedge count_clock) begin
   if(rst||begin_operation)fresh_count<=0;
   else if(phase==SAMPLE)fresh_count<=fresh_count+1'b1;
 end
 always @(posedge score_clock) begin
   if(rst||begin_operation)score_value<=0;
   else if((phase==CALCULATE)&&scoring)score_value<=score_value+row_cut;
   else if((phase==SAMPLE)&&(sampled_bit!=current[BASE+slot]))
     score_value<=score_value+(current[BASE+slot] ? -16'($signed(raw_value)) : 16'($signed(raw_value)));
 end
 // Eight result bits share one gate. Clock only the selected group.
 for(genvar group=0;group<(L+7)/8;group=group+1)begin:result_group
   wire result_clock;
   wire result_write=(phase==SAMPLE)&&(slot>=group*8)&&(slot<group*8+8);
   sky130_fd_sc_hd__dlclkp_1 gate(.CLK(clk),
     .GATE(rst||test_enable||begin_operation||result_write),.GCLK(result_clock));
   for(genvar bit_index=group*8;bit_index<L&&bit_index<group*8+8;bit_index=bit_index+1)begin:bit_bank
     always @(posedge result_clock)begin
       if(rst)next_bits[bit_index]<=0;
       else if(begin_operation)next_bits[bit_index]<=current[BASE+bit_index];
       else if((phase==SAMPLE)&&(slot==bit_index))next_bits[bit_index]<=sampled_bit;
     end
   end
 end
 always @(posedge controller_clock) begin
   if(rst)begin phase<=IDLE;slot<=0;scoring<=0;end
   else case(phase)
     IDLE:if(active||score_active)begin
       slot<=0;scoring<=score_active;phase<=SCAN;
     end
     SCAN:if(scoring||selected)phase<=CALCULATE;else next_site();
     CALCULATE:if(scoring)next_site();else phase<=DECIDE;
     DECIDE:if(refresh)phase<=SAMPLE;else next_site();
     SAMPLE:next_site();
     READY:if(accept)phase<=IDLE;
     default:phase<=IDLE;
   endcase
 end
`ifndef SYNTHESIS
 always @(posedge clk) if(!rst) begin
   if(active||score_active) assert(configured) else $fatal(1,"A2 coefficients not loaded");
   if(phase==CALCULATE&&!scoring) assert(field_sum>=-10 && field_sum<=10)
     else $fatal(1,"A2 field exceeds configured bound");
   if(active) assert(context_id<R) else $fatal(1,"A2 replica out of range");
 end
`endif
endmodule

// One field/score lane. Each replica and site owns its LFSR and history.
module a2_cluster_128 #(parameter EPIX=1)(
 input wire clk,rst,test_enable,active,score_active,accept,
 input wire seed_we,cfg_we,
 input wire [15:0] seed_addr,
 input wire [9:0] cfg_addr,
 input wire [31:0] data_in,
 input wire [5:0] context_id,beta,
 input wire [1:0] color,
 input wire [2:0] sweep_tag,
 input wire [9:0] beta_sweep,
 input wire [511:0] current,
 input wire [127:0] dirty,
 output reg [127:0] next_bits,
 output wire ready,configured,
 output reg [15:0] fresh_count,
 output reg signed [15:0] score_value);
 localparam N=512,L=128,R=1,BASE=128,FW=5,TW=2,AGE=2;
 localparam IDLE=0,SCAN=1,CALCULATE=2,DECIDE=3,SAMPLE=4,READY=5;
 reg [2:0] phase;
 reg [6:0] slot;
 reg scoring;
 reg signed [FW-1:0] raw_value;
 wire nonnegative=raw_value>=0;
 wire [15:0] magnitude=nonnegative ? 16'($signed(raw_value)) : 16'(-$signed(raw_value));
 function automatic [31:0] probability(input logic [7:0] address);
begin
case(address)
8'd0: probability=32'h80000000;
8'd1: probability=32'h8feacc96;
8'd2: probability=32'h9f597ea7;
8'd3: probability=32'haddea7bd;
8'd4: probability=32'hbb26a7af;
8'd5: probability=32'hc6fd1fab;
8'd6: probability=32'hd14c8f95;
8'd7: probability=32'hda19942e;
8'd8: probability=32'he17bead4;
8'd9: probability=32'he7972d6f;
8'd10: probability=32'hec948eee;
8'd11: probability=32'hf09e294b;
8'd12: probability=32'hf3dbe5e2;
8'd13: probability=32'hf671bec0;
8'd14: probability=32'hf87efe60;
8'd15: probability=32'hfa1e27b4;
8'd16: probability=32'hfb654178;
8'd17: probability=32'hfc66537e;
8'd18: probability=32'hfd2ff5b1;
8'd19: probability=32'hfdcdddad;
8'd20: probability=32'hfe496098;
8'd21: probability=32'hfea9e4d3;
8'd22: probability=32'hfef5426c;
8'd23: probability=32'hff301337;
8'd24: probability=32'hff5df444;
8'd25: probability=32'hff81bac2;
8'd26: probability=32'hff9d9e57;
8'd27: probability=32'hffb35ae0;
8'd28: probability=32'hffc44b19;
8'd29: probability=32'hffd17db5;
8'd30: probability=32'hffdbc5ea;
8'd31: probability=32'hffe3c873;
8'd32: probability=32'hffea05c2;
8'd33: probability=32'hffeee1f4;
8'd34: probability=32'hfff2ab10;
8'd35: probability=32'hfff59de2;
8'd36: probability=32'hfff7e9c8;
8'd37: probability=32'hfff9b3ab;
8'd38: probability=32'hfffb184a;
8'd39: probability=32'hfffc2e09;
8'd40: probability=32'hfffd065a;
8'd41: probability=32'hfffdaed2;
8'd42: probability=32'hfffe3207;
8'd43: probability=32'hfffe9837;
8'd44: probability=32'hfffee7cc;
8'd45: probability=32'hffff25c7;
8'd46: probability=32'hffff560c;
8'd47: probability=32'hffff7ba4;
8'd48: probability=32'hffff98eb;
8'd49: probability=32'hffffafb8;
8'd50: probability=32'hffffc17a;
8'd51: probability=32'hffffcf4f;
8'd52: probability=32'hffffda14;
8'd53: probability=32'hffffe277;
8'd54: probability=32'hffffe900;
8'd55: probability=32'hffffee16;
8'd56: probability=32'hfffff20d;
8'd57: probability=32'hfffff523;
8'd58: probability=32'hfffff78a;
8'd59: probability=32'hfffff969;
8'd60: probability=32'hfffffade;
8'd61: probability=32'hfffffc01;
8'd62: probability=32'hfffffce3;
8'd63: probability=32'hfffffd93;
8'd64: probability=32'hfffffe1d;
8'd65: probability=32'hfffffe88;
8'd66: probability=32'hfffffedb;
8'd67: probability=32'hffffff1c;
8'd68: probability=32'hffffff4e;
8'd69: probability=32'hffffff76;
8'd70: probability=32'hffffff94;
8'd71: probability=32'hffffffac;
8'd72: probability=32'hffffffbf;
8'd73: probability=32'hffffffcd;
8'd74: probability=32'hffffffd8;
8'd75: probability=32'hffffffe1;
8'd76: probability=32'hffffffe8;
8'd77: probability=32'hffffffed;
8'd78: probability=32'hfffffff1;
8'd79: probability=32'hfffffff5;
8'd80: probability=32'hfffffff7;
8'd81: probability=32'hfffffff9;
8'd82: probability=32'hfffffffb;
8'd83: probability=32'hfffffffc;
8'd84: probability=32'hffffffff;
8'd85: probability=32'hffffffff;
8'd86: probability=32'hffffffff;
8'd87: probability=32'hffffffff;
8'd88: probability=32'hffffffff;
8'd89: probability=32'hffffffff;
8'd90: probability=32'hffffffff;
8'd91: probability=32'hffffffff;
8'd92: probability=32'hffffffff;
8'd93: probability=32'hffffffff;
8'd94: probability=32'hffffffff;
8'd95: probability=32'hffffffff;
8'd96: probability=32'hffffffff;
8'd97: probability=32'hffffffff;
8'd98: probability=32'hffffffff;
8'd99: probability=32'hffffffff;
8'd100: probability=32'hffffffff;
8'd101: probability=32'hffffffff;
8'd102: probability=32'hffffffff;
8'd103: probability=32'hffffffff;
8'd104: probability=32'hffffffff;
8'd105: probability=32'hffffffff;
8'd106: probability=32'hffffffff;
8'd107: probability=32'hffffffff;
8'd108: probability=32'hffffffff;
8'd109: probability=32'hffffffff;
8'd110: probability=32'hffffffff;
8'd111: probability=32'hffffffff;
8'd112: probability=32'hffffffff;
8'd113: probability=32'hffffffff;
8'd114: probability=32'hffffffff;
8'd115: probability=32'hffffffff;
8'd116: probability=32'hffffffff;
8'd117: probability=32'hffffffff;
8'd118: probability=32'hffffffff;
8'd119: probability=32'hffffffff;
8'd120: probability=32'hffffffff;
8'd121: probability=32'hffffffff;
8'd122: probability=32'hffffffff;
8'd123: probability=32'hffffffff;
8'd124: probability=32'hffffffff;
8'd125: probability=32'hffffffff;
8'd126: probability=32'hffffffff;
8'd127: probability=32'hffffffff;
default: probability=32'hffffffff;
endcase
end
endfunction
 function automatic [7:0] neighbors(input [6:0] node,input [511:0] bits); begin case(node)
0: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[134],bits[132]};
1: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[133],bits[132]};
2: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[132]};
3: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[134],bits[133]};
4: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[130],bits[129],bits[128]};
5: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[131],bits[129]};
6: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[131],bits[128]};
7: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
8: neighbors={1'b0,1'b0,1'b0,1'b0,bits[200],bits[143],bits[142],bits[140]};
9: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[143],bits[141],bits[73]};
10: neighbors={1'b0,1'b0,1'b0,1'b0,bits[143],bits[142],bits[140],bits[74]};
11: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[143],bits[140]};
12: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[139],bits[138],bits[136]};
13: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[137]};
14: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[150],bits[138],bits[136]};
15: neighbors={1'b0,1'b0,1'b0,1'b0,bits[139],bits[138],bits[137],bits[136]};
16: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[150],bits[149]};
17: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[151],bits[150],bits[149]};
18: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[210],bits[151],bits[150]};
19: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
20: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
21: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[145],bits[144]};
22: neighbors={1'b0,1'b0,1'b0,1'b0,bits[146],bits[145],bits[144],bits[142]};
23: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[146],bits[145]};
24: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[157],bits[156]};
25: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[217],bits[159]};
26: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[218],bits[156]};
27: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[157],bits[156]};
28: neighbors={1'b0,1'b0,1'b0,1'b0,bits[164],bits[155],bits[154],bits[152]};
29: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[165],bits[155],bits[152]};
30: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
31: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[167],bits[153]};
32: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
33: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[167],bits[165]};
34: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
35: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[165],bits[164]};
36: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[163],bits[156]};
37: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[163],bits[161],bits[157]};
38: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
39: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[161],bits[159]};
40: neighbors={1'b0,1'b0,1'b0,1'b0,bits[175],bits[174],bits[173],bits[104]};
41: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[175],bits[174]};
42: neighbors={1'b0,1'b0,1'b0,1'b0,bits[175],bits[174],bits[172],bits[106]};
43: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[173],bits[172]};
44: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[171],bits[170]};
45: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[171],bits[168]};
46: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[170],bits[169],bits[168]};
47: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[170],bits[169],bits[168]};
48: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[181],bits[180],bits[112]};
49: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[181],bits[180]};
50: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[182],bits[181],bits[114]};
51: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[182],bits[181]};
52: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[177],bits[176]};
53: neighbors={1'b0,1'b0,1'b0,bits[189],bits[179],bits[178],bits[177],bits[176]};
54: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[190],bits[179],bits[178]};
55: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
56: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
57: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[190],bits[189]};
58: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[191],bits[189]};
59: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[191],bits[189]};
60: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
61: neighbors={1'b0,1'b0,1'b0,1'b0,bits[187],bits[186],bits[185],bits[181]};
62: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[185],bits[182]};
63: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[187],bits[186]};
64: neighbors={1'b0,1'b0,1'b0,1'b0,bits[256],bits[198],bits[197],bits[196]};
65: neighbors={1'b0,1'b0,1'b0,bits[257],bits[199],bits[198],bits[197],bits[196]};
66: neighbors={1'b0,1'b0,1'b0,1'b0,bits[199],bits[198],bits[197],bits[196]};
67: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[259],bits[197],bits[196]};
68: neighbors={1'b0,1'b0,1'b0,bits[204],bits[195],bits[194],bits[193],bits[192]};
69: neighbors={1'b0,1'b0,1'b0,bits[205],bits[195],bits[194],bits[193],bits[192]};
70: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[194],bits[193],bits[192]};
71: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[207],bits[194],bits[193]};
72: neighbors={1'b0,1'b0,1'b0,1'b0,bits[264],bits[206],bits[205],bits[136]};
73: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[207],bits[206],bits[205]};
74: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[206],bits[204]};
75: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[206],bits[205]};
76: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[202],bits[196]};
77: neighbors={1'b0,1'b0,1'b0,1'b0,bits[203],bits[201],bits[200],bits[197]};
78: neighbors={1'b0,1'b0,1'b0,bits[214],bits[203],bits[202],bits[201],bits[200]};
79: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[201],bits[199]};
80: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[272],bits[215]};
81: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[215],bits[214],bits[212]};
82: neighbors={1'b0,1'b0,1'b0,1'b0,bits[215],bits[214],bits[212],bits[146]};
83: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[275],bits[215],bits[214]};
84: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[220],bits[210],bits[209]};
85: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
86: neighbors={1'b0,1'b0,1'b0,bits[222],bits[211],bits[210],bits[209],bits[206]};
87: neighbors={1'b0,1'b0,1'b0,bits[223],bits[211],bits[210],bits[209],bits[208]};
88: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[223],bits[220]};
89: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[222],bits[221],bits[153]};
90: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[223],bits[154]};
91: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[223],bits[222]};
92: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[228],bits[216],bits[212]};
93: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[229],bits[217]};
94: neighbors={1'b0,1'b0,1'b0,1'b0,bits[230],bits[219],bits[217],bits[214]};
95: neighbors={1'b0,1'b0,1'b0,1'b0,bits[219],bits[218],bits[216],bits[215]};
96: neighbors={1'b0,1'b0,1'b0,1'b0,bits[231],bits[230],bits[229],bits[228]};
97: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[231],bits[230]};
98: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[231]};
99: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[231],bits[230]};
100: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[224],bits[220]};
101: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[224],bits[221]};
102: neighbors={1'b0,1'b0,1'b0,1'b0,bits[227],bits[225],bits[224],bits[222]};
103: neighbors={1'b0,1'b0,1'b0,1'b0,bits[227],bits[226],bits[225],bits[224]};
104: neighbors={1'b0,1'b0,1'b0,1'b0,bits[296],bits[239],bits[238],bits[237]};
105: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[239],bits[238]};
106: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[298],bits[239]};
107: neighbors={1'b0,1'b0,1'b0,1'b0,bits[299],bits[238],bits[237],bits[236]};
108: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[235]};
109: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[235],bits[232]};
110: neighbors={1'b0,1'b0,1'b0,1'b0,bits[246],bits[235],bits[233],bits[232]};
111: neighbors={1'b0,1'b0,1'b0,1'b0,bits[247],bits[234],bits[233],bits[232]};
112: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[247],bits[244]};
113: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
114: neighbors={1'b0,1'b0,1'b0,1'b0,bits[306],bits[247],bits[246],bits[245]};
115: neighbors={1'b0,1'b0,1'b0,1'b0,bits[307],bits[246],bits[245],bits[244]};
116: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[243],bits[240]};
117: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[243],bits[242]};
118: neighbors={1'b0,1'b0,1'b0,1'b0,bits[254],bits[243],bits[242],bits[238]};
119: neighbors={1'b0,1'b0,1'b0,1'b0,bits[255],bits[242],bits[240],bits[239]};
120: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[254],bits[253]};
121: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[255],bits[253]};
122: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
123: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
124: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
125: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[249],bits[248]};
126: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[248],bits[246]};
127: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[249],bits[247]};
default: neighbors=0;endcase end endfunction
function automatic [7:0] present(input [6:0] node); begin case(node)
0: present=8'd3;
1: present=8'd3;
2: present=8'd1;
3: present=8'd3;
4: present=8'd7;
5: present=8'd3;
6: present=8'd3;
7: present=8'd0;
8: present=8'd15;
9: present=8'd7;
10: present=8'd15;
11: present=8'd3;
12: present=8'd7;
13: present=8'd1;
14: present=8'd7;
15: present=8'd15;
16: present=8'd3;
17: present=8'd7;
18: present=8'd7;
19: present=8'd0;
20: present=8'd0;
21: present=8'd3;
22: present=8'd15;
23: present=8'd3;
24: present=8'd3;
25: present=8'd3;
26: present=8'd3;
27: present=8'd3;
28: present=8'd15;
29: present=8'd7;
30: present=8'd0;
31: present=8'd3;
32: present=8'd0;
33: present=8'd3;
34: present=8'd0;
35: present=8'd3;
36: present=8'd3;
37: present=8'd7;
38: present=8'd0;
39: present=8'd3;
40: present=8'd15;
41: present=8'd3;
42: present=8'd15;
43: present=8'd3;
44: present=8'd3;
45: present=8'd3;
46: present=8'd7;
47: present=8'd7;
48: present=8'd7;
49: present=8'd3;
50: present=8'd7;
51: present=8'd3;
52: present=8'd3;
53: present=8'd31;
54: present=8'd7;
55: present=8'd0;
56: present=8'd0;
57: present=8'd3;
58: present=8'd3;
59: present=8'd3;
60: present=8'd0;
61: present=8'd15;
62: present=8'd3;
63: present=8'd3;
64: present=8'd15;
65: present=8'd31;
66: present=8'd15;
67: present=8'd7;
68: present=8'd31;
69: present=8'd31;
70: present=8'd7;
71: present=8'd7;
72: present=8'd15;
73: present=8'd7;
74: present=8'd3;
75: present=8'd3;
76: present=8'd3;
77: present=8'd15;
78: present=8'd31;
79: present=8'd3;
80: present=8'd3;
81: present=8'd7;
82: present=8'd15;
83: present=8'd7;
84: present=8'd7;
85: present=8'd0;
86: present=8'd31;
87: present=8'd31;
88: present=8'd3;
89: present=8'd7;
90: present=8'd3;
91: present=8'd3;
92: present=8'd7;
93: present=8'd3;
94: present=8'd15;
95: present=8'd15;
96: present=8'd15;
97: present=8'd3;
98: present=8'd1;
99: present=8'd3;
100: present=8'd3;
101: present=8'd3;
102: present=8'd15;
103: present=8'd15;
104: present=8'd15;
105: present=8'd3;
106: present=8'd3;
107: present=8'd15;
108: present=8'd1;
109: present=8'd3;
110: present=8'd15;
111: present=8'd15;
112: present=8'd3;
113: present=8'd0;
114: present=8'd15;
115: present=8'd15;
116: present=8'd3;
117: present=8'd3;
118: present=8'd15;
119: present=8'd15;
120: present=8'd3;
121: present=8'd3;
122: present=8'd0;
123: present=8'd0;
124: present=8'd0;
125: present=8'd3;
126: present=8'd3;
127: present=8'd3;
default: present=0;endcase end endfunction
function automatic [7:0] forward(input [6:0] node); begin case(node)
0: forward=8'd3;
1: forward=8'd3;
2: forward=8'd1;
3: forward=8'd3;
4: forward=8'd0;
5: forward=8'd0;
6: forward=8'd0;
7: forward=8'd0;
8: forward=8'd15;
9: forward=8'd6;
10: forward=8'd14;
11: forward=8'd3;
12: forward=8'd0;
13: forward=8'd0;
14: forward=8'd4;
15: forward=8'd0;
16: forward=8'd3;
17: forward=8'd7;
18: forward=8'd7;
19: forward=8'd0;
20: forward=8'd0;
21: forward=8'd0;
22: forward=8'd0;
23: forward=8'd0;
24: forward=8'd3;
25: forward=8'd3;
26: forward=8'd3;
27: forward=8'd3;
28: forward=8'd8;
29: forward=8'd4;
30: forward=8'd0;
31: forward=8'd2;
32: forward=8'd0;
33: forward=8'd3;
34: forward=8'd0;
35: forward=8'd3;
36: forward=8'd0;
37: forward=8'd0;
38: forward=8'd0;
39: forward=8'd0;
40: forward=8'd14;
41: forward=8'd3;
42: forward=8'd14;
43: forward=8'd3;
44: forward=8'd0;
45: forward=8'd0;
46: forward=8'd0;
47: forward=8'd0;
48: forward=8'd6;
49: forward=8'd3;
50: forward=8'd6;
51: forward=8'd3;
52: forward=8'd0;
53: forward=8'd16;
54: forward=8'd4;
55: forward=8'd0;
56: forward=8'd0;
57: forward=8'd3;
58: forward=8'd3;
59: forward=8'd3;
60: forward=8'd0;
61: forward=8'd0;
62: forward=8'd0;
63: forward=8'd0;
64: forward=8'd15;
65: forward=8'd31;
66: forward=8'd15;
67: forward=8'd7;
68: forward=8'd16;
69: forward=8'd16;
70: forward=8'd0;
71: forward=8'd4;
72: forward=8'd14;
73: forward=8'd7;
74: forward=8'd3;
75: forward=8'd3;
76: forward=8'd0;
77: forward=8'd0;
78: forward=8'd16;
79: forward=8'd0;
80: forward=8'd3;
81: forward=8'd7;
82: forward=8'd14;
83: forward=8'd7;
84: forward=8'd4;
85: forward=8'd0;
86: forward=8'd16;
87: forward=8'd16;
88: forward=8'd3;
89: forward=8'd6;
90: forward=8'd2;
91: forward=8'd3;
92: forward=8'd4;
93: forward=8'd2;
94: forward=8'd8;
95: forward=8'd0;
96: forward=8'd15;
97: forward=8'd3;
98: forward=8'd1;
99: forward=8'd3;
100: forward=8'd0;
101: forward=8'd0;
102: forward=8'd0;
103: forward=8'd0;
104: forward=8'd15;
105: forward=8'd3;
106: forward=8'd3;
107: forward=8'd15;
108: forward=8'd0;
109: forward=8'd0;
110: forward=8'd8;
111: forward=8'd8;
112: forward=8'd3;
113: forward=8'd0;
114: forward=8'd15;
115: forward=8'd15;
116: forward=8'd0;
117: forward=8'd0;
118: forward=8'd8;
119: forward=8'd8;
120: forward=8'd3;
121: forward=8'd3;
122: forward=8'd0;
123: forward=8'd0;
124: forward=8'd0;
125: forward=8'd0;
126: forward=8'd0;
127: forward=8'd0;
default: forward=0;endcase end endfunction
function automatic [1:0] node_color(input [6:0] node); begin case(node)
0: node_color=2'd0;
1: node_color=2'd0;
2: node_color=2'd0;
3: node_color=2'd0;
4: node_color=2'd1;
5: node_color=2'd1;
6: node_color=2'd1;
7: node_color=2'd1;
8: node_color=2'd1;
9: node_color=2'd1;
10: node_color=2'd1;
11: node_color=2'd1;
12: node_color=2'd0;
13: node_color=2'd0;
14: node_color=2'd0;
15: node_color=2'd0;
16: node_color=2'd0;
17: node_color=2'd0;
18: node_color=2'd0;
19: node_color=2'd0;
20: node_color=2'd1;
21: node_color=2'd1;
22: node_color=2'd1;
23: node_color=2'd1;
24: node_color=2'd1;
25: node_color=2'd1;
26: node_color=2'd1;
27: node_color=2'd1;
28: node_color=2'd0;
29: node_color=2'd0;
30: node_color=2'd0;
31: node_color=2'd0;
32: node_color=2'd0;
33: node_color=2'd0;
34: node_color=2'd0;
35: node_color=2'd0;
36: node_color=2'd1;
37: node_color=2'd1;
38: node_color=2'd1;
39: node_color=2'd1;
40: node_color=2'd1;
41: node_color=2'd1;
42: node_color=2'd1;
43: node_color=2'd1;
44: node_color=2'd0;
45: node_color=2'd0;
46: node_color=2'd0;
47: node_color=2'd0;
48: node_color=2'd0;
49: node_color=2'd0;
50: node_color=2'd0;
51: node_color=2'd0;
52: node_color=2'd1;
53: node_color=2'd1;
54: node_color=2'd1;
55: node_color=2'd1;
56: node_color=2'd1;
57: node_color=2'd1;
58: node_color=2'd1;
59: node_color=2'd1;
60: node_color=2'd0;
61: node_color=2'd0;
62: node_color=2'd0;
63: node_color=2'd0;
64: node_color=2'd1;
65: node_color=2'd1;
66: node_color=2'd1;
67: node_color=2'd1;
68: node_color=2'd0;
69: node_color=2'd0;
70: node_color=2'd0;
71: node_color=2'd0;
72: node_color=2'd0;
73: node_color=2'd0;
74: node_color=2'd0;
75: node_color=2'd0;
76: node_color=2'd1;
77: node_color=2'd1;
78: node_color=2'd1;
79: node_color=2'd1;
80: node_color=2'd1;
81: node_color=2'd1;
82: node_color=2'd1;
83: node_color=2'd1;
84: node_color=2'd0;
85: node_color=2'd0;
86: node_color=2'd0;
87: node_color=2'd0;
88: node_color=2'd0;
89: node_color=2'd0;
90: node_color=2'd0;
91: node_color=2'd0;
92: node_color=2'd1;
93: node_color=2'd1;
94: node_color=2'd1;
95: node_color=2'd1;
96: node_color=2'd1;
97: node_color=2'd1;
98: node_color=2'd1;
99: node_color=2'd1;
100: node_color=2'd0;
101: node_color=2'd0;
102: node_color=2'd0;
103: node_color=2'd0;
104: node_color=2'd0;
105: node_color=2'd0;
106: node_color=2'd0;
107: node_color=2'd0;
108: node_color=2'd1;
109: node_color=2'd1;
110: node_color=2'd1;
111: node_color=2'd1;
112: node_color=2'd1;
113: node_color=2'd1;
114: node_color=2'd1;
115: node_color=2'd1;
116: node_color=2'd0;
117: node_color=2'd0;
118: node_color=2'd0;
119: node_color=2'd0;
120: node_color=2'd0;
121: node_color=2'd0;
122: node_color=2'd0;
123: node_color=2'd0;
124: node_color=2'd1;
125: node_color=2'd1;
126: node_color=2'd1;
127: node_color=2'd1;
default: node_color=0;endcase end endfunction

 wire [31:0] threshold=probability(8'((magnitude*beta*4+2)/4>127 ? 127 : (magnitude*beta*4+2)/4));
 wire selected=node_color(slot)==color;
 wire configured_write=cfg_we && cfg_addr>=BASE && cfg_addr<BASE+L;
 reg [L-1:0] loaded;
 wire configuration_clock,controller_clock;
 sky130_fd_sc_hd__dlclkp_1 configuration_gate(.CLK(clk),.GATE(rst||test_enable||configured_write),.GCLK(configuration_clock));
 sky130_fd_sc_hd__dlclkp_1 controller_gate(.CLK(clk),.GATE(rst||test_enable||active||score_active||(phase!=IDLE)),.GCLK(controller_clock));
 always @(posedge configuration_clock) begin
   if(rst) loaded<=0;
   else if(configured_write) loaded[7'(cfg_addr-BASE)]<=1'b1;
 end
 assign configured=&loaded;
 wire [39:0] coefficients;
 wire read_coeff=(phase==SCAN)&&(scoring||selected);
 a2_coefficient_memory #(.WORDS(128)) coefficient_memory(
   .clk(clk),.access(configured_write||read_coeff),
   .write_enable(configured_write),
   .address(configured_write ? 8'(cfg_addr-BASE) : {1'b0,slot}),
   .write_data({8'b0,data_in}),.mask(2'b11),.read_data(coefficients));
 wire [7:0] neighbor_bits=neighbors(slot,current);
 wire [7:0] edge_present=present(slot),edge_forward=forward(slot);
 reg signed [15:0] field_sum,row_cut;
 reg signed [15:0] weight;
 always_comb begin
   field_sum=0;row_cut=0;weight=0;
   // Run field arithmetic only after a coefficient read.
   if(phase==CALCULATE) for(integer e=0;e<8;e=e+1) begin
     weight={{12{coefficients[4*e+3]}},coefficients[4*e+:4]};
     if(edge_present[e]) begin
       if(!scoring)field_sum=field_sum+(neighbor_bits[e] ? -weight : weight);
       if(scoring&&edge_forward[e]&&(current[BASE+slot]!=neighbor_bits[e])) row_cut=row_cut+weight;
     end
   end
 end
 wire [31:0] retained [0:R*L-1];
 wire signed [FW-1:0] fields [0:R*L-1];
 wire [TW-1:0] tags [0:R*L-1];
 localparam CW=$clog2(R*L+1);
 wire [CW-1:0] address=CW'(context_id*L+slot);
 wire [TW-1:0] age=TW'(sweep_tag)-tags[address];
 wire signed [FW-1:0] saved_raw=fields[address];
 wire [5:0] saved_beta=beta-6'((beta>1)&&(beta_sweep<age));
 wire changed=16'($signed(saved_raw))*16'($signed({1'b0,saved_beta}))!=16'($signed(raw_value))*16'($signed({1'b0,beta}));
 wire refresh=!EPIX||dirty[slot]||(age>AGE)||current[BASE+slot]!=nonnegative||changed;
 // Each replica and p-bit has separate LFSR state and feedback logic.
 for(genvar r=0;r<R;r=r+1) begin:replica_bank
   wire replica_clock;
   wire seed_replica=seed_we&&(seed_addr>=r*N+BASE)&&(seed_addr<r*N+BASE+L);
   wire fresh_replica=(phase==SAMPLE)&&(context_id==r);
   // Stop the clock upstream of inactive replicas.
   sky130_fd_sc_hd__dlclkp_1 replica_gate(.CLK(clk),
     .GATE(rst||test_enable||seed_replica||fresh_replica),.GCLK(replica_clock));
   for(genvar i=0;i<L;i=i+1) begin:site_bank
     wire seeded=seed_we&&(seed_addr==r*N+BASE+i);
     wire consume=(phase==SAMPLE)&&(context_id==r)&&(slot==i);
     wire rng_clock;
     reg [31:0] state;
     function automatic [31:0] advance(input [31:0] x0);
       reg [31:0] x;
       begin
         x=x0;
         for(integer k=0;k<32;k=k+1)x={x[30:0],~(x[31]^x[21]^x[1]^x[0])};
         advance=x;
       end
     endfunction
     // Holding LFSR state also holds its feedback logic. Keep consume out of this path.
     wire [31:0] evolved=advance(state);
     sky130_fd_sc_hd__dlclkp_1 gate(.CLK(replica_clock),.GATE(rst||test_enable||seeded||consume),.GCLK(rng_clock));
     always @(posedge rng_clock) begin
       if(rst) state<=0;
       else if(seeded) state<=(data_in==32'hffffffff)?32'b0:data_in;
       else if(consume) state<=evolved;
     end
     // SAMPLE reads the next random word. Reuse holds the spin.
     assign retained[r*L+i]=evolved;
     if(EPIX) begin:metadata
       reg signed [FW-1:0] saved_field;
       reg [TW-1:0] saved_tag;
       always @(posedge rng_clock) begin
         if(rst)begin saved_field<=0;saved_tag<=0;end
         else if(consume)begin saved_field<=raw_value;saved_tag<=TW'(sweep_tag);end
       end
       assign fields[r*L+i]=saved_field;
       assign tags[r*L+i]=saved_tag;
     end else begin
       assign fields[r*L+i]=0;
       assign tags[r*L+i]=0;
     end
   end
 end
 // Save the RNG address one cycle before a fresh sample. Hold it during reuse.
 reg [CW-1:0] rng_address;
 wire rng_address_clock;
 wire fresh_request=(phase==DECIDE)&&refresh;
 sky130_fd_sc_hd__dlclkp_1 rng_address_gate(.CLK(clk),
   .GATE(rst||test_enable||fresh_request),.GCLK(rng_address_clock));
 always @(posedge rng_address_clock) begin
   if(rst)rng_address<=0;
   else if(fresh_request)rng_address<=address;
 end
 wire [31:0] random_word=retained[rng_address];
`ifndef SYNTHESIS
 always @(posedge clk) if(!rst&&phase==SAMPLE)
   assert(rng_address==address) else $fatal(1,"RNG read address mismatch");
`endif
 wire sampled_bit=nonnegative ? threshold>random_word : random_word>threshold;
 assign ready=phase==READY;
 task automatic next_site;
   begin
     if(slot==L-1)phase<=READY;
     else begin slot<=slot+1'b1;phase<=SCAN;end
   end
 endtask
 // Clock each data bank only when needed.
 wire begin_operation=(phase==IDLE)&&(active||score_active);
 wire raw_write=(phase==CALCULATE)&&!scoring;
 wire score_write=((phase==CALCULATE)&&scoring)||
                  ((phase==SAMPLE)&&(sampled_bit!=current[BASE+slot]));
 wire raw_clock,count_clock,score_clock;
 sky130_fd_sc_hd__dlclkp_1 raw_gate(.CLK(clk),
   .GATE(rst||test_enable||raw_write),.GCLK(raw_clock));
 sky130_fd_sc_hd__dlclkp_1 count_gate(.CLK(clk),
   .GATE(rst||test_enable||begin_operation||(phase==SAMPLE)),.GCLK(count_clock));
 sky130_fd_sc_hd__dlclkp_1 score_gate(.CLK(clk),
   .GATE(rst||test_enable||begin_operation||score_write),.GCLK(score_clock));
 always @(posedge raw_clock) begin
   if(rst)raw_value<=0;
   else if(raw_write)raw_value<=FW'(field_sum);
 end
 always @(posedge count_clock) begin
   if(rst||begin_operation)fresh_count<=0;
   else if(phase==SAMPLE)fresh_count<=fresh_count+1'b1;
 end
 always @(posedge score_clock) begin
   if(rst||begin_operation)score_value<=0;
   else if((phase==CALCULATE)&&scoring)score_value<=score_value+row_cut;
   else if((phase==SAMPLE)&&(sampled_bit!=current[BASE+slot]))
     score_value<=score_value+(current[BASE+slot] ? -16'($signed(raw_value)) : 16'($signed(raw_value)));
 end
 // Eight result bits share one gate. Clock only the selected group.
 for(genvar group=0;group<(L+7)/8;group=group+1)begin:result_group
   wire result_clock;
   wire result_write=(phase==SAMPLE)&&(slot>=group*8)&&(slot<group*8+8);
   sky130_fd_sc_hd__dlclkp_1 gate(.CLK(clk),
     .GATE(rst||test_enable||begin_operation||result_write),.GCLK(result_clock));
   for(genvar bit_index=group*8;bit_index<L&&bit_index<group*8+8;bit_index=bit_index+1)begin:bit_bank
     always @(posedge result_clock)begin
       if(rst)next_bits[bit_index]<=0;
       else if(begin_operation)next_bits[bit_index]<=current[BASE+bit_index];
       else if((phase==SAMPLE)&&(slot==bit_index))next_bits[bit_index]<=sampled_bit;
     end
   end
 end
 always @(posedge controller_clock) begin
   if(rst)begin phase<=IDLE;slot<=0;scoring<=0;end
   else case(phase)
     IDLE:if(active||score_active)begin
       slot<=0;scoring<=score_active;phase<=SCAN;
     end
     SCAN:if(scoring||selected)phase<=CALCULATE;else next_site();
     CALCULATE:if(scoring)next_site();else phase<=DECIDE;
     DECIDE:if(refresh)phase<=SAMPLE;else next_site();
     SAMPLE:next_site();
     READY:if(accept)phase<=IDLE;
     default:phase<=IDLE;
   endcase
 end
`ifndef SYNTHESIS
 always @(posedge clk) if(!rst) begin
   if(active||score_active) assert(configured) else $fatal(1,"A2 coefficients not loaded");
   if(phase==CALCULATE&&!scoring) assert(field_sum>=-10 && field_sum<=10)
     else $fatal(1,"A2 field exceeds configured bound");
   if(active) assert(context_id<R) else $fatal(1,"A2 replica out of range");
 end
`endif
endmodule

// One field/score lane. Each replica and site owns its LFSR and history.
module a2_cluster_256 #(parameter EPIX=1)(
 input wire clk,rst,test_enable,active,score_active,accept,
 input wire seed_we,cfg_we,
 input wire [15:0] seed_addr,
 input wire [9:0] cfg_addr,
 input wire [31:0] data_in,
 input wire [5:0] context_id,beta,
 input wire [1:0] color,
 input wire [2:0] sweep_tag,
 input wire [9:0] beta_sweep,
 input wire [511:0] current,
 input wire [127:0] dirty,
 output reg [127:0] next_bits,
 output wire ready,configured,
 output reg [15:0] fresh_count,
 output reg signed [15:0] score_value);
 localparam N=512,L=128,R=1,BASE=256,FW=5,TW=2,AGE=2;
 localparam IDLE=0,SCAN=1,CALCULATE=2,DECIDE=3,SAMPLE=4,READY=5;
 reg [2:0] phase;
 reg [6:0] slot;
 reg scoring;
 reg signed [FW-1:0] raw_value;
 wire nonnegative=raw_value>=0;
 wire [15:0] magnitude=nonnegative ? 16'($signed(raw_value)) : 16'(-$signed(raw_value));
 function automatic [31:0] probability(input logic [7:0] address);
begin
case(address)
8'd0: probability=32'h80000000;
8'd1: probability=32'h8feacc96;
8'd2: probability=32'h9f597ea7;
8'd3: probability=32'haddea7bd;
8'd4: probability=32'hbb26a7af;
8'd5: probability=32'hc6fd1fab;
8'd6: probability=32'hd14c8f95;
8'd7: probability=32'hda19942e;
8'd8: probability=32'he17bead4;
8'd9: probability=32'he7972d6f;
8'd10: probability=32'hec948eee;
8'd11: probability=32'hf09e294b;
8'd12: probability=32'hf3dbe5e2;
8'd13: probability=32'hf671bec0;
8'd14: probability=32'hf87efe60;
8'd15: probability=32'hfa1e27b4;
8'd16: probability=32'hfb654178;
8'd17: probability=32'hfc66537e;
8'd18: probability=32'hfd2ff5b1;
8'd19: probability=32'hfdcdddad;
8'd20: probability=32'hfe496098;
8'd21: probability=32'hfea9e4d3;
8'd22: probability=32'hfef5426c;
8'd23: probability=32'hff301337;
8'd24: probability=32'hff5df444;
8'd25: probability=32'hff81bac2;
8'd26: probability=32'hff9d9e57;
8'd27: probability=32'hffb35ae0;
8'd28: probability=32'hffc44b19;
8'd29: probability=32'hffd17db5;
8'd30: probability=32'hffdbc5ea;
8'd31: probability=32'hffe3c873;
8'd32: probability=32'hffea05c2;
8'd33: probability=32'hffeee1f4;
8'd34: probability=32'hfff2ab10;
8'd35: probability=32'hfff59de2;
8'd36: probability=32'hfff7e9c8;
8'd37: probability=32'hfff9b3ab;
8'd38: probability=32'hfffb184a;
8'd39: probability=32'hfffc2e09;
8'd40: probability=32'hfffd065a;
8'd41: probability=32'hfffdaed2;
8'd42: probability=32'hfffe3207;
8'd43: probability=32'hfffe9837;
8'd44: probability=32'hfffee7cc;
8'd45: probability=32'hffff25c7;
8'd46: probability=32'hffff560c;
8'd47: probability=32'hffff7ba4;
8'd48: probability=32'hffff98eb;
8'd49: probability=32'hffffafb8;
8'd50: probability=32'hffffc17a;
8'd51: probability=32'hffffcf4f;
8'd52: probability=32'hffffda14;
8'd53: probability=32'hffffe277;
8'd54: probability=32'hffffe900;
8'd55: probability=32'hffffee16;
8'd56: probability=32'hfffff20d;
8'd57: probability=32'hfffff523;
8'd58: probability=32'hfffff78a;
8'd59: probability=32'hfffff969;
8'd60: probability=32'hfffffade;
8'd61: probability=32'hfffffc01;
8'd62: probability=32'hfffffce3;
8'd63: probability=32'hfffffd93;
8'd64: probability=32'hfffffe1d;
8'd65: probability=32'hfffffe88;
8'd66: probability=32'hfffffedb;
8'd67: probability=32'hffffff1c;
8'd68: probability=32'hffffff4e;
8'd69: probability=32'hffffff76;
8'd70: probability=32'hffffff94;
8'd71: probability=32'hffffffac;
8'd72: probability=32'hffffffbf;
8'd73: probability=32'hffffffcd;
8'd74: probability=32'hffffffd8;
8'd75: probability=32'hffffffe1;
8'd76: probability=32'hffffffe8;
8'd77: probability=32'hffffffed;
8'd78: probability=32'hfffffff1;
8'd79: probability=32'hfffffff5;
8'd80: probability=32'hfffffff7;
8'd81: probability=32'hfffffff9;
8'd82: probability=32'hfffffffb;
8'd83: probability=32'hfffffffc;
8'd84: probability=32'hffffffff;
8'd85: probability=32'hffffffff;
8'd86: probability=32'hffffffff;
8'd87: probability=32'hffffffff;
8'd88: probability=32'hffffffff;
8'd89: probability=32'hffffffff;
8'd90: probability=32'hffffffff;
8'd91: probability=32'hffffffff;
8'd92: probability=32'hffffffff;
8'd93: probability=32'hffffffff;
8'd94: probability=32'hffffffff;
8'd95: probability=32'hffffffff;
8'd96: probability=32'hffffffff;
8'd97: probability=32'hffffffff;
8'd98: probability=32'hffffffff;
8'd99: probability=32'hffffffff;
8'd100: probability=32'hffffffff;
8'd101: probability=32'hffffffff;
8'd102: probability=32'hffffffff;
8'd103: probability=32'hffffffff;
8'd104: probability=32'hffffffff;
8'd105: probability=32'hffffffff;
8'd106: probability=32'hffffffff;
8'd107: probability=32'hffffffff;
8'd108: probability=32'hffffffff;
8'd109: probability=32'hffffffff;
8'd110: probability=32'hffffffff;
8'd111: probability=32'hffffffff;
8'd112: probability=32'hffffffff;
8'd113: probability=32'hffffffff;
8'd114: probability=32'hffffffff;
8'd115: probability=32'hffffffff;
8'd116: probability=32'hffffffff;
8'd117: probability=32'hffffffff;
8'd118: probability=32'hffffffff;
8'd119: probability=32'hffffffff;
8'd120: probability=32'hffffffff;
8'd121: probability=32'hffffffff;
8'd122: probability=32'hffffffff;
8'd123: probability=32'hffffffff;
8'd124: probability=32'hffffffff;
8'd125: probability=32'hffffffff;
8'd126: probability=32'hffffffff;
8'd127: probability=32'hffffffff;
default: probability=32'hffffffff;
endcase
end
endfunction
 function automatic [7:0] neighbors(input [6:0] node,input [511:0] bits); begin case(node)
0: neighbors={1'b0,1'b0,1'b0,1'b0,bits[263],bits[262],bits[260],bits[192]};
1: neighbors={1'b0,1'b0,1'b0,bits[263],bits[262],bits[261],bits[260],bits[193]};
2: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[263],bits[262]};
3: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[262],bits[260],bits[195]};
4: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[259],bits[257],bits[256]};
5: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[269],bits[257]};
6: neighbors={1'b0,1'b0,1'b0,1'b0,bits[259],bits[258],bits[257],bits[256]};
7: neighbors={1'b0,1'b0,1'b0,1'b0,bits[271],bits[258],bits[257],bits[256]};
8: neighbors={1'b0,1'b0,bits[328],bits[271],bits[270],bits[269],bits[268],bits[200]};
9: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[329],bits[271],bits[269]};
10: neighbors={1'b0,1'b0,1'b0,bits[330],bits[271],bits[270],bits[269],bits[268]};
11: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[271],bits[269]};
12: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[266],bits[264]};
13: neighbors={1'b0,1'b0,1'b0,bits[267],bits[266],bits[265],bits[264],bits[261]};
14: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[266],bits[264]};
15: neighbors={1'b0,1'b0,1'b0,bits[267],bits[266],bits[265],bits[264],bits[263]};
16: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[279],bits[208]};
17: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[279],bits[278]};
18: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[279],bits[278]};
19: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[279],bits[278],bits[211]};
20: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
21: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
22: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[275],bits[274],bits[273]};
23: neighbors={1'b0,1'b0,1'b0,1'b0,bits[275],bits[274],bits[273],bits[272]};
24: neighbors={1'b0,1'b0,1'b0,1'b0,bits[344],bits[287],bits[286],bits[285]};
25: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[345],bits[287],bits[285]};
26: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[287],bits[286],bits[285]};
27: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[286],bits[285]};
28: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
29: neighbors={1'b0,1'b0,1'b0,bits[293],bits[283],bits[282],bits[281],bits[280]};
30: neighbors={1'b0,1'b0,1'b0,1'b0,bits[294],bits[283],bits[282],bits[280]};
31: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[282],bits[281],bits[280]};
32: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[294],bits[292]};
33: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[294],bits[293],bits[292]};
34: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[293],bits[292]};
35: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[293],bits[292]};
36: neighbors={1'b0,1'b0,1'b0,1'b0,bits[291],bits[290],bits[289],bits[288]};
37: neighbors={1'b0,1'b0,1'b0,1'b0,bits[291],bits[290],bits[289],bits[285]};
38: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[289],bits[288],bits[286]};
39: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
40: neighbors={1'b0,1'b0,1'b0,1'b0,bits[360],bits[303],bits[301],bits[232]};
41: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
42: neighbors={1'b0,1'b0,1'b0,1'b0,bits[303],bits[302],bits[301],bits[234]};
43: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[363],bits[302],bits[235]};
44: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
45: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[298],bits[296]};
46: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[299],bits[298]};
47: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[298],bits[296]};
48: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[309],bits[308]};
49: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[369],bits[310],bits[309]};
50: neighbors={1'b0,1'b0,bits[370],bits[311],bits[310],bits[309],bits[308],bits[242]};
51: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[311],bits[243]};
52: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[306],bits[304]};
53: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[306],bits[305],bits[304]};
54: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[306],bits[305]};
55: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[307],bits[306]};
56: neighbors={1'b0,1'b0,1'b0,1'b0,bits[319],bits[318],bits[317],bits[316]};
57: neighbors={1'b0,1'b0,1'b0,1'b0,bits[377],bits[319],bits[318],bits[316]};
58: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[378],bits[318],bits[317]};
59: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[379],bits[317]};
60: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[313],bits[312]};
61: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[315],bits[314],bits[312]};
62: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[314],bits[313],bits[312]};
63: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[313],bits[312]};
64: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[326],bits[325],bits[324]};
65: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
66: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[325],bits[324]};
67: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[326]};
68: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[322],bits[320]};
69: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[322],bits[320]};
70: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[323],bits[320]};
71: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
72: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[335],bits[334],bits[264]};
73: neighbors={1'b0,1'b0,1'b0,1'b0,bits[393],bits[334],bits[332],bits[265]};
74: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[332],bits[266]};
75: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[395],bits[334]};
76: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[330],bits[329]};
77: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
78: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[331],bits[329],bits[328]};
79: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[328]};
80: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
81: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
82: neighbors={1'b0,1'b0,1'b0,1'b0,bits[343],bits[342],bits[341],bits[340]};
83: neighbors={1'b0,1'b0,1'b0,1'b0,bits[343],bits[342],bits[341],bits[340]};
84: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[339],bits[338]};
85: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[339],bits[338]};
86: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[339],bits[338]};
87: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[339],bits[338]};
88: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[351],bits[280]};
89: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[351],bits[281]};
90: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
91: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
92: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
93: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
94: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
95: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[345],bits[344]};
96: neighbors={1'b0,1'b0,1'b0,1'b0,bits[416],bits[359],bits[357],bits[356]};
97: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[417],bits[358]};
98: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
99: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[359],bits[358]};
100: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[364],bits[352]};
101: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[365],bits[352]};
102: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[355],bits[353]};
103: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[355],bits[352]};
104: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[367],bits[365],bits[296]};
105: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[367],bits[365]};
106: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[366],bits[365],bits[364]};
107: neighbors={1'b0,1'b0,1'b0,bits[367],bits[366],bits[365],bits[364],bits[299]};
108: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[363],bits[362],bits[356]};
109: neighbors={1'b0,1'b0,1'b0,bits[363],bits[362],bits[361],bits[360],bits[357]};
110: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[363],bits[362]};
111: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[363],bits[361],bits[360]};
112: neighbors={1'b0,1'b0,1'b0,1'b0,bits[375],bits[374],bits[373],bits[372]};
113: neighbors={1'b0,1'b0,1'b0,1'b0,bits[374],bits[373],bits[372],bits[305]};
114: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[434],bits[374],bits[306]};
115: neighbors={1'b0,1'b0,1'b0,1'b0,bits[435],bits[375],bits[374],bits[373]};
116: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[369],bits[368]};
117: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[371],bits[369],bits[368]};
118: neighbors={1'b0,1'b0,1'b0,1'b0,bits[371],bits[370],bits[369],bits[368]};
119: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[371],bits[368]};
120: neighbors={1'b0,1'b0,1'b0,1'b0,bits[383],bits[382],bits[381],bits[380]};
121: neighbors={1'b0,1'b0,1'b0,bits[441],bits[383],bits[382],bits[381],bits[313]};
122: neighbors={1'b0,1'b0,bits[442],bits[383],bits[382],bits[381],bits[380],bits[314]};
123: neighbors={1'b0,1'b0,1'b0,1'b0,bits[383],bits[381],bits[380],bits[315]};
124: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[379],bits[378],bits[376]};
125: neighbors={1'b0,1'b0,1'b0,1'b0,bits[379],bits[378],bits[377],bits[376]};
126: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[378],bits[377],bits[376]};
127: neighbors={1'b0,1'b0,1'b0,1'b0,bits[379],bits[378],bits[377],bits[376]};
default: neighbors=0;endcase end endfunction
function automatic [7:0] present(input [6:0] node); begin case(node)
0: present=8'd15;
1: present=8'd31;
2: present=8'd3;
3: present=8'd7;
4: present=8'd7;
5: present=8'd3;
6: present=8'd15;
7: present=8'd15;
8: present=8'd63;
9: present=8'd7;
10: present=8'd31;
11: present=8'd3;
12: present=8'd3;
13: present=8'd31;
14: present=8'd3;
15: present=8'd31;
16: present=8'd3;
17: present=8'd3;
18: present=8'd3;
19: present=8'd7;
20: present=8'd0;
21: present=8'd0;
22: present=8'd7;
23: present=8'd15;
24: present=8'd15;
25: present=8'd7;
26: present=8'd7;
27: present=8'd3;
28: present=8'd0;
29: present=8'd31;
30: present=8'd15;
31: present=8'd7;
32: present=8'd3;
33: present=8'd7;
34: present=8'd3;
35: present=8'd3;
36: present=8'd15;
37: present=8'd15;
38: present=8'd7;
39: present=8'd0;
40: present=8'd15;
41: present=8'd0;
42: present=8'd15;
43: present=8'd7;
44: present=8'd0;
45: present=8'd3;
46: present=8'd3;
47: present=8'd3;
48: present=8'd3;
49: present=8'd7;
50: present=8'd63;
51: present=8'd3;
52: present=8'd3;
53: present=8'd7;
54: present=8'd3;
55: present=8'd3;
56: present=8'd15;
57: present=8'd15;
58: present=8'd7;
59: present=8'd3;
60: present=8'd3;
61: present=8'd7;
62: present=8'd7;
63: present=8'd3;
64: present=8'd7;
65: present=8'd0;
66: present=8'd3;
67: present=8'd1;
68: present=8'd3;
69: present=8'd3;
70: present=8'd3;
71: present=8'd0;
72: present=8'd7;
73: present=8'd15;
74: present=8'd3;
75: present=8'd3;
76: present=8'd3;
77: present=8'd0;
78: present=8'd7;
79: present=8'd1;
80: present=8'd0;
81: present=8'd0;
82: present=8'd15;
83: present=8'd15;
84: present=8'd3;
85: present=8'd3;
86: present=8'd3;
87: present=8'd3;
88: present=8'd3;
89: present=8'd3;
90: present=8'd0;
91: present=8'd0;
92: present=8'd0;
93: present=8'd0;
94: present=8'd0;
95: present=8'd3;
96: present=8'd15;
97: present=8'd3;
98: present=8'd0;
99: present=8'd3;
100: present=8'd3;
101: present=8'd3;
102: present=8'd3;
103: present=8'd3;
104: present=8'd7;
105: present=8'd3;
106: present=8'd7;
107: present=8'd31;
108: present=8'd7;
109: present=8'd31;
110: present=8'd3;
111: present=8'd7;
112: present=8'd15;
113: present=8'd15;
114: present=8'd7;
115: present=8'd15;
116: present=8'd3;
117: present=8'd7;
118: present=8'd15;
119: present=8'd3;
120: present=8'd15;
121: present=8'd31;
122: present=8'd63;
123: present=8'd15;
124: present=8'd7;
125: present=8'd15;
126: present=8'd7;
127: present=8'd15;
default: present=0;endcase end endfunction
function automatic [7:0] forward(input [6:0] node); begin case(node)
0: forward=8'd14;
1: forward=8'd30;
2: forward=8'd3;
3: forward=8'd6;
4: forward=8'd0;
5: forward=8'd2;
6: forward=8'd0;
7: forward=8'd8;
8: forward=8'd62;
9: forward=8'd7;
10: forward=8'd31;
11: forward=8'd3;
12: forward=8'd0;
13: forward=8'd0;
14: forward=8'd0;
15: forward=8'd0;
16: forward=8'd2;
17: forward=8'd3;
18: forward=8'd3;
19: forward=8'd6;
20: forward=8'd0;
21: forward=8'd0;
22: forward=8'd0;
23: forward=8'd0;
24: forward=8'd15;
25: forward=8'd7;
26: forward=8'd7;
27: forward=8'd3;
28: forward=8'd0;
29: forward=8'd16;
30: forward=8'd8;
31: forward=8'd0;
32: forward=8'd3;
33: forward=8'd7;
34: forward=8'd3;
35: forward=8'd3;
36: forward=8'd0;
37: forward=8'd0;
38: forward=8'd0;
39: forward=8'd0;
40: forward=8'd14;
41: forward=8'd0;
42: forward=8'd14;
43: forward=8'd6;
44: forward=8'd0;
45: forward=8'd0;
46: forward=8'd0;
47: forward=8'd0;
48: forward=8'd3;
49: forward=8'd7;
50: forward=8'd62;
51: forward=8'd2;
52: forward=8'd0;
53: forward=8'd0;
54: forward=8'd0;
55: forward=8'd0;
56: forward=8'd15;
57: forward=8'd15;
58: forward=8'd7;
59: forward=8'd3;
60: forward=8'd0;
61: forward=8'd0;
62: forward=8'd0;
63: forward=8'd0;
64: forward=8'd7;
65: forward=8'd0;
66: forward=8'd3;
67: forward=8'd1;
68: forward=8'd0;
69: forward=8'd0;
70: forward=8'd0;
71: forward=8'd0;
72: forward=8'd6;
73: forward=8'd14;
74: forward=8'd2;
75: forward=8'd3;
76: forward=8'd0;
77: forward=8'd0;
78: forward=8'd0;
79: forward=8'd0;
80: forward=8'd0;
81: forward=8'd0;
82: forward=8'd15;
83: forward=8'd15;
84: forward=8'd0;
85: forward=8'd0;
86: forward=8'd0;
87: forward=8'd0;
88: forward=8'd2;
89: forward=8'd2;
90: forward=8'd0;
91: forward=8'd0;
92: forward=8'd0;
93: forward=8'd0;
94: forward=8'd0;
95: forward=8'd0;
96: forward=8'd15;
97: forward=8'd3;
98: forward=8'd0;
99: forward=8'd3;
100: forward=8'd2;
101: forward=8'd2;
102: forward=8'd0;
103: forward=8'd0;
104: forward=8'd6;
105: forward=8'd3;
106: forward=8'd7;
107: forward=8'd30;
108: forward=8'd0;
109: forward=8'd0;
110: forward=8'd0;
111: forward=8'd0;
112: forward=8'd15;
113: forward=8'd14;
114: forward=8'd6;
115: forward=8'd15;
116: forward=8'd0;
117: forward=8'd0;
118: forward=8'd0;
119: forward=8'd0;
120: forward=8'd15;
121: forward=8'd30;
122: forward=8'd62;
123: forward=8'd14;
124: forward=8'd0;
125: forward=8'd0;
126: forward=8'd0;
127: forward=8'd0;
default: forward=0;endcase end endfunction
function automatic [1:0] node_color(input [6:0] node); begin case(node)
0: node_color=2'd0;
1: node_color=2'd0;
2: node_color=2'd0;
3: node_color=2'd0;
4: node_color=2'd1;
5: node_color=2'd1;
6: node_color=2'd1;
7: node_color=2'd1;
8: node_color=2'd1;
9: node_color=2'd1;
10: node_color=2'd1;
11: node_color=2'd1;
12: node_color=2'd0;
13: node_color=2'd0;
14: node_color=2'd0;
15: node_color=2'd0;
16: node_color=2'd0;
17: node_color=2'd0;
18: node_color=2'd0;
19: node_color=2'd0;
20: node_color=2'd1;
21: node_color=2'd1;
22: node_color=2'd1;
23: node_color=2'd1;
24: node_color=2'd1;
25: node_color=2'd1;
26: node_color=2'd1;
27: node_color=2'd1;
28: node_color=2'd0;
29: node_color=2'd0;
30: node_color=2'd0;
31: node_color=2'd0;
32: node_color=2'd0;
33: node_color=2'd0;
34: node_color=2'd0;
35: node_color=2'd0;
36: node_color=2'd1;
37: node_color=2'd1;
38: node_color=2'd1;
39: node_color=2'd1;
40: node_color=2'd1;
41: node_color=2'd1;
42: node_color=2'd1;
43: node_color=2'd1;
44: node_color=2'd0;
45: node_color=2'd0;
46: node_color=2'd0;
47: node_color=2'd0;
48: node_color=2'd0;
49: node_color=2'd0;
50: node_color=2'd0;
51: node_color=2'd0;
52: node_color=2'd1;
53: node_color=2'd1;
54: node_color=2'd1;
55: node_color=2'd1;
56: node_color=2'd1;
57: node_color=2'd1;
58: node_color=2'd1;
59: node_color=2'd1;
60: node_color=2'd0;
61: node_color=2'd0;
62: node_color=2'd0;
63: node_color=2'd0;
64: node_color=2'd1;
65: node_color=2'd1;
66: node_color=2'd1;
67: node_color=2'd1;
68: node_color=2'd0;
69: node_color=2'd0;
70: node_color=2'd0;
71: node_color=2'd0;
72: node_color=2'd0;
73: node_color=2'd0;
74: node_color=2'd0;
75: node_color=2'd0;
76: node_color=2'd1;
77: node_color=2'd1;
78: node_color=2'd1;
79: node_color=2'd1;
80: node_color=2'd1;
81: node_color=2'd1;
82: node_color=2'd1;
83: node_color=2'd1;
84: node_color=2'd0;
85: node_color=2'd0;
86: node_color=2'd0;
87: node_color=2'd0;
88: node_color=2'd0;
89: node_color=2'd0;
90: node_color=2'd0;
91: node_color=2'd0;
92: node_color=2'd1;
93: node_color=2'd1;
94: node_color=2'd1;
95: node_color=2'd1;
96: node_color=2'd1;
97: node_color=2'd1;
98: node_color=2'd1;
99: node_color=2'd1;
100: node_color=2'd0;
101: node_color=2'd0;
102: node_color=2'd0;
103: node_color=2'd0;
104: node_color=2'd0;
105: node_color=2'd0;
106: node_color=2'd0;
107: node_color=2'd0;
108: node_color=2'd1;
109: node_color=2'd1;
110: node_color=2'd1;
111: node_color=2'd1;
112: node_color=2'd1;
113: node_color=2'd1;
114: node_color=2'd1;
115: node_color=2'd1;
116: node_color=2'd0;
117: node_color=2'd0;
118: node_color=2'd0;
119: node_color=2'd0;
120: node_color=2'd0;
121: node_color=2'd0;
122: node_color=2'd0;
123: node_color=2'd0;
124: node_color=2'd1;
125: node_color=2'd1;
126: node_color=2'd1;
127: node_color=2'd1;
default: node_color=0;endcase end endfunction

 wire [31:0] threshold=probability(8'((magnitude*beta*4+2)/4>127 ? 127 : (magnitude*beta*4+2)/4));
 wire selected=node_color(slot)==color;
 wire configured_write=cfg_we && cfg_addr>=BASE && cfg_addr<BASE+L;
 reg [L-1:0] loaded;
 wire configuration_clock,controller_clock;
 sky130_fd_sc_hd__dlclkp_1 configuration_gate(.CLK(clk),.GATE(rst||test_enable||configured_write),.GCLK(configuration_clock));
 sky130_fd_sc_hd__dlclkp_1 controller_gate(.CLK(clk),.GATE(rst||test_enable||active||score_active||(phase!=IDLE)),.GCLK(controller_clock));
 always @(posedge configuration_clock) begin
   if(rst) loaded<=0;
   else if(configured_write) loaded[7'(cfg_addr-BASE)]<=1'b1;
 end
 assign configured=&loaded;
 wire [39:0] coefficients;
 wire read_coeff=(phase==SCAN)&&(scoring||selected);
 a2_coefficient_memory #(.WORDS(128)) coefficient_memory(
   .clk(clk),.access(configured_write||read_coeff),
   .write_enable(configured_write),
   .address(configured_write ? 8'(cfg_addr-BASE) : {1'b0,slot}),
   .write_data({8'b0,data_in}),.mask(2'b11),.read_data(coefficients));
 wire [7:0] neighbor_bits=neighbors(slot,current);
 wire [7:0] edge_present=present(slot),edge_forward=forward(slot);
 reg signed [15:0] field_sum,row_cut;
 reg signed [15:0] weight;
 always_comb begin
   field_sum=0;row_cut=0;weight=0;
   // Run field arithmetic only after a coefficient read.
   if(phase==CALCULATE) for(integer e=0;e<8;e=e+1) begin
     weight={{12{coefficients[4*e+3]}},coefficients[4*e+:4]};
     if(edge_present[e]) begin
       if(!scoring)field_sum=field_sum+(neighbor_bits[e] ? -weight : weight);
       if(scoring&&edge_forward[e]&&(current[BASE+slot]!=neighbor_bits[e])) row_cut=row_cut+weight;
     end
   end
 end
 wire [31:0] retained [0:R*L-1];
 wire signed [FW-1:0] fields [0:R*L-1];
 wire [TW-1:0] tags [0:R*L-1];
 localparam CW=$clog2(R*L+1);
 wire [CW-1:0] address=CW'(context_id*L+slot);
 wire [TW-1:0] age=TW'(sweep_tag)-tags[address];
 wire signed [FW-1:0] saved_raw=fields[address];
 wire [5:0] saved_beta=beta-6'((beta>1)&&(beta_sweep<age));
 wire changed=16'($signed(saved_raw))*16'($signed({1'b0,saved_beta}))!=16'($signed(raw_value))*16'($signed({1'b0,beta}));
 wire refresh=!EPIX||dirty[slot]||(age>AGE)||current[BASE+slot]!=nonnegative||changed;
 // Each replica and p-bit has separate LFSR state and feedback logic.
 for(genvar r=0;r<R;r=r+1) begin:replica_bank
   wire replica_clock;
   wire seed_replica=seed_we&&(seed_addr>=r*N+BASE)&&(seed_addr<r*N+BASE+L);
   wire fresh_replica=(phase==SAMPLE)&&(context_id==r);
   // Stop the clock upstream of inactive replicas.
   sky130_fd_sc_hd__dlclkp_1 replica_gate(.CLK(clk),
     .GATE(rst||test_enable||seed_replica||fresh_replica),.GCLK(replica_clock));
   for(genvar i=0;i<L;i=i+1) begin:site_bank
     wire seeded=seed_we&&(seed_addr==r*N+BASE+i);
     wire consume=(phase==SAMPLE)&&(context_id==r)&&(slot==i);
     wire rng_clock;
     reg [31:0] state;
     function automatic [31:0] advance(input [31:0] x0);
       reg [31:0] x;
       begin
         x=x0;
         for(integer k=0;k<32;k=k+1)x={x[30:0],~(x[31]^x[21]^x[1]^x[0])};
         advance=x;
       end
     endfunction
     // Holding LFSR state also holds its feedback logic. Keep consume out of this path.
     wire [31:0] evolved=advance(state);
     sky130_fd_sc_hd__dlclkp_1 gate(.CLK(replica_clock),.GATE(rst||test_enable||seeded||consume),.GCLK(rng_clock));
     always @(posedge rng_clock) begin
       if(rst) state<=0;
       else if(seeded) state<=(data_in==32'hffffffff)?32'b0:data_in;
       else if(consume) state<=evolved;
     end
     // SAMPLE reads the next random word. Reuse holds the spin.
     assign retained[r*L+i]=evolved;
     if(EPIX) begin:metadata
       reg signed [FW-1:0] saved_field;
       reg [TW-1:0] saved_tag;
       always @(posedge rng_clock) begin
         if(rst)begin saved_field<=0;saved_tag<=0;end
         else if(consume)begin saved_field<=raw_value;saved_tag<=TW'(sweep_tag);end
       end
       assign fields[r*L+i]=saved_field;
       assign tags[r*L+i]=saved_tag;
     end else begin
       assign fields[r*L+i]=0;
       assign tags[r*L+i]=0;
     end
   end
 end
 // Save the RNG address one cycle before a fresh sample. Hold it during reuse.
 reg [CW-1:0] rng_address;
 wire rng_address_clock;
 wire fresh_request=(phase==DECIDE)&&refresh;
 sky130_fd_sc_hd__dlclkp_1 rng_address_gate(.CLK(clk),
   .GATE(rst||test_enable||fresh_request),.GCLK(rng_address_clock));
 always @(posedge rng_address_clock) begin
   if(rst)rng_address<=0;
   else if(fresh_request)rng_address<=address;
 end
 wire [31:0] random_word=retained[rng_address];
`ifndef SYNTHESIS
 always @(posedge clk) if(!rst&&phase==SAMPLE)
   assert(rng_address==address) else $fatal(1,"RNG read address mismatch");
`endif
 wire sampled_bit=nonnegative ? threshold>random_word : random_word>threshold;
 assign ready=phase==READY;
 task automatic next_site;
   begin
     if(slot==L-1)phase<=READY;
     else begin slot<=slot+1'b1;phase<=SCAN;end
   end
 endtask
 // Clock each data bank only when needed.
 wire begin_operation=(phase==IDLE)&&(active||score_active);
 wire raw_write=(phase==CALCULATE)&&!scoring;
 wire score_write=((phase==CALCULATE)&&scoring)||
                  ((phase==SAMPLE)&&(sampled_bit!=current[BASE+slot]));
 wire raw_clock,count_clock,score_clock;
 sky130_fd_sc_hd__dlclkp_1 raw_gate(.CLK(clk),
   .GATE(rst||test_enable||raw_write),.GCLK(raw_clock));
 sky130_fd_sc_hd__dlclkp_1 count_gate(.CLK(clk),
   .GATE(rst||test_enable||begin_operation||(phase==SAMPLE)),.GCLK(count_clock));
 sky130_fd_sc_hd__dlclkp_1 score_gate(.CLK(clk),
   .GATE(rst||test_enable||begin_operation||score_write),.GCLK(score_clock));
 always @(posedge raw_clock) begin
   if(rst)raw_value<=0;
   else if(raw_write)raw_value<=FW'(field_sum);
 end
 always @(posedge count_clock) begin
   if(rst||begin_operation)fresh_count<=0;
   else if(phase==SAMPLE)fresh_count<=fresh_count+1'b1;
 end
 always @(posedge score_clock) begin
   if(rst||begin_operation)score_value<=0;
   else if((phase==CALCULATE)&&scoring)score_value<=score_value+row_cut;
   else if((phase==SAMPLE)&&(sampled_bit!=current[BASE+slot]))
     score_value<=score_value+(current[BASE+slot] ? -16'($signed(raw_value)) : 16'($signed(raw_value)));
 end
 // Eight result bits share one gate. Clock only the selected group.
 for(genvar group=0;group<(L+7)/8;group=group+1)begin:result_group
   wire result_clock;
   wire result_write=(phase==SAMPLE)&&(slot>=group*8)&&(slot<group*8+8);
   sky130_fd_sc_hd__dlclkp_1 gate(.CLK(clk),
     .GATE(rst||test_enable||begin_operation||result_write),.GCLK(result_clock));
   for(genvar bit_index=group*8;bit_index<L&&bit_index<group*8+8;bit_index=bit_index+1)begin:bit_bank
     always @(posedge result_clock)begin
       if(rst)next_bits[bit_index]<=0;
       else if(begin_operation)next_bits[bit_index]<=current[BASE+bit_index];
       else if((phase==SAMPLE)&&(slot==bit_index))next_bits[bit_index]<=sampled_bit;
     end
   end
 end
 always @(posedge controller_clock) begin
   if(rst)begin phase<=IDLE;slot<=0;scoring<=0;end
   else case(phase)
     IDLE:if(active||score_active)begin
       slot<=0;scoring<=score_active;phase<=SCAN;
     end
     SCAN:if(scoring||selected)phase<=CALCULATE;else next_site();
     CALCULATE:if(scoring)next_site();else phase<=DECIDE;
     DECIDE:if(refresh)phase<=SAMPLE;else next_site();
     SAMPLE:next_site();
     READY:if(accept)phase<=IDLE;
     default:phase<=IDLE;
   endcase
 end
`ifndef SYNTHESIS
 always @(posedge clk) if(!rst) begin
   if(active||score_active) assert(configured) else $fatal(1,"A2 coefficients not loaded");
   if(phase==CALCULATE&&!scoring) assert(field_sum>=-10 && field_sum<=10)
     else $fatal(1,"A2 field exceeds configured bound");
   if(active) assert(context_id<R) else $fatal(1,"A2 replica out of range");
 end
`endif
endmodule

// One field/score lane. Each replica and site owns its LFSR and history.
module a2_cluster_384 #(parameter EPIX=1)(
 input wire clk,rst,test_enable,active,score_active,accept,
 input wire seed_we,cfg_we,
 input wire [15:0] seed_addr,
 input wire [9:0] cfg_addr,
 input wire [31:0] data_in,
 input wire [5:0] context_id,beta,
 input wire [1:0] color,
 input wire [2:0] sweep_tag,
 input wire [9:0] beta_sweep,
 input wire [511:0] current,
 input wire [127:0] dirty,
 output reg [127:0] next_bits,
 output wire ready,configured,
 output reg [15:0] fresh_count,
 output reg signed [15:0] score_value);
 localparam N=512,L=128,R=1,BASE=384,FW=5,TW=2,AGE=2;
 localparam IDLE=0,SCAN=1,CALCULATE=2,DECIDE=3,SAMPLE=4,READY=5;
 reg [2:0] phase;
 reg [6:0] slot;
 reg scoring;
 reg signed [FW-1:0] raw_value;
 wire nonnegative=raw_value>=0;
 wire [15:0] magnitude=nonnegative ? 16'($signed(raw_value)) : 16'(-$signed(raw_value));
 function automatic [31:0] probability(input logic [7:0] address);
begin
case(address)
8'd0: probability=32'h80000000;
8'd1: probability=32'h8feacc96;
8'd2: probability=32'h9f597ea7;
8'd3: probability=32'haddea7bd;
8'd4: probability=32'hbb26a7af;
8'd5: probability=32'hc6fd1fab;
8'd6: probability=32'hd14c8f95;
8'd7: probability=32'hda19942e;
8'd8: probability=32'he17bead4;
8'd9: probability=32'he7972d6f;
8'd10: probability=32'hec948eee;
8'd11: probability=32'hf09e294b;
8'd12: probability=32'hf3dbe5e2;
8'd13: probability=32'hf671bec0;
8'd14: probability=32'hf87efe60;
8'd15: probability=32'hfa1e27b4;
8'd16: probability=32'hfb654178;
8'd17: probability=32'hfc66537e;
8'd18: probability=32'hfd2ff5b1;
8'd19: probability=32'hfdcdddad;
8'd20: probability=32'hfe496098;
8'd21: probability=32'hfea9e4d3;
8'd22: probability=32'hfef5426c;
8'd23: probability=32'hff301337;
8'd24: probability=32'hff5df444;
8'd25: probability=32'hff81bac2;
8'd26: probability=32'hff9d9e57;
8'd27: probability=32'hffb35ae0;
8'd28: probability=32'hffc44b19;
8'd29: probability=32'hffd17db5;
8'd30: probability=32'hffdbc5ea;
8'd31: probability=32'hffe3c873;
8'd32: probability=32'hffea05c2;
8'd33: probability=32'hffeee1f4;
8'd34: probability=32'hfff2ab10;
8'd35: probability=32'hfff59de2;
8'd36: probability=32'hfff7e9c8;
8'd37: probability=32'hfff9b3ab;
8'd38: probability=32'hfffb184a;
8'd39: probability=32'hfffc2e09;
8'd40: probability=32'hfffd065a;
8'd41: probability=32'hfffdaed2;
8'd42: probability=32'hfffe3207;
8'd43: probability=32'hfffe9837;
8'd44: probability=32'hfffee7cc;
8'd45: probability=32'hffff25c7;
8'd46: probability=32'hffff560c;
8'd47: probability=32'hffff7ba4;
8'd48: probability=32'hffff98eb;
8'd49: probability=32'hffffafb8;
8'd50: probability=32'hffffc17a;
8'd51: probability=32'hffffcf4f;
8'd52: probability=32'hffffda14;
8'd53: probability=32'hffffe277;
8'd54: probability=32'hffffe900;
8'd55: probability=32'hffffee16;
8'd56: probability=32'hfffff20d;
8'd57: probability=32'hfffff523;
8'd58: probability=32'hfffff78a;
8'd59: probability=32'hfffff969;
8'd60: probability=32'hfffffade;
8'd61: probability=32'hfffffc01;
8'd62: probability=32'hfffffce3;
8'd63: probability=32'hfffffd93;
8'd64: probability=32'hfffffe1d;
8'd65: probability=32'hfffffe88;
8'd66: probability=32'hfffffedb;
8'd67: probability=32'hffffff1c;
8'd68: probability=32'hffffff4e;
8'd69: probability=32'hffffff76;
8'd70: probability=32'hffffff94;
8'd71: probability=32'hffffffac;
8'd72: probability=32'hffffffbf;
8'd73: probability=32'hffffffcd;
8'd74: probability=32'hffffffd8;
8'd75: probability=32'hffffffe1;
8'd76: probability=32'hffffffe8;
8'd77: probability=32'hffffffed;
8'd78: probability=32'hfffffff1;
8'd79: probability=32'hfffffff5;
8'd80: probability=32'hfffffff7;
8'd81: probability=32'hfffffff9;
8'd82: probability=32'hfffffffb;
8'd83: probability=32'hfffffffc;
8'd84: probability=32'hffffffff;
8'd85: probability=32'hffffffff;
8'd86: probability=32'hffffffff;
8'd87: probability=32'hffffffff;
8'd88: probability=32'hffffffff;
8'd89: probability=32'hffffffff;
8'd90: probability=32'hffffffff;
8'd91: probability=32'hffffffff;
8'd92: probability=32'hffffffff;
8'd93: probability=32'hffffffff;
8'd94: probability=32'hffffffff;
8'd95: probability=32'hffffffff;
8'd96: probability=32'hffffffff;
8'd97: probability=32'hffffffff;
8'd98: probability=32'hffffffff;
8'd99: probability=32'hffffffff;
8'd100: probability=32'hffffffff;
8'd101: probability=32'hffffffff;
8'd102: probability=32'hffffffff;
8'd103: probability=32'hffffffff;
8'd104: probability=32'hffffffff;
8'd105: probability=32'hffffffff;
8'd106: probability=32'hffffffff;
8'd107: probability=32'hffffffff;
8'd108: probability=32'hffffffff;
8'd109: probability=32'hffffffff;
8'd110: probability=32'hffffffff;
8'd111: probability=32'hffffffff;
8'd112: probability=32'hffffffff;
8'd113: probability=32'hffffffff;
8'd114: probability=32'hffffffff;
8'd115: probability=32'hffffffff;
8'd116: probability=32'hffffffff;
8'd117: probability=32'hffffffff;
8'd118: probability=32'hffffffff;
8'd119: probability=32'hffffffff;
8'd120: probability=32'hffffffff;
8'd121: probability=32'hffffffff;
8'd122: probability=32'hffffffff;
8'd123: probability=32'hffffffff;
8'd124: probability=32'hffffffff;
8'd125: probability=32'hffffffff;
8'd126: probability=32'hffffffff;
8'd127: probability=32'hffffffff;
default: probability=32'hffffffff;
endcase
end
endfunction
 function automatic [7:0] neighbors(input [6:0] node,input [511:0] bits); begin case(node)
0: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
1: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[391],bits[389]};
2: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[389],bits[388]};
3: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[391],bits[388]};
4: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[387],bits[386]};
5: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[386],bits[385]};
6: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
7: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[387],bits[385]};
8: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[399],bits[398],bits[396]};
9: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[397],bits[396],bits[329]};
10: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[398],bits[396]};
11: neighbors={1'b0,1'b0,1'b0,1'b0,bits[398],bits[397],bits[396],bits[331]};
12: neighbors={1'b0,1'b0,1'b0,1'b0,bits[395],bits[394],bits[393],bits[392]};
13: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[395],bits[393]};
14: neighbors={1'b0,1'b0,1'b0,1'b0,bits[406],bits[395],bits[394],bits[392]};
15: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[407],bits[392]};
16: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[406],bits[404]};
17: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[407],bits[406],bits[404]};
18: neighbors={1'b0,1'b0,1'b0,1'b0,bits[407],bits[406],bits[405],bits[404]};
19: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
20: neighbors={1'b0,1'b0,1'b0,1'b0,bits[412],bits[402],bits[401],bits[400]};
21: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[402]};
22: neighbors={1'b0,1'b0,1'b0,bits[414],bits[402],bits[401],bits[400],bits[398]};
23: neighbors={1'b0,1'b0,1'b0,1'b0,bits[415],bits[402],bits[401],bits[399]};
24: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[415],bits[412]};
25: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[414],bits[413],bits[412]};
26: neighbors={1'b0,1'b0,1'b0,1'b0,bits[415],bits[414],bits[413],bits[412]};
27: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[415],bits[412]};
28: neighbors={1'b0,1'b0,1'b0,bits[411],bits[410],bits[409],bits[408],bits[404]};
29: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[410],bits[409]};
30: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[410],bits[409],bits[406]};
31: neighbors={1'b0,1'b0,1'b0,1'b0,bits[411],bits[410],bits[408],bits[407]};
32: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[423],bits[420],bits[352]};
33: neighbors={1'b0,1'b0,1'b0,1'b0,bits[481],bits[423],bits[420],bits[353]};
34: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[422],bits[421]};
35: neighbors={1'b0,1'b0,1'b0,1'b0,bits[483],bits[423],bits[422],bits[421]};
36: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[417],bits[416]};
37: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[419],bits[418]};
38: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[430],bits[419],bits[418]};
39: neighbors={1'b0,1'b0,1'b0,1'b0,bits[431],bits[419],bits[417],bits[416]};
40: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[430],bits[429]};
41: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[431],bits[428]};
42: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[431],bits[429],bits[428]};
43: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
44: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[426],bits[425]};
45: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[426],bits[424]};
46: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[424],bits[422]};
47: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[426],bits[425],bits[423]};
48: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[438],bits[437],bits[436]};
49: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
50: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[438],bits[370]};
51: neighbors={1'b0,1'b0,1'b0,1'b0,bits[438],bits[437],bits[436],bits[371]};
52: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[435],bits[432]};
53: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[435],bits[432]};
54: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[435],bits[434],bits[432]};
55: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
56: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[504],bits[445]};
57: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[445],bits[377]};
58: neighbors={1'b0,1'b0,1'b0,1'b0,bits[506],bits[447],bits[445],bits[378]};
59: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[447],bits[445]};
60: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
61: neighbors={1'b0,1'b0,1'b0,1'b0,bits[443],bits[442],bits[441],bits[440]};
62: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
63: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[443],bits[442]};
64: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[455],bits[454],bits[453]};
65: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[455],bits[452]};
66: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[455],bits[454],bits[453]};
67: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[455],bits[453],bits[452]};
68: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[460],bits[451],bits[449]};
69: neighbors={1'b0,1'b0,1'b0,1'b0,bits[461],bits[451],bits[450],bits[448]};
70: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[450],bits[448]};
71: neighbors={1'b0,1'b0,1'b0,1'b0,bits[451],bits[450],bits[449],bits[448]};
72: neighbors={1'b0,1'b0,1'b0,1'b0,bits[463],bits[462],bits[461],bits[460]};
73: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[462],bits[461]};
74: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
75: neighbors={1'b0,1'b0,1'b0,1'b0,bits[463],bits[462],bits[461],bits[460]};
76: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[459],bits[456],bits[452]};
77: neighbors={1'b0,1'b0,1'b0,1'b0,bits[459],bits[457],bits[456],bits[453]};
78: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[459],bits[457],bits[456]};
79: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[459],bits[456]};
80: neighbors={1'b0,1'b0,1'b0,1'b0,bits[471],bits[470],bits[469],bits[468]};
81: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[471],bits[468]};
82: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[471],bits[470],bits[469]};
83: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[471],bits[470]};
84: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[465],bits[464]};
85: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[466],bits[464]};
86: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[467],bits[466],bits[464]};
87: neighbors={1'b0,1'b0,1'b0,1'b0,bits[467],bits[466],bits[465],bits[464]};
88: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[479],bits[477],bits[476]};
89: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[477]};
90: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[479],bits[477]};
91: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[479],bits[476]};
92: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[475],bits[472]};
93: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[474],bits[473],bits[472]};
94: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
95: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[475],bits[474],bits[472]};
96: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[486],bits[485]};
97: neighbors={1'b0,1'b0,1'b0,1'b0,bits[486],bits[485],bits[484],bits[417]};
98: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[487],bits[486]};
99: neighbors={1'b0,1'b0,1'b0,bits[487],bits[486],bits[485],bits[484],bits[419]};
100: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[483],bits[481]};
101: neighbors={1'b0,1'b0,1'b0,1'b0,bits[493],bits[483],bits[481],bits[480]};
102: neighbors={1'b0,1'b0,1'b0,1'b0,bits[483],bits[482],bits[481],bits[480]};
103: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[495],bits[483],bits[482]};
104: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[495],bits[494]};
105: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[494],bits[493]};
106: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[495],bits[494],bits[493]};
107: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[495],bits[493]};
108: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
109: neighbors={1'b0,1'b0,1'b0,1'b0,bits[491],bits[490],bits[489],bits[485]};
110: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[490],bits[489],bits[488]};
111: neighbors={1'b0,1'b0,1'b0,1'b0,bits[491],bits[490],bits[488],bits[487]};
112: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[502],bits[501],bits[500]};
113: neighbors={1'b0,1'b0,1'b0,1'b0,bits[503],bits[502],bits[501],bits[500]};
114: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
115: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[503],bits[500]};
116: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[499],bits[497],bits[496]};
117: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[497],bits[496]};
118: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[497],bits[496]};
119: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[499],bits[497]};
120: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[509],bits[508],bits[440]};
121: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[510],bits[509]};
122: neighbors={1'b0,1'b0,1'b0,1'b0,bits[511],bits[509],bits[508],bits[442]};
123: neighbors={1'b0,1'b0,1'b0,1'b0,bits[511],bits[510],bits[509],bits[508]};
124: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[507],bits[506],bits[504]};
125: neighbors={1'b0,1'b0,1'b0,1'b0,bits[507],bits[506],bits[505],bits[504]};
126: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[507],bits[505]};
127: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[507],bits[506]};
default: neighbors=0;endcase end endfunction
function automatic [7:0] present(input [6:0] node); begin case(node)
0: present=8'd0;
1: present=8'd3;
2: present=8'd3;
3: present=8'd3;
4: present=8'd3;
5: present=8'd3;
6: present=8'd0;
7: present=8'd3;
8: present=8'd7;
9: present=8'd7;
10: present=8'd3;
11: present=8'd15;
12: present=8'd15;
13: present=8'd3;
14: present=8'd15;
15: present=8'd3;
16: present=8'd3;
17: present=8'd7;
18: present=8'd15;
19: present=8'd0;
20: present=8'd15;
21: present=8'd1;
22: present=8'd31;
23: present=8'd15;
24: present=8'd3;
25: present=8'd7;
26: present=8'd15;
27: present=8'd3;
28: present=8'd31;
29: present=8'd3;
30: present=8'd7;
31: present=8'd15;
32: present=8'd7;
33: present=8'd15;
34: present=8'd3;
35: present=8'd15;
36: present=8'd3;
37: present=8'd3;
38: present=8'd7;
39: present=8'd15;
40: present=8'd3;
41: present=8'd3;
42: present=8'd7;
43: present=8'd0;
44: present=8'd3;
45: present=8'd3;
46: present=8'd3;
47: present=8'd7;
48: present=8'd7;
49: present=8'd0;
50: present=8'd3;
51: present=8'd15;
52: present=8'd3;
53: present=8'd3;
54: present=8'd7;
55: present=8'd0;
56: present=8'd3;
57: present=8'd3;
58: present=8'd15;
59: present=8'd3;
60: present=8'd0;
61: present=8'd15;
62: present=8'd0;
63: present=8'd3;
64: present=8'd7;
65: present=8'd3;
66: present=8'd7;
67: present=8'd7;
68: present=8'd7;
69: present=8'd15;
70: present=8'd3;
71: present=8'd15;
72: present=8'd15;
73: present=8'd3;
74: present=8'd0;
75: present=8'd15;
76: present=8'd7;
77: present=8'd15;
78: present=8'd7;
79: present=8'd3;
80: present=8'd15;
81: present=8'd3;
82: present=8'd7;
83: present=8'd3;
84: present=8'd3;
85: present=8'd3;
86: present=8'd7;
87: present=8'd15;
88: present=8'd7;
89: present=8'd1;
90: present=8'd3;
91: present=8'd3;
92: present=8'd3;
93: present=8'd7;
94: present=8'd0;
95: present=8'd7;
96: present=8'd3;
97: present=8'd15;
98: present=8'd3;
99: present=8'd31;
100: present=8'd3;
101: present=8'd15;
102: present=8'd15;
103: present=8'd7;
104: present=8'd3;
105: present=8'd3;
106: present=8'd7;
107: present=8'd3;
108: present=8'd0;
109: present=8'd15;
110: present=8'd7;
111: present=8'd15;
112: present=8'd7;
113: present=8'd15;
114: present=8'd0;
115: present=8'd3;
116: present=8'd7;
117: present=8'd3;
118: present=8'd3;
119: present=8'd3;
120: present=8'd7;
121: present=8'd3;
122: present=8'd15;
123: present=8'd15;
124: present=8'd7;
125: present=8'd15;
126: present=8'd3;
127: present=8'd3;
default: present=0;endcase end endfunction
function automatic [7:0] forward(input [6:0] node); begin case(node)
0: forward=8'd0;
1: forward=8'd3;
2: forward=8'd3;
3: forward=8'd3;
4: forward=8'd0;
5: forward=8'd0;
6: forward=8'd0;
7: forward=8'd0;
8: forward=8'd7;
9: forward=8'd6;
10: forward=8'd3;
11: forward=8'd14;
12: forward=8'd0;
13: forward=8'd0;
14: forward=8'd8;
15: forward=8'd2;
16: forward=8'd3;
17: forward=8'd7;
18: forward=8'd15;
19: forward=8'd0;
20: forward=8'd8;
21: forward=8'd0;
22: forward=8'd16;
23: forward=8'd8;
24: forward=8'd3;
25: forward=8'd7;
26: forward=8'd15;
27: forward=8'd3;
28: forward=8'd0;
29: forward=8'd0;
30: forward=8'd0;
31: forward=8'd0;
32: forward=8'd6;
33: forward=8'd14;
34: forward=8'd3;
35: forward=8'd15;
36: forward=8'd0;
37: forward=8'd0;
38: forward=8'd4;
39: forward=8'd8;
40: forward=8'd3;
41: forward=8'd3;
42: forward=8'd7;
43: forward=8'd0;
44: forward=8'd0;
45: forward=8'd0;
46: forward=8'd0;
47: forward=8'd0;
48: forward=8'd7;
49: forward=8'd0;
50: forward=8'd2;
51: forward=8'd14;
52: forward=8'd0;
53: forward=8'd0;
54: forward=8'd0;
55: forward=8'd0;
56: forward=8'd3;
57: forward=8'd2;
58: forward=8'd14;
59: forward=8'd3;
60: forward=8'd0;
61: forward=8'd0;
62: forward=8'd0;
63: forward=8'd0;
64: forward=8'd7;
65: forward=8'd3;
66: forward=8'd7;
67: forward=8'd7;
68: forward=8'd4;
69: forward=8'd8;
70: forward=8'd0;
71: forward=8'd0;
72: forward=8'd15;
73: forward=8'd3;
74: forward=8'd0;
75: forward=8'd15;
76: forward=8'd0;
77: forward=8'd0;
78: forward=8'd0;
79: forward=8'd0;
80: forward=8'd15;
81: forward=8'd3;
82: forward=8'd7;
83: forward=8'd3;
84: forward=8'd0;
85: forward=8'd0;
86: forward=8'd0;
87: forward=8'd0;
88: forward=8'd7;
89: forward=8'd1;
90: forward=8'd3;
91: forward=8'd3;
92: forward=8'd0;
93: forward=8'd0;
94: forward=8'd0;
95: forward=8'd0;
96: forward=8'd3;
97: forward=8'd14;
98: forward=8'd3;
99: forward=8'd30;
100: forward=8'd0;
101: forward=8'd8;
102: forward=8'd0;
103: forward=8'd4;
104: forward=8'd3;
105: forward=8'd3;
106: forward=8'd7;
107: forward=8'd3;
108: forward=8'd0;
109: forward=8'd0;
110: forward=8'd0;
111: forward=8'd0;
112: forward=8'd7;
113: forward=8'd15;
114: forward=8'd0;
115: forward=8'd3;
116: forward=8'd0;
117: forward=8'd0;
118: forward=8'd0;
119: forward=8'd0;
120: forward=8'd6;
121: forward=8'd3;
122: forward=8'd14;
123: forward=8'd15;
124: forward=8'd0;
125: forward=8'd0;
126: forward=8'd0;
127: forward=8'd0;
default: forward=0;endcase end endfunction
function automatic [1:0] node_color(input [6:0] node); begin case(node)
0: node_color=2'd0;
1: node_color=2'd0;
2: node_color=2'd0;
3: node_color=2'd0;
4: node_color=2'd1;
5: node_color=2'd1;
6: node_color=2'd1;
7: node_color=2'd1;
8: node_color=2'd1;
9: node_color=2'd1;
10: node_color=2'd1;
11: node_color=2'd1;
12: node_color=2'd0;
13: node_color=2'd0;
14: node_color=2'd0;
15: node_color=2'd0;
16: node_color=2'd0;
17: node_color=2'd0;
18: node_color=2'd0;
19: node_color=2'd0;
20: node_color=2'd1;
21: node_color=2'd1;
22: node_color=2'd1;
23: node_color=2'd1;
24: node_color=2'd1;
25: node_color=2'd1;
26: node_color=2'd1;
27: node_color=2'd1;
28: node_color=2'd0;
29: node_color=2'd0;
30: node_color=2'd0;
31: node_color=2'd0;
32: node_color=2'd0;
33: node_color=2'd0;
34: node_color=2'd0;
35: node_color=2'd0;
36: node_color=2'd1;
37: node_color=2'd1;
38: node_color=2'd1;
39: node_color=2'd1;
40: node_color=2'd1;
41: node_color=2'd1;
42: node_color=2'd1;
43: node_color=2'd1;
44: node_color=2'd0;
45: node_color=2'd0;
46: node_color=2'd0;
47: node_color=2'd0;
48: node_color=2'd0;
49: node_color=2'd0;
50: node_color=2'd0;
51: node_color=2'd0;
52: node_color=2'd1;
53: node_color=2'd1;
54: node_color=2'd1;
55: node_color=2'd1;
56: node_color=2'd1;
57: node_color=2'd1;
58: node_color=2'd1;
59: node_color=2'd1;
60: node_color=2'd0;
61: node_color=2'd0;
62: node_color=2'd0;
63: node_color=2'd0;
64: node_color=2'd1;
65: node_color=2'd1;
66: node_color=2'd1;
67: node_color=2'd1;
68: node_color=2'd0;
69: node_color=2'd0;
70: node_color=2'd0;
71: node_color=2'd0;
72: node_color=2'd0;
73: node_color=2'd0;
74: node_color=2'd0;
75: node_color=2'd0;
76: node_color=2'd1;
77: node_color=2'd1;
78: node_color=2'd1;
79: node_color=2'd1;
80: node_color=2'd1;
81: node_color=2'd1;
82: node_color=2'd1;
83: node_color=2'd1;
84: node_color=2'd0;
85: node_color=2'd0;
86: node_color=2'd0;
87: node_color=2'd0;
88: node_color=2'd0;
89: node_color=2'd0;
90: node_color=2'd0;
91: node_color=2'd0;
92: node_color=2'd1;
93: node_color=2'd1;
94: node_color=2'd1;
95: node_color=2'd1;
96: node_color=2'd1;
97: node_color=2'd1;
98: node_color=2'd1;
99: node_color=2'd1;
100: node_color=2'd0;
101: node_color=2'd0;
102: node_color=2'd0;
103: node_color=2'd0;
104: node_color=2'd0;
105: node_color=2'd0;
106: node_color=2'd0;
107: node_color=2'd0;
108: node_color=2'd1;
109: node_color=2'd1;
110: node_color=2'd1;
111: node_color=2'd1;
112: node_color=2'd1;
113: node_color=2'd1;
114: node_color=2'd1;
115: node_color=2'd1;
116: node_color=2'd0;
117: node_color=2'd0;
118: node_color=2'd0;
119: node_color=2'd0;
120: node_color=2'd0;
121: node_color=2'd0;
122: node_color=2'd0;
123: node_color=2'd0;
124: node_color=2'd1;
125: node_color=2'd1;
126: node_color=2'd1;
127: node_color=2'd1;
default: node_color=0;endcase end endfunction

 wire [31:0] threshold=probability(8'((magnitude*beta*4+2)/4>127 ? 127 : (magnitude*beta*4+2)/4));
 wire selected=node_color(slot)==color;
 wire configured_write=cfg_we && cfg_addr>=BASE && cfg_addr<BASE+L;
 reg [L-1:0] loaded;
 wire configuration_clock,controller_clock;
 sky130_fd_sc_hd__dlclkp_1 configuration_gate(.CLK(clk),.GATE(rst||test_enable||configured_write),.GCLK(configuration_clock));
 sky130_fd_sc_hd__dlclkp_1 controller_gate(.CLK(clk),.GATE(rst||test_enable||active||score_active||(phase!=IDLE)),.GCLK(controller_clock));
 always @(posedge configuration_clock) begin
   if(rst) loaded<=0;
   else if(configured_write) loaded[7'(cfg_addr-BASE)]<=1'b1;
 end
 assign configured=&loaded;
 wire [39:0] coefficients;
 wire read_coeff=(phase==SCAN)&&(scoring||selected);
 a2_coefficient_memory #(.WORDS(128)) coefficient_memory(
   .clk(clk),.access(configured_write||read_coeff),
   .write_enable(configured_write),
   .address(configured_write ? 8'(cfg_addr-BASE) : {1'b0,slot}),
   .write_data({8'b0,data_in}),.mask(2'b11),.read_data(coefficients));
 wire [7:0] neighbor_bits=neighbors(slot,current);
 wire [7:0] edge_present=present(slot),edge_forward=forward(slot);
 reg signed [15:0] field_sum,row_cut;
 reg signed [15:0] weight;
 always_comb begin
   field_sum=0;row_cut=0;weight=0;
   // Run field arithmetic only after a coefficient read.
   if(phase==CALCULATE) for(integer e=0;e<8;e=e+1) begin
     weight={{12{coefficients[4*e+3]}},coefficients[4*e+:4]};
     if(edge_present[e]) begin
       if(!scoring)field_sum=field_sum+(neighbor_bits[e] ? -weight : weight);
       if(scoring&&edge_forward[e]&&(current[BASE+slot]!=neighbor_bits[e])) row_cut=row_cut+weight;
     end
   end
 end
 wire [31:0] retained [0:R*L-1];
 wire signed [FW-1:0] fields [0:R*L-1];
 wire [TW-1:0] tags [0:R*L-1];
 localparam CW=$clog2(R*L+1);
 wire [CW-1:0] address=CW'(context_id*L+slot);
 wire [TW-1:0] age=TW'(sweep_tag)-tags[address];
 wire signed [FW-1:0] saved_raw=fields[address];
 wire [5:0] saved_beta=beta-6'((beta>1)&&(beta_sweep<age));
 wire changed=16'($signed(saved_raw))*16'($signed({1'b0,saved_beta}))!=16'($signed(raw_value))*16'($signed({1'b0,beta}));
 wire refresh=!EPIX||dirty[slot]||(age>AGE)||current[BASE+slot]!=nonnegative||changed;
 // Each replica and p-bit has separate LFSR state and feedback logic.
 for(genvar r=0;r<R;r=r+1) begin:replica_bank
   wire replica_clock;
   wire seed_replica=seed_we&&(seed_addr>=r*N+BASE)&&(seed_addr<r*N+BASE+L);
   wire fresh_replica=(phase==SAMPLE)&&(context_id==r);
   // Stop the clock upstream of inactive replicas.
   sky130_fd_sc_hd__dlclkp_1 replica_gate(.CLK(clk),
     .GATE(rst||test_enable||seed_replica||fresh_replica),.GCLK(replica_clock));
   for(genvar i=0;i<L;i=i+1) begin:site_bank
     wire seeded=seed_we&&(seed_addr==r*N+BASE+i);
     wire consume=(phase==SAMPLE)&&(context_id==r)&&(slot==i);
     wire rng_clock;
     reg [31:0] state;
     function automatic [31:0] advance(input [31:0] x0);
       reg [31:0] x;
       begin
         x=x0;
         for(integer k=0;k<32;k=k+1)x={x[30:0],~(x[31]^x[21]^x[1]^x[0])};
         advance=x;
       end
     endfunction
     // Holding LFSR state also holds its feedback logic. Keep consume out of this path.
     wire [31:0] evolved=advance(state);
     sky130_fd_sc_hd__dlclkp_1 gate(.CLK(replica_clock),.GATE(rst||test_enable||seeded||consume),.GCLK(rng_clock));
     always @(posedge rng_clock) begin
       if(rst) state<=0;
       else if(seeded) state<=(data_in==32'hffffffff)?32'b0:data_in;
       else if(consume) state<=evolved;
     end
     // SAMPLE reads the next random word. Reuse holds the spin.
     assign retained[r*L+i]=evolved;
     if(EPIX) begin:metadata
       reg signed [FW-1:0] saved_field;
       reg [TW-1:0] saved_tag;
       always @(posedge rng_clock) begin
         if(rst)begin saved_field<=0;saved_tag<=0;end
         else if(consume)begin saved_field<=raw_value;saved_tag<=TW'(sweep_tag);end
       end
       assign fields[r*L+i]=saved_field;
       assign tags[r*L+i]=saved_tag;
     end else begin
       assign fields[r*L+i]=0;
       assign tags[r*L+i]=0;
     end
   end
 end
 // Save the RNG address one cycle before a fresh sample. Hold it during reuse.
 reg [CW-1:0] rng_address;
 wire rng_address_clock;
 wire fresh_request=(phase==DECIDE)&&refresh;
 sky130_fd_sc_hd__dlclkp_1 rng_address_gate(.CLK(clk),
   .GATE(rst||test_enable||fresh_request),.GCLK(rng_address_clock));
 always @(posedge rng_address_clock) begin
   if(rst)rng_address<=0;
   else if(fresh_request)rng_address<=address;
 end
 wire [31:0] random_word=retained[rng_address];
`ifndef SYNTHESIS
 always @(posedge clk) if(!rst&&phase==SAMPLE)
   assert(rng_address==address) else $fatal(1,"RNG read address mismatch");
`endif
 wire sampled_bit=nonnegative ? threshold>random_word : random_word>threshold;
 assign ready=phase==READY;
 task automatic next_site;
   begin
     if(slot==L-1)phase<=READY;
     else begin slot<=slot+1'b1;phase<=SCAN;end
   end
 endtask
 // Clock each data bank only when needed.
 wire begin_operation=(phase==IDLE)&&(active||score_active);
 wire raw_write=(phase==CALCULATE)&&!scoring;
 wire score_write=((phase==CALCULATE)&&scoring)||
                  ((phase==SAMPLE)&&(sampled_bit!=current[BASE+slot]));
 wire raw_clock,count_clock,score_clock;
 sky130_fd_sc_hd__dlclkp_1 raw_gate(.CLK(clk),
   .GATE(rst||test_enable||raw_write),.GCLK(raw_clock));
 sky130_fd_sc_hd__dlclkp_1 count_gate(.CLK(clk),
   .GATE(rst||test_enable||begin_operation||(phase==SAMPLE)),.GCLK(count_clock));
 sky130_fd_sc_hd__dlclkp_1 score_gate(.CLK(clk),
   .GATE(rst||test_enable||begin_operation||score_write),.GCLK(score_clock));
 always @(posedge raw_clock) begin
   if(rst)raw_value<=0;
   else if(raw_write)raw_value<=FW'(field_sum);
 end
 always @(posedge count_clock) begin
   if(rst||begin_operation)fresh_count<=0;
   else if(phase==SAMPLE)fresh_count<=fresh_count+1'b1;
 end
 always @(posedge score_clock) begin
   if(rst||begin_operation)score_value<=0;
   else if((phase==CALCULATE)&&scoring)score_value<=score_value+row_cut;
   else if((phase==SAMPLE)&&(sampled_bit!=current[BASE+slot]))
     score_value<=score_value+(current[BASE+slot] ? -16'($signed(raw_value)) : 16'($signed(raw_value)));
 end
 // Eight result bits share one gate. Clock only the selected group.
 for(genvar group=0;group<(L+7)/8;group=group+1)begin:result_group
   wire result_clock;
   wire result_write=(phase==SAMPLE)&&(slot>=group*8)&&(slot<group*8+8);
   sky130_fd_sc_hd__dlclkp_1 gate(.CLK(clk),
     .GATE(rst||test_enable||begin_operation||result_write),.GCLK(result_clock));
   for(genvar bit_index=group*8;bit_index<L&&bit_index<group*8+8;bit_index=bit_index+1)begin:bit_bank
     always @(posedge result_clock)begin
       if(rst)next_bits[bit_index]<=0;
       else if(begin_operation)next_bits[bit_index]<=current[BASE+bit_index];
       else if((phase==SAMPLE)&&(slot==bit_index))next_bits[bit_index]<=sampled_bit;
     end
   end
 end
 always @(posedge controller_clock) begin
   if(rst)begin phase<=IDLE;slot<=0;scoring<=0;end
   else case(phase)
     IDLE:if(active||score_active)begin
       slot<=0;scoring<=score_active;phase<=SCAN;
     end
     SCAN:if(scoring||selected)phase<=CALCULATE;else next_site();
     CALCULATE:if(scoring)next_site();else phase<=DECIDE;
     DECIDE:if(refresh)phase<=SAMPLE;else next_site();
     SAMPLE:next_site();
     READY:if(accept)phase<=IDLE;
     default:phase<=IDLE;
   endcase
 end
`ifndef SYNTHESIS
 always @(posedge clk) if(!rst) begin
   if(active||score_active) assert(configured) else $fatal(1,"A2 coefficients not loaded");
   if(phase==CALCULATE&&!scoring) assert(field_sum>=-10 && field_sum<=10)
     else $fatal(1,"A2 field exceeds configured bound");
   if(active) assert(context_id<R) else $fatal(1,"A2 replica out of range");
 end
`endif
endmodule
