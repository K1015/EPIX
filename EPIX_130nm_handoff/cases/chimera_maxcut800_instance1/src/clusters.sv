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
 input wire [799:0] current,
 input wire [127:0] dirty,
 output reg [127:0] next_bits,
 output wire ready,configured,
 output reg [15:0] fresh_count,
 output reg signed [15:0] score_value);
 localparam N=800,L=128,R=1,BASE=0,FW=5,TW=2,AGE=2;
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
 function automatic [7:0] neighbors(input [6:0] node,input [799:0] bits); begin case(node)
0: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[80],bits[7],bits[6]};
1: neighbors={1'b0,1'b0,1'b0,1'b0,bits[81],bits[7],bits[5],bits[4]};
2: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[6],bits[5],bits[4]};
3: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[5]};
4: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[2],bits[1]};
5: neighbors={1'b0,1'b0,1'b0,1'b0,bits[13],bits[3],bits[2],bits[1]};
6: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[14],bits[2],bits[0]};
7: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[15],bits[1],bits[0]};
8: neighbors={1'b0,1'b0,1'b0,1'b0,bits[15],bits[14],bits[13],bits[12]};
9: neighbors={1'b0,1'b0,1'b0,1'b0,bits[15],bits[14],bits[13],bits[12]};
10: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[14]};
11: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[15],bits[14],bits[13]};
12: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[9],bits[8]};
13: neighbors={1'b0,1'b0,1'b0,1'b0,bits[11],bits[9],bits[8],bits[5]};
14: neighbors={1'b0,1'b0,1'b0,bits[11],bits[10],bits[9],bits[8],bits[6]};
15: neighbors={1'b0,1'b0,1'b0,1'b0,bits[11],bits[9],bits[8],bits[7]};
16: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[23],bits[22],bits[20]};
17: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[23],bits[22],bits[20]};
18: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[22],bits[21],bits[20]};
19: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[22],bits[21]};
20: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[18],bits[17],bits[16]};
21: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[19],bits[18]};
22: neighbors={1'b0,1'b0,1'b0,1'b0,bits[19],bits[18],bits[17],bits[16]};
23: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[17],bits[16]};
24: neighbors={1'b0,1'b0,1'b0,1'b0,bits[104],bits[30],bits[29],bits[28]};
25: neighbors={1'b0,1'b0,1'b0,1'b0,bits[105],bits[30],bits[29],bits[28]};
26: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[106],bits[31]};
27: neighbors={1'b0,1'b0,1'b0,1'b0,bits[107],bits[31],bits[29],bits[28]};
28: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[27],bits[25],bits[24]};
29: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[27],bits[25],bits[24]};
30: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[25],bits[24]};
31: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[27],bits[26]};
32: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[39],bits[38],bits[36]};
33: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[39],bits[36]};
34: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[39],bits[38],bits[36]};
35: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[39],bits[37]};
36: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[34],bits[33],bits[32]};
37: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[35]};
38: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[46],bits[34],bits[32]};
39: neighbors={1'b0,1'b0,1'b0,bits[47],bits[35],bits[34],bits[33],bits[32]};
40: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[120],bits[46],bits[45]};
41: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[46],bits[45],bits[44]};
42: neighbors={1'b0,1'b0,1'b0,bits[122],bits[47],bits[46],bits[45],bits[44]};
43: neighbors={1'b0,1'b0,1'b0,bits[123],bits[47],bits[46],bits[45],bits[44]};
44: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[43],bits[42],bits[41]};
45: neighbors={1'b0,1'b0,1'b0,1'b0,bits[43],bits[42],bits[41],bits[40]};
46: neighbors={1'b0,1'b0,1'b0,bits[43],bits[42],bits[41],bits[40],bits[38]};
47: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[43],bits[42],bits[39]};
48: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[55],bits[53],bits[52]};
49: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[54],bits[53]};
50: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[55],bits[52]};
51: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[54],bits[52]};
52: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[51],bits[50],bits[48]};
53: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[49],bits[48]};
54: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[51],bits[49]};
55: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[50],bits[48]};
56: neighbors={1'b0,1'b0,1'b0,1'b0,bits[136],bits[63],bits[61],bits[60]};
57: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[63],bits[60]};
58: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[63],bits[61]};
59: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[139],bits[63],bits[60]};
60: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[59],bits[57],bits[56]};
61: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[58],bits[56]};
62: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
63: neighbors={1'b0,1'b0,1'b0,1'b0,bits[59],bits[58],bits[57],bits[56]};
64: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[144],bits[71],bits[70]};
65: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[71],bits[68]};
66: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
67: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[147],bits[70],bits[68]};
68: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[67],bits[65]};
69: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
70: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[67],bits[64]};
71: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[65],bits[64]};
72: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[77],bits[76]};
73: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[78],bits[76]};
74: neighbors={1'b0,1'b0,1'b0,1'b0,bits[79],bits[78],bits[77],bits[76]};
75: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[79],bits[78],bits[76]};
76: neighbors={1'b0,1'b0,1'b0,1'b0,bits[75],bits[74],bits[73],bits[72]};
77: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[74],bits[72]};
78: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[75],bits[74],bits[73]};
79: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[75],bits[74]};
80: neighbors={1'b0,1'b0,1'b0,1'b0,bits[87],bits[86],bits[85],bits[0]};
81: neighbors={1'b0,1'b0,1'b0,1'b0,bits[161],bits[86],bits[85],bits[1]};
82: neighbors={1'b0,1'b0,1'b0,1'b0,bits[162],bits[87],bits[86],bits[84]};
83: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[86],bits[84]};
84: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[92],bits[83],bits[82]};
85: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[81],bits[80]};
86: neighbors={1'b0,1'b0,1'b0,bits[94],bits[83],bits[82],bits[81],bits[80]};
87: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[95],bits[82],bits[80]};
88: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[168],bits[94],bits[92]};
89: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[95],bits[94]};
90: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[170],bits[95],bits[92]};
91: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
92: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[90],bits[88],bits[84]};
93: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
94: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[89],bits[88],bits[86]};
95: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[90],bits[89],bits[87]};
96: neighbors={1'b0,1'b0,1'b0,1'b0,bits[176],bits[103],bits[101],bits[100]};
97: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[177],bits[100]};
98: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
99: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[100]};
100: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[99],bits[97],bits[96]};
101: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[96]};
102: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
103: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[96]};
104: neighbors={1'b0,1'b0,1'b0,1'b0,bits[110],bits[109],bits[108],bits[24]};
105: neighbors={1'b0,1'b0,1'b0,1'b0,bits[110],bits[109],bits[108],bits[25]};
106: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[110],bits[26]};
107: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[110],bits[109],bits[27]};
108: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[105],bits[104]};
109: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[107],bits[105],bits[104]};
110: neighbors={1'b0,1'b0,1'b0,1'b0,bits[107],bits[106],bits[105],bits[104]};
111: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
112: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[119],bits[118],bits[117]};
113: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[118],bits[117]};
114: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
115: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[118],bits[117]};
116: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
117: neighbors={1'b0,1'b0,1'b0,1'b0,bits[125],bits[115],bits[113],bits[112]};
118: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[115],bits[113],bits[112]};
119: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[127],bits[112]};
120: neighbors={1'b0,1'b0,1'b0,bits[127],bits[126],bits[125],bits[124],bits[40]};
121: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[126],bits[124]};
122: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[127],bits[42]};
123: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[126],bits[124],bits[43]};
124: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[123],bits[121],bits[120]};
125: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[120],bits[117]};
126: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[123],bits[121],bits[120]};
127: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[122],bits[120],bits[119]};
default: neighbors=0;endcase end endfunction
function automatic [7:0] present(input [6:0] node); begin case(node)
0: present=8'd7;
1: present=8'd15;
2: present=8'd7;
3: present=8'd1;
4: present=8'd3;
5: present=8'd15;
6: present=8'd7;
7: present=8'd7;
8: present=8'd15;
9: present=8'd15;
10: present=8'd1;
11: present=8'd7;
12: present=8'd3;
13: present=8'd15;
14: present=8'd31;
15: present=8'd15;
16: present=8'd7;
17: present=8'd7;
18: present=8'd7;
19: present=8'd3;
20: present=8'd7;
21: present=8'd3;
22: present=8'd15;
23: present=8'd3;
24: present=8'd15;
25: present=8'd15;
26: present=8'd3;
27: present=8'd15;
28: present=8'd7;
29: present=8'd7;
30: present=8'd3;
31: present=8'd3;
32: present=8'd7;
33: present=8'd3;
34: present=8'd7;
35: present=8'd3;
36: present=8'd7;
37: present=8'd1;
38: present=8'd7;
39: present=8'd31;
40: present=8'd7;
41: present=8'd7;
42: present=8'd31;
43: present=8'd31;
44: present=8'd7;
45: present=8'd15;
46: present=8'd31;
47: present=8'd7;
48: present=8'd7;
49: present=8'd3;
50: present=8'd3;
51: present=8'd3;
52: present=8'd7;
53: present=8'd3;
54: present=8'd3;
55: present=8'd3;
56: present=8'd15;
57: present=8'd3;
58: present=8'd3;
59: present=8'd7;
60: present=8'd7;
61: present=8'd3;
62: present=8'd0;
63: present=8'd15;
64: present=8'd7;
65: present=8'd3;
66: present=8'd0;
67: present=8'd7;
68: present=8'd3;
69: present=8'd0;
70: present=8'd3;
71: present=8'd3;
72: present=8'd3;
73: present=8'd3;
74: present=8'd15;
75: present=8'd7;
76: present=8'd15;
77: present=8'd3;
78: present=8'd7;
79: present=8'd3;
80: present=8'd15;
81: present=8'd15;
82: present=8'd15;
83: present=8'd3;
84: present=8'd7;
85: present=8'd3;
86: present=8'd31;
87: present=8'd7;
88: present=8'd7;
89: present=8'd3;
90: present=8'd7;
91: present=8'd0;
92: present=8'd7;
93: present=8'd0;
94: present=8'd7;
95: present=8'd7;
96: present=8'd15;
97: present=8'd3;
98: present=8'd0;
99: present=8'd1;
100: present=8'd7;
101: present=8'd1;
102: present=8'd0;
103: present=8'd1;
104: present=8'd15;
105: present=8'd15;
106: present=8'd3;
107: present=8'd7;
108: present=8'd3;
109: present=8'd7;
110: present=8'd15;
111: present=8'd0;
112: present=8'd7;
113: present=8'd3;
114: present=8'd0;
115: present=8'd3;
116: present=8'd0;
117: present=8'd15;
118: present=8'd7;
119: present=8'd3;
120: present=8'd31;
121: present=8'd3;
122: present=8'd3;
123: present=8'd7;
124: present=8'd7;
125: present=8'd3;
126: present=8'd7;
127: present=8'd7;
default: present=0;endcase end endfunction
function automatic [7:0] forward(input [6:0] node); begin case(node)
0: forward=8'd7;
1: forward=8'd15;
2: forward=8'd7;
3: forward=8'd1;
4: forward=8'd0;
5: forward=8'd8;
6: forward=8'd4;
7: forward=8'd4;
8: forward=8'd15;
9: forward=8'd15;
10: forward=8'd1;
11: forward=8'd7;
12: forward=8'd0;
13: forward=8'd0;
14: forward=8'd0;
15: forward=8'd0;
16: forward=8'd7;
17: forward=8'd7;
18: forward=8'd7;
19: forward=8'd3;
20: forward=8'd0;
21: forward=8'd0;
22: forward=8'd0;
23: forward=8'd0;
24: forward=8'd15;
25: forward=8'd15;
26: forward=8'd3;
27: forward=8'd15;
28: forward=8'd0;
29: forward=8'd0;
30: forward=8'd0;
31: forward=8'd0;
32: forward=8'd7;
33: forward=8'd3;
34: forward=8'd7;
35: forward=8'd3;
36: forward=8'd0;
37: forward=8'd0;
38: forward=8'd4;
39: forward=8'd16;
40: forward=8'd7;
41: forward=8'd7;
42: forward=8'd31;
43: forward=8'd31;
44: forward=8'd0;
45: forward=8'd0;
46: forward=8'd0;
47: forward=8'd0;
48: forward=8'd7;
49: forward=8'd3;
50: forward=8'd3;
51: forward=8'd3;
52: forward=8'd0;
53: forward=8'd0;
54: forward=8'd0;
55: forward=8'd0;
56: forward=8'd15;
57: forward=8'd3;
58: forward=8'd3;
59: forward=8'd7;
60: forward=8'd0;
61: forward=8'd0;
62: forward=8'd0;
63: forward=8'd0;
64: forward=8'd7;
65: forward=8'd3;
66: forward=8'd0;
67: forward=8'd7;
68: forward=8'd0;
69: forward=8'd0;
70: forward=8'd0;
71: forward=8'd0;
72: forward=8'd3;
73: forward=8'd3;
74: forward=8'd15;
75: forward=8'd7;
76: forward=8'd0;
77: forward=8'd0;
78: forward=8'd0;
79: forward=8'd0;
80: forward=8'd14;
81: forward=8'd14;
82: forward=8'd15;
83: forward=8'd3;
84: forward=8'd4;
85: forward=8'd0;
86: forward=8'd16;
87: forward=8'd4;
88: forward=8'd7;
89: forward=8'd3;
90: forward=8'd7;
91: forward=8'd0;
92: forward=8'd0;
93: forward=8'd0;
94: forward=8'd0;
95: forward=8'd0;
96: forward=8'd15;
97: forward=8'd3;
98: forward=8'd0;
99: forward=8'd1;
100: forward=8'd0;
101: forward=8'd0;
102: forward=8'd0;
103: forward=8'd0;
104: forward=8'd14;
105: forward=8'd14;
106: forward=8'd2;
107: forward=8'd6;
108: forward=8'd0;
109: forward=8'd0;
110: forward=8'd0;
111: forward=8'd0;
112: forward=8'd7;
113: forward=8'd3;
114: forward=8'd0;
115: forward=8'd3;
116: forward=8'd0;
117: forward=8'd8;
118: forward=8'd0;
119: forward=8'd2;
120: forward=8'd30;
121: forward=8'd3;
122: forward=8'd2;
123: forward=8'd6;
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
64: node_color=2'd0;
65: node_color=2'd0;
66: node_color=2'd0;
67: node_color=2'd0;
68: node_color=2'd1;
69: node_color=2'd1;
70: node_color=2'd1;
71: node_color=2'd1;
72: node_color=2'd1;
73: node_color=2'd1;
74: node_color=2'd1;
75: node_color=2'd1;
76: node_color=2'd0;
77: node_color=2'd0;
78: node_color=2'd0;
79: node_color=2'd0;
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
   if(phase==CALCULATE&&!scoring) assert(field_sum>=-12 && field_sum<=12)
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
 input wire [799:0] current,
 input wire [127:0] dirty,
 output reg [127:0] next_bits,
 output wire ready,configured,
 output reg [15:0] fresh_count,
 output reg signed [15:0] score_value);
 localparam N=800,L=128,R=1,BASE=128,FW=5,TW=2,AGE=2;
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
 function automatic [7:0] neighbors(input [6:0] node,input [799:0] bits); begin case(node)
