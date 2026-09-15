// Generated from the frozen certified signed-weight benchmark.
function automatic signed [4:0] raw_field(input integer node,input logic [287:0] bits);
begin
case(node)
0: raw_field = (bits[1] ? 5'sd1 : -5'sd1) + (bits[12] ? -5'sd1 : 5'sd1) + (bits[13] ? 5'sd1 : -5'sd1);
1: raw_field = (bits[0] ? 5'sd1 : -5'sd1) + (bits[2] ? -5'sd1 : 5'sd1) + (bits[12] ? -5'sd1 : 5'sd1) + (bits[13] ? 5'sd1 : -5'sd1) + (bits[14] ? -5'sd1 : 5'sd1);
2: raw_field = (bits[1] ? -5'sd1 : 5'sd1) + (bits[3] ? 5'sd1 : -5'sd1) + (bits[13] ? -5'sd1 : 5'sd1) + (bits[14] ? 5'sd1 : -5'sd1) + (bits[15] ? 5'sd1 : -5'sd1);
3: raw_field = (bits[2] ? 5'sd1 : -5'sd1) + (bits[4] ? -5'sd1 : 5'sd1) + (bits[14] ? -5'sd1 : 5'sd1) + (bits[15] ? -5'sd1 : 5'sd1) + (bits[16] ? -5'sd1 : 5'sd1);
4: raw_field = (bits[3] ? -5'sd1 : 5'sd1) + (bits[5] ? 5'sd1 : -5'sd1) + (bits[15] ? 5'sd1 : -5'sd1) + (bits[16] ? 5'sd1 : -5'sd1) + (bits[17] ? -5'sd1 : 5'sd1);
5: raw_field = (bits[4] ? 5'sd1 : -5'sd1) + (bits[6] ? 5'sd1 : -5'sd1) + (bits[16] ? -5'sd1 : 5'sd1) + (bits[17] ? 5'sd1 : -5'sd1) + (bits[18] ? -5'sd1 : 5'sd1);
6: raw_field = (bits[5] ? 5'sd1 : -5'sd1) + (bits[7] ? -5'sd1 : 5'sd1) + (bits[17] ? -5'sd1 : 5'sd1) + (bits[18] ? -5'sd1 : 5'sd1) + (bits[19] ? 5'sd1 : -5'sd1);
7: raw_field = (bits[6] ? -5'sd1 : 5'sd1) + (bits[8] ? 5'sd1 : -5'sd1) + (bits[18] ? -5'sd1 : 5'sd1) + (bits[19] ? 5'sd1 : -5'sd1) + (bits[20] ? -5'sd1 : 5'sd1);
8: raw_field = (bits[7] ? 5'sd1 : -5'sd1) + (bits[9] ? 5'sd1 : -5'sd1) + (bits[19] ? 5'sd1 : -5'sd1) + (bits[20] ? -5'sd1 : 5'sd1) + (bits[21] ? -5'sd1 : 5'sd1);
9: raw_field = (bits[8] ? 5'sd1 : -5'sd1) + (bits[10] ? -5'sd1 : 5'sd1) + (bits[20] ? -5'sd1 : 5'sd1) + (bits[21] ? -5'sd1 : 5'sd1) + (bits[22] ? 5'sd1 : -5'sd1);
10: raw_field = (bits[9] ? -5'sd1 : 5'sd1) + (bits[11] ? 5'sd1 : -5'sd1) + (bits[21] ? 5'sd1 : -5'sd1) + (bits[22] ? 5'sd1 : -5'sd1) + (bits[23] ? 5'sd1 : -5'sd1);
11: raw_field = (bits[10] ? 5'sd1 : -5'sd1) + (bits[22] ? 5'sd1 : -5'sd1) + (bits[23] ? -5'sd1 : 5'sd1);
12: raw_field = (bits[0] ? -5'sd1 : 5'sd1) + (bits[1] ? -5'sd1 : 5'sd1) + (bits[13] ? 5'sd1 : -5'sd1) + (bits[24] ? 5'sd1 : -5'sd1) + (bits[25] ? 5'sd1 : -5'sd1);
13: raw_field = (bits[0] ? 5'sd1 : -5'sd1) + (bits[1] ? 5'sd1 : -5'sd1) + (bits[2] ? -5'sd1 : 5'sd1) + (bits[12] ? 5'sd1 : -5'sd1) + (bits[14] ? 5'sd1 : -5'sd1) + (bits[24] ? -5'sd1 : 5'sd1) + (bits[25] ? 5'sd1 : -5'sd1) + (bits[26] ? 5'sd1 : -5'sd1);
14: raw_field = (bits[1] ? -5'sd1 : 5'sd1) + (bits[2] ? 5'sd1 : -5'sd1) + (bits[3] ? -5'sd1 : 5'sd1) + (bits[13] ? 5'sd1 : -5'sd1) + (bits[15] ? -5'sd1 : 5'sd1) + (bits[25] ? 5'sd1 : -5'sd1) + (bits[26] ? 5'sd1 : -5'sd1) + (bits[27] ? -5'sd1 : 5'sd1);
15: raw_field = (bits[2] ? 5'sd1 : -5'sd1) + (bits[3] ? -5'sd1 : 5'sd1) + (bits[4] ? 5'sd1 : -5'sd1) + (bits[14] ? -5'sd1 : 5'sd1) + (bits[16] ? -5'sd1 : 5'sd1) + (bits[26] ? 5'sd1 : -5'sd1) + (bits[27] ? 5'sd1 : -5'sd1) + (bits[28] ? 5'sd1 : -5'sd1);
16: raw_field = (bits[3] ? -5'sd1 : 5'sd1) + (bits[4] ? 5'sd1 : -5'sd1) + (bits[5] ? -5'sd1 : 5'sd1) + (bits[15] ? -5'sd1 : 5'sd1) + (bits[17] ? -5'sd1 : 5'sd1) + (bits[27] ? -5'sd1 : 5'sd1) + (bits[28] ? 5'sd1 : -5'sd1) + (bits[29] ? -5'sd1 : 5'sd1);
17: raw_field = (bits[4] ? -5'sd1 : 5'sd1) + (bits[5] ? 5'sd1 : -5'sd1) + (bits[6] ? -5'sd1 : 5'sd1) + (bits[16] ? -5'sd1 : 5'sd1) + (bits[18] ? -5'sd1 : 5'sd1) + (bits[28] ? 5'sd1 : -5'sd1) + (bits[29] ? 5'sd1 : -5'sd1) + (bits[30] ? 5'sd1 : -5'sd1);
18: raw_field = (bits[5] ? -5'sd1 : 5'sd1) + (bits[6] ? -5'sd1 : 5'sd1) + (bits[7] ? -5'sd1 : 5'sd1) + (bits[17] ? -5'sd1 : 5'sd1) + (bits[19] ? 5'sd1 : -5'sd1) + (bits[29] ? -5'sd1 : 5'sd1) + (bits[30] ? 5'sd1 : -5'sd1) + (bits[31] ? -5'sd1 : 5'sd1);
19: raw_field = (bits[6] ? 5'sd1 : -5'sd1) + (bits[7] ? 5'sd1 : -5'sd1) + (bits[8] ? 5'sd1 : -5'sd1) + (bits[18] ? 5'sd1 : -5'sd1) + (bits[20] ? 5'sd1 : -5'sd1) + (bits[30] ? 5'sd1 : -5'sd1) + (bits[31] ? 5'sd1 : -5'sd1) + (bits[32] ? -5'sd1 : 5'sd1);
20: raw_field = (bits[7] ? -5'sd1 : 5'sd1) + (bits[8] ? -5'sd1 : 5'sd1) + (bits[9] ? -5'sd1 : 5'sd1) + (bits[19] ? 5'sd1 : -5'sd1) + (bits[21] ? 5'sd1 : -5'sd1) + (bits[31] ? 5'sd1 : -5'sd1) + (bits[32] ? -5'sd1 : 5'sd1) + (bits[33] ? 5'sd1 : -5'sd1);
21: raw_field = (bits[8] ? -5'sd1 : 5'sd1) + (bits[9] ? -5'sd1 : 5'sd1) + (bits[10] ? 5'sd1 : -5'sd1) + (bits[20] ? 5'sd1 : -5'sd1) + (bits[22] ? 5'sd1 : -5'sd1) + (bits[32] ? -5'sd1 : 5'sd1) + (bits[33] ? 5'sd1 : -5'sd1) + (bits[34] ? 5'sd1 : -5'sd1);
22: raw_field = (bits[9] ? 5'sd1 : -5'sd1) + (bits[10] ? 5'sd1 : -5'sd1) + (bits[11] ? 5'sd1 : -5'sd1) + (bits[21] ? 5'sd1 : -5'sd1) + (bits[23] ? 5'sd1 : -5'sd1) + (bits[33] ? -5'sd1 : 5'sd1) + (bits[34] ? 5'sd1 : -5'sd1) + (bits[35] ? 5'sd1 : -5'sd1);
23: raw_field = (bits[10] ? 5'sd1 : -5'sd1) + (bits[11] ? -5'sd1 : 5'sd1) + (bits[22] ? 5'sd1 : -5'sd1) + (bits[34] ? 5'sd1 : -5'sd1) + (bits[35] ? 5'sd1 : -5'sd1);
24: raw_field = (bits[12] ? 5'sd1 : -5'sd1) + (bits[13] ? -5'sd1 : 5'sd1) + (bits[25] ? -5'sd1 : 5'sd1) + (bits[36] ? 5'sd1 : -5'sd1) + (bits[37] ? -5'sd1 : 5'sd1);
25: raw_field = (bits[12] ? 5'sd1 : -5'sd1) + (bits[13] ? 5'sd1 : -5'sd1) + (bits[14] ? 5'sd1 : -5'sd1) + (bits[24] ? -5'sd1 : 5'sd1) + (bits[26] ? 5'sd1 : -5'sd1) + (bits[36] ? -5'sd1 : 5'sd1) + (bits[37] ? 5'sd1 : -5'sd1) + (bits[38] ? 5'sd1 : -5'sd1);
26: raw_field = (bits[13] ? 5'sd1 : -5'sd1) + (bits[14] ? 5'sd1 : -5'sd1) + (bits[15] ? 5'sd1 : -5'sd1) + (bits[25] ? 5'sd1 : -5'sd1) + (bits[27] ? 5'sd1 : -5'sd1) + (bits[37] ? 5'sd1 : -5'sd1) + (bits[38] ? 5'sd1 : -5'sd1) + (bits[39] ? -5'sd1 : 5'sd1);
27: raw_field = (bits[14] ? -5'sd1 : 5'sd1) + (bits[15] ? 5'sd1 : -5'sd1) + (bits[16] ? -5'sd1 : 5'sd1) + (bits[26] ? 5'sd1 : -5'sd1) + (bits[28] ? -5'sd1 : 5'sd1) + (bits[38] ? -5'sd1 : 5'sd1) + (bits[39] ? -5'sd1 : 5'sd1) + (bits[40] ? -5'sd1 : 5'sd1);
28: raw_field = (bits[15] ? 5'sd1 : -5'sd1) + (bits[16] ? 5'sd1 : -5'sd1) + (bits[17] ? 5'sd1 : -5'sd1) + (bits[27] ? -5'sd1 : 5'sd1) + (bits[29] ? 5'sd1 : -5'sd1) + (bits[39] ? 5'sd1 : -5'sd1) + (bits[40] ? 5'sd1 : -5'sd1) + (bits[41] ? -5'sd1 : 5'sd1);
29: raw_field = (bits[16] ? -5'sd1 : 5'sd1) + (bits[17] ? 5'sd1 : -5'sd1) + (bits[18] ? -5'sd1 : 5'sd1) + (bits[28] ? 5'sd1 : -5'sd1) + (bits[30] ? -5'sd1 : 5'sd1) + (bits[40] ? -5'sd1 : 5'sd1) + (bits[41] ? -5'sd1 : 5'sd1) + (bits[42] ? 5'sd1 : -5'sd1);
30: raw_field = (bits[17] ? 5'sd1 : -5'sd1) + (bits[18] ? 5'sd1 : -5'sd1) + (bits[19] ? 5'sd1 : -5'sd1) + (bits[29] ? -5'sd1 : 5'sd1) + (bits[31] ? -5'sd1 : 5'sd1) + (bits[41] ? 5'sd1 : -5'sd1) + (bits[42] ? -5'sd1 : 5'sd1) + (bits[43] ? -5'sd1 : 5'sd1);
31: raw_field = (bits[18] ? -5'sd1 : 5'sd1) + (bits[19] ? 5'sd1 : -5'sd1) + (bits[20] ? 5'sd1 : -5'sd1) + (bits[30] ? -5'sd1 : 5'sd1) + (bits[32] ? -5'sd1 : 5'sd1) + (bits[42] ? -5'sd1 : 5'sd1) + (bits[43] ? 5'sd1 : -5'sd1) + (bits[44] ? -5'sd1 : 5'sd1);
32: raw_field = (bits[19] ? -5'sd1 : 5'sd1) + (bits[20] ? -5'sd1 : 5'sd1) + (bits[21] ? -5'sd1 : 5'sd1) + (bits[31] ? -5'sd1 : 5'sd1) + (bits[33] ? -5'sd1 : 5'sd1) + (bits[43] ? 5'sd1 : -5'sd1) + (bits[44] ? 5'sd1 : -5'sd1) + (bits[45] ? 5'sd1 : -5'sd1);
33: raw_field = (bits[20] ? 5'sd1 : -5'sd1) + (bits[21] ? 5'sd1 : -5'sd1) + (bits[22] ? -5'sd1 : 5'sd1) + (bits[32] ? -5'sd1 : 5'sd1) + (bits[34] ? -5'sd1 : 5'sd1) + (bits[44] ? -5'sd1 : 5'sd1) + (bits[45] ? -5'sd1 : 5'sd1) + (bits[46] ? -5'sd1 : 5'sd1);
34: raw_field = (bits[21] ? 5'sd1 : -5'sd1) + (bits[22] ? 5'sd1 : -5'sd1) + (bits[23] ? 5'sd1 : -5'sd1) + (bits[33] ? -5'sd1 : 5'sd1) + (bits[35] ? 5'sd1 : -5'sd1) + (bits[45] ? -5'sd1 : 5'sd1) + (bits[46] ? 5'sd1 : -5'sd1) + (bits[47] ? 5'sd1 : -5'sd1);
35: raw_field = (bits[22] ? 5'sd1 : -5'sd1) + (bits[23] ? 5'sd1 : -5'sd1) + (bits[34] ? 5'sd1 : -5'sd1) + (bits[46] ? 5'sd1 : -5'sd1) + (bits[47] ? 5'sd1 : -5'sd1);
36: raw_field = (bits[24] ? 5'sd1 : -5'sd1) + (bits[25] ? -5'sd1 : 5'sd1) + (bits[37] ? -5'sd1 : 5'sd1) + (bits[48] ? 5'sd1 : -5'sd1) + (bits[49] ? 5'sd1 : -5'sd1);
37: raw_field = (bits[24] ? -5'sd1 : 5'sd1) + (bits[25] ? 5'sd1 : -5'sd1) + (bits[26] ? 5'sd1 : -5'sd1) + (bits[36] ? -5'sd1 : 5'sd1) + (bits[38] ? -5'sd1 : 5'sd1) + (bits[48] ? 5'sd1 : -5'sd1) + (bits[49] ? 5'sd1 : -5'sd1) + (bits[50] ? 5'sd1 : -5'sd1);
38: raw_field = (bits[25] ? 5'sd1 : -5'sd1) + (bits[26] ? 5'sd1 : -5'sd1) + (bits[27] ? -5'sd1 : 5'sd1) + (bits[37] ? -5'sd1 : 5'sd1) + (bits[39] ? 5'sd1 : -5'sd1) + (bits[49] ? -5'sd1 : 5'sd1) + (bits[50] ? -5'sd1 : 5'sd1) + (bits[51] ? 5'sd1 : -5'sd1);
39: raw_field = (bits[26] ? -5'sd1 : 5'sd1) + (bits[27] ? -5'sd1 : 5'sd1) + (bits[28] ? 5'sd1 : -5'sd1) + (bits[38] ? 5'sd1 : -5'sd1) + (bits[40] ? 5'sd1 : -5'sd1) + (bits[50] ? -5'sd1 : 5'sd1) + (bits[51] ? 5'sd1 : -5'sd1) + (bits[52] ? 5'sd1 : -5'sd1);
40: raw_field = (bits[27] ? -5'sd1 : 5'sd1) + (bits[28] ? 5'sd1 : -5'sd1) + (bits[29] ? -5'sd1 : 5'sd1) + (bits[39] ? 5'sd1 : -5'sd1) + (bits[41] ? -5'sd1 : 5'sd1) + (bits[51] ? -5'sd1 : 5'sd1) + (bits[52] ? -5'sd1 : 5'sd1) + (bits[53] ? -5'sd1 : 5'sd1);
41: raw_field = (bits[28] ? -5'sd1 : 5'sd1) + (bits[29] ? -5'sd1 : 5'sd1) + (bits[30] ? 5'sd1 : -5'sd1) + (bits[40] ? -5'sd1 : 5'sd1) + (bits[42] ? -5'sd1 : 5'sd1) + (bits[52] ? 5'sd1 : -5'sd1) + (bits[53] ? -5'sd1 : 5'sd1) + (bits[54] ? 5'sd1 : -5'sd1);
42: raw_field = (bits[29] ? 5'sd1 : -5'sd1) + (bits[30] ? -5'sd1 : 5'sd1) + (bits[31] ? -5'sd1 : 5'sd1) + (bits[41] ? -5'sd1 : 5'sd1) + (bits[43] ? -5'sd1 : 5'sd1) + (bits[53] ? 5'sd1 : -5'sd1) + (bits[54] ? -5'sd1 : 5'sd1) + (bits[55] ? -5'sd1 : 5'sd1);
43: raw_field = (bits[30] ? -5'sd1 : 5'sd1) + (bits[31] ? 5'sd1 : -5'sd1) + (bits[32] ? 5'sd1 : -5'sd1) + (bits[42] ? -5'sd1 : 5'sd1) + (bits[44] ? -5'sd1 : 5'sd1) + (bits[54] ? 5'sd1 : -5'sd1) + (bits[55] ? 5'sd1 : -5'sd1) + (bits[56] ? -5'sd1 : 5'sd1);
44: raw_field = (bits[31] ? -5'sd1 : 5'sd1) + (bits[32] ? 5'sd1 : -5'sd1) + (bits[33] ? -5'sd1 : 5'sd1) + (bits[43] ? -5'sd1 : 5'sd1) + (bits[45] ? -5'sd1 : 5'sd1) + (bits[55] ? -5'sd1 : 5'sd1) + (bits[56] ? 5'sd1 : -5'sd1) + (bits[57] ? -5'sd1 : 5'sd1);
45: raw_field = (bits[32] ? 5'sd1 : -5'sd1) + (bits[33] ? -5'sd1 : 5'sd1) + (bits[34] ? -5'sd1 : 5'sd1) + (bits[44] ? -5'sd1 : 5'sd1) + (bits[46] ? 5'sd1 : -5'sd1) + (bits[56] ? -5'sd1 : 5'sd1) + (bits[57] ? 5'sd1 : -5'sd1) + (bits[58] ? -5'sd1 : 5'sd1);
46: raw_field = (bits[33] ? -5'sd1 : 5'sd1) + (bits[34] ? 5'sd1 : -5'sd1) + (bits[35] ? 5'sd1 : -5'sd1) + (bits[45] ? 5'sd1 : -5'sd1) + (bits[47] ? -5'sd1 : 5'sd1) + (bits[57] ? -5'sd1 : 5'sd1) + (bits[58] ? 5'sd1 : -5'sd1) + (bits[59] ? 5'sd1 : -5'sd1);
47: raw_field = (bits[34] ? 5'sd1 : -5'sd1) + (bits[35] ? 5'sd1 : -5'sd1) + (bits[46] ? -5'sd1 : 5'sd1) + (bits[58] ? 5'sd1 : -5'sd1) + (bits[59] ? -5'sd1 : 5'sd1);
48: raw_field = (bits[36] ? 5'sd1 : -5'sd1) + (bits[37] ? 5'sd1 : -5'sd1) + (bits[49] ? 5'sd1 : -5'sd1) + (bits[60] ? 5'sd1 : -5'sd1) + (bits[61] ? 5'sd1 : -5'sd1);
49: raw_field = (bits[36] ? 5'sd1 : -5'sd1) + (bits[37] ? 5'sd1 : -5'sd1) + (bits[38] ? -5'sd1 : 5'sd1) + (bits[48] ? 5'sd1 : -5'sd1) + (bits[50] ? -5'sd1 : 5'sd1) + (bits[60] ? 5'sd1 : -5'sd1) + (bits[61] ? 5'sd1 : -5'sd1) + (bits[62] ? 5'sd1 : -5'sd1);
50: raw_field = (bits[37] ? 5'sd1 : -5'sd1) + (bits[38] ? -5'sd1 : 5'sd1) + (bits[39] ? -5'sd1 : 5'sd1) + (bits[49] ? -5'sd1 : 5'sd1) + (bits[51] ? 5'sd1 : -5'sd1) + (bits[61] ? -5'sd1 : 5'sd1) + (bits[62] ? -5'sd1 : 5'sd1) + (bits[63] ? -5'sd1 : 5'sd1);
51: raw_field = (bits[38] ? 5'sd1 : -5'sd1) + (bits[39] ? 5'sd1 : -5'sd1) + (bits[40] ? -5'sd1 : 5'sd1) + (bits[50] ? 5'sd1 : -5'sd1) + (bits[52] ? 5'sd1 : -5'sd1) + (bits[62] ? 5'sd1 : -5'sd1) + (bits[63] ? -5'sd1 : 5'sd1) + (bits[64] ? 5'sd1 : -5'sd1);
52: raw_field = (bits[39] ? 5'sd1 : -5'sd1) + (bits[40] ? -5'sd1 : 5'sd1) + (bits[41] ? 5'sd1 : -5'sd1) + (bits[51] ? 5'sd1 : -5'sd1) + (bits[53] ? -5'sd1 : 5'sd1) + (bits[63] ? 5'sd1 : -5'sd1) + (bits[64] ? -5'sd1 : 5'sd1) + (bits[65] ? 5'sd1 : -5'sd1);
53: raw_field = (bits[40] ? -5'sd1 : 5'sd1) + (bits[41] ? -5'sd1 : 5'sd1) + (bits[42] ? 5'sd1 : -5'sd1) + (bits[52] ? -5'sd1 : 5'sd1) + (bits[54] ? 5'sd1 : -5'sd1) + (bits[64] ? -5'sd1 : 5'sd1) + (bits[65] ? -5'sd1 : 5'sd1) + (bits[66] ? 5'sd1 : -5'sd1);
54: raw_field = (bits[41] ? 5'sd1 : -5'sd1) + (bits[42] ? -5'sd1 : 5'sd1) + (bits[43] ? 5'sd1 : -5'sd1) + (bits[53] ? 5'sd1 : -5'sd1) + (bits[55] ? -5'sd1 : 5'sd1) + (bits[65] ? 5'sd1 : -5'sd1) + (bits[66] ? -5'sd1 : 5'sd1) + (bits[67] ? -5'sd1 : 5'sd1);
55: raw_field = (bits[42] ? -5'sd1 : 5'sd1) + (bits[43] ? 5'sd1 : -5'sd1) + (bits[44] ? -5'sd1 : 5'sd1) + (bits[54] ? -5'sd1 : 5'sd1) + (bits[56] ? 5'sd1 : -5'sd1) + (bits[66] ? 5'sd1 : -5'sd1) + (bits[67] ? -5'sd1 : 5'sd1) + (bits[68] ? -5'sd1 : 5'sd1);
56: raw_field = (bits[43] ? -5'sd1 : 5'sd1) + (bits[44] ? 5'sd1 : -5'sd1) + (bits[45] ? -5'sd1 : 5'sd1) + (bits[55] ? 5'sd1 : -5'sd1) + (bits[57] ? -5'sd1 : 5'sd1) + (bits[67] ? 5'sd1 : -5'sd1) + (bits[68] ? 5'sd1 : -5'sd1) + (bits[69] ? -5'sd1 : 5'sd1);
57: raw_field = (bits[44] ? -5'sd1 : 5'sd1) + (bits[45] ? 5'sd1 : -5'sd1) + (bits[46] ? -5'sd1 : 5'sd1) + (bits[56] ? -5'sd1 : 5'sd1) + (bits[58] ? -5'sd1 : 5'sd1) + (bits[68] ? -5'sd1 : 5'sd1) + (bits[69] ? -5'sd1 : 5'sd1) + (bits[70] ? -5'sd1 : 5'sd1);
58: raw_field = (bits[45] ? -5'sd1 : 5'sd1) + (bits[46] ? 5'sd1 : -5'sd1) + (bits[47] ? 5'sd1 : -5'sd1) + (bits[57] ? -5'sd1 : 5'sd1) + (bits[59] ? -5'sd1 : 5'sd1) + (bits[69] ? 5'sd1 : -5'sd1) + (bits[70] ? -5'sd1 : 5'sd1) + (bits[71] ? -5'sd1 : 5'sd1);
59: raw_field = (bits[46] ? 5'sd1 : -5'sd1) + (bits[47] ? -5'sd1 : 5'sd1) + (bits[58] ? -5'sd1 : 5'sd1) + (bits[70] ? 5'sd1 : -5'sd1) + (bits[71] ? -5'sd1 : 5'sd1);
60: raw_field = (bits[48] ? 5'sd1 : -5'sd1) + (bits[49] ? 5'sd1 : -5'sd1) + (bits[61] ? 5'sd1 : -5'sd1) + (bits[72] ? -5'sd1 : 5'sd1) + (bits[73] ? 5'sd1 : -5'sd1);
61: raw_field = (bits[48] ? 5'sd1 : -5'sd1) + (bits[49] ? 5'sd1 : -5'sd1) + (bits[50] ? -5'sd1 : 5'sd1) + (bits[60] ? 5'sd1 : -5'sd1) + (bits[62] ? -5'sd1 : 5'sd1) + (bits[72] ? 5'sd1 : -5'sd1) + (bits[73] ? 5'sd1 : -5'sd1) + (bits[74] ? 5'sd1 : -5'sd1);
62: raw_field = (bits[49] ? 5'sd1 : -5'sd1) + (bits[50] ? -5'sd1 : 5'sd1) + (bits[51] ? 5'sd1 : -5'sd1) + (bits[61] ? -5'sd1 : 5'sd1) + (bits[63] ? 5'sd1 : -5'sd1) + (bits[73] ? -5'sd1 : 5'sd1) + (bits[74] ? -5'sd1 : 5'sd1) + (bits[75] ? 5'sd1 : -5'sd1);
63: raw_field = (bits[50] ? -5'sd1 : 5'sd1) + (bits[51] ? -5'sd1 : 5'sd1) + (bits[52] ? 5'sd1 : -5'sd1) + (bits[62] ? 5'sd1 : -5'sd1) + (bits[64] ? -5'sd1 : 5'sd1) + (bits[74] ? -5'sd1 : 5'sd1) + (bits[75] ? 5'sd1 : -5'sd1) + (bits[76] ? 5'sd1 : -5'sd1);
64: raw_field = (bits[51] ? 5'sd1 : -5'sd1) + (bits[52] ? -5'sd1 : 5'sd1) + (bits[53] ? -5'sd1 : 5'sd1) + (bits[63] ? -5'sd1 : 5'sd1) + (bits[65] ? -5'sd1 : 5'sd1) + (bits[75] ? -5'sd1 : 5'sd1) + (bits[76] ? 5'sd1 : -5'sd1) + (bits[77] ? 5'sd1 : -5'sd1);
65: raw_field = (bits[52] ? 5'sd1 : -5'sd1) + (bits[53] ? -5'sd1 : 5'sd1) + (bits[54] ? 5'sd1 : -5'sd1) + (bits[64] ? -5'sd1 : 5'sd1) + (bits[66] ? 5'sd1 : -5'sd1) + (bits[76] ? 5'sd1 : -5'sd1) + (bits[77] ? 5'sd1 : -5'sd1) + (bits[78] ? 5'sd1 : -5'sd1);
66: raw_field = (bits[53] ? 5'sd1 : -5'sd1) + (bits[54] ? -5'sd1 : 5'sd1) + (bits[55] ? 5'sd1 : -5'sd1) + (bits[65] ? 5'sd1 : -5'sd1) + (bits[67] ? 5'sd1 : -5'sd1) + (bits[77] ? 5'sd1 : -5'sd1) + (bits[78] ? -5'sd1 : 5'sd1) + (bits[79] ? 5'sd1 : -5'sd1);
67: raw_field = (bits[54] ? -5'sd1 : 5'sd1) + (bits[55] ? -5'sd1 : 5'sd1) + (bits[56] ? 5'sd1 : -5'sd1) + (bits[66] ? 5'sd1 : -5'sd1) + (bits[68] ? -5'sd1 : 5'sd1) + (bits[78] ? -5'sd1 : 5'sd1) + (bits[79] ? -5'sd1 : 5'sd1) + (bits[80] ? 5'sd1 : -5'sd1);
68: raw_field = (bits[55] ? -5'sd1 : 5'sd1) + (bits[56] ? 5'sd1 : -5'sd1) + (bits[57] ? -5'sd1 : 5'sd1) + (bits[67] ? -5'sd1 : 5'sd1) + (bits[69] ? 5'sd1 : -5'sd1) + (bits[79] ? 5'sd1 : -5'sd1) + (bits[80] ? 5'sd1 : -5'sd1) + (bits[81] ? -5'sd1 : 5'sd1);
69: raw_field = (bits[56] ? -5'sd1 : 5'sd1) + (bits[57] ? -5'sd1 : 5'sd1) + (bits[58] ? 5'sd1 : -5'sd1) + (bits[68] ? 5'sd1 : -5'sd1) + (bits[70] ? -5'sd1 : 5'sd1) + (bits[80] ? 5'sd1 : -5'sd1) + (bits[81] ? -5'sd1 : 5'sd1) + (bits[82] ? 5'sd1 : -5'sd1);
70: raw_field = (bits[57] ? -5'sd1 : 5'sd1) + (bits[58] ? -5'sd1 : 5'sd1) + (bits[59] ? 5'sd1 : -5'sd1) + (bits[69] ? -5'sd1 : 5'sd1) + (bits[71] ? -5'sd1 : 5'sd1) + (bits[81] ? 5'sd1 : -5'sd1) + (bits[82] ? -5'sd1 : 5'sd1) + (bits[83] ? -5'sd1 : 5'sd1);
71: raw_field = (bits[58] ? -5'sd1 : 5'sd1) + (bits[59] ? -5'sd1 : 5'sd1) + (bits[70] ? -5'sd1 : 5'sd1) + (bits[82] ? 5'sd1 : -5'sd1) + (bits[83] ? 5'sd1 : -5'sd1);
72: raw_field = (bits[60] ? -5'sd1 : 5'sd1) + (bits[61] ? 5'sd1 : -5'sd1) + (bits[73] ? -5'sd1 : 5'sd1) + (bits[84] ? 5'sd1 : -5'sd1) + (bits[85] ? 5'sd1 : -5'sd1);
73: raw_field = (bits[60] ? 5'sd1 : -5'sd1) + (bits[61] ? 5'sd1 : -5'sd1) + (bits[62] ? -5'sd1 : 5'sd1) + (bits[72] ? -5'sd1 : 5'sd1) + (bits[74] ? 5'sd1 : -5'sd1) + (bits[84] ? 5'sd1 : -5'sd1) + (bits[85] ? 5'sd1 : -5'sd1) + (bits[86] ? 5'sd1 : -5'sd1);
74: raw_field = (bits[61] ? 5'sd1 : -5'sd1) + (bits[62] ? -5'sd1 : 5'sd1) + (bits[63] ? -5'sd1 : 5'sd1) + (bits[73] ? 5'sd1 : -5'sd1) + (bits[75] ? -5'sd1 : 5'sd1) + (bits[85] ? 5'sd1 : -5'sd1) + (bits[86] ? -5'sd1 : 5'sd1) + (bits[87] ? 5'sd1 : -5'sd1);
75: raw_field = (bits[62] ? 5'sd1 : -5'sd1) + (bits[63] ? 5'sd1 : -5'sd1) + (bits[64] ? -5'sd1 : 5'sd1) + (bits[74] ? -5'sd1 : 5'sd1) + (bits[76] ? -5'sd1 : 5'sd1) + (bits[86] ? -5'sd1 : 5'sd1) + (bits[87] ? 5'sd1 : -5'sd1) + (bits[88] ? -5'sd1 : 5'sd1);
76: raw_field = (bits[63] ? 5'sd1 : -5'sd1) + (bits[64] ? 5'sd1 : -5'sd1) + (bits[65] ? 5'sd1 : -5'sd1) + (bits[75] ? -5'sd1 : 5'sd1) + (bits[77] ? -5'sd1 : 5'sd1) + (bits[87] ? 5'sd1 : -5'sd1) + (bits[88] ? -5'sd1 : 5'sd1) + (bits[89] ? 5'sd1 : -5'sd1);
77: raw_field = (bits[64] ? 5'sd1 : -5'sd1) + (bits[65] ? 5'sd1 : -5'sd1) + (bits[66] ? 5'sd1 : -5'sd1) + (bits[76] ? -5'sd1 : 5'sd1) + (bits[78] ? 5'sd1 : -5'sd1) + (bits[88] ? 5'sd1 : -5'sd1) + (bits[89] ? -5'sd1 : 5'sd1) + (bits[90] ? -5'sd1 : 5'sd1);
78: raw_field = (bits[65] ? 5'sd1 : -5'sd1) + (bits[66] ? -5'sd1 : 5'sd1) + (bits[67] ? -5'sd1 : 5'sd1) + (bits[77] ? 5'sd1 : -5'sd1) + (bits[79] ? 5'sd1 : -5'sd1) + (bits[89] ? -5'sd1 : 5'sd1) + (bits[90] ? -5'sd1 : 5'sd1) + (bits[91] ? -5'sd1 : 5'sd1);
79: raw_field = (bits[66] ? 5'sd1 : -5'sd1) + (bits[67] ? -5'sd1 : 5'sd1) + (bits[68] ? 5'sd1 : -5'sd1) + (bits[78] ? 5'sd1 : -5'sd1) + (bits[80] ? 5'sd1 : -5'sd1) + (bits[90] ? 5'sd1 : -5'sd1) + (bits[91] ? -5'sd1 : 5'sd1) + (bits[92] ? 5'sd1 : -5'sd1);
80: raw_field = (bits[67] ? 5'sd1 : -5'sd1) + (bits[68] ? 5'sd1 : -5'sd1) + (bits[69] ? 5'sd1 : -5'sd1) + (bits[79] ? 5'sd1 : -5'sd1) + (bits[81] ? -5'sd1 : 5'sd1) + (bits[91] ? 5'sd1 : -5'sd1) + (bits[92] ? 5'sd1 : -5'sd1) + (bits[93] ? -5'sd1 : 5'sd1);
81: raw_field = (bits[68] ? -5'sd1 : 5'sd1) + (bits[69] ? -5'sd1 : 5'sd1) + (bits[70] ? 5'sd1 : -5'sd1) + (bits[80] ? -5'sd1 : 5'sd1) + (bits[82] ? 5'sd1 : -5'sd1) + (bits[92] ? 5'sd1 : -5'sd1) + (bits[93] ? -5'sd1 : 5'sd1) + (bits[94] ? 5'sd1 : -5'sd1);
82: raw_field = (bits[69] ? 5'sd1 : -5'sd1) + (bits[70] ? -5'sd1 : 5'sd1) + (bits[71] ? 5'sd1 : -5'sd1) + (bits[81] ? 5'sd1 : -5'sd1) + (bits[83] ? -5'sd1 : 5'sd1) + (bits[93] ? -5'sd1 : 5'sd1) + (bits[94] ? 5'sd1 : -5'sd1) + (bits[95] ? 5'sd1 : -5'sd1);
83: raw_field = (bits[70] ? -5'sd1 : 5'sd1) + (bits[71] ? 5'sd1 : -5'sd1) + (bits[82] ? -5'sd1 : 5'sd1) + (bits[94] ? -5'sd1 : 5'sd1) + (bits[95] ? -5'sd1 : 5'sd1);
84: raw_field = (bits[72] ? 5'sd1 : -5'sd1) + (bits[73] ? 5'sd1 : -5'sd1) + (bits[85] ? -5'sd1 : 5'sd1) + (bits[96] ? 5'sd1 : -5'sd1) + (bits[97] ? 5'sd1 : -5'sd1);
85: raw_field = (bits[72] ? 5'sd1 : -5'sd1) + (bits[73] ? 5'sd1 : -5'sd1) + (bits[74] ? 5'sd1 : -5'sd1) + (bits[84] ? -5'sd1 : 5'sd1) + (bits[86] ? 5'sd1 : -5'sd1) + (bits[96] ? -5'sd1 : 5'sd1) + (bits[97] ? 5'sd1 : -5'sd1) + (bits[98] ? -5'sd1 : 5'sd1);
86: raw_field = (bits[73] ? 5'sd1 : -5'sd1) + (bits[74] ? -5'sd1 : 5'sd1) + (bits[75] ? -5'sd1 : 5'sd1) + (bits[85] ? 5'sd1 : -5'sd1) + (bits[87] ? 5'sd1 : -5'sd1) + (bits[97] ? -5'sd1 : 5'sd1) + (bits[98] ? 5'sd1 : -5'sd1) + (bits[99] ? -5'sd1 : 5'sd1);
87: raw_field = (bits[74] ? 5'sd1 : -5'sd1) + (bits[75] ? 5'sd1 : -5'sd1) + (bits[76] ? 5'sd1 : -5'sd1) + (bits[86] ? 5'sd1 : -5'sd1) + (bits[88] ? 5'sd1 : -5'sd1) + (bits[98] ? 5'sd1 : -5'sd1) + (bits[99] ? -5'sd1 : 5'sd1) + (bits[100] ? 5'sd1 : -5'sd1);
88: raw_field = (bits[75] ? -5'sd1 : 5'sd1) + (bits[76] ? -5'sd1 : 5'sd1) + (bits[77] ? 5'sd1 : -5'sd1) + (bits[87] ? 5'sd1 : -5'sd1) + (bits[89] ? -5'sd1 : 5'sd1) + (bits[99] ? 5'sd1 : -5'sd1) + (bits[100] ? 5'sd1 : -5'sd1) + (bits[101] ? 5'sd1 : -5'sd1);
89: raw_field = (bits[76] ? 5'sd1 : -5'sd1) + (bits[77] ? -5'sd1 : 5'sd1) + (bits[78] ? -5'sd1 : 5'sd1) + (bits[88] ? -5'sd1 : 5'sd1) + (bits[90] ? -5'sd1 : 5'sd1) + (bits[100] ? 5'sd1 : -5'sd1) + (bits[101] ? -5'sd1 : 5'sd1) + (bits[102] ? -5'sd1 : 5'sd1);
90: raw_field = (bits[77] ? -5'sd1 : 5'sd1) + (bits[78] ? -5'sd1 : 5'sd1) + (bits[79] ? 5'sd1 : -5'sd1) + (bits[89] ? -5'sd1 : 5'sd1) + (bits[91] ? -5'sd1 : 5'sd1) + (bits[101] ? 5'sd1 : -5'sd1) + (bits[102] ? -5'sd1 : 5'sd1) + (bits[103] ? -5'sd1 : 5'sd1);
91: raw_field = (bits[78] ? -5'sd1 : 5'sd1) + (bits[79] ? -5'sd1 : 5'sd1) + (bits[80] ? 5'sd1 : -5'sd1) + (bits[90] ? -5'sd1 : 5'sd1) + (bits[92] ? -5'sd1 : 5'sd1) + (bits[102] ? 5'sd1 : -5'sd1) + (bits[103] ? 5'sd1 : -5'sd1) + (bits[104] ? -5'sd1 : 5'sd1);
92: raw_field = (bits[79] ? 5'sd1 : -5'sd1) + (bits[80] ? 5'sd1 : -5'sd1) + (bits[81] ? 5'sd1 : -5'sd1) + (bits[91] ? -5'sd1 : 5'sd1) + (bits[93] ? -5'sd1 : 5'sd1) + (bits[103] ? 5'sd1 : -5'sd1) + (bits[104] ? -5'sd1 : 5'sd1) + (bits[105] ? 5'sd1 : -5'sd1);
93: raw_field = (bits[80] ? -5'sd1 : 5'sd1) + (bits[81] ? -5'sd1 : 5'sd1) + (bits[82] ? -5'sd1 : 5'sd1) + (bits[92] ? -5'sd1 : 5'sd1) + (bits[94] ? 5'sd1 : -5'sd1) + (bits[104] ? 5'sd1 : -5'sd1) + (bits[105] ? -5'sd1 : 5'sd1) + (bits[106] ? 5'sd1 : -5'sd1);
94: raw_field = (bits[81] ? 5'sd1 : -5'sd1) + (bits[82] ? 5'sd1 : -5'sd1) + (bits[83] ? -5'sd1 : 5'sd1) + (bits[93] ? 5'sd1 : -5'sd1) + (bits[95] ? 5'sd1 : -5'sd1) + (bits[105] ? 5'sd1 : -5'sd1) + (bits[106] ? -5'sd1 : 5'sd1) + (bits[107] ? 5'sd1 : -5'sd1);
95: raw_field = (bits[82] ? 5'sd1 : -5'sd1) + (bits[83] ? -5'sd1 : 5'sd1) + (bits[94] ? 5'sd1 : -5'sd1) + (bits[106] ? -5'sd1 : 5'sd1) + (bits[107] ? 5'sd1 : -5'sd1);
96: raw_field = (bits[84] ? 5'sd1 : -5'sd1) + (bits[85] ? -5'sd1 : 5'sd1) + (bits[97] ? 5'sd1 : -5'sd1) + (bits[108] ? 5'sd1 : -5'sd1) + (bits[109] ? 5'sd1 : -5'sd1);
97: raw_field = (bits[84] ? 5'sd1 : -5'sd1) + (bits[85] ? 5'sd1 : -5'sd1) + (bits[86] ? -5'sd1 : 5'sd1) + (bits[96] ? 5'sd1 : -5'sd1) + (bits[98] ? -5'sd1 : 5'sd1) + (bits[108] ? -5'sd1 : 5'sd1) + (bits[109] ? 5'sd1 : -5'sd1) + (bits[110] ? 5'sd1 : -5'sd1);
98: raw_field = (bits[85] ? -5'sd1 : 5'sd1) + (bits[86] ? 5'sd1 : -5'sd1) + (bits[87] ? 5'sd1 : -5'sd1) + (bits[97] ? -5'sd1 : 5'sd1) + (bits[99] ? -5'sd1 : 5'sd1) + (bits[109] ? -5'sd1 : 5'sd1) + (bits[110] ? -5'sd1 : 5'sd1) + (bits[111] ? -5'sd1 : 5'sd1);
99: raw_field = (bits[86] ? -5'sd1 : 5'sd1) + (bits[87] ? -5'sd1 : 5'sd1) + (bits[88] ? 5'sd1 : -5'sd1) + (bits[98] ? -5'sd1 : 5'sd1) + (bits[100] ? -5'sd1 : 5'sd1) + (bits[110] ? 5'sd1 : -5'sd1) + (bits[111] ? 5'sd1 : -5'sd1) + (bits[112] ? 5'sd1 : -5'sd1);
100: raw_field = (bits[87] ? 5'sd1 : -5'sd1) + (bits[88] ? 5'sd1 : -5'sd1) + (bits[89] ? 5'sd1 : -5'sd1) + (bits[99] ? -5'sd1 : 5'sd1) + (bits[101] ? 5'sd1 : -5'sd1) + (bits[111] ? -5'sd1 : 5'sd1) + (bits[112] ? -5'sd1 : 5'sd1) + (bits[113] ? 5'sd1 : -5'sd1);
101: raw_field = (bits[88] ? 5'sd1 : -5'sd1) + (bits[89] ? -5'sd1 : 5'sd1) + (bits[90] ? 5'sd1 : -5'sd1) + (bits[100] ? 5'sd1 : -5'sd1) + (bits[102] ? -5'sd1 : 5'sd1) + (bits[112] ? -5'sd1 : 5'sd1) + (bits[113] ? -5'sd1 : 5'sd1) + (bits[114] ? -5'sd1 : 5'sd1);
102: raw_field = (bits[89] ? -5'sd1 : 5'sd1) + (bits[90] ? -5'sd1 : 5'sd1) + (bits[91] ? 5'sd1 : -5'sd1) + (bits[101] ? -5'sd1 : 5'sd1) + (bits[103] ? 5'sd1 : -5'sd1) + (bits[113] ? -5'sd1 : 5'sd1) + (bits[114] ? -5'sd1 : 5'sd1) + (bits[115] ? -5'sd1 : 5'sd1);
103: raw_field = (bits[90] ? -5'sd1 : 5'sd1) + (bits[91] ? 5'sd1 : -5'sd1) + (bits[92] ? 5'sd1 : -5'sd1) + (bits[102] ? 5'sd1 : -5'sd1) + (bits[104] ? -5'sd1 : 5'sd1) + (bits[114] ? 5'sd1 : -5'sd1) + (bits[115] ? 5'sd1 : -5'sd1) + (bits[116] ? 5'sd1 : -5'sd1);
104: raw_field = (bits[91] ? -5'sd1 : 5'sd1) + (bits[92] ? -5'sd1 : 5'sd1) + (bits[93] ? 5'sd1 : -5'sd1) + (bits[103] ? -5'sd1 : 5'sd1) + (bits[105] ? 5'sd1 : -5'sd1) + (bits[115] ? 5'sd1 : -5'sd1) + (bits[116] ? 5'sd1 : -5'sd1) + (bits[117] ? -5'sd1 : 5'sd1);
105: raw_field = (bits[92] ? 5'sd1 : -5'sd1) + (bits[93] ? -5'sd1 : 5'sd1) + (bits[94] ? 5'sd1 : -5'sd1) + (bits[104] ? 5'sd1 : -5'sd1) + (bits[106] ? 5'sd1 : -5'sd1) + (bits[116] ? -5'sd1 : 5'sd1) + (bits[117] ? -5'sd1 : 5'sd1) + (bits[118] ? -5'sd1 : 5'sd1);
106: raw_field = (bits[93] ? 5'sd1 : -5'sd1) + (bits[94] ? -5'sd1 : 5'sd1) + (bits[95] ? -5'sd1 : 5'sd1) + (bits[105] ? 5'sd1 : -5'sd1) + (bits[107] ? 5'sd1 : -5'sd1) + (bits[117] ? 5'sd1 : -5'sd1) + (bits[118] ? -5'sd1 : 5'sd1) + (bits[119] ? 5'sd1 : -5'sd1);
107: raw_field = (bits[94] ? 5'sd1 : -5'sd1) + (bits[95] ? 5'sd1 : -5'sd1) + (bits[106] ? 5'sd1 : -5'sd1) + (bits[118] ? -5'sd1 : 5'sd1) + (bits[119] ? -5'sd1 : 5'sd1);
108: raw_field = (bits[96] ? 5'sd1 : -5'sd1) + (bits[97] ? -5'sd1 : 5'sd1) + (bits[109] ? 5'sd1 : -5'sd1) + (bits[120] ? -5'sd1 : 5'sd1) + (bits[121] ? -5'sd1 : 5'sd1);
109: raw_field = (bits[96] ? 5'sd1 : -5'sd1) + (bits[97] ? 5'sd1 : -5'sd1) + (bits[98] ? -5'sd1 : 5'sd1) + (bits[108] ? 5'sd1 : -5'sd1) + (bits[110] ? -5'sd1 : 5'sd1) + (bits[120] ? -5'sd1 : 5'sd1) + (bits[121] ? -5'sd1 : 5'sd1) + (bits[122] ? -5'sd1 : 5'sd1);
110: raw_field = (bits[97] ? 5'sd1 : -5'sd1) + (bits[98] ? -5'sd1 : 5'sd1) + (bits[99] ? 5'sd1 : -5'sd1) + (bits[109] ? -5'sd1 : 5'sd1) + (bits[111] ? -5'sd1 : 5'sd1) + (bits[121] ? -5'sd1 : 5'sd1) + (bits[122] ? 5'sd1 : -5'sd1) + (bits[123] ? 5'sd1 : -5'sd1);
111: raw_field = (bits[98] ? -5'sd1 : 5'sd1) + (bits[99] ? 5'sd1 : -5'sd1) + (bits[100] ? -5'sd1 : 5'sd1) + (bits[110] ? -5'sd1 : 5'sd1) + (bits[112] ? 5'sd1 : -5'sd1) + (bits[122] ? -5'sd1 : 5'sd1) + (bits[123] ? -5'sd1 : 5'sd1) + (bits[124] ? -5'sd1 : 5'sd1);
112: raw_field = (bits[99] ? 5'sd1 : -5'sd1) + (bits[100] ? -5'sd1 : 5'sd1) + (bits[101] ? -5'sd1 : 5'sd1) + (bits[111] ? 5'sd1 : -5'sd1) + (bits[113] ? 5'sd1 : -5'sd1) + (bits[123] ? -5'sd1 : 5'sd1) + (bits[124] ? -5'sd1 : 5'sd1) + (bits[125] ? -5'sd1 : 5'sd1);
113: raw_field = (bits[100] ? 5'sd1 : -5'sd1) + (bits[101] ? -5'sd1 : 5'sd1) + (bits[102] ? -5'sd1 : 5'sd1) + (bits[112] ? 5'sd1 : -5'sd1) + (bits[114] ? 5'sd1 : -5'sd1) + (bits[124] ? 5'sd1 : -5'sd1) + (bits[125] ? -5'sd1 : 5'sd1) + (bits[126] ? 5'sd1 : -5'sd1);
114: raw_field = (bits[101] ? -5'sd1 : 5'sd1) + (bits[102] ? -5'sd1 : 5'sd1) + (bits[103] ? 5'sd1 : -5'sd1) + (bits[113] ? 5'sd1 : -5'sd1) + (bits[115] ? -5'sd1 : 5'sd1) + (bits[125] ? -5'sd1 : 5'sd1) + (bits[126] ? 5'sd1 : -5'sd1) + (bits[127] ? 5'sd1 : -5'sd1);
115: raw_field = (bits[102] ? -5'sd1 : 5'sd1) + (bits[103] ? 5'sd1 : -5'sd1) + (bits[104] ? 5'sd1 : -5'sd1) + (bits[114] ? -5'sd1 : 5'sd1) + (bits[116] ? -5'sd1 : 5'sd1) + (bits[126] ? 5'sd1 : -5'sd1) + (bits[127] ? -5'sd1 : 5'sd1) + (bits[128] ? 5'sd1 : -5'sd1);
116: raw_field = (bits[103] ? 5'sd1 : -5'sd1) + (bits[104] ? 5'sd1 : -5'sd1) + (bits[105] ? -5'sd1 : 5'sd1) + (bits[115] ? -5'sd1 : 5'sd1) + (bits[117] ? -5'sd1 : 5'sd1) + (bits[127] ? -5'sd1 : 5'sd1) + (bits[128] ? 5'sd1 : -5'sd1) + (bits[129] ? 5'sd1 : -5'sd1);
117: raw_field = (bits[104] ? -5'sd1 : 5'sd1) + (bits[105] ? -5'sd1 : 5'sd1) + (bits[106] ? 5'sd1 : -5'sd1) + (bits[116] ? -5'sd1 : 5'sd1) + (bits[118] ? -5'sd1 : 5'sd1) + (bits[128] ? -5'sd1 : 5'sd1) + (bits[129] ? -5'sd1 : 5'sd1) + (bits[130] ? 5'sd1 : -5'sd1);
118: raw_field = (bits[105] ? -5'sd1 : 5'sd1) + (bits[106] ? -5'sd1 : 5'sd1) + (bits[107] ? -5'sd1 : 5'sd1) + (bits[117] ? -5'sd1 : 5'sd1) + (bits[119] ? 5'sd1 : -5'sd1) + (bits[129] ? 5'sd1 : -5'sd1) + (bits[130] ? 5'sd1 : -5'sd1) + (bits[131] ? -5'sd1 : 5'sd1);
119: raw_field = (bits[106] ? 5'sd1 : -5'sd1) + (bits[107] ? -5'sd1 : 5'sd1) + (bits[118] ? 5'sd1 : -5'sd1) + (bits[130] ? -5'sd1 : 5'sd1) + (bits[131] ? 5'sd1 : -5'sd1);
120: raw_field = (bits[108] ? -5'sd1 : 5'sd1) + (bits[109] ? -5'sd1 : 5'sd1) + (bits[121] ? 5'sd1 : -5'sd1) + (bits[132] ? -5'sd1 : 5'sd1) + (bits[133] ? -5'sd1 : 5'sd1);
121: raw_field = (bits[108] ? -5'sd1 : 5'sd1) + (bits[109] ? -5'sd1 : 5'sd1) + (bits[110] ? -5'sd1 : 5'sd1) + (bits[120] ? 5'sd1 : -5'sd1) + (bits[122] ? 5'sd1 : -5'sd1) + (bits[132] ? 5'sd1 : -5'sd1) + (bits[133] ? 5'sd1 : -5'sd1) + (bits[134] ? -5'sd1 : 5'sd1);
122: raw_field = (bits[109] ? -5'sd1 : 5'sd1) + (bits[110] ? 5'sd1 : -5'sd1) + (bits[111] ? -5'sd1 : 5'sd1) + (bits[121] ? 5'sd1 : -5'sd1) + (bits[123] ? -5'sd1 : 5'sd1) + (bits[133] ? 5'sd1 : -5'sd1) + (bits[134] ? 5'sd1 : -5'sd1) + (bits[135] ? -5'sd1 : 5'sd1);
123: raw_field = (bits[110] ? 5'sd1 : -5'sd1) + (bits[111] ? -5'sd1 : 5'sd1) + (bits[112] ? -5'sd1 : 5'sd1) + (bits[122] ? -5'sd1 : 5'sd1) + (bits[124] ? 5'sd1 : -5'sd1) + (bits[134] ? 5'sd1 : -5'sd1) + (bits[135] ? -5'sd1 : 5'sd1) + (bits[136] ? -5'sd1 : 5'sd1);
124: raw_field = (bits[111] ? -5'sd1 : 5'sd1) + (bits[112] ? -5'sd1 : 5'sd1) + (bits[113] ? 5'sd1 : -5'sd1) + (bits[123] ? 5'sd1 : -5'sd1) + (bits[125] ? 5'sd1 : -5'sd1) + (bits[135] ? -5'sd1 : 5'sd1) + (bits[136] ? -5'sd1 : 5'sd1) + (bits[137] ? -5'sd1 : 5'sd1);
125: raw_field = (bits[112] ? -5'sd1 : 5'sd1) + (bits[113] ? -5'sd1 : 5'sd1) + (bits[114] ? -5'sd1 : 5'sd1) + (bits[124] ? 5'sd1 : -5'sd1) + (bits[126] ? 5'sd1 : -5'sd1) + (bits[136] ? 5'sd1 : -5'sd1) + (bits[137] ? 5'sd1 : -5'sd1) + (bits[138] ? 5'sd1 : -5'sd1);
126: raw_field = (bits[113] ? 5'sd1 : -5'sd1) + (bits[114] ? 5'sd1 : -5'sd1) + (bits[115] ? 5'sd1 : -5'sd1) + (bits[125] ? 5'sd1 : -5'sd1) + (bits[127] ? -5'sd1 : 5'sd1) + (bits[137] ? 5'sd1 : -5'sd1) + (bits[138] ? -5'sd1 : 5'sd1) + (bits[139] ? -5'sd1 : 5'sd1);
127: raw_field = (bits[114] ? 5'sd1 : -5'sd1) + (bits[115] ? -5'sd1 : 5'sd1) + (bits[116] ? -5'sd1 : 5'sd1) + (bits[126] ? -5'sd1 : 5'sd1) + (bits[128] ? 5'sd1 : -5'sd1) + (bits[138] ? -5'sd1 : 5'sd1) + (bits[139] ? -5'sd1 : 5'sd1) + (bits[140] ? 5'sd1 : -5'sd1);
128: raw_field = (bits[115] ? 5'sd1 : -5'sd1) + (bits[116] ? 5'sd1 : -5'sd1) + (bits[117] ? -5'sd1 : 5'sd1) + (bits[127] ? 5'sd1 : -5'sd1) + (bits[129] ? -5'sd1 : 5'sd1) + (bits[139] ? 5'sd1 : -5'sd1) + (bits[140] ? 5'sd1 : -5'sd1) + (bits[141] ? 5'sd1 : -5'sd1);
129: raw_field = (bits[116] ? 5'sd1 : -5'sd1) + (bits[117] ? -5'sd1 : 5'sd1) + (bits[118] ? 5'sd1 : -5'sd1) + (bits[128] ? -5'sd1 : 5'sd1) + (bits[130] ? 5'sd1 : -5'sd1) + (bits[140] ? -5'sd1 : 5'sd1) + (bits[141] ? -5'sd1 : 5'sd1) + (bits[142] ? 5'sd1 : -5'sd1);
130: raw_field = (bits[117] ? 5'sd1 : -5'sd1) + (bits[118] ? 5'sd1 : -5'sd1) + (bits[119] ? -5'sd1 : 5'sd1) + (bits[129] ? 5'sd1 : -5'sd1) + (bits[131] ? 5'sd1 : -5'sd1) + (bits[141] ? -5'sd1 : 5'sd1) + (bits[142] ? -5'sd1 : 5'sd1) + (bits[143] ? 5'sd1 : -5'sd1);
131: raw_field = (bits[118] ? -5'sd1 : 5'sd1) + (bits[119] ? 5'sd1 : -5'sd1) + (bits[130] ? 5'sd1 : -5'sd1) + (bits[142] ? -5'sd1 : 5'sd1) + (bits[143] ? -5'sd1 : 5'sd1);
132: raw_field = (bits[120] ? -5'sd1 : 5'sd1) + (bits[121] ? 5'sd1 : -5'sd1) + (bits[133] ? 5'sd1 : -5'sd1) + (bits[144] ? 5'sd1 : -5'sd1) + (bits[145] ? 5'sd1 : -5'sd1);
133: raw_field = (bits[120] ? -5'sd1 : 5'sd1) + (bits[121] ? 5'sd1 : -5'sd1) + (bits[122] ? 5'sd1 : -5'sd1) + (bits[132] ? 5'sd1 : -5'sd1) + (bits[134] ? -5'sd1 : 5'sd1) + (bits[144] ? -5'sd1 : 5'sd1) + (bits[145] ? 5'sd1 : -5'sd1) + (bits[146] ? 5'sd1 : -5'sd1);
134: raw_field = (bits[121] ? -5'sd1 : 5'sd1) + (bits[122] ? 5'sd1 : -5'sd1) + (bits[123] ? 5'sd1 : -5'sd1) + (bits[133] ? -5'sd1 : 5'sd1) + (bits[135] ? 5'sd1 : -5'sd1) + (bits[145] ? -5'sd1 : 5'sd1) + (bits[146] ? -5'sd1 : 5'sd1) + (bits[147] ? 5'sd1 : -5'sd1);
135: raw_field = (bits[122] ? -5'sd1 : 5'sd1) + (bits[123] ? -5'sd1 : 5'sd1) + (bits[124] ? -5'sd1 : 5'sd1) + (bits[134] ? 5'sd1 : -5'sd1) + (bits[136] ? 5'sd1 : -5'sd1) + (bits[146] ? -5'sd1 : 5'sd1) + (bits[147] ? 5'sd1 : -5'sd1) + (bits[148] ? -5'sd1 : 5'sd1);
136: raw_field = (bits[123] ? -5'sd1 : 5'sd1) + (bits[124] ? -5'sd1 : 5'sd1) + (bits[125] ? 5'sd1 : -5'sd1) + (bits[135] ? 5'sd1 : -5'sd1) + (bits[137] ? -5'sd1 : 5'sd1) + (bits[147] ? -5'sd1 : 5'sd1) + (bits[148] ? 5'sd1 : -5'sd1) + (bits[149] ? -5'sd1 : 5'sd1);
137: raw_field = (bits[124] ? -5'sd1 : 5'sd1) + (bits[125] ? 5'sd1 : -5'sd1) + (bits[126] ? 5'sd1 : -5'sd1) + (bits[136] ? -5'sd1 : 5'sd1) + (bits[138] ? -5'sd1 : 5'sd1) + (bits[148] ? 5'sd1 : -5'sd1) + (bits[149] ? -5'sd1 : 5'sd1) + (bits[150] ? 5'sd1 : -5'sd1);
138: raw_field = (bits[125] ? 5'sd1 : -5'sd1) + (bits[126] ? -5'sd1 : 5'sd1) + (bits[127] ? -5'sd1 : 5'sd1) + (bits[137] ? -5'sd1 : 5'sd1) + (bits[139] ? -5'sd1 : 5'sd1) + (bits[149] ? -5'sd1 : 5'sd1) + (bits[150] ? -5'sd1 : 5'sd1) + (bits[151] ? 5'sd1 : -5'sd1);
139: raw_field = (bits[126] ? -5'sd1 : 5'sd1) + (bits[127] ? -5'sd1 : 5'sd1) + (bits[128] ? 5'sd1 : -5'sd1) + (bits[138] ? -5'sd1 : 5'sd1) + (bits[140] ? 5'sd1 : -5'sd1) + (bits[150] ? 5'sd1 : -5'sd1) + (bits[151] ? -5'sd1 : 5'sd1) + (bits[152] ? -5'sd1 : 5'sd1);
140: raw_field = (bits[127] ? 5'sd1 : -5'sd1) + (bits[128] ? 5'sd1 : -5'sd1) + (bits[129] ? -5'sd1 : 5'sd1) + (bits[139] ? 5'sd1 : -5'sd1) + (bits[141] ? -5'sd1 : 5'sd1) + (bits[151] ? -5'sd1 : 5'sd1) + (bits[152] ? 5'sd1 : -5'sd1) + (bits[153] ? -5'sd1 : 5'sd1);
141: raw_field = (bits[128] ? 5'sd1 : -5'sd1) + (bits[129] ? -5'sd1 : 5'sd1) + (bits[130] ? -5'sd1 : 5'sd1) + (bits[140] ? -5'sd1 : 5'sd1) + (bits[142] ? -5'sd1 : 5'sd1) + (bits[152] ? 5'sd1 : -5'sd1) + (bits[153] ? -5'sd1 : 5'sd1) + (bits[154] ? 5'sd1 : -5'sd1);
142: raw_field = (bits[129] ? 5'sd1 : -5'sd1) + (bits[130] ? -5'sd1 : 5'sd1) + (bits[131] ? -5'sd1 : 5'sd1) + (bits[141] ? -5'sd1 : 5'sd1) + (bits[143] ? -5'sd1 : 5'sd1) + (bits[153] ? 5'sd1 : -5'sd1) + (bits[154] ? -5'sd1 : 5'sd1) + (bits[155] ? -5'sd1 : 5'sd1);
143: raw_field = (bits[130] ? 5'sd1 : -5'sd1) + (bits[131] ? -5'sd1 : 5'sd1) + (bits[142] ? -5'sd1 : 5'sd1) + (bits[154] ? 5'sd1 : -5'sd1) + (bits[155] ? -5'sd1 : 5'sd1);
144: raw_field = (bits[132] ? 5'sd1 : -5'sd1) + (bits[133] ? -5'sd1 : 5'sd1) + (bits[145] ? -5'sd1 : 5'sd1) + (bits[156] ? 5'sd1 : -5'sd1) + (bits[157] ? 5'sd1 : -5'sd1);
145: raw_field = (bits[132] ? 5'sd1 : -5'sd1) + (bits[133] ? 5'sd1 : -5'sd1) + (bits[134] ? -5'sd1 : 5'sd1) + (bits[144] ? -5'sd1 : 5'sd1) + (bits[146] ? -5'sd1 : 5'sd1) + (bits[156] ? -5'sd1 : 5'sd1) + (bits[157] ? 5'sd1 : -5'sd1) + (bits[158] ? 5'sd1 : -5'sd1);
146: raw_field = (bits[133] ? 5'sd1 : -5'sd1) + (bits[134] ? -5'sd1 : 5'sd1) + (bits[135] ? -5'sd1 : 5'sd1) + (bits[145] ? -5'sd1 : 5'sd1) + (bits[147] ? 5'sd1 : -5'sd1) + (bits[157] ? 5'sd1 : -5'sd1) + (bits[158] ? -5'sd1 : 5'sd1) + (bits[159] ? 5'sd1 : -5'sd1);
147: raw_field = (bits[134] ? 5'sd1 : -5'sd1) + (bits[135] ? 5'sd1 : -5'sd1) + (bits[136] ? -5'sd1 : 5'sd1) + (bits[146] ? 5'sd1 : -5'sd1) + (bits[148] ? -5'sd1 : 5'sd1) + (bits[158] ? -5'sd1 : 5'sd1) + (bits[159] ? -5'sd1 : 5'sd1) + (bits[160] ? 5'sd1 : -5'sd1);
148: raw_field = (bits[135] ? -5'sd1 : 5'sd1) + (bits[136] ? 5'sd1 : -5'sd1) + (bits[137] ? 5'sd1 : -5'sd1) + (bits[147] ? -5'sd1 : 5'sd1) + (bits[149] ? 5'sd1 : -5'sd1) + (bits[159] ? -5'sd1 : 5'sd1) + (bits[160] ? 5'sd1 : -5'sd1) + (bits[161] ? 5'sd1 : -5'sd1);
149: raw_field = (bits[136] ? -5'sd1 : 5'sd1) + (bits[137] ? -5'sd1 : 5'sd1) + (bits[138] ? -5'sd1 : 5'sd1) + (bits[148] ? 5'sd1 : -5'sd1) + (bits[150] ? 5'sd1 : -5'sd1) + (bits[160] ? 5'sd1 : -5'sd1) + (bits[161] ? 5'sd1 : -5'sd1) + (bits[162] ? 5'sd1 : -5'sd1);
150: raw_field = (bits[137] ? 5'sd1 : -5'sd1) + (bits[138] ? -5'sd1 : 5'sd1) + (bits[139] ? 5'sd1 : -5'sd1) + (bits[149] ? 5'sd1 : -5'sd1) + (bits[151] ? 5'sd1 : -5'sd1) + (bits[161] ? -5'sd1 : 5'sd1) + (bits[162] ? -5'sd1 : 5'sd1) + (bits[163] ? -5'sd1 : 5'sd1);
151: raw_field = (bits[138] ? 5'sd1 : -5'sd1) + (bits[139] ? -5'sd1 : 5'sd1) + (bits[140] ? -5'sd1 : 5'sd1) + (bits[150] ? 5'sd1 : -5'sd1) + (bits[152] ? 5'sd1 : -5'sd1) + (bits[162] ? 5'sd1 : -5'sd1) + (bits[163] ? -5'sd1 : 5'sd1) + (bits[164] ? 5'sd1 : -5'sd1);
152: raw_field = (bits[139] ? -5'sd1 : 5'sd1) + (bits[140] ? 5'sd1 : -5'sd1) + (bits[141] ? 5'sd1 : -5'sd1) + (bits[151] ? 5'sd1 : -5'sd1) + (bits[153] ? -5'sd1 : 5'sd1) + (bits[163] ? 5'sd1 : -5'sd1) + (bits[164] ? 5'sd1 : -5'sd1) + (bits[165] ? 5'sd1 : -5'sd1);
153: raw_field = (bits[140] ? -5'sd1 : 5'sd1) + (bits[141] ? -5'sd1 : 5'sd1) + (bits[142] ? 5'sd1 : -5'sd1) + (bits[152] ? -5'sd1 : 5'sd1) + (bits[154] ? -5'sd1 : 5'sd1) + (bits[164] ? 5'sd1 : -5'sd1) + (bits[165] ? -5'sd1 : 5'sd1) + (bits[166] ? -5'sd1 : 5'sd1);
154: raw_field = (bits[141] ? 5'sd1 : -5'sd1) + (bits[142] ? -5'sd1 : 5'sd1) + (bits[143] ? 5'sd1 : -5'sd1) + (bits[153] ? -5'sd1 : 5'sd1) + (bits[155] ? -5'sd1 : 5'sd1) + (bits[165] ? -5'sd1 : 5'sd1) + (bits[166] ? 5'sd1 : -5'sd1) + (bits[167] ? 5'sd1 : -5'sd1);
155: raw_field = (bits[142] ? -5'sd1 : 5'sd1) + (bits[143] ? -5'sd1 : 5'sd1) + (bits[154] ? -5'sd1 : 5'sd1) + (bits[166] ? -5'sd1 : 5'sd1) + (bits[167] ? 5'sd1 : -5'sd1);
156: raw_field = (bits[144] ? 5'sd1 : -5'sd1) + (bits[145] ? -5'sd1 : 5'sd1) + (bits[157] ? -5'sd1 : 5'sd1) + (bits[168] ? -5'sd1 : 5'sd1) + (bits[169] ? 5'sd1 : -5'sd1);
157: raw_field = (bits[144] ? 5'sd1 : -5'sd1) + (bits[145] ? 5'sd1 : -5'sd1) + (bits[146] ? 5'sd1 : -5'sd1) + (bits[156] ? -5'sd1 : 5'sd1) + (bits[158] ? -5'sd1 : 5'sd1) + (bits[168] ? 5'sd1 : -5'sd1) + (bits[169] ? -5'sd1 : 5'sd1) + (bits[170] ? 5'sd1 : -5'sd1);
158: raw_field = (bits[145] ? 5'sd1 : -5'sd1) + (bits[146] ? -5'sd1 : 5'sd1) + (bits[147] ? -5'sd1 : 5'sd1) + (bits[157] ? -5'sd1 : 5'sd1) + (bits[159] ? -5'sd1 : 5'sd1) + (bits[169] ? 5'sd1 : -5'sd1) + (bits[170] ? -5'sd1 : 5'sd1) + (bits[171] ? 5'sd1 : -5'sd1);
159: raw_field = (bits[146] ? 5'sd1 : -5'sd1) + (bits[147] ? -5'sd1 : 5'sd1) + (bits[148] ? -5'sd1 : 5'sd1) + (bits[158] ? -5'sd1 : 5'sd1) + (bits[160] ? 5'sd1 : -5'sd1) + (bits[170] ? 5'sd1 : -5'sd1) + (bits[171] ? -5'sd1 : 5'sd1) + (bits[172] ? 5'sd1 : -5'sd1);
160: raw_field = (bits[147] ? 5'sd1 : -5'sd1) + (bits[148] ? 5'sd1 : -5'sd1) + (bits[149] ? 5'sd1 : -5'sd1) + (bits[159] ? 5'sd1 : -5'sd1) + (bits[161] ? 5'sd1 : -5'sd1) + (bits[171] ? -5'sd1 : 5'sd1) + (bits[172] ? 5'sd1 : -5'sd1) + (bits[173] ? 5'sd1 : -5'sd1);
161: raw_field = (bits[148] ? 5'sd1 : -5'sd1) + (bits[149] ? 5'sd1 : -5'sd1) + (bits[150] ? -5'sd1 : 5'sd1) + (bits[160] ? 5'sd1 : -5'sd1) + (bits[162] ? 5'sd1 : -5'sd1) + (bits[172] ? -5'sd1 : 5'sd1) + (bits[173] ? -5'sd1 : 5'sd1) + (bits[174] ? -5'sd1 : 5'sd1);
162: raw_field = (bits[149] ? 5'sd1 : -5'sd1) + (bits[150] ? -5'sd1 : 5'sd1) + (bits[151] ? 5'sd1 : -5'sd1) + (bits[161] ? 5'sd1 : -5'sd1) + (bits[163] ? -5'sd1 : 5'sd1) + (bits[173] ? -5'sd1 : 5'sd1) + (bits[174] ? -5'sd1 : 5'sd1) + (bits[175] ? 5'sd1 : -5'sd1);
163: raw_field = (bits[150] ? -5'sd1 : 5'sd1) + (bits[151] ? -5'sd1 : 5'sd1) + (bits[152] ? 5'sd1 : -5'sd1) + (bits[162] ? -5'sd1 : 5'sd1) + (bits[164] ? 5'sd1 : -5'sd1) + (bits[174] ? 5'sd1 : -5'sd1) + (bits[175] ? -5'sd1 : 5'sd1) + (bits[176] ? -5'sd1 : 5'sd1);
164: raw_field = (bits[151] ? 5'sd1 : -5'sd1) + (bits[152] ? 5'sd1 : -5'sd1) + (bits[153] ? 5'sd1 : -5'sd1) + (bits[163] ? 5'sd1 : -5'sd1) + (bits[165] ? -5'sd1 : 5'sd1) + (bits[175] ? 5'sd1 : -5'sd1) + (bits[176] ? 5'sd1 : -5'sd1) + (bits[177] ? 5'sd1 : -5'sd1);
165: raw_field = (bits[152] ? 5'sd1 : -5'sd1) + (bits[153] ? -5'sd1 : 5'sd1) + (bits[154] ? -5'sd1 : 5'sd1) + (bits[164] ? -5'sd1 : 5'sd1) + (bits[166] ? 5'sd1 : -5'sd1) + (bits[176] ? -5'sd1 : 5'sd1) + (bits[177] ? -5'sd1 : 5'sd1) + (bits[178] ? 5'sd1 : -5'sd1);
166: raw_field = (bits[153] ? -5'sd1 : 5'sd1) + (bits[154] ? 5'sd1 : -5'sd1) + (bits[155] ? -5'sd1 : 5'sd1) + (bits[165] ? 5'sd1 : -5'sd1) + (bits[167] ? -5'sd1 : 5'sd1) + (bits[177] ? 5'sd1 : -5'sd1) + (bits[178] ? 5'sd1 : -5'sd1) + (bits[179] ? 5'sd1 : -5'sd1);
167: raw_field = (bits[154] ? 5'sd1 : -5'sd1) + (bits[155] ? 5'sd1 : -5'sd1) + (bits[166] ? -5'sd1 : 5'sd1) + (bits[178] ? -5'sd1 : 5'sd1) + (bits[179] ? -5'sd1 : 5'sd1);
168: raw_field = (bits[156] ? -5'sd1 : 5'sd1) + (bits[157] ? 5'sd1 : -5'sd1) + (bits[169] ? -5'sd1 : 5'sd1) + (bits[180] ? 5'sd1 : -5'sd1) + (bits[181] ? 5'sd1 : -5'sd1);
169: raw_field = (bits[156] ? 5'sd1 : -5'sd1) + (bits[157] ? -5'sd1 : 5'sd1) + (bits[158] ? 5'sd1 : -5'sd1) + (bits[168] ? -5'sd1 : 5'sd1) + (bits[170] ? 5'sd1 : -5'sd1) + (bits[180] ? 5'sd1 : -5'sd1) + (bits[181] ? 5'sd1 : -5'sd1) + (bits[182] ? 5'sd1 : -5'sd1);
170: raw_field = (bits[157] ? 5'sd1 : -5'sd1) + (bits[158] ? -5'sd1 : 5'sd1) + (bits[159] ? 5'sd1 : -5'sd1) + (bits[169] ? 5'sd1 : -5'sd1) + (bits[171] ? 5'sd1 : -5'sd1) + (bits[181] ? 5'sd1 : -5'sd1) + (bits[182] ? -5'sd1 : 5'sd1) + (bits[183] ? 5'sd1 : -5'sd1);
171: raw_field = (bits[158] ? 5'sd1 : -5'sd1) + (bits[159] ? -5'sd1 : 5'sd1) + (bits[160] ? -5'sd1 : 5'sd1) + (bits[170] ? 5'sd1 : -5'sd1) + (bits[172] ? -5'sd1 : 5'sd1) + (bits[182] ? 5'sd1 : -5'sd1) + (bits[183] ? -5'sd1 : 5'sd1) + (bits[184] ? 5'sd1 : -5'sd1);
172: raw_field = (bits[159] ? 5'sd1 : -5'sd1) + (bits[160] ? 5'sd1 : -5'sd1) + (bits[161] ? -5'sd1 : 5'sd1) + (bits[171] ? -5'sd1 : 5'sd1) + (bits[173] ? 5'sd1 : -5'sd1) + (bits[183] ? 5'sd1 : -5'sd1) + (bits[184] ? -5'sd1 : 5'sd1) + (bits[185] ? 5'sd1 : -5'sd1);
173: raw_field = (bits[160] ? 5'sd1 : -5'sd1) + (bits[161] ? -5'sd1 : 5'sd1) + (bits[162] ? -5'sd1 : 5'sd1) + (bits[172] ? 5'sd1 : -5'sd1) + (bits[174] ? 5'sd1 : -5'sd1) + (bits[184] ? 5'sd1 : -5'sd1) + (bits[185] ? 5'sd1 : -5'sd1) + (bits[186] ? 5'sd1 : -5'sd1);
174: raw_field = (bits[161] ? -5'sd1 : 5'sd1) + (bits[162] ? -5'sd1 : 5'sd1) + (bits[163] ? 5'sd1 : -5'sd1) + (bits[173] ? 5'sd1 : -5'sd1) + (bits[175] ? 5'sd1 : -5'sd1) + (bits[185] ? -5'sd1 : 5'sd1) + (bits[186] ? -5'sd1 : 5'sd1) + (bits[187] ? 5'sd1 : -5'sd1);
175: raw_field = (bits[162] ? 5'sd1 : -5'sd1) + (bits[163] ? -5'sd1 : 5'sd1) + (bits[164] ? 5'sd1 : -5'sd1) + (bits[174] ? 5'sd1 : -5'sd1) + (bits[176] ? -5'sd1 : 5'sd1) + (bits[186] ? 5'sd1 : -5'sd1) + (bits[187] ? -5'sd1 : 5'sd1) + (bits[188] ? -5'sd1 : 5'sd1);
176: raw_field = (bits[163] ? -5'sd1 : 5'sd1) + (bits[164] ? 5'sd1 : -5'sd1) + (bits[165] ? -5'sd1 : 5'sd1) + (bits[175] ? -5'sd1 : 5'sd1) + (bits[177] ? 5'sd1 : -5'sd1) + (bits[187] ? -5'sd1 : 5'sd1) + (bits[188] ? 5'sd1 : -5'sd1) + (bits[189] ? -5'sd1 : 5'sd1);
177: raw_field = (bits[164] ? 5'sd1 : -5'sd1) + (bits[165] ? -5'sd1 : 5'sd1) + (bits[166] ? 5'sd1 : -5'sd1) + (bits[176] ? 5'sd1 : -5'sd1) + (bits[178] ? 5'sd1 : -5'sd1) + (bits[188] ? 5'sd1 : -5'sd1) + (bits[189] ? -5'sd1 : 5'sd1) + (bits[190] ? -5'sd1 : 5'sd1);
178: raw_field = (bits[165] ? 5'sd1 : -5'sd1) + (bits[166] ? 5'sd1 : -5'sd1) + (bits[167] ? -5'sd1 : 5'sd1) + (bits[177] ? 5'sd1 : -5'sd1) + (bits[179] ? 5'sd1 : -5'sd1) + (bits[189] ? 5'sd1 : -5'sd1) + (bits[190] ? -5'sd1 : 5'sd1) + (bits[191] ? -5'sd1 : 5'sd1);
179: raw_field = (bits[166] ? 5'sd1 : -5'sd1) + (bits[167] ? -5'sd1 : 5'sd1) + (bits[178] ? 5'sd1 : -5'sd1) + (bits[190] ? 5'sd1 : -5'sd1) + (bits[191] ? -5'sd1 : 5'sd1);
180: raw_field = (bits[168] ? 5'sd1 : -5'sd1) + (bits[169] ? 5'sd1 : -5'sd1) + (bits[181] ? -5'sd1 : 5'sd1) + (bits[192] ? -5'sd1 : 5'sd1) + (bits[193] ? -5'sd1 : 5'sd1);
181: raw_field = (bits[168] ? 5'sd1 : -5'sd1) + (bits[169] ? 5'sd1 : -5'sd1) + (bits[170] ? 5'sd1 : -5'sd1) + (bits[180] ? -5'sd1 : 5'sd1) + (bits[182] ? 5'sd1 : -5'sd1) + (bits[192] ? 5'sd1 : -5'sd1) + (bits[193] ? 5'sd1 : -5'sd1) + (bits[194] ? 5'sd1 : -5'sd1);
182: raw_field = (bits[169] ? 5'sd1 : -5'sd1) + (bits[170] ? -5'sd1 : 5'sd1) + (bits[171] ? 5'sd1 : -5'sd1) + (bits[181] ? 5'sd1 : -5'sd1) + (bits[183] ? 5'sd1 : -5'sd1) + (bits[193] ? 5'sd1 : -5'sd1) + (bits[194] ? 5'sd1 : -5'sd1) + (bits[195] ? 5'sd1 : -5'sd1);
183: raw_field = (bits[170] ? 5'sd1 : -5'sd1) + (bits[171] ? -5'sd1 : 5'sd1) + (bits[172] ? 5'sd1 : -5'sd1) + (bits[182] ? 5'sd1 : -5'sd1) + (bits[184] ? -5'sd1 : 5'sd1) + (bits[194] ? -5'sd1 : 5'sd1) + (bits[195] ? -5'sd1 : 5'sd1) + (bits[196] ? -5'sd1 : 5'sd1);
184: raw_field = (bits[171] ? 5'sd1 : -5'sd1) + (bits[172] ? -5'sd1 : 5'sd1) + (bits[173] ? 5'sd1 : -5'sd1) + (bits[183] ? -5'sd1 : 5'sd1) + (bits[185] ? -5'sd1 : 5'sd1) + (bits[195] ? 5'sd1 : -5'sd1) + (bits[196] ? 5'sd1 : -5'sd1) + (bits[197] ? 5'sd1 : -5'sd1);
185: raw_field = (bits[172] ? 5'sd1 : -5'sd1) + (bits[173] ? 5'sd1 : -5'sd1) + (bits[174] ? -5'sd1 : 5'sd1) + (bits[184] ? -5'sd1 : 5'sd1) + (bits[186] ? -5'sd1 : 5'sd1) + (bits[196] ? 5'sd1 : -5'sd1) + (bits[197] ? -5'sd1 : 5'sd1) + (bits[198] ? 5'sd1 : -5'sd1);
186: raw_field = (bits[173] ? 5'sd1 : -5'sd1) + (bits[174] ? -5'sd1 : 5'sd1) + (bits[175] ? 5'sd1 : -5'sd1) + (bits[185] ? -5'sd1 : 5'sd1) + (bits[187] ? -5'sd1 : 5'sd1) + (bits[197] ? -5'sd1 : 5'sd1) + (bits[198] ? 5'sd1 : -5'sd1) + (bits[199] ? -5'sd1 : 5'sd1);
187: raw_field = (bits[174] ? 5'sd1 : -5'sd1) + (bits[175] ? -5'sd1 : 5'sd1) + (bits[176] ? -5'sd1 : 5'sd1) + (bits[186] ? -5'sd1 : 5'sd1) + (bits[188] ? 5'sd1 : -5'sd1) + (bits[198] ? 5'sd1 : -5'sd1) + (bits[199] ? -5'sd1 : 5'sd1) + (bits[200] ? 5'sd1 : -5'sd1);
188: raw_field = (bits[175] ? -5'sd1 : 5'sd1) + (bits[176] ? 5'sd1 : -5'sd1) + (bits[177] ? 5'sd1 : -5'sd1) + (bits[187] ? 5'sd1 : -5'sd1) + (bits[189] ? -5'sd1 : 5'sd1) + (bits[199] ? -5'sd1 : 5'sd1) + (bits[200] ? 5'sd1 : -5'sd1) + (bits[201] ? -5'sd1 : 5'sd1);
189: raw_field = (bits[176] ? -5'sd1 : 5'sd1) + (bits[177] ? -5'sd1 : 5'sd1) + (bits[178] ? 5'sd1 : -5'sd1) + (bits[188] ? -5'sd1 : 5'sd1) + (bits[190] ? -5'sd1 : 5'sd1) + (bits[200] ? 5'sd1 : -5'sd1) + (bits[201] ? -5'sd1 : 5'sd1) + (bits[202] ? -5'sd1 : 5'sd1);
190: raw_field = (bits[177] ? -5'sd1 : 5'sd1) + (bits[178] ? -5'sd1 : 5'sd1) + (bits[179] ? 5'sd1 : -5'sd1) + (bits[189] ? -5'sd1 : 5'sd1) + (bits[191] ? -5'sd1 : 5'sd1) + (bits[201] ? -5'sd1 : 5'sd1) + (bits[202] ? -5'sd1 : 5'sd1) + (bits[203] ? -5'sd1 : 5'sd1);
191: raw_field = (bits[178] ? -5'sd1 : 5'sd1) + (bits[179] ? -5'sd1 : 5'sd1) + (bits[190] ? -5'sd1 : 5'sd1) + (bits[202] ? -5'sd1 : 5'sd1) + (bits[203] ? 5'sd1 : -5'sd1);
192: raw_field = (bits[180] ? -5'sd1 : 5'sd1) + (bits[181] ? 5'sd1 : -5'sd1) + (bits[193] ? 5'sd1 : -5'sd1) + (bits[204] ? -5'sd1 : 5'sd1) + (bits[205] ? -5'sd1 : 5'sd1);
193: raw_field = (bits[180] ? -5'sd1 : 5'sd1) + (bits[181] ? 5'sd1 : -5'sd1) + (bits[182] ? 5'sd1 : -5'sd1) + (bits[192] ? 5'sd1 : -5'sd1) + (bits[194] ? 5'sd1 : -5'sd1) + (bits[204] ? -5'sd1 : 5'sd1) + (bits[205] ? 5'sd1 : -5'sd1) + (bits[206] ? 5'sd1 : -5'sd1);
194: raw_field = (bits[181] ? 5'sd1 : -5'sd1) + (bits[182] ? 5'sd1 : -5'sd1) + (bits[183] ? -5'sd1 : 5'sd1) + (bits[193] ? 5'sd1 : -5'sd1) + (bits[195] ? 5'sd1 : -5'sd1) + (bits[205] ? -5'sd1 : 5'sd1) + (bits[206] ? 5'sd1 : -5'sd1) + (bits[207] ? 5'sd1 : -5'sd1);
195: raw_field = (bits[182] ? 5'sd1 : -5'sd1) + (bits[183] ? -5'sd1 : 5'sd1) + (bits[184] ? 5'sd1 : -5'sd1) + (bits[194] ? 5'sd1 : -5'sd1) + (bits[196] ? -5'sd1 : 5'sd1) + (bits[206] ? -5'sd1 : 5'sd1) + (bits[207] ? -5'sd1 : 5'sd1) + (bits[208] ? 5'sd1 : -5'sd1);
196: raw_field = (bits[183] ? -5'sd1 : 5'sd1) + (bits[184] ? 5'sd1 : -5'sd1) + (bits[185] ? 5'sd1 : -5'sd1) + (bits[195] ? -5'sd1 : 5'sd1) + (bits[197] ? -5'sd1 : 5'sd1) + (bits[207] ? -5'sd1 : 5'sd1) + (bits[208] ? 5'sd1 : -5'sd1) + (bits[209] ? 5'sd1 : -5'sd1);
197: raw_field = (bits[184] ? 5'sd1 : -5'sd1) + (bits[185] ? -5'sd1 : 5'sd1) + (bits[186] ? -5'sd1 : 5'sd1) + (bits[196] ? -5'sd1 : 5'sd1) + (bits[198] ? 5'sd1 : -5'sd1) + (bits[208] ? -5'sd1 : 5'sd1) + (bits[209] ? -5'sd1 : 5'sd1) + (bits[210] ? -5'sd1 : 5'sd1);
198: raw_field = (bits[185] ? 5'sd1 : -5'sd1) + (bits[186] ? 5'sd1 : -5'sd1) + (bits[187] ? 5'sd1 : -5'sd1) + (bits[197] ? 5'sd1 : -5'sd1) + (bits[199] ? 5'sd1 : -5'sd1) + (bits[209] ? 5'sd1 : -5'sd1) + (bits[210] ? 5'sd1 : -5'sd1) + (bits[211] ? -5'sd1 : 5'sd1);
199: raw_field = (bits[186] ? -5'sd1 : 5'sd1) + (bits[187] ? -5'sd1 : 5'sd1) + (bits[188] ? -5'sd1 : 5'sd1) + (bits[198] ? 5'sd1 : -5'sd1) + (bits[200] ? 5'sd1 : -5'sd1) + (bits[210] ? 5'sd1 : -5'sd1) + (bits[211] ? -5'sd1 : 5'sd1) + (bits[212] ? 5'sd1 : -5'sd1);
200: raw_field = (bits[187] ? 5'sd1 : -5'sd1) + (bits[188] ? 5'sd1 : -5'sd1) + (bits[189] ? 5'sd1 : -5'sd1) + (bits[199] ? 5'sd1 : -5'sd1) + (bits[201] ? -5'sd1 : 5'sd1) + (bits[211] ? -5'sd1 : 5'sd1) + (bits[212] ? -5'sd1 : 5'sd1) + (bits[213] ? -5'sd1 : 5'sd1);
201: raw_field = (bits[188] ? -5'sd1 : 5'sd1) + (bits[189] ? -5'sd1 : 5'sd1) + (bits[190] ? -5'sd1 : 5'sd1) + (bits[200] ? -5'sd1 : 5'sd1) + (bits[202] ? -5'sd1 : 5'sd1) + (bits[212] ? 5'sd1 : -5'sd1) + (bits[213] ? -5'sd1 : 5'sd1) + (bits[214] ? 5'sd1 : -5'sd1);
202: raw_field = (bits[189] ? -5'sd1 : 5'sd1) + (bits[190] ? -5'sd1 : 5'sd1) + (bits[191] ? -5'sd1 : 5'sd1) + (bits[201] ? -5'sd1 : 5'sd1) + (bits[203] ? -5'sd1 : 5'sd1) + (bits[213] ? -5'sd1 : 5'sd1) + (bits[214] ? -5'sd1 : 5'sd1) + (bits[215] ? 5'sd1 : -5'sd1);
203: raw_field = (bits[190] ? -5'sd1 : 5'sd1) + (bits[191] ? 5'sd1 : -5'sd1) + (bits[202] ? -5'sd1 : 5'sd1) + (bits[214] ? -5'sd1 : 5'sd1) + (bits[215] ? 5'sd1 : -5'sd1);
204: raw_field = (bits[192] ? -5'sd1 : 5'sd1) + (bits[193] ? -5'sd1 : 5'sd1) + (bits[205] ? 5'sd1 : -5'sd1) + (bits[216] ? 5'sd1 : -5'sd1) + (bits[217] ? 5'sd1 : -5'sd1);
205: raw_field = (bits[192] ? -5'sd1 : 5'sd1) + (bits[193] ? 5'sd1 : -5'sd1) + (bits[194] ? -5'sd1 : 5'sd1) + (bits[204] ? 5'sd1 : -5'sd1) + (bits[206] ? 5'sd1 : -5'sd1) + (bits[216] ? -5'sd1 : 5'sd1) + (bits[217] ? -5'sd1 : 5'sd1) + (bits[218] ? -5'sd1 : 5'sd1);
206: raw_field = (bits[193] ? 5'sd1 : -5'sd1) + (bits[194] ? 5'sd1 : -5'sd1) + (bits[195] ? -5'sd1 : 5'sd1) + (bits[205] ? 5'sd1 : -5'sd1) + (bits[207] ? 5'sd1 : -5'sd1) + (bits[217] ? -5'sd1 : 5'sd1) + (bits[218] ? 5'sd1 : -5'sd1) + (bits[219] ? 5'sd1 : -5'sd1);
207: raw_field = (bits[194] ? 5'sd1 : -5'sd1) + (bits[195] ? -5'sd1 : 5'sd1) + (bits[196] ? -5'sd1 : 5'sd1) + (bits[206] ? 5'sd1 : -5'sd1) + (bits[208] ? -5'sd1 : 5'sd1) + (bits[218] ? 5'sd1 : -5'sd1) + (bits[219] ? -5'sd1 : 5'sd1) + (bits[220] ? 5'sd1 : -5'sd1);
208: raw_field = (bits[195] ? 5'sd1 : -5'sd1) + (bits[196] ? 5'sd1 : -5'sd1) + (bits[197] ? -5'sd1 : 5'sd1) + (bits[207] ? -5'sd1 : 5'sd1) + (bits[209] ? 5'sd1 : -5'sd1) + (bits[219] ? 5'sd1 : -5'sd1) + (bits[220] ? -5'sd1 : 5'sd1) + (bits[221] ? 5'sd1 : -5'sd1);
209: raw_field = (bits[196] ? 5'sd1 : -5'sd1) + (bits[197] ? -5'sd1 : 5'sd1) + (bits[198] ? 5'sd1 : -5'sd1) + (bits[208] ? 5'sd1 : -5'sd1) + (bits[210] ? -5'sd1 : 5'sd1) + (bits[220] ? 5'sd1 : -5'sd1) + (bits[221] ? -5'sd1 : 5'sd1) + (bits[222] ? -5'sd1 : 5'sd1);
210: raw_field = (bits[197] ? -5'sd1 : 5'sd1) + (bits[198] ? 5'sd1 : -5'sd1) + (bits[199] ? 5'sd1 : -5'sd1) + (bits[209] ? -5'sd1 : 5'sd1) + (bits[211] ? 5'sd1 : -5'sd1) + (bits[221] ? 5'sd1 : -5'sd1) + (bits[222] ? 5'sd1 : -5'sd1) + (bits[223] ? 5'sd1 : -5'sd1);
211: raw_field = (bits[198] ? -5'sd1 : 5'sd1) + (bits[199] ? -5'sd1 : 5'sd1) + (bits[200] ? -5'sd1 : 5'sd1) + (bits[210] ? 5'sd1 : -5'sd1) + (bits[212] ? 5'sd1 : -5'sd1) + (bits[222] ? -5'sd1 : 5'sd1) + (bits[223] ? -5'sd1 : 5'sd1) + (bits[224] ? -5'sd1 : 5'sd1);
212: raw_field = (bits[199] ? 5'sd1 : -5'sd1) + (bits[200] ? -5'sd1 : 5'sd1) + (bits[201] ? 5'sd1 : -5'sd1) + (bits[211] ? 5'sd1 : -5'sd1) + (bits[213] ? -5'sd1 : 5'sd1) + (bits[223] ? 5'sd1 : -5'sd1) + (bits[224] ? -5'sd1 : 5'sd1) + (bits[225] ? -5'sd1 : 5'sd1);
213: raw_field = (bits[200] ? -5'sd1 : 5'sd1) + (bits[201] ? -5'sd1 : 5'sd1) + (bits[202] ? -5'sd1 : 5'sd1) + (bits[212] ? -5'sd1 : 5'sd1) + (bits[214] ? 5'sd1 : -5'sd1) + (bits[224] ? 5'sd1 : -5'sd1) + (bits[225] ? 5'sd1 : -5'sd1) + (bits[226] ? -5'sd1 : 5'sd1);
214: raw_field = (bits[201] ? 5'sd1 : -5'sd1) + (bits[202] ? -5'sd1 : 5'sd1) + (bits[203] ? -5'sd1 : 5'sd1) + (bits[213] ? 5'sd1 : -5'sd1) + (bits[215] ? 5'sd1 : -5'sd1) + (bits[225] ? -5'sd1 : 5'sd1) + (bits[226] ? 5'sd1 : -5'sd1) + (bits[227] ? -5'sd1 : 5'sd1);
215: raw_field = (bits[202] ? 5'sd1 : -5'sd1) + (bits[203] ? 5'sd1 : -5'sd1) + (bits[214] ? 5'sd1 : -5'sd1) + (bits[226] ? -5'sd1 : 5'sd1) + (bits[227] ? -5'sd1 : 5'sd1);
216: raw_field = (bits[204] ? 5'sd1 : -5'sd1) + (bits[205] ? -5'sd1 : 5'sd1) + (bits[217] ? -5'sd1 : 5'sd1) + (bits[228] ? -5'sd1 : 5'sd1) + (bits[229] ? 5'sd1 : -5'sd1);
217: raw_field = (bits[204] ? 5'sd1 : -5'sd1) + (bits[205] ? -5'sd1 : 5'sd1) + (bits[206] ? -5'sd1 : 5'sd1) + (bits[216] ? -5'sd1 : 5'sd1) + (bits[218] ? -5'sd1 : 5'sd1) + (bits[228] ? -5'sd1 : 5'sd1) + (bits[229] ? -5'sd1 : 5'sd1) + (bits[230] ? 5'sd1 : -5'sd1);
218: raw_field = (bits[205] ? -5'sd1 : 5'sd1) + (bits[206] ? 5'sd1 : -5'sd1) + (bits[207] ? 5'sd1 : -5'sd1) + (bits[217] ? -5'sd1 : 5'sd1) + (bits[219] ? 5'sd1 : -5'sd1) + (bits[229] ? 5'sd1 : -5'sd1) + (bits[230] ? 5'sd1 : -5'sd1) + (bits[231] ? 5'sd1 : -5'sd1);
219: raw_field = (bits[206] ? 5'sd1 : -5'sd1) + (bits[207] ? -5'sd1 : 5'sd1) + (bits[208] ? 5'sd1 : -5'sd1) + (bits[218] ? 5'sd1 : -5'sd1) + (bits[220] ? 5'sd1 : -5'sd1) + (bits[230] ? 5'sd1 : -5'sd1) + (bits[231] ? -5'sd1 : 5'sd1) + (bits[232] ? 5'sd1 : -5'sd1);
220: raw_field = (bits[207] ? 5'sd1 : -5'sd1) + (bits[208] ? -5'sd1 : 5'sd1) + (bits[209] ? 5'sd1 : -5'sd1) + (bits[219] ? 5'sd1 : -5'sd1) + (bits[221] ? -5'sd1 : 5'sd1) + (bits[231] ? -5'sd1 : 5'sd1) + (bits[232] ? 5'sd1 : -5'sd1) + (bits[233] ? -5'sd1 : 5'sd1);
221: raw_field = (bits[208] ? 5'sd1 : -5'sd1) + (bits[209] ? -5'sd1 : 5'sd1) + (bits[210] ? 5'sd1 : -5'sd1) + (bits[220] ? -5'sd1 : 5'sd1) + (bits[222] ? 5'sd1 : -5'sd1) + (bits[232] ? -5'sd1 : 5'sd1) + (bits[233] ? -5'sd1 : 5'sd1) + (bits[234] ? 5'sd1 : -5'sd1);
222: raw_field = (bits[209] ? -5'sd1 : 5'sd1) + (bits[210] ? 5'sd1 : -5'sd1) + (bits[211] ? -5'sd1 : 5'sd1) + (bits[221] ? 5'sd1 : -5'sd1) + (bits[223] ? 5'sd1 : -5'sd1) + (bits[233] ? -5'sd1 : 5'sd1) + (bits[234] ? -5'sd1 : 5'sd1) + (bits[235] ? -5'sd1 : 5'sd1);
223: raw_field = (bits[210] ? 5'sd1 : -5'sd1) + (bits[211] ? -5'sd1 : 5'sd1) + (bits[212] ? 5'sd1 : -5'sd1) + (bits[222] ? 5'sd1 : -5'sd1) + (bits[224] ? 5'sd1 : -5'sd1) + (bits[234] ? -5'sd1 : 5'sd1) + (bits[235] ? -5'sd1 : 5'sd1) + (bits[236] ? -5'sd1 : 5'sd1);
224: raw_field = (bits[211] ? -5'sd1 : 5'sd1) + (bits[212] ? -5'sd1 : 5'sd1) + (bits[213] ? 5'sd1 : -5'sd1) + (bits[223] ? 5'sd1 : -5'sd1) + (bits[225] ? -5'sd1 : 5'sd1) + (bits[235] ? -5'sd1 : 5'sd1) + (bits[236] ? -5'sd1 : 5'sd1) + (bits[237] ? -5'sd1 : 5'sd1);
225: raw_field = (bits[212] ? -5'sd1 : 5'sd1) + (bits[213] ? 5'sd1 : -5'sd1) + (bits[214] ? -5'sd1 : 5'sd1) + (bits[224] ? -5'sd1 : 5'sd1) + (bits[226] ? 5'sd1 : -5'sd1) + (bits[236] ? -5'sd1 : 5'sd1) + (bits[237] ? 5'sd1 : -5'sd1) + (bits[238] ? -5'sd1 : 5'sd1);
226: raw_field = (bits[213] ? -5'sd1 : 5'sd1) + (bits[214] ? 5'sd1 : -5'sd1) + (bits[215] ? -5'sd1 : 5'sd1) + (bits[225] ? 5'sd1 : -5'sd1) + (bits[227] ? 5'sd1 : -5'sd1) + (bits[237] ? 5'sd1 : -5'sd1) + (bits[238] ? 5'sd1 : -5'sd1) + (bits[239] ? -5'sd1 : 5'sd1);
227: raw_field = (bits[214] ? -5'sd1 : 5'sd1) + (bits[215] ? -5'sd1 : 5'sd1) + (bits[226] ? 5'sd1 : -5'sd1) + (bits[238] ? -5'sd1 : 5'sd1) + (bits[239] ? -5'sd1 : 5'sd1);
228: raw_field = (bits[216] ? -5'sd1 : 5'sd1) + (bits[217] ? -5'sd1 : 5'sd1) + (bits[229] ? -5'sd1 : 5'sd1) + (bits[240] ? -5'sd1 : 5'sd1) + (bits[241] ? -5'sd1 : 5'sd1);
229: raw_field = (bits[216] ? 5'sd1 : -5'sd1) + (bits[217] ? -5'sd1 : 5'sd1) + (bits[218] ? 5'sd1 : -5'sd1) + (bits[228] ? -5'sd1 : 5'sd1) + (bits[230] ? -5'sd1 : 5'sd1) + (bits[240] ? -5'sd1 : 5'sd1) + (bits[241] ? 5'sd1 : -5'sd1) + (bits[242] ? 5'sd1 : -5'sd1);
230: raw_field = (bits[217] ? 5'sd1 : -5'sd1) + (bits[218] ? 5'sd1 : -5'sd1) + (bits[219] ? 5'sd1 : -5'sd1) + (bits[229] ? -5'sd1 : 5'sd1) + (bits[231] ? 5'sd1 : -5'sd1) + (bits[241] ? -5'sd1 : 5'sd1) + (bits[242] ? -5'sd1 : 5'sd1) + (bits[243] ? -5'sd1 : 5'sd1);
231: raw_field = (bits[218] ? 5'sd1 : -5'sd1) + (bits[219] ? -5'sd1 : 5'sd1) + (bits[220] ? -5'sd1 : 5'sd1) + (bits[230] ? 5'sd1 : -5'sd1) + (bits[232] ? 5'sd1 : -5'sd1) + (bits[242] ? 5'sd1 : -5'sd1) + (bits[243] ? -5'sd1 : 5'sd1) + (bits[244] ? -5'sd1 : 5'sd1);
232: raw_field = (bits[219] ? 5'sd1 : -5'sd1) + (bits[220] ? 5'sd1 : -5'sd1) + (bits[221] ? -5'sd1 : 5'sd1) + (bits[231] ? 5'sd1 : -5'sd1) + (bits[233] ? -5'sd1 : 5'sd1) + (bits[243] ? 5'sd1 : -5'sd1) + (bits[244] ? -5'sd1 : 5'sd1) + (bits[245] ? 5'sd1 : -5'sd1);
233: raw_field = (bits[220] ? -5'sd1 : 5'sd1) + (bits[221] ? -5'sd1 : 5'sd1) + (bits[222] ? -5'sd1 : 5'sd1) + (bits[232] ? -5'sd1 : 5'sd1) + (bits[234] ? 5'sd1 : -5'sd1) + (bits[244] ? -5'sd1 : 5'sd1) + (bits[245] ? -5'sd1 : 5'sd1) + (bits[246] ? -5'sd1 : 5'sd1);
234: raw_field = (bits[221] ? 5'sd1 : -5'sd1) + (bits[222] ? -5'sd1 : 5'sd1) + (bits[223] ? -5'sd1 : 5'sd1) + (bits[233] ? 5'sd1 : -5'sd1) + (bits[235] ? -5'sd1 : 5'sd1) + (bits[245] ? 5'sd1 : -5'sd1) + (bits[246] ? 5'sd1 : -5'sd1) + (bits[247] ? -5'sd1 : 5'sd1);
235: raw_field = (bits[222] ? -5'sd1 : 5'sd1) + (bits[223] ? -5'sd1 : 5'sd1) + (bits[224] ? -5'sd1 : 5'sd1) + (bits[234] ? -5'sd1 : 5'sd1) + (bits[236] ? 5'sd1 : -5'sd1) + (bits[246] ? 5'sd1 : -5'sd1) + (bits[247] ? -5'sd1 : 5'sd1) + (bits[248] ? 5'sd1 : -5'sd1);
236: raw_field = (bits[223] ? -5'sd1 : 5'sd1) + (bits[224] ? -5'sd1 : 5'sd1) + (bits[225] ? -5'sd1 : 5'sd1) + (bits[235] ? 5'sd1 : -5'sd1) + (bits[237] ? -5'sd1 : 5'sd1) + (bits[247] ? -5'sd1 : 5'sd1) + (bits[248] ? -5'sd1 : 5'sd1) + (bits[249] ? 5'sd1 : -5'sd1);
237: raw_field = (bits[224] ? -5'sd1 : 5'sd1) + (bits[225] ? 5'sd1 : -5'sd1) + (bits[226] ? 5'sd1 : -5'sd1) + (bits[236] ? -5'sd1 : 5'sd1) + (bits[238] ? 5'sd1 : -5'sd1) + (bits[248] ? 5'sd1 : -5'sd1) + (bits[249] ? -5'sd1 : 5'sd1) + (bits[250] ? 5'sd1 : -5'sd1);
238: raw_field = (bits[225] ? -5'sd1 : 5'sd1) + (bits[226] ? 5'sd1 : -5'sd1) + (bits[227] ? -5'sd1 : 5'sd1) + (bits[237] ? 5'sd1 : -5'sd1) + (bits[239] ? 5'sd1 : -5'sd1) + (bits[249] ? -5'sd1 : 5'sd1) + (bits[250] ? 5'sd1 : -5'sd1) + (bits[251] ? 5'sd1 : -5'sd1);
239: raw_field = (bits[226] ? -5'sd1 : 5'sd1) + (bits[227] ? -5'sd1 : 5'sd1) + (bits[238] ? 5'sd1 : -5'sd1) + (bits[250] ? -5'sd1 : 5'sd1) + (bits[251] ? -5'sd1 : 5'sd1);
240: raw_field = (bits[228] ? -5'sd1 : 5'sd1) + (bits[229] ? -5'sd1 : 5'sd1) + (bits[241] ? 5'sd1 : -5'sd1) + (bits[252] ? -5'sd1 : 5'sd1) + (bits[253] ? -5'sd1 : 5'sd1);
241: raw_field = (bits[228] ? -5'sd1 : 5'sd1) + (bits[229] ? 5'sd1 : -5'sd1) + (bits[230] ? -5'sd1 : 5'sd1) + (bits[240] ? 5'sd1 : -5'sd1) + (bits[242] ? -5'sd1 : 5'sd1) + (bits[252] ? -5'sd1 : 5'sd1) + (bits[253] ? -5'sd1 : 5'sd1) + (bits[254] ? 5'sd1 : -5'sd1);
242: raw_field = (bits[229] ? 5'sd1 : -5'sd1) + (bits[230] ? -5'sd1 : 5'sd1) + (bits[231] ? 5'sd1 : -5'sd1) + (bits[241] ? -5'sd1 : 5'sd1) + (bits[243] ? 5'sd1 : -5'sd1) + (bits[253] ? -5'sd1 : 5'sd1) + (bits[254] ? 5'sd1 : -5'sd1) + (bits[255] ? -5'sd1 : 5'sd1);
243: raw_field = (bits[230] ? -5'sd1 : 5'sd1) + (bits[231] ? -5'sd1 : 5'sd1) + (bits[232] ? 5'sd1 : -5'sd1) + (bits[242] ? 5'sd1 : -5'sd1) + (bits[244] ? 5'sd1 : -5'sd1) + (bits[254] ? -5'sd1 : 5'sd1) + (bits[255] ? 5'sd1 : -5'sd1) + (bits[256] ? -5'sd1 : 5'sd1);
244: raw_field = (bits[231] ? -5'sd1 : 5'sd1) + (bits[232] ? -5'sd1 : 5'sd1) + (bits[233] ? -5'sd1 : 5'sd1) + (bits[243] ? 5'sd1 : -5'sd1) + (bits[245] ? 5'sd1 : -5'sd1) + (bits[255] ? 5'sd1 : -5'sd1) + (bits[256] ? -5'sd1 : 5'sd1) + (bits[257] ? 5'sd1 : -5'sd1);
245: raw_field = (bits[232] ? 5'sd1 : -5'sd1) + (bits[233] ? -5'sd1 : 5'sd1) + (bits[234] ? 5'sd1 : -5'sd1) + (bits[244] ? 5'sd1 : -5'sd1) + (bits[246] ? 5'sd1 : -5'sd1) + (bits[256] ? 5'sd1 : -5'sd1) + (bits[257] ? 5'sd1 : -5'sd1) + (bits[258] ? -5'sd1 : 5'sd1);
246: raw_field = (bits[233] ? -5'sd1 : 5'sd1) + (bits[234] ? 5'sd1 : -5'sd1) + (bits[235] ? 5'sd1 : -5'sd1) + (bits[245] ? 5'sd1 : -5'sd1) + (bits[247] ? -5'sd1 : 5'sd1) + (bits[257] ? -5'sd1 : 5'sd1) + (bits[258] ? 5'sd1 : -5'sd1) + (bits[259] ? -5'sd1 : 5'sd1);
247: raw_field = (bits[234] ? -5'sd1 : 5'sd1) + (bits[235] ? -5'sd1 : 5'sd1) + (bits[236] ? -5'sd1 : 5'sd1) + (bits[246] ? -5'sd1 : 5'sd1) + (bits[248] ? -5'sd1 : 5'sd1) + (bits[258] ? 5'sd1 : -5'sd1) + (bits[259] ? 5'sd1 : -5'sd1) + (bits[260] ? -5'sd1 : 5'sd1);
248: raw_field = (bits[235] ? 5'sd1 : -5'sd1) + (bits[236] ? -5'sd1 : 5'sd1) + (bits[237] ? 5'sd1 : -5'sd1) + (bits[247] ? -5'sd1 : 5'sd1) + (bits[249] ? 5'sd1 : -5'sd1) + (bits[259] ? -5'sd1 : 5'sd1) + (bits[260] ? 5'sd1 : -5'sd1) + (bits[261] ? 5'sd1 : -5'sd1);
249: raw_field = (bits[236] ? 5'sd1 : -5'sd1) + (bits[237] ? -5'sd1 : 5'sd1) + (bits[238] ? -5'sd1 : 5'sd1) + (bits[248] ? 5'sd1 : -5'sd1) + (bits[250] ? 5'sd1 : -5'sd1) + (bits[260] ? 5'sd1 : -5'sd1) + (bits[261] ? -5'sd1 : 5'sd1) + (bits[262] ? 5'sd1 : -5'sd1);
250: raw_field = (bits[237] ? 5'sd1 : -5'sd1) + (bits[238] ? 5'sd1 : -5'sd1) + (bits[239] ? -5'sd1 : 5'sd1) + (bits[249] ? 5'sd1 : -5'sd1) + (bits[251] ? -5'sd1 : 5'sd1) + (bits[261] ? 5'sd1 : -5'sd1) + (bits[262] ? -5'sd1 : 5'sd1) + (bits[263] ? 5'sd1 : -5'sd1);
251: raw_field = (bits[238] ? 5'sd1 : -5'sd1) + (bits[239] ? -5'sd1 : 5'sd1) + (bits[250] ? -5'sd1 : 5'sd1) + (bits[262] ? 5'sd1 : -5'sd1) + (bits[263] ? 5'sd1 : -5'sd1);
252: raw_field = (bits[240] ? -5'sd1 : 5'sd1) + (bits[241] ? -5'sd1 : 5'sd1) + (bits[253] ? 5'sd1 : -5'sd1) + (bits[264] ? -5'sd1 : 5'sd1) + (bits[265] ? -5'sd1 : 5'sd1);
253: raw_field = (bits[240] ? -5'sd1 : 5'sd1) + (bits[241] ? -5'sd1 : 5'sd1) + (bits[242] ? -5'sd1 : 5'sd1) + (bits[252] ? 5'sd1 : -5'sd1) + (bits[254] ? 5'sd1 : -5'sd1) + (bits[264] ? -5'sd1 : 5'sd1) + (bits[265] ? 5'sd1 : -5'sd1) + (bits[266] ? 5'sd1 : -5'sd1);
254: raw_field = (bits[241] ? 5'sd1 : -5'sd1) + (bits[242] ? 5'sd1 : -5'sd1) + (bits[243] ? -5'sd1 : 5'sd1) + (bits[253] ? 5'sd1 : -5'sd1) + (bits[255] ? 5'sd1 : -5'sd1) + (bits[265] ? 5'sd1 : -5'sd1) + (bits[266] ? 5'sd1 : -5'sd1) + (bits[267] ? -5'sd1 : 5'sd1);
255: raw_field = (bits[242] ? -5'sd1 : 5'sd1) + (bits[243] ? 5'sd1 : -5'sd1) + (bits[244] ? 5'sd1 : -5'sd1) + (bits[254] ? 5'sd1 : -5'sd1) + (bits[256] ? 5'sd1 : -5'sd1) + (bits[266] ? -5'sd1 : 5'sd1) + (bits[267] ? -5'sd1 : 5'sd1) + (bits[268] ? 5'sd1 : -5'sd1);
256: raw_field = (bits[243] ? -5'sd1 : 5'sd1) + (bits[244] ? -5'sd1 : 5'sd1) + (bits[245] ? 5'sd1 : -5'sd1) + (bits[255] ? 5'sd1 : -5'sd1) + (bits[257] ? 5'sd1 : -5'sd1) + (bits[267] ? 5'sd1 : -5'sd1) + (bits[268] ? 5'sd1 : -5'sd1) + (bits[269] ? -5'sd1 : 5'sd1);
257: raw_field = (bits[244] ? 5'sd1 : -5'sd1) + (bits[245] ? 5'sd1 : -5'sd1) + (bits[246] ? -5'sd1 : 5'sd1) + (bits[256] ? 5'sd1 : -5'sd1) + (bits[258] ? -5'sd1 : 5'sd1) + (bits[268] ? 5'sd1 : -5'sd1) + (bits[269] ? 5'sd1 : -5'sd1) + (bits[270] ? 5'sd1 : -5'sd1);
258: raw_field = (bits[245] ? -5'sd1 : 5'sd1) + (bits[246] ? 5'sd1 : -5'sd1) + (bits[247] ? 5'sd1 : -5'sd1) + (bits[257] ? -5'sd1 : 5'sd1) + (bits[259] ? -5'sd1 : 5'sd1) + (bits[269] ? -5'sd1 : 5'sd1) + (bits[270] ? 5'sd1 : -5'sd1) + (bits[271] ? -5'sd1 : 5'sd1);
259: raw_field = (bits[246] ? -5'sd1 : 5'sd1) + (bits[247] ? 5'sd1 : -5'sd1) + (bits[248] ? -5'sd1 : 5'sd1) + (bits[258] ? -5'sd1 : 5'sd1) + (bits[260] ? 5'sd1 : -5'sd1) + (bits[270] ? 5'sd1 : -5'sd1) + (bits[271] ? 5'sd1 : -5'sd1) + (bits[272] ? -5'sd1 : 5'sd1);
260: raw_field = (bits[247] ? -5'sd1 : 5'sd1) + (bits[248] ? 5'sd1 : -5'sd1) + (bits[249] ? 5'sd1 : -5'sd1) + (bits[259] ? 5'sd1 : -5'sd1) + (bits[261] ? 5'sd1 : -5'sd1) + (bits[271] ? 5'sd1 : -5'sd1) + (bits[272] ? -5'sd1 : 5'sd1) + (bits[273] ? -5'sd1 : 5'sd1);
261: raw_field = (bits[248] ? 5'sd1 : -5'sd1) + (bits[249] ? -5'sd1 : 5'sd1) + (bits[250] ? 5'sd1 : -5'sd1) + (bits[260] ? 5'sd1 : -5'sd1) + (bits[262] ? -5'sd1 : 5'sd1) + (bits[272] ? 5'sd1 : -5'sd1) + (bits[273] ? -5'sd1 : 5'sd1) + (bits[274] ? 5'sd1 : -5'sd1);
262: raw_field = (bits[249] ? 5'sd1 : -5'sd1) + (bits[250] ? -5'sd1 : 5'sd1) + (bits[251] ? 5'sd1 : -5'sd1) + (bits[261] ? -5'sd1 : 5'sd1) + (bits[263] ? 5'sd1 : -5'sd1) + (bits[273] ? -5'sd1 : 5'sd1) + (bits[274] ? 5'sd1 : -5'sd1) + (bits[275] ? -5'sd1 : 5'sd1);
263: raw_field = (bits[250] ? 5'sd1 : -5'sd1) + (bits[251] ? 5'sd1 : -5'sd1) + (bits[262] ? 5'sd1 : -5'sd1) + (bits[274] ? -5'sd1 : 5'sd1) + (bits[275] ? -5'sd1 : 5'sd1);
264: raw_field = (bits[252] ? -5'sd1 : 5'sd1) + (bits[253] ? -5'sd1 : 5'sd1) + (bits[265] ? 5'sd1 : -5'sd1) + (bits[276] ? -5'sd1 : 5'sd1) + (bits[277] ? -5'sd1 : 5'sd1);
265: raw_field = (bits[252] ? -5'sd1 : 5'sd1) + (bits[253] ? 5'sd1 : -5'sd1) + (bits[254] ? 5'sd1 : -5'sd1) + (bits[264] ? 5'sd1 : -5'sd1) + (bits[266] ? -5'sd1 : 5'sd1) + (bits[276] ? -5'sd1 : 5'sd1) + (bits[277] ? 5'sd1 : -5'sd1) + (bits[278] ? 5'sd1 : -5'sd1);
266: raw_field = (bits[253] ? 5'sd1 : -5'sd1) + (bits[254] ? 5'sd1 : -5'sd1) + (bits[255] ? -5'sd1 : 5'sd1) + (bits[265] ? -5'sd1 : 5'sd1) + (bits[267] ? -5'sd1 : 5'sd1) + (bits[277] ? 5'sd1 : -5'sd1) + (bits[278] ? 5'sd1 : -5'sd1) + (bits[279] ? -5'sd1 : 5'sd1);
267: raw_field = (bits[254] ? -5'sd1 : 5'sd1) + (bits[255] ? -5'sd1 : 5'sd1) + (bits[256] ? 5'sd1 : -5'sd1) + (bits[266] ? -5'sd1 : 5'sd1) + (bits[268] ? 5'sd1 : -5'sd1) + (bits[278] ? -5'sd1 : 5'sd1) + (bits[279] ? -5'sd1 : 5'sd1) + (bits[280] ? 5'sd1 : -5'sd1);
268: raw_field = (bits[255] ? 5'sd1 : -5'sd1) + (bits[256] ? 5'sd1 : -5'sd1) + (bits[257] ? 5'sd1 : -5'sd1) + (bits[267] ? 5'sd1 : -5'sd1) + (bits[269] ? -5'sd1 : 5'sd1) + (bits[279] ? -5'sd1 : 5'sd1) + (bits[280] ? 5'sd1 : -5'sd1) + (bits[281] ? 5'sd1 : -5'sd1);
269: raw_field = (bits[256] ? -5'sd1 : 5'sd1) + (bits[257] ? 5'sd1 : -5'sd1) + (bits[258] ? -5'sd1 : 5'sd1) + (bits[268] ? -5'sd1 : 5'sd1) + (bits[270] ? -5'sd1 : 5'sd1) + (bits[280] ? -5'sd1 : 5'sd1) + (bits[281] ? -5'sd1 : 5'sd1) + (bits[282] ? -5'sd1 : 5'sd1);
270: raw_field = (bits[257] ? 5'sd1 : -5'sd1) + (bits[258] ? 5'sd1 : -5'sd1) + (bits[259] ? 5'sd1 : -5'sd1) + (bits[269] ? -5'sd1 : 5'sd1) + (bits[271] ? 5'sd1 : -5'sd1) + (bits[281] ? -5'sd1 : 5'sd1) + (bits[282] ? -5'sd1 : 5'sd1) + (bits[283] ? 5'sd1 : -5'sd1);
271: raw_field = (bits[258] ? -5'sd1 : 5'sd1) + (bits[259] ? 5'sd1 : -5'sd1) + (bits[260] ? 5'sd1 : -5'sd1) + (bits[270] ? 5'sd1 : -5'sd1) + (bits[272] ? 5'sd1 : -5'sd1) + (bits[282] ? 5'sd1 : -5'sd1) + (bits[283] ? -5'sd1 : 5'sd1) + (bits[284] ? -5'sd1 : 5'sd1);
272: raw_field = (bits[259] ? -5'sd1 : 5'sd1) + (bits[260] ? -5'sd1 : 5'sd1) + (bits[261] ? 5'sd1 : -5'sd1) + (bits[271] ? 5'sd1 : -5'sd1) + (bits[273] ? -5'sd1 : 5'sd1) + (bits[283] ? -5'sd1 : 5'sd1) + (bits[284] ? -5'sd1 : 5'sd1) + (bits[285] ? 5'sd1 : -5'sd1);
273: raw_field = (bits[260] ? -5'sd1 : 5'sd1) + (bits[261] ? -5'sd1 : 5'sd1) + (bits[262] ? -5'sd1 : 5'sd1) + (bits[272] ? -5'sd1 : 5'sd1) + (bits[274] ? -5'sd1 : 5'sd1) + (bits[284] ? 5'sd1 : -5'sd1) + (bits[285] ? 5'sd1 : -5'sd1) + (bits[286] ? -5'sd1 : 5'sd1);
274: raw_field = (bits[261] ? 5'sd1 : -5'sd1) + (bits[262] ? 5'sd1 : -5'sd1) + (bits[263] ? -5'sd1 : 5'sd1) + (bits[273] ? -5'sd1 : 5'sd1) + (bits[275] ? -5'sd1 : 5'sd1) + (bits[285] ? 5'sd1 : -5'sd1) + (bits[286] ? -5'sd1 : 5'sd1) + (bits[287] ? 5'sd1 : -5'sd1);
275: raw_field = (bits[262] ? -5'sd1 : 5'sd1) + (bits[263] ? -5'sd1 : 5'sd1) + (bits[274] ? -5'sd1 : 5'sd1) + (bits[286] ? -5'sd1 : 5'sd1) + (bits[287] ? 5'sd1 : -5'sd1);
276: raw_field = (bits[264] ? -5'sd1 : 5'sd1) + (bits[265] ? -5'sd1 : 5'sd1) + (bits[277] ? -5'sd1 : 5'sd1);
277: raw_field = (bits[264] ? -5'sd1 : 5'sd1) + (bits[265] ? 5'sd1 : -5'sd1) + (bits[266] ? 5'sd1 : -5'sd1) + (bits[276] ? -5'sd1 : 5'sd1) + (bits[278] ? -5'sd1 : 5'sd1);
278: raw_field = (bits[265] ? 5'sd1 : -5'sd1) + (bits[266] ? 5'sd1 : -5'sd1) + (bits[267] ? -5'sd1 : 5'sd1) + (bits[277] ? -5'sd1 : 5'sd1) + (bits[279] ? 5'sd1 : -5'sd1);
279: raw_field = (bits[266] ? -5'sd1 : 5'sd1) + (bits[267] ? -5'sd1 : 5'sd1) + (bits[268] ? -5'sd1 : 5'sd1) + (bits[278] ? 5'sd1 : -5'sd1) + (bits[280] ? 5'sd1 : -5'sd1);
280: raw_field = (bits[267] ? 5'sd1 : -5'sd1) + (bits[268] ? 5'sd1 : -5'sd1) + (bits[269] ? -5'sd1 : 5'sd1) + (bits[279] ? 5'sd1 : -5'sd1) + (bits[281] ? 5'sd1 : -5'sd1);
281: raw_field = (bits[268] ? 5'sd1 : -5'sd1) + (bits[269] ? -5'sd1 : 5'sd1) + (bits[270] ? -5'sd1 : 5'sd1) + (bits[280] ? 5'sd1 : -5'sd1) + (bits[282] ? 5'sd1 : -5'sd1);
282: raw_field = (bits[269] ? -5'sd1 : 5'sd1) + (bits[270] ? -5'sd1 : 5'sd1) + (bits[271] ? 5'sd1 : -5'sd1) + (bits[281] ? 5'sd1 : -5'sd1) + (bits[283] ? -5'sd1 : 5'sd1);
283: raw_field = (bits[270] ? 5'sd1 : -5'sd1) + (bits[271] ? -5'sd1 : 5'sd1) + (bits[272] ? -5'sd1 : 5'sd1) + (bits[282] ? -5'sd1 : 5'sd1) + (bits[284] ? -5'sd1 : 5'sd1);
284: raw_field = (bits[271] ? -5'sd1 : 5'sd1) + (bits[272] ? -5'sd1 : 5'sd1) + (bits[273] ? 5'sd1 : -5'sd1) + (bits[283] ? -5'sd1 : 5'sd1) + (bits[285] ? 5'sd1 : -5'sd1);
285: raw_field = (bits[272] ? 5'sd1 : -5'sd1) + (bits[273] ? 5'sd1 : -5'sd1) + (bits[274] ? 5'sd1 : -5'sd1) + (bits[284] ? 5'sd1 : -5'sd1) + (bits[286] ? -5'sd1 : 5'sd1);
286: raw_field = (bits[273] ? -5'sd1 : 5'sd1) + (bits[274] ? -5'sd1 : 5'sd1) + (bits[275] ? -5'sd1 : 5'sd1) + (bits[285] ? -5'sd1 : 5'sd1) + (bits[287] ? 5'sd1 : -5'sd1);
287: raw_field = (bits[274] ? 5'sd1 : -5'sd1) + (bits[275] ? 5'sd1 : -5'sd1) + (bits[286] ? 5'sd1 : -5'sd1);
default: raw_field=0;
endcase
end
endfunction
function automatic signed [11:0] score(input logic [287:0] bits);
begin
score = ((((((((((((bits[0] ^ bits[1]) ? -12'sd1 : 12'sd0) +
((bits[0] ^ bits[12]) ? 12'sd1 : 12'sd0)) +
(((bits[0] ^ bits[13]) ? -12'sd1 : 12'sd0) +
((bits[1] ^ bits[2]) ? 12'sd1 : 12'sd0))) +
((((bits[1] ^ bits[12]) ? 12'sd1 : 12'sd0) +
((bits[1] ^ bits[13]) ? -12'sd1 : 12'sd0)) +
(((bits[1] ^ bits[14]) ? 12'sd1 : 12'sd0) +
((bits[2] ^ bits[3]) ? -12'sd1 : 12'sd0)))) +
(((((bits[2] ^ bits[13]) ? 12'sd1 : 12'sd0) +
((bits[2] ^ bits[14]) ? -12'sd1 : 12'sd0)) +
(((bits[2] ^ bits[15]) ? -12'sd1 : 12'sd0) +
((bits[3] ^ bits[4]) ? 12'sd1 : 12'sd0))) +
((((bits[3] ^ bits[14]) ? 12'sd1 : 12'sd0) +
((bits[3] ^ bits[15]) ? 12'sd1 : 12'sd0)) +
(((bits[3] ^ bits[16]) ? 12'sd1 : 12'sd0) +
((bits[4] ^ bits[5]) ? -12'sd1 : 12'sd0))))) +
((((((bits[4] ^ bits[15]) ? -12'sd1 : 12'sd0) +
((bits[4] ^ bits[16]) ? -12'sd1 : 12'sd0)) +
(((bits[4] ^ bits[17]) ? 12'sd1 : 12'sd0) +
((bits[5] ^ bits[6]) ? -12'sd1 : 12'sd0))) +
((((bits[5] ^ bits[16]) ? 12'sd1 : 12'sd0) +
((bits[5] ^ bits[17]) ? -12'sd1 : 12'sd0)) +
(((bits[5] ^ bits[18]) ? 12'sd1 : 12'sd0) +
((bits[6] ^ bits[7]) ? 12'sd1 : 12'sd0)))) +
(((((bits[6] ^ bits[17]) ? 12'sd1 : 12'sd0) +
((bits[6] ^ bits[18]) ? 12'sd1 : 12'sd0)) +
(((bits[6] ^ bits[19]) ? -12'sd1 : 12'sd0) +
((bits[7] ^ bits[8]) ? -12'sd1 : 12'sd0))) +
((((bits[7] ^ bits[18]) ? 12'sd1 : 12'sd0) +
((bits[7] ^ bits[19]) ? -12'sd1 : 12'sd0)) +
(((bits[7] ^ bits[20]) ? 12'sd1 : 12'sd0) +
((bits[8] ^ bits[9]) ? -12'sd1 : 12'sd0)))))) +
(((((((bits[8] ^ bits[19]) ? -12'sd1 : 12'sd0) +
((bits[8] ^ bits[20]) ? 12'sd1 : 12'sd0)) +
(((bits[8] ^ bits[21]) ? 12'sd1 : 12'sd0) +
((bits[9] ^ bits[10]) ? 12'sd1 : 12'sd0))) +
((((bits[9] ^ bits[20]) ? 12'sd1 : 12'sd0) +
((bits[9] ^ bits[21]) ? 12'sd1 : 12'sd0)) +
(((bits[9] ^ bits[22]) ? -12'sd1 : 12'sd0) +
((bits[10] ^ bits[11]) ? -12'sd1 : 12'sd0)))) +
(((((bits[10] ^ bits[21]) ? -12'sd1 : 12'sd0) +
((bits[10] ^ bits[22]) ? -12'sd1 : 12'sd0)) +
(((bits[10] ^ bits[23]) ? -12'sd1 : 12'sd0) +
((bits[11] ^ bits[22]) ? -12'sd1 : 12'sd0))) +
((((bits[11] ^ bits[23]) ? 12'sd1 : 12'sd0) +
((bits[12] ^ bits[13]) ? -12'sd1 : 12'sd0)) +
(((bits[12] ^ bits[24]) ? -12'sd1 : 12'sd0) +
((bits[12] ^ bits[25]) ? -12'sd1 : 12'sd0))))) +
((((((bits[13] ^ bits[14]) ? -12'sd1 : 12'sd0) +
((bits[13] ^ bits[24]) ? 12'sd1 : 12'sd0)) +
(((bits[13] ^ bits[25]) ? -12'sd1 : 12'sd0) +
((bits[13] ^ bits[26]) ? -12'sd1 : 12'sd0))) +
((((bits[14] ^ bits[15]) ? 12'sd1 : 12'sd0) +
((bits[14] ^ bits[25]) ? -12'sd1 : 12'sd0)) +
(((bits[14] ^ bits[26]) ? -12'sd1 : 12'sd0) +
((bits[14] ^ bits[27]) ? 12'sd1 : 12'sd0)))) +
(((((bits[15] ^ bits[16]) ? 12'sd1 : 12'sd0) +
((bits[15] ^ bits[26]) ? -12'sd1 : 12'sd0)) +
(((bits[15] ^ bits[27]) ? -12'sd1 : 12'sd0) +
((bits[15] ^ bits[28]) ? -12'sd1 : 12'sd0))) +
((((bits[16] ^ bits[17]) ? 12'sd1 : 12'sd0) +
((bits[16] ^ bits[27]) ? 12'sd1 : 12'sd0)) +
(((bits[16] ^ bits[28]) ? -12'sd1 : 12'sd0) +
(((bits[16] ^ bits[29]) ? 12'sd1 : 12'sd0) +
((bits[17] ^ bits[18]) ? 12'sd1 : 12'sd0)))))))) +
((((((((bits[17] ^ bits[28]) ? -12'sd1 : 12'sd0) +
((bits[17] ^ bits[29]) ? -12'sd1 : 12'sd0)) +
(((bits[17] ^ bits[30]) ? -12'sd1 : 12'sd0) +
((bits[18] ^ bits[19]) ? -12'sd1 : 12'sd0))) +
((((bits[18] ^ bits[29]) ? 12'sd1 : 12'sd0) +
((bits[18] ^ bits[30]) ? -12'sd1 : 12'sd0)) +
(((bits[18] ^ bits[31]) ? 12'sd1 : 12'sd0) +
((bits[19] ^ bits[20]) ? -12'sd1 : 12'sd0)))) +
(((((bits[19] ^ bits[30]) ? -12'sd1 : 12'sd0) +
((bits[19] ^ bits[31]) ? -12'sd1 : 12'sd0)) +
(((bits[19] ^ bits[32]) ? 12'sd1 : 12'sd0) +
((bits[20] ^ bits[21]) ? -12'sd1 : 12'sd0))) +
((((bits[20] ^ bits[31]) ? -12'sd1 : 12'sd0) +
((bits[20] ^ bits[32]) ? 12'sd1 : 12'sd0)) +
(((bits[20] ^ bits[33]) ? -12'sd1 : 12'sd0) +
((bits[21] ^ bits[22]) ? -12'sd1 : 12'sd0))))) +
((((((bits[21] ^ bits[32]) ? 12'sd1 : 12'sd0) +
((bits[21] ^ bits[33]) ? -12'sd1 : 12'sd0)) +
(((bits[21] ^ bits[34]) ? -12'sd1 : 12'sd0) +
((bits[22] ^ bits[23]) ? -12'sd1 : 12'sd0))) +
((((bits[22] ^ bits[33]) ? 12'sd1 : 12'sd0) +
((bits[22] ^ bits[34]) ? -12'sd1 : 12'sd0)) +
(((bits[22] ^ bits[35]) ? -12'sd1 : 12'sd0) +
((bits[23] ^ bits[34]) ? -12'sd1 : 12'sd0)))) +
(((((bits[23] ^ bits[35]) ? -12'sd1 : 12'sd0) +
((bits[24] ^ bits[25]) ? 12'sd1 : 12'sd0)) +
(((bits[24] ^ bits[36]) ? -12'sd1 : 12'sd0) +
((bits[24] ^ bits[37]) ? 12'sd1 : 12'sd0))) +
((((bits[25] ^ bits[26]) ? -12'sd1 : 12'sd0) +
((bits[25] ^ bits[36]) ? 12'sd1 : 12'sd0)) +
(((bits[25] ^ bits[37]) ? -12'sd1 : 12'sd0) +
((bits[25] ^ bits[38]) ? -12'sd1 : 12'sd0)))))) +
(((((((bits[26] ^ bits[27]) ? -12'sd1 : 12'sd0) +
((bits[26] ^ bits[37]) ? -12'sd1 : 12'sd0)) +
(((bits[26] ^ bits[38]) ? -12'sd1 : 12'sd0) +
((bits[26] ^ bits[39]) ? 12'sd1 : 12'sd0))) +
((((bits[27] ^ bits[28]) ? 12'sd1 : 12'sd0) +
((bits[27] ^ bits[38]) ? 12'sd1 : 12'sd0)) +
(((bits[27] ^ bits[39]) ? 12'sd1 : 12'sd0) +
((bits[27] ^ bits[40]) ? 12'sd1 : 12'sd0)))) +
(((((bits[28] ^ bits[29]) ? -12'sd1 : 12'sd0) +
((bits[28] ^ bits[39]) ? -12'sd1 : 12'sd0)) +
(((bits[28] ^ bits[40]) ? -12'sd1 : 12'sd0) +
((bits[28] ^ bits[41]) ? 12'sd1 : 12'sd0))) +
((((bits[29] ^ bits[30]) ? 12'sd1 : 12'sd0) +
((bits[29] ^ bits[40]) ? 12'sd1 : 12'sd0)) +
(((bits[29] ^ bits[41]) ? 12'sd1 : 12'sd0) +
((bits[29] ^ bits[42]) ? -12'sd1 : 12'sd0))))) +
((((((bits[30] ^ bits[31]) ? 12'sd1 : 12'sd0) +
((bits[30] ^ bits[41]) ? -12'sd1 : 12'sd0)) +
(((bits[30] ^ bits[42]) ? 12'sd1 : 12'sd0) +
((bits[30] ^ bits[43]) ? 12'sd1 : 12'sd0))) +
((((bits[31] ^ bits[32]) ? 12'sd1 : 12'sd0) +
((bits[31] ^ bits[42]) ? 12'sd1 : 12'sd0)) +
(((bits[31] ^ bits[43]) ? -12'sd1 : 12'sd0) +
((bits[31] ^ bits[44]) ? 12'sd1 : 12'sd0)))) +
(((((bits[32] ^ bits[33]) ? 12'sd1 : 12'sd0) +
((bits[32] ^ bits[43]) ? -12'sd1 : 12'sd0)) +
(((bits[32] ^ bits[44]) ? -12'sd1 : 12'sd0) +
((bits[32] ^ bits[45]) ? -12'sd1 : 12'sd0))) +
((((bits[33] ^ bits[34]) ? 12'sd1 : 12'sd0) +
((bits[33] ^ bits[44]) ? 12'sd1 : 12'sd0)) +
(((bits[33] ^ bits[45]) ? 12'sd1 : 12'sd0) +
(((bits[33] ^ bits[46]) ? 12'sd1 : 12'sd0) +
((bits[34] ^ bits[35]) ? -12'sd1 : 12'sd0))))))))) +
(((((((((bits[34] ^ bits[45]) ? 12'sd1 : 12'sd0) +
((bits[34] ^ bits[46]) ? -12'sd1 : 12'sd0)) +
(((bits[34] ^ bits[47]) ? -12'sd1 : 12'sd0) +
((bits[35] ^ bits[46]) ? -12'sd1 : 12'sd0))) +
((((bits[35] ^ bits[47]) ? -12'sd1 : 12'sd0) +
((bits[36] ^ bits[37]) ? 12'sd1 : 12'sd0)) +
(((bits[36] ^ bits[48]) ? -12'sd1 : 12'sd0) +
((bits[36] ^ bits[49]) ? -12'sd1 : 12'sd0)))) +
(((((bits[37] ^ bits[38]) ? 12'sd1 : 12'sd0) +
((bits[37] ^ bits[48]) ? -12'sd1 : 12'sd0)) +
(((bits[37] ^ bits[49]) ? -12'sd1 : 12'sd0) +
((bits[37] ^ bits[50]) ? -12'sd1 : 12'sd0))) +
((((bits[38] ^ bits[39]) ? -12'sd1 : 12'sd0) +
((bits[38] ^ bits[49]) ? 12'sd1 : 12'sd0)) +
(((bits[38] ^ bits[50]) ? 12'sd1 : 12'sd0) +
((bits[38] ^ bits[51]) ? -12'sd1 : 12'sd0))))) +
((((((bits[39] ^ bits[40]) ? -12'sd1 : 12'sd0) +
((bits[39] ^ bits[50]) ? 12'sd1 : 12'sd0)) +
(((bits[39] ^ bits[51]) ? -12'sd1 : 12'sd0) +
((bits[39] ^ bits[52]) ? -12'sd1 : 12'sd0))) +
((((bits[40] ^ bits[41]) ? 12'sd1 : 12'sd0) +
((bits[40] ^ bits[51]) ? 12'sd1 : 12'sd0)) +
(((bits[40] ^ bits[52]) ? 12'sd1 : 12'sd0) +
((bits[40] ^ bits[53]) ? 12'sd1 : 12'sd0)))) +
(((((bits[41] ^ bits[42]) ? 12'sd1 : 12'sd0) +
((bits[41] ^ bits[52]) ? -12'sd1 : 12'sd0)) +
(((bits[41] ^ bits[53]) ? 12'sd1 : 12'sd0) +
((bits[41] ^ bits[54]) ? -12'sd1 : 12'sd0))) +
((((bits[42] ^ bits[43]) ? 12'sd1 : 12'sd0) +
((bits[42] ^ bits[53]) ? -12'sd1 : 12'sd0)) +
(((bits[42] ^ bits[54]) ? 12'sd1 : 12'sd0) +
((bits[42] ^ bits[55]) ? 12'sd1 : 12'sd0)))))) +
(((((((bits[43] ^ bits[44]) ? 12'sd1 : 12'sd0) +
((bits[43] ^ bits[54]) ? -12'sd1 : 12'sd0)) +
(((bits[43] ^ bits[55]) ? -12'sd1 : 12'sd0) +
((bits[43] ^ bits[56]) ? 12'sd1 : 12'sd0))) +
((((bits[44] ^ bits[45]) ? 12'sd1 : 12'sd0) +
((bits[44] ^ bits[55]) ? 12'sd1 : 12'sd0)) +
(((bits[44] ^ bits[56]) ? -12'sd1 : 12'sd0) +
((bits[44] ^ bits[57]) ? 12'sd1 : 12'sd0)))) +
(((((bits[45] ^ bits[46]) ? -12'sd1 : 12'sd0) +
((bits[45] ^ bits[56]) ? 12'sd1 : 12'sd0)) +
(((bits[45] ^ bits[57]) ? -12'sd1 : 12'sd0) +
((bits[45] ^ bits[58]) ? 12'sd1 : 12'sd0))) +
((((bits[46] ^ bits[47]) ? 12'sd1 : 12'sd0) +
((bits[46] ^ bits[57]) ? 12'sd1 : 12'sd0)) +
(((bits[46] ^ bits[58]) ? -12'sd1 : 12'sd0) +
((bits[46] ^ bits[59]) ? -12'sd1 : 12'sd0))))) +
((((((bits[47] ^ bits[58]) ? -12'sd1 : 12'sd0) +
((bits[47] ^ bits[59]) ? 12'sd1 : 12'sd0)) +
(((bits[48] ^ bits[49]) ? -12'sd1 : 12'sd0) +
((bits[48] ^ bits[60]) ? -12'sd1 : 12'sd0))) +
((((bits[48] ^ bits[61]) ? -12'sd1 : 12'sd0) +
((bits[49] ^ bits[50]) ? 12'sd1 : 12'sd0)) +
(((bits[49] ^ bits[60]) ? -12'sd1 : 12'sd0) +
((bits[49] ^ bits[61]) ? -12'sd1 : 12'sd0)))) +
(((((bits[49] ^ bits[62]) ? -12'sd1 : 12'sd0) +
((bits[50] ^ bits[51]) ? -12'sd1 : 12'sd0)) +
(((bits[50] ^ bits[61]) ? 12'sd1 : 12'sd0) +
((bits[50] ^ bits[62]) ? 12'sd1 : 12'sd0))) +
((((bits[50] ^ bits[63]) ? 12'sd1 : 12'sd0) +
((bits[51] ^ bits[52]) ? -12'sd1 : 12'sd0)) +
(((bits[51] ^ bits[62]) ? -12'sd1 : 12'sd0) +
(((bits[51] ^ bits[63]) ? 12'sd1 : 12'sd0) +
((bits[51] ^ bits[64]) ? -12'sd1 : 12'sd0)))))))) +
((((((((bits[52] ^ bits[53]) ? 12'sd1 : 12'sd0) +
((bits[52] ^ bits[63]) ? -12'sd1 : 12'sd0)) +
(((bits[52] ^ bits[64]) ? 12'sd1 : 12'sd0) +
((bits[52] ^ bits[65]) ? -12'sd1 : 12'sd0))) +
((((bits[53] ^ bits[54]) ? -12'sd1 : 12'sd0) +
((bits[53] ^ bits[64]) ? 12'sd1 : 12'sd0)) +
(((bits[53] ^ bits[65]) ? 12'sd1 : 12'sd0) +
((bits[53] ^ bits[66]) ? -12'sd1 : 12'sd0)))) +
(((((bits[54] ^ bits[55]) ? 12'sd1 : 12'sd0) +
((bits[54] ^ bits[65]) ? -12'sd1 : 12'sd0)) +
(((bits[54] ^ bits[66]) ? 12'sd1 : 12'sd0) +
((bits[54] ^ bits[67]) ? 12'sd1 : 12'sd0))) +
((((bits[55] ^ bits[56]) ? -12'sd1 : 12'sd0) +
((bits[55] ^ bits[66]) ? -12'sd1 : 12'sd0)) +
(((bits[55] ^ bits[67]) ? 12'sd1 : 12'sd0) +
((bits[55] ^ bits[68]) ? 12'sd1 : 12'sd0))))) +
((((((bits[56] ^ bits[57]) ? 12'sd1 : 12'sd0) +
((bits[56] ^ bits[67]) ? -12'sd1 : 12'sd0)) +
(((bits[56] ^ bits[68]) ? -12'sd1 : 12'sd0) +
((bits[56] ^ bits[69]) ? 12'sd1 : 12'sd0))) +
((((bits[57] ^ bits[58]) ? 12'sd1 : 12'sd0) +
((bits[57] ^ bits[68]) ? 12'sd1 : 12'sd0)) +
(((bits[57] ^ bits[69]) ? 12'sd1 : 12'sd0) +
((bits[57] ^ bits[70]) ? 12'sd1 : 12'sd0)))) +
(((((bits[58] ^ bits[59]) ? 12'sd1 : 12'sd0) +
((bits[58] ^ bits[69]) ? -12'sd1 : 12'sd0)) +
(((bits[58] ^ bits[70]) ? 12'sd1 : 12'sd0) +
((bits[58] ^ bits[71]) ? 12'sd1 : 12'sd0))) +
((((bits[59] ^ bits[70]) ? -12'sd1 : 12'sd0) +
((bits[59] ^ bits[71]) ? 12'sd1 : 12'sd0)) +
(((bits[60] ^ bits[61]) ? -12'sd1 : 12'sd0) +
(((bits[60] ^ bits[72]) ? 12'sd1 : 12'sd0) +
((bits[60] ^ bits[73]) ? -12'sd1 : 12'sd0))))))) +
(((((((bits[61] ^ bits[62]) ? 12'sd1 : 12'sd0) +
((bits[61] ^ bits[72]) ? -12'sd1 : 12'sd0)) +
(((bits[61] ^ bits[73]) ? -12'sd1 : 12'sd0) +
((bits[61] ^ bits[74]) ? -12'sd1 : 12'sd0))) +
((((bits[62] ^ bits[63]) ? -12'sd1 : 12'sd0) +
((bits[62] ^ bits[73]) ? 12'sd1 : 12'sd0)) +
(((bits[62] ^ bits[74]) ? 12'sd1 : 12'sd0) +
((bits[62] ^ bits[75]) ? -12'sd1 : 12'sd0)))) +
(((((bits[63] ^ bits[64]) ? 12'sd1 : 12'sd0) +
((bits[63] ^ bits[74]) ? 12'sd1 : 12'sd0)) +
(((bits[63] ^ bits[75]) ? -12'sd1 : 12'sd0) +
((bits[63] ^ bits[76]) ? -12'sd1 : 12'sd0))) +
((((bits[64] ^ bits[65]) ? 12'sd1 : 12'sd0) +
((bits[64] ^ bits[75]) ? 12'sd1 : 12'sd0)) +
(((bits[64] ^ bits[76]) ? -12'sd1 : 12'sd0) +
((bits[64] ^ bits[77]) ? -12'sd1 : 12'sd0))))) +
((((((bits[65] ^ bits[66]) ? -12'sd1 : 12'sd0) +
((bits[65] ^ bits[76]) ? -12'sd1 : 12'sd0)) +
(((bits[65] ^ bits[77]) ? -12'sd1 : 12'sd0) +
((bits[65] ^ bits[78]) ? -12'sd1 : 12'sd0))) +
((((bits[66] ^ bits[67]) ? -12'sd1 : 12'sd0) +
((bits[66] ^ bits[77]) ? -12'sd1 : 12'sd0)) +
(((bits[66] ^ bits[78]) ? 12'sd1 : 12'sd0) +
((bits[66] ^ bits[79]) ? -12'sd1 : 12'sd0)))) +
(((((bits[67] ^ bits[68]) ? 12'sd1 : 12'sd0) +
((bits[67] ^ bits[78]) ? 12'sd1 : 12'sd0)) +
(((bits[67] ^ bits[79]) ? 12'sd1 : 12'sd0) +
((bits[67] ^ bits[80]) ? -12'sd1 : 12'sd0))) +
((((bits[68] ^ bits[69]) ? -12'sd1 : 12'sd0) +
((bits[68] ^ bits[79]) ? -12'sd1 : 12'sd0)) +
(((bits[68] ^ bits[80]) ? -12'sd1 : 12'sd0) +
(((bits[68] ^ bits[81]) ? 12'sd1 : 12'sd0) +
((bits[69] ^ bits[70]) ? 12'sd1 : 12'sd0)))))))))) +
((((((((((bits[69] ^ bits[80]) ? -12'sd1 : 12'sd0) +
((bits[69] ^ bits[81]) ? 12'sd1 : 12'sd0)) +
(((bits[69] ^ bits[82]) ? -12'sd1 : 12'sd0) +
((bits[70] ^ bits[71]) ? 12'sd1 : 12'sd0))) +
((((bits[70] ^ bits[81]) ? -12'sd1 : 12'sd0) +
((bits[70] ^ bits[82]) ? 12'sd1 : 12'sd0)) +
(((bits[70] ^ bits[83]) ? 12'sd1 : 12'sd0) +
((bits[71] ^ bits[82]) ? -12'sd1 : 12'sd0)))) +
(((((bits[71] ^ bits[83]) ? -12'sd1 : 12'sd0) +
((bits[72] ^ bits[73]) ? 12'sd1 : 12'sd0)) +
(((bits[72] ^ bits[84]) ? -12'sd1 : 12'sd0) +
((bits[72] ^ bits[85]) ? -12'sd1 : 12'sd0))) +
((((bits[73] ^ bits[74]) ? -12'sd1 : 12'sd0) +
((bits[73] ^ bits[84]) ? -12'sd1 : 12'sd0)) +
(((bits[73] ^ bits[85]) ? -12'sd1 : 12'sd0) +
((bits[73] ^ bits[86]) ? -12'sd1 : 12'sd0))))) +
((((((bits[74] ^ bits[75]) ? 12'sd1 : 12'sd0) +
((bits[74] ^ bits[85]) ? -12'sd1 : 12'sd0)) +
(((bits[74] ^ bits[86]) ? 12'sd1 : 12'sd0) +
((bits[74] ^ bits[87]) ? -12'sd1 : 12'sd0))) +
((((bits[75] ^ bits[76]) ? 12'sd1 : 12'sd0) +
((bits[75] ^ bits[86]) ? 12'sd1 : 12'sd0)) +
(((bits[75] ^ bits[87]) ? -12'sd1 : 12'sd0) +
((bits[75] ^ bits[88]) ? 12'sd1 : 12'sd0)))) +
(((((bits[76] ^ bits[77]) ? 12'sd1 : 12'sd0) +
((bits[76] ^ bits[87]) ? -12'sd1 : 12'sd0)) +
(((bits[76] ^ bits[88]) ? 12'sd1 : 12'sd0) +
((bits[76] ^ bits[89]) ? -12'sd1 : 12'sd0))) +
((((bits[77] ^ bits[78]) ? -12'sd1 : 12'sd0) +
((bits[77] ^ bits[88]) ? -12'sd1 : 12'sd0)) +
(((bits[77] ^ bits[89]) ? 12'sd1 : 12'sd0) +
((bits[77] ^ bits[90]) ? 12'sd1 : 12'sd0)))))) +
(((((((bits[78] ^ bits[79]) ? -12'sd1 : 12'sd0) +
((bits[78] ^ bits[89]) ? 12'sd1 : 12'sd0)) +
(((bits[78] ^ bits[90]) ? 12'sd1 : 12'sd0) +
((bits[78] ^ bits[91]) ? 12'sd1 : 12'sd0))) +
((((bits[79] ^ bits[80]) ? -12'sd1 : 12'sd0) +
((bits[79] ^ bits[90]) ? -12'sd1 : 12'sd0)) +
(((bits[79] ^ bits[91]) ? 12'sd1 : 12'sd0) +
((bits[79] ^ bits[92]) ? -12'sd1 : 12'sd0)))) +
(((((bits[80] ^ bits[81]) ? 12'sd1 : 12'sd0) +
((bits[80] ^ bits[91]) ? -12'sd1 : 12'sd0)) +
(((bits[80] ^ bits[92]) ? -12'sd1 : 12'sd0) +
((bits[80] ^ bits[93]) ? 12'sd1 : 12'sd0))) +
((((bits[81] ^ bits[82]) ? -12'sd1 : 12'sd0) +
((bits[81] ^ bits[92]) ? -12'sd1 : 12'sd0)) +
(((bits[81] ^ bits[93]) ? 12'sd1 : 12'sd0) +
((bits[81] ^ bits[94]) ? -12'sd1 : 12'sd0))))) +
((((((bits[82] ^ bits[83]) ? 12'sd1 : 12'sd0) +
((bits[82] ^ bits[93]) ? 12'sd1 : 12'sd0)) +
(((bits[82] ^ bits[94]) ? -12'sd1 : 12'sd0) +
((bits[82] ^ bits[95]) ? -12'sd1 : 12'sd0))) +
((((bits[83] ^ bits[94]) ? 12'sd1 : 12'sd0) +
((bits[83] ^ bits[95]) ? 12'sd1 : 12'sd0)) +
(((bits[84] ^ bits[85]) ? 12'sd1 : 12'sd0) +
((bits[84] ^ bits[96]) ? -12'sd1 : 12'sd0)))) +
(((((bits[84] ^ bits[97]) ? -12'sd1 : 12'sd0) +
((bits[85] ^ bits[86]) ? -12'sd1 : 12'sd0)) +
(((bits[85] ^ bits[96]) ? 12'sd1 : 12'sd0) +
((bits[85] ^ bits[97]) ? -12'sd1 : 12'sd0))) +
((((bits[85] ^ bits[98]) ? 12'sd1 : 12'sd0) +
((bits[86] ^ bits[87]) ? -12'sd1 : 12'sd0)) +
(((bits[86] ^ bits[97]) ? 12'sd1 : 12'sd0) +
(((bits[86] ^ bits[98]) ? -12'sd1 : 12'sd0) +
((bits[86] ^ bits[99]) ? 12'sd1 : 12'sd0)))))))) +
((((((((bits[87] ^ bits[88]) ? -12'sd1 : 12'sd0) +
((bits[87] ^ bits[98]) ? -12'sd1 : 12'sd0)) +
(((bits[87] ^ bits[99]) ? 12'sd1 : 12'sd0) +
((bits[87] ^ bits[100]) ? -12'sd1 : 12'sd0))) +
((((bits[88] ^ bits[89]) ? 12'sd1 : 12'sd0) +
((bits[88] ^ bits[99]) ? -12'sd1 : 12'sd0)) +
(((bits[88] ^ bits[100]) ? -12'sd1 : 12'sd0) +
((bits[88] ^ bits[101]) ? -12'sd1 : 12'sd0)))) +
(((((bits[89] ^ bits[90]) ? 12'sd1 : 12'sd0) +
((bits[89] ^ bits[100]) ? -12'sd1 : 12'sd0)) +
(((bits[89] ^ bits[101]) ? 12'sd1 : 12'sd0) +
((bits[89] ^ bits[102]) ? 12'sd1 : 12'sd0))) +
((((bits[90] ^ bits[91]) ? 12'sd1 : 12'sd0) +
((bits[90] ^ bits[101]) ? -12'sd1 : 12'sd0)) +
(((bits[90] ^ bits[102]) ? 12'sd1 : 12'sd0) +
((bits[90] ^ bits[103]) ? 12'sd1 : 12'sd0))))) +
((((((bits[91] ^ bits[92]) ? 12'sd1 : 12'sd0) +
((bits[91] ^ bits[102]) ? -12'sd1 : 12'sd0)) +
(((bits[91] ^ bits[103]) ? -12'sd1 : 12'sd0) +
((bits[91] ^ bits[104]) ? 12'sd1 : 12'sd0))) +
((((bits[92] ^ bits[93]) ? 12'sd1 : 12'sd0) +
((bits[92] ^ bits[103]) ? -12'sd1 : 12'sd0)) +
(((bits[92] ^ bits[104]) ? 12'sd1 : 12'sd0) +
((bits[92] ^ bits[105]) ? -12'sd1 : 12'sd0)))) +
(((((bits[93] ^ bits[94]) ? -12'sd1 : 12'sd0) +
((bits[93] ^ bits[104]) ? -12'sd1 : 12'sd0)) +
(((bits[93] ^ bits[105]) ? 12'sd1 : 12'sd0) +
((bits[93] ^ bits[106]) ? -12'sd1 : 12'sd0))) +
((((bits[94] ^ bits[95]) ? -12'sd1 : 12'sd0) +
((bits[94] ^ bits[105]) ? -12'sd1 : 12'sd0)) +
(((bits[94] ^ bits[106]) ? 12'sd1 : 12'sd0) +
(((bits[94] ^ bits[107]) ? -12'sd1 : 12'sd0) +
((bits[95] ^ bits[106]) ? 12'sd1 : 12'sd0))))))) +
(((((((bits[95] ^ bits[107]) ? -12'sd1 : 12'sd0) +
((bits[96] ^ bits[97]) ? -12'sd1 : 12'sd0)) +
(((bits[96] ^ bits[108]) ? -12'sd1 : 12'sd0) +
((bits[96] ^ bits[109]) ? -12'sd1 : 12'sd0))) +
((((bits[97] ^ bits[98]) ? 12'sd1 : 12'sd0) +
((bits[97] ^ bits[108]) ? 12'sd1 : 12'sd0)) +
(((bits[97] ^ bits[109]) ? -12'sd1 : 12'sd0) +
((bits[97] ^ bits[110]) ? -12'sd1 : 12'sd0)))) +
(((((bits[98] ^ bits[99]) ? 12'sd1 : 12'sd0) +
((bits[98] ^ bits[109]) ? 12'sd1 : 12'sd0)) +
(((bits[98] ^ bits[110]) ? 12'sd1 : 12'sd0) +
((bits[98] ^ bits[111]) ? 12'sd1 : 12'sd0))) +
((((bits[99] ^ bits[100]) ? 12'sd1 : 12'sd0) +
((bits[99] ^ bits[110]) ? -12'sd1 : 12'sd0)) +
(((bits[99] ^ bits[111]) ? -12'sd1 : 12'sd0) +
((bits[99] ^ bits[112]) ? -12'sd1 : 12'sd0))))) +
((((((bits[100] ^ bits[101]) ? -12'sd1 : 12'sd0) +
((bits[100] ^ bits[111]) ? 12'sd1 : 12'sd0)) +
(((bits[100] ^ bits[112]) ? 12'sd1 : 12'sd0) +
((bits[100] ^ bits[113]) ? -12'sd1 : 12'sd0))) +
((((bits[101] ^ bits[102]) ? 12'sd1 : 12'sd0) +
((bits[101] ^ bits[112]) ? 12'sd1 : 12'sd0)) +
(((bits[101] ^ bits[113]) ? 12'sd1 : 12'sd0) +
((bits[101] ^ bits[114]) ? 12'sd1 : 12'sd0)))) +
(((((bits[102] ^ bits[103]) ? -12'sd1 : 12'sd0) +
((bits[102] ^ bits[113]) ? 12'sd1 : 12'sd0)) +
(((bits[102] ^ bits[114]) ? 12'sd1 : 12'sd0) +
((bits[102] ^ bits[115]) ? 12'sd1 : 12'sd0))) +
((((bits[103] ^ bits[104]) ? 12'sd1 : 12'sd0) +
((bits[103] ^ bits[114]) ? -12'sd1 : 12'sd0)) +
(((bits[103] ^ bits[115]) ? -12'sd1 : 12'sd0) +
(((bits[103] ^ bits[116]) ? -12'sd1 : 12'sd0) +
((bits[104] ^ bits[105]) ? -12'sd1 : 12'sd0))))))))) +
(((((((((bits[104] ^ bits[115]) ? -12'sd1 : 12'sd0) +
((bits[104] ^ bits[116]) ? -12'sd1 : 12'sd0)) +
(((bits[104] ^ bits[117]) ? 12'sd1 : 12'sd0) +
((bits[105] ^ bits[106]) ? -12'sd1 : 12'sd0))) +
((((bits[105] ^ bits[116]) ? 12'sd1 : 12'sd0) +
((bits[105] ^ bits[117]) ? 12'sd1 : 12'sd0)) +
(((bits[105] ^ bits[118]) ? 12'sd1 : 12'sd0) +
((bits[106] ^ bits[107]) ? -12'sd1 : 12'sd0)))) +
(((((bits[106] ^ bits[117]) ? -12'sd1 : 12'sd0) +
((bits[106] ^ bits[118]) ? 12'sd1 : 12'sd0)) +
(((bits[106] ^ bits[119]) ? -12'sd1 : 12'sd0) +
((bits[107] ^ bits[118]) ? 12'sd1 : 12'sd0))) +
((((bits[107] ^ bits[119]) ? 12'sd1 : 12'sd0) +
((bits[108] ^ bits[109]) ? -12'sd1 : 12'sd0)) +
(((bits[108] ^ bits[120]) ? 12'sd1 : 12'sd0) +
((bits[108] ^ bits[121]) ? 12'sd1 : 12'sd0))))) +
((((((bits[109] ^ bits[110]) ? 12'sd1 : 12'sd0) +
((bits[109] ^ bits[120]) ? 12'sd1 : 12'sd0)) +
(((bits[109] ^ bits[121]) ? 12'sd1 : 12'sd0) +
((bits[109] ^ bits[122]) ? 12'sd1 : 12'sd0))) +
((((bits[110] ^ bits[111]) ? 12'sd1 : 12'sd0) +
((bits[110] ^ bits[121]) ? 12'sd1 : 12'sd0)) +
(((bits[110] ^ bits[122]) ? -12'sd1 : 12'sd0) +
((bits[110] ^ bits[123]) ? -12'sd1 : 12'sd0)))) +
(((((bits[111] ^ bits[112]) ? -12'sd1 : 12'sd0) +
((bits[111] ^ bits[122]) ? 12'sd1 : 12'sd0)) +
(((bits[111] ^ bits[123]) ? 12'sd1 : 12'sd0) +
((bits[111] ^ bits[124]) ? 12'sd1 : 12'sd0))) +
((((bits[112] ^ bits[113]) ? -12'sd1 : 12'sd0) +
((bits[112] ^ bits[123]) ? 12'sd1 : 12'sd0)) +
(((bits[112] ^ bits[124]) ? 12'sd1 : 12'sd0) +
((bits[112] ^ bits[125]) ? 12'sd1 : 12'sd0)))))) +
(((((((bits[113] ^ bits[114]) ? -12'sd1 : 12'sd0) +
((bits[113] ^ bits[124]) ? -12'sd1 : 12'sd0)) +
(((bits[113] ^ bits[125]) ? 12'sd1 : 12'sd0) +
((bits[113] ^ bits[126]) ? -12'sd1 : 12'sd0))) +
((((bits[114] ^ bits[115]) ? 12'sd1 : 12'sd0) +
((bits[114] ^ bits[125]) ? 12'sd1 : 12'sd0)) +
(((bits[114] ^ bits[126]) ? -12'sd1 : 12'sd0) +
((bits[114] ^ bits[127]) ? -12'sd1 : 12'sd0)))) +
(((((bits[115] ^ bits[116]) ? 12'sd1 : 12'sd0) +
((bits[115] ^ bits[126]) ? -12'sd1 : 12'sd0)) +
(((bits[115] ^ bits[127]) ? 12'sd1 : 12'sd0) +
((bits[115] ^ bits[128]) ? -12'sd1 : 12'sd0))) +
((((bits[116] ^ bits[117]) ? 12'sd1 : 12'sd0) +
((bits[116] ^ bits[127]) ? 12'sd1 : 12'sd0)) +
(((bits[116] ^ bits[128]) ? -12'sd1 : 12'sd0) +
((bits[116] ^ bits[129]) ? -12'sd1 : 12'sd0))))) +
((((((bits[117] ^ bits[118]) ? 12'sd1 : 12'sd0) +
((bits[117] ^ bits[128]) ? 12'sd1 : 12'sd0)) +
(((bits[117] ^ bits[129]) ? 12'sd1 : 12'sd0) +
((bits[117] ^ bits[130]) ? -12'sd1 : 12'sd0))) +
((((bits[118] ^ bits[119]) ? -12'sd1 : 12'sd0) +
((bits[118] ^ bits[129]) ? -12'sd1 : 12'sd0)) +
(((bits[118] ^ bits[130]) ? -12'sd1 : 12'sd0) +
((bits[118] ^ bits[131]) ? 12'sd1 : 12'sd0)))) +
(((((bits[119] ^ bits[130]) ? 12'sd1 : 12'sd0) +
((bits[119] ^ bits[131]) ? -12'sd1 : 12'sd0)) +
(((bits[120] ^ bits[121]) ? -12'sd1 : 12'sd0) +
((bits[120] ^ bits[132]) ? 12'sd1 : 12'sd0))) +
((((bits[120] ^ bits[133]) ? 12'sd1 : 12'sd0) +
((bits[121] ^ bits[122]) ? -12'sd1 : 12'sd0)) +
(((bits[121] ^ bits[132]) ? -12'sd1 : 12'sd0) +
(((bits[121] ^ bits[133]) ? -12'sd1 : 12'sd0) +
((bits[121] ^ bits[134]) ? 12'sd1 : 12'sd0)))))))) +
((((((((bits[122] ^ bits[123]) ? 12'sd1 : 12'sd0) +
((bits[122] ^ bits[133]) ? -12'sd1 : 12'sd0)) +
(((bits[122] ^ bits[134]) ? -12'sd1 : 12'sd0) +
((bits[122] ^ bits[135]) ? 12'sd1 : 12'sd0))) +
((((bits[123] ^ bits[124]) ? -12'sd1 : 12'sd0) +
((bits[123] ^ bits[134]) ? -12'sd1 : 12'sd0)) +
(((bits[123] ^ bits[135]) ? 12'sd1 : 12'sd0) +
((bits[123] ^ bits[136]) ? 12'sd1 : 12'sd0)))) +
(((((bits[124] ^ bits[125]) ? -12'sd1 : 12'sd0) +
((bits[124] ^ bits[135]) ? 12'sd1 : 12'sd0)) +
(((bits[124] ^ bits[136]) ? 12'sd1 : 12'sd0) +
((bits[124] ^ bits[137]) ? 12'sd1 : 12'sd0))) +
((((bits[125] ^ bits[126]) ? -12'sd1 : 12'sd0) +
((bits[125] ^ bits[136]) ? -12'sd1 : 12'sd0)) +
(((bits[125] ^ bits[137]) ? -12'sd1 : 12'sd0) +
((bits[125] ^ bits[138]) ? -12'sd1 : 12'sd0))))) +
((((((bits[126] ^ bits[127]) ? 12'sd1 : 12'sd0) +
((bits[126] ^ bits[137]) ? -12'sd1 : 12'sd0)) +
(((bits[126] ^ bits[138]) ? 12'sd1 : 12'sd0) +
((bits[126] ^ bits[139]) ? 12'sd1 : 12'sd0))) +
((((bits[127] ^ bits[128]) ? -12'sd1 : 12'sd0) +
((bits[127] ^ bits[138]) ? 12'sd1 : 12'sd0)) +
(((bits[127] ^ bits[139]) ? 12'sd1 : 12'sd0) +
((bits[127] ^ bits[140]) ? -12'sd1 : 12'sd0)))) +
(((((bits[128] ^ bits[129]) ? 12'sd1 : 12'sd0) +
((bits[128] ^ bits[139]) ? -12'sd1 : 12'sd0)) +
(((bits[128] ^ bits[140]) ? -12'sd1 : 12'sd0) +
((bits[128] ^ bits[141]) ? -12'sd1 : 12'sd0))) +
((((bits[129] ^ bits[130]) ? -12'sd1 : 12'sd0) +
((bits[129] ^ bits[140]) ? 12'sd1 : 12'sd0)) +
(((bits[129] ^ bits[141]) ? 12'sd1 : 12'sd0) +
(((bits[129] ^ bits[142]) ? -12'sd1 : 12'sd0) +
((bits[130] ^ bits[131]) ? -12'sd1 : 12'sd0))))))) +
(((((((bits[130] ^ bits[141]) ? 12'sd1 : 12'sd0) +
((bits[130] ^ bits[142]) ? 12'sd1 : 12'sd0)) +
(((bits[130] ^ bits[143]) ? -12'sd1 : 12'sd0) +
((bits[131] ^ bits[142]) ? 12'sd1 : 12'sd0))) +
((((bits[131] ^ bits[143]) ? 12'sd1 : 12'sd0) +
((bits[132] ^ bits[133]) ? -12'sd1 : 12'sd0)) +
(((bits[132] ^ bits[144]) ? -12'sd1 : 12'sd0) +
((bits[132] ^ bits[145]) ? -12'sd1 : 12'sd0)))) +
(((((bits[133] ^ bits[134]) ? 12'sd1 : 12'sd0) +
((bits[133] ^ bits[144]) ? 12'sd1 : 12'sd0)) +
(((bits[133] ^ bits[145]) ? -12'sd1 : 12'sd0) +
((bits[133] ^ bits[146]) ? -12'sd1 : 12'sd0))) +
((((bits[134] ^ bits[135]) ? -12'sd1 : 12'sd0) +
((bits[134] ^ bits[145]) ? 12'sd1 : 12'sd0)) +
(((bits[134] ^ bits[146]) ? 12'sd1 : 12'sd0) +
((bits[134] ^ bits[147]) ? -12'sd1 : 12'sd0))))) +
((((((bits[135] ^ bits[136]) ? -12'sd1 : 12'sd0) +
((bits[135] ^ bits[146]) ? 12'sd1 : 12'sd0)) +
(((bits[135] ^ bits[147]) ? -12'sd1 : 12'sd0) +
((bits[135] ^ bits[148]) ? 12'sd1 : 12'sd0))) +
((((bits[136] ^ bits[137]) ? 12'sd1 : 12'sd0) +
((bits[136] ^ bits[147]) ? 12'sd1 : 12'sd0)) +
(((bits[136] ^ bits[148]) ? -12'sd1 : 12'sd0) +
((bits[136] ^ bits[149]) ? 12'sd1 : 12'sd0)))) +
(((((bits[137] ^ bits[138]) ? 12'sd1 : 12'sd0) +
((bits[137] ^ bits[148]) ? -12'sd1 : 12'sd0)) +
(((bits[137] ^ bits[149]) ? 12'sd1 : 12'sd0) +
((bits[137] ^ bits[150]) ? -12'sd1 : 12'sd0))) +
((((bits[138] ^ bits[139]) ? 12'sd1 : 12'sd0) +
((bits[138] ^ bits[149]) ? 12'sd1 : 12'sd0)) +
(((bits[138] ^ bits[150]) ? 12'sd1 : 12'sd0) +
(((bits[138] ^ bits[151]) ? -12'sd1 : 12'sd0) +
((bits[139] ^ bits[140]) ? -12'sd1 : 12'sd0))))))))))) +
(((((((((((bits[139] ^ bits[150]) ? -12'sd1 : 12'sd0) +
((bits[139] ^ bits[151]) ? 12'sd1 : 12'sd0)) +
(((bits[139] ^ bits[152]) ? 12'sd1 : 12'sd0) +
((bits[140] ^ bits[141]) ? 12'sd1 : 12'sd0))) +
((((bits[140] ^ bits[151]) ? 12'sd1 : 12'sd0) +
((bits[140] ^ bits[152]) ? -12'sd1 : 12'sd0)) +
(((bits[140] ^ bits[153]) ? 12'sd1 : 12'sd0) +
((bits[141] ^ bits[142]) ? 12'sd1 : 12'sd0)))) +
(((((bits[141] ^ bits[152]) ? -12'sd1 : 12'sd0) +
((bits[141] ^ bits[153]) ? 12'sd1 : 12'sd0)) +
(((bits[141] ^ bits[154]) ? -12'sd1 : 12'sd0) +
((bits[142] ^ bits[143]) ? 12'sd1 : 12'sd0))) +
((((bits[142] ^ bits[153]) ? -12'sd1 : 12'sd0) +
((bits[142] ^ bits[154]) ? 12'sd1 : 12'sd0)) +
(((bits[142] ^ bits[155]) ? 12'sd1 : 12'sd0) +
((bits[143] ^ bits[154]) ? -12'sd1 : 12'sd0))))) +
((((((bits[143] ^ bits[155]) ? 12'sd1 : 12'sd0) +
((bits[144] ^ bits[145]) ? 12'sd1 : 12'sd0)) +
(((bits[144] ^ bits[156]) ? -12'sd1 : 12'sd0) +
((bits[144] ^ bits[157]) ? -12'sd1 : 12'sd0))) +
((((bits[145] ^ bits[146]) ? 12'sd1 : 12'sd0) +
((bits[145] ^ bits[156]) ? 12'sd1 : 12'sd0)) +
(((bits[145] ^ bits[157]) ? -12'sd1 : 12'sd0) +
((bits[145] ^ bits[158]) ? -12'sd1 : 12'sd0)))) +
(((((bits[146] ^ bits[147]) ? -12'sd1 : 12'sd0) +
((bits[146] ^ bits[157]) ? -12'sd1 : 12'sd0)) +
(((bits[146] ^ bits[158]) ? 12'sd1 : 12'sd0) +
((bits[146] ^ bits[159]) ? -12'sd1 : 12'sd0))) +
((((bits[147] ^ bits[148]) ? 12'sd1 : 12'sd0) +
((bits[147] ^ bits[158]) ? 12'sd1 : 12'sd0)) +
(((bits[147] ^ bits[159]) ? 12'sd1 : 12'sd0) +
((bits[147] ^ bits[160]) ? -12'sd1 : 12'sd0)))))) +
(((((((bits[148] ^ bits[149]) ? -12'sd1 : 12'sd0) +
((bits[148] ^ bits[159]) ? 12'sd1 : 12'sd0)) +
(((bits[148] ^ bits[160]) ? -12'sd1 : 12'sd0) +
((bits[148] ^ bits[161]) ? -12'sd1 : 12'sd0))) +
((((bits[149] ^ bits[150]) ? -12'sd1 : 12'sd0) +
((bits[149] ^ bits[160]) ? -12'sd1 : 12'sd0)) +
(((bits[149] ^ bits[161]) ? -12'sd1 : 12'sd0) +
((bits[149] ^ bits[162]) ? -12'sd1 : 12'sd0)))) +
(((((bits[150] ^ bits[151]) ? -12'sd1 : 12'sd0) +
((bits[150] ^ bits[161]) ? 12'sd1 : 12'sd0)) +
(((bits[150] ^ bits[162]) ? 12'sd1 : 12'sd0) +
((bits[150] ^ bits[163]) ? 12'sd1 : 12'sd0))) +
((((bits[151] ^ bits[152]) ? -12'sd1 : 12'sd0) +
((bits[151] ^ bits[162]) ? -12'sd1 : 12'sd0)) +
(((bits[151] ^ bits[163]) ? 12'sd1 : 12'sd0) +
((bits[151] ^ bits[164]) ? -12'sd1 : 12'sd0))))) +
((((((bits[152] ^ bits[153]) ? 12'sd1 : 12'sd0) +
((bits[152] ^ bits[163]) ? -12'sd1 : 12'sd0)) +
(((bits[152] ^ bits[164]) ? -12'sd1 : 12'sd0) +
((bits[152] ^ bits[165]) ? -12'sd1 : 12'sd0))) +
((((bits[153] ^ bits[154]) ? 12'sd1 : 12'sd0) +
((bits[153] ^ bits[164]) ? -12'sd1 : 12'sd0)) +
(((bits[153] ^ bits[165]) ? 12'sd1 : 12'sd0) +
((bits[153] ^ bits[166]) ? 12'sd1 : 12'sd0)))) +
(((((bits[154] ^ bits[155]) ? 12'sd1 : 12'sd0) +
((bits[154] ^ bits[165]) ? 12'sd1 : 12'sd0)) +
(((bits[154] ^ bits[166]) ? -12'sd1 : 12'sd0) +
((bits[154] ^ bits[167]) ? -12'sd1 : 12'sd0))) +
((((bits[155] ^ bits[166]) ? 12'sd1 : 12'sd0) +
((bits[155] ^ bits[167]) ? -12'sd1 : 12'sd0)) +
(((bits[156] ^ bits[157]) ? 12'sd1 : 12'sd0) +
(((bits[156] ^ bits[168]) ? 12'sd1 : 12'sd0) +
((bits[156] ^ bits[169]) ? -12'sd1 : 12'sd0)))))))) +
((((((((bits[157] ^ bits[158]) ? 12'sd1 : 12'sd0) +
((bits[157] ^ bits[168]) ? -12'sd1 : 12'sd0)) +
(((bits[157] ^ bits[169]) ? 12'sd1 : 12'sd0) +
((bits[157] ^ bits[170]) ? -12'sd1 : 12'sd0))) +
((((bits[158] ^ bits[159]) ? 12'sd1 : 12'sd0) +
((bits[158] ^ bits[169]) ? -12'sd1 : 12'sd0)) +
(((bits[158] ^ bits[170]) ? 12'sd1 : 12'sd0) +
((bits[158] ^ bits[171]) ? -12'sd1 : 12'sd0)))) +
(((((bits[159] ^ bits[160]) ? -12'sd1 : 12'sd0) +
((bits[159] ^ bits[170]) ? -12'sd1 : 12'sd0)) +
(((bits[159] ^ bits[171]) ? 12'sd1 : 12'sd0) +
((bits[159] ^ bits[172]) ? -12'sd1 : 12'sd0))) +
((((bits[160] ^ bits[161]) ? -12'sd1 : 12'sd0) +
((bits[160] ^ bits[171]) ? 12'sd1 : 12'sd0)) +
(((bits[160] ^ bits[172]) ? -12'sd1 : 12'sd0) +
((bits[160] ^ bits[173]) ? -12'sd1 : 12'sd0))))) +
((((((bits[161] ^ bits[162]) ? -12'sd1 : 12'sd0) +
((bits[161] ^ bits[172]) ? 12'sd1 : 12'sd0)) +
(((bits[161] ^ bits[173]) ? 12'sd1 : 12'sd0) +
((bits[161] ^ bits[174]) ? 12'sd1 : 12'sd0))) +
((((bits[162] ^ bits[163]) ? 12'sd1 : 12'sd0) +
((bits[162] ^ bits[173]) ? 12'sd1 : 12'sd0)) +
(((bits[162] ^ bits[174]) ? 12'sd1 : 12'sd0) +
((bits[162] ^ bits[175]) ? -12'sd1 : 12'sd0)))) +
(((((bits[163] ^ bits[164]) ? -12'sd1 : 12'sd0) +
((bits[163] ^ bits[174]) ? -12'sd1 : 12'sd0)) +
(((bits[163] ^ bits[175]) ? 12'sd1 : 12'sd0) +
((bits[163] ^ bits[176]) ? 12'sd1 : 12'sd0))) +
((((bits[164] ^ bits[165]) ? 12'sd1 : 12'sd0) +
((bits[164] ^ bits[175]) ? -12'sd1 : 12'sd0)) +
(((bits[164] ^ bits[176]) ? -12'sd1 : 12'sd0) +
((bits[164] ^ bits[177]) ? -12'sd1 : 12'sd0)))))) +
(((((((bits[165] ^ bits[166]) ? -12'sd1 : 12'sd0) +
((bits[165] ^ bits[176]) ? 12'sd1 : 12'sd0)) +
(((bits[165] ^ bits[177]) ? 12'sd1 : 12'sd0) +
((bits[165] ^ bits[178]) ? -12'sd1 : 12'sd0))) +
((((bits[166] ^ bits[167]) ? 12'sd1 : 12'sd0) +
((bits[166] ^ bits[177]) ? -12'sd1 : 12'sd0)) +
(((bits[166] ^ bits[178]) ? -12'sd1 : 12'sd0) +
((bits[166] ^ bits[179]) ? -12'sd1 : 12'sd0)))) +
(((((bits[167] ^ bits[178]) ? 12'sd1 : 12'sd0) +
((bits[167] ^ bits[179]) ? 12'sd1 : 12'sd0)) +
(((bits[168] ^ bits[169]) ? 12'sd1 : 12'sd0) +
((bits[168] ^ bits[180]) ? -12'sd1 : 12'sd0))) +
((((bits[168] ^ bits[181]) ? -12'sd1 : 12'sd0) +
((bits[169] ^ bits[170]) ? -12'sd1 : 12'sd0)) +
(((bits[169] ^ bits[180]) ? -12'sd1 : 12'sd0) +
((bits[169] ^ bits[181]) ? -12'sd1 : 12'sd0))))) +
((((((bits[169] ^ bits[182]) ? -12'sd1 : 12'sd0) +
((bits[170] ^ bits[171]) ? -12'sd1 : 12'sd0)) +
(((bits[170] ^ bits[181]) ? -12'sd1 : 12'sd0) +
((bits[170] ^ bits[182]) ? 12'sd1 : 12'sd0))) +
((((bits[170] ^ bits[183]) ? -12'sd1 : 12'sd0) +
((bits[171] ^ bits[172]) ? 12'sd1 : 12'sd0)) +
(((bits[171] ^ bits[182]) ? -12'sd1 : 12'sd0) +
((bits[171] ^ bits[183]) ? 12'sd1 : 12'sd0)))) +
(((((bits[171] ^ bits[184]) ? -12'sd1 : 12'sd0) +
((bits[172] ^ bits[173]) ? -12'sd1 : 12'sd0)) +
(((bits[172] ^ bits[183]) ? -12'sd1 : 12'sd0) +
((bits[172] ^ bits[184]) ? 12'sd1 : 12'sd0))) +
((((bits[172] ^ bits[185]) ? -12'sd1 : 12'sd0) +
((bits[173] ^ bits[174]) ? -12'sd1 : 12'sd0)) +
(((bits[173] ^ bits[184]) ? -12'sd1 : 12'sd0) +
(((bits[173] ^ bits[185]) ? -12'sd1 : 12'sd0) +
((bits[173] ^ bits[186]) ? -12'sd1 : 12'sd0))))))))) +
(((((((((bits[174] ^ bits[175]) ? -12'sd1 : 12'sd0) +
((bits[174] ^ bits[185]) ? 12'sd1 : 12'sd0)) +
(((bits[174] ^ bits[186]) ? 12'sd1 : 12'sd0) +
((bits[174] ^ bits[187]) ? -12'sd1 : 12'sd0))) +
((((bits[175] ^ bits[176]) ? 12'sd1 : 12'sd0) +
((bits[175] ^ bits[186]) ? -12'sd1 : 12'sd0)) +
(((bits[175] ^ bits[187]) ? 12'sd1 : 12'sd0) +
((bits[175] ^ bits[188]) ? 12'sd1 : 12'sd0)))) +
(((((bits[176] ^ bits[177]) ? -12'sd1 : 12'sd0) +
((bits[176] ^ bits[187]) ? 12'sd1 : 12'sd0)) +
(((bits[176] ^ bits[188]) ? -12'sd1 : 12'sd0) +
((bits[176] ^ bits[189]) ? 12'sd1 : 12'sd0))) +
((((bits[177] ^ bits[178]) ? -12'sd1 : 12'sd0) +
((bits[177] ^ bits[188]) ? -12'sd1 : 12'sd0)) +
(((bits[177] ^ bits[189]) ? 12'sd1 : 12'sd0) +
((bits[177] ^ bits[190]) ? 12'sd1 : 12'sd0))))) +
((((((bits[178] ^ bits[179]) ? -12'sd1 : 12'sd0) +
((bits[178] ^ bits[189]) ? -12'sd1 : 12'sd0)) +
(((bits[178] ^ bits[190]) ? 12'sd1 : 12'sd0) +
((bits[178] ^ bits[191]) ? 12'sd1 : 12'sd0))) +
((((bits[179] ^ bits[190]) ? -12'sd1 : 12'sd0) +
((bits[179] ^ bits[191]) ? 12'sd1 : 12'sd0)) +
(((bits[180] ^ bits[181]) ? 12'sd1 : 12'sd0) +
((bits[180] ^ bits[192]) ? 12'sd1 : 12'sd0)))) +
(((((bits[180] ^ bits[193]) ? 12'sd1 : 12'sd0) +
((bits[181] ^ bits[182]) ? -12'sd1 : 12'sd0)) +
(((bits[181] ^ bits[192]) ? -12'sd1 : 12'sd0) +
((bits[181] ^ bits[193]) ? -12'sd1 : 12'sd0))) +
((((bits[181] ^ bits[194]) ? -12'sd1 : 12'sd0) +
((bits[182] ^ bits[183]) ? -12'sd1 : 12'sd0)) +
(((bits[182] ^ bits[193]) ? -12'sd1 : 12'sd0) +
((bits[182] ^ bits[194]) ? -12'sd1 : 12'sd0)))))) +
(((((((bits[182] ^ bits[195]) ? -12'sd1 : 12'sd0) +
((bits[183] ^ bits[184]) ? 12'sd1 : 12'sd0)) +
(((bits[183] ^ bits[194]) ? 12'sd1 : 12'sd0) +
((bits[183] ^ bits[195]) ? 12'sd1 : 12'sd0))) +
((((bits[183] ^ bits[196]) ? 12'sd1 : 12'sd0) +
((bits[184] ^ bits[185]) ? 12'sd1 : 12'sd0)) +
(((bits[184] ^ bits[195]) ? -12'sd1 : 12'sd0) +
((bits[184] ^ bits[196]) ? -12'sd1 : 12'sd0)))) +
(((((bits[184] ^ bits[197]) ? -12'sd1 : 12'sd0) +
((bits[185] ^ bits[186]) ? 12'sd1 : 12'sd0)) +
(((bits[185] ^ bits[196]) ? -12'sd1 : 12'sd0) +
((bits[185] ^ bits[197]) ? 12'sd1 : 12'sd0))) +
((((bits[185] ^ bits[198]) ? -12'sd1 : 12'sd0) +
((bits[186] ^ bits[187]) ? 12'sd1 : 12'sd0)) +
(((bits[186] ^ bits[197]) ? 12'sd1 : 12'sd0) +
((bits[186] ^ bits[198]) ? -12'sd1 : 12'sd0))))) +
((((((bits[186] ^ bits[199]) ? 12'sd1 : 12'sd0) +
((bits[187] ^ bits[188]) ? -12'sd1 : 12'sd0)) +
(((bits[187] ^ bits[198]) ? -12'sd1 : 12'sd0) +
((bits[187] ^ bits[199]) ? 12'sd1 : 12'sd0))) +
((((bits[187] ^ bits[200]) ? -12'sd1 : 12'sd0) +
((bits[188] ^ bits[189]) ? 12'sd1 : 12'sd0)) +
(((bits[188] ^ bits[199]) ? 12'sd1 : 12'sd0) +
((bits[188] ^ bits[200]) ? -12'sd1 : 12'sd0)))) +
(((((bits[188] ^ bits[201]) ? 12'sd1 : 12'sd0) +
((bits[189] ^ bits[190]) ? 12'sd1 : 12'sd0)) +
(((bits[189] ^ bits[200]) ? -12'sd1 : 12'sd0) +
((bits[189] ^ bits[201]) ? 12'sd1 : 12'sd0))) +
((((bits[189] ^ bits[202]) ? 12'sd1 : 12'sd0) +
((bits[190] ^ bits[191]) ? 12'sd1 : 12'sd0)) +
(((bits[190] ^ bits[201]) ? 12'sd1 : 12'sd0) +
(((bits[190] ^ bits[202]) ? 12'sd1 : 12'sd0) +
((bits[190] ^ bits[203]) ? 12'sd1 : 12'sd0)))))))) +
((((((((bits[191] ^ bits[202]) ? 12'sd1 : 12'sd0) +
((bits[191] ^ bits[203]) ? -12'sd1 : 12'sd0)) +
(((bits[192] ^ bits[193]) ? -12'sd1 : 12'sd0) +
((bits[192] ^ bits[204]) ? 12'sd1 : 12'sd0))) +
((((bits[192] ^ bits[205]) ? 12'sd1 : 12'sd0) +
((bits[193] ^ bits[194]) ? -12'sd1 : 12'sd0)) +
(((bits[193] ^ bits[204]) ? 12'sd1 : 12'sd0) +
((bits[193] ^ bits[205]) ? -12'sd1 : 12'sd0)))) +
(((((bits[193] ^ bits[206]) ? -12'sd1 : 12'sd0) +
((bits[194] ^ bits[195]) ? -12'sd1 : 12'sd0)) +
(((bits[194] ^ bits[205]) ? 12'sd1 : 12'sd0) +
((bits[194] ^ bits[206]) ? -12'sd1 : 12'sd0))) +
((((bits[194] ^ bits[207]) ? -12'sd1 : 12'sd0) +
((bits[195] ^ bits[196]) ? 12'sd1 : 12'sd0)) +
(((bits[195] ^ bits[206]) ? 12'sd1 : 12'sd0) +
((bits[195] ^ bits[207]) ? 12'sd1 : 12'sd0))))) +
((((((bits[195] ^ bits[208]) ? -12'sd1 : 12'sd0) +
((bits[196] ^ bits[197]) ? 12'sd1 : 12'sd0)) +
(((bits[196] ^ bits[207]) ? 12'sd1 : 12'sd0) +
((bits[196] ^ bits[208]) ? -12'sd1 : 12'sd0))) +
((((bits[196] ^ bits[209]) ? -12'sd1 : 12'sd0) +
((bits[197] ^ bits[198]) ? -12'sd1 : 12'sd0)) +
(((bits[197] ^ bits[208]) ? 12'sd1 : 12'sd0) +
((bits[197] ^ bits[209]) ? 12'sd1 : 12'sd0)))) +
(((((bits[197] ^ bits[210]) ? 12'sd1 : 12'sd0) +
((bits[198] ^ bits[199]) ? -12'sd1 : 12'sd0)) +
(((bits[198] ^ bits[209]) ? -12'sd1 : 12'sd0) +
((bits[198] ^ bits[210]) ? -12'sd1 : 12'sd0))) +
((((bits[198] ^ bits[211]) ? 12'sd1 : 12'sd0) +
((bits[199] ^ bits[200]) ? -12'sd1 : 12'sd0)) +
(((bits[199] ^ bits[210]) ? -12'sd1 : 12'sd0) +
(((bits[199] ^ bits[211]) ? 12'sd1 : 12'sd0) +
((bits[199] ^ bits[212]) ? -12'sd1 : 12'sd0))))))) +
(((((((bits[200] ^ bits[201]) ? 12'sd1 : 12'sd0) +
((bits[200] ^ bits[211]) ? 12'sd1 : 12'sd0)) +
(((bits[200] ^ bits[212]) ? 12'sd1 : 12'sd0) +
((bits[200] ^ bits[213]) ? 12'sd1 : 12'sd0))) +
((((bits[201] ^ bits[202]) ? 12'sd1 : 12'sd0) +
((bits[201] ^ bits[212]) ? -12'sd1 : 12'sd0)) +
(((bits[201] ^ bits[213]) ? 12'sd1 : 12'sd0) +
((bits[201] ^ bits[214]) ? -12'sd1 : 12'sd0)))) +
(((((bits[202] ^ bits[203]) ? 12'sd1 : 12'sd0) +
((bits[202] ^ bits[213]) ? 12'sd1 : 12'sd0)) +
(((bits[202] ^ bits[214]) ? 12'sd1 : 12'sd0) +
((bits[202] ^ bits[215]) ? -12'sd1 : 12'sd0))) +
((((bits[203] ^ bits[214]) ? 12'sd1 : 12'sd0) +
((bits[203] ^ bits[215]) ? -12'sd1 : 12'sd0)) +
(((bits[204] ^ bits[205]) ? -12'sd1 : 12'sd0) +
((bits[204] ^ bits[216]) ? -12'sd1 : 12'sd0))))) +
((((((bits[204] ^ bits[217]) ? -12'sd1 : 12'sd0) +
((bits[205] ^ bits[206]) ? -12'sd1 : 12'sd0)) +
(((bits[205] ^ bits[216]) ? 12'sd1 : 12'sd0) +
((bits[205] ^ bits[217]) ? 12'sd1 : 12'sd0))) +
((((bits[205] ^ bits[218]) ? 12'sd1 : 12'sd0) +
((bits[206] ^ bits[207]) ? -12'sd1 : 12'sd0)) +
(((bits[206] ^ bits[217]) ? 12'sd1 : 12'sd0) +
((bits[206] ^ bits[218]) ? -12'sd1 : 12'sd0)))) +
(((((bits[206] ^ bits[219]) ? -12'sd1 : 12'sd0) +
((bits[207] ^ bits[208]) ? 12'sd1 : 12'sd0)) +
(((bits[207] ^ bits[218]) ? -12'sd1 : 12'sd0) +
((bits[207] ^ bits[219]) ? 12'sd1 : 12'sd0))) +
((((bits[207] ^ bits[220]) ? -12'sd1 : 12'sd0) +
((bits[208] ^ bits[209]) ? -12'sd1 : 12'sd0)) +
(((bits[208] ^ bits[219]) ? -12'sd1 : 12'sd0) +
(((bits[208] ^ bits[220]) ? 12'sd1 : 12'sd0) +
((bits[208] ^ bits[221]) ? -12'sd1 : 12'sd0)))))))))) +
((((((((((bits[209] ^ bits[210]) ? 12'sd1 : 12'sd0) +
((bits[209] ^ bits[220]) ? -12'sd1 : 12'sd0)) +
(((bits[209] ^ bits[221]) ? 12'sd1 : 12'sd0) +
((bits[209] ^ bits[222]) ? 12'sd1 : 12'sd0))) +
((((bits[210] ^ bits[211]) ? -12'sd1 : 12'sd0) +
((bits[210] ^ bits[221]) ? -12'sd1 : 12'sd0)) +
(((bits[210] ^ bits[222]) ? -12'sd1 : 12'sd0) +
((bits[210] ^ bits[223]) ? -12'sd1 : 12'sd0)))) +
(((((bits[211] ^ bits[212]) ? -12'sd1 : 12'sd0) +
((bits[211] ^ bits[222]) ? 12'sd1 : 12'sd0)) +
(((bits[211] ^ bits[223]) ? 12'sd1 : 12'sd0) +
((bits[211] ^ bits[224]) ? 12'sd1 : 12'sd0))) +
((((bits[212] ^ bits[213]) ? 12'sd1 : 12'sd0) +
((bits[212] ^ bits[223]) ? -12'sd1 : 12'sd0)) +
(((bits[212] ^ bits[224]) ? 12'sd1 : 12'sd0) +
((bits[212] ^ bits[225]) ? 12'sd1 : 12'sd0))))) +
((((((bits[213] ^ bits[214]) ? -12'sd1 : 12'sd0) +
((bits[213] ^ bits[224]) ? -12'sd1 : 12'sd0)) +
(((bits[213] ^ bits[225]) ? -12'sd1 : 12'sd0) +
((bits[213] ^ bits[226]) ? 12'sd1 : 12'sd0))) +
((((bits[214] ^ bits[215]) ? -12'sd1 : 12'sd0) +
((bits[214] ^ bits[225]) ? 12'sd1 : 12'sd0)) +
(((bits[214] ^ bits[226]) ? -12'sd1 : 12'sd0) +
((bits[214] ^ bits[227]) ? 12'sd1 : 12'sd0)))) +
(((((bits[215] ^ bits[226]) ? 12'sd1 : 12'sd0) +
((bits[215] ^ bits[227]) ? 12'sd1 : 12'sd0)) +
(((bits[216] ^ bits[217]) ? 12'sd1 : 12'sd0) +
((bits[216] ^ bits[228]) ? 12'sd1 : 12'sd0))) +
((((bits[216] ^ bits[229]) ? -12'sd1 : 12'sd0) +
((bits[217] ^ bits[218]) ? 12'sd1 : 12'sd0)) +
(((bits[217] ^ bits[228]) ? 12'sd1 : 12'sd0) +
((bits[217] ^ bits[229]) ? 12'sd1 : 12'sd0)))))) +
(((((((bits[217] ^ bits[230]) ? -12'sd1 : 12'sd0) +
((bits[218] ^ bits[219]) ? -12'sd1 : 12'sd0)) +
(((bits[218] ^ bits[229]) ? -12'sd1 : 12'sd0) +
((bits[218] ^ bits[230]) ? -12'sd1 : 12'sd0))) +
((((bits[218] ^ bits[231]) ? -12'sd1 : 12'sd0) +
((bits[219] ^ bits[220]) ? -12'sd1 : 12'sd0)) +
(((bits[219] ^ bits[230]) ? -12'sd1 : 12'sd0) +
((bits[219] ^ bits[231]) ? 12'sd1 : 12'sd0)))) +
(((((bits[219] ^ bits[232]) ? -12'sd1 : 12'sd0) +
((bits[220] ^ bits[221]) ? 12'sd1 : 12'sd0)) +
(((bits[220] ^ bits[231]) ? 12'sd1 : 12'sd0) +
((bits[220] ^ bits[232]) ? -12'sd1 : 12'sd0))) +
((((bits[220] ^ bits[233]) ? 12'sd1 : 12'sd0) +
((bits[221] ^ bits[222]) ? -12'sd1 : 12'sd0)) +
(((bits[221] ^ bits[232]) ? 12'sd1 : 12'sd0) +
((bits[221] ^ bits[233]) ? 12'sd1 : 12'sd0))))) +
((((((bits[221] ^ bits[234]) ? -12'sd1 : 12'sd0) +
((bits[222] ^ bits[223]) ? -12'sd1 : 12'sd0)) +
(((bits[222] ^ bits[233]) ? 12'sd1 : 12'sd0) +
((bits[222] ^ bits[234]) ? 12'sd1 : 12'sd0))) +
((((bits[222] ^ bits[235]) ? 12'sd1 : 12'sd0) +
((bits[223] ^ bits[224]) ? -12'sd1 : 12'sd0)) +
(((bits[223] ^ bits[234]) ? 12'sd1 : 12'sd0) +
((bits[223] ^ bits[235]) ? 12'sd1 : 12'sd0)))) +
(((((bits[223] ^ bits[236]) ? 12'sd1 : 12'sd0) +
((bits[224] ^ bits[225]) ? 12'sd1 : 12'sd0)) +
(((bits[224] ^ bits[235]) ? 12'sd1 : 12'sd0) +
((bits[224] ^ bits[236]) ? 12'sd1 : 12'sd0))) +
((((bits[224] ^ bits[237]) ? 12'sd1 : 12'sd0) +
((bits[225] ^ bits[226]) ? -12'sd1 : 12'sd0)) +
(((bits[225] ^ bits[236]) ? 12'sd1 : 12'sd0) +
(((bits[225] ^ bits[237]) ? -12'sd1 : 12'sd0) +
((bits[225] ^ bits[238]) ? 12'sd1 : 12'sd0)))))))) +
((((((((bits[226] ^ bits[227]) ? -12'sd1 : 12'sd0) +
((bits[226] ^ bits[237]) ? -12'sd1 : 12'sd0)) +
(((bits[226] ^ bits[238]) ? -12'sd1 : 12'sd0) +
((bits[226] ^ bits[239]) ? 12'sd1 : 12'sd0))) +
((((bits[227] ^ bits[238]) ? 12'sd1 : 12'sd0) +
((bits[227] ^ bits[239]) ? 12'sd1 : 12'sd0)) +
(((bits[228] ^ bits[229]) ? 12'sd1 : 12'sd0) +
((bits[228] ^ bits[240]) ? 12'sd1 : 12'sd0)))) +
(((((bits[228] ^ bits[241]) ? 12'sd1 : 12'sd0) +
((bits[229] ^ bits[230]) ? 12'sd1 : 12'sd0)) +
(((bits[229] ^ bits[240]) ? 12'sd1 : 12'sd0) +
((bits[229] ^ bits[241]) ? -12'sd1 : 12'sd0))) +
((((bits[229] ^ bits[242]) ? -12'sd1 : 12'sd0) +
((bits[230] ^ bits[231]) ? -12'sd1 : 12'sd0)) +
(((bits[230] ^ bits[241]) ? 12'sd1 : 12'sd0) +
((bits[230] ^ bits[242]) ? 12'sd1 : 12'sd0))))) +
((((((bits[230] ^ bits[243]) ? 12'sd1 : 12'sd0) +
((bits[231] ^ bits[232]) ? -12'sd1 : 12'sd0)) +
(((bits[231] ^ bits[242]) ? -12'sd1 : 12'sd0) +
((bits[231] ^ bits[243]) ? 12'sd1 : 12'sd0))) +
((((bits[231] ^ bits[244]) ? 12'sd1 : 12'sd0) +
((bits[232] ^ bits[233]) ? 12'sd1 : 12'sd0)) +
(((bits[232] ^ bits[243]) ? -12'sd1 : 12'sd0) +
((bits[232] ^ bits[244]) ? 12'sd1 : 12'sd0)))) +
(((((bits[232] ^ bits[245]) ? -12'sd1 : 12'sd0) +
((bits[233] ^ bits[234]) ? -12'sd1 : 12'sd0)) +
(((bits[233] ^ bits[244]) ? 12'sd1 : 12'sd0) +
((bits[233] ^ bits[245]) ? 12'sd1 : 12'sd0))) +
((((bits[233] ^ bits[246]) ? 12'sd1 : 12'sd0) +
((bits[234] ^ bits[235]) ? 12'sd1 : 12'sd0)) +
(((bits[234] ^ bits[245]) ? -12'sd1 : 12'sd0) +
(((bits[234] ^ bits[246]) ? -12'sd1 : 12'sd0) +
((bits[234] ^ bits[247]) ? 12'sd1 : 12'sd0))))))) +
(((((((bits[235] ^ bits[236]) ? -12'sd1 : 12'sd0) +
((bits[235] ^ bits[246]) ? -12'sd1 : 12'sd0)) +
(((bits[235] ^ bits[247]) ? 12'sd1 : 12'sd0) +
((bits[235] ^ bits[248]) ? -12'sd1 : 12'sd0))) +
((((bits[236] ^ bits[237]) ? 12'sd1 : 12'sd0) +
((bits[236] ^ bits[247]) ? 12'sd1 : 12'sd0)) +
(((bits[236] ^ bits[248]) ? 12'sd1 : 12'sd0) +
((bits[236] ^ bits[249]) ? -12'sd1 : 12'sd0)))) +
(((((bits[237] ^ bits[238]) ? -12'sd1 : 12'sd0) +
((bits[237] ^ bits[248]) ? -12'sd1 : 12'sd0)) +
(((bits[237] ^ bits[249]) ? 12'sd1 : 12'sd0) +
((bits[237] ^ bits[250]) ? -12'sd1 : 12'sd0))) +
((((bits[238] ^ bits[239]) ? -12'sd1 : 12'sd0) +
((bits[238] ^ bits[249]) ? 12'sd1 : 12'sd0)) +
(((bits[238] ^ bits[250]) ? -12'sd1 : 12'sd0) +
((bits[238] ^ bits[251]) ? -12'sd1 : 12'sd0))))) +
((((((bits[239] ^ bits[250]) ? 12'sd1 : 12'sd0) +
((bits[239] ^ bits[251]) ? 12'sd1 : 12'sd0)) +
(((bits[240] ^ bits[241]) ? -12'sd1 : 12'sd0) +
((bits[240] ^ bits[252]) ? 12'sd1 : 12'sd0))) +
((((bits[240] ^ bits[253]) ? 12'sd1 : 12'sd0) +
((bits[241] ^ bits[242]) ? 12'sd1 : 12'sd0)) +
(((bits[241] ^ bits[252]) ? 12'sd1 : 12'sd0) +
((bits[241] ^ bits[253]) ? 12'sd1 : 12'sd0)))) +
(((((bits[241] ^ bits[254]) ? -12'sd1 : 12'sd0) +
((bits[242] ^ bits[243]) ? -12'sd1 : 12'sd0)) +
(((bits[242] ^ bits[253]) ? 12'sd1 : 12'sd0) +
((bits[242] ^ bits[254]) ? -12'sd1 : 12'sd0))) +
((((bits[242] ^ bits[255]) ? 12'sd1 : 12'sd0) +
((bits[243] ^ bits[244]) ? -12'sd1 : 12'sd0)) +
(((bits[243] ^ bits[254]) ? 12'sd1 : 12'sd0) +
(((bits[243] ^ bits[255]) ? -12'sd1 : 12'sd0) +
((bits[243] ^ bits[256]) ? 12'sd1 : 12'sd0))))))))) +
(((((((((bits[244] ^ bits[245]) ? -12'sd1 : 12'sd0) +
((bits[244] ^ bits[255]) ? -12'sd1 : 12'sd0)) +
(((bits[244] ^ bits[256]) ? 12'sd1 : 12'sd0) +
((bits[244] ^ bits[257]) ? -12'sd1 : 12'sd0))) +
((((bits[245] ^ bits[246]) ? -12'sd1 : 12'sd0) +
((bits[245] ^ bits[256]) ? -12'sd1 : 12'sd0)) +
(((bits[245] ^ bits[257]) ? -12'sd1 : 12'sd0) +
((bits[245] ^ bits[258]) ? 12'sd1 : 12'sd0)))) +
(((((bits[246] ^ bits[247]) ? 12'sd1 : 12'sd0) +
((bits[246] ^ bits[257]) ? 12'sd1 : 12'sd0)) +
(((bits[246] ^ bits[258]) ? -12'sd1 : 12'sd0) +
((bits[246] ^ bits[259]) ? 12'sd1 : 12'sd0))) +
((((bits[247] ^ bits[248]) ? 12'sd1 : 12'sd0) +
((bits[247] ^ bits[258]) ? -12'sd1 : 12'sd0)) +
(((bits[247] ^ bits[259]) ? -12'sd1 : 12'sd0) +
((bits[247] ^ bits[260]) ? 12'sd1 : 12'sd0))))) +
((((((bits[248] ^ bits[249]) ? -12'sd1 : 12'sd0) +
((bits[248] ^ bits[259]) ? 12'sd1 : 12'sd0)) +
(((bits[248] ^ bits[260]) ? -12'sd1 : 12'sd0) +
((bits[248] ^ bits[261]) ? -12'sd1 : 12'sd0))) +
((((bits[249] ^ bits[250]) ? -12'sd1 : 12'sd0) +
((bits[249] ^ bits[260]) ? -12'sd1 : 12'sd0)) +
(((bits[249] ^ bits[261]) ? 12'sd1 : 12'sd0) +
((bits[249] ^ bits[262]) ? -12'sd1 : 12'sd0)))) +
(((((bits[250] ^ bits[251]) ? 12'sd1 : 12'sd0) +
((bits[250] ^ bits[261]) ? -12'sd1 : 12'sd0)) +
(((bits[250] ^ bits[262]) ? 12'sd1 : 12'sd0) +
((bits[250] ^ bits[263]) ? -12'sd1 : 12'sd0))) +
((((bits[251] ^ bits[262]) ? -12'sd1 : 12'sd0) +
((bits[251] ^ bits[263]) ? -12'sd1 : 12'sd0)) +
(((bits[252] ^ bits[253]) ? -12'sd1 : 12'sd0) +
((bits[252] ^ bits[264]) ? 12'sd1 : 12'sd0)))))) +
(((((((bits[252] ^ bits[265]) ? 12'sd1 : 12'sd0) +
((bits[253] ^ bits[254]) ? -12'sd1 : 12'sd0)) +
(((bits[253] ^ bits[264]) ? 12'sd1 : 12'sd0) +
((bits[253] ^ bits[265]) ? -12'sd1 : 12'sd0))) +
((((bits[253] ^ bits[266]) ? -12'sd1 : 12'sd0) +
((bits[254] ^ bits[255]) ? -12'sd1 : 12'sd0)) +
(((bits[254] ^ bits[265]) ? -12'sd1 : 12'sd0) +
((bits[254] ^ bits[266]) ? -12'sd1 : 12'sd0)))) +
(((((bits[254] ^ bits[267]) ? 12'sd1 : 12'sd0) +
((bits[255] ^ bits[256]) ? -12'sd1 : 12'sd0)) +
(((bits[255] ^ bits[266]) ? 12'sd1 : 12'sd0) +
((bits[255] ^ bits[267]) ? 12'sd1 : 12'sd0))) +
((((bits[255] ^ bits[268]) ? -12'sd1 : 12'sd0) +
((bits[256] ^ bits[257]) ? -12'sd1 : 12'sd0)) +
(((bits[256] ^ bits[267]) ? -12'sd1 : 12'sd0) +
((bits[256] ^ bits[268]) ? -12'sd1 : 12'sd0))))) +
((((((bits[256] ^ bits[269]) ? 12'sd1 : 12'sd0) +
((bits[257] ^ bits[258]) ? 12'sd1 : 12'sd0)) +
(((bits[257] ^ bits[268]) ? -12'sd1 : 12'sd0) +
((bits[257] ^ bits[269]) ? -12'sd1 : 12'sd0))) +
((((bits[257] ^ bits[270]) ? -12'sd1 : 12'sd0) +
((bits[258] ^ bits[259]) ? 12'sd1 : 12'sd0)) +
(((bits[258] ^ bits[269]) ? 12'sd1 : 12'sd0) +
((bits[258] ^ bits[270]) ? -12'sd1 : 12'sd0)))) +
(((((bits[258] ^ bits[271]) ? 12'sd1 : 12'sd0) +
((bits[259] ^ bits[260]) ? -12'sd1 : 12'sd0)) +
(((bits[259] ^ bits[270]) ? -12'sd1 : 12'sd0) +
((bits[259] ^ bits[271]) ? -12'sd1 : 12'sd0))) +
((((bits[259] ^ bits[272]) ? 12'sd1 : 12'sd0) +
((bits[260] ^ bits[261]) ? -12'sd1 : 12'sd0)) +
(((bits[260] ^ bits[271]) ? -12'sd1 : 12'sd0) +
(((bits[260] ^ bits[272]) ? 12'sd1 : 12'sd0) +
((bits[260] ^ bits[273]) ? 12'sd1 : 12'sd0)))))))) +
((((((((bits[261] ^ bits[262]) ? 12'sd1 : 12'sd0) +
((bits[261] ^ bits[272]) ? -12'sd1 : 12'sd0)) +
(((bits[261] ^ bits[273]) ? 12'sd1 : 12'sd0) +
((bits[261] ^ bits[274]) ? -12'sd1 : 12'sd0))) +
((((bits[262] ^ bits[263]) ? -12'sd1 : 12'sd0) +
((bits[262] ^ bits[273]) ? 12'sd1 : 12'sd0)) +
(((bits[262] ^ bits[274]) ? -12'sd1 : 12'sd0) +
((bits[262] ^ bits[275]) ? 12'sd1 : 12'sd0)))) +
(((((bits[263] ^ bits[274]) ? 12'sd1 : 12'sd0) +
((bits[263] ^ bits[275]) ? 12'sd1 : 12'sd0)) +
(((bits[264] ^ bits[265]) ? -12'sd1 : 12'sd0) +
((bits[264] ^ bits[276]) ? 12'sd1 : 12'sd0))) +
((((bits[264] ^ bits[277]) ? 12'sd1 : 12'sd0) +
((bits[265] ^ bits[266]) ? 12'sd1 : 12'sd0)) +
(((bits[265] ^ bits[276]) ? 12'sd1 : 12'sd0) +
((bits[265] ^ bits[277]) ? -12'sd1 : 12'sd0))))) +
((((((bits[265] ^ bits[278]) ? -12'sd1 : 12'sd0) +
((bits[266] ^ bits[267]) ? 12'sd1 : 12'sd0)) +
(((bits[266] ^ bits[277]) ? -12'sd1 : 12'sd0) +
((bits[266] ^ bits[278]) ? -12'sd1 : 12'sd0))) +
((((bits[266] ^ bits[279]) ? 12'sd1 : 12'sd0) +
((bits[267] ^ bits[268]) ? -12'sd1 : 12'sd0)) +
(((bits[267] ^ bits[278]) ? 12'sd1 : 12'sd0) +
((bits[267] ^ bits[279]) ? 12'sd1 : 12'sd0)))) +
(((((bits[267] ^ bits[280]) ? -12'sd1 : 12'sd0) +
((bits[268] ^ bits[269]) ? 12'sd1 : 12'sd0)) +
(((bits[268] ^ bits[279]) ? 12'sd1 : 12'sd0) +
((bits[268] ^ bits[280]) ? -12'sd1 : 12'sd0))) +
((((bits[268] ^ bits[281]) ? -12'sd1 : 12'sd0) +
((bits[269] ^ bits[270]) ? 12'sd1 : 12'sd0)) +
(((bits[269] ^ bits[280]) ? 12'sd1 : 12'sd0) +
(((bits[269] ^ bits[281]) ? 12'sd1 : 12'sd0) +
((bits[269] ^ bits[282]) ? 12'sd1 : 12'sd0))))))) +
(((((((bits[270] ^ bits[271]) ? -12'sd1 : 12'sd0) +
((bits[270] ^ bits[281]) ? 12'sd1 : 12'sd0)) +
(((bits[270] ^ bits[282]) ? 12'sd1 : 12'sd0) +
((bits[270] ^ bits[283]) ? -12'sd1 : 12'sd0))) +
((((bits[271] ^ bits[272]) ? -12'sd1 : 12'sd0) +
((bits[271] ^ bits[282]) ? -12'sd1 : 12'sd0)) +
(((bits[271] ^ bits[283]) ? 12'sd1 : 12'sd0) +
((bits[271] ^ bits[284]) ? 12'sd1 : 12'sd0)))) +
(((((bits[272] ^ bits[273]) ? 12'sd1 : 12'sd0) +
((bits[272] ^ bits[283]) ? 12'sd1 : 12'sd0)) +
(((bits[272] ^ bits[284]) ? 12'sd1 : 12'sd0) +
((bits[272] ^ bits[285]) ? -12'sd1 : 12'sd0))) +
((((bits[273] ^ bits[274]) ? 12'sd1 : 12'sd0) +
((bits[273] ^ bits[284]) ? -12'sd1 : 12'sd0)) +
(((bits[273] ^ bits[285]) ? -12'sd1 : 12'sd0) +
((bits[273] ^ bits[286]) ? 12'sd1 : 12'sd0))))) +
((((((bits[274] ^ bits[275]) ? 12'sd1 : 12'sd0) +
((bits[274] ^ bits[285]) ? -12'sd1 : 12'sd0)) +
(((bits[274] ^ bits[286]) ? 12'sd1 : 12'sd0) +
((bits[274] ^ bits[287]) ? -12'sd1 : 12'sd0))) +
((((bits[275] ^ bits[286]) ? 12'sd1 : 12'sd0) +
((bits[275] ^ bits[287]) ? -12'sd1 : 12'sd0)) +
(((bits[276] ^ bits[277]) ? 12'sd1 : 12'sd0) +
((bits[277] ^ bits[278]) ? 12'sd1 : 12'sd0)))) +
(((((bits[278] ^ bits[279]) ? -12'sd1 : 12'sd0) +
((bits[279] ^ bits[280]) ? -12'sd1 : 12'sd0)) +
(((bits[280] ^ bits[281]) ? -12'sd1 : 12'sd0) +
((bits[281] ^ bits[282]) ? -12'sd1 : 12'sd0))) +
((((bits[282] ^ bits[283]) ? 12'sd1 : 12'sd0) +
((bits[283] ^ bits[284]) ? 12'sd1 : 12'sd0)) +
(((bits[284] ^ bits[285]) ? -12'sd1 : 12'sd0) +
(((bits[285] ^ bits[286]) ? 12'sd1 : 12'sd0) +
((bits[286] ^ bits[287]) ? -12'sd1 : 12'sd0))))))))))));
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
17: probability = 32'd4134649536;
18: probability = 32'd4036897099;
19: probability = 32'd3969158894;
20: probability = 32'd3782994644;
21: probability = 32'd3659109422;
22: probability = 32'd3338477483;
23: probability = 32'd2917050301;
24: probability = 32'd2673442471;
25: probability = 32'd2147483648;
26: probability = 32'd2673442471;
27: probability = 32'd2917050301;
28: probability = 32'd3338477483;
29: probability = 32'd3659109422;
30: probability = 32'd3782994644;
31: probability = 32'd3969158894;
32: probability = 32'd4036897099;
33: probability = 32'd4134649536;
34: probability = 32'd4234564478;
35: probability = 32'd4196280244;
36: probability = 32'd4134649536;
37: probability = 32'd3969158894;
38: probability = 32'd3782994644;
39: probability = 32'd3511455637;
40: probability = 32'd3139872687;
41: probability = 32'd2673442471;
42: probability = 32'd2147483648;
43: probability = 32'd2673442471;
44: probability = 32'd3139872687;
45: probability = 32'd3511455637;
46: probability = 32'd3782994644;
47: probability = 32'd3969158894;
48: probability = 32'd4134649536;
49: probability = 32'd4196280244;
50: probability = 32'd4234564478;
51: probability = 32'd4266221720;
52: probability = 32'd4247778737;
53: probability = 32'd4196280244;
54: probability = 32'd4134649536;
55: probability = 32'd3969158894;
56: probability = 32'd3782994644;
57: probability = 32'd3338477483;
58: probability = 32'd2917050301;
59: probability = 32'd2147483648;
60: probability = 32'd2917050301;
61: probability = 32'd3338477483;
62: probability = 32'd3782994644;
63: probability = 32'd3969158894;
64: probability = 32'd4134649536;
65: probability = 32'd4196280244;
66: probability = 32'd4247778737;
67: probability = 32'd4266221720;
68: probability = 32'd4284347460;
69: probability = 32'd4272547027;
70: probability = 32'd4247778737;
71: probability = 32'd4196280244;
72: probability = 32'd4091274722;
73: probability = 32'd3885444463;
74: probability = 32'd3511455637;
75: probability = 32'd2917050301;
76: probability = 32'd2147483648;
77: probability = 32'd2917050301;
78: probability = 32'd3511455637;
79: probability = 32'd3885444463;
80: probability = 32'd4091274722;
81: probability = 32'd4196280244;
82: probability = 32'd4247778737;
83: probability = 32'd4272547027;
84: probability = 32'd4284347460;
85: probability = 32'd4291054361;
86: probability = 32'd4286692034;
87: probability = 32'd4272547027;
88: probability = 32'd4247778737;
89: probability = 32'd4169072224;
90: probability = 32'd4036897099;
91: probability = 32'd3659109422;
92: probability = 32'd3139872687;
93: probability = 32'd2147483648;
94: probability = 32'd3139872687;
95: probability = 32'd3659109422;
96: probability = 32'd4036897099;
97: probability = 32'd4169072224;
98: probability = 32'd4247778737;
99: probability = 32'd4272547027;
100: probability = 32'd4286692034;
101: probability = 32'd4291054361;
102: probability = 32'd4293845492;
103: probability = 32'd4291919285;
104: probability = 32'd4286692034;
105: probability = 32'd4266221720;
106: probability = 32'd4217717112;
107: probability = 32'd4091274722;
108: probability = 32'd3782994644;
109: probability = 32'd3139872687;
110: probability = 32'd2147483648;
111: probability = 32'd3139872687;
112: probability = 32'd3782994644;
113: probability = 32'd4091274722;
114: probability = 32'd4217717112;
115: probability = 32'd4266221720;
116: probability = 32'd4286692034;
117: probability = 32'd4291919285;
118: probability = 32'd4293845492;
119: probability = 32'd4294645834;
120: probability = 32'd4293845492;
121: probability = 32'd4291919285;
122: probability = 32'd4284347460;
123: probability = 32'd4258127277;
124: probability = 32'd4169072224;
125: probability = 32'd3969158894;
126: probability = 32'd3338477483;
127: probability = 32'd2147483648;
128: probability = 32'd3338477483;
129: probability = 32'd3969158894;
130: probability = 32'd4169072224;
131: probability = 32'd4258127277;
132: probability = 32'd4284347460;
133: probability = 32'd4291919285;
134: probability = 32'd4293845492;
135: probability = 32'd4294645834;
136: probability = 32'd4294895564;
137: probability = 32'd4294645834;
138: probability = 32'd4293845492;
139: probability = 32'd4289944288;
140: probability = 32'd4277486188;
141: probability = 32'd4217717112;
142: probability = 32'd4036897099;
143: probability = 32'd3338477483;
144: probability = 32'd2147483648;
145: probability = 32'd3338477483;
146: probability = 32'd4036897099;
147: probability = 32'd4217717112;
148: probability = 32'd4277486188;
149: probability = 32'd4289944288;
150: probability = 32'd4293845492;
151: probability = 32'd4294645834;
152: probability = 32'd4294895564;
153: probability = 32'd4294957588;
154: probability = 32'd4294911431;
155: probability = 32'd4294716937;
156: probability = 32'd4293526978;
157: probability = 32'd4288519767;
158: probability = 32'd4258127277;
159: probability = 32'd4134649536;
160: probability = 32'd3511455637;
161: probability = 32'd2147483648;
162: probability = 32'd3511455637;
163: probability = 32'd4134649536;
164: probability = 32'd4258127277;
165: probability = 32'd4288519767;
166: probability = 32'd4293526978;
167: probability = 32'd4294716937;
168: probability = 32'd4294911431;
169: probability = 32'd4294957588;
170: probability = 32'd4294966499;
171: probability = 32'd4294962710;
172: probability = 32'd4294933412;
173: probability = 32'd4294716937;
174: probability = 32'd4293118067;
175: probability = 32'd4281340727;
176: probability = 32'd4217717112;
177: probability = 32'd3782994644;
178: probability = 32'd2147483648;
179: probability = 32'd3782994644;
180: probability = 32'd4217717112;
181: probability = 32'd4281340727;
182: probability = 32'd4293118067;
183: probability = 32'd4294716937;
184: probability = 32'd4294933412;
185: probability = 32'd4294962710;
186: probability = 32'd4294966499;
187: probability = 32'd4294967277;
188: probability = 32'd4294967068;
189: probability = 32'd4294965130;
190: probability = 32'd4294940907;
191: probability = 32'd4294645834;
192: probability = 32'd4291919285;
193: probability = 32'd4258127277;
194: probability = 32'd3969158894;
195: probability = 32'd2147483648;
196: probability = 32'd3969158894;
197: probability = 32'd4258127277;
198: probability = 32'd4291919285;
199: probability = 32'd4294645834;
200: probability = 32'd4294940907;
201: probability = 32'd4294965130;
202: probability = 32'd4294967068;
203: probability = 32'd4294967277;
204: probability = 32'd4294967295;
205: probability = 32'd4294967291;
206: probability = 32'd4294967212;
207: probability = 32'd4294965609;
208: probability = 32'd4294933412;
209: probability = 32'd4294286818;
210: probability = 32'd4284347460;
211: probability = 32'd4091274722;
212: probability = 32'd2147483648;
213: probability = 32'd4091274722;
214: probability = 32'd4284347460;
215: probability = 32'd4294286818;
216: probability = 32'd4294933412;
217: probability = 32'd4294965609;
218: probability = 32'd4294967212;
219: probability = 32'd4294967291;
220: probability = 32'd4294967295;
221: probability = 32'd4294967295;
222: probability = 32'd4294967295;
223: probability = 32'd4294967295;
224: probability = 32'd4294967245;
225: probability = 32'd4294965130;
226: probability = 32'd4294895564;
227: probability = 32'd4291919285;
228: probability = 32'd4196280244;
229: probability = 32'd2147483648;
230: probability = 32'd4196280244;
231: probability = 32'd4291919285;
232: probability = 32'd4294895564;
233: probability = 32'd4294965130;
234: probability = 32'd4294967245;
235: probability = 32'd4294967295;
236: probability = 32'd4294967295;
237: probability = 32'd4294967295;
238: probability = 32'd4294967295;
239: probability = 32'd4294967295;
240: probability = 32'd4294967295;
241: probability = 32'd4294967295;
242: probability = 32'd4294967277;
243: probability = 32'd4294965130;
244: probability = 32'd4294716937;
245: probability = 32'd4258127277;
246: probability = 32'd2147483648;
247: probability = 32'd4258127277;
248: probability = 32'd4294716937;
249: probability = 32'd4294965130;
250: probability = 32'd4294967277;
251: probability = 32'd4294967295;
252: probability = 32'd4294967295;
253: probability = 32'd4294967295;
254: probability = 32'd4294967295;
255: probability = 32'd4294967295;
256: probability = 32'd4294967295;
257: probability = 32'd4294967295;
258: probability = 32'd4294967295;
259: probability = 32'd4294967295;
260: probability = 32'd4294967231;
261: probability = 32'd4294940907;
262: probability = 32'd4284347460;
263: probability = 32'd2147483648;
264: probability = 32'd4284347460;
265: probability = 32'd4294940907;
266: probability = 32'd4294967231;
267: probability = 32'd4294967295;
268: probability = 32'd4294967295;
269: probability = 32'd4294967295;
270: probability = 32'd4294967295;
271: probability = 32'd4294967295;
default: probability=0;
endcase
end
endfunction
function automatic [31:0] swap_threshold(input logic [3:0] left,input logic [11:0] gap);
begin
case(left)
0: begin case(gap)
1: swap_threshold=32'd3845725904;
2: swap_threshold=32'd3443473887;
3: swap_threshold=32'd3083296289;
4: swap_threshold=32'd2760792247;
5: swap_threshold=32'd2472021212;
6: swap_threshold=32'd2213454807;
7: swap_threshold=32'd1981933715;
8: swap_threshold=32'd1774629073;
9: swap_threshold=32'd1589007907;
10: swap_threshold=32'd1422802189;
11: swap_threshold=32'd1273981117;
12: swap_threshold=32'd1140726308;
13: swap_threshold=32'd1021409573;
14: swap_threshold=32'd914573030;
15: swap_threshold=32'd818911286;
16: swap_threshold=32'd733255489;
17: swap_threshold=32'd656559046;
18: swap_threshold=32'd587884832;
19: swap_threshold=32'd526393747;
20: swap_threshold=32'd471334455;
21: swap_threshold=32'd422034208;
22: swap_threshold=32'd377890628;
23: swap_threshold=32'd338364340;
24: swap_threshold=32'd302972390;
25: swap_threshold=32'd271282338;
26: swap_threshold=32'd242906975;
27: swap_threshold=32'd217499595;
28: swap_threshold=32'd194749754;
29: swap_threshold=32'd174379483;
30: swap_threshold=32'd156139883;
31: swap_threshold=32'd139808095;
32: swap_threshold=32'd125184565;
33: swap_threshold=32'd112090614;
34: swap_threshold=32'd100366254;
35: swap_threshold=32'd89868229;
36: swap_threshold=32'd80468267;
37: swap_threshold=32'd72051514;
38: swap_threshold=32'd64515130;
39: swap_threshold=32'd57767031;
40: swap_threshold=32'd51724763;
41: swap_threshold=32'd46314500;
42: swap_threshold=32'd41470134;
43: swap_threshold=32'd37132476;
44: swap_threshold=32'd33248524;
45: swap_threshold=32'd29770823;
46: swap_threshold=32'd26656879;
47: swap_threshold=32'd23868645;
48: swap_threshold=32'd21372053;
49: swap_threshold=32'd19136597;
50: swap_threshold=32'd17134963;
51: swap_threshold=32'd15342694;
52: swap_threshold=32'd13737892;
53: swap_threshold=32'd12300947;
54: swap_threshold=32'd11014303;
55: swap_threshold=32'd9862238;
56: swap_threshold=32'd8830676;
57: swap_threshold=32'd7907012;
58: swap_threshold=32'd7079961;
59: swap_threshold=32'd6339417;
60: swap_threshold=32'd5676332;
61: swap_threshold=32'd5082604;
62: swap_threshold=32'd4550978;
63: swap_threshold=32'd4074958;
64: swap_threshold=32'd3648729;
65: swap_threshold=32'd3267083;
66: swap_threshold=32'd2925355;
67: swap_threshold=32'd2619371;
68: swap_threshold=32'd2345392;
69: swap_threshold=32'd2100071;
70: swap_threshold=32'd1880409;
71: swap_threshold=32'd1683724;
72: swap_threshold=32'd1507611;
73: swap_threshold=32'd1349919;
74: swap_threshold=32'd1208721;
75: swap_threshold=32'd1082292;
76: swap_threshold=32'd969088;
77: swap_threshold=32'd867724;
78: swap_threshold=32'd776962;
79: swap_threshold=32'd695694;
80: swap_threshold=32'd622927;
81: swap_threshold=32'd557770;
82: swap_threshold=32'd499429;
83: swap_threshold=32'd447190;
84: swap_threshold=32'd400415;
85: swap_threshold=32'd358533;
86: swap_threshold=32'd321031;
87: swap_threshold=32'd287452;
88: swap_threshold=32'd257385;
89: swap_threshold=32'd230464;
90: swap_threshold=32'd206358;
91: swap_threshold=32'd184773;
92: swap_threshold=32'd165446;
93: swap_threshold=32'd148141;
94: swap_threshold=32'd132646;
95: swap_threshold=32'd118772;
96: swap_threshold=32'd106348;
97: swap_threshold=32'd95225;
98: swap_threshold=32'd85264;
99: swap_threshold=32'd76346;
100: swap_threshold=32'd68360;
101: swap_threshold=32'd61210;
102: swap_threshold=32'd54807;
103: swap_threshold=32'd49075;
104: swap_threshold=32'd43942;
105: swap_threshold=32'd39345;
106: swap_threshold=32'd35230;
107: swap_threshold=32'd31545;
108: swap_threshold=32'd28245;
109: swap_threshold=32'd25291;
110: swap_threshold=32'd22645;
111: swap_threshold=32'd20277;
112: swap_threshold=32'd18156;
113: swap_threshold=32'd16257;
114: swap_threshold=32'd14556;
115: swap_threshold=32'd13034;
116: swap_threshold=32'd11670;
117: swap_threshold=32'd10450;
118: swap_threshold=32'd9357;
119: swap_threshold=32'd8378;
120: swap_threshold=32'd7501;
121: swap_threshold=32'd6717;
122: swap_threshold=32'd6014;
123: swap_threshold=32'd5385;
124: swap_threshold=32'd4822;
125: swap_threshold=32'd4317;
126: swap_threshold=32'd3866;
127: swap_threshold=32'd3461;
128: swap_threshold=32'd3099;
129: swap_threshold=32'd2775;
130: swap_threshold=32'd2485;
131: swap_threshold=32'd2225;
132: swap_threshold=32'd1992;
133: swap_threshold=32'd1784;
134: swap_threshold=32'd1597;
135: swap_threshold=32'd1430;
136: swap_threshold=32'd1280;
137: swap_threshold=32'd1146;
138: swap_threshold=32'd1026;
139: swap_threshold=32'd919;
140: swap_threshold=32'd823;
141: swap_threshold=32'd737;
142: swap_threshold=32'd660;
143: swap_threshold=32'd591;
144: swap_threshold=32'd529;
145: swap_threshold=32'd473;
146: swap_threshold=32'd424;
147: swap_threshold=32'd379;
148: swap_threshold=32'd340;
149: swap_threshold=32'd304;
150: swap_threshold=32'd272;
151: swap_threshold=32'd244;
152: swap_threshold=32'd218;
153: swap_threshold=32'd195;
154: swap_threshold=32'd175;
155: swap_threshold=32'd156;
156: swap_threshold=32'd140;
157: swap_threshold=32'd125;
158: swap_threshold=32'd112;
159: swap_threshold=32'd100;
160: swap_threshold=32'd90;
161: swap_threshold=32'd80;
162: swap_threshold=32'd72;
163: swap_threshold=32'd64;
164: swap_threshold=32'd58;
165: swap_threshold=32'd52;
166: swap_threshold=32'd46;
167: swap_threshold=32'd41;
168: swap_threshold=32'd37;
169: swap_threshold=32'd33;
170: swap_threshold=32'd29;
171: swap_threshold=32'd26;
172: swap_threshold=32'd23;
173: swap_threshold=32'd21;
174: swap_threshold=32'd19;
175: swap_threshold=32'd17;
176: swap_threshold=32'd15;
177: swap_threshold=32'd13;
178: swap_threshold=32'd12;
179: swap_threshold=32'd11;
180: swap_threshold=32'd9;
181: swap_threshold=32'd8;
182: swap_threshold=32'd7;
183: swap_threshold=32'd7;
184: swap_threshold=32'd6;
185: swap_threshold=32'd5;
186: swap_threshold=32'd5;
187: swap_threshold=32'd4;
188: swap_threshold=32'd4;
189: swap_threshold=32'd3;
190: swap_threshold=32'd3;
191: swap_threshold=32'd2;
192: swap_threshold=32'd2;
193: swap_threshold=32'd2;
194: swap_threshold=32'd2;
195: swap_threshold=32'd1;
196: swap_threshold=32'd1;
197: swap_threshold=32'd1;
198: swap_threshold=32'd1;
199: swap_threshold=32'd1;
200: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
1: begin case(gap)
1: swap_threshold=32'd3845725904;
2: swap_threshold=32'd3443473887;
3: swap_threshold=32'd3083296289;
4: swap_threshold=32'd2760792247;
5: swap_threshold=32'd2472021212;
6: swap_threshold=32'd2213454807;
7: swap_threshold=32'd1981933715;
8: swap_threshold=32'd1774629073;
9: swap_threshold=32'd1589007907;
10: swap_threshold=32'd1422802189;
11: swap_threshold=32'd1273981117;
12: swap_threshold=32'd1140726308;
13: swap_threshold=32'd1021409573;
14: swap_threshold=32'd914573030;
15: swap_threshold=32'd818911286;
16: swap_threshold=32'd733255489;
17: swap_threshold=32'd656559046;
18: swap_threshold=32'd587884832;
19: swap_threshold=32'd526393747;
20: swap_threshold=32'd471334455;
21: swap_threshold=32'd422034208;
22: swap_threshold=32'd377890628;
23: swap_threshold=32'd338364340;
24: swap_threshold=32'd302972390;
25: swap_threshold=32'd271282338;
26: swap_threshold=32'd242906975;
27: swap_threshold=32'd217499595;
28: swap_threshold=32'd194749754;
29: swap_threshold=32'd174379483;
30: swap_threshold=32'd156139883;
31: swap_threshold=32'd139808095;
32: swap_threshold=32'd125184565;
33: swap_threshold=32'd112090614;
34: swap_threshold=32'd100366254;
35: swap_threshold=32'd89868229;
36: swap_threshold=32'd80468267;
37: swap_threshold=32'd72051514;
38: swap_threshold=32'd64515130;
39: swap_threshold=32'd57767031;
40: swap_threshold=32'd51724763;
41: swap_threshold=32'd46314500;
42: swap_threshold=32'd41470134;
43: swap_threshold=32'd37132476;
44: swap_threshold=32'd33248524;
45: swap_threshold=32'd29770823;
46: swap_threshold=32'd26656879;
47: swap_threshold=32'd23868645;
48: swap_threshold=32'd21372053;
49: swap_threshold=32'd19136597;
50: swap_threshold=32'd17134963;
51: swap_threshold=32'd15342694;
52: swap_threshold=32'd13737892;
53: swap_threshold=32'd12300947;
54: swap_threshold=32'd11014303;
55: swap_threshold=32'd9862238;
56: swap_threshold=32'd8830676;
57: swap_threshold=32'd7907012;
58: swap_threshold=32'd7079961;
59: swap_threshold=32'd6339417;
60: swap_threshold=32'd5676332;
61: swap_threshold=32'd5082604;
62: swap_threshold=32'd4550978;
63: swap_threshold=32'd4074958;
64: swap_threshold=32'd3648729;
65: swap_threshold=32'd3267083;
66: swap_threshold=32'd2925355;
67: swap_threshold=32'd2619371;
68: swap_threshold=32'd2345392;
69: swap_threshold=32'd2100071;
70: swap_threshold=32'd1880409;
71: swap_threshold=32'd1683724;
72: swap_threshold=32'd1507611;
73: swap_threshold=32'd1349919;
74: swap_threshold=32'd1208721;
75: swap_threshold=32'd1082292;
76: swap_threshold=32'd969088;
77: swap_threshold=32'd867724;
78: swap_threshold=32'd776962;
79: swap_threshold=32'd695694;
80: swap_threshold=32'd622927;
81: swap_threshold=32'd557770;
82: swap_threshold=32'd499429;
83: swap_threshold=32'd447190;
84: swap_threshold=32'd400415;
85: swap_threshold=32'd358533;
86: swap_threshold=32'd321031;
87: swap_threshold=32'd287452;
88: swap_threshold=32'd257385;
89: swap_threshold=32'd230464;
90: swap_threshold=32'd206358;
91: swap_threshold=32'd184773;
92: swap_threshold=32'd165446;
93: swap_threshold=32'd148141;
94: swap_threshold=32'd132646;
95: swap_threshold=32'd118772;
96: swap_threshold=32'd106348;
97: swap_threshold=32'd95225;
98: swap_threshold=32'd85264;
99: swap_threshold=32'd76346;
100: swap_threshold=32'd68360;
101: swap_threshold=32'd61210;
102: swap_threshold=32'd54807;
103: swap_threshold=32'd49075;
104: swap_threshold=32'd43942;
105: swap_threshold=32'd39345;
106: swap_threshold=32'd35230;
107: swap_threshold=32'd31545;
108: swap_threshold=32'd28245;
109: swap_threshold=32'd25291;
110: swap_threshold=32'd22645;
111: swap_threshold=32'd20277;
112: swap_threshold=32'd18156;
113: swap_threshold=32'd16257;
114: swap_threshold=32'd14556;
115: swap_threshold=32'd13034;
116: swap_threshold=32'd11670;
117: swap_threshold=32'd10450;
118: swap_threshold=32'd9357;
119: swap_threshold=32'd8378;
120: swap_threshold=32'd7501;
121: swap_threshold=32'd6717;
122: swap_threshold=32'd6014;
123: swap_threshold=32'd5385;
124: swap_threshold=32'd4822;
125: swap_threshold=32'd4317;
126: swap_threshold=32'd3866;
127: swap_threshold=32'd3461;
128: swap_threshold=32'd3099;
129: swap_threshold=32'd2775;
130: swap_threshold=32'd2485;
131: swap_threshold=32'd2225;
132: swap_threshold=32'd1992;
133: swap_threshold=32'd1784;
134: swap_threshold=32'd1597;
135: swap_threshold=32'd1430;
136: swap_threshold=32'd1280;
137: swap_threshold=32'd1146;
138: swap_threshold=32'd1026;
139: swap_threshold=32'd919;
140: swap_threshold=32'd823;
141: swap_threshold=32'd737;
142: swap_threshold=32'd660;
143: swap_threshold=32'd591;
144: swap_threshold=32'd529;
145: swap_threshold=32'd473;
146: swap_threshold=32'd424;
147: swap_threshold=32'd379;
148: swap_threshold=32'd340;
149: swap_threshold=32'd304;
150: swap_threshold=32'd272;
151: swap_threshold=32'd244;
152: swap_threshold=32'd218;
153: swap_threshold=32'd195;
154: swap_threshold=32'd175;
155: swap_threshold=32'd156;
156: swap_threshold=32'd140;
157: swap_threshold=32'd125;
158: swap_threshold=32'd112;
159: swap_threshold=32'd100;
160: swap_threshold=32'd90;
161: swap_threshold=32'd80;
162: swap_threshold=32'd72;
163: swap_threshold=32'd64;
164: swap_threshold=32'd58;
165: swap_threshold=32'd52;
166: swap_threshold=32'd46;
167: swap_threshold=32'd41;
168: swap_threshold=32'd37;
169: swap_threshold=32'd33;
170: swap_threshold=32'd29;
171: swap_threshold=32'd26;
172: swap_threshold=32'd23;
173: swap_threshold=32'd21;
174: swap_threshold=32'd19;
175: swap_threshold=32'd17;
176: swap_threshold=32'd15;
177: swap_threshold=32'd13;
178: swap_threshold=32'd12;
179: swap_threshold=32'd11;
180: swap_threshold=32'd9;
181: swap_threshold=32'd8;
182: swap_threshold=32'd7;
183: swap_threshold=32'd7;
184: swap_threshold=32'd6;
185: swap_threshold=32'd5;
186: swap_threshold=32'd5;
187: swap_threshold=32'd4;
188: swap_threshold=32'd4;
189: swap_threshold=32'd3;
190: swap_threshold=32'd3;
191: swap_threshold=32'd2;
192: swap_threshold=32'd2;
193: swap_threshold=32'd2;
194: swap_threshold=32'd2;
195: swap_threshold=32'd1;
196: swap_threshold=32'd1;
197: swap_threshold=32'd1;
198: swap_threshold=32'd1;
199: swap_threshold=32'd1;
200: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
2: begin case(gap)
1: swap_threshold=32'd3845725904;
2: swap_threshold=32'd3443473887;
3: swap_threshold=32'd3083296289;
4: swap_threshold=32'd2760792247;
5: swap_threshold=32'd2472021212;
6: swap_threshold=32'd2213454807;
7: swap_threshold=32'd1981933715;
8: swap_threshold=32'd1774629073;
9: swap_threshold=32'd1589007907;
10: swap_threshold=32'd1422802189;
11: swap_threshold=32'd1273981117;
12: swap_threshold=32'd1140726308;
13: swap_threshold=32'd1021409573;
14: swap_threshold=32'd914573030;
15: swap_threshold=32'd818911286;
16: swap_threshold=32'd733255489;
17: swap_threshold=32'd656559046;
18: swap_threshold=32'd587884832;
19: swap_threshold=32'd526393747;
20: swap_threshold=32'd471334455;
21: swap_threshold=32'd422034208;
22: swap_threshold=32'd377890628;
23: swap_threshold=32'd338364340;
24: swap_threshold=32'd302972390;
25: swap_threshold=32'd271282338;
26: swap_threshold=32'd242906975;
27: swap_threshold=32'd217499595;
28: swap_threshold=32'd194749754;
29: swap_threshold=32'd174379483;
30: swap_threshold=32'd156139883;
31: swap_threshold=32'd139808095;
32: swap_threshold=32'd125184565;
33: swap_threshold=32'd112090614;
34: swap_threshold=32'd100366254;
35: swap_threshold=32'd89868229;
36: swap_threshold=32'd80468267;
37: swap_threshold=32'd72051514;
38: swap_threshold=32'd64515130;
39: swap_threshold=32'd57767031;
40: swap_threshold=32'd51724763;
41: swap_threshold=32'd46314500;
42: swap_threshold=32'd41470134;
43: swap_threshold=32'd37132476;
44: swap_threshold=32'd33248524;
45: swap_threshold=32'd29770823;
46: swap_threshold=32'd26656879;
47: swap_threshold=32'd23868645;
48: swap_threshold=32'd21372053;
49: swap_threshold=32'd19136597;
50: swap_threshold=32'd17134963;
51: swap_threshold=32'd15342694;
52: swap_threshold=32'd13737892;
53: swap_threshold=32'd12300947;
54: swap_threshold=32'd11014303;
55: swap_threshold=32'd9862238;
56: swap_threshold=32'd8830676;
57: swap_threshold=32'd7907012;
58: swap_threshold=32'd7079961;
59: swap_threshold=32'd6339417;
60: swap_threshold=32'd5676332;
61: swap_threshold=32'd5082604;
62: swap_threshold=32'd4550978;
63: swap_threshold=32'd4074958;
64: swap_threshold=32'd3648729;
65: swap_threshold=32'd3267083;
66: swap_threshold=32'd2925355;
67: swap_threshold=32'd2619371;
68: swap_threshold=32'd2345392;
69: swap_threshold=32'd2100071;
70: swap_threshold=32'd1880409;
71: swap_threshold=32'd1683724;
72: swap_threshold=32'd1507611;
73: swap_threshold=32'd1349919;
74: swap_threshold=32'd1208721;
75: swap_threshold=32'd1082292;
76: swap_threshold=32'd969088;
77: swap_threshold=32'd867724;
78: swap_threshold=32'd776962;
79: swap_threshold=32'd695694;
80: swap_threshold=32'd622927;
81: swap_threshold=32'd557770;
82: swap_threshold=32'd499429;
83: swap_threshold=32'd447190;
84: swap_threshold=32'd400415;
85: swap_threshold=32'd358533;
86: swap_threshold=32'd321031;
87: swap_threshold=32'd287452;
88: swap_threshold=32'd257385;
89: swap_threshold=32'd230464;
90: swap_threshold=32'd206358;
91: swap_threshold=32'd184773;
92: swap_threshold=32'd165446;
93: swap_threshold=32'd148141;
94: swap_threshold=32'd132646;
95: swap_threshold=32'd118772;
96: swap_threshold=32'd106348;
97: swap_threshold=32'd95225;
98: swap_threshold=32'd85264;
99: swap_threshold=32'd76346;
100: swap_threshold=32'd68360;
101: swap_threshold=32'd61210;
102: swap_threshold=32'd54807;
103: swap_threshold=32'd49075;
104: swap_threshold=32'd43942;
105: swap_threshold=32'd39345;
106: swap_threshold=32'd35230;
107: swap_threshold=32'd31545;
108: swap_threshold=32'd28245;
109: swap_threshold=32'd25291;
110: swap_threshold=32'd22645;
111: swap_threshold=32'd20277;
112: swap_threshold=32'd18156;
113: swap_threshold=32'd16257;
114: swap_threshold=32'd14556;
115: swap_threshold=32'd13034;
116: swap_threshold=32'd11670;
117: swap_threshold=32'd10450;
118: swap_threshold=32'd9357;
119: swap_threshold=32'd8378;
120: swap_threshold=32'd7501;
121: swap_threshold=32'd6717;
122: swap_threshold=32'd6014;
123: swap_threshold=32'd5385;
124: swap_threshold=32'd4822;
125: swap_threshold=32'd4317;
126: swap_threshold=32'd3866;
127: swap_threshold=32'd3461;
128: swap_threshold=32'd3099;
129: swap_threshold=32'd2775;
130: swap_threshold=32'd2485;
131: swap_threshold=32'd2225;
132: swap_threshold=32'd1992;
133: swap_threshold=32'd1784;
134: swap_threshold=32'd1597;
135: swap_threshold=32'd1430;
136: swap_threshold=32'd1280;
137: swap_threshold=32'd1146;
138: swap_threshold=32'd1026;
139: swap_threshold=32'd919;
140: swap_threshold=32'd823;
141: swap_threshold=32'd737;
142: swap_threshold=32'd660;
143: swap_threshold=32'd591;
144: swap_threshold=32'd529;
145: swap_threshold=32'd473;
146: swap_threshold=32'd424;
147: swap_threshold=32'd379;
148: swap_threshold=32'd340;
149: swap_threshold=32'd304;
150: swap_threshold=32'd272;
151: swap_threshold=32'd244;
152: swap_threshold=32'd218;
153: swap_threshold=32'd195;
154: swap_threshold=32'd175;
155: swap_threshold=32'd156;
156: swap_threshold=32'd140;
157: swap_threshold=32'd125;
158: swap_threshold=32'd112;
159: swap_threshold=32'd100;
160: swap_threshold=32'd90;
161: swap_threshold=32'd80;
162: swap_threshold=32'd72;
163: swap_threshold=32'd64;
164: swap_threshold=32'd58;
165: swap_threshold=32'd52;
166: swap_threshold=32'd46;
167: swap_threshold=32'd41;
168: swap_threshold=32'd37;
169: swap_threshold=32'd33;
170: swap_threshold=32'd29;
171: swap_threshold=32'd26;
172: swap_threshold=32'd23;
173: swap_threshold=32'd21;
174: swap_threshold=32'd19;
175: swap_threshold=32'd17;
176: swap_threshold=32'd15;
177: swap_threshold=32'd13;
178: swap_threshold=32'd12;
179: swap_threshold=32'd11;
180: swap_threshold=32'd9;
181: swap_threshold=32'd8;
182: swap_threshold=32'd7;
183: swap_threshold=32'd7;
184: swap_threshold=32'd6;
185: swap_threshold=32'd5;
186: swap_threshold=32'd5;
187: swap_threshold=32'd4;
188: swap_threshold=32'd4;
189: swap_threshold=32'd3;
190: swap_threshold=32'd3;
191: swap_threshold=32'd2;
192: swap_threshold=32'd2;
193: swap_threshold=32'd2;
194: swap_threshold=32'd2;
195: swap_threshold=32'd1;
196: swap_threshold=32'd1;
197: swap_threshold=32'd1;
198: swap_threshold=32'd1;
199: swap_threshold=32'd1;
200: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
3: begin case(gap)
1: swap_threshold=32'd3784563553;
2: swap_threshold=32'd3334814982;
3: swap_threshold=32'd2938513466;
4: swap_threshold=32'd2589307484;
5: swap_threshold=32'd2281600314;
6: swap_threshold=32'd2010460336;
7: swap_threshold=32'd1771541990;
8: swap_threshold=32'd1561016135;
9: swap_threshold=32'd1375508674;
10: swap_threshold=32'd1212046480;
11: swap_threshold=32'd1068009747;
12: swap_threshold=32'd941089997;
13: swap_threshold=32'd829253090;
14: swap_threshold=32'd730706617;
15: swap_threshold=32'd643871173;
16: swap_threshold=32'd567355047;
17: swap_threshold=32'd499931917;
18: swap_threshold=32'd440521192;
19: swap_threshold=32'd388170696;
20: swap_threshold=32'd342041410;
21: swap_threshold=32'd301394019;
22: swap_threshold=32'd265577067;
23: swap_threshold=32'd234016517;
24: swap_threshold=32'd206206548;
25: swap_threshold=32'd181701450;
26: swap_threshold=32'd160108480;
27: swap_threshold=32'd141081568;
28: swap_threshold=32'd124315768;
29: swap_threshold=32'd109542377;
30: swap_threshold=32'd96524620;
31: swap_threshold=32'd85053863;
32: swap_threshold=32'd74946263;
33: swap_threshold=32'd66039826;
34: swap_threshold=32'd58191810;
35: swap_threshold=32'd51276433;
36: swap_threshold=32'd45182863;
37: swap_threshold=32'd39813438;
38: swap_threshold=32'd35082104;
39: swap_threshold=32'd30913029;
40: swap_threshold=32'd27239398;
41: swap_threshold=32'd24002333;
42: swap_threshold=32'd21149952;
43: swap_threshold=32'd18636542;
44: swap_threshold=32'd16421819;
45: swap_threshold=32'd14470289;
46: swap_threshold=32'd12750674;
47: swap_threshold=32'd11235414;
48: swap_threshold=32'd9900224;
49: swap_threshold=32'd8723705;
50: swap_threshold=32'd7687000;
51: swap_threshold=32'd6773495;
52: swap_threshold=32'd5968549;
53: swap_threshold=32'd5259261;
54: swap_threshold=32'd4634263;
55: swap_threshold=32'd4083538;
56: swap_threshold=32'd3598260;
57: swap_threshold=32'd3170651;
58: swap_threshold=32'd2793858;
59: swap_threshold=32'd2461843;
60: swap_threshold=32'd2169283;
61: swap_threshold=32'd1911491;
62: swap_threshold=32'd1684334;
63: swap_threshold=32'd1484171;
64: swap_threshold=32'd1307796;
65: swap_threshold=32'd1152380;
66: swap_threshold=32'd1015434;
67: swap_threshold=32'd894762;
68: swap_threshold=32'd788431;
69: swap_threshold=32'd694736;
70: swap_threshold=32'd612175;
71: swap_threshold=32'd539425;
72: swap_threshold=32'd475321;
73: swap_threshold=32'd418835;
74: swap_threshold=32'd369062;
75: swap_threshold=32'd325203;
76: swap_threshold=32'd286557;
77: swap_threshold=32'd252503;
78: swap_threshold=32'd222496;
79: swap_threshold=32'd196055;
80: swap_threshold=32'd172756;
81: swap_threshold=32'd152226;
82: swap_threshold=32'd134136;
83: swap_threshold=32'd118196;
84: swap_threshold=32'd104149;
85: swap_threshold=32'd91772;
86: swap_threshold=32'd80866;
87: swap_threshold=32'd71256;
88: swap_threshold=32'd62788;
89: swap_threshold=32'd55327;
90: swap_threshold=32'd48752;
91: swap_threshold=32'd42958;
92: swap_threshold=32'd37853;
93: swap_threshold=32'd33355;
94: swap_threshold=32'd29391;
95: swap_threshold=32'd25898;
96: swap_threshold=32'd22820;
97: swap_threshold=32'd20108;
98: swap_threshold=32'd17719;
99: swap_threshold=32'd15613;
100: swap_threshold=32'd13757;
101: swap_threshold=32'd12122;
102: swap_threshold=32'd10682;
103: swap_threshold=32'd9412;
104: swap_threshold=32'd8294;
105: swap_threshold=32'd7308;
106: swap_threshold=32'd6440;
107: swap_threshold=32'd5674;
108: swap_threshold=32'd5000;
109: swap_threshold=32'd4406;
110: swap_threshold=32'd3882;
111: swap_threshold=32'd3421;
112: swap_threshold=32'd3014;
113: swap_threshold=32'd2656;
114: swap_threshold=32'd2340;
115: swap_threshold=32'd2062;
116: swap_threshold=32'd1817;
117: swap_threshold=32'd1601;
118: swap_threshold=32'd1411;
119: swap_threshold=32'd1243;
120: swap_threshold=32'd1095;
121: swap_threshold=32'd965;
122: swap_threshold=32'd850;
123: swap_threshold=32'd749;
124: swap_threshold=32'd660;
125: swap_threshold=32'd582;
126: swap_threshold=32'd512;
127: swap_threshold=32'd451;
128: swap_threshold=32'd398;
129: swap_threshold=32'd350;
130: swap_threshold=32'd309;
131: swap_threshold=32'd272;
132: swap_threshold=32'd240;
133: swap_threshold=32'd211;
134: swap_threshold=32'd186;
135: swap_threshold=32'd164;
136: swap_threshold=32'd144;
137: swap_threshold=32'd127;
138: swap_threshold=32'd112;
139: swap_threshold=32'd99;
140: swap_threshold=32'd87;
141: swap_threshold=32'd76;
142: swap_threshold=32'd67;
143: swap_threshold=32'd59;
144: swap_threshold=32'd52;
145: swap_threshold=32'd46;
146: swap_threshold=32'd40;
147: swap_threshold=32'd35;
148: swap_threshold=32'd31;
149: swap_threshold=32'd27;
150: swap_threshold=32'd24;
151: swap_threshold=32'd21;
152: swap_threshold=32'd19;
153: swap_threshold=32'd16;
154: swap_threshold=32'd14;
155: swap_threshold=32'd13;
156: swap_threshold=32'd11;
157: swap_threshold=32'd10;
158: swap_threshold=32'd8;
159: swap_threshold=32'd7;
160: swap_threshold=32'd6;
161: swap_threshold=32'd6;
162: swap_threshold=32'd5;
163: swap_threshold=32'd4;
164: swap_threshold=32'd4;
165: swap_threshold=32'd3;
166: swap_threshold=32'd3;
167: swap_threshold=32'd2;
168: swap_threshold=32'd2;
169: swap_threshold=32'd2;
170: swap_threshold=32'd1;
171: swap_threshold=32'd1;
172: swap_threshold=32'd1;
173: swap_threshold=32'd1;
174: swap_threshold=32'd1;
175: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
4: begin case(gap)
1: swap_threshold=32'd3767037873;
2: swap_threshold=32'd3304000556;
3: swap_threshold=32'd2897878929;
4: swap_threshold=32'd2541677020;
5: swap_threshold=32'd2229258789;
6: swap_threshold=32'd1955242429;
7: swap_threshold=32'd1714907652;
8: swap_threshold=32'd1504114380;
9: swap_threshold=32'd1319231427;
10: swap_threshold=32'd1157073944;
11: swap_threshold=32'd1014848559;
12: swap_threshold=32'd890105254;
13: swap_threshold=32'd780695165;
14: swap_threshold=32'd684733562;
15: swap_threshold=32'd600567381;
16: swap_threshold=32'd526746751;
17: swap_threshold=32'd462000016;
18: swap_threshold=32'd405211830;
19: swap_threshold=32'd355403942;
20: swap_threshold=32'd311718348;
21: swap_threshold=32'd273402506;
22: swap_threshold=32'd239796377;
23: swap_threshold=32'd210321050;
24: swap_threshold=32'd184468776;
25: swap_threshold=32'd161794216;
26: swap_threshold=32'd141906771;
27: swap_threshold=32'd124463853;
28: swap_threshold=32'd109164987;
29: swap_threshold=32'd95746629;
30: swap_threshold=32'd83977631;
31: swap_threshold=32'd73655256;
32: swap_threshold=32'd64601688;
33: swap_threshold=32'd56660968;
34: swap_threshold=32'd49696307;
35: swap_threshold=32'd43587729;
36: swap_threshold=32'd38230006;
37: swap_threshold=32'd33530844;
38: swap_threshold=32'd29409295;
39: swap_threshold=32'd25794359;
40: swap_threshold=32'd22623764;
41: swap_threshold=32'd19842893;
42: swap_threshold=32'd17403841;
43: swap_threshold=32'd15264593;
44: swap_threshold=32'd13388298;
45: swap_threshold=32'd11742633;
46: swap_threshold=32'd10299250;
47: swap_threshold=32'd9033285;
48: swap_threshold=32'd7922931;
49: swap_threshold=32'd6949059;
50: swap_threshold=32'd6094893;
51: swap_threshold=32'd5345720;
52: swap_threshold=32'd4688634;
53: swap_threshold=32'd4112316;
54: swap_threshold=32'd3606837;
55: swap_threshold=32'd3163492;
56: swap_threshold=32'd2774641;
57: swap_threshold=32'd2433587;
58: swap_threshold=32'd2134455;
59: swap_threshold=32'd1872092;
60: swap_threshold=32'd1641978;
61: swap_threshold=32'd1440149;
62: swap_threshold=32'd1263128;
63: swap_threshold=32'd1107867;
64: swap_threshold=32'd971690;
65: swap_threshold=32'd852251;
66: swap_threshold=32'd747494;
67: swap_threshold=32'd655614;
68: swap_threshold=32'd575027;
69: swap_threshold=32'd504345;
70: swap_threshold=32'd442352;
71: swap_threshold=32'd387979;
72: swap_threshold=32'd340289;
73: swap_threshold=32'd298461;
74: swap_threshold=32'd261775;
75: swap_threshold=32'd229598;
76: swap_threshold=32'd201376;
77: swap_threshold=32'd176623;
78: swap_threshold=32'd154913;
79: swap_threshold=32'd135871;
80: swap_threshold=32'd119170;
81: swap_threshold=32'd104522;
82: swap_threshold=32'd91674;
83: swap_threshold=32'd80406;
84: swap_threshold=32'd70522;
85: swap_threshold=32'd61854;
86: swap_threshold=32'd54251;
87: swap_threshold=32'd47582;
88: swap_threshold=32'd41734;
89: swap_threshold=32'd36604;
90: swap_threshold=32'd32104;
91: swap_threshold=32'd28158;
92: swap_threshold=32'd24697;
93: swap_threshold=32'd21661;
94: swap_threshold=32'd18999;
95: swap_threshold=32'd16663;
96: swap_threshold=32'd14615;
97: swap_threshold=32'd12818;
98: swap_threshold=32'd11243;
99: swap_threshold=32'd9861;
100: swap_threshold=32'd8649;
101: swap_threshold=32'd7585;
102: swap_threshold=32'd6653;
103: swap_threshold=32'd5835;
104: swap_threshold=32'd5118;
105: swap_threshold=32'd4489;
106: swap_threshold=32'd3937;
107: swap_threshold=32'd3453;
108: swap_threshold=32'd3028;
109: swap_threshold=32'd2656;
110: swap_threshold=32'd2330;
111: swap_threshold=32'd2043;
112: swap_threshold=32'd1792;
113: swap_threshold=32'd1572;
114: swap_threshold=32'd1378;
115: swap_threshold=32'd1209;
116: swap_threshold=32'd1060;
117: swap_threshold=32'd930;
118: swap_threshold=32'd816;
119: swap_threshold=32'd715;
120: swap_threshold=32'd627;
121: swap_threshold=32'd550;
122: swap_threshold=32'd482;
123: swap_threshold=32'd423;
124: swap_threshold=32'd371;
125: swap_threshold=32'd325;
126: swap_threshold=32'd285;
127: swap_threshold=32'd250;
128: swap_threshold=32'd219;
129: swap_threshold=32'd192;
130: swap_threshold=32'd169;
131: swap_threshold=32'd148;
132: swap_threshold=32'd130;
133: swap_threshold=32'd114;
134: swap_threshold=32'd100;
135: swap_threshold=32'd87;
136: swap_threshold=32'd76;
137: swap_threshold=32'd67;
138: swap_threshold=32'd59;
139: swap_threshold=32'd51;
140: swap_threshold=32'd45;
141: swap_threshold=32'd39;
142: swap_threshold=32'd35;
143: swap_threshold=32'd30;
144: swap_threshold=32'd26;
145: swap_threshold=32'd23;
146: swap_threshold=32'd20;
147: swap_threshold=32'd18;
148: swap_threshold=32'd15;
149: swap_threshold=32'd13;
150: swap_threshold=32'd12;
151: swap_threshold=32'd10;
152: swap_threshold=32'd9;
153: swap_threshold=32'd8;
154: swap_threshold=32'd7;
155: swap_threshold=32'd6;
156: swap_threshold=32'd5;
157: swap_threshold=32'd4;
158: swap_threshold=32'd4;
159: swap_threshold=32'd3;
160: swap_threshold=32'd3;
161: swap_threshold=32'd2;
162: swap_threshold=32'd2;
163: swap_threshold=32'd2;
164: swap_threshold=32'd1;
165: swap_threshold=32'd1;
166: swap_threshold=32'd1;
167: swap_threshold=32'd1;
168: swap_threshold=32'd1;
169: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
5: begin case(gap)
1: swap_threshold=32'd3757980339;
2: swap_threshold=32'd3288131261;
3: swap_threshold=32'd2877026013;
4: swap_threshold=32'd2517320028;
5: swap_threshold=32'd2202587010;
6: swap_threshold=32'd1927204123;
7: swap_threshold=32'd1686251537;
8: swap_threshold=32'd1475424535;
9: swap_threshold=32'd1290956604;
10: swap_threshold=32'd1129552148;
11: swap_threshold=32'd988327611;
12: swap_threshold=32'd864759956;
13: swap_threshold=32'd756641597;
14: swap_threshold=32'd662040954;
15: swap_threshold=32'd579267947;
16: swap_threshold=32'd506843803;
17: swap_threshold=32'd443474633;
18: swap_threshold=32'd388028322;
19: swap_threshold=32'd339514298;
20: swap_threshold=32'd297065837;
21: swap_threshold=32'd259924581;
22: swap_threshold=32'd227426986;
23: swap_threshold=32'd198992468;
24: swap_threshold=32'd174113033;
25: swap_threshold=32'd152344199;
26: swap_threshold=32'd133297058;
27: swap_threshold=32'd116631324;
28: swap_threshold=32'd102049257;
29: swap_threshold=32'd89290343;
30: swap_threshold=32'd78126638;
31: swap_threshold=32'd68358697;
32: swap_threshold=32'd59812013;
33: swap_threshold=32'd52333895;
34: swap_threshold=32'd45790744;
35: swap_threshold=32'd40065664;
36: swap_threshold=32'd35056373;
37: swap_threshold=32'd30673379;
38: swap_threshold=32'd26838378;
39: swap_threshold=32'd23482856;
40: swap_threshold=32'd20546864;
41: swap_threshold=32'd17977951;
42: swap_threshold=32'd15730221;
43: swap_threshold=32'd13763519;
44: swap_threshold=32'd12042707;
45: swap_threshold=32'd10537043;
46: swap_threshold=32'd9219628;
47: swap_threshold=32'd8066925;
48: swap_threshold=32'd7058342;
49: swap_threshold=32'd6175858;
50: swap_threshold=32'd5403709;
51: swap_threshold=32'd4728099;
52: swap_threshold=32'd4136959;
53: swap_threshold=32'd3619727;
54: swap_threshold=32'd3167164;
55: swap_threshold=32'd2771182;
56: swap_threshold=32'd2424710;
57: swap_threshold=32'd2121555;
58: swap_threshold=32'd1856304;
59: swap_threshold=32'd1624215;
60: swap_threshold=32'd1421145;
61: swap_threshold=32'd1243463;
62: swap_threshold=32'd1087996;
63: swap_threshold=32'd951967;
64: swap_threshold=32'd832946;
65: swap_threshold=32'd728805;
66: swap_threshold=32'd637685;
67: swap_threshold=32'd557957;
68: swap_threshold=32'd488197;
69: swap_threshold=32'd427159;
70: swap_threshold=32'd373753;
71: swap_threshold=32'd327023;
72: swap_threshold=32'd286137;
73: swap_threshold=32'd250362;
74: swap_threshold=32'd219060;
75: swap_threshold=32'd191671;
76: swap_threshold=32'd167707;
77: swap_threshold=32'd146739;
78: swap_threshold=32'd128393;
79: swap_threshold=32'd112340;
80: swap_threshold=32'd98294;
81: swap_threshold=32'd86005;
82: swap_threshold=32'd75252;
83: swap_threshold=32'd65843;
84: swap_threshold=32'd57611;
85: swap_threshold=32'd50408;
86: swap_threshold=32'd44106;
87: swap_threshold=32'd38591;
88: swap_threshold=32'd33766;
89: swap_threshold=32'd29544;
90: swap_threshold=32'd25851;
91: swap_threshold=32'd22618;
92: swap_threshold=32'd19790;
93: swap_threshold=32'd17316;
94: swap_threshold=32'd15151;
95: swap_threshold=32'd13257;
96: swap_threshold=32'd11599;
97: swap_threshold=32'd10149;
98: swap_threshold=32'd8880;
99: swap_threshold=32'd7770;
100: swap_threshold=32'd6798;
101: swap_threshold=32'd5948;
102: swap_threshold=32'd5204;
103: swap_threshold=32'd4554;
104: swap_threshold=32'd3984;
105: swap_threshold=32'd3486;
106: swap_threshold=32'd3050;
107: swap_threshold=32'd2669;
108: swap_threshold=32'd2335;
109: swap_threshold=32'd2043;
110: swap_threshold=32'd1788;
111: swap_threshold=32'd1564;
112: swap_threshold=32'd1368;
113: swap_threshold=32'd1197;
114: swap_threshold=32'd1047;
115: swap_threshold=32'd916;
116: swap_threshold=32'd802;
117: swap_threshold=32'd701;
118: swap_threshold=32'd614;
119: swap_threshold=32'd537;
120: swap_threshold=32'd470;
121: swap_threshold=32'd411;
122: swap_threshold=32'd360;
123: swap_threshold=32'd314;
124: swap_threshold=32'd275;
125: swap_threshold=32'd241;
126: swap_threshold=32'd211;
127: swap_threshold=32'd184;
128: swap_threshold=32'd161;
129: swap_threshold=32'd141;
130: swap_threshold=32'd123;
131: swap_threshold=32'd108;
132: swap_threshold=32'd94;
133: swap_threshold=32'd82;
134: swap_threshold=32'd72;
135: swap_threshold=32'd63;
136: swap_threshold=32'd55;
137: swap_threshold=32'd48;
138: swap_threshold=32'd42;
139: swap_threshold=32'd37;
140: swap_threshold=32'd32;
141: swap_threshold=32'd28;
142: swap_threshold=32'd24;
143: swap_threshold=32'd21;
144: swap_threshold=32'd19;
145: swap_threshold=32'd16;
146: swap_threshold=32'd14;
147: swap_threshold=32'd12;
148: swap_threshold=32'd11;
149: swap_threshold=32'd9;
150: swap_threshold=32'd8;
151: swap_threshold=32'd7;
152: swap_threshold=32'd6;
153: swap_threshold=32'd5;
154: swap_threshold=32'd5;
155: swap_threshold=32'd4;
156: swap_threshold=32'd3;
157: swap_threshold=32'd3;
158: swap_threshold=32'd2;
159: swap_threshold=32'd2;
160: swap_threshold=32'd2;
161: swap_threshold=32'd1;
162: swap_threshold=32'd1;
163: swap_threshold=32'd1;
164: swap_threshold=32'd1;
165: swap_threshold=32'd1;
166: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
6: begin case(gap)
1: swap_threshold=32'd3616995779;
2: swap_threshold=32'd3046043792;
3: swap_threshold=32'd2565218029;
4: swap_threshold=32'd2160291836;
5: swap_threshold=32'd1819284272;
6: swap_threshold=32'd1532105621;
7: swap_threshold=32'd1290258850;
8: swap_threshold=32'd1086588207;
9: swap_threshold=32'd915067494;
10: swap_threshold=32'd770621762;
11: swap_threshold=32'd648977156;
12: swap_threshold=32'd546534460;
13: swap_threshold=32'd460262605;
14: swap_threshold=32'd387608981;
15: swap_threshold=32'd326423917;
16: swap_threshold=32'd274897071;
17: swap_threshold=32'd231503869;
18: swap_threshold=32'd194960394;
19: swap_threshold=32'd164185400;
20: swap_threshold=32'd138268317;
21: swap_threshold=32'd116442311;
22: swap_threshold=32'd98061596;
23: swap_threshold=32'd82582323;
24: swap_threshold=32'd69546493;
25: swap_threshold=32'd58568402;
26: swap_threshold=32'd49323231;
27: swap_threshold=32'd41537433;
28: swap_threshold=32'd34980644;
29: swap_threshold=32'd29458860;
30: swap_threshold=32'd24808704;
31: swap_threshold=32'd20892587;
32: swap_threshold=32'd17594639;
33: swap_threshold=32'd14817280;
34: swap_threshold=32'd12478335;
35: swap_threshold=32'd10508598;
36: swap_threshold=32'd8849789;
37: swap_threshold=32'd7452827;
38: swap_threshold=32'd6276379;
39: swap_threshold=32'd5285637;
40: swap_threshold=32'd4451285;
41: swap_threshold=32'd3748639;
42: swap_threshold=32'd3156906;
43: swap_threshold=32'd2658581;
44: swap_threshold=32'd2238917;
45: swap_threshold=32'd1885498;
46: swap_threshold=32'd1587867;
47: swap_threshold=32'd1337218;
48: swap_threshold=32'd1126135;
49: swap_threshold=32'd948372;
50: swap_threshold=32'd798669;
51: swap_threshold=32'd672597;
52: swap_threshold=32'd566426;
53: swap_threshold=32'd477014;
54: swap_threshold=32'd401716;
55: swap_threshold=32'd338304;
56: swap_threshold=32'd284902;
57: swap_threshold=32'd239929;
58: swap_threshold=32'd202056;
59: swap_threshold=32'd170161;
60: swap_threshold=32'd143300;
61: swap_threshold=32'd120680;
62: swap_threshold=32'd101630;
63: swap_threshold=32'd85587;
64: swap_threshold=32'd72077;
65: swap_threshold=32'd60700;
66: swap_threshold=32'd51118;
67: swap_threshold=32'd43049;
68: swap_threshold=32'd36253;
69: swap_threshold=32'd30531;
70: swap_threshold=32'd25711;
71: swap_threshold=32'd21652;
72: swap_threshold=32'd18235;
73: swap_threshold=32'd15356;
74: swap_threshold=32'd12932;
75: swap_threshold=32'd10891;
76: swap_threshold=32'd9171;
77: swap_threshold=32'd7724;
78: swap_threshold=32'd6504;
79: swap_threshold=32'd5478;
80: swap_threshold=32'd4613;
81: swap_threshold=32'd3885;
82: swap_threshold=32'd3271;
83: swap_threshold=32'd2755;
84: swap_threshold=32'd2320;
85: swap_threshold=32'd1954;
86: swap_threshold=32'd1645;
87: swap_threshold=32'd1385;
88: swap_threshold=32'd1167;
89: swap_threshold=32'd982;
90: swap_threshold=32'd827;
91: swap_threshold=32'd697;
92: swap_threshold=32'd587;
93: swap_threshold=32'd494;
94: swap_threshold=32'd416;
95: swap_threshold=32'd350;
96: swap_threshold=32'd295;
97: swap_threshold=32'd248;
98: swap_threshold=32'd209;
99: swap_threshold=32'd176;
100: swap_threshold=32'd148;
101: swap_threshold=32'd125;
102: swap_threshold=32'd105;
103: swap_threshold=32'd88;
104: swap_threshold=32'd74;
105: swap_threshold=32'd62;
106: swap_threshold=32'd52;
107: swap_threshold=32'd44;
108: swap_threshold=32'd37;
109: swap_threshold=32'd31;
110: swap_threshold=32'd26;
111: swap_threshold=32'd22;
112: swap_threshold=32'd18;
113: swap_threshold=32'd15;
114: swap_threshold=32'd13;
115: swap_threshold=32'd11;
116: swap_threshold=32'd9;
117: swap_threshold=32'd8;
118: swap_threshold=32'd6;
119: swap_threshold=32'd5;
120: swap_threshold=32'd4;
121: swap_threshold=32'd4;
122: swap_threshold=32'd3;
123: swap_threshold=32'd2;
124: swap_threshold=32'd2;
125: swap_threshold=32'd2;
126: swap_threshold=32'd1;
127: swap_threshold=32'd1;
128: swap_threshold=32'd1;
129: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
7: begin case(gap)
1: swap_threshold=32'd3616995779;
2: swap_threshold=32'd3046043792;
3: swap_threshold=32'd2565218029;
4: swap_threshold=32'd2160291836;
5: swap_threshold=32'd1819284272;
6: swap_threshold=32'd1532105621;
7: swap_threshold=32'd1290258850;
8: swap_threshold=32'd1086588207;
9: swap_threshold=32'd915067494;
10: swap_threshold=32'd770621762;
11: swap_threshold=32'd648977156;
12: swap_threshold=32'd546534460;
13: swap_threshold=32'd460262605;
14: swap_threshold=32'd387608981;
15: swap_threshold=32'd326423917;
16: swap_threshold=32'd274897071;
17: swap_threshold=32'd231503869;
18: swap_threshold=32'd194960394;
19: swap_threshold=32'd164185400;
20: swap_threshold=32'd138268317;
21: swap_threshold=32'd116442311;
22: swap_threshold=32'd98061596;
23: swap_threshold=32'd82582323;
24: swap_threshold=32'd69546493;
25: swap_threshold=32'd58568402;
26: swap_threshold=32'd49323231;
27: swap_threshold=32'd41537433;
28: swap_threshold=32'd34980644;
29: swap_threshold=32'd29458860;
30: swap_threshold=32'd24808704;
31: swap_threshold=32'd20892587;
32: swap_threshold=32'd17594639;
33: swap_threshold=32'd14817280;
34: swap_threshold=32'd12478335;
35: swap_threshold=32'd10508598;
36: swap_threshold=32'd8849789;
37: swap_threshold=32'd7452827;
38: swap_threshold=32'd6276379;
39: swap_threshold=32'd5285637;
40: swap_threshold=32'd4451285;
41: swap_threshold=32'd3748639;
42: swap_threshold=32'd3156906;
43: swap_threshold=32'd2658581;
44: swap_threshold=32'd2238917;
45: swap_threshold=32'd1885498;
46: swap_threshold=32'd1587867;
47: swap_threshold=32'd1337218;
48: swap_threshold=32'd1126135;
49: swap_threshold=32'd948372;
50: swap_threshold=32'd798669;
51: swap_threshold=32'd672597;
52: swap_threshold=32'd566426;
53: swap_threshold=32'd477014;
54: swap_threshold=32'd401716;
55: swap_threshold=32'd338304;
56: swap_threshold=32'd284902;
57: swap_threshold=32'd239929;
58: swap_threshold=32'd202056;
59: swap_threshold=32'd170161;
60: swap_threshold=32'd143300;
61: swap_threshold=32'd120680;
62: swap_threshold=32'd101630;
63: swap_threshold=32'd85587;
64: swap_threshold=32'd72077;
65: swap_threshold=32'd60700;
66: swap_threshold=32'd51118;
67: swap_threshold=32'd43049;
68: swap_threshold=32'd36253;
69: swap_threshold=32'd30531;
70: swap_threshold=32'd25711;
71: swap_threshold=32'd21652;
72: swap_threshold=32'd18235;
73: swap_threshold=32'd15356;
74: swap_threshold=32'd12932;
75: swap_threshold=32'd10891;
76: swap_threshold=32'd9171;
77: swap_threshold=32'd7724;
78: swap_threshold=32'd6504;
79: swap_threshold=32'd5478;
80: swap_threshold=32'd4613;
81: swap_threshold=32'd3885;
82: swap_threshold=32'd3271;
83: swap_threshold=32'd2755;
84: swap_threshold=32'd2320;
85: swap_threshold=32'd1954;
86: swap_threshold=32'd1645;
87: swap_threshold=32'd1385;
88: swap_threshold=32'd1167;
89: swap_threshold=32'd982;
90: swap_threshold=32'd827;
91: swap_threshold=32'd697;
92: swap_threshold=32'd587;
93: swap_threshold=32'd494;
94: swap_threshold=32'd416;
95: swap_threshold=32'd350;
96: swap_threshold=32'd295;
97: swap_threshold=32'd248;
98: swap_threshold=32'd209;
99: swap_threshold=32'd176;
100: swap_threshold=32'd148;
101: swap_threshold=32'd125;
102: swap_threshold=32'd105;
103: swap_threshold=32'd88;
104: swap_threshold=32'd74;
105: swap_threshold=32'd62;
106: swap_threshold=32'd52;
107: swap_threshold=32'd44;
108: swap_threshold=32'd37;
109: swap_threshold=32'd31;
110: swap_threshold=32'd26;
111: swap_threshold=32'd22;
112: swap_threshold=32'd18;
113: swap_threshold=32'd15;
114: swap_threshold=32'd13;
115: swap_threshold=32'd11;
116: swap_threshold=32'd9;
117: swap_threshold=32'd8;
118: swap_threshold=32'd6;
119: swap_threshold=32'd5;
120: swap_threshold=32'd4;
121: swap_threshold=32'd4;
122: swap_threshold=32'd3;
123: swap_threshold=32'd2;
124: swap_threshold=32'd2;
125: swap_threshold=32'd2;
126: swap_threshold=32'd1;
127: swap_threshold=32'd1;
128: swap_threshold=32'd1;
129: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
8: begin case(gap)
1: swap_threshold=32'd3334030107;
2: swap_threshold=32'd2588088800;
3: swap_threshold=32'd2009041137;
4: swap_threshold=32'd1559547065;
5: swap_threshold=32'd1210620829;
6: swap_threshold=32'd939761822;
7: swap_threshold=32'd729503624;
8: swap_threshold=32'd566287676;
9: swap_threshold=32'd439588949;
10: swap_threshold=32'd341237241;
11: swap_threshold=32'd264890314;
12: swap_threshold=32'd205624914;
13: swap_threshold=32'd159619295;
14: swap_threshold=32'd123906773;
15: swap_threshold=32'd96184413;
16: swap_threshold=32'd74664534;
17: swap_threshold=32'd57959417;
18: swap_threshold=32'd44991831;
19: swap_threshold=32'd34925555;
20: swap_threshold=32'd27111464;
21: swap_threshold=32'd21045664;
22: swap_threshold=32'd16336999;
23: swap_threshold=32'd12681830;
24: swap_threshold=32'd9844453;
25: swap_threshold=32'd7641898;
26: swap_threshold=32'd5932133;
27: swap_threshold=32'd4604903;
28: swap_threshold=32'd3574622;
29: swap_threshold=32'd2774852;
30: swap_threshold=32'd2154019;
31: swap_threshold=32'd1672088;
32: swap_threshold=32'd1297982;
33: swap_threshold=32'd1007577;
34: swap_threshold=32'd782146;
35: swap_threshold=32'd607152;
36: swap_threshold=32'd471310;
37: swap_threshold=32'd365861;
38: swap_threshold=32'd284005;
39: swap_threshold=32'd220463;
40: swap_threshold=32'd171137;
41: swap_threshold=32'd132848;
42: swap_threshold=32'd103125;
43: swap_threshold=32'd80052;
44: swap_threshold=32'd62141;
45: swap_threshold=32'd48238;
46: swap_threshold=32'd37445;
47: swap_threshold=32'd29067;
48: swap_threshold=32'd22564;
49: swap_threshold=32'd17515;
50: swap_threshold=32'd13596;
51: swap_threshold=32'd10554;
52: swap_threshold=32'd8193;
53: swap_threshold=32'd6360;
54: swap_threshold=32'd4937;
55: swap_threshold=32'd3832;
56: swap_threshold=32'd2975;
57: swap_threshold=32'd2309;
58: swap_threshold=32'd1792;
59: swap_threshold=32'd1391;
60: swap_threshold=32'd1080;
61: swap_threshold=32'd838;
62: swap_threshold=32'd650;
63: swap_threshold=32'd505;
64: swap_threshold=32'd392;
65: swap_threshold=32'd304;
66: swap_threshold=32'd236;
67: swap_threshold=32'd183;
68: swap_threshold=32'd142;
69: swap_threshold=32'd110;
70: swap_threshold=32'd85;
71: swap_threshold=32'd66;
72: swap_threshold=32'd51;
73: swap_threshold=32'd40;
74: swap_threshold=32'd31;
75: swap_threshold=32'd24;
76: swap_threshold=32'd18;
77: swap_threshold=32'd14;
78: swap_threshold=32'd11;
79: swap_threshold=32'd8;
80: swap_threshold=32'd6;
81: swap_threshold=32'd5;
82: swap_threshold=32'd4;
83: swap_threshold=32'd3;
84: swap_threshold=32'd2;
85: swap_threshold=32'd1;
86: swap_threshold=32'd1;
87: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
9: begin case(gap)
1: swap_threshold=32'd3082983459;
2: swap_threshold=32'd2213005676;
3: swap_threshold=32'd1588524295;
4: swap_threshold=32'd1140263426;
5: swap_threshold=32'd818495937;
6: swap_threshold=32'd587527043;
7: swap_threshold=32'd421734563;
8: swap_threshold=32'd302726561;
9: swap_threshold=32'd217301068;
10: swap_threshold=32'd155981536;
11: swap_threshold=32'd111965578;
12: swap_threshold=32'd80370350;
13: swap_threshold=32'd57690884;
14: swap_threshold=32'd41411267;
15: swap_threshold=32'd29725547;
16: swap_threshold=32'd21337385;
17: swap_threshold=32'd15316252;
18: swap_threshold=32'd10994205;
19: swap_threshold=32'd7891784;
20: swap_threshold=32'd5664825;
21: swap_threshold=32'd4066285;
22: swap_threshold=32'd2918832;
23: swap_threshold=32'd2095176;
24: swap_threshold=32'd1503944;
25: swap_threshold=32'd1079551;
26: swap_threshold=32'd774915;
27: swap_threshold=32'd556244;
28: swap_threshold=32'd399279;
29: swap_threshold=32'd286608;
30: swap_threshold=32'd205731;
31: swap_threshold=32'd147676;
32: swap_threshold=32'd106004;
33: swap_threshold=32'd76091;
34: swap_threshold=32'd54619;
35: swap_threshold=32'd39206;
36: swap_threshold=32'd28142;
37: swap_threshold=32'd20201;
38: swap_threshold=32'd14500;
39: swap_threshold=32'd10408;
40: swap_threshold=32'd7471;
41: swap_threshold=32'd5363;
42: swap_threshold=32'd3849;
43: swap_threshold=32'd2763;
44: swap_threshold=32'd1983;
45: swap_threshold=32'd1423;
46: swap_threshold=32'd1022;
47: swap_threshold=32'd733;
48: swap_threshold=32'd526;
49: swap_threshold=32'd378;
50: swap_threshold=32'd271;
51: swap_threshold=32'd194;
52: swap_threshold=32'd139;
53: swap_threshold=32'd100;
54: swap_threshold=32'd72;
55: swap_threshold=32'd51;
56: swap_threshold=32'd37;
57: swap_threshold=32'd26;
58: swap_threshold=32'd19;
59: swap_threshold=32'd13;
60: swap_threshold=32'd9;
61: swap_threshold=32'd7;
62: swap_threshold=32'd5;
63: swap_threshold=32'd3;
64: swap_threshold=32'd2;
65: swap_threshold=32'd1;
66: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
10: begin case(gap)
1: swap_threshold=32'd2731675859;
2: swap_threshold=32'd1737394603;
3: swap_threshold=32'd1105013977;
4: swap_threshold=32'd702808612;
5: swap_threshold=32'd446998821;
6: swap_threshold=32'd284299228;
7: swap_threshold=32'd180819383;
8: swap_threshold=32'd115004355;
9: swap_threshold=32'd73144822;
10: swap_threshold=32'd46521412;
11: swap_threshold=32'd29588448;
12: swap_threshold=32'd18818781;
13: swap_threshold=32'd11969080;
14: swap_threshold=32'd7612549;
15: swap_threshold=32'd4841717;
16: swap_threshold=32'd3079418;
17: swap_threshold=32'd1958565;
18: swap_threshold=32'd1245682;
19: swap_threshold=32'd792276;
20: swap_threshold=32'd503901;
21: swap_threshold=32'd320490;
22: swap_threshold=32'd203837;
23: swap_threshold=32'd129644;
24: swap_threshold=32'd82456;
25: swap_threshold=32'd52443;
26: swap_threshold=32'd33355;
27: swap_threshold=32'd21214;
28: swap_threshold=32'd13492;
29: swap_threshold=32'd8581;
30: swap_threshold=32'd5458;
31: swap_threshold=32'd3471;
32: swap_threshold=32'd2207;
33: swap_threshold=32'd1404;
34: swap_threshold=32'd893;
35: swap_threshold=32'd568;
36: swap_threshold=32'd361;
37: swap_threshold=32'd229;
38: swap_threshold=32'd146;
39: swap_threshold=32'd92;
40: swap_threshold=32'd59;
41: swap_threshold=32'd37;
42: swap_threshold=32'd23;
43: swap_threshold=32'd15;
44: swap_threshold=32'd9;
45: swap_threshold=32'd6;
46: swap_threshold=32'd3;
47: swap_threshold=32'd2;
48: swap_threshold=32'd1;
49: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
11: begin case(gap)
1: swap_threshold=32'd2515055762;
2: swap_threshold=32'd1472771514;
3: swap_threshold=32'd862428565;
4: swap_threshold=32'd505022689;
5: swap_threshold=32'd295732222;
6: swap_threshold=32'd173175481;
7: swap_threshold=32'd101408453;
8: swap_threshold=32'd59382970;
9: swap_threshold=32'd34773601;
10: swap_threshold=32'd20362797;
11: swap_threshold=32'd11924088;
12: swap_threshold=32'd6982532;
13: swap_threshold=32'd4088845;
14: swap_threshold=32'd2394354;
15: swap_threshold=32'd1402091;
16: swap_threshold=32'd821039;
17: swap_threshold=32'd480785;
18: swap_threshold=32'd281539;
19: swap_threshold=32'd164864;
20: swap_threshold=32'd96541;
21: swap_threshold=32'd56533;
22: swap_threshold=32'd33104;
23: swap_threshold=32'd19385;
24: swap_threshold=32'd11351;
25: swap_threshold=32'd6647;
26: swap_threshold=32'd3892;
27: swap_threshold=32'd2279;
28: swap_threshold=32'd1334;
29: swap_threshold=32'd781;
30: swap_threshold=32'd457;
31: swap_threshold=32'd268;
32: swap_threshold=32'd156;
33: swap_threshold=32'd91;
34: swap_threshold=32'd53;
35: swap_threshold=32'd31;
36: swap_threshold=32'd18;
37: swap_threshold=32'd10;
38: swap_threshold=32'd6;
39: swap_threshold=32'd3;
40: swap_threshold=32'd2;
41: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
12: begin case(gap)
1: swap_threshold=32'd2105289950;
2: swap_threshold=32'd1031962636;
3: swap_threshold=32'd505843332;
4: swap_threshold=32'd247952268;
5: swap_threshold=32'd121540254;
6: swap_threshold=32'd59576117;
7: swap_threshold=32'd29202783;
8: swap_threshold=32'd14314504;
9: swap_threshold=32'd7016626;
10: swap_threshold=32'd3439382;
11: swap_threshold=32'd1685902;
12: swap_threshold=32'd826389;
13: swap_threshold=32'd405076;
14: swap_threshold=32'd198558;
15: swap_threshold=32'd97328;
16: swap_threshold=32'd47708;
17: swap_threshold=32'd23385;
18: swap_threshold=32'd11462;
19: swap_threshold=32'd5618;
20: swap_threshold=32'd2754;
21: swap_threshold=32'd1350;
22: swap_threshold=32'd661;
23: swap_threshold=32'd324;
24: swap_threshold=32'd159;
25: swap_threshold=32'd77;
26: swap_threshold=32'd38;
27: swap_threshold=32'd18;
28: swap_threshold=32'd9;
29: swap_threshold=32'd4;
30: swap_threshold=32'd2;
31: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
13: begin case(gap)
1: swap_threshold=32'd1338603884;
2: swap_threshold=32'd417200000;
3: swap_threshold=32'd130027891;
4: swap_threshold=32'd40525533;
5: swap_threshold=32'd12630512;
6: swap_threshold=32'd3936526;
7: swap_threshold=32'd1226889;
8: swap_threshold=32'd382382;
9: swap_threshold=32'd119176;
10: swap_threshold=32'd37143;
11: swap_threshold=32'd11576;
12: swap_threshold=32'd3607;
13: swap_threshold=32'd1124;
14: swap_threshold=32'd350;
15: swap_threshold=32'd109;
16: swap_threshold=32'd34;
17: swap_threshold=32'd10;
18: swap_threshold=32'd3;
19: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
14: begin case(gap)
1: swap_threshold=32'd1316547699;
2: swap_threshold=32'd403564853;
3: swap_threshold=32'd123705803;
4: swap_threshold=32'd37919867;
5: swap_threshold=32'd11623677;
6: swap_threshold=32'd3563036;
7: swap_threshold=32'd1092187;
8: swap_threshold=32'd334790;
9: swap_threshold=32'd102624;
10: swap_threshold=32'd31457;
11: swap_threshold=32'd9642;
12: swap_threshold=32'd2955;
13: swap_threshold=32'd906;
14: swap_threshold=32'd277;
15: swap_threshold=32'd85;
16: swap_threshold=32'd26;
17: swap_threshold=32'd7;
18: swap_threshold=32'd2;
default: swap_threshold=0;
endcase end
default: swap_threshold=0;
endcase
end
endfunction
function automatic [287:0] expand(input logic [287:0] mask);
begin
expand[0] = mask[0] | mask[1] | mask[12] | mask[13];
expand[1] = mask[1] | mask[0] | mask[2] | mask[12] | mask[13] | mask[14];
expand[2] = mask[2] | mask[1] | mask[3] | mask[13] | mask[14] | mask[15];
expand[3] = mask[3] | mask[2] | mask[4] | mask[14] | mask[15] | mask[16];
expand[4] = mask[4] | mask[3] | mask[5] | mask[15] | mask[16] | mask[17];
expand[5] = mask[5] | mask[4] | mask[6] | mask[16] | mask[17] | mask[18];
expand[6] = mask[6] | mask[5] | mask[7] | mask[17] | mask[18] | mask[19];
expand[7] = mask[7] | mask[6] | mask[8] | mask[18] | mask[19] | mask[20];
expand[8] = mask[8] | mask[7] | mask[9] | mask[19] | mask[20] | mask[21];
expand[9] = mask[9] | mask[8] | mask[10] | mask[20] | mask[21] | mask[22];
expand[10] = mask[10] | mask[9] | mask[11] | mask[21] | mask[22] | mask[23];
expand[11] = mask[11] | mask[10] | mask[22] | mask[23];
expand[12] = mask[12] | mask[0] | mask[1] | mask[13] | mask[24] | mask[25];
expand[13] = mask[13] | mask[0] | mask[1] | mask[2] | mask[12] | mask[14] | mask[24] | mask[25] | mask[26];
expand[14] = mask[14] | mask[1] | mask[2] | mask[3] | mask[13] | mask[15] | mask[25] | mask[26] | mask[27];
expand[15] = mask[15] | mask[2] | mask[3] | mask[4] | mask[14] | mask[16] | mask[26] | mask[27] | mask[28];
expand[16] = mask[16] | mask[3] | mask[4] | mask[5] | mask[15] | mask[17] | mask[27] | mask[28] | mask[29];
expand[17] = mask[17] | mask[4] | mask[5] | mask[6] | mask[16] | mask[18] | mask[28] | mask[29] | mask[30];
expand[18] = mask[18] | mask[5] | mask[6] | mask[7] | mask[17] | mask[19] | mask[29] | mask[30] | mask[31];
expand[19] = mask[19] | mask[6] | mask[7] | mask[8] | mask[18] | mask[20] | mask[30] | mask[31] | mask[32];
expand[20] = mask[20] | mask[7] | mask[8] | mask[9] | mask[19] | mask[21] | mask[31] | mask[32] | mask[33];
expand[21] = mask[21] | mask[8] | mask[9] | mask[10] | mask[20] | mask[22] | mask[32] | mask[33] | mask[34];
expand[22] = mask[22] | mask[9] | mask[10] | mask[11] | mask[21] | mask[23] | mask[33] | mask[34] | mask[35];
expand[23] = mask[23] | mask[10] | mask[11] | mask[22] | mask[34] | mask[35];
expand[24] = mask[24] | mask[12] | mask[13] | mask[25] | mask[36] | mask[37];
expand[25] = mask[25] | mask[12] | mask[13] | mask[14] | mask[24] | mask[26] | mask[36] | mask[37] | mask[38];
expand[26] = mask[26] | mask[13] | mask[14] | mask[15] | mask[25] | mask[27] | mask[37] | mask[38] | mask[39];
expand[27] = mask[27] | mask[14] | mask[15] | mask[16] | mask[26] | mask[28] | mask[38] | mask[39] | mask[40];
expand[28] = mask[28] | mask[15] | mask[16] | mask[17] | mask[27] | mask[29] | mask[39] | mask[40] | mask[41];
expand[29] = mask[29] | mask[16] | mask[17] | mask[18] | mask[28] | mask[30] | mask[40] | mask[41] | mask[42];
expand[30] = mask[30] | mask[17] | mask[18] | mask[19] | mask[29] | mask[31] | mask[41] | mask[42] | mask[43];
expand[31] = mask[31] | mask[18] | mask[19] | mask[20] | mask[30] | mask[32] | mask[42] | mask[43] | mask[44];
expand[32] = mask[32] | mask[19] | mask[20] | mask[21] | mask[31] | mask[33] | mask[43] | mask[44] | mask[45];
expand[33] = mask[33] | mask[20] | mask[21] | mask[22] | mask[32] | mask[34] | mask[44] | mask[45] | mask[46];
expand[34] = mask[34] | mask[21] | mask[22] | mask[23] | mask[33] | mask[35] | mask[45] | mask[46] | mask[47];
expand[35] = mask[35] | mask[22] | mask[23] | mask[34] | mask[46] | mask[47];
expand[36] = mask[36] | mask[24] | mask[25] | mask[37] | mask[48] | mask[49];
expand[37] = mask[37] | mask[24] | mask[25] | mask[26] | mask[36] | mask[38] | mask[48] | mask[49] | mask[50];
expand[38] = mask[38] | mask[25] | mask[26] | mask[27] | mask[37] | mask[39] | mask[49] | mask[50] | mask[51];
expand[39] = mask[39] | mask[26] | mask[27] | mask[28] | mask[38] | mask[40] | mask[50] | mask[51] | mask[52];
expand[40] = mask[40] | mask[27] | mask[28] | mask[29] | mask[39] | mask[41] | mask[51] | mask[52] | mask[53];
expand[41] = mask[41] | mask[28] | mask[29] | mask[30] | mask[40] | mask[42] | mask[52] | mask[53] | mask[54];
expand[42] = mask[42] | mask[29] | mask[30] | mask[31] | mask[41] | mask[43] | mask[53] | mask[54] | mask[55];
expand[43] = mask[43] | mask[30] | mask[31] | mask[32] | mask[42] | mask[44] | mask[54] | mask[55] | mask[56];
expand[44] = mask[44] | mask[31] | mask[32] | mask[33] | mask[43] | mask[45] | mask[55] | mask[56] | mask[57];
expand[45] = mask[45] | mask[32] | mask[33] | mask[34] | mask[44] | mask[46] | mask[56] | mask[57] | mask[58];
expand[46] = mask[46] | mask[33] | mask[34] | mask[35] | mask[45] | mask[47] | mask[57] | mask[58] | mask[59];
expand[47] = mask[47] | mask[34] | mask[35] | mask[46] | mask[58] | mask[59];
expand[48] = mask[48] | mask[36] | mask[37] | mask[49] | mask[60] | mask[61];
expand[49] = mask[49] | mask[36] | mask[37] | mask[38] | mask[48] | mask[50] | mask[60] | mask[61] | mask[62];
expand[50] = mask[50] | mask[37] | mask[38] | mask[39] | mask[49] | mask[51] | mask[61] | mask[62] | mask[63];
expand[51] = mask[51] | mask[38] | mask[39] | mask[40] | mask[50] | mask[52] | mask[62] | mask[63] | mask[64];
expand[52] = mask[52] | mask[39] | mask[40] | mask[41] | mask[51] | mask[53] | mask[63] | mask[64] | mask[65];
expand[53] = mask[53] | mask[40] | mask[41] | mask[42] | mask[52] | mask[54] | mask[64] | mask[65] | mask[66];
expand[54] = mask[54] | mask[41] | mask[42] | mask[43] | mask[53] | mask[55] | mask[65] | mask[66] | mask[67];
expand[55] = mask[55] | mask[42] | mask[43] | mask[44] | mask[54] | mask[56] | mask[66] | mask[67] | mask[68];
expand[56] = mask[56] | mask[43] | mask[44] | mask[45] | mask[55] | mask[57] | mask[67] | mask[68] | mask[69];
expand[57] = mask[57] | mask[44] | mask[45] | mask[46] | mask[56] | mask[58] | mask[68] | mask[69] | mask[70];
expand[58] = mask[58] | mask[45] | mask[46] | mask[47] | mask[57] | mask[59] | mask[69] | mask[70] | mask[71];
expand[59] = mask[59] | mask[46] | mask[47] | mask[58] | mask[70] | mask[71];
expand[60] = mask[60] | mask[48] | mask[49] | mask[61] | mask[72] | mask[73];
expand[61] = mask[61] | mask[48] | mask[49] | mask[50] | mask[60] | mask[62] | mask[72] | mask[73] | mask[74];
expand[62] = mask[62] | mask[49] | mask[50] | mask[51] | mask[61] | mask[63] | mask[73] | mask[74] | mask[75];
expand[63] = mask[63] | mask[50] | mask[51] | mask[52] | mask[62] | mask[64] | mask[74] | mask[75] | mask[76];
expand[64] = mask[64] | mask[51] | mask[52] | mask[53] | mask[63] | mask[65] | mask[75] | mask[76] | mask[77];
expand[65] = mask[65] | mask[52] | mask[53] | mask[54] | mask[64] | mask[66] | mask[76] | mask[77] | mask[78];
expand[66] = mask[66] | mask[53] | mask[54] | mask[55] | mask[65] | mask[67] | mask[77] | mask[78] | mask[79];
expand[67] = mask[67] | mask[54] | mask[55] | mask[56] | mask[66] | mask[68] | mask[78] | mask[79] | mask[80];
expand[68] = mask[68] | mask[55] | mask[56] | mask[57] | mask[67] | mask[69] | mask[79] | mask[80] | mask[81];
expand[69] = mask[69] | mask[56] | mask[57] | mask[58] | mask[68] | mask[70] | mask[80] | mask[81] | mask[82];
expand[70] = mask[70] | mask[57] | mask[58] | mask[59] | mask[69] | mask[71] | mask[81] | mask[82] | mask[83];
expand[71] = mask[71] | mask[58] | mask[59] | mask[70] | mask[82] | mask[83];
expand[72] = mask[72] | mask[60] | mask[61] | mask[73] | mask[84] | mask[85];
expand[73] = mask[73] | mask[60] | mask[61] | mask[62] | mask[72] | mask[74] | mask[84] | mask[85] | mask[86];
expand[74] = mask[74] | mask[61] | mask[62] | mask[63] | mask[73] | mask[75] | mask[85] | mask[86] | mask[87];
expand[75] = mask[75] | mask[62] | mask[63] | mask[64] | mask[74] | mask[76] | mask[86] | mask[87] | mask[88];
expand[76] = mask[76] | mask[63] | mask[64] | mask[65] | mask[75] | mask[77] | mask[87] | mask[88] | mask[89];
expand[77] = mask[77] | mask[64] | mask[65] | mask[66] | mask[76] | mask[78] | mask[88] | mask[89] | mask[90];
expand[78] = mask[78] | mask[65] | mask[66] | mask[67] | mask[77] | mask[79] | mask[89] | mask[90] | mask[91];
expand[79] = mask[79] | mask[66] | mask[67] | mask[68] | mask[78] | mask[80] | mask[90] | mask[91] | mask[92];
expand[80] = mask[80] | mask[67] | mask[68] | mask[69] | mask[79] | mask[81] | mask[91] | mask[92] | mask[93];
expand[81] = mask[81] | mask[68] | mask[69] | mask[70] | mask[80] | mask[82] | mask[92] | mask[93] | mask[94];
expand[82] = mask[82] | mask[69] | mask[70] | mask[71] | mask[81] | mask[83] | mask[93] | mask[94] | mask[95];
expand[83] = mask[83] | mask[70] | mask[71] | mask[82] | mask[94] | mask[95];
expand[84] = mask[84] | mask[72] | mask[73] | mask[85] | mask[96] | mask[97];
expand[85] = mask[85] | mask[72] | mask[73] | mask[74] | mask[84] | mask[86] | mask[96] | mask[97] | mask[98];
expand[86] = mask[86] | mask[73] | mask[74] | mask[75] | mask[85] | mask[87] | mask[97] | mask[98] | mask[99];
expand[87] = mask[87] | mask[74] | mask[75] | mask[76] | mask[86] | mask[88] | mask[98] | mask[99] | mask[100];
expand[88] = mask[88] | mask[75] | mask[76] | mask[77] | mask[87] | mask[89] | mask[99] | mask[100] | mask[101];
expand[89] = mask[89] | mask[76] | mask[77] | mask[78] | mask[88] | mask[90] | mask[100] | mask[101] | mask[102];
expand[90] = mask[90] | mask[77] | mask[78] | mask[79] | mask[89] | mask[91] | mask[101] | mask[102] | mask[103];
expand[91] = mask[91] | mask[78] | mask[79] | mask[80] | mask[90] | mask[92] | mask[102] | mask[103] | mask[104];
expand[92] = mask[92] | mask[79] | mask[80] | mask[81] | mask[91] | mask[93] | mask[103] | mask[104] | mask[105];
expand[93] = mask[93] | mask[80] | mask[81] | mask[82] | mask[92] | mask[94] | mask[104] | mask[105] | mask[106];
expand[94] = mask[94] | mask[81] | mask[82] | mask[83] | mask[93] | mask[95] | mask[105] | mask[106] | mask[107];
expand[95] = mask[95] | mask[82] | mask[83] | mask[94] | mask[106] | mask[107];
expand[96] = mask[96] | mask[84] | mask[85] | mask[97] | mask[108] | mask[109];
expand[97] = mask[97] | mask[84] | mask[85] | mask[86] | mask[96] | mask[98] | mask[108] | mask[109] | mask[110];
expand[98] = mask[98] | mask[85] | mask[86] | mask[87] | mask[97] | mask[99] | mask[109] | mask[110] | mask[111];
expand[99] = mask[99] | mask[86] | mask[87] | mask[88] | mask[98] | mask[100] | mask[110] | mask[111] | mask[112];
expand[100] = mask[100] | mask[87] | mask[88] | mask[89] | mask[99] | mask[101] | mask[111] | mask[112] | mask[113];
expand[101] = mask[101] | mask[88] | mask[89] | mask[90] | mask[100] | mask[102] | mask[112] | mask[113] | mask[114];
expand[102] = mask[102] | mask[89] | mask[90] | mask[91] | mask[101] | mask[103] | mask[113] | mask[114] | mask[115];
expand[103] = mask[103] | mask[90] | mask[91] | mask[92] | mask[102] | mask[104] | mask[114] | mask[115] | mask[116];
expand[104] = mask[104] | mask[91] | mask[92] | mask[93] | mask[103] | mask[105] | mask[115] | mask[116] | mask[117];
expand[105] = mask[105] | mask[92] | mask[93] | mask[94] | mask[104] | mask[106] | mask[116] | mask[117] | mask[118];
expand[106] = mask[106] | mask[93] | mask[94] | mask[95] | mask[105] | mask[107] | mask[117] | mask[118] | mask[119];
expand[107] = mask[107] | mask[94] | mask[95] | mask[106] | mask[118] | mask[119];
expand[108] = mask[108] | mask[96] | mask[97] | mask[109] | mask[120] | mask[121];
expand[109] = mask[109] | mask[96] | mask[97] | mask[98] | mask[108] | mask[110] | mask[120] | mask[121] | mask[122];
expand[110] = mask[110] | mask[97] | mask[98] | mask[99] | mask[109] | mask[111] | mask[121] | mask[122] | mask[123];
expand[111] = mask[111] | mask[98] | mask[99] | mask[100] | mask[110] | mask[112] | mask[122] | mask[123] | mask[124];
expand[112] = mask[112] | mask[99] | mask[100] | mask[101] | mask[111] | mask[113] | mask[123] | mask[124] | mask[125];
expand[113] = mask[113] | mask[100] | mask[101] | mask[102] | mask[112] | mask[114] | mask[124] | mask[125] | mask[126];
expand[114] = mask[114] | mask[101] | mask[102] | mask[103] | mask[113] | mask[115] | mask[125] | mask[126] | mask[127];
expand[115] = mask[115] | mask[102] | mask[103] | mask[104] | mask[114] | mask[116] | mask[126] | mask[127] | mask[128];
expand[116] = mask[116] | mask[103] | mask[104] | mask[105] | mask[115] | mask[117] | mask[127] | mask[128] | mask[129];
expand[117] = mask[117] | mask[104] | mask[105] | mask[106] | mask[116] | mask[118] | mask[128] | mask[129] | mask[130];
expand[118] = mask[118] | mask[105] | mask[106] | mask[107] | mask[117] | mask[119] | mask[129] | mask[130] | mask[131];
expand[119] = mask[119] | mask[106] | mask[107] | mask[118] | mask[130] | mask[131];
expand[120] = mask[120] | mask[108] | mask[109] | mask[121] | mask[132] | mask[133];
expand[121] = mask[121] | mask[108] | mask[109] | mask[110] | mask[120] | mask[122] | mask[132] | mask[133] | mask[134];
expand[122] = mask[122] | mask[109] | mask[110] | mask[111] | mask[121] | mask[123] | mask[133] | mask[134] | mask[135];
expand[123] = mask[123] | mask[110] | mask[111] | mask[112] | mask[122] | mask[124] | mask[134] | mask[135] | mask[136];
expand[124] = mask[124] | mask[111] | mask[112] | mask[113] | mask[123] | mask[125] | mask[135] | mask[136] | mask[137];
expand[125] = mask[125] | mask[112] | mask[113] | mask[114] | mask[124] | mask[126] | mask[136] | mask[137] | mask[138];
expand[126] = mask[126] | mask[113] | mask[114] | mask[115] | mask[125] | mask[127] | mask[137] | mask[138] | mask[139];
expand[127] = mask[127] | mask[114] | mask[115] | mask[116] | mask[126] | mask[128] | mask[138] | mask[139] | mask[140];
expand[128] = mask[128] | mask[115] | mask[116] | mask[117] | mask[127] | mask[129] | mask[139] | mask[140] | mask[141];
expand[129] = mask[129] | mask[116] | mask[117] | mask[118] | mask[128] | mask[130] | mask[140] | mask[141] | mask[142];
expand[130] = mask[130] | mask[117] | mask[118] | mask[119] | mask[129] | mask[131] | mask[141] | mask[142] | mask[143];
expand[131] = mask[131] | mask[118] | mask[119] | mask[130] | mask[142] | mask[143];
expand[132] = mask[132] | mask[120] | mask[121] | mask[133] | mask[144] | mask[145];
expand[133] = mask[133] | mask[120] | mask[121] | mask[122] | mask[132] | mask[134] | mask[144] | mask[145] | mask[146];
expand[134] = mask[134] | mask[121] | mask[122] | mask[123] | mask[133] | mask[135] | mask[145] | mask[146] | mask[147];
expand[135] = mask[135] | mask[122] | mask[123] | mask[124] | mask[134] | mask[136] | mask[146] | mask[147] | mask[148];
expand[136] = mask[136] | mask[123] | mask[124] | mask[125] | mask[135] | mask[137] | mask[147] | mask[148] | mask[149];
expand[137] = mask[137] | mask[124] | mask[125] | mask[126] | mask[136] | mask[138] | mask[148] | mask[149] | mask[150];
expand[138] = mask[138] | mask[125] | mask[126] | mask[127] | mask[137] | mask[139] | mask[149] | mask[150] | mask[151];
expand[139] = mask[139] | mask[126] | mask[127] | mask[128] | mask[138] | mask[140] | mask[150] | mask[151] | mask[152];
expand[140] = mask[140] | mask[127] | mask[128] | mask[129] | mask[139] | mask[141] | mask[151] | mask[152] | mask[153];
expand[141] = mask[141] | mask[128] | mask[129] | mask[130] | mask[140] | mask[142] | mask[152] | mask[153] | mask[154];
expand[142] = mask[142] | mask[129] | mask[130] | mask[131] | mask[141] | mask[143] | mask[153] | mask[154] | mask[155];
expand[143] = mask[143] | mask[130] | mask[131] | mask[142] | mask[154] | mask[155];
expand[144] = mask[144] | mask[132] | mask[133] | mask[145] | mask[156] | mask[157];
expand[145] = mask[145] | mask[132] | mask[133] | mask[134] | mask[144] | mask[146] | mask[156] | mask[157] | mask[158];
expand[146] = mask[146] | mask[133] | mask[134] | mask[135] | mask[145] | mask[147] | mask[157] | mask[158] | mask[159];
expand[147] = mask[147] | mask[134] | mask[135] | mask[136] | mask[146] | mask[148] | mask[158] | mask[159] | mask[160];
expand[148] = mask[148] | mask[135] | mask[136] | mask[137] | mask[147] | mask[149] | mask[159] | mask[160] | mask[161];
expand[149] = mask[149] | mask[136] | mask[137] | mask[138] | mask[148] | mask[150] | mask[160] | mask[161] | mask[162];
expand[150] = mask[150] | mask[137] | mask[138] | mask[139] | mask[149] | mask[151] | mask[161] | mask[162] | mask[163];
expand[151] = mask[151] | mask[138] | mask[139] | mask[140] | mask[150] | mask[152] | mask[162] | mask[163] | mask[164];
expand[152] = mask[152] | mask[139] | mask[140] | mask[141] | mask[151] | mask[153] | mask[163] | mask[164] | mask[165];
expand[153] = mask[153] | mask[140] | mask[141] | mask[142] | mask[152] | mask[154] | mask[164] | mask[165] | mask[166];
expand[154] = mask[154] | mask[141] | mask[142] | mask[143] | mask[153] | mask[155] | mask[165] | mask[166] | mask[167];
expand[155] = mask[155] | mask[142] | mask[143] | mask[154] | mask[166] | mask[167];
expand[156] = mask[156] | mask[144] | mask[145] | mask[157] | mask[168] | mask[169];
expand[157] = mask[157] | mask[144] | mask[145] | mask[146] | mask[156] | mask[158] | mask[168] | mask[169] | mask[170];
expand[158] = mask[158] | mask[145] | mask[146] | mask[147] | mask[157] | mask[159] | mask[169] | mask[170] | mask[171];
expand[159] = mask[159] | mask[146] | mask[147] | mask[148] | mask[158] | mask[160] | mask[170] | mask[171] | mask[172];
expand[160] = mask[160] | mask[147] | mask[148] | mask[149] | mask[159] | mask[161] | mask[171] | mask[172] | mask[173];
expand[161] = mask[161] | mask[148] | mask[149] | mask[150] | mask[160] | mask[162] | mask[172] | mask[173] | mask[174];
expand[162] = mask[162] | mask[149] | mask[150] | mask[151] | mask[161] | mask[163] | mask[173] | mask[174] | mask[175];
expand[163] = mask[163] | mask[150] | mask[151] | mask[152] | mask[162] | mask[164] | mask[174] | mask[175] | mask[176];
expand[164] = mask[164] | mask[151] | mask[152] | mask[153] | mask[163] | mask[165] | mask[175] | mask[176] | mask[177];
expand[165] = mask[165] | mask[152] | mask[153] | mask[154] | mask[164] | mask[166] | mask[176] | mask[177] | mask[178];
expand[166] = mask[166] | mask[153] | mask[154] | mask[155] | mask[165] | mask[167] | mask[177] | mask[178] | mask[179];
expand[167] = mask[167] | mask[154] | mask[155] | mask[166] | mask[178] | mask[179];
expand[168] = mask[168] | mask[156] | mask[157] | mask[169] | mask[180] | mask[181];
expand[169] = mask[169] | mask[156] | mask[157] | mask[158] | mask[168] | mask[170] | mask[180] | mask[181] | mask[182];
expand[170] = mask[170] | mask[157] | mask[158] | mask[159] | mask[169] | mask[171] | mask[181] | mask[182] | mask[183];
expand[171] = mask[171] | mask[158] | mask[159] | mask[160] | mask[170] | mask[172] | mask[182] | mask[183] | mask[184];
expand[172] = mask[172] | mask[159] | mask[160] | mask[161] | mask[171] | mask[173] | mask[183] | mask[184] | mask[185];
expand[173] = mask[173] | mask[160] | mask[161] | mask[162] | mask[172] | mask[174] | mask[184] | mask[185] | mask[186];
expand[174] = mask[174] | mask[161] | mask[162] | mask[163] | mask[173] | mask[175] | mask[185] | mask[186] | mask[187];
expand[175] = mask[175] | mask[162] | mask[163] | mask[164] | mask[174] | mask[176] | mask[186] | mask[187] | mask[188];
expand[176] = mask[176] | mask[163] | mask[164] | mask[165] | mask[175] | mask[177] | mask[187] | mask[188] | mask[189];
expand[177] = mask[177] | mask[164] | mask[165] | mask[166] | mask[176] | mask[178] | mask[188] | mask[189] | mask[190];
expand[178] = mask[178] | mask[165] | mask[166] | mask[167] | mask[177] | mask[179] | mask[189] | mask[190] | mask[191];
expand[179] = mask[179] | mask[166] | mask[167] | mask[178] | mask[190] | mask[191];
expand[180] = mask[180] | mask[168] | mask[169] | mask[181] | mask[192] | mask[193];
expand[181] = mask[181] | mask[168] | mask[169] | mask[170] | mask[180] | mask[182] | mask[192] | mask[193] | mask[194];
expand[182] = mask[182] | mask[169] | mask[170] | mask[171] | mask[181] | mask[183] | mask[193] | mask[194] | mask[195];
expand[183] = mask[183] | mask[170] | mask[171] | mask[172] | mask[182] | mask[184] | mask[194] | mask[195] | mask[196];
expand[184] = mask[184] | mask[171] | mask[172] | mask[173] | mask[183] | mask[185] | mask[195] | mask[196] | mask[197];
expand[185] = mask[185] | mask[172] | mask[173] | mask[174] | mask[184] | mask[186] | mask[196] | mask[197] | mask[198];
expand[186] = mask[186] | mask[173] | mask[174] | mask[175] | mask[185] | mask[187] | mask[197] | mask[198] | mask[199];
expand[187] = mask[187] | mask[174] | mask[175] | mask[176] | mask[186] | mask[188] | mask[198] | mask[199] | mask[200];
expand[188] = mask[188] | mask[175] | mask[176] | mask[177] | mask[187] | mask[189] | mask[199] | mask[200] | mask[201];
expand[189] = mask[189] | mask[176] | mask[177] | mask[178] | mask[188] | mask[190] | mask[200] | mask[201] | mask[202];
expand[190] = mask[190] | mask[177] | mask[178] | mask[179] | mask[189] | mask[191] | mask[201] | mask[202] | mask[203];
expand[191] = mask[191] | mask[178] | mask[179] | mask[190] | mask[202] | mask[203];
expand[192] = mask[192] | mask[180] | mask[181] | mask[193] | mask[204] | mask[205];
expand[193] = mask[193] | mask[180] | mask[181] | mask[182] | mask[192] | mask[194] | mask[204] | mask[205] | mask[206];
expand[194] = mask[194] | mask[181] | mask[182] | mask[183] | mask[193] | mask[195] | mask[205] | mask[206] | mask[207];
expand[195] = mask[195] | mask[182] | mask[183] | mask[184] | mask[194] | mask[196] | mask[206] | mask[207] | mask[208];
expand[196] = mask[196] | mask[183] | mask[184] | mask[185] | mask[195] | mask[197] | mask[207] | mask[208] | mask[209];
expand[197] = mask[197] | mask[184] | mask[185] | mask[186] | mask[196] | mask[198] | mask[208] | mask[209] | mask[210];
expand[198] = mask[198] | mask[185] | mask[186] | mask[187] | mask[197] | mask[199] | mask[209] | mask[210] | mask[211];
expand[199] = mask[199] | mask[186] | mask[187] | mask[188] | mask[198] | mask[200] | mask[210] | mask[211] | mask[212];
expand[200] = mask[200] | mask[187] | mask[188] | mask[189] | mask[199] | mask[201] | mask[211] | mask[212] | mask[213];
expand[201] = mask[201] | mask[188] | mask[189] | mask[190] | mask[200] | mask[202] | mask[212] | mask[213] | mask[214];
expand[202] = mask[202] | mask[189] | mask[190] | mask[191] | mask[201] | mask[203] | mask[213] | mask[214] | mask[215];
expand[203] = mask[203] | mask[190] | mask[191] | mask[202] | mask[214] | mask[215];
expand[204] = mask[204] | mask[192] | mask[193] | mask[205] | mask[216] | mask[217];
expand[205] = mask[205] | mask[192] | mask[193] | mask[194] | mask[204] | mask[206] | mask[216] | mask[217] | mask[218];
expand[206] = mask[206] | mask[193] | mask[194] | mask[195] | mask[205] | mask[207] | mask[217] | mask[218] | mask[219];
expand[207] = mask[207] | mask[194] | mask[195] | mask[196] | mask[206] | mask[208] | mask[218] | mask[219] | mask[220];
expand[208] = mask[208] | mask[195] | mask[196] | mask[197] | mask[207] | mask[209] | mask[219] | mask[220] | mask[221];
expand[209] = mask[209] | mask[196] | mask[197] | mask[198] | mask[208] | mask[210] | mask[220] | mask[221] | mask[222];
expand[210] = mask[210] | mask[197] | mask[198] | mask[199] | mask[209] | mask[211] | mask[221] | mask[222] | mask[223];
expand[211] = mask[211] | mask[198] | mask[199] | mask[200] | mask[210] | mask[212] | mask[222] | mask[223] | mask[224];
expand[212] = mask[212] | mask[199] | mask[200] | mask[201] | mask[211] | mask[213] | mask[223] | mask[224] | mask[225];
expand[213] = mask[213] | mask[200] | mask[201] | mask[202] | mask[212] | mask[214] | mask[224] | mask[225] | mask[226];
expand[214] = mask[214] | mask[201] | mask[202] | mask[203] | mask[213] | mask[215] | mask[225] | mask[226] | mask[227];
expand[215] = mask[215] | mask[202] | mask[203] | mask[214] | mask[226] | mask[227];
expand[216] = mask[216] | mask[204] | mask[205] | mask[217] | mask[228] | mask[229];
expand[217] = mask[217] | mask[204] | mask[205] | mask[206] | mask[216] | mask[218] | mask[228] | mask[229] | mask[230];
expand[218] = mask[218] | mask[205] | mask[206] | mask[207] | mask[217] | mask[219] | mask[229] | mask[230] | mask[231];
expand[219] = mask[219] | mask[206] | mask[207] | mask[208] | mask[218] | mask[220] | mask[230] | mask[231] | mask[232];
expand[220] = mask[220] | mask[207] | mask[208] | mask[209] | mask[219] | mask[221] | mask[231] | mask[232] | mask[233];
expand[221] = mask[221] | mask[208] | mask[209] | mask[210] | mask[220] | mask[222] | mask[232] | mask[233] | mask[234];
expand[222] = mask[222] | mask[209] | mask[210] | mask[211] | mask[221] | mask[223] | mask[233] | mask[234] | mask[235];
expand[223] = mask[223] | mask[210] | mask[211] | mask[212] | mask[222] | mask[224] | mask[234] | mask[235] | mask[236];
expand[224] = mask[224] | mask[211] | mask[212] | mask[213] | mask[223] | mask[225] | mask[235] | mask[236] | mask[237];
expand[225] = mask[225] | mask[212] | mask[213] | mask[214] | mask[224] | mask[226] | mask[236] | mask[237] | mask[238];
expand[226] = mask[226] | mask[213] | mask[214] | mask[215] | mask[225] | mask[227] | mask[237] | mask[238] | mask[239];
expand[227] = mask[227] | mask[214] | mask[215] | mask[226] | mask[238] | mask[239];
expand[228] = mask[228] | mask[216] | mask[217] | mask[229] | mask[240] | mask[241];
expand[229] = mask[229] | mask[216] | mask[217] | mask[218] | mask[228] | mask[230] | mask[240] | mask[241] | mask[242];
expand[230] = mask[230] | mask[217] | mask[218] | mask[219] | mask[229] | mask[231] | mask[241] | mask[242] | mask[243];
expand[231] = mask[231] | mask[218] | mask[219] | mask[220] | mask[230] | mask[232] | mask[242] | mask[243] | mask[244];
expand[232] = mask[232] | mask[219] | mask[220] | mask[221] | mask[231] | mask[233] | mask[243] | mask[244] | mask[245];
expand[233] = mask[233] | mask[220] | mask[221] | mask[222] | mask[232] | mask[234] | mask[244] | mask[245] | mask[246];
expand[234] = mask[234] | mask[221] | mask[222] | mask[223] | mask[233] | mask[235] | mask[245] | mask[246] | mask[247];
expand[235] = mask[235] | mask[222] | mask[223] | mask[224] | mask[234] | mask[236] | mask[246] | mask[247] | mask[248];
expand[236] = mask[236] | mask[223] | mask[224] | mask[225] | mask[235] | mask[237] | mask[247] | mask[248] | mask[249];
expand[237] = mask[237] | mask[224] | mask[225] | mask[226] | mask[236] | mask[238] | mask[248] | mask[249] | mask[250];
expand[238] = mask[238] | mask[225] | mask[226] | mask[227] | mask[237] | mask[239] | mask[249] | mask[250] | mask[251];
expand[239] = mask[239] | mask[226] | mask[227] | mask[238] | mask[250] | mask[251];
expand[240] = mask[240] | mask[228] | mask[229] | mask[241] | mask[252] | mask[253];
expand[241] = mask[241] | mask[228] | mask[229] | mask[230] | mask[240] | mask[242] | mask[252] | mask[253] | mask[254];
expand[242] = mask[242] | mask[229] | mask[230] | mask[231] | mask[241] | mask[243] | mask[253] | mask[254] | mask[255];
expand[243] = mask[243] | mask[230] | mask[231] | mask[232] | mask[242] | mask[244] | mask[254] | mask[255] | mask[256];
expand[244] = mask[244] | mask[231] | mask[232] | mask[233] | mask[243] | mask[245] | mask[255] | mask[256] | mask[257];
expand[245] = mask[245] | mask[232] | mask[233] | mask[234] | mask[244] | mask[246] | mask[256] | mask[257] | mask[258];
expand[246] = mask[246] | mask[233] | mask[234] | mask[235] | mask[245] | mask[247] | mask[257] | mask[258] | mask[259];
expand[247] = mask[247] | mask[234] | mask[235] | mask[236] | mask[246] | mask[248] | mask[258] | mask[259] | mask[260];
expand[248] = mask[248] | mask[235] | mask[236] | mask[237] | mask[247] | mask[249] | mask[259] | mask[260] | mask[261];
expand[249] = mask[249] | mask[236] | mask[237] | mask[238] | mask[248] | mask[250] | mask[260] | mask[261] | mask[262];
expand[250] = mask[250] | mask[237] | mask[238] | mask[239] | mask[249] | mask[251] | mask[261] | mask[262] | mask[263];
expand[251] = mask[251] | mask[238] | mask[239] | mask[250] | mask[262] | mask[263];
expand[252] = mask[252] | mask[240] | mask[241] | mask[253] | mask[264] | mask[265];
expand[253] = mask[253] | mask[240] | mask[241] | mask[242] | mask[252] | mask[254] | mask[264] | mask[265] | mask[266];
expand[254] = mask[254] | mask[241] | mask[242] | mask[243] | mask[253] | mask[255] | mask[265] | mask[266] | mask[267];
expand[255] = mask[255] | mask[242] | mask[243] | mask[244] | mask[254] | mask[256] | mask[266] | mask[267] | mask[268];
expand[256] = mask[256] | mask[243] | mask[244] | mask[245] | mask[255] | mask[257] | mask[267] | mask[268] | mask[269];
expand[257] = mask[257] | mask[244] | mask[245] | mask[246] | mask[256] | mask[258] | mask[268] | mask[269] | mask[270];
expand[258] = mask[258] | mask[245] | mask[246] | mask[247] | mask[257] | mask[259] | mask[269] | mask[270] | mask[271];
expand[259] = mask[259] | mask[246] | mask[247] | mask[248] | mask[258] | mask[260] | mask[270] | mask[271] | mask[272];
expand[260] = mask[260] | mask[247] | mask[248] | mask[249] | mask[259] | mask[261] | mask[271] | mask[272] | mask[273];
expand[261] = mask[261] | mask[248] | mask[249] | mask[250] | mask[260] | mask[262] | mask[272] | mask[273] | mask[274];
expand[262] = mask[262] | mask[249] | mask[250] | mask[251] | mask[261] | mask[263] | mask[273] | mask[274] | mask[275];
expand[263] = mask[263] | mask[250] | mask[251] | mask[262] | mask[274] | mask[275];
expand[264] = mask[264] | mask[252] | mask[253] | mask[265] | mask[276] | mask[277];
expand[265] = mask[265] | mask[252] | mask[253] | mask[254] | mask[264] | mask[266] | mask[276] | mask[277] | mask[278];
expand[266] = mask[266] | mask[253] | mask[254] | mask[255] | mask[265] | mask[267] | mask[277] | mask[278] | mask[279];
expand[267] = mask[267] | mask[254] | mask[255] | mask[256] | mask[266] | mask[268] | mask[278] | mask[279] | mask[280];
expand[268] = mask[268] | mask[255] | mask[256] | mask[257] | mask[267] | mask[269] | mask[279] | mask[280] | mask[281];
expand[269] = mask[269] | mask[256] | mask[257] | mask[258] | mask[268] | mask[270] | mask[280] | mask[281] | mask[282];
expand[270] = mask[270] | mask[257] | mask[258] | mask[259] | mask[269] | mask[271] | mask[281] | mask[282] | mask[283];
expand[271] = mask[271] | mask[258] | mask[259] | mask[260] | mask[270] | mask[272] | mask[282] | mask[283] | mask[284];
expand[272] = mask[272] | mask[259] | mask[260] | mask[261] | mask[271] | mask[273] | mask[283] | mask[284] | mask[285];
expand[273] = mask[273] | mask[260] | mask[261] | mask[262] | mask[272] | mask[274] | mask[284] | mask[285] | mask[286];
expand[274] = mask[274] | mask[261] | mask[262] | mask[263] | mask[273] | mask[275] | mask[285] | mask[286] | mask[287];
expand[275] = mask[275] | mask[262] | mask[263] | mask[274] | mask[286] | mask[287];
expand[276] = mask[276] | mask[264] | mask[265] | mask[277];
expand[277] = mask[277] | mask[264] | mask[265] | mask[266] | mask[276] | mask[278];
expand[278] = mask[278] | mask[265] | mask[266] | mask[267] | mask[277] | mask[279];
expand[279] = mask[279] | mask[266] | mask[267] | mask[268] | mask[278] | mask[280];
expand[280] = mask[280] | mask[267] | mask[268] | mask[269] | mask[279] | mask[281];
expand[281] = mask[281] | mask[268] | mask[269] | mask[270] | mask[280] | mask[282];
expand[282] = mask[282] | mask[269] | mask[270] | mask[271] | mask[281] | mask[283];
expand[283] = mask[283] | mask[270] | mask[271] | mask[272] | mask[282] | mask[284];
expand[284] = mask[284] | mask[271] | mask[272] | mask[273] | mask[283] | mask[285];
expand[285] = mask[285] | mask[272] | mask[273] | mask[274] | mask[284] | mask[286];
expand[286] = mask[286] | mask[273] | mask[274] | mask[275] | mask[285] | mask[287];
expand[287] = mask[287] | mask[274] | mask[275] | mask[286];
end
endfunction
