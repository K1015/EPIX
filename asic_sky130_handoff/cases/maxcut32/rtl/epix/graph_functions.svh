// Generated from the frozen certified signed-weight benchmark.
function automatic signed [4:0] raw_field(input integer node,input logic [31:0] bits);
begin
case(node)
0: raw_field = (bits[1] ? -5'sd1 : 5'sd1) + (bits[4] ? 5'sd1 : -5'sd1) + (bits[5] ? -5'sd1 : 5'sd1);
1: raw_field = (bits[0] ? -5'sd1 : 5'sd1) + (bits[2] ? -5'sd1 : 5'sd1) + (bits[4] ? 5'sd1 : -5'sd1) + (bits[5] ? -5'sd1 : 5'sd1) + (bits[6] ? -5'sd1 : 5'sd1);
2: raw_field = (bits[1] ? -5'sd1 : 5'sd1) + (bits[3] ? 5'sd1 : -5'sd1) + (bits[5] ? 5'sd1 : -5'sd1) + (bits[6] ? 5'sd1 : -5'sd1) + (bits[7] ? -5'sd1 : 5'sd1);
3: raw_field = (bits[2] ? 5'sd1 : -5'sd1) + (bits[6] ? 5'sd1 : -5'sd1) + (bits[7] ? -5'sd1 : 5'sd1);
4: raw_field = (bits[0] ? 5'sd1 : -5'sd1) + (bits[1] ? 5'sd1 : -5'sd1) + (bits[5] ? 5'sd1 : -5'sd1) + (bits[8] ? -5'sd1 : 5'sd1) + (bits[9] ? -5'sd1 : 5'sd1);
5: raw_field = (bits[0] ? -5'sd1 : 5'sd1) + (bits[1] ? -5'sd1 : 5'sd1) + (bits[2] ? 5'sd1 : -5'sd1) + (bits[4] ? 5'sd1 : -5'sd1) + (bits[6] ? 5'sd1 : -5'sd1) + (bits[8] ? 5'sd1 : -5'sd1) + (bits[9] ? 5'sd1 : -5'sd1) + (bits[10] ? -5'sd1 : 5'sd1);
6: raw_field = (bits[1] ? -5'sd1 : 5'sd1) + (bits[2] ? 5'sd1 : -5'sd1) + (bits[3] ? 5'sd1 : -5'sd1) + (bits[5] ? 5'sd1 : -5'sd1) + (bits[7] ? 5'sd1 : -5'sd1) + (bits[9] ? 5'sd1 : -5'sd1) + (bits[10] ? -5'sd1 : 5'sd1) + (bits[11] ? 5'sd1 : -5'sd1);
7: raw_field = (bits[2] ? -5'sd1 : 5'sd1) + (bits[3] ? -5'sd1 : 5'sd1) + (bits[6] ? 5'sd1 : -5'sd1) + (bits[10] ? -5'sd1 : 5'sd1) + (bits[11] ? 5'sd1 : -5'sd1);
8: raw_field = (bits[4] ? -5'sd1 : 5'sd1) + (bits[5] ? 5'sd1 : -5'sd1) + (bits[9] ? -5'sd1 : 5'sd1) + (bits[12] ? -5'sd1 : 5'sd1) + (bits[13] ? -5'sd1 : 5'sd1);
9: raw_field = (bits[4] ? -5'sd1 : 5'sd1) + (bits[5] ? 5'sd1 : -5'sd1) + (bits[6] ? 5'sd1 : -5'sd1) + (bits[8] ? -5'sd1 : 5'sd1) + (bits[10] ? 5'sd1 : -5'sd1) + (bits[12] ? 5'sd1 : -5'sd1) + (bits[13] ? 5'sd1 : -5'sd1) + (bits[14] ? -5'sd1 : 5'sd1);
10: raw_field = (bits[5] ? -5'sd1 : 5'sd1) + (bits[6] ? -5'sd1 : 5'sd1) + (bits[7] ? -5'sd1 : 5'sd1) + (bits[9] ? 5'sd1 : -5'sd1) + (bits[11] ? -5'sd1 : 5'sd1) + (bits[13] ? -5'sd1 : 5'sd1) + (bits[14] ? -5'sd1 : 5'sd1) + (bits[15] ? -5'sd1 : 5'sd1);
11: raw_field = (bits[6] ? 5'sd1 : -5'sd1) + (bits[7] ? 5'sd1 : -5'sd1) + (bits[10] ? -5'sd1 : 5'sd1) + (bits[14] ? -5'sd1 : 5'sd1) + (bits[15] ? -5'sd1 : 5'sd1);
12: raw_field = (bits[8] ? -5'sd1 : 5'sd1) + (bits[9] ? 5'sd1 : -5'sd1) + (bits[13] ? -5'sd1 : 5'sd1) + (bits[16] ? 5'sd1 : -5'sd1) + (bits[17] ? -5'sd1 : 5'sd1);
13: raw_field = (bits[8] ? -5'sd1 : 5'sd1) + (bits[9] ? 5'sd1 : -5'sd1) + (bits[10] ? -5'sd1 : 5'sd1) + (bits[12] ? -5'sd1 : 5'sd1) + (bits[14] ? -5'sd1 : 5'sd1) + (bits[16] ? 5'sd1 : -5'sd1) + (bits[17] ? 5'sd1 : -5'sd1) + (bits[18] ? -5'sd1 : 5'sd1);
14: raw_field = (bits[9] ? -5'sd1 : 5'sd1) + (bits[10] ? -5'sd1 : 5'sd1) + (bits[11] ? -5'sd1 : 5'sd1) + (bits[13] ? -5'sd1 : 5'sd1) + (bits[15] ? 5'sd1 : -5'sd1) + (bits[17] ? -5'sd1 : 5'sd1) + (bits[18] ? -5'sd1 : 5'sd1) + (bits[19] ? -5'sd1 : 5'sd1);
15: raw_field = (bits[10] ? -5'sd1 : 5'sd1) + (bits[11] ? -5'sd1 : 5'sd1) + (bits[14] ? 5'sd1 : -5'sd1) + (bits[18] ? 5'sd1 : -5'sd1) + (bits[19] ? -5'sd1 : 5'sd1);
16: raw_field = (bits[12] ? 5'sd1 : -5'sd1) + (bits[13] ? 5'sd1 : -5'sd1) + (bits[17] ? 5'sd1 : -5'sd1) + (bits[20] ? -5'sd1 : 5'sd1) + (bits[21] ? 5'sd1 : -5'sd1);
17: raw_field = (bits[12] ? -5'sd1 : 5'sd1) + (bits[13] ? 5'sd1 : -5'sd1) + (bits[14] ? -5'sd1 : 5'sd1) + (bits[16] ? 5'sd1 : -5'sd1) + (bits[18] ? 5'sd1 : -5'sd1) + (bits[20] ? -5'sd1 : 5'sd1) + (bits[21] ? -5'sd1 : 5'sd1) + (bits[22] ? -5'sd1 : 5'sd1);
18: raw_field = (bits[13] ? -5'sd1 : 5'sd1) + (bits[14] ? -5'sd1 : 5'sd1) + (bits[15] ? 5'sd1 : -5'sd1) + (bits[17] ? 5'sd1 : -5'sd1) + (bits[19] ? -5'sd1 : 5'sd1) + (bits[21] ? -5'sd1 : 5'sd1) + (bits[22] ? 5'sd1 : -5'sd1) + (bits[23] ? 5'sd1 : -5'sd1);
19: raw_field = (bits[14] ? -5'sd1 : 5'sd1) + (bits[15] ? -5'sd1 : 5'sd1) + (bits[18] ? -5'sd1 : 5'sd1) + (bits[22] ? 5'sd1 : -5'sd1) + (bits[23] ? 5'sd1 : -5'sd1);
20: raw_field = (bits[16] ? -5'sd1 : 5'sd1) + (bits[17] ? -5'sd1 : 5'sd1) + (bits[21] ? 5'sd1 : -5'sd1) + (bits[24] ? 5'sd1 : -5'sd1) + (bits[25] ? 5'sd1 : -5'sd1);
21: raw_field = (bits[16] ? 5'sd1 : -5'sd1) + (bits[17] ? -5'sd1 : 5'sd1) + (bits[18] ? -5'sd1 : 5'sd1) + (bits[20] ? 5'sd1 : -5'sd1) + (bits[22] ? 5'sd1 : -5'sd1) + (bits[24] ? 5'sd1 : -5'sd1) + (bits[25] ? 5'sd1 : -5'sd1) + (bits[26] ? -5'sd1 : 5'sd1);
22: raw_field = (bits[17] ? -5'sd1 : 5'sd1) + (bits[18] ? 5'sd1 : -5'sd1) + (bits[19] ? 5'sd1 : -5'sd1) + (bits[21] ? 5'sd1 : -5'sd1) + (bits[23] ? 5'sd1 : -5'sd1) + (bits[25] ? 5'sd1 : -5'sd1) + (bits[26] ? -5'sd1 : 5'sd1) + (bits[27] ? -5'sd1 : 5'sd1);
23: raw_field = (bits[18] ? 5'sd1 : -5'sd1) + (bits[19] ? 5'sd1 : -5'sd1) + (bits[22] ? 5'sd1 : -5'sd1) + (bits[26] ? -5'sd1 : 5'sd1) + (bits[27] ? -5'sd1 : 5'sd1);
24: raw_field = (bits[20] ? 5'sd1 : -5'sd1) + (bits[21] ? 5'sd1 : -5'sd1) + (bits[25] ? 5'sd1 : -5'sd1) + (bits[28] ? 5'sd1 : -5'sd1) + (bits[29] ? 5'sd1 : -5'sd1);
25: raw_field = (bits[20] ? 5'sd1 : -5'sd1) + (bits[21] ? 5'sd1 : -5'sd1) + (bits[22] ? 5'sd1 : -5'sd1) + (bits[24] ? 5'sd1 : -5'sd1) + (bits[26] ? 5'sd1 : -5'sd1) + (bits[28] ? -5'sd1 : 5'sd1) + (bits[29] ? 5'sd1 : -5'sd1) + (bits[30] ? 5'sd1 : -5'sd1);
26: raw_field = (bits[21] ? -5'sd1 : 5'sd1) + (bits[22] ? -5'sd1 : 5'sd1) + (bits[23] ? -5'sd1 : 5'sd1) + (bits[25] ? 5'sd1 : -5'sd1) + (bits[27] ? 5'sd1 : -5'sd1) + (bits[29] ? -5'sd1 : 5'sd1) + (bits[30] ? -5'sd1 : 5'sd1) + (bits[31] ? -5'sd1 : 5'sd1);
27: raw_field = (bits[22] ? -5'sd1 : 5'sd1) + (bits[23] ? -5'sd1 : 5'sd1) + (bits[26] ? 5'sd1 : -5'sd1) + (bits[30] ? -5'sd1 : 5'sd1) + (bits[31] ? -5'sd1 : 5'sd1);
28: raw_field = (bits[24] ? 5'sd1 : -5'sd1) + (bits[25] ? -5'sd1 : 5'sd1) + (bits[29] ? -5'sd1 : 5'sd1);
29: raw_field = (bits[24] ? 5'sd1 : -5'sd1) + (bits[25] ? 5'sd1 : -5'sd1) + (bits[26] ? -5'sd1 : 5'sd1) + (bits[28] ? -5'sd1 : 5'sd1) + (bits[30] ? -5'sd1 : 5'sd1);
30: raw_field = (bits[25] ? 5'sd1 : -5'sd1) + (bits[26] ? -5'sd1 : 5'sd1) + (bits[27] ? -5'sd1 : 5'sd1) + (bits[29] ? -5'sd1 : 5'sd1) + (bits[31] ? 5'sd1 : -5'sd1);
31: raw_field = (bits[26] ? -5'sd1 : 5'sd1) + (bits[27] ? -5'sd1 : 5'sd1) + (bits[30] ? 5'sd1 : -5'sd1);
default: raw_field=0;
endcase
end
endfunction
function automatic signed [7:0] score(input logic [31:0] bits);
begin
score = ((((((((bits[0] ^ bits[1]) ? 8'sd1 : 8'sd0) +
((bits[0] ^ bits[4]) ? -8'sd1 : 8'sd0)) +
(((bits[0] ^ bits[5]) ? 8'sd1 : 8'sd0) +
(((bits[1] ^ bits[2]) ? 8'sd1 : 8'sd0) +
((bits[1] ^ bits[4]) ? -8'sd1 : 8'sd0)))) +
((((bits[1] ^ bits[5]) ? 8'sd1 : 8'sd0) +
(((bits[1] ^ bits[6]) ? 8'sd1 : 8'sd0) +
((bits[2] ^ bits[3]) ? -8'sd1 : 8'sd0))) +
(((bits[2] ^ bits[5]) ? -8'sd1 : 8'sd0) +
(((bits[2] ^ bits[6]) ? -8'sd1 : 8'sd0) +
((bits[2] ^ bits[7]) ? 8'sd1 : 8'sd0))))) +
(((((bits[3] ^ bits[6]) ? -8'sd1 : 8'sd0) +
(((bits[3] ^ bits[7]) ? 8'sd1 : 8'sd0) +
((bits[4] ^ bits[5]) ? -8'sd1 : 8'sd0))) +
(((bits[4] ^ bits[8]) ? 8'sd1 : 8'sd0) +
(((bits[4] ^ bits[9]) ? 8'sd1 : 8'sd0) +
((bits[5] ^ bits[6]) ? -8'sd1 : 8'sd0)))) +
((((bits[5] ^ bits[8]) ? -8'sd1 : 8'sd0) +
(((bits[5] ^ bits[9]) ? -8'sd1 : 8'sd0) +
((bits[5] ^ bits[10]) ? 8'sd1 : 8'sd0))) +
(((bits[6] ^ bits[7]) ? -8'sd1 : 8'sd0) +
(((bits[6] ^ bits[9]) ? -8'sd1 : 8'sd0) +
((bits[6] ^ bits[10]) ? 8'sd1 : 8'sd0)))))) +
((((((bits[6] ^ bits[11]) ? -8'sd1 : 8'sd0) +
(((bits[7] ^ bits[10]) ? 8'sd1 : 8'sd0) +
((bits[7] ^ bits[11]) ? -8'sd1 : 8'sd0))) +
(((bits[8] ^ bits[9]) ? 8'sd1 : 8'sd0) +
(((bits[8] ^ bits[12]) ? 8'sd1 : 8'sd0) +
((bits[8] ^ bits[13]) ? 8'sd1 : 8'sd0)))) +
((((bits[9] ^ bits[10]) ? -8'sd1 : 8'sd0) +
(((bits[9] ^ bits[12]) ? -8'sd1 : 8'sd0) +
((bits[9] ^ bits[13]) ? -8'sd1 : 8'sd0))) +
(((bits[9] ^ bits[14]) ? 8'sd1 : 8'sd0) +
(((bits[10] ^ bits[11]) ? 8'sd1 : 8'sd0) +
((bits[10] ^ bits[13]) ? 8'sd1 : 8'sd0))))) +
(((((bits[10] ^ bits[14]) ? 8'sd1 : 8'sd0) +
(((bits[10] ^ bits[15]) ? 8'sd1 : 8'sd0) +
((bits[11] ^ bits[14]) ? 8'sd1 : 8'sd0))) +
(((bits[11] ^ bits[15]) ? 8'sd1 : 8'sd0) +
(((bits[12] ^ bits[13]) ? 8'sd1 : 8'sd0) +
((bits[12] ^ bits[16]) ? -8'sd1 : 8'sd0)))) +
((((bits[12] ^ bits[17]) ? 8'sd1 : 8'sd0) +
(((bits[13] ^ bits[14]) ? 8'sd1 : 8'sd0) +
((bits[13] ^ bits[16]) ? -8'sd1 : 8'sd0))) +
(((bits[13] ^ bits[17]) ? -8'sd1 : 8'sd0) +
(((bits[13] ^ bits[18]) ? 8'sd1 : 8'sd0) +
((bits[14] ^ bits[15]) ? -8'sd1 : 8'sd0))))))) +
(((((((bits[14] ^ bits[17]) ? 8'sd1 : 8'sd0) +
((bits[14] ^ bits[18]) ? 8'sd1 : 8'sd0)) +
(((bits[14] ^ bits[19]) ? 8'sd1 : 8'sd0) +
(((bits[15] ^ bits[18]) ? -8'sd1 : 8'sd0) +
((bits[15] ^ bits[19]) ? 8'sd1 : 8'sd0)))) +
((((bits[16] ^ bits[17]) ? -8'sd1 : 8'sd0) +
(((bits[16] ^ bits[20]) ? 8'sd1 : 8'sd0) +
((bits[16] ^ bits[21]) ? -8'sd1 : 8'sd0))) +
(((bits[17] ^ bits[18]) ? -8'sd1 : 8'sd0) +
(((bits[17] ^ bits[20]) ? 8'sd1 : 8'sd0) +
((bits[17] ^ bits[21]) ? 8'sd1 : 8'sd0))))) +
(((((bits[17] ^ bits[22]) ? 8'sd1 : 8'sd0) +
(((bits[18] ^ bits[19]) ? 8'sd1 : 8'sd0) +
((bits[18] ^ bits[21]) ? 8'sd1 : 8'sd0))) +
(((bits[18] ^ bits[22]) ? -8'sd1 : 8'sd0) +
(((bits[18] ^ bits[23]) ? -8'sd1 : 8'sd0) +
((bits[19] ^ bits[22]) ? -8'sd1 : 8'sd0)))) +
((((bits[19] ^ bits[23]) ? -8'sd1 : 8'sd0) +
(((bits[20] ^ bits[21]) ? -8'sd1 : 8'sd0) +
((bits[20] ^ bits[24]) ? -8'sd1 : 8'sd0))) +
(((bits[20] ^ bits[25]) ? -8'sd1 : 8'sd0) +
(((bits[21] ^ bits[22]) ? -8'sd1 : 8'sd0) +
((bits[21] ^ bits[24]) ? -8'sd1 : 8'sd0)))))) +
((((((bits[21] ^ bits[25]) ? -8'sd1 : 8'sd0) +
(((bits[21] ^ bits[26]) ? 8'sd1 : 8'sd0) +
((bits[22] ^ bits[23]) ? -8'sd1 : 8'sd0))) +
(((bits[22] ^ bits[25]) ? -8'sd1 : 8'sd0) +
(((bits[22] ^ bits[26]) ? 8'sd1 : 8'sd0) +
((bits[22] ^ bits[27]) ? 8'sd1 : 8'sd0)))) +
((((bits[23] ^ bits[26]) ? 8'sd1 : 8'sd0) +
(((bits[23] ^ bits[27]) ? 8'sd1 : 8'sd0) +
((bits[24] ^ bits[25]) ? -8'sd1 : 8'sd0))) +
(((bits[24] ^ bits[28]) ? -8'sd1 : 8'sd0) +
(((bits[24] ^ bits[29]) ? -8'sd1 : 8'sd0) +
((bits[25] ^ bits[26]) ? -8'sd1 : 8'sd0))))) +
(((((bits[25] ^ bits[28]) ? 8'sd1 : 8'sd0) +
(((bits[25] ^ bits[29]) ? -8'sd1 : 8'sd0) +
((bits[25] ^ bits[30]) ? -8'sd1 : 8'sd0))) +
(((bits[26] ^ bits[27]) ? -8'sd1 : 8'sd0) +
(((bits[26] ^ bits[29]) ? 8'sd1 : 8'sd0) +
((bits[26] ^ bits[30]) ? 8'sd1 : 8'sd0)))) +
((((bits[26] ^ bits[31]) ? 8'sd1 : 8'sd0) +
(((bits[27] ^ bits[30]) ? 8'sd1 : 8'sd0) +
((bits[27] ^ bits[31]) ? 8'sd1 : 8'sd0))) +
(((bits[28] ^ bits[29]) ? 8'sd1 : 8'sd0) +
(((bits[29] ^ bits[30]) ? 8'sd1 : 8'sd0) +
((bits[30] ^ bits[31]) ? -8'sd1 : 8'sd0))))))));
end
endfunction
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
17: probability = 32'd4196280244;
18: probability = 32'd4134649536;
19: probability = 32'd4036897099;
20: probability = 32'd3885444463;
21: probability = 32'd3659109422;
22: probability = 32'd3338477483;
23: probability = 32'd3139872687;
24: probability = 32'd2673442471;
25: probability = 32'd2147483648;
26: probability = 32'd2673442471;
27: probability = 32'd3139872687;
28: probability = 32'd3338477483;
29: probability = 32'd3659109422;
30: probability = 32'd3885444463;
31: probability = 32'd4036897099;
32: probability = 32'd4134649536;
33: probability = 32'd4196280244;
34: probability = 32'd4266221720;
35: probability = 32'd4234564478;
36: probability = 32'd4196280244;
37: probability = 32'd4091274722;
38: probability = 32'd3969158894;
39: probability = 32'd3659109422;
40: probability = 32'd3338477483;
41: probability = 32'd2673442471;
42: probability = 32'd2147483648;
43: probability = 32'd2673442471;
44: probability = 32'd3338477483;
45: probability = 32'd3659109422;
46: probability = 32'd3969158894;
47: probability = 32'd4091274722;
48: probability = 32'd4196280244;
49: probability = 32'd4234564478;
50: probability = 32'd4266221720;
51: probability = 32'd4286692034;
52: probability = 32'd4277486188;
53: probability = 32'd4258127277;
54: probability = 32'd4217717112;
55: probability = 32'd4134649536;
56: probability = 32'd3969158894;
57: probability = 32'd3511455637;
58: probability = 32'd2917050301;
59: probability = 32'd2147483648;
60: probability = 32'd2917050301;
61: probability = 32'd3511455637;
62: probability = 32'd3969158894;
63: probability = 32'd4134649536;
64: probability = 32'd4217717112;
65: probability = 32'd4258127277;
66: probability = 32'd4277486188;
67: probability = 32'd4286692034;
68: probability = 32'd4293118067;
69: probability = 32'd4289944288;
70: probability = 32'd4284347460;
71: probability = 32'd4266221720;
72: probability = 32'd4217717112;
73: probability = 32'd4091274722;
74: probability = 32'd3782994644;
75: probability = 32'd3139872687;
76: probability = 32'd2147483648;
77: probability = 32'd3139872687;
78: probability = 32'd3782994644;
79: probability = 32'd4091274722;
80: probability = 32'd4217717112;
81: probability = 32'd4266221720;
82: probability = 32'd4284347460;
83: probability = 32'd4289944288;
84: probability = 32'd4293118067;
85: probability = 32'd4294716937;
86: probability = 32'd4294093584;
87: probability = 32'd4291919285;
88: probability = 32'd4284347460;
89: probability = 32'd4266221720;
90: probability = 32'd4196280244;
91: probability = 32'd3969158894;
92: probability = 32'd3338477483;
93: probability = 32'd2147483648;
94: probability = 32'd3338477483;
95: probability = 32'd3969158894;
96: probability = 32'd4196280244;
97: probability = 32'd4266221720;
98: probability = 32'd4284347460;
99: probability = 32'd4291919285;
100: probability = 32'd4294093584;
101: probability = 32'd4294716937;
102: probability = 32'd4294946744;
103: probability = 32'd4294875191;
104: probability = 32'd4294554539;
105: probability = 32'd4293118067;
106: probability = 32'd4284347460;
107: probability = 32'd4247778737;
108: probability = 32'd4091274722;
109: probability = 32'd3511455637;
110: probability = 32'd2147483648;
111: probability = 32'd3511455637;
112: probability = 32'd4091274722;
113: probability = 32'd4247778737;
114: probability = 32'd4284347460;
115: probability = 32'd4293118067;
116: probability = 32'd4294554539;
117: probability = 32'd4294875191;
118: probability = 32'd4294946744;
119: probability = 32'd4294966499;
120: probability = 32'd4294961408;
121: probability = 32'd4294933412;
122: probability = 32'd4294716937;
123: probability = 32'd4293118067;
124: probability = 32'd4281340727;
125: probability = 32'd4217717112;
126: probability = 32'd3782994644;
127: probability = 32'd2147483648;
128: probability = 32'd3782994644;
129: probability = 32'd4217717112;
130: probability = 32'd4281340727;
131: probability = 32'd4293118067;
132: probability = 32'd4294716937;
133: probability = 32'd4294933412;
134: probability = 32'd4294961408;
135: probability = 32'd4294966499;
136: probability = 32'd4294967285;
137: probability = 32'd4294967158;
138: probability = 32'd4294965609;
139: probability = 32'd4294946744;
140: probability = 32'd4294716937;
141: probability = 32'd4292593130;
142: probability = 32'd4266221720;
143: probability = 32'd3969158894;
144: probability = 32'd2147483648;
145: probability = 32'd3969158894;
146: probability = 32'd4266221720;
147: probability = 32'd4292593130;
148: probability = 32'd4294716937;
149: probability = 32'd4294946744;
150: probability = 32'd4294965609;
151: probability = 32'd4294967158;
152: probability = 32'd4294967285;
153: probability = 32'd4294967295;
154: probability = 32'd4294967295;
155: probability = 32'd4294967256;
156: probability = 32'd4294966273;
157: probability = 32'd4294946744;
158: probability = 32'd4294554539;
159: probability = 32'd4286692034;
160: probability = 32'd4091274722;
161: probability = 32'd2147483648;
162: probability = 32'd4091274722;
163: probability = 32'd4286692034;
164: probability = 32'd4294554539;
165: probability = 32'd4294946744;
166: probability = 32'd4294966273;
167: probability = 32'd4294967256;
168: probability = 32'd4294967295;
169: probability = 32'd4294967295;
170: probability = 32'd4294967295;
171: probability = 32'd4294967295;
172: probability = 32'd4294967295;
173: probability = 32'd4294967295;
174: probability = 32'd4294967158;
175: probability = 32'd4294957588;
176: probability = 32'd4294286818;
177: probability = 32'd4234564478;
178: probability = 32'd2147483648;
179: probability = 32'd4234564478;
180: probability = 32'd4294286818;
181: probability = 32'd4294957588;
182: probability = 32'd4294967158;
183: probability = 32'd4294967295;
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
function automatic [31:0] swap_threshold(input logic [3:0] left,input logic [7:0] gap);
begin
case(left)
0: begin case(gap)
1: swap_threshold=32'd3672911105;
2: swap_threshold=32'd3140949641;
3: swap_threshold=32'd2686034148;
4: swap_threshold=32'd2297005768;
5: swap_threshold=32'd1964321824;
6: swap_threshold=32'd1679821742;
7: swap_threshold=32'd1436526871;
8: swap_threshold=32'd1228469307;
9: swap_threshold=32'd1050545499;
10: swap_threshold=32'd898391062;
11: swap_threshold=32'd768273721;
12: swap_threshold=32'd657001762;
13: swap_threshold=32'd561845738;
14: swap_threshold=32'd480471516;
15: swap_threshold=32'd410883028;
16: swap_threshold=32'd351373301;
17: swap_threshold=32'd300482591;
18: swap_threshold=32'd256962572;
19: swap_threshold=32'd219745721;
20: swap_threshold=32'd187919126;
21: swap_threshold=32'd160702095;
22: swap_threshold=32'd137427009;
23: swap_threshold=32'd117522941;
24: swap_threshold=32'd100501653;
25: swap_threshold=32'd85945623;
26: swap_threshold=32'd73497796;
27: swap_threshold=32'd62852835;
28: swap_threshold=32'd53749624;
29: swap_threshold=32'd45964865;
30: swap_threshold=32'd39307601;
31: swap_threshold=32'd33614534;
32: swap_threshold=32'd28746015;
33: swap_threshold=32'd24582622;
34: swap_threshold=32'd21022229;
35: swap_threshold=32'd17977501;
36: swap_threshold=32'd15373752;
37: swap_threshold=32'd13147114;
38: swap_threshold=32'd11242968;
39: swap_threshold=32'd9614607;
40: swap_threshold=32'd8222087;
41: swap_threshold=32'd7031251;
42: swap_threshold=32'd6012889;
43: swap_threshold=32'd5142020;
44: swap_threshold=32'd4397282;
45: swap_threshold=32'd3760407;
46: swap_threshold=32'd3215773;
47: swap_threshold=32'd2750020;
48: swap_threshold=32'd2351725;
49: swap_threshold=32'd2011115;
50: swap_threshold=32'd1719838;
51: swap_threshold=32'd1470747;
52: swap_threshold=32'd1257733;
53: swap_threshold=32'd1075571;
54: swap_threshold=32'd919792;
55: swap_threshold=32'd786575;
56: swap_threshold=32'd672652;
57: swap_threshold=32'd575230;
58: swap_threshold=32'd491917;
59: swap_threshold=32'd420671;
60: swap_threshold=32'd359743;
61: swap_threshold=32'd307640;
62: swap_threshold=32'd263083;
63: swap_threshold=32'd224980;
64: swap_threshold=32'd192395;
65: swap_threshold=32'd164530;
66: swap_threshold=32'd140700;
67: swap_threshold=32'd120322;
68: swap_threshold=32'd102895;
69: swap_threshold=32'd87993;
70: swap_threshold=32'd75248;
71: swap_threshold=32'd64350;
72: swap_threshold=32'd55030;
73: swap_threshold=32'd47059;
74: swap_threshold=32'd40243;
75: swap_threshold=32'd34415;
76: swap_threshold=32'd29430;
77: swap_threshold=32'd25168;
78: swap_threshold=32'd21523;
79: swap_threshold=32'd18405;
80: swap_threshold=32'd15739;
81: swap_threshold=32'd13460;
82: swap_threshold=32'd11510;
83: swap_threshold=32'd9843;
84: swap_threshold=32'd8417;
85: swap_threshold=32'd7198;
86: swap_threshold=32'd6156;
87: swap_threshold=32'd5264;
88: swap_threshold=32'd4502;
89: swap_threshold=32'd3849;
90: swap_threshold=32'd3292;
91: swap_threshold=32'd2815;
92: swap_threshold=32'd2407;
93: swap_threshold=32'd2059;
94: swap_threshold=32'd1760;
95: swap_threshold=32'd1505;
96: swap_threshold=32'd1287;
97: swap_threshold=32'd1101;
98: swap_threshold=32'd941;
99: swap_threshold=32'd805;
100: swap_threshold=32'd688;
101: swap_threshold=32'd588;
102: swap_threshold=32'd503;
103: swap_threshold=32'd430;
104: swap_threshold=32'd368;
105: swap_threshold=32'd314;
106: swap_threshold=32'd269;
107: swap_threshold=32'd230;
108: swap_threshold=32'd196;
109: swap_threshold=32'd168;
110: swap_threshold=32'd144;
111: swap_threshold=32'd123;
112: swap_threshold=32'd105;
113: swap_threshold=32'd90;
114: swap_threshold=32'd77;
115: swap_threshold=32'd65;
116: swap_threshold=32'd56;
117: swap_threshold=32'd48;
118: swap_threshold=32'd41;
119: swap_threshold=32'd35;
120: swap_threshold=32'd30;
121: swap_threshold=32'd25;
122: swap_threshold=32'd22;
123: swap_threshold=32'd18;
124: swap_threshold=32'd16;
125: swap_threshold=32'd13;
126: swap_threshold=32'd11;
127: swap_threshold=32'd10;
128: swap_threshold=32'd8;
129: swap_threshold=32'd7;
130: swap_threshold=32'd6;
131: swap_threshold=32'd5;
132: swap_threshold=32'd4;
133: swap_threshold=32'd3;
134: swap_threshold=32'd3;
135: swap_threshold=32'd2;
136: swap_threshold=32'd2;
137: swap_threshold=32'd2;
138: swap_threshold=32'd1;
139: swap_threshold=32'd1;
140: swap_threshold=32'd1;
141: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
1: begin case(gap)
1: swap_threshold=32'd3672911105;
2: swap_threshold=32'd3140949641;
3: swap_threshold=32'd2686034148;
4: swap_threshold=32'd2297005768;
5: swap_threshold=32'd1964321824;
6: swap_threshold=32'd1679821742;
7: swap_threshold=32'd1436526871;
8: swap_threshold=32'd1228469307;
9: swap_threshold=32'd1050545499;
10: swap_threshold=32'd898391062;
11: swap_threshold=32'd768273721;
12: swap_threshold=32'd657001762;
13: swap_threshold=32'd561845738;
14: swap_threshold=32'd480471516;
15: swap_threshold=32'd410883028;
16: swap_threshold=32'd351373301;
17: swap_threshold=32'd300482591;
18: swap_threshold=32'd256962572;
19: swap_threshold=32'd219745721;
20: swap_threshold=32'd187919126;
21: swap_threshold=32'd160702095;
22: swap_threshold=32'd137427009;
23: swap_threshold=32'd117522941;
24: swap_threshold=32'd100501653;
25: swap_threshold=32'd85945623;
26: swap_threshold=32'd73497796;
27: swap_threshold=32'd62852835;
28: swap_threshold=32'd53749624;
29: swap_threshold=32'd45964865;
30: swap_threshold=32'd39307601;
31: swap_threshold=32'd33614534;
32: swap_threshold=32'd28746015;
33: swap_threshold=32'd24582622;
34: swap_threshold=32'd21022229;
35: swap_threshold=32'd17977501;
36: swap_threshold=32'd15373752;
37: swap_threshold=32'd13147114;
38: swap_threshold=32'd11242968;
39: swap_threshold=32'd9614607;
40: swap_threshold=32'd8222087;
41: swap_threshold=32'd7031251;
42: swap_threshold=32'd6012889;
43: swap_threshold=32'd5142020;
44: swap_threshold=32'd4397282;
45: swap_threshold=32'd3760407;
46: swap_threshold=32'd3215773;
47: swap_threshold=32'd2750020;
48: swap_threshold=32'd2351725;
49: swap_threshold=32'd2011115;
50: swap_threshold=32'd1719838;
51: swap_threshold=32'd1470747;
52: swap_threshold=32'd1257733;
53: swap_threshold=32'd1075571;
54: swap_threshold=32'd919792;
55: swap_threshold=32'd786575;
56: swap_threshold=32'd672652;
57: swap_threshold=32'd575230;
58: swap_threshold=32'd491917;
59: swap_threshold=32'd420671;
60: swap_threshold=32'd359743;
61: swap_threshold=32'd307640;
62: swap_threshold=32'd263083;
63: swap_threshold=32'd224980;
64: swap_threshold=32'd192395;
65: swap_threshold=32'd164530;
66: swap_threshold=32'd140700;
67: swap_threshold=32'd120322;
68: swap_threshold=32'd102895;
69: swap_threshold=32'd87993;
70: swap_threshold=32'd75248;
71: swap_threshold=32'd64350;
72: swap_threshold=32'd55030;
73: swap_threshold=32'd47059;
74: swap_threshold=32'd40243;
75: swap_threshold=32'd34415;
76: swap_threshold=32'd29430;
77: swap_threshold=32'd25168;
78: swap_threshold=32'd21523;
79: swap_threshold=32'd18405;
80: swap_threshold=32'd15739;
81: swap_threshold=32'd13460;
82: swap_threshold=32'd11510;
83: swap_threshold=32'd9843;
84: swap_threshold=32'd8417;
85: swap_threshold=32'd7198;
86: swap_threshold=32'd6156;
87: swap_threshold=32'd5264;
88: swap_threshold=32'd4502;
89: swap_threshold=32'd3849;
90: swap_threshold=32'd3292;
91: swap_threshold=32'd2815;
92: swap_threshold=32'd2407;
93: swap_threshold=32'd2059;
94: swap_threshold=32'd1760;
95: swap_threshold=32'd1505;
96: swap_threshold=32'd1287;
97: swap_threshold=32'd1101;
98: swap_threshold=32'd941;
99: swap_threshold=32'd805;
100: swap_threshold=32'd688;
101: swap_threshold=32'd588;
102: swap_threshold=32'd503;
103: swap_threshold=32'd430;
104: swap_threshold=32'd368;
105: swap_threshold=32'd314;
106: swap_threshold=32'd269;
107: swap_threshold=32'd230;
108: swap_threshold=32'd196;
109: swap_threshold=32'd168;
110: swap_threshold=32'd144;
111: swap_threshold=32'd123;
112: swap_threshold=32'd105;
113: swap_threshold=32'd90;
114: swap_threshold=32'd77;
115: swap_threshold=32'd65;
116: swap_threshold=32'd56;
117: swap_threshold=32'd48;
118: swap_threshold=32'd41;
119: swap_threshold=32'd35;
120: swap_threshold=32'd30;
121: swap_threshold=32'd25;
122: swap_threshold=32'd22;
123: swap_threshold=32'd18;
124: swap_threshold=32'd16;
125: swap_threshold=32'd13;
126: swap_threshold=32'd11;
127: swap_threshold=32'd10;
128: swap_threshold=32'd8;
129: swap_threshold=32'd7;
130: swap_threshold=32'd6;
131: swap_threshold=32'd5;
132: swap_threshold=32'd4;
133: swap_threshold=32'd3;
134: swap_threshold=32'd3;
135: swap_threshold=32'd2;
136: swap_threshold=32'd2;
137: swap_threshold=32'd2;
138: swap_threshold=32'd1;
139: swap_threshold=32'd1;
140: swap_threshold=32'd1;
141: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
2: begin case(gap)
1: swap_threshold=32'd3590442270;
2: swap_threshold=32'd3001484017;
3: swap_threshold=32'd2509135540;
4: swap_threshold=32'd2097549454;
5: swap_threshold=32'd1753477897;
6: swap_threshold=32'd1465846123;
7: swap_threshold=32'd1225396032;
8: swap_threshold=32'd1024388175;
9: swap_threshold=32'd856352645;
10: swap_threshold=32'd715880826;
11: swap_threshold=32'd598451304;
12: swap_threshold=32'd500284335;
13: swap_threshold=32'd418220186;
14: swap_threshold=32'd349617431;
15: swap_threshold=32'd292267931;
16: swap_threshold=32'd244325756;
17: swap_threshold=32'd204247777;
18: swap_threshold=32'd170743990;
19: swap_threshold=32'd142735997;
20: swap_threshold=32'd119322295;
21: swap_threshold=32'd99749261;
22: swap_threshold=32'd83386889;
23: swap_threshold=32'd69708519;
24: swap_threshold=32'd58273881;
25: swap_threshold=32'd48714924;
26: swap_threshold=32'd40723971;
27: swap_threshold=32'd34043813;
28: swap_threshold=32'd28459436;
29: swap_threshold=32'd23791092;
30: swap_threshold=32'd19888520;
31: swap_threshold=32'd16626106;
32: swap_threshold=32'd13898842;
33: swap_threshold=32'd11618945;
34: swap_threshold=32'd9713031;
35: swap_threshold=32'd8119754;
36: swap_threshold=32'd6787830;
37: swap_threshold=32'd5674388;
38: swap_threshold=32'd4743590;
39: swap_threshold=32'd3965475;
40: swap_threshold=32'd3314998;
41: swap_threshold=32'd2771222;
42: swap_threshold=32'd2316645;
43: swap_threshold=32'd1936634;
44: swap_threshold=32'd1618958;
45: swap_threshold=32'd1353392;
46: swap_threshold=32'd1131388;
47: swap_threshold=32'd945801;
48: swap_threshold=32'd790656;
49: swap_threshold=32'd660961;
50: swap_threshold=32'd552540;
51: swap_threshold=32'd461904;
52: swap_threshold=32'd386136;
53: swap_threshold=32'd322796;
54: swap_threshold=32'd269846;
55: swap_threshold=32'd225582;
56: swap_threshold=32'd188578;
57: swap_threshold=32'd157645;
58: swap_threshold=32'd131785;
59: swap_threshold=32'd110168;
60: swap_threshold=32'd92096;
61: swap_threshold=32'd76989;
62: swap_threshold=32'd64360;
63: swap_threshold=32'd53803;
64: swap_threshold=32'd44977;
65: swap_threshold=32'd37599;
66: swap_threshold=32'd31432;
67: swap_threshold=32'd26276;
68: swap_threshold=32'd21965;
69: swap_threshold=32'd18362;
70: swap_threshold=32'd15350;
71: swap_threshold=32'd12832;
72: swap_threshold=32'd10727;
73: swap_threshold=32'd8967;
74: swap_threshold=32'd7496;
75: swap_threshold=32'd6267;
76: swap_threshold=32'd5239;
77: swap_threshold=32'd4379;
78: swap_threshold=32'd3661;
79: swap_threshold=32'd3060;
80: swap_threshold=32'd2558;
81: swap_threshold=32'd2138;
82: swap_threshold=32'd1788;
83: swap_threshold=32'd1494;
84: swap_threshold=32'd1249;
85: swap_threshold=32'd1044;
86: swap_threshold=32'd873;
87: swap_threshold=32'd730;
88: swap_threshold=32'd610;
89: swap_threshold=32'd510;
90: swap_threshold=32'd426;
91: swap_threshold=32'd356;
92: swap_threshold=32'd298;
93: swap_threshold=32'd249;
94: swap_threshold=32'd208;
95: swap_threshold=32'd174;
96: swap_threshold=32'd145;
97: swap_threshold=32'd121;
98: swap_threshold=32'd101;
99: swap_threshold=32'd85;
100: swap_threshold=32'd71;
101: swap_threshold=32'd59;
102: swap_threshold=32'd49;
103: swap_threshold=32'd41;
104: swap_threshold=32'd34;
105: swap_threshold=32'd29;
106: swap_threshold=32'd24;
107: swap_threshold=32'd20;
108: swap_threshold=32'd16;
109: swap_threshold=32'd14;
110: swap_threshold=32'd11;
111: swap_threshold=32'd9;
112: swap_threshold=32'd8;
113: swap_threshold=32'd6;
114: swap_threshold=32'd5;
115: swap_threshold=32'd4;
116: swap_threshold=32'd4;
117: swap_threshold=32'd3;
118: swap_threshold=32'd2;
119: swap_threshold=32'd2;
120: swap_threshold=32'd1;
121: swap_threshold=32'd1;
122: swap_threshold=32'd1;
123: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
3: begin case(gap)
1: swap_threshold=32'd3559347135;
2: swap_threshold=32'd2949720255;
3: swap_threshold=32'd2444507167;
4: swap_threshold=32'd2025824409;
5: swap_threshold=32'd1678851504;
6: swap_threshold=32'd1391306354;
7: swap_threshold=32'd1153010476;
8: swap_threshold=32'd955528704;
9: swap_threshold=32'd791870606;
10: swap_threshold=32'd656243035;
11: swap_threshold=32'd543845064;
12: swap_threshold=32'd450698047;
13: swap_threshold=32'd373504777;
14: swap_threshold=32'd309532778;
15: swap_threshold=32'd256517577;
16: swap_threshold=32'd212582551;
17: swap_threshold=32'd176172492;
18: swap_threshold=32'd145998563;
19: swap_threshold=32'd120992672;
20: swap_threshold=32'd100269662;
21: swap_threshold=32'd83095984;
22: swap_threshold=32'd68863726;
23: swap_threshold=32'd57069097;
24: swap_threshold=32'd47294592;
25: swap_threshold=32'd39194215;
26: swap_threshold=32'd32481229;
27: swap_threshold=32'd26918009;
28: swap_threshold=32'd22307629;
29: swap_threshold=32'd18486892;
30: swap_threshold=32'd15320551;
31: swap_threshold=32'd12696525;
32: swap_threshold=32'd10521929;
33: swap_threshold=32'd8719786;
34: swap_threshold=32'd7226305;
35: swap_threshold=32'd5988620;
36: swap_threshold=32'd4962920;
37: swap_threshold=32'd4112896;
38: swap_threshold=32'd3408460;
39: swap_threshold=32'd2824676;
40: swap_threshold=32'd2340880;
41: swap_threshold=32'd1939946;
42: swap_threshold=32'd1607682;
43: swap_threshold=32'd1332326;
44: swap_threshold=32'd1104132;
45: swap_threshold=32'd915022;
46: swap_threshold=32'd758301;
47: swap_threshold=32'd628423;
48: swap_threshold=32'd520790;
49: swap_threshold=32'd431592;
50: swap_threshold=32'd357671;
51: swap_threshold=32'd296411;
52: swap_threshold=32'd245643;
53: swap_threshold=32'd203570;
54: swap_threshold=32'd168704;
55: swap_threshold=32'd139809;
56: swap_threshold=32'd115863;
57: swap_threshold=32'd96019;
58: swap_threshold=32'd79573;
59: swap_threshold=32'd65944;
60: swap_threshold=32'd54649;
61: swap_threshold=32'd45289;
62: swap_threshold=32'd37532;
63: swap_threshold=32'd31104;
64: swap_threshold=32'd25776;
65: swap_threshold=32'd21361;
66: swap_threshold=32'd17703;
67: swap_threshold=32'd14671;
68: swap_threshold=32'd12158;
69: swap_threshold=32'd10075;
70: swap_threshold=32'd8350;
71: swap_threshold=32'd6919;
72: swap_threshold=32'd5734;
73: swap_threshold=32'd4752;
74: swap_threshold=32'd3938;
75: swap_threshold=32'd3263;
76: swap_threshold=32'd2704;
77: swap_threshold=32'd2241;
78: swap_threshold=32'd1857;
79: swap_threshold=32'd1539;
80: swap_threshold=32'd1275;
81: swap_threshold=32'd1057;
82: swap_threshold=32'd876;
83: swap_threshold=32'd726;
84: swap_threshold=32'd601;
85: swap_threshold=32'd498;
86: swap_threshold=32'd413;
87: swap_threshold=32'd342;
88: swap_threshold=32'd283;
89: swap_threshold=32'd235;
90: swap_threshold=32'd194;
91: swap_threshold=32'd161;
92: swap_threshold=32'd133;
93: swap_threshold=32'd110;
94: swap_threshold=32'd91;
95: swap_threshold=32'd76;
96: swap_threshold=32'd63;
97: swap_threshold=32'd52;
98: swap_threshold=32'd43;
99: swap_threshold=32'd35;
100: swap_threshold=32'd29;
101: swap_threshold=32'd24;
102: swap_threshold=32'd20;
103: swap_threshold=32'd16;
104: swap_threshold=32'd14;
105: swap_threshold=32'd11;
106: swap_threshold=32'd9;
107: swap_threshold=32'd7;
108: swap_threshold=32'd6;
109: swap_threshold=32'd5;
110: swap_threshold=32'd4;
111: swap_threshold=32'd3;
112: swap_threshold=32'd3;
113: swap_threshold=32'd2;
114: swap_threshold=32'd2;
115: swap_threshold=32'd1;
116: swap_threshold=32'd1;
117: swap_threshold=32'd1;
118: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
4: begin case(gap)
1: swap_threshold=32'd3361798485;
2: swap_threshold=32'd2631379537;
3: swap_threshold=32'd2059658929;
4: swap_threshold=32'd1612156226;
5: swap_threshold=32'd1261882568;
6: swap_threshold=32'd987712970;
7: swap_threshold=32'd773112282;
8: swap_threshold=32'd605137948;
9: swap_threshold=32'd473659448;
10: swap_threshold=32'd370747320;
11: swap_threshold=32'd290194940;
12: swap_threshold=32'd227144200;
13: swap_threshold=32'd177792513;
14: swap_threshold=32'd139163481;
15: swap_threshold=32'd108927390;
16: swap_threshold=32'd85260704;
17: swap_threshold=32'd66736086;
18: swap_threshold=32'd52236316;
19: swap_threshold=32'd40886916;
20: swap_threshold=32'd32003404;
21: swap_threshold=32'd25050015;
22: swap_threshold=32'd19607391;
23: swap_threshold=32'd15347287;
24: swap_threshold=32'd12012777;
25: swap_threshold=32'd9402758;
26: swap_threshold=32'd7359818;
27: swap_threshold=32'd5760748;
28: swap_threshold=32'd4509108;
29: swap_threshold=32'd3529413;
30: swap_threshold=32'd2762576;
31: swap_threshold=32'd2162350;
32: swap_threshold=32'd1692536;
33: swap_threshold=32'd1324798;
34: swap_threshold=32'd1036959;
35: swap_threshold=32'd811658;
36: swap_threshold=32'd635309;
37: swap_threshold=32'd497275;
38: swap_threshold=32'd389232;
39: swap_threshold=32'd304663;
40: swap_threshold=32'd238469;
41: swap_threshold=32'd186657;
42: swap_threshold=32'd146101;
43: swap_threshold=32'd114358;
44: swap_threshold=32'd89511;
45: swap_threshold=32'd70063;
46: swap_threshold=32'd54840;
47: swap_threshold=32'd42925;
48: swap_threshold=32'd33599;
49: swap_threshold=32'd26298;
50: swap_threshold=32'd20584;
51: swap_threshold=32'd16112;
52: swap_threshold=32'd12611;
53: swap_threshold=32'd9871;
54: swap_threshold=32'd7726;
55: swap_threshold=32'd6047;
56: swap_threshold=32'd4733;
57: swap_threshold=32'd3705;
58: swap_threshold=32'd2900;
59: swap_threshold=32'd2270;
60: swap_threshold=32'd1776;
61: swap_threshold=32'd1390;
62: swap_threshold=32'd1088;
63: swap_threshold=32'd852;
64: swap_threshold=32'd666;
65: swap_threshold=32'd522;
66: swap_threshold=32'd408;
67: swap_threshold=32'd319;
68: swap_threshold=32'd250;
69: swap_threshold=32'd195;
70: swap_threshold=32'd153;
71: swap_threshold=32'd120;
72: swap_threshold=32'd93;
73: swap_threshold=32'd73;
74: swap_threshold=32'd57;
75: swap_threshold=32'd45;
76: swap_threshold=32'd35;
77: swap_threshold=32'd27;
78: swap_threshold=32'd21;
79: swap_threshold=32'd16;
80: swap_threshold=32'd13;
81: swap_threshold=32'd10;
82: swap_threshold=32'd8;
83: swap_threshold=32'd6;
84: swap_threshold=32'd4;
85: swap_threshold=32'd3;
86: swap_threshold=32'd3;
87: swap_threshold=32'd2;
88: swap_threshold=32'd1;
89: swap_threshold=32'd1;
90: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
5: begin case(gap)
1: swap_threshold=32'd3167186500;
2: swap_threshold=32'd2335540561;
3: swap_threshold=32'd1722269817;
4: swap_threshold=32'd1270032887;
5: swap_threshold=32'd936545202;
6: swap_threshold=32'd690625357;
7: swap_threshold=32'd509279619;
8: swap_threshold=32'd375551994;
9: swap_threshold=32'd276938827;
10: swap_threshold=32'd204219696;
11: swap_threshold=32'd150595294;
12: swap_threshold=32'd111051691;
13: swap_threshold=32'd81891524;
14: swap_threshold=32'd60388289;
15: swap_threshold=32'd44531416;
16: swap_threshold=32'd32838271;
17: swap_threshold=32'd24215534;
18: swap_threshold=32'd17856972;
19: swap_threshold=32'd13168054;
20: swap_threshold=32'd9710361;
21: swap_threshold=32'd7160595;
22: swap_threshold=32'd5280352;
23: swap_threshold=32'd3893827;
24: swap_threshold=32'd2871378;
25: swap_threshold=32'd2117406;
26: swap_threshold=32'd1561413;
27: swap_threshold=32'd1151414;
28: swap_threshold=32'd849074;
29: swap_threshold=32'd626122;
30: swap_threshold=32'd461714;
31: swap_threshold=32'd340476;
32: swap_threshold=32'd251073;
33: swap_threshold=32'd185146;
34: swap_threshold=32'd136530;
35: swap_threshold=32'd100679;
36: swap_threshold=32'd74243;
37: swap_threshold=32'd54748;
38: swap_threshold=32'd40372;
39: swap_threshold=32'd29771;
40: swap_threshold=32'd21953;
41: swap_threshold=32'd16189;
42: swap_threshold=32'd11938;
43: swap_threshold=32'd8803;
44: swap_threshold=32'd6491;
45: swap_threshold=32'd4787;
46: swap_threshold=32'd3530;
47: swap_threshold=32'd2603;
48: swap_threshold=32'd1919;
49: swap_threshold=32'd1415;
50: swap_threshold=32'd1043;
51: swap_threshold=32'd769;
52: swap_threshold=32'd567;
53: swap_threshold=32'd418;
54: swap_threshold=32'd308;
55: swap_threshold=32'd227;
56: swap_threshold=32'd167;
57: swap_threshold=32'd123;
58: swap_threshold=32'd91;
59: swap_threshold=32'd67;
60: swap_threshold=32'd49;
61: swap_threshold=32'd36;
62: swap_threshold=32'd26;
63: swap_threshold=32'd19;
64: swap_threshold=32'd14;
65: swap_threshold=32'd10;
66: swap_threshold=32'd7;
67: swap_threshold=32'd5;
68: swap_threshold=32'd4;
69: swap_threshold=32'd3;
70: swap_threshold=32'd2;
71: swap_threshold=32'd1;
72: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
6: begin case(gap)
1: swap_threshold=32'd2837570439;
2: swap_threshold=32'd1874707172;
3: swap_threshold=32'd1238569071;
4: swap_threshold=32'd818289579;
5: swap_threshold=32'd540622119;
6: swap_threshold=32'd357174627;
7: swap_threshold=32'd235975758;
8: swap_threshold=32'd155902895;
9: swap_threshold=32'd103000888;
10: swap_threshold=32'd68049942;
11: swap_threshold=32'd44958783;
12: swap_threshold=32'd29703070;
13: swap_threshold=32'd19624026;
14: swap_threshold=32'd12965071;
15: swap_threshold=32'd8565677;
16: swap_threshold=32'd5659114;
17: swap_threshold=32'd3738826;
18: swap_threshold=32'd2470142;
19: swap_threshold=32'd1631957;
20: swap_threshold=32'd1078190;
21: swap_threshold=32'd712331;
22: swap_threshold=32'd470618;
23: swap_threshold=32'd310925;
24: swap_threshold=32'd205420;
25: swap_threshold=32'd135715;
26: swap_threshold=32'd89663;
27: swap_threshold=32'd59238;
28: swap_threshold=32'd39137;
29: swap_threshold=32'd25856;
30: swap_threshold=32'd17082;
31: swap_threshold=32'd11286;
32: swap_threshold=32'd7456;
33: swap_threshold=32'd4926;
34: swap_threshold=32'd3254;
35: swap_threshold=32'd2150;
36: swap_threshold=32'd1420;
37: swap_threshold=32'd938;
38: swap_threshold=32'd620;
39: swap_threshold=32'd409;
40: swap_threshold=32'd270;
41: swap_threshold=32'd178;
42: swap_threshold=32'd118;
43: swap_threshold=32'd78;
44: swap_threshold=32'd51;
45: swap_threshold=32'd34;
46: swap_threshold=32'd22;
47: swap_threshold=32'd14;
48: swap_threshold=32'd9;
49: swap_threshold=32'd6;
50: swap_threshold=32'd4;
51: swap_threshold=32'd2;
52: swap_threshold=32'd1;
53: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
7: begin case(gap)
1: swap_threshold=32'd2552784687;
2: swap_threshold=32'd1517289704;
3: swap_threshold=32'd901826173;
4: swap_threshold=32'd536015268;
5: swap_threshold=32'd318589519;
6: swap_threshold=32'd189358938;
7: swap_threshold=32'd112548609;
8: swap_threshold=32'd66895123;
9: swap_threshold=32'd39760220;
10: swap_threshold=32'd23632143;
11: swap_threshold=32'd14046154;
12: swap_threshold=32'd8348563;
13: swap_threshold=32'd4962106;
14: swap_threshold=32'd2949309;
15: swap_threshold=32'd1752971;
16: swap_threshold=32'd1041907;
17: swap_threshold=32'd619274;
18: swap_threshold=32'd368076;
19: swap_threshold=32'd218772;
20: swap_threshold=32'd130030;
21: swap_threshold=32'd77285;
22: swap_threshold=32'd45936;
23: swap_threshold=32'd27302;
24: swap_threshold=32'd16227;
25: swap_threshold=32'd9645;
26: swap_threshold=32'd5732;
27: swap_threshold=32'd3407;
28: swap_threshold=32'd2025;
29: swap_threshold=32'd1203;
30: swap_threshold=32'd715;
31: swap_threshold=32'd425;
32: swap_threshold=32'd252;
33: swap_threshold=32'd150;
34: swap_threshold=32'd89;
35: swap_threshold=32'd53;
36: swap_threshold=32'd31;
37: swap_threshold=32'd18;
38: swap_threshold=32'd11;
39: swap_threshold=32'd6;
40: swap_threshold=32'd3;
41: swap_threshold=32'd2;
42: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
8: begin case(gap)
1: swap_threshold=32'd2344249660;
2: swap_threshold=32'd1279522308;
3: swap_threshold=32'd698380110;
4: swap_threshold=32'd381185053;
5: swap_threshold=32'd208055817;
6: swap_threshold=32'd113559602;
7: swap_threshold=32'd61982325;
8: swap_threshold=32'd33830768;
9: swap_threshold=32'd18465278;
10: swap_threshold=32'd10078592;
11: swap_threshold=32'd5501028;
12: swap_threshold=32'd3002533;
13: swap_threshold=32'd1638822;
14: swap_threshold=32'd894490;
15: swap_threshold=32'd488224;
16: swap_threshold=32'd266479;
17: swap_threshold=32'd145448;
18: swap_threshold=32'd79387;
19: swap_threshold=32'd43330;
20: swap_threshold=32'd23650;
21: swap_threshold=32'd12908;
22: swap_threshold=32'd7045;
23: swap_threshold=32'd3845;
24: swap_threshold=32'd2099;
25: swap_threshold=32'd1145;
26: swap_threshold=32'd625;
27: swap_threshold=32'd341;
28: swap_threshold=32'd186;
29: swap_threshold=32'd101;
30: swap_threshold=32'd55;
31: swap_threshold=32'd30;
32: swap_threshold=32'd16;
33: swap_threshold=32'd9;
34: swap_threshold=32'd4;
35: swap_threshold=32'd2;
36: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
9: begin case(gap)
1: swap_threshold=32'd1205096984;
2: swap_threshold=32'd338130337;
3: swap_threshold=32'd94873795;
4: swap_threshold=32'd26620022;
5: swap_threshold=32'd7469139;
6: swap_threshold=32'd2095717;
7: swap_threshold=32'd588023;
8: swap_threshold=32'd164989;
9: swap_threshold=32'd46293;
10: swap_threshold=32'd12989;
11: swap_threshold=32'd3644;
12: swap_threshold=32'd1022;
13: swap_threshold=32'd286;
14: swap_threshold=32'd80;
15: swap_threshold=32'd22;
16: swap_threshold=32'd6;
17: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
10: begin case(gap)
1: swap_threshold=32'd817163170;
2: swap_threshold=32'd155473977;
3: swap_threshold=32'd29580576;
4: swap_threshold=32'd5628019;
5: swap_threshold=32'd1070790;
6: swap_threshold=32'd203729;
7: swap_threshold=32'd38761;
8: swap_threshold=32'd7374;
9: swap_threshold=32'd1403;
10: swap_threshold=32'd266;
11: swap_threshold=32'd50;
12: swap_threshold=32'd9;
13: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
default: swap_threshold=0;
endcase
end
endfunction
function automatic [31:0] expand(input logic [31:0] mask);
begin
expand[0] = mask[0] | mask[1] | mask[4] | mask[5];
expand[1] = mask[1] | mask[0] | mask[2] | mask[4] | mask[5] | mask[6];
expand[2] = mask[2] | mask[1] | mask[3] | mask[5] | mask[6] | mask[7];
expand[3] = mask[3] | mask[2] | mask[6] | mask[7];
expand[4] = mask[4] | mask[0] | mask[1] | mask[5] | mask[8] | mask[9];
expand[5] = mask[5] | mask[0] | mask[1] | mask[2] | mask[4] | mask[6] | mask[8] | mask[9] | mask[10];
expand[6] = mask[6] | mask[1] | mask[2] | mask[3] | mask[5] | mask[7] | mask[9] | mask[10] | mask[11];
expand[7] = mask[7] | mask[2] | mask[3] | mask[6] | mask[10] | mask[11];
expand[8] = mask[8] | mask[4] | mask[5] | mask[9] | mask[12] | mask[13];
expand[9] = mask[9] | mask[4] | mask[5] | mask[6] | mask[8] | mask[10] | mask[12] | mask[13] | mask[14];
expand[10] = mask[10] | mask[5] | mask[6] | mask[7] | mask[9] | mask[11] | mask[13] | mask[14] | mask[15];
expand[11] = mask[11] | mask[6] | mask[7] | mask[10] | mask[14] | mask[15];
expand[12] = mask[12] | mask[8] | mask[9] | mask[13] | mask[16] | mask[17];
expand[13] = mask[13] | mask[8] | mask[9] | mask[10] | mask[12] | mask[14] | mask[16] | mask[17] | mask[18];
expand[14] = mask[14] | mask[9] | mask[10] | mask[11] | mask[13] | mask[15] | mask[17] | mask[18] | mask[19];
expand[15] = mask[15] | mask[10] | mask[11] | mask[14] | mask[18] | mask[19];
expand[16] = mask[16] | mask[12] | mask[13] | mask[17] | mask[20] | mask[21];
expand[17] = mask[17] | mask[12] | mask[13] | mask[14] | mask[16] | mask[18] | mask[20] | mask[21] | mask[22];
expand[18] = mask[18] | mask[13] | mask[14] | mask[15] | mask[17] | mask[19] | mask[21] | mask[22] | mask[23];
expand[19] = mask[19] | mask[14] | mask[15] | mask[18] | mask[22] | mask[23];
expand[20] = mask[20] | mask[16] | mask[17] | mask[21] | mask[24] | mask[25];
expand[21] = mask[21] | mask[16] | mask[17] | mask[18] | mask[20] | mask[22] | mask[24] | mask[25] | mask[26];
expand[22] = mask[22] | mask[17] | mask[18] | mask[19] | mask[21] | mask[23] | mask[25] | mask[26] | mask[27];
expand[23] = mask[23] | mask[18] | mask[19] | mask[22] | mask[26] | mask[27];
expand[24] = mask[24] | mask[20] | mask[21] | mask[25] | mask[28] | mask[29];
expand[25] = mask[25] | mask[20] | mask[21] | mask[22] | mask[24] | mask[26] | mask[28] | mask[29] | mask[30];
expand[26] = mask[26] | mask[21] | mask[22] | mask[23] | mask[25] | mask[27] | mask[29] | mask[30] | mask[31];
expand[27] = mask[27] | mask[22] | mask[23] | mask[26] | mask[30] | mask[31];
expand[28] = mask[28] | mask[24] | mask[25] | mask[29];
expand[29] = mask[29] | mask[24] | mask[25] | mask[26] | mask[28] | mask[30];
expand[30] = mask[30] | mask[25] | mask[26] | mask[27] | mask[29] | mask[31];
expand[31] = mask[31] | mask[26] | mask[27] | mask[30];
end
endfunction