0: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
1: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[134],bits[132]};
2: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
3: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[134],bits[133],bits[132]};
4: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[131],bits[129]};
5: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[141],bits[131]};
6: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[142],bits[131],bits[129]};
7: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
8: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[142],bits[56]};
9: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
10: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[142],bits[141]};
11: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[142],bits[141],bits[59]};
12: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
13: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[139],bits[138],bits[133]};
14: neighbors={1'b0,1'b0,1'b0,1'b0,bits[139],bits[138],bits[136],bits[134]};
15: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
16: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[151],bits[64]};
17: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[151],bits[149],bits[148]};
18: neighbors={1'b0,1'b0,1'b0,1'b0,bits[151],bits[150],bits[149],bits[148]};
19: neighbors={1'b0,1'b0,1'b0,1'b0,bits[151],bits[150],bits[149],bits[67]};
20: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[146],bits[145]};
21: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[147],bits[146],bits[145]};
22: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[147],bits[146]};
23: neighbors={1'b0,1'b0,1'b0,1'b0,bits[147],bits[146],bits[145],bits[144]};
24: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
25: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
26: neighbors={1'b0,1'b0,1'b0,1'b0,bits[234],bits[159],bits[157],bits[156]};
27: neighbors={1'b0,1'b0,1'b0,1'b0,bits[235],bits[159],bits[157],bits[156]};
28: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[155],bits[154]};
29: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[155],bits[154]};
30: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
31: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[155],bits[154]};
32: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[167],bits[164]};
33: neighbors={1'b0,1'b0,1'b0,1'b0,bits[167],bits[166],bits[164],bits[81]};
34: neighbors={1'b0,1'b0,1'b0,1'b0,bits[167],bits[166],bits[164],bits[82]};
35: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
36: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[162],bits[161],bits[160]};
37: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
38: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[162],bits[161]};
39: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[162],bits[161],bits[160]};
40: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[173],bits[88]};
41: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[175],bits[174]};
42: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[173],bits[90]};
43: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[175],bits[174]};
44: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
45: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[170],bits[168]};
46: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[171],bits[169]};
47: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[171],bits[169]};
48: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[180],bits[96]};
49: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[182],bits[97]};
50: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[183],bits[182],bits[181]};
51: neighbors={1'b0,1'b0,1'b0,1'b0,bits[183],bits[182],bits[181],bits[180]};
52: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[179],bits[176]};
53: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[179],bits[178]};
54: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[179],bits[178],bits[177]};
55: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[179],bits[178]};
56: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
57: neighbors={1'b0,1'b0,1'b0,1'b0,bits[265],bits[190],bits[189],bits[188]};
58: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[190],bits[189]};
59: neighbors={1'b0,1'b0,1'b0,1'b0,bits[267],bits[191],bits[189],bits[188]};
60: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[187],bits[185]};
61: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[187],bits[186],bits[185]};
62: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[186],bits[185]};
63: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[187]};
64: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[199],bits[196]};
65: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[199],bits[198],bits[196]};
66: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[199],bits[198]};
67: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[199],bits[198]};
68: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[204],bits[193],bits[192]};
69: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
70: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[195],bits[194],bits[193]};
71: neighbors={1'b0,1'b0,1'b0,bits[207],bits[195],bits[194],bits[193],bits[192]};
72: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[280],bits[205],bits[204]};
73: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
74: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[282],bits[205],bits[204]};
75: neighbors={1'b0,1'b0,1'b0,1'b0,bits[283],bits[207],bits[205],bits[204]};
76: neighbors={1'b0,1'b0,1'b0,1'b0,bits[203],bits[202],bits[200],bits[196]};
77: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[203],bits[202],bits[200]};
78: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
79: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[203],bits[199]};
80: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[213],bits[212]};
81: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[214],bits[213],bits[212]};
82: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[213],bits[212]};
83: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
84: neighbors={1'b0,1'b0,1'b0,1'b0,bits[220],bits[210],bits[209],bits[208]};
85: neighbors={1'b0,1'b0,1'b0,1'b0,bits[221],bits[210],bits[209],bits[208]};
86: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[222],bits[209]};
87: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
88: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
89: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[222],bits[221]};
90: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[222],bits[220]};
91: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[222],bits[221],bits[220]};
92: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[219],bits[218],bits[212]};
93: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[219],bits[217],bits[213]};
94: neighbors={1'b0,1'b0,1'b0,1'b0,bits[219],bits[218],bits[217],bits[214]};
95: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
96: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[229],bits[228]};
97: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
98: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
99: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[229],bits[228]};
100: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[227],bits[224]};
101: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[227],bits[224]};
102: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
103: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
104: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
105: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
106: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[238],bits[154]};
107: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[238],bits[155]};
108: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
109: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
110: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[235],bits[234]};
111: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
112: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[320],bits[244]};
113: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
114: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[247],bits[246],bits[244]};
115: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[323],bits[246]};
116: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[242],bits[240]};
117: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
118: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[254],bits[243],bits[242]};
119: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[255],bits[242]};
120: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[255],bits[254],bits[253]};
121: neighbors={1'b0,1'b0,1'b0,1'b0,bits[255],bits[254],bits[253],bits[252]};
122: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[254],bits[253],bits[252]};
123: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[255],bits[252]};
124: neighbors={1'b0,1'b0,1'b0,1'b0,bits[260],bits[251],bits[250],bits[249]};
125: neighbors={1'b0,1'b0,1'b0,1'b0,bits[261],bits[250],bits[249],bits[248]};
126: neighbors={1'b0,1'b0,1'b0,1'b0,bits[250],bits[249],bits[248],bits[246]};
127: neighbors={1'b0,1'b0,1'b0,1'b0,bits[251],bits[249],bits[248],bits[247]};
default: neighbors=0;endcase end endfunction
function automatic [7:0] present(input [6:0] node); begin case(node)
0: present=8'd0;
1: present=8'd3;
2: present=8'd0;
3: present=8'd7;
4: present=8'd3;
5: present=8'd3;
6: present=8'd7;
7: present=8'd0;
8: present=8'd3;
9: present=8'd0;
10: present=8'd3;
11: present=8'd7;
12: present=8'd0;
13: present=8'd7;
14: present=8'd15;
15: present=8'd0;
16: present=8'd3;
17: present=8'd7;
18: present=8'd15;
19: present=8'd15;
20: present=8'd3;
21: present=8'd7;
22: present=8'd3;
23: present=8'd15;
24: present=8'd0;
25: present=8'd0;
26: present=8'd15;
27: present=8'd15;
28: present=8'd3;
29: present=8'd3;
30: present=8'd0;
31: present=8'd3;
32: present=8'd3;
33: present=8'd15;
34: present=8'd15;
35: present=8'd0;
36: present=8'd7;
37: present=8'd0;
38: present=8'd3;
39: present=8'd7;
40: present=8'd3;
41: present=8'd3;
42: present=8'd3;
43: present=8'd3;
44: present=8'd0;
45: present=8'd3;
46: present=8'd3;
47: present=8'd3;
48: present=8'd3;
49: present=8'd3;
50: present=8'd7;
51: present=8'd15;
52: present=8'd3;
53: present=8'd3;
54: present=8'd7;
55: present=8'd3;
56: present=8'd0;
57: present=8'd15;
58: present=8'd3;
59: present=8'd15;
60: present=8'd3;
61: present=8'd7;
62: present=8'd3;
63: present=8'd1;
64: present=8'd3;
65: present=8'd7;
66: present=8'd3;
67: present=8'd3;
68: present=8'd7;
69: present=8'd0;
70: present=8'd7;
71: present=8'd31;
72: present=8'd7;
73: present=8'd0;
74: present=8'd7;
75: present=8'd15;
76: present=8'd15;
77: present=8'd7;
78: present=8'd0;
79: present=8'd3;
80: present=8'd3;
81: present=8'd7;
82: present=8'd3;
83: present=8'd0;
84: present=8'd15;
85: present=8'd15;
86: present=8'd3;
87: present=8'd0;
88: present=8'd0;
89: present=8'd3;
90: present=8'd3;
91: present=8'd7;
92: present=8'd7;
93: present=8'd7;
94: present=8'd15;
95: present=8'd0;
96: present=8'd3;
97: present=8'd0;
98: present=8'd0;
99: present=8'd3;
100: present=8'd3;
101: present=8'd3;
102: present=8'd0;
103: present=8'd0;
104: present=8'd0;
105: present=8'd0;
106: present=8'd3;
107: present=8'd3;
108: present=8'd0;
109: present=8'd0;
110: present=8'd3;
111: present=8'd0;
112: present=8'd3;
113: present=8'd0;
114: present=8'd7;
115: present=8'd3;
116: present=8'd3;
117: present=8'd0;
118: present=8'd7;
119: present=8'd3;
120: present=8'd7;
121: present=8'd15;
122: present=8'd7;
123: present=8'd3;
124: present=8'd15;
125: present=8'd15;
126: present=8'd15;
127: present=8'd15;
default: present=0;endcase end endfunction
function automatic [7:0] forward(input [6:0] node); begin case(node)
0: forward=8'd0;
1: forward=8'd3;
2: forward=8'd0;
3: forward=8'd7;
4: forward=8'd0;
5: forward=8'd2;
6: forward=8'd4;
7: forward=8'd0;
8: forward=8'd2;
9: forward=8'd0;
10: forward=8'd3;
11: forward=8'd6;
12: forward=8'd0;
13: forward=8'd0;
14: forward=8'd0;
15: forward=8'd0;
16: forward=8'd2;
17: forward=8'd7;
18: forward=8'd15;
19: forward=8'd14;
20: forward=8'd0;
21: forward=8'd0;
22: forward=8'd0;
23: forward=8'd0;
24: forward=8'd0;
25: forward=8'd0;
26: forward=8'd15;
27: forward=8'd15;
28: forward=8'd0;
29: forward=8'd0;
30: forward=8'd0;
31: forward=8'd0;
32: forward=8'd3;
33: forward=8'd14;
34: forward=8'd14;
35: forward=8'd0;
36: forward=8'd0;
37: forward=8'd0;
38: forward=8'd0;
39: forward=8'd0;
40: forward=8'd2;
41: forward=8'd3;
42: forward=8'd2;
43: forward=8'd3;
44: forward=8'd0;
45: forward=8'd0;
46: forward=8'd0;
47: forward=8'd0;
48: forward=8'd2;
49: forward=8'd2;
50: forward=8'd7;
51: forward=8'd15;
52: forward=8'd0;
53: forward=8'd0;
54: forward=8'd0;
55: forward=8'd0;
56: forward=8'd0;
57: forward=8'd15;
58: forward=8'd3;
59: forward=8'd15;
60: forward=8'd0;
61: forward=8'd0;
62: forward=8'd0;
63: forward=8'd0;
64: forward=8'd3;
65: forward=8'd7;
66: forward=8'd3;
67: forward=8'd3;
68: forward=8'd4;
69: forward=8'd0;
70: forward=8'd0;
71: forward=8'd16;
72: forward=8'd7;
73: forward=8'd0;
74: forward=8'd7;
75: forward=8'd15;
76: forward=8'd0;
77: forward=8'd0;
78: forward=8'd0;
79: forward=8'd0;
80: forward=8'd3;
81: forward=8'd7;
82: forward=8'd3;
83: forward=8'd0;
84: forward=8'd8;
85: forward=8'd8;
86: forward=8'd2;
87: forward=8'd0;
88: forward=8'd0;
89: forward=8'd3;
90: forward=8'd3;
91: forward=8'd7;
92: forward=8'd0;
93: forward=8'd0;
94: forward=8'd0;
95: forward=8'd0;
96: forward=8'd3;
97: forward=8'd0;
98: forward=8'd0;
99: forward=8'd3;
100: forward=8'd0;
101: forward=8'd0;
102: forward=8'd0;
103: forward=8'd0;
104: forward=8'd0;
105: forward=8'd0;
106: forward=8'd2;
107: forward=8'd2;
108: forward=8'd0;
109: forward=8'd0;
110: forward=8'd0;
111: forward=8'd0;
112: forward=8'd3;
113: forward=8'd0;
114: forward=8'd7;
115: forward=8'd3;
116: forward=8'd0;
117: forward=8'd0;
118: forward=8'd4;
119: forward=8'd2;
120: forward=8'd7;
121: forward=8'd15;
122: forward=8'd7;
123: forward=8'd3;
124: forward=8'd8;
125: forward=8'd8;
126: forward=8'd0;
127: forward=8'd0;
default: forward=0;endcase end endfunction
function automatic [1:0] node_color(input [6:0] node); begin case(node)
0: node_color=2'd1;
1: node_color=2'd1;
2: node_color=2'd1;
3: node_color=2'd1;
4: node_color=2'd0;
5: node_color=2'd0;
6: node_color=2'd0;
7: node_color=2'd0;
8: node_color=2'd0;
9: node_color=2'd0;
10: node_color=2'd0;
11: node_color=2'd0;
12: node_color=2'd1;
13: node_color=2'd1;
14: node_color=2'd1;
15: node_color=2'd1;
16: node_color=2'd1;
17: node_color=2'd1;
18: node_color=2'd1;
19: node_color=2'd1;
20: node_color=2'd0;
21: node_color=2'd0;
22: node_color=2'd0;
23: node_color=2'd0;
24: node_color=2'd0;
25: node_color=2'd0;
26: node_color=2'd0;
27: node_color=2'd0;
28: node_color=2'd1;
29: node_color=2'd1;
30: node_color=2'd1;
31: node_color=2'd1;
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
64: node_color=2'd0;
65: node_color=2'd0;
66: node_color=2'd0;
67: node_color=2'd0;
68: node_color=2'd1;
69: node_color=2'd1;
70: node_color=2'd1;
71: node_color=2'd1;
72: node_color=2'd1;
73: node_color=2'd1;
74: node_color=2'd1;
75: node_color=2'd1;
76: node_color=2'd0;
77: node_color=2'd0;
78: node_color=2'd0;
79: node_color=2'd0;
80: node_color=2'd0;
81: node_color=2'd0;
82: node_color=2'd0;
83: node_color=2'd0;
84: node_color=2'd1;
85: node_color=2'd1;
86: node_color=2'd1;
87: node_color=2'd1;
88: node_color=2'd1;
89: node_color=2'd1;
90: node_color=2'd1;
91: node_color=2'd1;
92: node_color=2'd0;
93: node_color=2'd0;
94: node_color=2'd0;
95: node_color=2'd0;
96: node_color=2'd0;
97: node_color=2'd0;
98: node_color=2'd0;
99: node_color=2'd0;
100: node_color=2'd1;
101: node_color=2'd1;
102: node_color=2'd1;
103: node_color=2'd1;
104: node_color=2'd1;
105: node_color=2'd1;
106: node_color=2'd1;
107: node_color=2'd1;
108: node_color=2'd0;
109: node_color=2'd0;
110: node_color=2'd0;
111: node_color=2'd0;
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
   if(phase==CALCULATE&&!scoring) assert(field_sum>=-12 && field_sum<=12)
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
 input wire [799:0] current,
 input wire [127:0] dirty,
 output reg [127:0] next_bits,
 output wire ready,configured,
 output reg [15:0] fresh_count,
 output reg signed [15:0] score_value);
 localparam N=800,L=128,R=1,BASE=256,FW=5,TW=2,AGE=2;
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
 function automatic [7:0] neighbors(input [6:0] node,input [799:0] bits); begin case(node)
