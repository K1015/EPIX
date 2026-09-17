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
 input wire [127:0] current,
 input wire [127:0] dirty,
 output reg [127:0] next_bits,
 output wire ready,configured,
 output reg [15:0] fresh_count,
 output reg signed [15:0] score_value);
 localparam N=128,L=128,R=24,BASE=0,FW=5,TW=2,AGE=2;
 localparam IDLE=0,SCAN=1,CALCULATE=2,DECIDE=3,SAMPLE=4,READY=5;
 reg [2:0] phase;
 reg [6:0] slot;
 reg scoring;
 reg signed [FW-1:0] raw_value;
 wire nonnegative=raw_value>=0;
 wire [15:0] magnitude=nonnegative ? 16'($signed(raw_value)) : 16'(-$signed(raw_value));
 function automatic [31:0] probability(input logic [3:0] temp,input logic signed [4:0] raw);
begin
case (integer'(temp)*17 + integer'($signed(raw)) + 8)
0: probability = 32'd3969158894;
1: probability = 32'd3782994644;
2: probability = 32'd3659109422;
3: probability = 32'd3511455637;
4: probability = 32'd3338477483;
5: probability = 32'd3139872687;
6: probability = 32'd2673442471;
7: probability = 32'd2414529686;
8: probability = 32'd2147483648;
9: probability = 32'd2414529686;
10: probability = 32'd2673442471;
11: probability = 32'd3139872687;
12: probability = 32'd3338477483;
13: probability = 32'd3511455637;
14: probability = 32'd3659109422;
15: probability = 32'd3782994644;
16: probability = 32'd3969158894;
17: probability = 32'd4169072224;
18: probability = 32'd4091274722;
19: probability = 32'd3969158894;
20: probability = 32'd3885444463;
21: probability = 32'd3659109422;
22: probability = 32'd3338477483;
23: probability = 32'd2917050301;
24: probability = 32'd2673442471;
25: probability = 32'd2147483648;
26: probability = 32'd2673442471;
27: probability = 32'd2917050301;
28: probability = 32'd3338477483;
29: probability = 32'd3659109422;
30: probability = 32'd3885444463;
31: probability = 32'd3969158894;
32: probability = 32'd4091274722;
33: probability = 32'd4169072224;
34: probability = 32'd4247778737;
35: probability = 32'd4217717112;
36: probability = 32'd4169072224;
37: probability = 32'd4036897099;
38: probability = 32'd3885444463;
39: probability = 32'd3659109422;
40: probability = 32'd3338477483;
41: probability = 32'd2673442471;
42: probability = 32'd2147483648;
43: probability = 32'd2673442471;
44: probability = 32'd3338477483;
45: probability = 32'd3659109422;
46: probability = 32'd3885444463;
47: probability = 32'd4036897099;
48: probability = 32'd4169072224;
49: probability = 32'd4217717112;
50: probability = 32'd4247778737;
51: probability = 32'd4281340727;
52: probability = 32'd4266221720;
53: probability = 32'd4234564478;
54: probability = 32'd4169072224;
55: probability = 32'd4036897099;
56: probability = 32'd3885444463;
57: probability = 32'd3511455637;
58: probability = 32'd2917050301;
59: probability = 32'd2147483648;
60: probability = 32'd2917050301;
61: probability = 32'd3511455637;
62: probability = 32'd3885444463;
63: probability = 32'd4036897099;
64: probability = 32'd4169072224;
65: probability = 32'd4234564478;
66: probability = 32'd4266221720;
67: probability = 32'd4281340727;
68: probability = 32'd4291054361;
69: probability = 32'd4286692034;
70: probability = 32'd4272547027;
71: probability = 32'd4247778737;
72: probability = 32'd4169072224;
73: probability = 32'd4036897099;
74: probability = 32'd3659109422;
75: probability = 32'd3139872687;
76: probability = 32'd2147483648;
77: probability = 32'd3139872687;
78: probability = 32'd3659109422;
79: probability = 32'd4036897099;
80: probability = 32'd4169072224;
81: probability = 32'd4247778737;
82: probability = 32'd4272547027;
83: probability = 32'd4286692034;
84: probability = 32'd4291054361;
85: probability = 32'd4294093584;
86: probability = 32'd4292593130;
87: probability = 32'd4286692034;
88: probability = 32'd4272547027;
89: probability = 32'd4234564478;
90: probability = 32'd4134649536;
91: probability = 32'd3782994644;
92: probability = 32'd3139872687;
93: probability = 32'd2147483648;
94: probability = 32'd3139872687;
95: probability = 32'd3782994644;
96: probability = 32'd4134649536;
97: probability = 32'd4234564478;
98: probability = 32'd4272547027;
99: probability = 32'd4286692034;
100: probability = 32'd4292593130;
101: probability = 32'd4294093584;
102: probability = 32'd4294815442;
103: probability = 32'd4294437320;
104: probability = 32'd4293118067;
105: probability = 32'd4288519767;
106: probability = 32'd4272547027;
107: probability = 32'd4217717112;
108: probability = 32'd3969158894;
109: probability = 32'd3338477483;
110: probability = 32'd2147483648;
111: probability = 32'd3338477483;
112: probability = 32'd3969158894;
113: probability = 32'd4217717112;
114: probability = 32'd4272547027;
115: probability = 32'd4288519767;
116: probability = 32'd4293118067;
117: probability = 32'd4294437320;
118: probability = 32'd4294815442;
119: probability = 32'd4294957588;
120: probability = 32'd4294911431;
121: probability = 32'd4294716937;
122: probability = 32'd4293526978;
123: probability = 32'd4288519767;
124: probability = 32'd4258127277;
125: probability = 32'd4134649536;
126: probability = 32'd3511455637;
127: probability = 32'd2147483648;
128: probability = 32'd3511455637;
129: probability = 32'd4134649536;
130: probability = 32'd4258127277;
131: probability = 32'd4288519767;
132: probability = 32'd4293526978;
133: probability = 32'd4294716937;
134: probability = 32'd4294911431;
135: probability = 32'd4294957588;
136: probability = 32'd4294967003;
137: probability = 32'd4294965130;
138: probability = 32'd4294951290;
139: probability = 32'd4294849031;
140: probability = 32'd4293845492;
141: probability = 32'd4286692034;
142: probability = 32'd4234564478;
143: probability = 32'd3782994644;
144: probability = 32'd2147483648;
145: probability = 32'd3782994644;
146: probability = 32'd4234564478;
147: probability = 32'd4286692034;
148: probability = 32'd4293845492;
149: probability = 32'd4294849031;
150: probability = 32'd4294951290;
151: probability = 32'd4294965130;
152: probability = 32'd4294967003;
153: probability = 32'd4294967295;
154: probability = 32'd4294967281;
155: probability = 32'd4294967068;
156: probability = 32'd4294963725;
157: probability = 32'd4294911431;
158: probability = 32'd4294093584;
159: probability = 32'd4277486188;
160: probability = 32'd4036897099;
161: probability = 32'd2147483648;
162: probability = 32'd4036897099;
163: probability = 32'd4277486188;
164: probability = 32'd4294093584;
165: probability = 32'd4294911431;
166: probability = 32'd4294963725;
167: probability = 32'd4294967068;
168: probability = 32'd4294967281;
169: probability = 32'd4294967295;
170: probability = 32'd4294967295;
171: probability = 32'd4294967295;
172: probability = 32'd4294967295;
173: probability = 32'd4294967272;
174: probability = 32'd4294966273;
175: probability = 32'd4294923788;
176: probability = 32'd4293118067;
177: probability = 32'd4196280244;
178: probability = 32'd2147483648;
179: probability = 32'd4196280244;
180: probability = 32'd4293118067;
181: probability = 32'd4294923788;
182: probability = 32'd4294966273;
183: probability = 32'd4294967272;
184: probability = 32'd4294967295;
185: probability = 32'd4294967295;
186: probability = 32'd4294967295;
187: probability = 32'd4294967295;
188: probability = 32'd4294967295;
189: probability = 32'd4294967295;
190: probability = 32'd4294967295;
191: probability = 32'd4294967295;
192: probability = 32'd4294967231;
193: probability = 32'd4294940907;
194: probability = 32'd4284347460;
195: probability = 32'd2147483648;
196: probability = 32'd4284347460;
197: probability = 32'd4294940907;
198: probability = 32'd4294967231;
199: probability = 32'd4294967295;
200: probability = 32'd4294967295;
201: probability = 32'd4294967295;
202: probability = 32'd4294967295;
203: probability = 32'd4294967295;
default: probability=0;
endcase
end
endfunction
 function automatic [7:0] neighbors(input [6:0] node,input [127:0] bits); begin case(node)