0: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[261],bits[260]};
1: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[337],bits[262],bits[261]};
2: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[261],bits[260]};
3: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[339],bits[263],bits[262]};
4: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[258],bits[256],bits[252]};
5: neighbors={1'b0,1'b0,1'b0,bits[269],bits[258],bits[257],bits[256],bits[253]};
6: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[259],bits[257]};
7: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[271],bits[259]};
8: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[271],bits[269]};
9: neighbors={1'b0,1'b0,1'b0,1'b0,bits[271],bits[269],bits[268],bits[185]};
10: neighbors={1'b0,1'b0,1'b0,1'b0,bits[271],bits[270],bits[269],bits[268]};
11: neighbors={1'b0,1'b0,1'b0,bits[271],bits[270],bits[269],bits[268],bits[187]};
12: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[267],bits[266],bits[265]};
13: neighbors={1'b0,1'b0,1'b0,bits[267],bits[266],bits[265],bits[264],bits[261]};
14: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[267],bits[266]};
15: neighbors={1'b0,1'b0,1'b0,bits[267],bits[266],bits[265],bits[264],bits[263]};
16: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[352],bits[279]};
17: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[278],bits[277],bits[276]};
18: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[277],bits[276]};
19: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[355],bits[279]};
20: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[284],bits[274],bits[273]};
21: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[274],bits[273]};
22: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[286],bits[273]};
23: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[275],bits[272]};
24: neighbors={1'b0,1'b0,1'b0,1'b0,bits[287],bits[286],bits[284],bits[200]};
25: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[287],bits[286]};
26: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[286],bits[284],bits[202]};
27: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[287],bits[284],bits[203]};
28: neighbors={1'b0,1'b0,1'b0,1'b0,bits[283],bits[282],bits[280],bits[276]};
29: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
30: neighbors={1'b0,1'b0,1'b0,1'b0,bits[282],bits[281],bits[280],bits[278]};
31: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[283],bits[281],bits[280]};
32: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[368],bits[295],bits[293]};
33: neighbors={1'b0,1'b0,1'b0,1'b0,bits[369],bits[295],bits[294],bits[293]};
34: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[295],bits[294]};
35: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[295],bits[294],bits[293]};
36: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
37: neighbors={1'b0,1'b0,1'b0,1'b0,bits[301],bits[291],bits[289],bits[288]};
38: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[291],bits[290],bits[289]};
39: neighbors={1'b0,1'b0,1'b0,bits[303],bits[291],bits[290],bits[289],bits[288]};
40: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[376],bits[303]};
41: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
42: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
43: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[302],bits[301]};
44: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
45: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[309],bits[299],bits[293]};
46: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[310],bits[299]};
47: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[311],bits[296],bits[295]};
48: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
49: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
50: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[310],bits[309]};
51: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[311],bits[309]};
52: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
53: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[307],bits[306],bits[301]};
54: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[306],bits[302]};
55: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[307],bits[303]};
56: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
57: neighbors={1'b0,1'b0,1'b0,1'b0,bits[319],bits[318],bits[317],bits[316]};
58: neighbors={1'b0,1'b0,1'b0,1'b0,bits[319],bits[318],bits[317],bits[316]};
59: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[319],bits[317],bits[316]};
60: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[315],bits[314],bits[313]};
61: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[315],bits[314],bits[313]};
62: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[314],bits[313]};
63: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[315],bits[314],bits[313]};
64: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[400],bits[324],bits[240]};
65: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[401],bits[325]};
66: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[327],bits[325],bits[324]};
67: neighbors={1'b0,1'b0,1'b0,1'b0,bits[403],bits[325],bits[324],bits[243]};
68: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[323],bits[322],bits[320]};
69: neighbors={1'b0,1'b0,1'b0,1'b0,bits[333],bits[323],bits[322],bits[321]};
70: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
71: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[335],bits[322]};
72: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[334],bits[333]};
73: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[334],bits[333]};
74: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[335],bits[333]};
75: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[335],bits[333],bits[332]};
76: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[331]};
77: neighbors={1'b0,1'b0,1'b0,bits[331],bits[330],bits[329],bits[328],bits[325]};
78: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[329],bits[328]};
79: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[331],bits[330],bits[327]};
80: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[343],bits[340]};
81: neighbors={1'b0,1'b0,1'b0,1'b0,bits[417],bits[343],bits[341],bits[257]};
82: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[418],bits[341]};
83: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[343],bits[340],bits[259]};
84: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[339],bits[336]};
85: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[338],bits[337]};
86: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
87: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[339],bits[337],bits[336]};
88: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[350],bits[349]};
89: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[351],bits[349],bits[348]};
90: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[351],bits[349],bits[348]};
91: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[351],bits[350],bits[348]};
92: neighbors={1'b0,1'b0,1'b0,1'b0,bits[356],bits[347],bits[346],bits[345]};
93: neighbors={1'b0,1'b0,1'b0,1'b0,bits[357],bits[346],bits[345],bits[344]};
94: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[358],bits[347],bits[344]};
95: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[347],bits[346],bits[345]};
96: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[359],bits[357],bits[272]};
97: neighbors={1'b0,1'b0,1'b0,1'b0,bits[359],bits[358],bits[357],bits[356]};
98: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[358],bits[357],bits[356]};
99: neighbors={1'b0,1'b0,1'b0,1'b0,bits[359],bits[358],bits[357],bits[275]};
100: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[354],bits[353],bits[348]};
101: neighbors={1'b0,1'b0,bits[365],bits[355],bits[354],bits[353],bits[352],bits[349]};
102: neighbors={1'b0,1'b0,1'b0,bits[366],bits[355],bits[354],bits[353],bits[350]};
103: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[355],bits[353],bits[352]};
104: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[367],bits[365]};
105: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
106: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
107: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[367],bits[366],bits[365]};
108: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
109: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[363],bits[360],bits[357]};
110: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[363],bits[358]};
111: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[363],bits[360]};
112: neighbors={1'b0,1'b0,1'b0,1'b0,bits[375],bits[374],bits[372],bits[288]};
113: neighbors={1'b0,1'b0,1'b0,1'b0,bits[375],bits[374],bits[373],bits[289]};
114: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[375],bits[373],bits[372]};
115: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[374],bits[372]};
116: neighbors={1'b0,1'b0,1'b0,1'b0,bits[380],bits[371],bits[370],bits[368]};
117: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[370],bits[369]};
118: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[371],bits[369],bits[368]};
119: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[370],bits[369],bits[368]};
120: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[382],bits[380],bits[296]};
121: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[382],bits[381],bits[380]};
122: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[381],bits[380]};
123: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[459],bits[382]};
124: neighbors={1'b0,1'b0,1'b0,bits[388],bits[378],bits[377],bits[376],bits[372]};
125: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[378],bits[377]};
126: neighbors={1'b0,1'b0,1'b0,1'b0,bits[390],bits[379],bits[377],bits[376]};
127: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
default: neighbors=0;endcase end endfunction
function automatic [7:0] present(input [6:0] node); begin case(node)
0: present=8'd3;
1: present=8'd7;
2: present=8'd3;
3: present=8'd7;
4: present=8'd7;
5: present=8'd31;
6: present=8'd3;
7: present=8'd3;
8: present=8'd3;
9: present=8'd15;
10: present=8'd15;
11: present=8'd31;
12: present=8'd7;
13: present=8'd31;
14: present=8'd3;
15: present=8'd31;
16: present=8'd3;
17: present=8'd7;
18: present=8'd3;
19: present=8'd3;
20: present=8'd7;
21: present=8'd3;
22: present=8'd3;
23: present=8'd3;
24: present=8'd15;
25: present=8'd3;
26: present=8'd7;
27: present=8'd7;
28: present=8'd15;
29: present=8'd0;
30: present=8'd15;
31: present=8'd7;
32: present=8'd7;
33: present=8'd15;
34: present=8'd3;
35: present=8'd7;
36: present=8'd0;
37: present=8'd15;
38: present=8'd7;
39: present=8'd31;
40: present=8'd3;
41: present=8'd0;
42: present=8'd0;
43: present=8'd3;
44: present=8'd0;
45: present=8'd7;
46: present=8'd3;
47: present=8'd7;
48: present=8'd0;
49: present=8'd0;
50: present=8'd3;
51: present=8'd3;
52: present=8'd0;
53: present=8'd7;
54: present=8'd3;
55: present=8'd3;
56: present=8'd0;
57: present=8'd15;
58: present=8'd15;
59: present=8'd7;
60: present=8'd7;
61: present=8'd7;
62: present=8'd3;
63: present=8'd7;
64: present=8'd7;
65: present=8'd3;
66: present=8'd7;
67: present=8'd15;
68: present=8'd7;
69: present=8'd15;
70: present=8'd0;
71: present=8'd3;
72: present=8'd3;
73: present=8'd3;
74: present=8'd3;
75: present=8'd7;
76: present=8'd1;
77: present=8'd31;
78: present=8'd3;
79: present=8'd7;
80: present=8'd3;
81: present=8'd15;
82: present=8'd3;
83: present=8'd7;
84: present=8'd3;
85: present=8'd3;
86: present=8'd0;
87: present=8'd7;
88: present=8'd3;
89: present=8'd7;
90: present=8'd7;
91: present=8'd7;
92: present=8'd15;
93: present=8'd15;
94: present=8'd7;
95: present=8'd7;
96: present=8'd7;
97: present=8'd15;
98: present=8'd7;
99: present=8'd15;
100: present=8'd7;
101: present=8'd63;
102: present=8'd31;
103: present=8'd7;
104: present=8'd3;
105: present=8'd0;
106: present=8'd0;
107: present=8'd7;
108: present=8'd0;
109: present=8'd7;
110: present=8'd3;
111: present=8'd3;
112: present=8'd15;
113: present=8'd15;
114: present=8'd7;
115: present=8'd3;
116: present=8'd15;
117: present=8'd3;
118: present=8'd7;
119: present=8'd7;
120: present=8'd7;
121: present=8'd7;
122: present=8'd3;
123: present=8'd3;
124: present=8'd31;
125: present=8'd3;
126: present=8'd15;
127: present=8'd0;
default: present=0;endcase end endfunction
function automatic [7:0] forward(input [6:0] node); begin case(node)
0: forward=8'd3;
1: forward=8'd7;
2: forward=8'd3;
3: forward=8'd7;
4: forward=8'd0;
5: forward=8'd16;
6: forward=8'd0;
7: forward=8'd2;
8: forward=8'd3;
9: forward=8'd14;
10: forward=8'd15;
11: forward=8'd30;
12: forward=8'd0;
13: forward=8'd0;
14: forward=8'd0;
15: forward=8'd0;
16: forward=8'd3;
17: forward=8'd7;
18: forward=8'd3;
19: forward=8'd3;
20: forward=8'd4;
21: forward=8'd0;
22: forward=8'd2;
23: forward=8'd0;
24: forward=8'd14;
25: forward=8'd3;
26: forward=8'd6;
27: forward=8'd6;
28: forward=8'd0;
29: forward=8'd0;
30: forward=8'd0;
31: forward=8'd0;
32: forward=8'd7;
33: forward=8'd15;
34: forward=8'd3;
35: forward=8'd7;
36: forward=8'd0;
37: forward=8'd8;
38: forward=8'd0;
39: forward=8'd16;
40: forward=8'd3;
41: forward=8'd0;
42: forward=8'd0;
43: forward=8'd3;
44: forward=8'd0;
45: forward=8'd4;
46: forward=8'd2;
47: forward=8'd4;
48: forward=8'd0;
49: forward=8'd0;
50: forward=8'd3;
51: forward=8'd3;
52: forward=8'd0;
53: forward=8'd0;
54: forward=8'd0;
55: forward=8'd0;
56: forward=8'd0;
57: forward=8'd15;
58: forward=8'd15;
59: forward=8'd7;
60: forward=8'd0;
61: forward=8'd0;
62: forward=8'd0;
63: forward=8'd0;
64: forward=8'd6;
65: forward=8'd3;
66: forward=8'd7;
67: forward=8'd14;
68: forward=8'd0;
69: forward=8'd8;
70: forward=8'd0;
71: forward=8'd2;
72: forward=8'd3;
73: forward=8'd3;
74: forward=8'd3;
75: forward=8'd7;
76: forward=8'd0;
77: forward=8'd0;
78: forward=8'd0;
79: forward=8'd0;
80: forward=8'd3;
81: forward=8'd14;
82: forward=8'd3;
83: forward=8'd6;
84: forward=8'd0;
85: forward=8'd0;
86: forward=8'd0;
87: forward=8'd0;
88: forward=8'd3;
89: forward=8'd7;
90: forward=8'd7;
91: forward=8'd7;
92: forward=8'd8;
93: forward=8'd8;
94: forward=8'd4;
95: forward=8'd0;
96: forward=8'd6;
97: forward=8'd15;
98: forward=8'd7;
99: forward=8'd14;
100: forward=8'd0;
101: forward=8'd32;
102: forward=8'd16;
103: forward=8'd0;
104: forward=8'd3;
105: forward=8'd0;
106: forward=8'd0;
107: forward=8'd7;
108: forward=8'd0;
109: forward=8'd0;
110: forward=8'd0;
111: forward=8'd0;
112: forward=8'd14;
113: forward=8'd14;
114: forward=8'd7;
115: forward=8'd3;
116: forward=8'd8;
117: forward=8'd0;
118: forward=8'd0;
119: forward=8'd0;
120: forward=8'd6;
121: forward=8'd7;
122: forward=8'd3;
123: forward=8'd3;
124: forward=8'd16;
125: forward=8'd0;
126: forward=8'd8;
127: forward=8'd0;
default: forward=0;endcase end endfunction
function automatic [1:0] node_color(input [6:0] node); begin case(node)
0: node_color=2'd1;
1: node_color=2'd1;
2: node_color=2'd1;
3: node_color=2'd1;
4: node_color=2'd0;
5: node_color=2'd0;
6: node_color=2'd0;
7: node_color=2'd0;
8: node_color=2'd0;
9: node_color=2'd0;
10: node_color=2'd0;
11: node_color=2'd0;
12: node_color=2'd1;
13: node_color=2'd1;
14: node_color=2'd1;
15: node_color=2'd1;
16: node_color=2'd1;
17: node_color=2'd1;
18: node_color=2'd1;
19: node_color=2'd1;
20: node_color=2'd0;
21: node_color=2'd0;
22: node_color=2'd0;
23: node_color=2'd0;
24: node_color=2'd0;
25: node_color=2'd0;
26: node_color=2'd0;
27: node_color=2'd0;
28: node_color=2'd1;
29: node_color=2'd1;
30: node_color=2'd1;
31: node_color=2'd1;
32: node_color=2'd1;
33: node_color=2'd1;
34: node_color=2'd1;
35: node_color=2'd1;
36: node_color=2'd0;
37: node_color=2'd0;
38: node_color=2'd0;
39: node_color=2'd0;
40: node_color=2'd0;
41: node_color=2'd0;
42: node_color=2'd0;
43: node_color=2'd0;
44: node_color=2'd1;
45: node_color=2'd1;
46: node_color=2'd1;
47: node_color=2'd1;
48: node_color=2'd1;
49: node_color=2'd1;
50: node_color=2'd1;
51: node_color=2'd1;
52: node_color=2'd0;
53: node_color=2'd0;
54: node_color=2'd0;
55: node_color=2'd0;
56: node_color=2'd0;
57: node_color=2'd0;
58: node_color=2'd0;
59: node_color=2'd0;
60: node_color=2'd1;
61: node_color=2'd1;
62: node_color=2'd1;
63: node_color=2'd1;
64: node_color=2'd0;
65: node_color=2'd0;
66: node_color=2'd0;
67: node_color=2'd0;
68: node_color=2'd1;
69: node_color=2'd1;
70: node_color=2'd1;
71: node_color=2'd1;
72: node_color=2'd1;
73: node_color=2'd1;
74: node_color=2'd1;
75: node_color=2'd1;
76: node_color=2'd0;
77: node_color=2'd0;
78: node_color=2'd0;
79: node_color=2'd0;
80: node_color=2'd0;
81: node_color=2'd0;
82: node_color=2'd0;
83: node_color=2'd0;
84: node_color=2'd1;
85: node_color=2'd1;
86: node_color=2'd1;
87: node_color=2'd1;
88: node_color=2'd1;
89: node_color=2'd1;
90: node_color=2'd1;
91: node_color=2'd1;
92: node_color=2'd0;
93: node_color=2'd0;
94: node_color=2'd0;
95: node_color=2'd0;
96: node_color=2'd0;
97: node_color=2'd0;
98: node_color=2'd0;
99: node_color=2'd0;
100: node_color=2'd1;
101: node_color=2'd1;
102: node_color=2'd1;
103: node_color=2'd1;
104: node_color=2'd1;
105: node_color=2'd1;
106: node_color=2'd1;
107: node_color=2'd1;
108: node_color=2'd0;
109: node_color=2'd0;
110: node_color=2'd0;
111: node_color=2'd0;
112: node_color=2'd0;
113: node_color=2'd0;
114: node_color=2'd0;
115: node_color=2'd0;
116: node_color=2'd1;
117: node_color=2'd1;
118: node_color=2'd1;
119: node_color=2'd1;
120: node_color=2'd1;
121: node_color=2'd1;
122: node_color=2'd1;
123: node_color=2'd1;
124: node_color=2'd0;
125: node_color=2'd0;
126: node_color=2'd0;
127: node_color=2'd0;
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
   if(phase==CALCULATE&&!scoring) assert(field_sum>=-12 && field_sum<=12)
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
 input wire [799:0] current,
 input wire [127:0] dirty,
 output reg [127:0] next_bits,
 output wire ready,configured,
 output reg [15:0] fresh_count,
 output reg signed [15:0] score_value);
 localparam N=800,L=128,R=1,BASE=384,FW=5,TW=2,AGE=2;
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
 function automatic [7:0] neighbors(input [6:0] node,input [799:0] bits); begin case(node)
0: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[464],bits[388]};
1: neighbors={1'b0,1'b0,1'b0,bits[465],bits[391],bits[390],bits[389],bits[388]};
2: neighbors={1'b0,1'b0,1'b0,1'b0,bits[466],bits[391],bits[390],bits[388]};
3: neighbors={1'b0,1'b0,1'b0,1'b0,bits[391],bits[390],bits[389],bits[388]};
4: neighbors={1'b0,1'b0,bits[396],bits[387],bits[386],bits[385],bits[384],bits[380]};
5: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[387],bits[385]};
6: neighbors={1'b0,1'b0,1'b0,bits[398],bits[387],bits[386],bits[385],bits[382]};
7: neighbors={1'b0,1'b0,1'b0,1'b0,bits[399],bits[387],bits[386],bits[385]};
8: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[397],bits[396]};
9: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[399],bits[397]};
10: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[399],bits[398],bits[396]};
11: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[399],bits[396]};
12: neighbors={1'b0,1'b0,1'b0,1'b0,bits[395],bits[394],bits[392],bits[388]};
13: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[393],bits[392]};
14: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[394],bits[390]};
15: neighbors={1'b0,1'b0,1'b0,1'b0,bits[395],bits[394],bits[393],bits[391]};
16: neighbors={1'b0,1'b0,1'b0,1'b0,bits[406],bits[405],bits[404],bits[320]};
17: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[407],bits[404],bits[321]};
18: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[406],bits[404]};
19: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[406],bits[404],bits[323]};
20: neighbors={1'b0,1'b0,1'b0,bits[412],bits[403],bits[402],bits[401],bits[400]};
21: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[413],bits[400]};
22: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[403],bits[402],bits[400]};
23: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[415],bits[401]};
24: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[415],bits[413],bits[412]};
25: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[415],bits[412]};
26: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
27: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[415],bits[412]};
28: neighbors={1'b0,1'b0,1'b0,1'b0,bits[411],bits[409],bits[408],bits[404]};
29: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[408],bits[405]};
30: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
31: neighbors={1'b0,1'b0,1'b0,1'b0,bits[411],bits[409],bits[408],bits[407]};
32: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[496],bits[422],bits[421]};
33: neighbors={1'b0,1'b0,1'b0,1'b0,bits[497],bits[423],bits[422],bits[337]};
34: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[422],bits[421],bits[338]};
35: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[423],bits[421]};
36: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
37: neighbors={1'b0,1'b0,1'b0,1'b0,bits[429],bits[419],bits[418],bits[416]};
38: neighbors={1'b0,1'b0,1'b0,1'b0,bits[430],bits[418],bits[417],bits[416]};
39: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[419],bits[417]};
40: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[430],bits[429],bits[428]};
41: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
42: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
43: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[431],bits[430]};
44: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[436],bits[424]};
45: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[424],bits[421]};
46: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[427],bits[424],bits[422]};
47: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[439],bits[427]};
48: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[436]};
49: neighbors={1'b0,1'b0,1'b0,1'b0,bits[439],bits[438],bits[437],bits[436]};
50: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[439],bits[437]};
51: neighbors={1'b0,1'b0,1'b0,1'b0,bits[439],bits[438],bits[437],bits[436]};
52: neighbors={1'b0,1'b0,1'b0,bits[444],bits[435],bits[433],bits[432],bits[428]};
53: neighbors={1'b0,1'b0,1'b0,1'b0,bits[445],bits[435],bits[434],bits[433]};
54: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[435],bits[433]};
55: neighbors={1'b0,1'b0,1'b0,1'b0,bits[435],bits[434],bits[433],bits[431]};
56: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[445],bits[444]};
57: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
58: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
59: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
60: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[440],bits[436]};
61: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[440],bits[437]};
62: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
63: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
64: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[453],bits[452]};
65: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[453],bits[452]};
66: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[454],bits[453]};
67: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
68: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[460],bits[449],bits[448]};
69: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[450],bits[449],bits[448]};
70: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[462],bits[450]};
71: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
72: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[463],bits[462]};
73: neighbors={1'b0,1'b0,1'b0,1'b0,bits[537],bits[462],bits[461],bits[460]};
74: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[463],bits[461]};
75: neighbors={1'b0,1'b0,1'b0,bits[539],bits[463],bits[462],bits[460],bits[379]};
76: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[459],bits[457],bits[452]};
77: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[458],bits[457]};
78: neighbors={1'b0,1'b0,1'b0,bits[470],bits[459],bits[457],bits[456],bits[454]};
79: neighbors={1'b0,1'b0,1'b0,1'b0,bits[471],bits[459],bits[458],bits[456]};
80: neighbors={1'b0,1'b0,1'b0,1'b0,bits[470],bits[469],bits[468],bits[384]};
81: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[470],bits[385]};
82: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[468],bits[386]};
83: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[471],bits[470]};
84: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[476],bits[466],bits[464]};
85: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[477],bits[464]};
86: neighbors={1'b0,1'b0,1'b0,1'b0,bits[467],bits[465],bits[464],bits[462]};
87: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[467],bits[463]};
88: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[552],bits[479],bits[477]};
89: neighbors={1'b0,1'b0,1'b0,1'b0,bits[553],bits[479],bits[478],bits[476]};
90: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[479],bits[478],bits[476]};
91: neighbors={1'b0,1'b0,1'b0,bits[555],bits[479],bits[478],bits[477],bits[476]};
92: neighbors={1'b0,1'b0,1'b0,1'b0,bits[475],bits[474],bits[473],bits[468]};
93: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[475],bits[472],bits[469]};
94: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[475],bits[474],bits[473]};
95: neighbors={1'b0,1'b0,1'b0,1'b0,bits[475],bits[474],bits[473],bits[472]};
96: neighbors={1'b0,1'b0,1'b0,1'b0,bits[560],bits[487],bits[486],bits[485]};
97: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[561],bits[487],bits[484]};
98: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[487],bits[486],bits[484]};
99: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[487],bits[485],bits[484]};
100: neighbors={1'b0,1'b0,1'b0,1'b0,bits[492],bits[483],bits[482],bits[481]};
101: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[483],bits[480]};
102: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[494],bits[482],bits[480]};
103: neighbors={1'b0,1'b0,1'b0,bits[495],bits[483],bits[482],bits[481],bits[480]};
104: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[495],bits[494]};
105: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[494],bits[493]};
106: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[495],bits[494],bits[492]};
107: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[494],bits[493]};
108: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[490],bits[484]};
109: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[491],bits[489]};
110: neighbors={1'b0,1'b0,1'b0,bits[491],bits[490],bits[489],bits[488],bits[486]};
111: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[490],bits[488],bits[487]};
112: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[502],bits[500],bits[416]};
113: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[500],bits[417]};
114: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
115: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[502],bits[500]};
116: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[499],bits[497],bits[496]};
117: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
118: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[499],bits[496]};
119: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
120: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[511],bits[510],bits[508]};
121: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[511],bits[510],bits[509]};
122: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[511],bits[510],bits[509]};
123: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[511],bits[510],bits[508]};
124: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[516],bits[507],bits[504]};
125: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[517],bits[506],bits[505]};
126: neighbors={1'b0,1'b0,1'b0,bits[518],bits[507],bits[506],bits[505],bits[504]};
127: neighbors={1'b0,1'b0,1'b0,bits[519],bits[507],bits[506],bits[505],bits[504]};
default: neighbors=0;endcase end endfunction
function automatic [7:0] present(input [6:0] node); begin case(node)
0: present=8'd3;
1: present=8'd31;
2: present=8'd15;
3: present=8'd15;
4: present=8'd63;
5: present=8'd3;
6: present=8'd31;
7: present=8'd15;
8: present=8'd3;
9: present=8'd3;
10: present=8'd7;
11: present=8'd3;
12: present=8'd15;
13: present=8'd3;
14: present=8'd3;
15: present=8'd15;
16: present=8'd15;
17: present=8'd7;
18: present=8'd3;
19: present=8'd7;
20: present=8'd31;
21: present=8'd3;
22: present=8'd7;
23: present=8'd3;
24: present=8'd7;
25: present=8'd3;
26: present=8'd0;
27: present=8'd3;
28: present=8'd15;
29: present=8'd3;
30: present=8'd0;
31: present=8'd15;
32: present=8'd7;
33: present=8'd15;
34: present=8'd7;
35: present=8'd3;
36: present=8'd0;
37: present=8'd15;
38: present=8'd15;
39: present=8'd3;
40: present=8'd7;
41: present=8'd0;
42: present=8'd0;
43: present=8'd3;
44: present=8'd3;
45: present=8'd3;
46: present=8'd7;
47: present=8'd3;
48: present=8'd1;
49: present=8'd15;
50: present=8'd3;
51: present=8'd15;
52: present=8'd31;
53: present=8'd15;
54: present=8'd3;
55: present=8'd15;
56: present=8'd3;
57: present=8'd0;
58: present=8'd0;
59: present=8'd0;
60: present=8'd3;
61: present=8'd3;
62: present=8'd0;
63: present=8'd0;
64: present=8'd3;
65: present=8'd3;
66: present=8'd3;
67: present=8'd0;
68: present=8'd7;
69: present=8'd7;
70: present=8'd3;
71: present=8'd0;
72: present=8'd3;
73: present=8'd15;
74: present=8'd3;
75: present=8'd31;
76: present=8'd7;
77: present=8'd3;
78: present=8'd31;
79: present=8'd15;
80: present=8'd15;
81: present=8'd3;
82: present=8'd3;
83: present=8'd3;
84: present=8'd7;
85: present=8'd3;
86: present=8'd15;
87: present=8'd3;
88: present=8'd7;
89: present=8'd15;
90: present=8'd7;
91: present=8'd31;
92: present=8'd15;
93: present=8'd7;
94: present=8'd7;
95: present=8'd15;
96: present=8'd15;
97: present=8'd7;
98: present=8'd7;
99: present=8'd7;
100: present=8'd15;
101: present=8'd3;
102: present=8'd7;
103: present=8'd31;
104: present=8'd3;
105: present=8'd3;
106: present=8'd7;
107: present=8'd3;
108: present=8'd3;
109: present=8'd3;
110: present=8'd31;
111: present=8'd7;
112: present=8'd7;
113: present=8'd3;
114: present=8'd0;
115: present=8'd3;
116: present=8'd7;
117: present=8'd0;
118: present=8'd3;
119: present=8'd0;
120: present=8'd7;
121: present=8'd7;
122: present=8'd7;
123: present=8'd7;
124: present=8'd7;
125: present=8'd7;
126: present=8'd31;
127: present=8'd31;
default: present=0;endcase end endfunction
function automatic [7:0] forward(input [6:0] node); begin case(node)
0: forward=8'd3;
1: forward=8'd31;
2: forward=8'd15;
3: forward=8'd15;
4: forward=8'd32;
5: forward=8'd0;
6: forward=8'd16;
7: forward=8'd8;
8: forward=8'd3;
9: forward=8'd3;
10: forward=8'd7;
11: forward=8'd3;
12: forward=8'd0;
13: forward=8'd0;
14: forward=8'd0;
15: forward=8'd0;
16: forward=8'd14;
17: forward=8'd6;
18: forward=8'd3;
19: forward=8'd6;
20: forward=8'd16;
21: forward=8'd2;
22: forward=8'd0;
23: forward=8'd2;
24: forward=8'd7;
25: forward=8'd3;
26: forward=8'd0;
27: forward=8'd3;
28: forward=8'd0;
29: forward=8'd0;
30: forward=8'd0;
31: forward=8'd0;
32: forward=8'd7;
33: forward=8'd14;
34: forward=8'd6;
35: forward=8'd3;
36: forward=8'd0;
37: forward=8'd8;
38: forward=8'd8;
39: forward=8'd0;
40: forward=8'd7;
41: forward=8'd0;
42: forward=8'd0;
43: forward=8'd3;
44: forward=8'd2;
45: forward=8'd0;
46: forward=8'd0;
47: forward=8'd2;
48: forward=8'd1;
49: forward=8'd15;
50: forward=8'd3;
51: forward=8'd15;
52: forward=8'd16;
53: forward=8'd8;
54: forward=8'd0;
55: forward=8'd0;
56: forward=8'd3;
57: forward=8'd0;
58: forward=8'd0;
59: forward=8'd0;
60: forward=8'd0;
61: forward=8'd0;
62: forward=8'd0;
63: forward=8'd0;
64: forward=8'd3;
65: forward=8'd3;
66: forward=8'd3;
67: forward=8'd0;
68: forward=8'd4;
69: forward=8'd0;
70: forward=8'd2;
71: forward=8'd0;
72: forward=8'd3;
73: forward=8'd15;
74: forward=8'd3;
75: forward=8'd30;
76: forward=8'd0;
77: forward=8'd0;
78: forward=8'd16;
79: forward=8'd8;
80: forward=8'd14;
81: forward=8'd2;
82: forward=8'd2;
83: forward=8'd3;
84: forward=8'd4;
85: forward=8'd2;
86: forward=8'd0;
87: forward=8'd0;
88: forward=8'd7;
89: forward=8'd15;
90: forward=8'd7;
91: forward=8'd31;
92: forward=8'd0;
93: forward=8'd0;
94: forward=8'd0;
95: forward=8'd0;
96: forward=8'd15;
97: forward=8'd7;
98: forward=8'd7;
99: forward=8'd7;
100: forward=8'd8;
101: forward=8'd0;
102: forward=8'd4;
103: forward=8'd16;
104: forward=8'd3;
105: forward=8'd3;
106: forward=8'd7;
107: forward=8'd3;
108: forward=8'd0;
109: forward=8'd0;
110: forward=8'd0;
111: forward=8'd0;
112: forward=8'd6;
113: forward=8'd2;
114: forward=8'd0;
115: forward=8'd3;
116: forward=8'd0;
117: forward=8'd0;
118: forward=8'd0;
119: forward=8'd0;
120: forward=8'd7;
121: forward=8'd7;
122: forward=8'd7;
123: forward=8'd7;
124: forward=8'd4;
125: forward=8'd4;
126: forward=8'd16;
127: forward=8'd16;
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
16: node_color=2'd1;
17: node_color=2'd1;
18: node_color=2'd1;
19: node_color=2'd1;
20: node_color=2'd0;
21: node_color=2'd0;
22: node_color=2'd0;
23: node_color=2'd0;
24: node_color=2'd0;
25: node_color=2'd0;
26: node_color=2'd0;
27: node_color=2'd0;
28: node_color=2'd1;
29: node_color=2'd1;
30: node_color=2'd1;
31: node_color=2'd1;
32: node_color=2'd1;
33: node_color=2'd1;
34: node_color=2'd1;
35: node_color=2'd1;
36: node_color=2'd0;
37: node_color=2'd0;
38: node_color=2'd0;
39: node_color=2'd0;
40: node_color=2'd0;
41: node_color=2'd0;
42: node_color=2'd0;
43: node_color=2'd0;
44: node_color=2'd1;
45: node_color=2'd1;
46: node_color=2'd1;
47: node_color=2'd1;
48: node_color=2'd1;
49: node_color=2'd1;
50: node_color=2'd1;
51: node_color=2'd1;
52: node_color=2'd0;
53: node_color=2'd0;
54: node_color=2'd0;
55: node_color=2'd0;
56: node_color=2'd0;
57: node_color=2'd0;
58: node_color=2'd0;
59: node_color=2'd0;
60: node_color=2'd1;
61: node_color=2'd1;
62: node_color=2'd1;
63: node_color=2'd1;
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
96: node_color=2'd0;
97: node_color=2'd0;
98: node_color=2'd0;
99: node_color=2'd0;
100: node_color=2'd1;
101: node_color=2'd1;
102: node_color=2'd1;
103: node_color=2'd1;
104: node_color=2'd1;
105: node_color=2'd1;
106: node_color=2'd1;
107: node_color=2'd1;
108: node_color=2'd0;
109: node_color=2'd0;
110: node_color=2'd0;
111: node_color=2'd0;
112: node_color=2'd0;
113: node_color=2'd0;
114: node_color=2'd0;
115: node_color=2'd0;
116: node_color=2'd1;
117: node_color=2'd1;
118: node_color=2'd1;
119: node_color=2'd1;
120: node_color=2'd1;
121: node_color=2'd1;
122: node_color=2'd1;
123: node_color=2'd1;
124: node_color=2'd0;
125: node_color=2'd0;
126: node_color=2'd0;
127: node_color=2'd0;
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
   if(phase==CALCULATE&&!scoring) assert(field_sum>=-12 && field_sum<=12)
     else $fatal(1,"A2 field exceeds configured bound");
   if(active) assert(context_id<R) else $fatal(1,"A2 replica out of range");
 end
`endif
endmodule

// One field/score lane. Each replica and site owns its LFSR and history.
module a2_cluster_512 #(parameter EPIX=1)(
 input wire clk,rst,test_enable,active,score_active,accept,
 input wire seed_we,cfg_we,
 input wire [15:0] seed_addr,
 input wire [9:0] cfg_addr,
 input wire [31:0] data_in,
 input wire [5:0] context_id,beta,
 input wire [1:0] color,
 input wire [2:0] sweep_tag,
 input wire [9:0] beta_sweep,
 input wire [799:0] current,
 input wire [127:0] dirty,
 output reg [127:0] next_bits,
 output wire ready,configured,
 output reg [15:0] fresh_count,
 output reg signed [15:0] score_value);
 localparam N=800,L=128,R=1,BASE=512,FW=5,TW=2,AGE=2;
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
 function automatic [7:0] neighbors(input [6:0] node,input [799:0] bits); begin case(node)
0: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[592],bits[518]};
1: neighbors={1'b0,1'b0,1'b0,1'b0,bits[593],bits[519],bits[518],bits[516]};
2: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[519],bits[518],bits[516]};
3: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[519],bits[518],bits[517]};
4: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[514],bits[513],bits[508]};
5: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[525],bits[515],bits[509]};
6: neighbors={1'b0,1'b0,bits[526],bits[515],bits[514],bits[513],bits[512],bits[510]};
7: neighbors={1'b0,1'b0,1'b0,1'b0,bits[515],bits[514],bits[513],bits[511]};
8: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[600],bits[526],bits[524]};
9: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[601],bits[524]};
10: neighbors={1'b0,1'b0,1'b0,bits[602],bits[527],bits[526],bits[525],bits[524]};
11: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[527],bits[524]};
12: neighbors={1'b0,1'b0,1'b0,bits[532],bits[523],bits[522],bits[521],bits[520]};
13: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[533],bits[522],bits[517]};
14: neighbors={1'b0,1'b0,1'b0,1'b0,bits[534],bits[522],bits[520],bits[518]};
15: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[523],bits[522]};
16: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
17: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[609],bits[534]};
18: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
19: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[533],bits[532]};
20: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[531],bits[524]};
21: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[531],bits[525]};
22: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[529],bits[526]};
23: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
24: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[616],bits[543],bits[541]};
25: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[541],bits[540],bits[457]};
26: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[541],bits[540]};
27: neighbors={1'b0,1'b0,1'b0,1'b0,bits[619],bits[543],bits[542],bits[459]};
28: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[538],bits[537]};
29: neighbors={1'b0,1'b0,1'b0,1'b0,bits[549],bits[538],bits[537],bits[536]};
30: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[550],bits[539]};
31: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[539],bits[536]};
32: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[551],bits[549]};
33: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[625],bits[549]};
34: neighbors={1'b0,1'b0,1'b0,1'b0,bits[626],bits[551],bits[550],bits[549]};
35: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
36: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
37: neighbors={1'b0,1'b0,1'b0,1'b0,bits[546],bits[545],bits[544],bits[541]};
38: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[546],bits[542]};
39: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[546],bits[544]};
40: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[558],bits[472]};
41: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[558],bits[473]};
42: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[558],bits[557]};
43: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[558],bits[557],bits[475]};
44: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
45: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[555],bits[554]};
46: neighbors={1'b0,1'b0,1'b0,1'b0,bits[555],bits[554],bits[553],bits[552]};
47: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
48: neighbors={1'b0,1'b0,1'b0,bits[640],bits[566],bits[565],bits[564],bits[480]};
49: neighbors={1'b0,1'b0,1'b0,bits[641],bits[566],bits[565],bits[564],bits[481]};
50: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[565],bits[564]};
51: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[643],bits[566]};
52: neighbors={1'b0,1'b0,1'b0,1'b0,bits[572],bits[562],bits[561],bits[560]};
53: neighbors={1'b0,1'b0,1'b0,1'b0,bits[573],bits[562],bits[561],bits[560]};
54: neighbors={1'b0,1'b0,1'b0,1'b0,bits[574],bits[563],bits[561],bits[560]};
55: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
56: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[574],bits[572]};
57: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[575],bits[574],bits[572]};
58: neighbors={1'b0,1'b0,1'b0,1'b0,bits[650],bits[575],bits[574],bits[572]};
59: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[575],bits[573],bits[572]};
60: neighbors={1'b0,1'b0,bits[580],bits[571],bits[570],bits[569],bits[568],bits[564]};
61: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[571],bits[565]};
62: neighbors={1'b0,1'b0,1'b0,1'b0,bits[570],bits[569],bits[568],bits[566]};
63: neighbors={1'b0,1'b0,1'b0,1'b0,bits[583],bits[571],bits[570],bits[569]};
64: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[583],bits[580]};
65: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
66: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
67: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
68: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[576],bits[572]};
69: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
70: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
71: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[576],bits[575]};
72: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[591],bits[589],bits[588]};
73: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[588]};
74: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[591],bits[589],bits[588]};
75: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[589],bits[588]};
76: neighbors={1'b0,1'b0,1'b0,1'b0,bits[587],bits[586],bits[585],bits[584]};
77: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[587],bits[586],bits[584]};
78: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
79: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[586],bits[584]};
80: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[596],bits[512]};
81: neighbors={1'b0,1'b0,1'b0,1'b0,bits[673],bits[597],bits[596],bits[513]};
82: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[674],bits[597]};
83: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
84: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[593],bits[592]};
85: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[594],bits[593]};
86: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
87: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
88: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[606],bits[520]};
89: neighbors={1'b0,1'b0,1'b0,bits[607],bits[606],bits[605],bits[604],bits[521]};
90: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[604],bits[522]};
91: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[606],bits[604]};
92: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[603],bits[602],bits[601]};
93: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[613],bits[601]};
94: neighbors={1'b0,1'b0,1'b0,1'b0,bits[614],bits[603],bits[601],bits[600]};
95: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[615],bits[601]};
96: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[615],bits[613]};
97: neighbors={1'b0,1'b0,1'b0,1'b0,bits[615],bits[614],bits[613],bits[529]};
98: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[615],bits[612]};
99: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[614],bits[613]};
100: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[620],bits[610]};
101: neighbors={1'b0,1'b0,1'b0,1'b0,bits[611],bits[609],bits[608],bits[605]};
102: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[611],bits[609],bits[606]};
103: neighbors={1'b0,1'b0,1'b0,bits[623],bits[610],bits[609],bits[608],bits[607]};
104: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[622],bits[620],bits[536]};
105: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
106: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[698],bits[620]};
107: neighbors={1'b0,1'b0,1'b0,bits[699],bits[623],bits[622],bits[620],bits[539]};
108: neighbors={1'b0,1'b0,1'b0,bits[628],bits[619],bits[618],bits[616],bits[612]};
109: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
110: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[630],bits[619],bits[616]};
111: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[619],bits[615]};
112: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[631],bits[629]};
113: neighbors={1'b0,1'b0,1'b0,bits[631],bits[630],bits[629],bits[628],bits[545]};
114: neighbors={1'b0,1'b0,1'b0,bits[706],bits[631],bits[630],bits[629],bits[546]};
115: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
116: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[625],bits[620]};
117: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[626],bits[625],bits[624]};
118: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[626],bits[625],bits[622]};
119: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[626],bits[625],bits[624]};
120: neighbors={1'b0,1'b0,1'b0,1'b0,bits[639],bits[638],bits[637],bits[636]};
121: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
122: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[639],bits[637],bits[636]};
123: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[639],bits[638]};
124: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[634],bits[632]};
125: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[634],bits[632]};
126: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[635],bits[632]};
127: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[635],bits[634],bits[632]};
default: neighbors=0;endcase end endfunction
function automatic [7:0] present(input [6:0] node); begin case(node)
0: present=8'd3;
1: present=8'd15;
2: present=8'd7;
3: present=8'd7;
4: present=8'd7;
5: present=8'd7;
6: present=8'd63;
7: present=8'd15;
8: present=8'd7;
9: present=8'd3;
10: present=8'd31;
11: present=8'd3;
12: present=8'd31;
13: present=8'd7;
14: present=8'd15;
15: present=8'd3;
16: present=8'd0;
17: present=8'd3;
18: present=8'd0;
19: present=8'd3;
20: present=8'd3;
21: present=8'd3;
22: present=8'd3;
23: present=8'd0;
24: present=8'd7;
25: present=8'd7;
26: present=8'd3;
27: present=8'd15;
28: present=8'd3;
29: present=8'd15;
30: present=8'd3;
31: present=8'd3;
32: present=8'd3;
33: present=8'd3;
34: present=8'd15;
35: present=8'd0;
36: present=8'd0;
37: present=8'd15;
38: present=8'd3;
39: present=8'd3;
40: present=8'd3;
41: present=8'd3;
42: present=8'd3;
43: present=8'd7;
44: present=8'd0;
45: present=8'd3;
46: present=8'd15;
47: present=8'd0;
48: present=8'd31;
49: present=8'd31;
50: present=8'd3;
51: present=8'd3;
52: present=8'd15;
53: present=8'd15;
54: present=8'd15;
55: present=8'd0;
56: present=8'd3;
57: present=8'd7;
58: present=8'd15;
59: present=8'd7;
60: present=8'd63;
61: present=8'd3;
62: present=8'd15;
63: present=8'd15;
64: present=8'd3;
65: present=8'd0;
66: present=8'd0;
67: present=8'd0;
68: present=8'd3;
69: present=8'd0;
70: present=8'd0;
71: present=8'd3;
72: present=8'd7;
73: present=8'd1;
74: present=8'd7;
75: present=8'd3;
76: present=8'd15;
77: present=8'd7;
78: present=8'd0;
79: present=8'd3;
80: present=8'd3;
81: present=8'd15;
82: present=8'd3;
83: present=8'd0;
84: present=8'd3;
85: present=8'd3;
86: present=8'd0;
87: present=8'd0;
88: present=8'd3;
89: present=8'd31;
90: present=8'd3;
91: present=8'd3;
92: present=8'd7;
93: present=8'd3;
94: present=8'd15;
95: present=8'd3;
96: present=8'd3;
97: present=8'd15;
98: present=8'd3;
99: present=8'd3;
100: present=8'd3;
101: present=8'd15;
102: present=8'd7;
103: present=8'd31;
104: present=8'd7;
105: present=8'd0;
106: present=8'd3;
107: present=8'd31;
108: present=8'd31;
109: present=8'd0;
110: present=8'd7;
111: present=8'd3;
112: present=8'd3;
113: present=8'd31;
114: present=8'd31;
115: present=8'd0;
116: present=8'd3;
117: present=8'd7;
118: present=8'd7;
119: present=8'd7;
120: present=8'd15;
121: present=8'd0;
122: present=8'd7;
123: present=8'd3;
124: present=8'd3;
125: present=8'd3;
126: present=8'd3;
127: present=8'd7;
default: present=0;endcase end endfunction
function automatic [7:0] forward(input [6:0] node); begin case(node)
0: forward=8'd3;
1: forward=8'd15;
2: forward=8'd7;
3: forward=8'd7;
4: forward=8'd0;
5: forward=8'd4;
6: forward=8'd32;
7: forward=8'd0;
8: forward=8'd7;
9: forward=8'd3;
10: forward=8'd31;
11: forward=8'd3;
12: forward=8'd16;
13: forward=8'd4;
14: forward=8'd8;
15: forward=8'd0;
16: forward=8'd0;
17: forward=8'd3;
18: forward=8'd0;
19: forward=8'd3;
20: forward=8'd0;
21: forward=8'd0;
22: forward=8'd0;
23: forward=8'd0;
24: forward=8'd7;
25: forward=8'd6;
26: forward=8'd3;
27: forward=8'd14;
28: forward=8'd0;
29: forward=8'd8;
30: forward=8'd2;
31: forward=8'd0;
32: forward=8'd3;
33: forward=8'd3;
34: forward=8'd15;
35: forward=8'd0;
36: forward=8'd0;
37: forward=8'd0;
38: forward=8'd0;
39: forward=8'd0;
40: forward=8'd2;
41: forward=8'd2;
42: forward=8'd3;
43: forward=8'd6;
44: forward=8'd0;
45: forward=8'd0;
46: forward=8'd0;
47: forward=8'd0;
48: forward=8'd30;
49: forward=8'd30;
50: forward=8'd3;
51: forward=8'd3;
52: forward=8'd8;
53: forward=8'd8;
54: forward=8'd8;
55: forward=8'd0;
56: forward=8'd3;
57: forward=8'd7;
58: forward=8'd15;
59: forward=8'd7;
60: forward=8'd32;
61: forward=8'd0;
62: forward=8'd0;
63: forward=8'd8;
64: forward=8'd3;
65: forward=8'd0;
66: forward=8'd0;
67: forward=8'd0;
68: forward=8'd0;
69: forward=8'd0;
70: forward=8'd0;
71: forward=8'd0;
72: forward=8'd7;
73: forward=8'd1;
74: forward=8'd7;
75: forward=8'd3;
76: forward=8'd0;
77: forward=8'd0;
78: forward=8'd0;
79: forward=8'd0;
80: forward=8'd2;
81: forward=8'd14;
82: forward=8'd3;
83: forward=8'd0;
84: forward=8'd0;
85: forward=8'd0;
86: forward=8'd0;
87: forward=8'd0;
88: forward=8'd2;
89: forward=8'd30;
90: forward=8'd2;
91: forward=8'd3;
92: forward=8'd0;
93: forward=8'd2;
94: forward=8'd8;
95: forward=8'd2;
96: forward=8'd3;
97: forward=8'd14;
98: forward=8'd3;
99: forward=8'd3;
100: forward=8'd2;
101: forward=8'd0;
102: forward=8'd0;
103: forward=8'd16;
104: forward=8'd6;
105: forward=8'd0;
106: forward=8'd3;
107: forward=8'd30;
108: forward=8'd16;
109: forward=8'd0;
110: forward=8'd4;
111: forward=8'd0;
112: forward=8'd3;
113: forward=8'd30;
114: forward=8'd30;
115: forward=8'd0;
116: forward=8'd0;
117: forward=8'd0;
118: forward=8'd0;
119: forward=8'd0;
120: forward=8'd15;
121: forward=8'd0;
122: forward=8'd7;
123: forward=8'd3;
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
48: node_color=2'd1;
49: node_color=2'd1;
50: node_color=2'd1;
51: node_color=2'd1;
52: node_color=2'd0;
53: node_color=2'd0;
54: node_color=2'd0;
55: node_color=2'd0;
56: node_color=2'd0;
57: node_color=2'd0;
58: node_color=2'd0;
59: node_color=2'd0;
60: node_color=2'd1;
61: node_color=2'd1;
62: node_color=2'd1;
63: node_color=2'd1;
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
   if(phase==CALCULATE&&!scoring) assert(field_sum>=-12 && field_sum<=12)
     else $fatal(1,"A2 field exceeds configured bound");
   if(active) assert(context_id<R) else $fatal(1,"A2 replica out of range");
 end
`endif
endmodule

// One field/score lane. Each replica and site owns its LFSR and history.
module a2_cluster_640 #(parameter EPIX=1)(
 input wire clk,rst,test_enable,active,score_active,accept,
 input wire seed_we,cfg_we,
 input wire [15:0] seed_addr,
 input wire [9:0] cfg_addr,
 input wire [31:0] data_in,
 input wire [5:0] context_id,beta,
 input wire [1:0] color,
 input wire [2:0] sweep_tag,
 input wire [9:0] beta_sweep,
 input wire [799:0] current,
 input wire [127:0] dirty,
 output reg [127:0] next_bits,
 output wire ready,configured,
 output reg [15:0] fresh_count,
 output reg signed [15:0] score_value);
 localparam N=800,L=128,R=1,BASE=640,FW=5,TW=2,AGE=2;
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
 function automatic [7:0] neighbors(input [6:0] node,input [799:0] bits); begin case(node)
0: neighbors={1'b0,1'b0,1'b0,bits[720],bits[646],bits[645],bits[644],bits[560]};
1: neighbors={1'b0,1'b0,1'b0,bits[647],bits[646],bits[645],bits[644],bits[561]};
2: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[647],bits[645],bits[644]};
3: neighbors={1'b0,1'b0,bits[723],bits[647],bits[646],bits[645],bits[644],bits[563]};
4: neighbors={1'b0,1'b0,1'b0,1'b0,bits[643],bits[642],bits[641],bits[640]};
5: neighbors={1'b0,1'b0,1'b0,bits[653],bits[643],bits[642],bits[641],bits[640]};
6: neighbors={1'b0,1'b0,1'b0,1'b0,bits[654],bits[643],bits[641],bits[640]};
7: neighbors={1'b0,1'b0,1'b0,1'b0,bits[655],bits[643],bits[642],bits[641]};
8: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[728],bits[655]};
9: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
10: neighbors={1'b0,1'b0,1'b0,1'b0,bits[655],bits[654],bits[653],bits[570]};
11: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[731],bits[655]};
12: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
13: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[650],bits[645]};
14: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[650],bits[646]};
15: neighbors={1'b0,1'b0,1'b0,1'b0,bits[651],bits[650],bits[648],bits[647]};
16: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
17: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
18: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[663],bits[661]};
19: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[663],bits[661]};
20: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
21: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[659],bits[658]};
22: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
23: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[659],bits[658]};
24: neighbors={1'b0,1'b0,1'b0,1'b0,bits[744],bits[670],bits[669],bits[668]};
25: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[671],bits[670],bits[668]};
26: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[670],bits[669]};
27: neighbors={1'b0,1'b0,1'b0,1'b0,bits[747],bits[670],bits[669],bits[668]};
28: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[667],bits[665],bits[664]};
29: neighbors={1'b0,1'b0,1'b0,1'b0,bits[677],bits[667],bits[666],bits[664]};
30: neighbors={1'b0,1'b0,1'b0,1'b0,bits[667],bits[666],bits[665],bits[664]};
31: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[679],bits[665]};
32: neighbors={1'b0,1'b0,1'b0,1'b0,bits[679],bits[678],bits[677],bits[676]};
33: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[679],bits[677],bits[593]};
34: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[679],bits[678],bits[594]};
35: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[679],bits[676]};
36: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[675],bits[672]};
37: neighbors={1'b0,1'b0,1'b0,1'b0,bits[685],bits[673],bits[672],bits[669]};
38: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[686],bits[674],bits[672]};
39: neighbors={1'b0,1'b0,1'b0,bits[675],bits[674],bits[673],bits[672],bits[671]};
40: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[687],bits[686],bits[685]};
41: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
42: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[687],bits[684]};
43: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[687],bits[685]};
44: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[692],bits[682]};
45: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[683],bits[680],bits[677]};
46: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[680],bits[678]};
47: neighbors={1'b0,1'b0,1'b0,1'b0,bits[695],bits[683],bits[682],bits[680]};
48: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
49: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[695],bits[694],bits[692]};
50: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[694],bits[693],bits[692]};
51: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[695],bits[693],bits[692]};
52: neighbors={1'b0,1'b0,1'b0,1'b0,bits[691],bits[690],bits[689],bits[684]};
53: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[691],bits[690]};
54: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[690],bits[689]};
55: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[691],bits[689],bits[687]};
56: neighbors={1'b0,1'b0,1'b0,1'b0,bits[776],bits[703],bits[702],bits[701]};
57: neighbors={1'b0,1'b0,1'b0,1'b0,bits[777],bits[703],bits[702],bits[701]};
58: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[703],bits[618]};
59: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[702],bits[701],bits[619]};
60: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
61: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[699],bits[697],bits[696]};
62: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[699],bits[697],bits[696]};
63: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[698],bits[697],bits[696]};
64: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[711],bits[710]};
65: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[710],bits[708]};
66: neighbors={1'b0,1'b0,1'b0,1'b0,bits[711],bits[710],bits[708],bits[626]};
67: neighbors={1'b0,1'b0,1'b0,1'b0,bits[711],bits[710],bits[709],bits[708]};
68: neighbors={1'b0,1'b0,1'b0,1'b0,bits[716],bits[707],bits[706],bits[705]};
69: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[717],bits[707]};
70: neighbors={1'b0,1'b0,1'b0,bits[718],bits[707],bits[706],bits[705],bits[704]};
71: neighbors={1'b0,1'b0,1'b0,1'b0,bits[719],bits[707],bits[706],bits[704]};
72: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[718],bits[716]};
73: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[719],bits[717]};
74: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[717],bits[716]};
75: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[718],bits[717],bits[716]};
76: neighbors={1'b0,1'b0,1'b0,1'b0,bits[715],bits[714],bits[712],bits[708]};
77: neighbors={1'b0,1'b0,1'b0,1'b0,bits[715],bits[714],bits[713],bits[709]};
78: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[715],bits[712],bits[710]};
79: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[713],bits[711]};
80: neighbors={1'b0,1'b0,1'b0,1'b0,bits[727],bits[726],bits[725],bits[640]};
81: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[727],bits[725]};
82: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[725],bits[724]};
83: neighbors={1'b0,1'b0,1'b0,1'b0,bits[727],bits[726],bits[725],bits[643]};
84: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[732],bits[722]};
85: neighbors={1'b0,1'b0,1'b0,bits[733],bits[723],bits[722],bits[721],bits[720]};
86: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[723],bits[720]};
87: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[723],bits[721],bits[720]};
88: neighbors={1'b0,1'b0,1'b0,bits[735],bits[734],bits[733],bits[732],bits[648]};
89: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[735],bits[733],bits[732]};
90: neighbors={1'b0,1'b0,1'b0,1'b0,bits[735],bits[734],bits[733],bits[732]};
91: neighbors={1'b0,1'b0,1'b0,bits[735],bits[734],bits[733],bits[732],bits[651]};
92: neighbors={1'b0,1'b0,1'b0,bits[731],bits[730],bits[729],bits[728],bits[724]};
93: neighbors={1'b0,1'b0,1'b0,bits[731],bits[730],bits[729],bits[728],bits[725]};
94: neighbors={1'b0,1'b0,1'b0,1'b0,bits[742],bits[731],bits[730],bits[728]};
95: neighbors={1'b0,1'b0,1'b0,bits[743],bits[731],bits[730],bits[729],bits[728]};
96: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[743]};
97: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[742],bits[740]};
98: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[743],bits[742],bits[740]};
99: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[743],bits[740]};
100: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[739],bits[738],bits[737]};
101: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
102: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[738],bits[737],bits[734]};
103: neighbors={1'b0,1'b0,1'b0,1'b0,bits[739],bits[738],bits[736],bits[735]};
104: neighbors={1'b0,1'b0,1'b0,bits[751],bits[750],bits[749],bits[748],bits[664]};
105: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[750],bits[749],bits[748]};
106: neighbors={1'b0,1'b0,1'b0,1'b0,bits[751],bits[750],bits[749],bits[748]};
107: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[748],bits[667]};
108: neighbors={1'b0,1'b0,1'b0,1'b0,bits[747],bits[746],bits[745],bits[744]};
109: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[746],bits[745],bits[744]};
110: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[746],bits[745],bits[744]};
111: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[746],bits[744]};
112: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
113: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[759],bits[758],bits[757]};
114: neighbors={1'b0,1'b0,1'b0,1'b0,bits[759],bits[758],bits[757],bits[756]};
115: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[758],bits[757],bits[756]};
116: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[755],bits[754]};
117: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[755],bits[754],bits[753]};
118: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[755],bits[754],bits[753]};
119: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[754],bits[753]};
120: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
121: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
122: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[766],bits[765]};
123: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[765],bits[764]};
124: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[772],bits[763]};
125: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[763],bits[762]};
126: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[774],bits[762]};
127: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
default: neighbors=0;endcase end endfunction
function automatic [7:0] present(input [6:0] node); begin case(node)
0: present=8'd31;
1: present=8'd31;
2: present=8'd7;
3: present=8'd63;
4: present=8'd15;
5: present=8'd31;
6: present=8'd15;
7: present=8'd15;
8: present=8'd3;
9: present=8'd0;
10: present=8'd15;
11: present=8'd3;
12: present=8'd0;
13: present=8'd3;
14: present=8'd3;
15: present=8'd15;
16: present=8'd0;
17: present=8'd0;
18: present=8'd3;
19: present=8'd3;
20: present=8'd0;
21: present=8'd3;
22: present=8'd0;
23: present=8'd3;
24: present=8'd15;
25: present=8'd7;
26: present=8'd3;
27: present=8'd15;
28: present=8'd7;
29: present=8'd15;
30: present=8'd15;
31: present=8'd3;
32: present=8'd15;
33: present=8'd7;
34: present=8'd7;
35: present=8'd3;
36: present=8'd3;
37: present=8'd15;
38: present=8'd7;
39: present=8'd31;
40: present=8'd7;
41: present=8'd0;
42: present=8'd3;
43: present=8'd3;
44: present=8'd3;
45: present=8'd7;
46: present=8'd3;
47: present=8'd15;
48: present=8'd0;
49: present=8'd7;
50: present=8'd7;
51: present=8'd7;
52: present=8'd15;
53: present=8'd3;
54: present=8'd3;
55: present=8'd7;
56: present=8'd15;
57: present=8'd15;
58: present=8'd3;
59: present=8'd7;
60: present=8'd0;
61: present=8'd7;
62: present=8'd7;
63: present=8'd7;
64: present=8'd3;
65: present=8'd3;
66: present=8'd15;
67: present=8'd15;
68: present=8'd15;
69: present=8'd3;
70: present=8'd31;
71: present=8'd15;
72: present=8'd3;
73: present=8'd3;
74: present=8'd3;
75: present=8'd7;
76: present=8'd15;
77: present=8'd15;
78: present=8'd7;
79: present=8'd3;
80: present=8'd15;
81: present=8'd3;
82: present=8'd3;
83: present=8'd15;
84: present=8'd3;
85: present=8'd31;
86: present=8'd3;
87: present=8'd7;
88: present=8'd31;
89: present=8'd7;
90: present=8'd15;
91: present=8'd31;
92: present=8'd31;
93: present=8'd31;
94: present=8'd15;
95: present=8'd31;
96: present=8'd1;
97: present=8'd3;
98: present=8'd7;
99: present=8'd3;
100: present=8'd7;
101: present=8'd0;
102: present=8'd7;
103: present=8'd15;
104: present=8'd31;
105: present=8'd7;
106: present=8'd15;
107: present=8'd3;
108: present=8'd15;
109: present=8'd7;
110: present=8'd7;
111: present=8'd3;
112: present=8'd0;
113: present=8'd7;
114: present=8'd15;
115: present=8'd7;
116: present=8'd3;
117: present=8'd7;
118: present=8'd7;
119: present=8'd3;
120: present=8'd0;
121: present=8'd0;
122: present=8'd3;
123: present=8'd3;
124: present=8'd3;
125: present=8'd3;
126: present=8'd3;
127: present=8'd0;
default: present=0;endcase end endfunction
function automatic [7:0] forward(input [6:0] node); begin case(node)
0: forward=8'd30;
1: forward=8'd30;
2: forward=8'd7;
3: forward=8'd62;
4: forward=8'd0;
5: forward=8'd16;
6: forward=8'd8;
7: forward=8'd8;
8: forward=8'd3;
9: forward=8'd0;
10: forward=8'd14;
11: forward=8'd3;
12: forward=8'd0;
13: forward=8'd0;
14: forward=8'd0;
15: forward=8'd0;
16: forward=8'd0;
17: forward=8'd0;
18: forward=8'd3;
19: forward=8'd3;
20: forward=8'd0;
21: forward=8'd0;
22: forward=8'd0;
23: forward=8'd0;
24: forward=8'd15;
25: forward=8'd7;
26: forward=8'd3;
27: forward=8'd15;
28: forward=8'd0;
29: forward=8'd8;
30: forward=8'd0;
31: forward=8'd2;
32: forward=8'd15;
33: forward=8'd6;
34: forward=8'd6;
35: forward=8'd3;
36: forward=8'd0;
37: forward=8'd8;
38: forward=8'd4;
39: forward=8'd0;
40: forward=8'd7;
41: forward=8'd0;
42: forward=8'd3;
43: forward=8'd3;
44: forward=8'd2;
45: forward=8'd0;
46: forward=8'd0;
47: forward=8'd8;
48: forward=8'd0;
49: forward=8'd7;
50: forward=8'd7;
51: forward=8'd7;
52: forward=8'd0;
53: forward=8'd0;
54: forward=8'd0;
55: forward=8'd0;
56: forward=8'd15;
57: forward=8'd15;
58: forward=8'd2;
59: forward=8'd6;
60: forward=8'd0;
61: forward=8'd0;
62: forward=8'd0;
63: forward=8'd0;
64: forward=8'd3;
65: forward=8'd3;
66: forward=8'd14;
67: forward=8'd15;
68: forward=8'd8;
69: forward=8'd2;
70: forward=8'd16;
71: forward=8'd8;
72: forward=8'd3;
73: forward=8'd3;
74: forward=8'd3;
75: forward=8'd7;
76: forward=8'd0;
77: forward=8'd0;
78: forward=8'd0;
79: forward=8'd0;
80: forward=8'd14;
81: forward=8'd3;
82: forward=8'd3;
83: forward=8'd14;
84: forward=8'd2;
85: forward=8'd16;
86: forward=8'd0;
87: forward=8'd0;
88: forward=8'd30;
89: forward=8'd7;
90: forward=8'd15;
91: forward=8'd30;
92: forward=8'd0;
93: forward=8'd0;
94: forward=8'd8;
95: forward=8'd16;
96: forward=8'd1;
97: forward=8'd3;
98: forward=8'd7;
99: forward=8'd3;
100: forward=8'd0;
101: forward=8'd0;
102: forward=8'd0;
103: forward=8'd0;
104: forward=8'd30;
105: forward=8'd7;
106: forward=8'd15;
107: forward=8'd2;
108: forward=8'd0;
109: forward=8'd0;
110: forward=8'd0;
111: forward=8'd0;
112: forward=8'd0;
113: forward=8'd7;
114: forward=8'd15;
115: forward=8'd7;
116: forward=8'd0;
117: forward=8'd0;
118: forward=8'd0;
119: forward=8'd0;
120: forward=8'd0;
121: forward=8'd0;
122: forward=8'd3;
123: forward=8'd3;
124: forward=8'd2;
125: forward=8'd0;
126: forward=8'd2;
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
64: node_color=2'd0;
65: node_color=2'd0;
66: node_color=2'd0;
67: node_color=2'd0;
68: node_color=2'd1;
69: node_color=2'd1;
70: node_color=2'd1;
71: node_color=2'd1;
72: node_color=2'd1;
73: node_color=2'd1;
74: node_color=2'd1;
75: node_color=2'd1;
76: node_color=2'd0;
77: node_color=2'd0;
78: node_color=2'd0;
79: node_color=2'd0;
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
   if(phase==CALCULATE&&!scoring) assert(field_sum>=-12 && field_sum<=12)
     else $fatal(1,"A2 field exceeds configured bound");
   if(active) assert(context_id<R) else $fatal(1,"A2 replica out of range");
 end