0: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[9],bits[8],bits[1]};
1: neighbors={1'b0,1'b0,1'b0,bits[10],bits[9],bits[8],bits[2],bits[0]};
2: neighbors={1'b0,1'b0,1'b0,bits[11],bits[10],bits[9],bits[3],bits[1]};
3: neighbors={1'b0,1'b0,1'b0,bits[12],bits[11],bits[10],bits[4],bits[2]};
4: neighbors={1'b0,1'b0,1'b0,bits[13],bits[12],bits[11],bits[5],bits[3]};
5: neighbors={1'b0,1'b0,1'b0,bits[14],bits[13],bits[12],bits[6],bits[4]};
6: neighbors={1'b0,1'b0,1'b0,bits[15],bits[14],bits[13],bits[7],bits[5]};
7: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[15],bits[14],bits[6]};
8: neighbors={1'b0,1'b0,1'b0,bits[17],bits[16],bits[9],bits[1],bits[0]};
9: neighbors={bits[18],bits[17],bits[16],bits[10],bits[8],bits[2],bits[1],bits[0]};
10: neighbors={bits[19],bits[18],bits[17],bits[11],bits[9],bits[3],bits[2],bits[1]};
11: neighbors={bits[20],bits[19],bits[18],bits[12],bits[10],bits[4],bits[3],bits[2]};
12: neighbors={bits[21],bits[20],bits[19],bits[13],bits[11],bits[5],bits[4],bits[3]};
13: neighbors={bits[22],bits[21],bits[20],bits[14],bits[12],bits[6],bits[5],bits[4]};
14: neighbors={bits[23],bits[22],bits[21],bits[15],bits[13],bits[7],bits[6],bits[5]};
15: neighbors={1'b0,1'b0,1'b0,bits[23],bits[22],bits[14],bits[7],bits[6]};
16: neighbors={1'b0,1'b0,1'b0,bits[25],bits[24],bits[17],bits[9],bits[8]};
17: neighbors={bits[26],bits[25],bits[24],bits[18],bits[16],bits[10],bits[9],bits[8]};
18: neighbors={bits[27],bits[26],bits[25],bits[19],bits[17],bits[11],bits[10],bits[9]};
19: neighbors={bits[28],bits[27],bits[26],bits[20],bits[18],bits[12],bits[11],bits[10]};
20: neighbors={bits[29],bits[28],bits[27],bits[21],bits[19],bits[13],bits[12],bits[11]};
21: neighbors={bits[30],bits[29],bits[28],bits[22],bits[20],bits[14],bits[13],bits[12]};
22: neighbors={bits[31],bits[30],bits[29],bits[23],bits[21],bits[15],bits[14],bits[13]};
23: neighbors={1'b0,1'b0,1'b0,bits[31],bits[30],bits[22],bits[15],bits[14]};
24: neighbors={1'b0,1'b0,1'b0,bits[33],bits[32],bits[25],bits[17],bits[16]};
25: neighbors={bits[34],bits[33],bits[32],bits[26],bits[24],bits[18],bits[17],bits[16]};
26: neighbors={bits[35],bits[34],bits[33],bits[27],bits[25],bits[19],bits[18],bits[17]};
27: neighbors={bits[36],bits[35],bits[34],bits[28],bits[26],bits[20],bits[19],bits[18]};
28: neighbors={bits[37],bits[36],bits[35],bits[29],bits[27],bits[21],bits[20],bits[19]};
29: neighbors={bits[38],bits[37],bits[36],bits[30],bits[28],bits[22],bits[21],bits[20]};
30: neighbors={bits[39],bits[38],bits[37],bits[31],bits[29],bits[23],bits[22],bits[21]};
31: neighbors={1'b0,1'b0,1'b0,bits[39],bits[38],bits[30],bits[23],bits[22]};
32: neighbors={1'b0,1'b0,1'b0,bits[41],bits[40],bits[33],bits[25],bits[24]};
33: neighbors={bits[42],bits[41],bits[40],bits[34],bits[32],bits[26],bits[25],bits[24]};
34: neighbors={bits[43],bits[42],bits[41],bits[35],bits[33],bits[27],bits[26],bits[25]};
35: neighbors={bits[44],bits[43],bits[42],bits[36],bits[34],bits[28],bits[27],bits[26]};
36: neighbors={bits[45],bits[44],bits[43],bits[37],bits[35],bits[29],bits[28],bits[27]};
37: neighbors={bits[46],bits[45],bits[44],bits[38],bits[36],bits[30],bits[29],bits[28]};
38: neighbors={bits[47],bits[46],bits[45],bits[39],bits[37],bits[31],bits[30],bits[29]};
39: neighbors={1'b0,1'b0,1'b0,bits[47],bits[46],bits[38],bits[31],bits[30]};
40: neighbors={1'b0,1'b0,1'b0,bits[49],bits[48],bits[41],bits[33],bits[32]};
41: neighbors={bits[50],bits[49],bits[48],bits[42],bits[40],bits[34],bits[33],bits[32]};
42: neighbors={bits[51],bits[50],bits[49],bits[43],bits[41],bits[35],bits[34],bits[33]};
43: neighbors={bits[52],bits[51],bits[50],bits[44],bits[42],bits[36],bits[35],bits[34]};
44: neighbors={bits[53],bits[52],bits[51],bits[45],bits[43],bits[37],bits[36],bits[35]};
45: neighbors={bits[54],bits[53],bits[52],bits[46],bits[44],bits[38],bits[37],bits[36]};
46: neighbors={bits[55],bits[54],bits[53],bits[47],bits[45],bits[39],bits[38],bits[37]};
47: neighbors={1'b0,1'b0,1'b0,bits[55],bits[54],bits[46],bits[39],bits[38]};
48: neighbors={1'b0,1'b0,1'b0,bits[57],bits[56],bits[49],bits[41],bits[40]};
49: neighbors={bits[58],bits[57],bits[56],bits[50],bits[48],bits[42],bits[41],bits[40]};
50: neighbors={bits[59],bits[58],bits[57],bits[51],bits[49],bits[43],bits[42],bits[41]};
51: neighbors={bits[60],bits[59],bits[58],bits[52],bits[50],bits[44],bits[43],bits[42]};
52: neighbors={bits[61],bits[60],bits[59],bits[53],bits[51],bits[45],bits[44],bits[43]};
53: neighbors={bits[62],bits[61],bits[60],bits[54],bits[52],bits[46],bits[45],bits[44]};
54: neighbors={bits[63],bits[62],bits[61],bits[55],bits[53],bits[47],bits[46],bits[45]};
55: neighbors={1'b0,1'b0,1'b0,bits[63],bits[62],bits[54],bits[47],bits[46]};
56: neighbors={1'b0,1'b0,1'b0,bits[65],bits[64],bits[57],bits[49],bits[48]};
57: neighbors={bits[66],bits[65],bits[64],bits[58],bits[56],bits[50],bits[49],bits[48]};
58: neighbors={bits[67],bits[66],bits[65],bits[59],bits[57],bits[51],bits[50],bits[49]};
59: neighbors={bits[68],bits[67],bits[66],bits[60],bits[58],bits[52],bits[51],bits[50]};
60: neighbors={bits[69],bits[68],bits[67],bits[61],bits[59],bits[53],bits[52],bits[51]};
61: neighbors={bits[70],bits[69],bits[68],bits[62],bits[60],bits[54],bits[53],bits[52]};
62: neighbors={bits[71],bits[70],bits[69],bits[63],bits[61],bits[55],bits[54],bits[53]};
63: neighbors={1'b0,1'b0,1'b0,bits[71],bits[70],bits[62],bits[55],bits[54]};
64: neighbors={1'b0,1'b0,1'b0,bits[73],bits[72],bits[65],bits[57],bits[56]};
65: neighbors={bits[74],bits[73],bits[72],bits[66],bits[64],bits[58],bits[57],bits[56]};
66: neighbors={bits[75],bits[74],bits[73],bits[67],bits[65],bits[59],bits[58],bits[57]};
67: neighbors={bits[76],bits[75],bits[74],bits[68],bits[66],bits[60],bits[59],bits[58]};
68: neighbors={bits[77],bits[76],bits[75],bits[69],bits[67],bits[61],bits[60],bits[59]};
69: neighbors={bits[78],bits[77],bits[76],bits[70],bits[68],bits[62],bits[61],bits[60]};
70: neighbors={bits[79],bits[78],bits[77],bits[71],bits[69],bits[63],bits[62],bits[61]};
71: neighbors={1'b0,1'b0,1'b0,bits[79],bits[78],bits[70],bits[63],bits[62]};
72: neighbors={1'b0,1'b0,1'b0,bits[81],bits[80],bits[73],bits[65],bits[64]};
73: neighbors={bits[82],bits[81],bits[80],bits[74],bits[72],bits[66],bits[65],bits[64]};
74: neighbors={bits[83],bits[82],bits[81],bits[75],bits[73],bits[67],bits[66],bits[65]};
75: neighbors={bits[84],bits[83],bits[82],bits[76],bits[74],bits[68],bits[67],bits[66]};
76: neighbors={bits[85],bits[84],bits[83],bits[77],bits[75],bits[69],bits[68],bits[67]};
77: neighbors={bits[86],bits[85],bits[84],bits[78],bits[76],bits[70],bits[69],bits[68]};
78: neighbors={bits[87],bits[86],bits[85],bits[79],bits[77],bits[71],bits[70],bits[69]};
79: neighbors={1'b0,1'b0,1'b0,bits[87],bits[86],bits[78],bits[71],bits[70]};
80: neighbors={1'b0,1'b0,1'b0,bits[89],bits[88],bits[81],bits[73],bits[72]};
81: neighbors={bits[90],bits[89],bits[88],bits[82],bits[80],bits[74],bits[73],bits[72]};
82: neighbors={bits[91],bits[90],bits[89],bits[83],bits[81],bits[75],bits[74],bits[73]};
83: neighbors={bits[92],bits[91],bits[90],bits[84],bits[82],bits[76],bits[75],bits[74]};
84: neighbors={bits[93],bits[92],bits[91],bits[85],bits[83],bits[77],bits[76],bits[75]};
85: neighbors={bits[94],bits[93],bits[92],bits[86],bits[84],bits[78],bits[77],bits[76]};
86: neighbors={bits[95],bits[94],bits[93],bits[87],bits[85],bits[79],bits[78],bits[77]};
87: neighbors={1'b0,1'b0,1'b0,bits[95],bits[94],bits[86],bits[79],bits[78]};
88: neighbors={1'b0,1'b0,1'b0,bits[97],bits[96],bits[89],bits[81],bits[80]};
89: neighbors={bits[98],bits[97],bits[96],bits[90],bits[88],bits[82],bits[81],bits[80]};
90: neighbors={bits[99],bits[98],bits[97],bits[91],bits[89],bits[83],bits[82],bits[81]};
91: neighbors={bits[100],bits[99],bits[98],bits[92],bits[90],bits[84],bits[83],bits[82]};
92: neighbors={bits[101],bits[100],bits[99],bits[93],bits[91],bits[85],bits[84],bits[83]};
93: neighbors={bits[102],bits[101],bits[100],bits[94],bits[92],bits[86],bits[85],bits[84]};
94: neighbors={bits[103],bits[102],bits[101],bits[95],bits[93],bits[87],bits[86],bits[85]};
95: neighbors={1'b0,1'b0,1'b0,bits[103],bits[102],bits[94],bits[87],bits[86]};
96: neighbors={1'b0,1'b0,1'b0,bits[105],bits[104],bits[97],bits[89],bits[88]};
97: neighbors={bits[106],bits[105],bits[104],bits[98],bits[96],bits[90],bits[89],bits[88]};
98: neighbors={bits[107],bits[106],bits[105],bits[99],bits[97],bits[91],bits[90],bits[89]};
99: neighbors={bits[108],bits[107],bits[106],bits[100],bits[98],bits[92],bits[91],bits[90]};
100: neighbors={bits[109],bits[108],bits[107],bits[101],bits[99],bits[93],bits[92],bits[91]};
101: neighbors={bits[110],bits[109],bits[108],bits[102],bits[100],bits[94],bits[93],bits[92]};
102: neighbors={bits[111],bits[110],bits[109],bits[103],bits[101],bits[95],bits[94],bits[93]};
103: neighbors={1'b0,1'b0,1'b0,bits[111],bits[110],bits[102],bits[95],bits[94]};
104: neighbors={1'b0,1'b0,1'b0,bits[113],bits[112],bits[105],bits[97],bits[96]};
105: neighbors={bits[114],bits[113],bits[112],bits[106],bits[104],bits[98],bits[97],bits[96]};
106: neighbors={bits[115],bits[114],bits[113],bits[107],bits[105],bits[99],bits[98],bits[97]};
107: neighbors={bits[116],bits[115],bits[114],bits[108],bits[106],bits[100],bits[99],bits[98]};
108: neighbors={bits[117],bits[116],bits[115],bits[109],bits[107],bits[101],bits[100],bits[99]};
109: neighbors={bits[118],bits[117],bits[116],bits[110],bits[108],bits[102],bits[101],bits[100]};
110: neighbors={bits[119],bits[118],bits[117],bits[111],bits[109],bits[103],bits[102],bits[101]};
111: neighbors={1'b0,1'b0,1'b0,bits[119],bits[118],bits[110],bits[103],bits[102]};
112: neighbors={1'b0,1'b0,1'b0,bits[121],bits[120],bits[113],bits[105],bits[104]};
113: neighbors={bits[122],bits[121],bits[120],bits[114],bits[112],bits[106],bits[105],bits[104]};
114: neighbors={bits[123],bits[122],bits[121],bits[115],bits[113],bits[107],bits[106],bits[105]};
115: neighbors={bits[124],bits[123],bits[122],bits[116],bits[114],bits[108],bits[107],bits[106]};
116: neighbors={bits[125],bits[124],bits[123],bits[117],bits[115],bits[109],bits[108],bits[107]};
117: neighbors={bits[126],bits[125],bits[124],bits[118],bits[116],bits[110],bits[109],bits[108]};
118: neighbors={bits[127],bits[126],bits[125],bits[119],bits[117],bits[111],bits[110],bits[109]};
119: neighbors={1'b0,1'b0,1'b0,bits[127],bits[126],bits[118],bits[111],bits[110]};
120: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[121],bits[113],bits[112]};
121: neighbors={1'b0,1'b0,1'b0,bits[122],bits[120],bits[114],bits[113],bits[112]};
122: neighbors={1'b0,1'b0,1'b0,bits[123],bits[121],bits[115],bits[114],bits[113]};
123: neighbors={1'b0,1'b0,1'b0,bits[124],bits[122],bits[116],bits[115],bits[114]};
124: neighbors={1'b0,1'b0,1'b0,bits[125],bits[123],bits[117],bits[116],bits[115]};
125: neighbors={1'b0,1'b0,1'b0,bits[126],bits[124],bits[118],bits[117],bits[116]};
126: neighbors={1'b0,1'b0,1'b0,bits[127],bits[125],bits[119],bits[118],bits[117]};
127: neighbors={1'b0,1'b0,1'b0,1'b0,1'b0,bits[126],bits[119],bits[118]};
default: neighbors=0;endcase end endfunction
function automatic [7:0] present(input [6:0] node); begin case(node)
0: present=8'd7;
1: present=8'd31;
2: present=8'd31;
3: present=8'd31;
4: present=8'd31;
5: present=8'd31;
6: present=8'd31;
7: present=8'd7;
8: present=8'd31;
9: present=8'd255;
10: present=8'd255;
11: present=8'd255;
12: present=8'd255;
13: present=8'd255;
14: present=8'd255;
15: present=8'd31;
16: present=8'd31;
17: present=8'd255;
18: present=8'd255;
19: present=8'd255;
20: present=8'd255;
21: present=8'd255;
22: present=8'd255;
23: present=8'd31;
24: present=8'd31;
25: present=8'd255;
26: present=8'd255;
27: present=8'd255;
28: present=8'd255;
29: present=8'd255;
30: present=8'd255;
31: present=8'd31;
32: present=8'd31;
33: present=8'd255;
34: present=8'd255;
35: present=8'd255;
36: present=8'd255;
37: present=8'd255;
38: present=8'd255;
39: present=8'd31;
40: present=8'd31;
41: present=8'd255;
42: present=8'd255;
43: present=8'd255;
44: present=8'd255;
45: present=8'd255;
46: present=8'd255;
47: present=8'd31;
48: present=8'd31;
49: present=8'd255;
50: present=8'd255;
51: present=8'd255;
52: present=8'd255;
53: present=8'd255;
54: present=8'd255;
55: present=8'd31;
56: present=8'd31;
57: present=8'd255;
58: present=8'd255;
59: present=8'd255;
60: present=8'd255;
61: present=8'd255;
62: present=8'd255;
63: present=8'd31;
64: present=8'd31;
65: present=8'd255;
66: present=8'd255;
67: present=8'd255;
68: present=8'd255;
69: present=8'd255;
70: present=8'd255;
71: present=8'd31;
72: present=8'd31;
73: present=8'd255;
74: present=8'd255;
75: present=8'd255;
76: present=8'd255;
77: present=8'd255;
78: present=8'd255;
79: present=8'd31;
80: present=8'd31;
81: present=8'd255;
82: present=8'd255;
83: present=8'd255;
84: present=8'd255;
85: present=8'd255;
86: present=8'd255;
87: present=8'd31;
88: present=8'd31;
89: present=8'd255;
90: present=8'd255;
91: present=8'd255;
92: present=8'd255;
93: present=8'd255;
94: present=8'd255;
95: present=8'd31;
96: present=8'd31;
97: present=8'd255;
98: present=8'd255;
99: present=8'd255;
100: present=8'd255;
101: present=8'd255;
102: present=8'd255;
103: present=8'd31;
104: present=8'd31;
105: present=8'd255;
106: present=8'd255;
107: present=8'd255;
108: present=8'd255;
109: present=8'd255;
110: present=8'd255;
111: present=8'd31;
112: present=8'd31;
113: present=8'd255;
114: present=8'd255;
115: present=8'd255;
116: present=8'd255;
117: present=8'd255;
118: present=8'd255;
119: present=8'd31;
120: present=8'd7;
121: present=8'd31;
122: present=8'd31;
123: present=8'd31;
124: present=8'd31;
125: present=8'd31;
126: present=8'd31;
127: present=8'd7;
default: present=0;endcase end endfunction
function automatic [7:0] forward(input [6:0] node); begin case(node)
0: forward=8'd7;
1: forward=8'd30;
2: forward=8'd30;
3: forward=8'd30;
4: forward=8'd30;
5: forward=8'd30;
6: forward=8'd30;
7: forward=8'd6;
8: forward=8'd28;
9: forward=8'd240;
10: forward=8'd240;
11: forward=8'd240;
12: forward=8'd240;
13: forward=8'd240;
14: forward=8'd240;
15: forward=8'd24;
16: forward=8'd28;
17: forward=8'd240;
18: forward=8'd240;
19: forward=8'd240;
20: forward=8'd240;
21: forward=8'd240;
22: forward=8'd240;
23: forward=8'd24;
24: forward=8'd28;
25: forward=8'd240;
26: forward=8'd240;
27: forward=8'd240;
28: forward=8'd240;
29: forward=8'd240;
30: forward=8'd240;
31: forward=8'd24;
32: forward=8'd28;
33: forward=8'd240;
34: forward=8'd240;
35: forward=8'd240;
36: forward=8'd240;
37: forward=8'd240;
38: forward=8'd240;
39: forward=8'd24;
40: forward=8'd28;
41: forward=8'd240;
42: forward=8'd240;
43: forward=8'd240;
44: forward=8'd240;
45: forward=8'd240;
46: forward=8'd240;
47: forward=8'd24;
48: forward=8'd28;
49: forward=8'd240;
50: forward=8'd240;
51: forward=8'd240;
52: forward=8'd240;
53: forward=8'd240;
54: forward=8'd240;
55: forward=8'd24;
56: forward=8'd28;
57: forward=8'd240;
58: forward=8'd240;
59: forward=8'd240;
60: forward=8'd240;
61: forward=8'd240;
62: forward=8'd240;
63: forward=8'd24;
64: forward=8'd28;
65: forward=8'd240;
66: forward=8'd240;
67: forward=8'd240;
68: forward=8'd240;
69: forward=8'd240;
70: forward=8'd240;
71: forward=8'd24;
72: forward=8'd28;
73: forward=8'd240;
74: forward=8'd240;
75: forward=8'd240;
76: forward=8'd240;
77: forward=8'd240;
78: forward=8'd240;
79: forward=8'd24;
80: forward=8'd28;
81: forward=8'd240;
82: forward=8'd240;
83: forward=8'd240;
84: forward=8'd240;
85: forward=8'd240;
86: forward=8'd240;
87: forward=8'd24;
88: forward=8'd28;
89: forward=8'd240;
90: forward=8'd240;
91: forward=8'd240;
92: forward=8'd240;
93: forward=8'd240;
94: forward=8'd240;
95: forward=8'd24;
96: forward=8'd28;
97: forward=8'd240;
98: forward=8'd240;
99: forward=8'd240;
100: forward=8'd240;
101: forward=8'd240;
102: forward=8'd240;
103: forward=8'd24;
104: forward=8'd28;
105: forward=8'd240;
106: forward=8'd240;
107: forward=8'd240;
108: forward=8'd240;
109: forward=8'd240;
110: forward=8'd240;
111: forward=8'd24;
112: forward=8'd28;
113: forward=8'd240;
114: forward=8'd240;
115: forward=8'd240;
116: forward=8'd240;
117: forward=8'd240;
118: forward=8'd240;
119: forward=8'd24;
120: forward=8'd4;
121: forward=8'd16;
122: forward=8'd16;
123: forward=8'd16;
124: forward=8'd16;
125: forward=8'd16;
126: forward=8'd16;
127: forward=8'd0;
default: forward=0;endcase end endfunction
function automatic [1:0] node_color(input [6:0] node); begin case(node)
0: node_color=2'd0;
1: node_color=2'd1;
2: node_color=2'd0;
3: node_color=2'd1;
4: node_color=2'd0;
5: node_color=2'd1;
6: node_color=2'd0;
7: node_color=2'd1;
8: node_color=2'd2;
9: node_color=2'd3;
10: node_color=2'd2;
11: node_color=2'd3;
12: node_color=2'd2;
13: node_color=2'd3;
14: node_color=2'd2;
15: node_color=2'd3;
16: node_color=2'd0;
17: node_color=2'd1;
18: node_color=2'd0;
19: node_color=2'd1;
20: node_color=2'd0;
21: node_color=2'd1;
22: node_color=2'd0;
23: node_color=2'd1;
24: node_color=2'd2;
25: node_color=2'd3;
26: node_color=2'd2;
27: node_color=2'd3;
28: node_color=2'd2;
29: node_color=2'd3;
30: node_color=2'd2;
31: node_color=2'd3;
32: node_color=2'd0;
33: node_color=2'd1;
34: node_color=2'd0;
35: node_color=2'd1;
36: node_color=2'd0;
37: node_color=2'd1;
38: node_color=2'd0;
39: node_color=2'd1;
40: node_color=2'd2;
41: node_color=2'd3;
42: node_color=2'd2;
43: node_color=2'd3;
44: node_color=2'd2;
45: node_color=2'd3;
46: node_color=2'd2;
47: node_color=2'd3;
48: node_color=2'd0;
49: node_color=2'd1;
50: node_color=2'd0;
51: node_color=2'd1;
52: node_color=2'd0;
53: node_color=2'd1;
54: node_color=2'd0;
55: node_color=2'd1;
56: node_color=2'd2;
57: node_color=2'd3;
58: node_color=2'd2;
59: node_color=2'd3;
60: node_color=2'd2;
61: node_color=2'd3;
62: node_color=2'd2;
63: node_color=2'd3;
64: node_color=2'd0;
65: node_color=2'd1;
66: node_color=2'd0;
67: node_color=2'd1;
68: node_color=2'd0;
69: node_color=2'd1;
70: node_color=2'd0;
71: node_color=2'd1;
72: node_color=2'd2;
73: node_color=2'd3;
74: node_color=2'd2;
75: node_color=2'd3;
76: node_color=2'd2;
77: node_color=2'd3;
78: node_color=2'd2;
79: node_color=2'd3;
80: node_color=2'd0;
81: node_color=2'd1;
82: node_color=2'd0;
83: node_color=2'd1;
84: node_color=2'd0;
85: node_color=2'd1;
86: node_color=2'd0;
87: node_color=2'd1;
88: node_color=2'd2;
89: node_color=2'd3;
90: node_color=2'd2;
91: node_color=2'd3;
92: node_color=2'd2;
93: node_color=2'd3;
94: node_color=2'd2;
95: node_color=2'd3;
96: node_color=2'd0;
97: node_color=2'd1;
98: node_color=2'd0;
99: node_color=2'd1;
100: node_color=2'd0;
101: node_color=2'd1;
102: node_color=2'd0;
103: node_color=2'd1;
104: node_color=2'd2;
105: node_color=2'd3;
106: node_color=2'd2;
107: node_color=2'd3;
108: node_color=2'd2;
109: node_color=2'd3;
110: node_color=2'd2;
111: node_color=2'd3;
112: node_color=2'd0;
113: node_color=2'd1;
114: node_color=2'd0;
115: node_color=2'd1;
116: node_color=2'd0;
117: node_color=2'd1;
118: node_color=2'd0;
119: node_color=2'd1;
120: node_color=2'd2;
121: node_color=2'd3;
122: node_color=2'd2;
123: node_color=2'd3;
124: node_color=2'd2;
125: node_color=2'd3;
126: node_color=2'd2;
127: node_color=2'd3;
default: node_color=0;endcase end endfunction

 wire [31:0] threshold=probability(beta,raw_value);
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
 wire changed=saved_raw!=raw_value;
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
   if(phase==CALCULATE&&!scoring) assert(field_sum>=-8 && field_sum<=8)
     else $fatal(1,"A2 field exceeds configured bound");
   if(active) assert(context_id<R) else $fatal(1,"A2 replica out of range");
 end
`endif
endmodule