`endif
endmodule

// One field/score lane. Each replica and site owns its LFSR and history.
module a2_cluster_768 #(parameter EPIX=1)(
 input wire clk,rst,test_enable,active,score_active,accept,
 input wire seed_we,cfg_we,
 input wire [15:0] seed_addr,
 input wire [9:0] cfg_addr,
 input wire [31:0] data_in,
 input wire [5:0] context_id,beta,
 input wire [1:0] color,
 input wire [2:0] sweep_tag,
 input wire [9:0] beta_sweep,
 input wire [799:0] current,
 input wire [31:0] dirty,
 output reg [31:0] next_bits,
 output wire ready,configured,
 output reg [15:0] fresh_count,
 output reg signed [15:0] score_value);
 localparam N=800,L=32,R=1,BASE=768,FW=5,TW=2,AGE=2;
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
 function automatic [7:0] neighbors(input [6:0] node,input [799:0] bits); begin case(node)
0: neighbors={1'b0,1'b0,1'b0,1'b0,bits[775],bits[774],bits[773],bits[772]};
1: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[773],bits[772]};
2: neighbors={1'b0,1'b0,1'b0,1'b0,bits[775],bits[774],bits[773],bits[772]};
3: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[775],bits[774],bits[773]};
4: neighbors={1'b0,1'b0,1'b0,1'b0,bits[770],bits[769],bits[768],bits[764]};
5: neighbors={1'b0,1'b0,1'b0,1'b0,bits[771],bits[770],bits[769],bits[768]};
6: neighbors={1'b0,1'b0,1'b0,1'b0,bits[771],bits[770],bits[768],bits[766]};
7: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[771],bits[770],bits[768]};
8: neighbors={1'b0,1'b0,1'b0,bits[783],bits[782],bits[781],bits[780],bits[696]};
9: neighbors={1'b0,1'b0,1'b0,1'b0,bits[783],bits[781],bits[780],bits[697]};
10: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[783],bits[782],bits[781]};
11: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[782],bits[781]};
12: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[777],bits[776]};
13: neighbors={1'b0,1'b0,1'b0,1'b0,bits[779],bits[778],bits[777],bits[776]};
14: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[779],bits[778],bits[776]};
15: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[778],bits[777],bits[776]};
16: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[790],bits[789]};
17: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[791],bits[788]};
18: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[790],bits[789]};
19: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[791],bits[788]};
20: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[787],bits[785]};
21: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[786],bits[784]};
22: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[786],bits[784]};
23: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,bits[787],bits[785]};
24: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
25: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
26: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
27: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
28: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
29: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
30: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
31: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
default: neighbors=0;endcase end endfunction
function automatic [7:0] present(input [6:0] node); begin case(node)
0: present=8'd15;
1: present=8'd3;
2: present=8'd15;
3: present=8'd7;
4: present=8'd15;
5: present=8'd15;
6: present=8'd15;
7: present=8'd7;
8: present=8'd31;
9: present=8'd15;
10: present=8'd7;
11: present=8'd3;
12: present=8'd3;
13: present=8'd15;
14: present=8'd7;
15: present=8'd7;
16: present=8'd3;
17: present=8'd3;
18: present=8'd3;
19: present=8'd3;
20: present=8'd3;
21: present=8'd3;
22: present=8'd3;
23: present=8'd3;
24: present=8'd0;
25: present=8'd0;
26: present=8'd0;
27: present=8'd0;
28: present=8'd0;
29: present=8'd0;
30: present=8'd0;
31: present=8'd0;
default: present=0;endcase end endfunction
function automatic [7:0] forward(input [6:0] node); begin case(node)
0: forward=8'd15;
1: forward=8'd3;
2: forward=8'd15;
3: forward=8'd7;
4: forward=8'd0;
5: forward=8'd0;
6: forward=8'd0;
7: forward=8'd0;
8: forward=8'd30;
9: forward=8'd14;
10: forward=8'd7;
11: forward=8'd3;
12: forward=8'd0;
13: forward=8'd0;
14: forward=8'd0;
15: forward=8'd0;
16: forward=8'd3;
17: forward=8'd3;
18: forward=8'd3;
19: forward=8'd3;
20: forward=8'd0;
21: forward=8'd0;
22: forward=8'd0;
23: forward=8'd0;
24: forward=8'd0;
25: forward=8'd0;
26: forward=8'd0;
27: forward=8'd0;
28: forward=8'd0;
29: forward=8'd0;
30: forward=8'd0;
31: forward=8'd0;
default: forward=0;endcase end endfunction
function automatic [1:0] node_color(input [6:0] node); begin case(node)
0: node_color=2'd1;
1: node_color=2'd1;
2: node_color=2'd1;
3: node_color=2'd1;
4: node_color=2'd0;
5: node_color=2'd0;
6: node_color=2'd0;
7: node_color=2'd0;
8: node_color=2'd0;
9: node_color=2'd0;
10: node_color=2'd0;
11: node_color=2'd0;
12: node_color=2'd1;
13: node_color=2'd1;
14: node_color=2'd1;
15: node_color=2'd1;
16: node_color=2'd1;
17: node_color=2'd1;
18: node_color=2'd1;
19: node_color=2'd1;
20: node_color=2'd0;
21: node_color=2'd0;
22: node_color=2'd0;
23: node_color=2'd0;
24: node_color=2'd0;
25: node_color=2'd0;
26: node_color=2'd0;
27: node_color=2'd0;
28: node_color=2'd1;
29: node_color=2'd1;
30: node_color=2'd1;
31: node_color=2'd1;
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
   if(phase==CALCULATE&&!scoring) assert(field_sum>=-12 && field_sum<=12)
     else $fatal(1,"A2 field exceeds configured bound");
   if(active) assert(context_id<R) else $fatal(1,"A2 replica out of range");
 end
`endif
endmodule
