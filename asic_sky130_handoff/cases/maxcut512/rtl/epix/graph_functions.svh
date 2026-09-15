// Generated from the frozen certified signed-weight benchmark.
function automatic signed [4:0] raw_field(input integer node,input logic [511:0] bits);
begin
case(node)
0: raw_field = (bits[1] ? -5'sd1 : 5'sd1) + (bits[16] ? -5'sd1 : 5'sd1) + (bits[17] ? 5'sd1 : -5'sd1);
1: raw_field = (bits[0] ? -5'sd1 : 5'sd1) + (bits[2] ? -5'sd1 : 5'sd1) + (bits[16] ? -5'sd1 : 5'sd1) + (bits[17] ? -5'sd1 : 5'sd1) + (bits[18] ? 5'sd1 : -5'sd1);
2: raw_field = (bits[1] ? -5'sd1 : 5'sd1) + (bits[3] ? -5'sd1 : 5'sd1) + (bits[17] ? -5'sd1 : 5'sd1) + (bits[18] ? 5'sd1 : -5'sd1) + (bits[19] ? 5'sd1 : -5'sd1);
3: raw_field = (bits[2] ? -5'sd1 : 5'sd1) + (bits[4] ? -5'sd1 : 5'sd1) + (bits[18] ? -5'sd1 : 5'sd1) + (bits[19] ? 5'sd1 : -5'sd1) + (bits[20] ? -5'sd1 : 5'sd1);
4: raw_field = (bits[3] ? -5'sd1 : 5'sd1) + (bits[5] ? -5'sd1 : 5'sd1) + (bits[19] ? 5'sd1 : -5'sd1) + (bits[20] ? -5'sd1 : 5'sd1) + (bits[21] ? -5'sd1 : 5'sd1);
5: raw_field = (bits[4] ? -5'sd1 : 5'sd1) + (bits[6] ? 5'sd1 : -5'sd1) + (bits[20] ? -5'sd1 : 5'sd1) + (bits[21] ? 5'sd1 : -5'sd1) + (bits[22] ? -5'sd1 : 5'sd1);
6: raw_field = (bits[5] ? 5'sd1 : -5'sd1) + (bits[7] ? 5'sd1 : -5'sd1) + (bits[21] ? -5'sd1 : 5'sd1) + (bits[22] ? -5'sd1 : 5'sd1) + (bits[23] ? -5'sd1 : 5'sd1);
7: raw_field = (bits[6] ? 5'sd1 : -5'sd1) + (bits[8] ? -5'sd1 : 5'sd1) + (bits[22] ? 5'sd1 : -5'sd1) + (bits[23] ? -5'sd1 : 5'sd1) + (bits[24] ? 5'sd1 : -5'sd1);
8: raw_field = (bits[7] ? -5'sd1 : 5'sd1) + (bits[9] ? -5'sd1 : 5'sd1) + (bits[23] ? -5'sd1 : 5'sd1) + (bits[24] ? -5'sd1 : 5'sd1) + (bits[25] ? -5'sd1 : 5'sd1);
9: raw_field = (bits[8] ? -5'sd1 : 5'sd1) + (bits[10] ? -5'sd1 : 5'sd1) + (bits[24] ? -5'sd1 : 5'sd1) + (bits[25] ? 5'sd1 : -5'sd1) + (bits[26] ? -5'sd1 : 5'sd1);
10: raw_field = (bits[9] ? -5'sd1 : 5'sd1) + (bits[11] ? 5'sd1 : -5'sd1) + (bits[25] ? -5'sd1 : 5'sd1) + (bits[26] ? -5'sd1 : 5'sd1) + (bits[27] ? -5'sd1 : 5'sd1);
11: raw_field = (bits[10] ? 5'sd1 : -5'sd1) + (bits[12] ? 5'sd1 : -5'sd1) + (bits[26] ? 5'sd1 : -5'sd1) + (bits[27] ? -5'sd1 : 5'sd1) + (bits[28] ? -5'sd1 : 5'sd1);
12: raw_field = (bits[11] ? 5'sd1 : -5'sd1) + (bits[13] ? 5'sd1 : -5'sd1) + (bits[27] ? -5'sd1 : 5'sd1) + (bits[28] ? 5'sd1 : -5'sd1) + (bits[29] ? 5'sd1 : -5'sd1);
13: raw_field = (bits[12] ? 5'sd1 : -5'sd1) + (bits[14] ? 5'sd1 : -5'sd1) + (bits[28] ? -5'sd1 : 5'sd1) + (bits[29] ? -5'sd1 : 5'sd1) + (bits[30] ? -5'sd1 : 5'sd1);
14: raw_field = (bits[13] ? 5'sd1 : -5'sd1) + (bits[15] ? -5'sd1 : 5'sd1) + (bits[29] ? -5'sd1 : 5'sd1) + (bits[30] ? -5'sd1 : 5'sd1) + (bits[31] ? 5'sd1 : -5'sd1);
15: raw_field = (bits[14] ? -5'sd1 : 5'sd1) + (bits[30] ? 5'sd1 : -5'sd1) + (bits[31] ? 5'sd1 : -5'sd1);
16: raw_field = (bits[0] ? -5'sd1 : 5'sd1) + (bits[1] ? -5'sd1 : 5'sd1) + (bits[17] ? 5'sd1 : -5'sd1) + (bits[32] ? -5'sd1 : 5'sd1) + (bits[33] ? 5'sd1 : -5'sd1);
17: raw_field = (bits[0] ? 5'sd1 : -5'sd1) + (bits[1] ? -5'sd1 : 5'sd1) + (bits[2] ? -5'sd1 : 5'sd1) + (bits[16] ? 5'sd1 : -5'sd1) + (bits[18] ? -5'sd1 : 5'sd1) + (bits[32] ? 5'sd1 : -5'sd1) + (bits[33] ? -5'sd1 : 5'sd1) + (bits[34] ? 5'sd1 : -5'sd1);
18: raw_field = (bits[1] ? 5'sd1 : -5'sd1) + (bits[2] ? 5'sd1 : -5'sd1) + (bits[3] ? -5'sd1 : 5'sd1) + (bits[17] ? -5'sd1 : 5'sd1) + (bits[19] ? 5'sd1 : -5'sd1) + (bits[33] ? 5'sd1 : -5'sd1) + (bits[34] ? -5'sd1 : 5'sd1) + (bits[35] ? 5'sd1 : -5'sd1);
19: raw_field = (bits[2] ? 5'sd1 : -5'sd1) + (bits[3] ? 5'sd1 : -5'sd1) + (bits[4] ? 5'sd1 : -5'sd1) + (bits[18] ? 5'sd1 : -5'sd1) + (bits[20] ? 5'sd1 : -5'sd1) + (bits[34] ? 5'sd1 : -5'sd1) + (bits[35] ? 5'sd1 : -5'sd1) + (bits[36] ? 5'sd1 : -5'sd1);
20: raw_field = (bits[3] ? -5'sd1 : 5'sd1) + (bits[4] ? -5'sd1 : 5'sd1) + (bits[5] ? -5'sd1 : 5'sd1) + (bits[19] ? 5'sd1 : -5'sd1) + (bits[21] ? -5'sd1 : 5'sd1) + (bits[35] ? -5'sd1 : 5'sd1) + (bits[36] ? 5'sd1 : -5'sd1) + (bits[37] ? -5'sd1 : 5'sd1);
21: raw_field = (bits[4] ? -5'sd1 : 5'sd1) + (bits[5] ? 5'sd1 : -5'sd1) + (bits[6] ? -5'sd1 : 5'sd1) + (bits[20] ? -5'sd1 : 5'sd1) + (bits[22] ? -5'sd1 : 5'sd1) + (bits[36] ? -5'sd1 : 5'sd1) + (bits[37] ? 5'sd1 : -5'sd1) + (bits[38] ? -5'sd1 : 5'sd1);
22: raw_field = (bits[5] ? -5'sd1 : 5'sd1) + (bits[6] ? -5'sd1 : 5'sd1) + (bits[7] ? 5'sd1 : -5'sd1) + (bits[21] ? -5'sd1 : 5'sd1) + (bits[23] ? 5'sd1 : -5'sd1) + (bits[37] ? 5'sd1 : -5'sd1) + (bits[38] ? -5'sd1 : 5'sd1) + (bits[39] ? -5'sd1 : 5'sd1);
23: raw_field = (bits[6] ? -5'sd1 : 5'sd1) + (bits[7] ? -5'sd1 : 5'sd1) + (bits[8] ? -5'sd1 : 5'sd1) + (bits[22] ? 5'sd1 : -5'sd1) + (bits[24] ? 5'sd1 : -5'sd1) + (bits[38] ? -5'sd1 : 5'sd1) + (bits[39] ? 5'sd1 : -5'sd1) + (bits[40] ? -5'sd1 : 5'sd1);
24: raw_field = (bits[7] ? 5'sd1 : -5'sd1) + (bits[8] ? -5'sd1 : 5'sd1) + (bits[9] ? -5'sd1 : 5'sd1) + (bits[23] ? 5'sd1 : -5'sd1) + (bits[25] ? -5'sd1 : 5'sd1) + (bits[39] ? 5'sd1 : -5'sd1) + (bits[40] ? -5'sd1 : 5'sd1) + (bits[41] ? 5'sd1 : -5'sd1);
25: raw_field = (bits[8] ? -5'sd1 : 5'sd1) + (bits[9] ? 5'sd1 : -5'sd1) + (bits[10] ? -5'sd1 : 5'sd1) + (bits[24] ? -5'sd1 : 5'sd1) + (bits[26] ? 5'sd1 : -5'sd1) + (bits[40] ? 5'sd1 : -5'sd1) + (bits[41] ? -5'sd1 : 5'sd1) + (bits[42] ? -5'sd1 : 5'sd1);
26: raw_field = (bits[9] ? -5'sd1 : 5'sd1) + (bits[10] ? -5'sd1 : 5'sd1) + (bits[11] ? 5'sd1 : -5'sd1) + (bits[25] ? 5'sd1 : -5'sd1) + (bits[27] ? 5'sd1 : -5'sd1) + (bits[41] ? -5'sd1 : 5'sd1) + (bits[42] ? -5'sd1 : 5'sd1) + (bits[43] ? -5'sd1 : 5'sd1);
27: raw_field = (bits[10] ? -5'sd1 : 5'sd1) + (bits[11] ? -5'sd1 : 5'sd1) + (bits[12] ? -5'sd1 : 5'sd1) + (bits[26] ? 5'sd1 : -5'sd1) + (bits[28] ? 5'sd1 : -5'sd1) + (bits[42] ? -5'sd1 : 5'sd1) + (bits[43] ? -5'sd1 : 5'sd1) + (bits[44] ? 5'sd1 : -5'sd1);
28: raw_field = (bits[11] ? -5'sd1 : 5'sd1) + (bits[12] ? 5'sd1 : -5'sd1) + (bits[13] ? -5'sd1 : 5'sd1) + (bits[27] ? 5'sd1 : -5'sd1) + (bits[29] ? -5'sd1 : 5'sd1) + (bits[43] ? 5'sd1 : -5'sd1) + (bits[44] ? -5'sd1 : 5'sd1) + (bits[45] ? 5'sd1 : -5'sd1);
29: raw_field = (bits[12] ? 5'sd1 : -5'sd1) + (bits[13] ? -5'sd1 : 5'sd1) + (bits[14] ? -5'sd1 : 5'sd1) + (bits[28] ? -5'sd1 : 5'sd1) + (bits[30] ? -5'sd1 : 5'sd1) + (bits[44] ? -5'sd1 : 5'sd1) + (bits[45] ? 5'sd1 : -5'sd1) + (bits[46] ? 5'sd1 : -5'sd1);
30: raw_field = (bits[13] ? -5'sd1 : 5'sd1) + (bits[14] ? -5'sd1 : 5'sd1) + (bits[15] ? 5'sd1 : -5'sd1) + (bits[29] ? -5'sd1 : 5'sd1) + (bits[31] ? -5'sd1 : 5'sd1) + (bits[45] ? -5'sd1 : 5'sd1) + (bits[46] ? 5'sd1 : -5'sd1) + (bits[47] ? 5'sd1 : -5'sd1);
31: raw_field = (bits[14] ? 5'sd1 : -5'sd1) + (bits[15] ? 5'sd1 : -5'sd1) + (bits[30] ? -5'sd1 : 5'sd1) + (bits[46] ? -5'sd1 : 5'sd1) + (bits[47] ? -5'sd1 : 5'sd1);
32: raw_field = (bits[16] ? -5'sd1 : 5'sd1) + (bits[17] ? 5'sd1 : -5'sd1) + (bits[33] ? -5'sd1 : 5'sd1) + (bits[48] ? 5'sd1 : -5'sd1) + (bits[49] ? -5'sd1 : 5'sd1);
33: raw_field = (bits[16] ? 5'sd1 : -5'sd1) + (bits[17] ? -5'sd1 : 5'sd1) + (bits[18] ? 5'sd1 : -5'sd1) + (bits[32] ? -5'sd1 : 5'sd1) + (bits[34] ? -5'sd1 : 5'sd1) + (bits[48] ? -5'sd1 : 5'sd1) + (bits[49] ? 5'sd1 : -5'sd1) + (bits[50] ? -5'sd1 : 5'sd1);
34: raw_field = (bits[17] ? 5'sd1 : -5'sd1) + (bits[18] ? -5'sd1 : 5'sd1) + (bits[19] ? 5'sd1 : -5'sd1) + (bits[33] ? -5'sd1 : 5'sd1) + (bits[35] ? -5'sd1 : 5'sd1) + (bits[49] ? 5'sd1 : -5'sd1) + (bits[50] ? -5'sd1 : 5'sd1) + (bits[51] ? 5'sd1 : -5'sd1);
35: raw_field = (bits[18] ? 5'sd1 : -5'sd1) + (bits[19] ? 5'sd1 : -5'sd1) + (bits[20] ? -5'sd1 : 5'sd1) + (bits[34] ? -5'sd1 : 5'sd1) + (bits[36] ? -5'sd1 : 5'sd1) + (bits[50] ? 5'sd1 : -5'sd1) + (bits[51] ? 5'sd1 : -5'sd1) + (bits[52] ? 5'sd1 : -5'sd1);
36: raw_field = (bits[19] ? 5'sd1 : -5'sd1) + (bits[20] ? 5'sd1 : -5'sd1) + (bits[21] ? -5'sd1 : 5'sd1) + (bits[35] ? -5'sd1 : 5'sd1) + (bits[37] ? -5'sd1 : 5'sd1) + (bits[51] ? 5'sd1 : -5'sd1) + (bits[52] ? -5'sd1 : 5'sd1) + (bits[53] ? 5'sd1 : -5'sd1);
37: raw_field = (bits[20] ? -5'sd1 : 5'sd1) + (bits[21] ? 5'sd1 : -5'sd1) + (bits[22] ? 5'sd1 : -5'sd1) + (bits[36] ? -5'sd1 : 5'sd1) + (bits[38] ? 5'sd1 : -5'sd1) + (bits[52] ? 5'sd1 : -5'sd1) + (bits[53] ? -5'sd1 : 5'sd1) + (bits[54] ? 5'sd1 : -5'sd1);
38: raw_field = (bits[21] ? -5'sd1 : 5'sd1) + (bits[22] ? -5'sd1 : 5'sd1) + (bits[23] ? -5'sd1 : 5'sd1) + (bits[37] ? 5'sd1 : -5'sd1) + (bits[39] ? 5'sd1 : -5'sd1) + (bits[53] ? 5'sd1 : -5'sd1) + (bits[54] ? 5'sd1 : -5'sd1) + (bits[55] ? 5'sd1 : -5'sd1);
39: raw_field = (bits[22] ? -5'sd1 : 5'sd1) + (bits[23] ? 5'sd1 : -5'sd1) + (bits[24] ? 5'sd1 : -5'sd1) + (bits[38] ? 5'sd1 : -5'sd1) + (bits[40] ? -5'sd1 : 5'sd1) + (bits[54] ? 5'sd1 : -5'sd1) + (bits[55] ? 5'sd1 : -5'sd1) + (bits[56] ? 5'sd1 : -5'sd1);
40: raw_field = (bits[23] ? -5'sd1 : 5'sd1) + (bits[24] ? -5'sd1 : 5'sd1) + (bits[25] ? 5'sd1 : -5'sd1) + (bits[39] ? -5'sd1 : 5'sd1) + (bits[41] ? -5'sd1 : 5'sd1) + (bits[55] ? 5'sd1 : -5'sd1) + (bits[56] ? -5'sd1 : 5'sd1) + (bits[57] ? 5'sd1 : -5'sd1);
41: raw_field = (bits[24] ? 5'sd1 : -5'sd1) + (bits[25] ? -5'sd1 : 5'sd1) + (bits[26] ? -5'sd1 : 5'sd1) + (bits[40] ? -5'sd1 : 5'sd1) + (bits[42] ? -5'sd1 : 5'sd1) + (bits[56] ? -5'sd1 : 5'sd1) + (bits[57] ? -5'sd1 : 5'sd1) + (bits[58] ? -5'sd1 : 5'sd1);
42: raw_field = (bits[25] ? -5'sd1 : 5'sd1) + (bits[26] ? -5'sd1 : 5'sd1) + (bits[27] ? -5'sd1 : 5'sd1) + (bits[41] ? -5'sd1 : 5'sd1) + (bits[43] ? 5'sd1 : -5'sd1) + (bits[57] ? 5'sd1 : -5'sd1) + (bits[58] ? 5'sd1 : -5'sd1) + (bits[59] ? 5'sd1 : -5'sd1);
43: raw_field = (bits[26] ? -5'sd1 : 5'sd1) + (bits[27] ? -5'sd1 : 5'sd1) + (bits[28] ? 5'sd1 : -5'sd1) + (bits[42] ? 5'sd1 : -5'sd1) + (bits[44] ? -5'sd1 : 5'sd1) + (bits[58] ? -5'sd1 : 5'sd1) + (bits[59] ? -5'sd1 : 5'sd1) + (bits[60] ? -5'sd1 : 5'sd1);
44: raw_field = (bits[27] ? 5'sd1 : -5'sd1) + (bits[28] ? -5'sd1 : 5'sd1) + (bits[29] ? -5'sd1 : 5'sd1) + (bits[43] ? -5'sd1 : 5'sd1) + (bits[45] ? -5'sd1 : 5'sd1) + (bits[59] ? 5'sd1 : -5'sd1) + (bits[60] ? -5'sd1 : 5'sd1) + (bits[61] ? -5'sd1 : 5'sd1);
45: raw_field = (bits[28] ? 5'sd1 : -5'sd1) + (bits[29] ? 5'sd1 : -5'sd1) + (bits[30] ? -5'sd1 : 5'sd1) + (bits[44] ? -5'sd1 : 5'sd1) + (bits[46] ? 5'sd1 : -5'sd1) + (bits[60] ? 5'sd1 : -5'sd1) + (bits[61] ? -5'sd1 : 5'sd1) + (bits[62] ? -5'sd1 : 5'sd1);
46: raw_field = (bits[29] ? 5'sd1 : -5'sd1) + (bits[30] ? 5'sd1 : -5'sd1) + (bits[31] ? -5'sd1 : 5'sd1) + (bits[45] ? 5'sd1 : -5'sd1) + (bits[47] ? 5'sd1 : -5'sd1) + (bits[61] ? 5'sd1 : -5'sd1) + (bits[62] ? -5'sd1 : 5'sd1) + (bits[63] ? 5'sd1 : -5'sd1);
47: raw_field = (bits[30] ? 5'sd1 : -5'sd1) + (bits[31] ? -5'sd1 : 5'sd1) + (bits[46] ? 5'sd1 : -5'sd1) + (bits[62] ? 5'sd1 : -5'sd1) + (bits[63] ? 5'sd1 : -5'sd1);
48: raw_field = (bits[32] ? 5'sd1 : -5'sd1) + (bits[33] ? -5'sd1 : 5'sd1) + (bits[49] ? 5'sd1 : -5'sd1) + (bits[64] ? 5'sd1 : -5'sd1) + (bits[65] ? -5'sd1 : 5'sd1);
49: raw_field = (bits[32] ? -5'sd1 : 5'sd1) + (bits[33] ? 5'sd1 : -5'sd1) + (bits[34] ? 5'sd1 : -5'sd1) + (bits[48] ? 5'sd1 : -5'sd1) + (bits[50] ? 5'sd1 : -5'sd1) + (bits[64] ? -5'sd1 : 5'sd1) + (bits[65] ? -5'sd1 : 5'sd1) + (bits[66] ? 5'sd1 : -5'sd1);
50: raw_field = (bits[33] ? -5'sd1 : 5'sd1) + (bits[34] ? -5'sd1 : 5'sd1) + (bits[35] ? 5'sd1 : -5'sd1) + (bits[49] ? 5'sd1 : -5'sd1) + (bits[51] ? 5'sd1 : -5'sd1) + (bits[65] ? -5'sd1 : 5'sd1) + (bits[66] ? -5'sd1 : 5'sd1) + (bits[67] ? 5'sd1 : -5'sd1);
51: raw_field = (bits[34] ? 5'sd1 : -5'sd1) + (bits[35] ? 5'sd1 : -5'sd1) + (bits[36] ? 5'sd1 : -5'sd1) + (bits[50] ? 5'sd1 : -5'sd1) + (bits[52] ? 5'sd1 : -5'sd1) + (bits[66] ? -5'sd1 : 5'sd1) + (bits[67] ? -5'sd1 : 5'sd1) + (bits[68] ? -5'sd1 : 5'sd1);
52: raw_field = (bits[35] ? 5'sd1 : -5'sd1) + (bits[36] ? -5'sd1 : 5'sd1) + (bits[37] ? 5'sd1 : -5'sd1) + (bits[51] ? 5'sd1 : -5'sd1) + (bits[53] ? -5'sd1 : 5'sd1) + (bits[67] ? -5'sd1 : 5'sd1) + (bits[68] ? 5'sd1 : -5'sd1) + (bits[69] ? 5'sd1 : -5'sd1);
53: raw_field = (bits[36] ? 5'sd1 : -5'sd1) + (bits[37] ? -5'sd1 : 5'sd1) + (bits[38] ? 5'sd1 : -5'sd1) + (bits[52] ? -5'sd1 : 5'sd1) + (bits[54] ? -5'sd1 : 5'sd1) + (bits[68] ? 5'sd1 : -5'sd1) + (bits[69] ? 5'sd1 : -5'sd1) + (bits[70] ? 5'sd1 : -5'sd1);
54: raw_field = (bits[37] ? 5'sd1 : -5'sd1) + (bits[38] ? 5'sd1 : -5'sd1) + (bits[39] ? 5'sd1 : -5'sd1) + (bits[53] ? -5'sd1 : 5'sd1) + (bits[55] ? -5'sd1 : 5'sd1) + (bits[69] ? 5'sd1 : -5'sd1) + (bits[70] ? -5'sd1 : 5'sd1) + (bits[71] ? -5'sd1 : 5'sd1);
55: raw_field = (bits[38] ? 5'sd1 : -5'sd1) + (bits[39] ? 5'sd1 : -5'sd1) + (bits[40] ? 5'sd1 : -5'sd1) + (bits[54] ? -5'sd1 : 5'sd1) + (bits[56] ? 5'sd1 : -5'sd1) + (bits[70] ? 5'sd1 : -5'sd1) + (bits[71] ? 5'sd1 : -5'sd1) + (bits[72] ? 5'sd1 : -5'sd1);
56: raw_field = (bits[39] ? 5'sd1 : -5'sd1) + (bits[40] ? -5'sd1 : 5'sd1) + (bits[41] ? -5'sd1 : 5'sd1) + (bits[55] ? 5'sd1 : -5'sd1) + (bits[57] ? -5'sd1 : 5'sd1) + (bits[71] ? 5'sd1 : -5'sd1) + (bits[72] ? 5'sd1 : -5'sd1) + (bits[73] ? 5'sd1 : -5'sd1);
57: raw_field = (bits[40] ? 5'sd1 : -5'sd1) + (bits[41] ? -5'sd1 : 5'sd1) + (bits[42] ? 5'sd1 : -5'sd1) + (bits[56] ? -5'sd1 : 5'sd1) + (bits[58] ? -5'sd1 : 5'sd1) + (bits[72] ? 5'sd1 : -5'sd1) + (bits[73] ? -5'sd1 : 5'sd1) + (bits[74] ? -5'sd1 : 5'sd1);
58: raw_field = (bits[41] ? -5'sd1 : 5'sd1) + (bits[42] ? 5'sd1 : -5'sd1) + (bits[43] ? -5'sd1 : 5'sd1) + (bits[57] ? -5'sd1 : 5'sd1) + (bits[59] ? -5'sd1 : 5'sd1) + (bits[73] ? 5'sd1 : -5'sd1) + (bits[74] ? -5'sd1 : 5'sd1) + (bits[75] ? -5'sd1 : 5'sd1);
59: raw_field = (bits[42] ? 5'sd1 : -5'sd1) + (bits[43] ? -5'sd1 : 5'sd1) + (bits[44] ? 5'sd1 : -5'sd1) + (bits[58] ? -5'sd1 : 5'sd1) + (bits[60] ? 5'sd1 : -5'sd1) + (bits[74] ? 5'sd1 : -5'sd1) + (bits[75] ? -5'sd1 : 5'sd1) + (bits[76] ? -5'sd1 : 5'sd1);
60: raw_field = (bits[43] ? -5'sd1 : 5'sd1) + (bits[44] ? -5'sd1 : 5'sd1) + (bits[45] ? 5'sd1 : -5'sd1) + (bits[59] ? 5'sd1 : -5'sd1) + (bits[61] ? 5'sd1 : -5'sd1) + (bits[75] ? 5'sd1 : -5'sd1) + (bits[76] ? 5'sd1 : -5'sd1) + (bits[77] ? 5'sd1 : -5'sd1);
61: raw_field = (bits[44] ? -5'sd1 : 5'sd1) + (bits[45] ? -5'sd1 : 5'sd1) + (bits[46] ? 5'sd1 : -5'sd1) + (bits[60] ? 5'sd1 : -5'sd1) + (bits[62] ? 5'sd1 : -5'sd1) + (bits[76] ? -5'sd1 : 5'sd1) + (bits[77] ? -5'sd1 : 5'sd1) + (bits[78] ? -5'sd1 : 5'sd1);
62: raw_field = (bits[45] ? -5'sd1 : 5'sd1) + (bits[46] ? -5'sd1 : 5'sd1) + (bits[47] ? 5'sd1 : -5'sd1) + (bits[61] ? 5'sd1 : -5'sd1) + (bits[63] ? 5'sd1 : -5'sd1) + (bits[77] ? 5'sd1 : -5'sd1) + (bits[78] ? -5'sd1 : 5'sd1) + (bits[79] ? 5'sd1 : -5'sd1);
63: raw_field = (bits[46] ? 5'sd1 : -5'sd1) + (bits[47] ? 5'sd1 : -5'sd1) + (bits[62] ? 5'sd1 : -5'sd1) + (bits[78] ? -5'sd1 : 5'sd1) + (bits[79] ? -5'sd1 : 5'sd1);
64: raw_field = (bits[48] ? 5'sd1 : -5'sd1) + (bits[49] ? -5'sd1 : 5'sd1) + (bits[65] ? -5'sd1 : 5'sd1) + (bits[80] ? 5'sd1 : -5'sd1) + (bits[81] ? 5'sd1 : -5'sd1);
65: raw_field = (bits[48] ? -5'sd1 : 5'sd1) + (bits[49] ? -5'sd1 : 5'sd1) + (bits[50] ? -5'sd1 : 5'sd1) + (bits[64] ? -5'sd1 : 5'sd1) + (bits[66] ? 5'sd1 : -5'sd1) + (bits[80] ? 5'sd1 : -5'sd1) + (bits[81] ? -5'sd1 : 5'sd1) + (bits[82] ? 5'sd1 : -5'sd1);
66: raw_field = (bits[49] ? 5'sd1 : -5'sd1) + (bits[50] ? -5'sd1 : 5'sd1) + (bits[51] ? -5'sd1 : 5'sd1) + (bits[65] ? 5'sd1 : -5'sd1) + (bits[67] ? 5'sd1 : -5'sd1) + (bits[81] ? 5'sd1 : -5'sd1) + (bits[82] ? 5'sd1 : -5'sd1) + (bits[83] ? -5'sd1 : 5'sd1);
67: raw_field = (bits[50] ? 5'sd1 : -5'sd1) + (bits[51] ? -5'sd1 : 5'sd1) + (bits[52] ? -5'sd1 : 5'sd1) + (bits[66] ? 5'sd1 : -5'sd1) + (bits[68] ? 5'sd1 : -5'sd1) + (bits[82] ? 5'sd1 : -5'sd1) + (bits[83] ? -5'sd1 : 5'sd1) + (bits[84] ? 5'sd1 : -5'sd1);
68: raw_field = (bits[51] ? -5'sd1 : 5'sd1) + (bits[52] ? 5'sd1 : -5'sd1) + (bits[53] ? 5'sd1 : -5'sd1) + (bits[67] ? 5'sd1 : -5'sd1) + (bits[69] ? 5'sd1 : -5'sd1) + (bits[83] ? -5'sd1 : 5'sd1) + (bits[84] ? 5'sd1 : -5'sd1) + (bits[85] ? -5'sd1 : 5'sd1);
69: raw_field = (bits[52] ? 5'sd1 : -5'sd1) + (bits[53] ? 5'sd1 : -5'sd1) + (bits[54] ? 5'sd1 : -5'sd1) + (bits[68] ? 5'sd1 : -5'sd1) + (bits[70] ? -5'sd1 : 5'sd1) + (bits[84] ? 5'sd1 : -5'sd1) + (bits[85] ? 5'sd1 : -5'sd1) + (bits[86] ? -5'sd1 : 5'sd1);
70: raw_field = (bits[53] ? 5'sd1 : -5'sd1) + (bits[54] ? -5'sd1 : 5'sd1) + (bits[55] ? 5'sd1 : -5'sd1) + (bits[69] ? -5'sd1 : 5'sd1) + (bits[71] ? 5'sd1 : -5'sd1) + (bits[85] ? -5'sd1 : 5'sd1) + (bits[86] ? 5'sd1 : -5'sd1) + (bits[87] ? 5'sd1 : -5'sd1);
71: raw_field = (bits[54] ? -5'sd1 : 5'sd1) + (bits[55] ? 5'sd1 : -5'sd1) + (bits[56] ? 5'sd1 : -5'sd1) + (bits[70] ? 5'sd1 : -5'sd1) + (bits[72] ? 5'sd1 : -5'sd1) + (bits[86] ? -5'sd1 : 5'sd1) + (bits[87] ? 5'sd1 : -5'sd1) + (bits[88] ? 5'sd1 : -5'sd1);
72: raw_field = (bits[55] ? 5'sd1 : -5'sd1) + (bits[56] ? 5'sd1 : -5'sd1) + (bits[57] ? 5'sd1 : -5'sd1) + (bits[71] ? 5'sd1 : -5'sd1) + (bits[73] ? -5'sd1 : 5'sd1) + (bits[87] ? -5'sd1 : 5'sd1) + (bits[88] ? -5'sd1 : 5'sd1) + (bits[89] ? -5'sd1 : 5'sd1);
73: raw_field = (bits[56] ? 5'sd1 : -5'sd1) + (bits[57] ? -5'sd1 : 5'sd1) + (bits[58] ? 5'sd1 : -5'sd1) + (bits[72] ? -5'sd1 : 5'sd1) + (bits[74] ? -5'sd1 : 5'sd1) + (bits[88] ? -5'sd1 : 5'sd1) + (bits[89] ? 5'sd1 : -5'sd1) + (bits[90] ? -5'sd1 : 5'sd1);
74: raw_field = (bits[57] ? -5'sd1 : 5'sd1) + (bits[58] ? -5'sd1 : 5'sd1) + (bits[59] ? 5'sd1 : -5'sd1) + (bits[73] ? -5'sd1 : 5'sd1) + (bits[75] ? 5'sd1 : -5'sd1) + (bits[89] ? -5'sd1 : 5'sd1) + (bits[90] ? 5'sd1 : -5'sd1) + (bits[91] ? -5'sd1 : 5'sd1);
75: raw_field = (bits[58] ? -5'sd1 : 5'sd1) + (bits[59] ? -5'sd1 : 5'sd1) + (bits[60] ? 5'sd1 : -5'sd1) + (bits[74] ? 5'sd1 : -5'sd1) + (bits[76] ? -5'sd1 : 5'sd1) + (bits[90] ? -5'sd1 : 5'sd1) + (bits[91] ? -5'sd1 : 5'sd1) + (bits[92] ? 5'sd1 : -5'sd1);
76: raw_field = (bits[59] ? -5'sd1 : 5'sd1) + (bits[60] ? 5'sd1 : -5'sd1) + (bits[61] ? -5'sd1 : 5'sd1) + (bits[75] ? -5'sd1 : 5'sd1) + (bits[77] ? 5'sd1 : -5'sd1) + (bits[91] ? 5'sd1 : -5'sd1) + (bits[92] ? 5'sd1 : -5'sd1) + (bits[93] ? 5'sd1 : -5'sd1);
77: raw_field = (bits[60] ? 5'sd1 : -5'sd1) + (bits[61] ? -5'sd1 : 5'sd1) + (bits[62] ? 5'sd1 : -5'sd1) + (bits[76] ? 5'sd1 : -5'sd1) + (bits[78] ? -5'sd1 : 5'sd1) + (bits[92] ? -5'sd1 : 5'sd1) + (bits[93] ? -5'sd1 : 5'sd1) + (bits[94] ? -5'sd1 : 5'sd1);
78: raw_field = (bits[61] ? -5'sd1 : 5'sd1) + (bits[62] ? -5'sd1 : 5'sd1) + (bits[63] ? -5'sd1 : 5'sd1) + (bits[77] ? -5'sd1 : 5'sd1) + (bits[79] ? -5'sd1 : 5'sd1) + (bits[93] ? -5'sd1 : 5'sd1) + (bits[94] ? -5'sd1 : 5'sd1) + (bits[95] ? 5'sd1 : -5'sd1);
79: raw_field = (bits[62] ? 5'sd1 : -5'sd1) + (bits[63] ? -5'sd1 : 5'sd1) + (bits[78] ? -5'sd1 : 5'sd1) + (bits[94] ? -5'sd1 : 5'sd1) + (bits[95] ? -5'sd1 : 5'sd1);
80: raw_field = (bits[64] ? 5'sd1 : -5'sd1) + (bits[65] ? 5'sd1 : -5'sd1) + (bits[81] ? -5'sd1 : 5'sd1) + (bits[96] ? 5'sd1 : -5'sd1) + (bits[97] ? -5'sd1 : 5'sd1);
81: raw_field = (bits[64] ? 5'sd1 : -5'sd1) + (bits[65] ? -5'sd1 : 5'sd1) + (bits[66] ? 5'sd1 : -5'sd1) + (bits[80] ? -5'sd1 : 5'sd1) + (bits[82] ? 5'sd1 : -5'sd1) + (bits[96] ? 5'sd1 : -5'sd1) + (bits[97] ? -5'sd1 : 5'sd1) + (bits[98] ? 5'sd1 : -5'sd1);
82: raw_field = (bits[65] ? 5'sd1 : -5'sd1) + (bits[66] ? 5'sd1 : -5'sd1) + (bits[67] ? 5'sd1 : -5'sd1) + (bits[81] ? 5'sd1 : -5'sd1) + (bits[83] ? 5'sd1 : -5'sd1) + (bits[97] ? 5'sd1 : -5'sd1) + (bits[98] ? -5'sd1 : 5'sd1) + (bits[99] ? 5'sd1 : -5'sd1);
83: raw_field = (bits[66] ? -5'sd1 : 5'sd1) + (bits[67] ? -5'sd1 : 5'sd1) + (bits[68] ? -5'sd1 : 5'sd1) + (bits[82] ? 5'sd1 : -5'sd1) + (bits[84] ? 5'sd1 : -5'sd1) + (bits[98] ? -5'sd1 : 5'sd1) + (bits[99] ? -5'sd1 : 5'sd1) + (bits[100] ? 5'sd1 : -5'sd1);
84: raw_field = (bits[67] ? 5'sd1 : -5'sd1) + (bits[68] ? 5'sd1 : -5'sd1) + (bits[69] ? 5'sd1 : -5'sd1) + (bits[83] ? 5'sd1 : -5'sd1) + (bits[85] ? 5'sd1 : -5'sd1) + (bits[99] ? -5'sd1 : 5'sd1) + (bits[100] ? -5'sd1 : 5'sd1) + (bits[101] ? -5'sd1 : 5'sd1);
85: raw_field = (bits[68] ? -5'sd1 : 5'sd1) + (bits[69] ? 5'sd1 : -5'sd1) + (bits[70] ? -5'sd1 : 5'sd1) + (bits[84] ? 5'sd1 : -5'sd1) + (bits[86] ? 5'sd1 : -5'sd1) + (bits[100] ? -5'sd1 : 5'sd1) + (bits[101] ? -5'sd1 : 5'sd1) + (bits[102] ? 5'sd1 : -5'sd1);
86: raw_field = (bits[69] ? -5'sd1 : 5'sd1) + (bits[70] ? 5'sd1 : -5'sd1) + (bits[71] ? -5'sd1 : 5'sd1) + (bits[85] ? 5'sd1 : -5'sd1) + (bits[87] ? 5'sd1 : -5'sd1) + (bits[101] ? -5'sd1 : 5'sd1) + (bits[102] ? -5'sd1 : 5'sd1) + (bits[103] ? -5'sd1 : 5'sd1);
87: raw_field = (bits[70] ? 5'sd1 : -5'sd1) + (bits[71] ? 5'sd1 : -5'sd1) + (bits[72] ? -5'sd1 : 5'sd1) + (bits[86] ? 5'sd1 : -5'sd1) + (bits[88] ? 5'sd1 : -5'sd1) + (bits[102] ? -5'sd1 : 5'sd1) + (bits[103] ? 5'sd1 : -5'sd1) + (bits[104] ? 5'sd1 : -5'sd1);
88: raw_field = (bits[71] ? 5'sd1 : -5'sd1) + (bits[72] ? -5'sd1 : 5'sd1) + (bits[73] ? -5'sd1 : 5'sd1) + (bits[87] ? 5'sd1 : -5'sd1) + (bits[89] ? 5'sd1 : -5'sd1) + (bits[103] ? 5'sd1 : -5'sd1) + (bits[104] ? 5'sd1 : -5'sd1) + (bits[105] ? -5'sd1 : 5'sd1);
89: raw_field = (bits[72] ? -5'sd1 : 5'sd1) + (bits[73] ? 5'sd1 : -5'sd1) + (bits[74] ? -5'sd1 : 5'sd1) + (bits[88] ? 5'sd1 : -5'sd1) + (bits[90] ? -5'sd1 : 5'sd1) + (bits[104] ? 5'sd1 : -5'sd1) + (bits[105] ? -5'sd1 : 5'sd1) + (bits[106] ? 5'sd1 : -5'sd1);
90: raw_field = (bits[73] ? -5'sd1 : 5'sd1) + (bits[74] ? 5'sd1 : -5'sd1) + (bits[75] ? -5'sd1 : 5'sd1) + (bits[89] ? -5'sd1 : 5'sd1) + (bits[91] ? 5'sd1 : -5'sd1) + (bits[105] ? -5'sd1 : 5'sd1) + (bits[106] ? 5'sd1 : -5'sd1) + (bits[107] ? -5'sd1 : 5'sd1);
91: raw_field = (bits[74] ? -5'sd1 : 5'sd1) + (bits[75] ? -5'sd1 : 5'sd1) + (bits[76] ? 5'sd1 : -5'sd1) + (bits[90] ? 5'sd1 : -5'sd1) + (bits[92] ? -5'sd1 : 5'sd1) + (bits[106] ? -5'sd1 : 5'sd1) + (bits[107] ? 5'sd1 : -5'sd1) + (bits[108] ? -5'sd1 : 5'sd1);
92: raw_field = (bits[75] ? 5'sd1 : -5'sd1) + (bits[76] ? 5'sd1 : -5'sd1) + (bits[77] ? -5'sd1 : 5'sd1) + (bits[91] ? -5'sd1 : 5'sd1) + (bits[93] ? -5'sd1 : 5'sd1) + (bits[107] ? -5'sd1 : 5'sd1) + (bits[108] ? 5'sd1 : -5'sd1) + (bits[109] ? 5'sd1 : -5'sd1);
93: raw_field = (bits[76] ? 5'sd1 : -5'sd1) + (bits[77] ? -5'sd1 : 5'sd1) + (bits[78] ? -5'sd1 : 5'sd1) + (bits[92] ? -5'sd1 : 5'sd1) + (bits[94] ? 5'sd1 : -5'sd1) + (bits[108] ? 5'sd1 : -5'sd1) + (bits[109] ? -5'sd1 : 5'sd1) + (bits[110] ? -5'sd1 : 5'sd1);
94: raw_field = (bits[77] ? -5'sd1 : 5'sd1) + (bits[78] ? -5'sd1 : 5'sd1) + (bits[79] ? -5'sd1 : 5'sd1) + (bits[93] ? 5'sd1 : -5'sd1) + (bits[95] ? 5'sd1 : -5'sd1) + (bits[109] ? 5'sd1 : -5'sd1) + (bits[110] ? -5'sd1 : 5'sd1) + (bits[111] ? 5'sd1 : -5'sd1);
95: raw_field = (bits[78] ? 5'sd1 : -5'sd1) + (bits[79] ? -5'sd1 : 5'sd1) + (bits[94] ? 5'sd1 : -5'sd1) + (bits[110] ? 5'sd1 : -5'sd1) + (bits[111] ? -5'sd1 : 5'sd1);
96: raw_field = (bits[80] ? 5'sd1 : -5'sd1) + (bits[81] ? 5'sd1 : -5'sd1) + (bits[97] ? -5'sd1 : 5'sd1) + (bits[112] ? 5'sd1 : -5'sd1) + (bits[113] ? -5'sd1 : 5'sd1);
97: raw_field = (bits[80] ? -5'sd1 : 5'sd1) + (bits[81] ? -5'sd1 : 5'sd1) + (bits[82] ? 5'sd1 : -5'sd1) + (bits[96] ? -5'sd1 : 5'sd1) + (bits[98] ? -5'sd1 : 5'sd1) + (bits[112] ? 5'sd1 : -5'sd1) + (bits[113] ? 5'sd1 : -5'sd1) + (bits[114] ? -5'sd1 : 5'sd1);
98: raw_field = (bits[81] ? 5'sd1 : -5'sd1) + (bits[82] ? -5'sd1 : 5'sd1) + (bits[83] ? -5'sd1 : 5'sd1) + (bits[97] ? -5'sd1 : 5'sd1) + (bits[99] ? -5'sd1 : 5'sd1) + (bits[113] ? 5'sd1 : -5'sd1) + (bits[114] ? 5'sd1 : -5'sd1) + (bits[115] ? -5'sd1 : 5'sd1);
99: raw_field = (bits[82] ? 5'sd1 : -5'sd1) + (bits[83] ? -5'sd1 : 5'sd1) + (bits[84] ? -5'sd1 : 5'sd1) + (bits[98] ? -5'sd1 : 5'sd1) + (bits[100] ? -5'sd1 : 5'sd1) + (bits[114] ? 5'sd1 : -5'sd1) + (bits[115] ? -5'sd1 : 5'sd1) + (bits[116] ? 5'sd1 : -5'sd1);
100: raw_field = (bits[83] ? 5'sd1 : -5'sd1) + (bits[84] ? -5'sd1 : 5'sd1) + (bits[85] ? -5'sd1 : 5'sd1) + (bits[99] ? -5'sd1 : 5'sd1) + (bits[101] ? -5'sd1 : 5'sd1) + (bits[115] ? 5'sd1 : -5'sd1) + (bits[116] ? 5'sd1 : -5'sd1) + (bits[117] ? 5'sd1 : -5'sd1);
101: raw_field = (bits[84] ? -5'sd1 : 5'sd1) + (bits[85] ? -5'sd1 : 5'sd1) + (bits[86] ? -5'sd1 : 5'sd1) + (bits[100] ? -5'sd1 : 5'sd1) + (bits[102] ? 5'sd1 : -5'sd1) + (bits[116] ? 5'sd1 : -5'sd1) + (bits[117] ? -5'sd1 : 5'sd1) + (bits[118] ? 5'sd1 : -5'sd1);
102: raw_field = (bits[85] ? 5'sd1 : -5'sd1) + (bits[86] ? -5'sd1 : 5'sd1) + (bits[87] ? -5'sd1 : 5'sd1) + (bits[101] ? 5'sd1 : -5'sd1) + (bits[103] ? -5'sd1 : 5'sd1) + (bits[117] ? 5'sd1 : -5'sd1) + (bits[118] ? -5'sd1 : 5'sd1) + (bits[119] ? -5'sd1 : 5'sd1);
103: raw_field = (bits[86] ? -5'sd1 : 5'sd1) + (bits[87] ? 5'sd1 : -5'sd1) + (bits[88] ? 5'sd1 : -5'sd1) + (bits[102] ? -5'sd1 : 5'sd1) + (bits[104] ? -5'sd1 : 5'sd1) + (bits[118] ? -5'sd1 : 5'sd1) + (bits[119] ? -5'sd1 : 5'sd1) + (bits[120] ? 5'sd1 : -5'sd1);
104: raw_field = (bits[87] ? 5'sd1 : -5'sd1) + (bits[88] ? 5'sd1 : -5'sd1) + (bits[89] ? 5'sd1 : -5'sd1) + (bits[103] ? -5'sd1 : 5'sd1) + (bits[105] ? -5'sd1 : 5'sd1) + (bits[119] ? 5'sd1 : -5'sd1) + (bits[120] ? -5'sd1 : 5'sd1) + (bits[121] ? -5'sd1 : 5'sd1);
105: raw_field = (bits[88] ? -5'sd1 : 5'sd1) + (bits[89] ? -5'sd1 : 5'sd1) + (bits[90] ? -5'sd1 : 5'sd1) + (bits[104] ? -5'sd1 : 5'sd1) + (bits[106] ? 5'sd1 : -5'sd1) + (bits[120] ? 5'sd1 : -5'sd1) + (bits[121] ? -5'sd1 : 5'sd1) + (bits[122] ? 5'sd1 : -5'sd1);
106: raw_field = (bits[89] ? 5'sd1 : -5'sd1) + (bits[90] ? 5'sd1 : -5'sd1) + (bits[91] ? -5'sd1 : 5'sd1) + (bits[105] ? 5'sd1 : -5'sd1) + (bits[107] ? -5'sd1 : 5'sd1) + (bits[121] ? 5'sd1 : -5'sd1) + (bits[122] ? 5'sd1 : -5'sd1) + (bits[123] ? -5'sd1 : 5'sd1);
107: raw_field = (bits[90] ? -5'sd1 : 5'sd1) + (bits[91] ? 5'sd1 : -5'sd1) + (bits[92] ? -5'sd1 : 5'sd1) + (bits[106] ? -5'sd1 : 5'sd1) + (bits[108] ? 5'sd1 : -5'sd1) + (bits[122] ? 5'sd1 : -5'sd1) + (bits[123] ? -5'sd1 : 5'sd1) + (bits[124] ? -5'sd1 : 5'sd1);
108: raw_field = (bits[91] ? -5'sd1 : 5'sd1) + (bits[92] ? 5'sd1 : -5'sd1) + (bits[93] ? 5'sd1 : -5'sd1) + (bits[107] ? 5'sd1 : -5'sd1) + (bits[109] ? 5'sd1 : -5'sd1) + (bits[123] ? 5'sd1 : -5'sd1) + (bits[124] ? 5'sd1 : -5'sd1) + (bits[125] ? 5'sd1 : -5'sd1);
109: raw_field = (bits[92] ? 5'sd1 : -5'sd1) + (bits[93] ? -5'sd1 : 5'sd1) + (bits[94] ? 5'sd1 : -5'sd1) + (bits[108] ? 5'sd1 : -5'sd1) + (bits[110] ? -5'sd1 : 5'sd1) + (bits[124] ? 5'sd1 : -5'sd1) + (bits[125] ? -5'sd1 : 5'sd1) + (bits[126] ? -5'sd1 : 5'sd1);
110: raw_field = (bits[93] ? -5'sd1 : 5'sd1) + (bits[94] ? -5'sd1 : 5'sd1) + (bits[95] ? 5'sd1 : -5'sd1) + (bits[109] ? -5'sd1 : 5'sd1) + (bits[111] ? 5'sd1 : -5'sd1) + (bits[125] ? 5'sd1 : -5'sd1) + (bits[126] ? -5'sd1 : 5'sd1) + (bits[127] ? -5'sd1 : 5'sd1);
111: raw_field = (bits[94] ? 5'sd1 : -5'sd1) + (bits[95] ? -5'sd1 : 5'sd1) + (bits[110] ? 5'sd1 : -5'sd1) + (bits[126] ? -5'sd1 : 5'sd1) + (bits[127] ? 5'sd1 : -5'sd1);
112: raw_field = (bits[96] ? 5'sd1 : -5'sd1) + (bits[97] ? 5'sd1 : -5'sd1) + (bits[113] ? 5'sd1 : -5'sd1) + (bits[128] ? 5'sd1 : -5'sd1) + (bits[129] ? 5'sd1 : -5'sd1);
113: raw_field = (bits[96] ? -5'sd1 : 5'sd1) + (bits[97] ? 5'sd1 : -5'sd1) + (bits[98] ? 5'sd1 : -5'sd1) + (bits[112] ? 5'sd1 : -5'sd1) + (bits[114] ? 5'sd1 : -5'sd1) + (bits[128] ? -5'sd1 : 5'sd1) + (bits[129] ? 5'sd1 : -5'sd1) + (bits[130] ? -5'sd1 : 5'sd1);
114: raw_field = (bits[97] ? -5'sd1 : 5'sd1) + (bits[98] ? 5'sd1 : -5'sd1) + (bits[99] ? 5'sd1 : -5'sd1) + (bits[113] ? 5'sd1 : -5'sd1) + (bits[115] ? -5'sd1 : 5'sd1) + (bits[129] ? -5'sd1 : 5'sd1) + (bits[130] ? 5'sd1 : -5'sd1) + (bits[131] ? -5'sd1 : 5'sd1);
115: raw_field = (bits[98] ? -5'sd1 : 5'sd1) + (bits[99] ? -5'sd1 : 5'sd1) + (bits[100] ? 5'sd1 : -5'sd1) + (bits[114] ? -5'sd1 : 5'sd1) + (bits[116] ? 5'sd1 : -5'sd1) + (bits[130] ? 5'sd1 : -5'sd1) + (bits[131] ? -5'sd1 : 5'sd1) + (bits[132] ? -5'sd1 : 5'sd1);
116: raw_field = (bits[99] ? 5'sd1 : -5'sd1) + (bits[100] ? 5'sd1 : -5'sd1) + (bits[101] ? 5'sd1 : -5'sd1) + (bits[115] ? 5'sd1 : -5'sd1) + (bits[117] ? -5'sd1 : 5'sd1) + (bits[131] ? -5'sd1 : 5'sd1) + (bits[132] ? 5'sd1 : -5'sd1) + (bits[133] ? -5'sd1 : 5'sd1);
117: raw_field = (bits[100] ? 5'sd1 : -5'sd1) + (bits[101] ? -5'sd1 : 5'sd1) + (bits[102] ? 5'sd1 : -5'sd1) + (bits[116] ? -5'sd1 : 5'sd1) + (bits[118] ? -5'sd1 : 5'sd1) + (bits[132] ? -5'sd1 : 5'sd1) + (bits[133] ? -5'sd1 : 5'sd1) + (bits[134] ? -5'sd1 : 5'sd1);
118: raw_field = (bits[101] ? 5'sd1 : -5'sd1) + (bits[102] ? -5'sd1 : 5'sd1) + (bits[103] ? -5'sd1 : 5'sd1) + (bits[117] ? -5'sd1 : 5'sd1) + (bits[119] ? -5'sd1 : 5'sd1) + (bits[133] ? -5'sd1 : 5'sd1) + (bits[134] ? 5'sd1 : -5'sd1) + (bits[135] ? 5'sd1 : -5'sd1);
119: raw_field = (bits[102] ? -5'sd1 : 5'sd1) + (bits[103] ? -5'sd1 : 5'sd1) + (bits[104] ? 5'sd1 : -5'sd1) + (bits[118] ? -5'sd1 : 5'sd1) + (bits[120] ? 5'sd1 : -5'sd1) + (bits[134] ? 5'sd1 : -5'sd1) + (bits[135] ? -5'sd1 : 5'sd1) + (bits[136] ? -5'sd1 : 5'sd1);
120: raw_field = (bits[103] ? 5'sd1 : -5'sd1) + (bits[104] ? -5'sd1 : 5'sd1) + (bits[105] ? 5'sd1 : -5'sd1) + (bits[119] ? 5'sd1 : -5'sd1) + (bits[121] ? -5'sd1 : 5'sd1) + (bits[135] ? 5'sd1 : -5'sd1) + (bits[136] ? -5'sd1 : 5'sd1) + (bits[137] ? 5'sd1 : -5'sd1);
121: raw_field = (bits[104] ? -5'sd1 : 5'sd1) + (bits[105] ? -5'sd1 : 5'sd1) + (bits[106] ? 5'sd1 : -5'sd1) + (bits[120] ? -5'sd1 : 5'sd1) + (bits[122] ? -5'sd1 : 5'sd1) + (bits[136] ? 5'sd1 : -5'sd1) + (bits[137] ? -5'sd1 : 5'sd1) + (bits[138] ? -5'sd1 : 5'sd1);
122: raw_field = (bits[105] ? 5'sd1 : -5'sd1) + (bits[106] ? 5'sd1 : -5'sd1) + (bits[107] ? 5'sd1 : -5'sd1) + (bits[121] ? -5'sd1 : 5'sd1) + (bits[123] ? -5'sd1 : 5'sd1) + (bits[137] ? 5'sd1 : -5'sd1) + (bits[138] ? 5'sd1 : -5'sd1) + (bits[139] ? -5'sd1 : 5'sd1);
123: raw_field = (bits[106] ? -5'sd1 : 5'sd1) + (bits[107] ? -5'sd1 : 5'sd1) + (bits[108] ? 5'sd1 : -5'sd1) + (bits[122] ? -5'sd1 : 5'sd1) + (bits[124] ? 5'sd1 : -5'sd1) + (bits[138] ? 5'sd1 : -5'sd1) + (bits[139] ? 5'sd1 : -5'sd1) + (bits[140] ? -5'sd1 : 5'sd1);
124: raw_field = (bits[107] ? -5'sd1 : 5'sd1) + (bits[108] ? 5'sd1 : -5'sd1) + (bits[109] ? 5'sd1 : -5'sd1) + (bits[123] ? 5'sd1 : -5'sd1) + (bits[125] ? -5'sd1 : 5'sd1) + (bits[139] ? 5'sd1 : -5'sd1) + (bits[140] ? -5'sd1 : 5'sd1) + (bits[141] ? -5'sd1 : 5'sd1);
125: raw_field = (bits[108] ? 5'sd1 : -5'sd1) + (bits[109] ? -5'sd1 : 5'sd1) + (bits[110] ? 5'sd1 : -5'sd1) + (bits[124] ? -5'sd1 : 5'sd1) + (bits[126] ? 5'sd1 : -5'sd1) + (bits[140] ? 5'sd1 : -5'sd1) + (bits[141] ? -5'sd1 : 5'sd1) + (bits[142] ? 5'sd1 : -5'sd1);
126: raw_field = (bits[109] ? -5'sd1 : 5'sd1) + (bits[110] ? -5'sd1 : 5'sd1) + (bits[111] ? -5'sd1 : 5'sd1) + (bits[125] ? 5'sd1 : -5'sd1) + (bits[127] ? -5'sd1 : 5'sd1) + (bits[141] ? 5'sd1 : -5'sd1) + (bits[142] ? 5'sd1 : -5'sd1) + (bits[143] ? 5'sd1 : -5'sd1);
127: raw_field = (bits[110] ? -5'sd1 : 5'sd1) + (bits[111] ? 5'sd1 : -5'sd1) + (bits[126] ? -5'sd1 : 5'sd1) + (bits[142] ? -5'sd1 : 5'sd1) + (bits[143] ? 5'sd1 : -5'sd1);
128: raw_field = (bits[112] ? 5'sd1 : -5'sd1) + (bits[113] ? -5'sd1 : 5'sd1) + (bits[129] ? -5'sd1 : 5'sd1) + (bits[144] ? 5'sd1 : -5'sd1) + (bits[145] ? -5'sd1 : 5'sd1);
129: raw_field = (bits[112] ? 5'sd1 : -5'sd1) + (bits[113] ? 5'sd1 : -5'sd1) + (bits[114] ? -5'sd1 : 5'sd1) + (bits[128] ? -5'sd1 : 5'sd1) + (bits[130] ? 5'sd1 : -5'sd1) + (bits[144] ? -5'sd1 : 5'sd1) + (bits[145] ? 5'sd1 : -5'sd1) + (bits[146] ? 5'sd1 : -5'sd1);
130: raw_field = (bits[113] ? -5'sd1 : 5'sd1) + (bits[114] ? 5'sd1 : -5'sd1) + (bits[115] ? 5'sd1 : -5'sd1) + (bits[129] ? 5'sd1 : -5'sd1) + (bits[131] ? 5'sd1 : -5'sd1) + (bits[145] ? -5'sd1 : 5'sd1) + (bits[146] ? 5'sd1 : -5'sd1) + (bits[147] ? -5'sd1 : 5'sd1);
131: raw_field = (bits[114] ? -5'sd1 : 5'sd1) + (bits[115] ? -5'sd1 : 5'sd1) + (bits[116] ? -5'sd1 : 5'sd1) + (bits[130] ? 5'sd1 : -5'sd1) + (bits[132] ? -5'sd1 : 5'sd1) + (bits[146] ? 5'sd1 : -5'sd1) + (bits[147] ? 5'sd1 : -5'sd1) + (bits[148] ? -5'sd1 : 5'sd1);
132: raw_field = (bits[115] ? -5'sd1 : 5'sd1) + (bits[116] ? 5'sd1 : -5'sd1) + (bits[117] ? -5'sd1 : 5'sd1) + (bits[131] ? -5'sd1 : 5'sd1) + (bits[133] ? -5'sd1 : 5'sd1) + (bits[147] ? -5'sd1 : 5'sd1) + (bits[148] ? 5'sd1 : -5'sd1) + (bits[149] ? -5'sd1 : 5'sd1);
133: raw_field = (bits[116] ? -5'sd1 : 5'sd1) + (bits[117] ? -5'sd1 : 5'sd1) + (bits[118] ? -5'sd1 : 5'sd1) + (bits[132] ? -5'sd1 : 5'sd1) + (bits[134] ? 5'sd1 : -5'sd1) + (bits[148] ? -5'sd1 : 5'sd1) + (bits[149] ? 5'sd1 : -5'sd1) + (bits[150] ? -5'sd1 : 5'sd1);
134: raw_field = (bits[117] ? -5'sd1 : 5'sd1) + (bits[118] ? 5'sd1 : -5'sd1) + (bits[119] ? 5'sd1 : -5'sd1) + (bits[133] ? 5'sd1 : -5'sd1) + (bits[135] ? 5'sd1 : -5'sd1) + (bits[149] ? 5'sd1 : -5'sd1) + (bits[150] ? 5'sd1 : -5'sd1) + (bits[151] ? -5'sd1 : 5'sd1);
135: raw_field = (bits[118] ? 5'sd1 : -5'sd1) + (bits[119] ? -5'sd1 : 5'sd1) + (bits[120] ? 5'sd1 : -5'sd1) + (bits[134] ? 5'sd1 : -5'sd1) + (bits[136] ? -5'sd1 : 5'sd1) + (bits[150] ? 5'sd1 : -5'sd1) + (bits[151] ? 5'sd1 : -5'sd1) + (bits[152] ? -5'sd1 : 5'sd1);
136: raw_field = (bits[119] ? -5'sd1 : 5'sd1) + (bits[120] ? -5'sd1 : 5'sd1) + (bits[121] ? 5'sd1 : -5'sd1) + (bits[135] ? -5'sd1 : 5'sd1) + (bits[137] ? 5'sd1 : -5'sd1) + (bits[151] ? 5'sd1 : -5'sd1) + (bits[152] ? 5'sd1 : -5'sd1) + (bits[153] ? 5'sd1 : -5'sd1);
137: raw_field = (bits[120] ? 5'sd1 : -5'sd1) + (bits[121] ? -5'sd1 : 5'sd1) + (bits[122] ? 5'sd1 : -5'sd1) + (bits[136] ? 5'sd1 : -5'sd1) + (bits[138] ? -5'sd1 : 5'sd1) + (bits[152] ? -5'sd1 : 5'sd1) + (bits[153] ? 5'sd1 : -5'sd1) + (bits[154] ? 5'sd1 : -5'sd1);
138: raw_field = (bits[121] ? -5'sd1 : 5'sd1) + (bits[122] ? 5'sd1 : -5'sd1) + (bits[123] ? 5'sd1 : -5'sd1) + (bits[137] ? -5'sd1 : 5'sd1) + (bits[139] ? -5'sd1 : 5'sd1) + (bits[153] ? 5'sd1 : -5'sd1) + (bits[154] ? 5'sd1 : -5'sd1) + (bits[155] ? 5'sd1 : -5'sd1);
139: raw_field = (bits[122] ? -5'sd1 : 5'sd1) + (bits[123] ? 5'sd1 : -5'sd1) + (bits[124] ? 5'sd1 : -5'sd1) + (bits[138] ? -5'sd1 : 5'sd1) + (bits[140] ? -5'sd1 : 5'sd1) + (bits[154] ? -5'sd1 : 5'sd1) + (bits[155] ? -5'sd1 : 5'sd1) + (bits[156] ? 5'sd1 : -5'sd1);
140: raw_field = (bits[123] ? -5'sd1 : 5'sd1) + (bits[124] ? -5'sd1 : 5'sd1) + (bits[125] ? 5'sd1 : -5'sd1) + (bits[139] ? -5'sd1 : 5'sd1) + (bits[141] ? -5'sd1 : 5'sd1) + (bits[155] ? 5'sd1 : -5'sd1) + (bits[156] ? -5'sd1 : 5'sd1) + (bits[157] ? -5'sd1 : 5'sd1);
141: raw_field = (bits[124] ? -5'sd1 : 5'sd1) + (bits[125] ? -5'sd1 : 5'sd1) + (bits[126] ? 5'sd1 : -5'sd1) + (bits[140] ? -5'sd1 : 5'sd1) + (bits[142] ? 5'sd1 : -5'sd1) + (bits[156] ? 5'sd1 : -5'sd1) + (bits[157] ? -5'sd1 : 5'sd1) + (bits[158] ? -5'sd1 : 5'sd1);
142: raw_field = (bits[125] ? 5'sd1 : -5'sd1) + (bits[126] ? 5'sd1 : -5'sd1) + (bits[127] ? -5'sd1 : 5'sd1) + (bits[141] ? 5'sd1 : -5'sd1) + (bits[143] ? 5'sd1 : -5'sd1) + (bits[157] ? 5'sd1 : -5'sd1) + (bits[158] ? 5'sd1 : -5'sd1) + (bits[159] ? -5'sd1 : 5'sd1);
143: raw_field = (bits[126] ? 5'sd1 : -5'sd1) + (bits[127] ? 5'sd1 : -5'sd1) + (bits[142] ? 5'sd1 : -5'sd1) + (bits[158] ? -5'sd1 : 5'sd1) + (bits[159] ? -5'sd1 : 5'sd1);
144: raw_field = (bits[128] ? 5'sd1 : -5'sd1) + (bits[129] ? -5'sd1 : 5'sd1) + (bits[145] ? 5'sd1 : -5'sd1) + (bits[160] ? 5'sd1 : -5'sd1) + (bits[161] ? 5'sd1 : -5'sd1);
145: raw_field = (bits[128] ? -5'sd1 : 5'sd1) + (bits[129] ? 5'sd1 : -5'sd1) + (bits[130] ? -5'sd1 : 5'sd1) + (bits[144] ? 5'sd1 : -5'sd1) + (bits[146] ? 5'sd1 : -5'sd1) + (bits[160] ? -5'sd1 : 5'sd1) + (bits[161] ? -5'sd1 : 5'sd1) + (bits[162] ? -5'sd1 : 5'sd1);
146: raw_field = (bits[129] ? 5'sd1 : -5'sd1) + (bits[130] ? 5'sd1 : -5'sd1) + (bits[131] ? 5'sd1 : -5'sd1) + (bits[145] ? 5'sd1 : -5'sd1) + (bits[147] ? -5'sd1 : 5'sd1) + (bits[161] ? -5'sd1 : 5'sd1) + (bits[162] ? 5'sd1 : -5'sd1) + (bits[163] ? 5'sd1 : -5'sd1);
147: raw_field = (bits[130] ? -5'sd1 : 5'sd1) + (bits[131] ? 5'sd1 : -5'sd1) + (bits[132] ? -5'sd1 : 5'sd1) + (bits[146] ? -5'sd1 : 5'sd1) + (bits[148] ? -5'sd1 : 5'sd1) + (bits[162] ? -5'sd1 : 5'sd1) + (bits[163] ? 5'sd1 : -5'sd1) + (bits[164] ? 5'sd1 : -5'sd1);
148: raw_field = (bits[131] ? -5'sd1 : 5'sd1) + (bits[132] ? 5'sd1 : -5'sd1) + (bits[133] ? -5'sd1 : 5'sd1) + (bits[147] ? -5'sd1 : 5'sd1) + (bits[149] ? 5'sd1 : -5'sd1) + (bits[163] ? -5'sd1 : 5'sd1) + (bits[164] ? -5'sd1 : 5'sd1) + (bits[165] ? -5'sd1 : 5'sd1);
149: raw_field = (bits[132] ? -5'sd1 : 5'sd1) + (bits[133] ? 5'sd1 : -5'sd1) + (bits[134] ? 5'sd1 : -5'sd1) + (bits[148] ? 5'sd1 : -5'sd1) + (bits[150] ? -5'sd1 : 5'sd1) + (bits[164] ? 5'sd1 : -5'sd1) + (bits[165] ? -5'sd1 : 5'sd1) + (bits[166] ? -5'sd1 : 5'sd1);
150: raw_field = (bits[133] ? -5'sd1 : 5'sd1) + (bits[134] ? 5'sd1 : -5'sd1) + (bits[135] ? 5'sd1 : -5'sd1) + (bits[149] ? -5'sd1 : 5'sd1) + (bits[151] ? 5'sd1 : -5'sd1) + (bits[165] ? 5'sd1 : -5'sd1) + (bits[166] ? 5'sd1 : -5'sd1) + (bits[167] ? 5'sd1 : -5'sd1);
151: raw_field = (bits[134] ? -5'sd1 : 5'sd1) + (bits[135] ? 5'sd1 : -5'sd1) + (bits[136] ? 5'sd1 : -5'sd1) + (bits[150] ? 5'sd1 : -5'sd1) + (bits[152] ? 5'sd1 : -5'sd1) + (bits[166] ? -5'sd1 : 5'sd1) + (bits[167] ? -5'sd1 : 5'sd1) + (bits[168] ? -5'sd1 : 5'sd1);
152: raw_field = (bits[135] ? -5'sd1 : 5'sd1) + (bits[136] ? 5'sd1 : -5'sd1) + (bits[137] ? -5'sd1 : 5'sd1) + (bits[151] ? 5'sd1 : -5'sd1) + (bits[153] ? 5'sd1 : -5'sd1) + (bits[167] ? 5'sd1 : -5'sd1) + (bits[168] ? 5'sd1 : -5'sd1) + (bits[169] ? 5'sd1 : -5'sd1);
153: raw_field = (bits[136] ? 5'sd1 : -5'sd1) + (bits[137] ? 5'sd1 : -5'sd1) + (bits[138] ? 5'sd1 : -5'sd1) + (bits[152] ? 5'sd1 : -5'sd1) + (bits[154] ? 5'sd1 : -5'sd1) + (bits[168] ? -5'sd1 : 5'sd1) + (bits[169] ? -5'sd1 : 5'sd1) + (bits[170] ? 5'sd1 : -5'sd1);
154: raw_field = (bits[137] ? 5'sd1 : -5'sd1) + (bits[138] ? 5'sd1 : -5'sd1) + (bits[139] ? -5'sd1 : 5'sd1) + (bits[153] ? 5'sd1 : -5'sd1) + (bits[155] ? 5'sd1 : -5'sd1) + (bits[169] ? 5'sd1 : -5'sd1) + (bits[170] ? -5'sd1 : 5'sd1) + (bits[171] ? -5'sd1 : 5'sd1);
155: raw_field = (bits[138] ? 5'sd1 : -5'sd1) + (bits[139] ? -5'sd1 : 5'sd1) + (bits[140] ? 5'sd1 : -5'sd1) + (bits[154] ? 5'sd1 : -5'sd1) + (bits[156] ? -5'sd1 : 5'sd1) + (bits[170] ? -5'sd1 : 5'sd1) + (bits[171] ? -5'sd1 : 5'sd1) + (bits[172] ? -5'sd1 : 5'sd1);
156: raw_field = (bits[139] ? 5'sd1 : -5'sd1) + (bits[140] ? -5'sd1 : 5'sd1) + (bits[141] ? 5'sd1 : -5'sd1) + (bits[155] ? -5'sd1 : 5'sd1) + (bits[157] ? 5'sd1 : -5'sd1) + (bits[171] ? 5'sd1 : -5'sd1) + (bits[172] ? 5'sd1 : -5'sd1) + (bits[173] ? -5'sd1 : 5'sd1);
157: raw_field = (bits[140] ? -5'sd1 : 5'sd1) + (bits[141] ? -5'sd1 : 5'sd1) + (bits[142] ? 5'sd1 : -5'sd1) + (bits[156] ? 5'sd1 : -5'sd1) + (bits[158] ? 5'sd1 : -5'sd1) + (bits[172] ? 5'sd1 : -5'sd1) + (bits[173] ? -5'sd1 : 5'sd1) + (bits[174] ? 5'sd1 : -5'sd1);
158: raw_field = (bits[141] ? -5'sd1 : 5'sd1) + (bits[142] ? 5'sd1 : -5'sd1) + (bits[143] ? -5'sd1 : 5'sd1) + (bits[157] ? 5'sd1 : -5'sd1) + (bits[159] ? -5'sd1 : 5'sd1) + (bits[173] ? -5'sd1 : 5'sd1) + (bits[174] ? 5'sd1 : -5'sd1) + (bits[175] ? 5'sd1 : -5'sd1);
159: raw_field = (bits[142] ? -5'sd1 : 5'sd1) + (bits[143] ? -5'sd1 : 5'sd1) + (bits[158] ? -5'sd1 : 5'sd1) + (bits[174] ? 5'sd1 : -5'sd1) + (bits[175] ? -5'sd1 : 5'sd1);
160: raw_field = (bits[144] ? 5'sd1 : -5'sd1) + (bits[145] ? -5'sd1 : 5'sd1) + (bits[161] ? -5'sd1 : 5'sd1) + (bits[176] ? -5'sd1 : 5'sd1) + (bits[177] ? 5'sd1 : -5'sd1);
161: raw_field = (bits[144] ? 5'sd1 : -5'sd1) + (bits[145] ? -5'sd1 : 5'sd1) + (bits[146] ? -5'sd1 : 5'sd1) + (bits[160] ? -5'sd1 : 5'sd1) + (bits[162] ? -5'sd1 : 5'sd1) + (bits[176] ? -5'sd1 : 5'sd1) + (bits[177] ? -5'sd1 : 5'sd1) + (bits[178] ? -5'sd1 : 5'sd1);
162: raw_field = (bits[145] ? -5'sd1 : 5'sd1) + (bits[146] ? 5'sd1 : -5'sd1) + (bits[147] ? -5'sd1 : 5'sd1) + (bits[161] ? -5'sd1 : 5'sd1) + (bits[163] ? -5'sd1 : 5'sd1) + (bits[177] ? 5'sd1 : -5'sd1) + (bits[178] ? -5'sd1 : 5'sd1) + (bits[179] ? 5'sd1 : -5'sd1);
163: raw_field = (bits[146] ? 5'sd1 : -5'sd1) + (bits[147] ? 5'sd1 : -5'sd1) + (bits[148] ? -5'sd1 : 5'sd1) + (bits[162] ? -5'sd1 : 5'sd1) + (bits[164] ? -5'sd1 : 5'sd1) + (bits[178] ? -5'sd1 : 5'sd1) + (bits[179] ? -5'sd1 : 5'sd1) + (bits[180] ? -5'sd1 : 5'sd1);
164: raw_field = (bits[147] ? 5'sd1 : -5'sd1) + (bits[148] ? -5'sd1 : 5'sd1) + (bits[149] ? 5'sd1 : -5'sd1) + (bits[163] ? -5'sd1 : 5'sd1) + (bits[165] ? 5'sd1 : -5'sd1) + (bits[179] ? 5'sd1 : -5'sd1) + (bits[180] ? -5'sd1 : 5'sd1) + (bits[181] ? 5'sd1 : -5'sd1);
165: raw_field = (bits[148] ? -5'sd1 : 5'sd1) + (bits[149] ? -5'sd1 : 5'sd1) + (bits[150] ? 5'sd1 : -5'sd1) + (bits[164] ? 5'sd1 : -5'sd1) + (bits[166] ? 5'sd1 : -5'sd1) + (bits[180] ? -5'sd1 : 5'sd1) + (bits[181] ? -5'sd1 : 5'sd1) + (bits[182] ? -5'sd1 : 5'sd1);
166: raw_field = (bits[149] ? -5'sd1 : 5'sd1) + (bits[150] ? 5'sd1 : -5'sd1) + (bits[151] ? -5'sd1 : 5'sd1) + (bits[165] ? 5'sd1 : -5'sd1) + (bits[167] ? 5'sd1 : -5'sd1) + (bits[181] ? -5'sd1 : 5'sd1) + (bits[182] ? 5'sd1 : -5'sd1) + (bits[183] ? 5'sd1 : -5'sd1);
167: raw_field = (bits[150] ? 5'sd1 : -5'sd1) + (bits[151] ? -5'sd1 : 5'sd1) + (bits[152] ? 5'sd1 : -5'sd1) + (bits[166] ? 5'sd1 : -5'sd1) + (bits[168] ? -5'sd1 : 5'sd1) + (bits[182] ? -5'sd1 : 5'sd1) + (bits[183] ? 5'sd1 : -5'sd1) + (bits[184] ? -5'sd1 : 5'sd1);
168: raw_field = (bits[151] ? -5'sd1 : 5'sd1) + (bits[152] ? 5'sd1 : -5'sd1) + (bits[153] ? -5'sd1 : 5'sd1) + (bits[167] ? -5'sd1 : 5'sd1) + (bits[169] ? -5'sd1 : 5'sd1) + (bits[183] ? 5'sd1 : -5'sd1) + (bits[184] ? -5'sd1 : 5'sd1) + (bits[185] ? 5'sd1 : -5'sd1);
169: raw_field = (bits[152] ? 5'sd1 : -5'sd1) + (bits[153] ? -5'sd1 : 5'sd1) + (bits[154] ? 5'sd1 : -5'sd1) + (bits[168] ? -5'sd1 : 5'sd1) + (bits[170] ? 5'sd1 : -5'sd1) + (bits[184] ? -5'sd1 : 5'sd1) + (bits[185] ? -5'sd1 : 5'sd1) + (bits[186] ? -5'sd1 : 5'sd1);
170: raw_field = (bits[153] ? 5'sd1 : -5'sd1) + (bits[154] ? -5'sd1 : 5'sd1) + (bits[155] ? -5'sd1 : 5'sd1) + (bits[169] ? 5'sd1 : -5'sd1) + (bits[171] ? -5'sd1 : 5'sd1) + (bits[185] ? 5'sd1 : -5'sd1) + (bits[186] ? -5'sd1 : 5'sd1) + (bits[187] ? -5'sd1 : 5'sd1);
171: raw_field = (bits[154] ? -5'sd1 : 5'sd1) + (bits[155] ? -5'sd1 : 5'sd1) + (bits[156] ? 5'sd1 : -5'sd1) + (bits[170] ? -5'sd1 : 5'sd1) + (bits[172] ? 5'sd1 : -5'sd1) + (bits[186] ? 5'sd1 : -5'sd1) + (bits[187] ? 5'sd1 : -5'sd1) + (bits[188] ? -5'sd1 : 5'sd1);
172: raw_field = (bits[155] ? -5'sd1 : 5'sd1) + (bits[156] ? 5'sd1 : -5'sd1) + (bits[157] ? 5'sd1 : -5'sd1) + (bits[171] ? 5'sd1 : -5'sd1) + (bits[173] ? -5'sd1 : 5'sd1) + (bits[187] ? -5'sd1 : 5'sd1) + (bits[188] ? -5'sd1 : 5'sd1) + (bits[189] ? 5'sd1 : -5'sd1);
173: raw_field = (bits[156] ? -5'sd1 : 5'sd1) + (bits[157] ? -5'sd1 : 5'sd1) + (bits[158] ? -5'sd1 : 5'sd1) + (bits[172] ? -5'sd1 : 5'sd1) + (bits[174] ? -5'sd1 : 5'sd1) + (bits[188] ? -5'sd1 : 5'sd1) + (bits[189] ? 5'sd1 : -5'sd1) + (bits[190] ? 5'sd1 : -5'sd1);
174: raw_field = (bits[157] ? 5'sd1 : -5'sd1) + (bits[158] ? 5'sd1 : -5'sd1) + (bits[159] ? 5'sd1 : -5'sd1) + (bits[173] ? -5'sd1 : 5'sd1) + (bits[175] ? 5'sd1 : -5'sd1) + (bits[189] ? 5'sd1 : -5'sd1) + (bits[190] ? -5'sd1 : 5'sd1) + (bits[191] ? 5'sd1 : -5'sd1);
175: raw_field = (bits[158] ? 5'sd1 : -5'sd1) + (bits[159] ? -5'sd1 : 5'sd1) + (bits[174] ? 5'sd1 : -5'sd1) + (bits[190] ? 5'sd1 : -5'sd1) + (bits[191] ? 5'sd1 : -5'sd1);
176: raw_field = (bits[160] ? -5'sd1 : 5'sd1) + (bits[161] ? -5'sd1 : 5'sd1) + (bits[177] ? -5'sd1 : 5'sd1) + (bits[192] ? 5'sd1 : -5'sd1) + (bits[193] ? -5'sd1 : 5'sd1);
177: raw_field = (bits[160] ? 5'sd1 : -5'sd1) + (bits[161] ? -5'sd1 : 5'sd1) + (bits[162] ? 5'sd1 : -5'sd1) + (bits[176] ? -5'sd1 : 5'sd1) + (bits[178] ? -5'sd1 : 5'sd1) + (bits[192] ? -5'sd1 : 5'sd1) + (bits[193] ? -5'sd1 : 5'sd1) + (bits[194] ? -5'sd1 : 5'sd1);
178: raw_field = (bits[161] ? -5'sd1 : 5'sd1) + (bits[162] ? -5'sd1 : 5'sd1) + (bits[163] ? -5'sd1 : 5'sd1) + (bits[177] ? -5'sd1 : 5'sd1) + (bits[179] ? -5'sd1 : 5'sd1) + (bits[193] ? -5'sd1 : 5'sd1) + (bits[194] ? 5'sd1 : -5'sd1) + (bits[195] ? -5'sd1 : 5'sd1);
179: raw_field = (bits[162] ? 5'sd1 : -5'sd1) + (bits[163] ? -5'sd1 : 5'sd1) + (bits[164] ? 5'sd1 : -5'sd1) + (bits[178] ? -5'sd1 : 5'sd1) + (bits[180] ? 5'sd1 : -5'sd1) + (bits[194] ? 5'sd1 : -5'sd1) + (bits[195] ? 5'sd1 : -5'sd1) + (bits[196] ? -5'sd1 : 5'sd1);
180: raw_field = (bits[163] ? -5'sd1 : 5'sd1) + (bits[164] ? -5'sd1 : 5'sd1) + (bits[165] ? -5'sd1 : 5'sd1) + (bits[179] ? 5'sd1 : -5'sd1) + (bits[181] ? -5'sd1 : 5'sd1) + (bits[195] ? 5'sd1 : -5'sd1) + (bits[196] ? 5'sd1 : -5'sd1) + (bits[197] ? -5'sd1 : 5'sd1);
181: raw_field = (bits[164] ? 5'sd1 : -5'sd1) + (bits[165] ? -5'sd1 : 5'sd1) + (bits[166] ? -5'sd1 : 5'sd1) + (bits[180] ? -5'sd1 : 5'sd1) + (bits[182] ? 5'sd1 : -5'sd1) + (bits[196] ? -5'sd1 : 5'sd1) + (bits[197] ? 5'sd1 : -5'sd1) + (bits[198] ? 5'sd1 : -5'sd1);
182: raw_field = (bits[165] ? -5'sd1 : 5'sd1) + (bits[166] ? 5'sd1 : -5'sd1) + (bits[167] ? -5'sd1 : 5'sd1) + (bits[181] ? 5'sd1 : -5'sd1) + (bits[183] ? -5'sd1 : 5'sd1) + (bits[197] ? -5'sd1 : 5'sd1) + (bits[198] ? -5'sd1 : 5'sd1) + (bits[199] ? -5'sd1 : 5'sd1);
183: raw_field = (bits[166] ? 5'sd1 : -5'sd1) + (bits[167] ? 5'sd1 : -5'sd1) + (bits[168] ? 5'sd1 : -5'sd1) + (bits[182] ? -5'sd1 : 5'sd1) + (bits[184] ? -5'sd1 : 5'sd1) + (bits[198] ? -5'sd1 : 5'sd1) + (bits[199] ? 5'sd1 : -5'sd1) + (bits[200] ? 5'sd1 : -5'sd1);
184: raw_field = (bits[167] ? -5'sd1 : 5'sd1) + (bits[168] ? -5'sd1 : 5'sd1) + (bits[169] ? -5'sd1 : 5'sd1) + (bits[183] ? -5'sd1 : 5'sd1) + (bits[185] ? -5'sd1 : 5'sd1) + (bits[199] ? -5'sd1 : 5'sd1) + (bits[200] ? 5'sd1 : -5'sd1) + (bits[201] ? 5'sd1 : -5'sd1);
185: raw_field = (bits[168] ? 5'sd1 : -5'sd1) + (bits[169] ? -5'sd1 : 5'sd1) + (bits[170] ? 5'sd1 : -5'sd1) + (bits[184] ? -5'sd1 : 5'sd1) + (bits[186] ? -5'sd1 : 5'sd1) + (bits[200] ? -5'sd1 : 5'sd1) + (bits[201] ? 5'sd1 : -5'sd1) + (bits[202] ? -5'sd1 : 5'sd1);
186: raw_field = (bits[169] ? -5'sd1 : 5'sd1) + (bits[170] ? -5'sd1 : 5'sd1) + (bits[171] ? 5'sd1 : -5'sd1) + (bits[185] ? -5'sd1 : 5'sd1) + (bits[187] ? -5'sd1 : 5'sd1) + (bits[201] ? -5'sd1 : 5'sd1) + (bits[202] ? -5'sd1 : 5'sd1) + (bits[203] ? -5'sd1 : 5'sd1);
187: raw_field = (bits[170] ? -5'sd1 : 5'sd1) + (bits[171] ? 5'sd1 : -5'sd1) + (bits[172] ? -5'sd1 : 5'sd1) + (bits[186] ? -5'sd1 : 5'sd1) + (bits[188] ? -5'sd1 : 5'sd1) + (bits[202] ? 5'sd1 : -5'sd1) + (bits[203] ? 5'sd1 : -5'sd1) + (bits[204] ? 5'sd1 : -5'sd1);
188: raw_field = (bits[171] ? -5'sd1 : 5'sd1) + (bits[172] ? -5'sd1 : 5'sd1) + (bits[173] ? -5'sd1 : 5'sd1) + (bits[187] ? -5'sd1 : 5'sd1) + (bits[189] ? -5'sd1 : 5'sd1) + (bits[203] ? 5'sd1 : -5'sd1) + (bits[204] ? -5'sd1 : 5'sd1) + (bits[205] ? 5'sd1 : -5'sd1);
189: raw_field = (bits[172] ? 5'sd1 : -5'sd1) + (bits[173] ? 5'sd1 : -5'sd1) + (bits[174] ? 5'sd1 : -5'sd1) + (bits[188] ? -5'sd1 : 5'sd1) + (bits[190] ? -5'sd1 : 5'sd1) + (bits[204] ? 5'sd1 : -5'sd1) + (bits[205] ? 5'sd1 : -5'sd1) + (bits[206] ? -5'sd1 : 5'sd1);
190: raw_field = (bits[173] ? 5'sd1 : -5'sd1) + (bits[174] ? -5'sd1 : 5'sd1) + (bits[175] ? 5'sd1 : -5'sd1) + (bits[189] ? -5'sd1 : 5'sd1) + (bits[191] ? 5'sd1 : -5'sd1) + (bits[205] ? 5'sd1 : -5'sd1) + (bits[206] ? 5'sd1 : -5'sd1) + (bits[207] ? -5'sd1 : 5'sd1);
191: raw_field = (bits[174] ? 5'sd1 : -5'sd1) + (bits[175] ? 5'sd1 : -5'sd1) + (bits[190] ? 5'sd1 : -5'sd1) + (bits[206] ? -5'sd1 : 5'sd1) + (bits[207] ? -5'sd1 : 5'sd1);
192: raw_field = (bits[176] ? 5'sd1 : -5'sd1) + (bits[177] ? -5'sd1 : 5'sd1) + (bits[193] ? -5'sd1 : 5'sd1) + (bits[208] ? -5'sd1 : 5'sd1) + (bits[209] ? 5'sd1 : -5'sd1);
193: raw_field = (bits[176] ? -5'sd1 : 5'sd1) + (bits[177] ? -5'sd1 : 5'sd1) + (bits[178] ? -5'sd1 : 5'sd1) + (bits[192] ? -5'sd1 : 5'sd1) + (bits[194] ? 5'sd1 : -5'sd1) + (bits[208] ? 5'sd1 : -5'sd1) + (bits[209] ? -5'sd1 : 5'sd1) + (bits[210] ? -5'sd1 : 5'sd1);
194: raw_field = (bits[177] ? -5'sd1 : 5'sd1) + (bits[178] ? 5'sd1 : -5'sd1) + (bits[179] ? 5'sd1 : -5'sd1) + (bits[193] ? 5'sd1 : -5'sd1) + (bits[195] ? 5'sd1 : -5'sd1) + (bits[209] ? -5'sd1 : 5'sd1) + (bits[210] ? 5'sd1 : -5'sd1) + (bits[211] ? 5'sd1 : -5'sd1);
195: raw_field = (bits[178] ? -5'sd1 : 5'sd1) + (bits[179] ? 5'sd1 : -5'sd1) + (bits[180] ? 5'sd1 : -5'sd1) + (bits[194] ? 5'sd1 : -5'sd1) + (bits[196] ? -5'sd1 : 5'sd1) + (bits[210] ? 5'sd1 : -5'sd1) + (bits[211] ? -5'sd1 : 5'sd1) + (bits[212] ? 5'sd1 : -5'sd1);
196: raw_field = (bits[179] ? -5'sd1 : 5'sd1) + (bits[180] ? 5'sd1 : -5'sd1) + (bits[181] ? -5'sd1 : 5'sd1) + (bits[195] ? -5'sd1 : 5'sd1) + (bits[197] ? 5'sd1 : -5'sd1) + (bits[211] ? 5'sd1 : -5'sd1) + (bits[212] ? 5'sd1 : -5'sd1) + (bits[213] ? 5'sd1 : -5'sd1);
197: raw_field = (bits[180] ? -5'sd1 : 5'sd1) + (bits[181] ? 5'sd1 : -5'sd1) + (bits[182] ? -5'sd1 : 5'sd1) + (bits[196] ? 5'sd1 : -5'sd1) + (bits[198] ? -5'sd1 : 5'sd1) + (bits[212] ? -5'sd1 : 5'sd1) + (bits[213] ? 5'sd1 : -5'sd1) + (bits[214] ? -5'sd1 : 5'sd1);
198: raw_field = (bits[181] ? 5'sd1 : -5'sd1) + (bits[182] ? -5'sd1 : 5'sd1) + (bits[183] ? -5'sd1 : 5'sd1) + (bits[197] ? -5'sd1 : 5'sd1) + (bits[199] ? -5'sd1 : 5'sd1) + (bits[213] ? -5'sd1 : 5'sd1) + (bits[214] ? -5'sd1 : 5'sd1) + (bits[215] ? 5'sd1 : -5'sd1);
199: raw_field = (bits[182] ? -5'sd1 : 5'sd1) + (bits[183] ? 5'sd1 : -5'sd1) + (bits[184] ? -5'sd1 : 5'sd1) + (bits[198] ? -5'sd1 : 5'sd1) + (bits[200] ? 5'sd1 : -5'sd1) + (bits[214] ? -5'sd1 : 5'sd1) + (bits[215] ? 5'sd1 : -5'sd1) + (bits[216] ? 5'sd1 : -5'sd1);
200: raw_field = (bits[183] ? 5'sd1 : -5'sd1) + (bits[184] ? 5'sd1 : -5'sd1) + (bits[185] ? -5'sd1 : 5'sd1) + (bits[199] ? 5'sd1 : -5'sd1) + (bits[201] ? 5'sd1 : -5'sd1) + (bits[215] ? 5'sd1 : -5'sd1) + (bits[216] ? 5'sd1 : -5'sd1) + (bits[217] ? 5'sd1 : -5'sd1);
201: raw_field = (bits[184] ? 5'sd1 : -5'sd1) + (bits[185] ? 5'sd1 : -5'sd1) + (bits[186] ? -5'sd1 : 5'sd1) + (bits[200] ? 5'sd1 : -5'sd1) + (bits[202] ? -5'sd1 : 5'sd1) + (bits[216] ? -5'sd1 : 5'sd1) + (bits[217] ? 5'sd1 : -5'sd1) + (bits[218] ? -5'sd1 : 5'sd1);
202: raw_field = (bits[185] ? -5'sd1 : 5'sd1) + (bits[186] ? -5'sd1 : 5'sd1) + (bits[187] ? 5'sd1 : -5'sd1) + (bits[201] ? -5'sd1 : 5'sd1) + (bits[203] ? -5'sd1 : 5'sd1) + (bits[217] ? -5'sd1 : 5'sd1) + (bits[218] ? 5'sd1 : -5'sd1) + (bits[219] ? -5'sd1 : 5'sd1);
203: raw_field = (bits[186] ? -5'sd1 : 5'sd1) + (bits[187] ? 5'sd1 : -5'sd1) + (bits[188] ? 5'sd1 : -5'sd1) + (bits[202] ? -5'sd1 : 5'sd1) + (bits[204] ? -5'sd1 : 5'sd1) + (bits[218] ? -5'sd1 : 5'sd1) + (bits[219] ? 5'sd1 : -5'sd1) + (bits[220] ? 5'sd1 : -5'sd1);
204: raw_field = (bits[187] ? 5'sd1 : -5'sd1) + (bits[188] ? -5'sd1 : 5'sd1) + (bits[189] ? 5'sd1 : -5'sd1) + (bits[203] ? -5'sd1 : 5'sd1) + (bits[205] ? 5'sd1 : -5'sd1) + (bits[219] ? -5'sd1 : 5'sd1) + (bits[220] ? 5'sd1 : -5'sd1) + (bits[221] ? 5'sd1 : -5'sd1);
205: raw_field = (bits[188] ? 5'sd1 : -5'sd1) + (bits[189] ? 5'sd1 : -5'sd1) + (bits[190] ? 5'sd1 : -5'sd1) + (bits[204] ? 5'sd1 : -5'sd1) + (bits[206] ? -5'sd1 : 5'sd1) + (bits[220] ? 5'sd1 : -5'sd1) + (bits[221] ? 5'sd1 : -5'sd1) + (bits[222] ? -5'sd1 : 5'sd1);
206: raw_field = (bits[189] ? -5'sd1 : 5'sd1) + (bits[190] ? 5'sd1 : -5'sd1) + (bits[191] ? -5'sd1 : 5'sd1) + (bits[205] ? -5'sd1 : 5'sd1) + (bits[207] ? 5'sd1 : -5'sd1) + (bits[221] ? 5'sd1 : -5'sd1) + (bits[222] ? 5'sd1 : -5'sd1) + (bits[223] ? 5'sd1 : -5'sd1);
207: raw_field = (bits[190] ? -5'sd1 : 5'sd1) + (bits[191] ? -5'sd1 : 5'sd1) + (bits[206] ? 5'sd1 : -5'sd1) + (bits[222] ? -5'sd1 : 5'sd1) + (bits[223] ? 5'sd1 : -5'sd1);
208: raw_field = (bits[192] ? -5'sd1 : 5'sd1) + (bits[193] ? 5'sd1 : -5'sd1) + (bits[209] ? -5'sd1 : 5'sd1) + (bits[224] ? 5'sd1 : -5'sd1) + (bits[225] ? -5'sd1 : 5'sd1);
209: raw_field = (bits[192] ? 5'sd1 : -5'sd1) + (bits[193] ? -5'sd1 : 5'sd1) + (bits[194] ? -5'sd1 : 5'sd1) + (bits[208] ? -5'sd1 : 5'sd1) + (bits[210] ? -5'sd1 : 5'sd1) + (bits[224] ? 5'sd1 : -5'sd1) + (bits[225] ? 5'sd1 : -5'sd1) + (bits[226] ? -5'sd1 : 5'sd1);
210: raw_field = (bits[193] ? -5'sd1 : 5'sd1) + (bits[194] ? 5'sd1 : -5'sd1) + (bits[195] ? 5'sd1 : -5'sd1) + (bits[209] ? -5'sd1 : 5'sd1) + (bits[211] ? 5'sd1 : -5'sd1) + (bits[225] ? 5'sd1 : -5'sd1) + (bits[226] ? 5'sd1 : -5'sd1) + (bits[227] ? 5'sd1 : -5'sd1);
211: raw_field = (bits[194] ? 5'sd1 : -5'sd1) + (bits[195] ? -5'sd1 : 5'sd1) + (bits[196] ? 5'sd1 : -5'sd1) + (bits[210] ? 5'sd1 : -5'sd1) + (bits[212] ? 5'sd1 : -5'sd1) + (bits[226] ? -5'sd1 : 5'sd1) + (bits[227] ? -5'sd1 : 5'sd1) + (bits[228] ? -5'sd1 : 5'sd1);
212: raw_field = (bits[195] ? 5'sd1 : -5'sd1) + (bits[196] ? 5'sd1 : -5'sd1) + (bits[197] ? -5'sd1 : 5'sd1) + (bits[211] ? 5'sd1 : -5'sd1) + (bits[213] ? 5'sd1 : -5'sd1) + (bits[227] ? 5'sd1 : -5'sd1) + (bits[228] ? -5'sd1 : 5'sd1) + (bits[229] ? -5'sd1 : 5'sd1);
213: raw_field = (bits[196] ? 5'sd1 : -5'sd1) + (bits[197] ? 5'sd1 : -5'sd1) + (bits[198] ? -5'sd1 : 5'sd1) + (bits[212] ? 5'sd1 : -5'sd1) + (bits[214] ? -5'sd1 : 5'sd1) + (bits[228] ? -5'sd1 : 5'sd1) + (bits[229] ? -5'sd1 : 5'sd1) + (bits[230] ? -5'sd1 : 5'sd1);
214: raw_field = (bits[197] ? -5'sd1 : 5'sd1) + (bits[198] ? -5'sd1 : 5'sd1) + (bits[199] ? -5'sd1 : 5'sd1) + (bits[213] ? -5'sd1 : 5'sd1) + (bits[215] ? 5'sd1 : -5'sd1) + (bits[229] ? 5'sd1 : -5'sd1) + (bits[230] ? 5'sd1 : -5'sd1) + (bits[231] ? 5'sd1 : -5'sd1);
215: raw_field = (bits[198] ? 5'sd1 : -5'sd1) + (bits[199] ? 5'sd1 : -5'sd1) + (bits[200] ? 5'sd1 : -5'sd1) + (bits[214] ? 5'sd1 : -5'sd1) + (bits[216] ? 5'sd1 : -5'sd1) + (bits[230] ? -5'sd1 : 5'sd1) + (bits[231] ? -5'sd1 : 5'sd1) + (bits[232] ? -5'sd1 : 5'sd1);
216: raw_field = (bits[199] ? 5'sd1 : -5'sd1) + (bits[200] ? 5'sd1 : -5'sd1) + (bits[201] ? -5'sd1 : 5'sd1) + (bits[215] ? 5'sd1 : -5'sd1) + (bits[217] ? 5'sd1 : -5'sd1) + (bits[231] ? -5'sd1 : 5'sd1) + (bits[232] ? -5'sd1 : 5'sd1) + (bits[233] ? -5'sd1 : 5'sd1);
217: raw_field = (bits[200] ? 5'sd1 : -5'sd1) + (bits[201] ? 5'sd1 : -5'sd1) + (bits[202] ? -5'sd1 : 5'sd1) + (bits[216] ? 5'sd1 : -5'sd1) + (bits[218] ? -5'sd1 : 5'sd1) + (bits[232] ? -5'sd1 : 5'sd1) + (bits[233] ? -5'sd1 : 5'sd1) + (bits[234] ? 5'sd1 : -5'sd1);
218: raw_field = (bits[201] ? -5'sd1 : 5'sd1) + (bits[202] ? 5'sd1 : -5'sd1) + (bits[203] ? -5'sd1 : 5'sd1) + (bits[217] ? -5'sd1 : 5'sd1) + (bits[219] ? 5'sd1 : -5'sd1) + (bits[233] ? 5'sd1 : -5'sd1) + (bits[234] ? -5'sd1 : 5'sd1) + (bits[235] ? -5'sd1 : 5'sd1);
219: raw_field = (bits[202] ? -5'sd1 : 5'sd1) + (bits[203] ? 5'sd1 : -5'sd1) + (bits[204] ? -5'sd1 : 5'sd1) + (bits[218] ? 5'sd1 : -5'sd1) + (bits[220] ? -5'sd1 : 5'sd1) + (bits[234] ? -5'sd1 : 5'sd1) + (bits[235] ? -5'sd1 : 5'sd1) + (bits[236] ? 5'sd1 : -5'sd1);
220: raw_field = (bits[203] ? 5'sd1 : -5'sd1) + (bits[204] ? 5'sd1 : -5'sd1) + (bits[205] ? 5'sd1 : -5'sd1) + (bits[219] ? -5'sd1 : 5'sd1) + (bits[221] ? 5'sd1 : -5'sd1) + (bits[235] ? 5'sd1 : -5'sd1) + (bits[236] ? 5'sd1 : -5'sd1) + (bits[237] ? 5'sd1 : -5'sd1);
221: raw_field = (bits[204] ? 5'sd1 : -5'sd1) + (bits[205] ? 5'sd1 : -5'sd1) + (bits[206] ? 5'sd1 : -5'sd1) + (bits[220] ? 5'sd1 : -5'sd1) + (bits[222] ? 5'sd1 : -5'sd1) + (bits[236] ? 5'sd1 : -5'sd1) + (bits[237] ? -5'sd1 : 5'sd1) + (bits[238] ? -5'sd1 : 5'sd1);
222: raw_field = (bits[205] ? -5'sd1 : 5'sd1) + (bits[206] ? 5'sd1 : -5'sd1) + (bits[207] ? -5'sd1 : 5'sd1) + (bits[221] ? 5'sd1 : -5'sd1) + (bits[223] ? 5'sd1 : -5'sd1) + (bits[237] ? 5'sd1 : -5'sd1) + (bits[238] ? -5'sd1 : 5'sd1) + (bits[239] ? -5'sd1 : 5'sd1);
223: raw_field = (bits[206] ? 5'sd1 : -5'sd1) + (bits[207] ? 5'sd1 : -5'sd1) + (bits[222] ? 5'sd1 : -5'sd1) + (bits[238] ? -5'sd1 : 5'sd1) + (bits[239] ? -5'sd1 : 5'sd1);
224: raw_field = (bits[208] ? 5'sd1 : -5'sd1) + (bits[209] ? 5'sd1 : -5'sd1) + (bits[225] ? -5'sd1 : 5'sd1) + (bits[240] ? 5'sd1 : -5'sd1) + (bits[241] ? -5'sd1 : 5'sd1);
225: raw_field = (bits[208] ? -5'sd1 : 5'sd1) + (bits[209] ? 5'sd1 : -5'sd1) + (bits[210] ? 5'sd1 : -5'sd1) + (bits[224] ? -5'sd1 : 5'sd1) + (bits[226] ? -5'sd1 : 5'sd1) + (bits[240] ? 5'sd1 : -5'sd1) + (bits[241] ? -5'sd1 : 5'sd1) + (bits[242] ? 5'sd1 : -5'sd1);
226: raw_field = (bits[209] ? -5'sd1 : 5'sd1) + (bits[210] ? 5'sd1 : -5'sd1) + (bits[211] ? -5'sd1 : 5'sd1) + (bits[225] ? -5'sd1 : 5'sd1) + (bits[227] ? 5'sd1 : -5'sd1) + (bits[241] ? -5'sd1 : 5'sd1) + (bits[242] ? 5'sd1 : -5'sd1) + (bits[243] ? 5'sd1 : -5'sd1);
227: raw_field = (bits[210] ? 5'sd1 : -5'sd1) + (bits[211] ? -5'sd1 : 5'sd1) + (bits[212] ? 5'sd1 : -5'sd1) + (bits[226] ? 5'sd1 : -5'sd1) + (bits[228] ? 5'sd1 : -5'sd1) + (bits[242] ? 5'sd1 : -5'sd1) + (bits[243] ? -5'sd1 : 5'sd1) + (bits[244] ? 5'sd1 : -5'sd1);
228: raw_field = (bits[211] ? -5'sd1 : 5'sd1) + (bits[212] ? -5'sd1 : 5'sd1) + (bits[213] ? -5'sd1 : 5'sd1) + (bits[227] ? 5'sd1 : -5'sd1) + (bits[229] ? -5'sd1 : 5'sd1) + (bits[243] ? -5'sd1 : 5'sd1) + (bits[244] ? 5'sd1 : -5'sd1) + (bits[245] ? -5'sd1 : 5'sd1);
229: raw_field = (bits[212] ? -5'sd1 : 5'sd1) + (bits[213] ? -5'sd1 : 5'sd1) + (bits[214] ? 5'sd1 : -5'sd1) + (bits[228] ? -5'sd1 : 5'sd1) + (bits[230] ? 5'sd1 : -5'sd1) + (bits[244] ? -5'sd1 : 5'sd1) + (bits[245] ? 5'sd1 : -5'sd1) + (bits[246] ? 5'sd1 : -5'sd1);
230: raw_field = (bits[213] ? -5'sd1 : 5'sd1) + (bits[214] ? 5'sd1 : -5'sd1) + (bits[215] ? -5'sd1 : 5'sd1) + (bits[229] ? 5'sd1 : -5'sd1) + (bits[231] ? -5'sd1 : 5'sd1) + (bits[245] ? -5'sd1 : 5'sd1) + (bits[246] ? 5'sd1 : -5'sd1) + (bits[247] ? -5'sd1 : 5'sd1);
231: raw_field = (bits[214] ? 5'sd1 : -5'sd1) + (bits[215] ? -5'sd1 : 5'sd1) + (bits[216] ? -5'sd1 : 5'sd1) + (bits[230] ? -5'sd1 : 5'sd1) + (bits[232] ? -5'sd1 : 5'sd1) + (bits[246] ? -5'sd1 : 5'sd1) + (bits[247] ? -5'sd1 : 5'sd1) + (bits[248] ? -5'sd1 : 5'sd1);
232: raw_field = (bits[215] ? -5'sd1 : 5'sd1) + (bits[216] ? -5'sd1 : 5'sd1) + (bits[217] ? -5'sd1 : 5'sd1) + (bits[231] ? -5'sd1 : 5'sd1) + (bits[233] ? -5'sd1 : 5'sd1) + (bits[247] ? 5'sd1 : -5'sd1) + (bits[248] ? -5'sd1 : 5'sd1) + (bits[249] ? -5'sd1 : 5'sd1);
233: raw_field = (bits[216] ? -5'sd1 : 5'sd1) + (bits[217] ? -5'sd1 : 5'sd1) + (bits[218] ? 5'sd1 : -5'sd1) + (bits[232] ? -5'sd1 : 5'sd1) + (bits[234] ? 5'sd1 : -5'sd1) + (bits[248] ? 5'sd1 : -5'sd1) + (bits[249] ? 5'sd1 : -5'sd1) + (bits[250] ? -5'sd1 : 5'sd1);
234: raw_field = (bits[217] ? 5'sd1 : -5'sd1) + (bits[218] ? -5'sd1 : 5'sd1) + (bits[219] ? -5'sd1 : 5'sd1) + (bits[233] ? 5'sd1 : -5'sd1) + (bits[235] ? 5'sd1 : -5'sd1) + (bits[249] ? -5'sd1 : 5'sd1) + (bits[250] ? -5'sd1 : 5'sd1) + (bits[251] ? -5'sd1 : 5'sd1);
235: raw_field = (bits[218] ? -5'sd1 : 5'sd1) + (bits[219] ? -5'sd1 : 5'sd1) + (bits[220] ? 5'sd1 : -5'sd1) + (bits[234] ? 5'sd1 : -5'sd1) + (bits[236] ? -5'sd1 : 5'sd1) + (bits[250] ? -5'sd1 : 5'sd1) + (bits[251] ? 5'sd1 : -5'sd1) + (bits[252] ? 5'sd1 : -5'sd1);
236: raw_field = (bits[219] ? 5'sd1 : -5'sd1) + (bits[220] ? 5'sd1 : -5'sd1) + (bits[221] ? 5'sd1 : -5'sd1) + (bits[235] ? -5'sd1 : 5'sd1) + (bits[237] ? 5'sd1 : -5'sd1) + (bits[251] ? 5'sd1 : -5'sd1) + (bits[252] ? -5'sd1 : 5'sd1) + (bits[253] ? 5'sd1 : -5'sd1);
237: raw_field = (bits[220] ? 5'sd1 : -5'sd1) + (bits[221] ? -5'sd1 : 5'sd1) + (bits[222] ? 5'sd1 : -5'sd1) + (bits[236] ? 5'sd1 : -5'sd1) + (bits[238] ? 5'sd1 : -5'sd1) + (bits[252] ? 5'sd1 : -5'sd1) + (bits[253] ? 5'sd1 : -5'sd1) + (bits[254] ? 5'sd1 : -5'sd1);
238: raw_field = (bits[221] ? -5'sd1 : 5'sd1) + (bits[222] ? -5'sd1 : 5'sd1) + (bits[223] ? -5'sd1 : 5'sd1) + (bits[237] ? 5'sd1 : -5'sd1) + (bits[239] ? 5'sd1 : -5'sd1) + (bits[253] ? 5'sd1 : -5'sd1) + (bits[254] ? -5'sd1 : 5'sd1) + (bits[255] ? 5'sd1 : -5'sd1);
239: raw_field = (bits[222] ? -5'sd1 : 5'sd1) + (bits[223] ? -5'sd1 : 5'sd1) + (bits[238] ? 5'sd1 : -5'sd1) + (bits[254] ? -5'sd1 : 5'sd1) + (bits[255] ? 5'sd1 : -5'sd1);
240: raw_field = (bits[224] ? 5'sd1 : -5'sd1) + (bits[225] ? 5'sd1 : -5'sd1) + (bits[241] ? 5'sd1 : -5'sd1) + (bits[256] ? 5'sd1 : -5'sd1) + (bits[257] ? -5'sd1 : 5'sd1);
241: raw_field = (bits[224] ? -5'sd1 : 5'sd1) + (bits[225] ? -5'sd1 : 5'sd1) + (bits[226] ? -5'sd1 : 5'sd1) + (bits[240] ? 5'sd1 : -5'sd1) + (bits[242] ? -5'sd1 : 5'sd1) + (bits[256] ? 5'sd1 : -5'sd1) + (bits[257] ? 5'sd1 : -5'sd1) + (bits[258] ? -5'sd1 : 5'sd1);
242: raw_field = (bits[225] ? 5'sd1 : -5'sd1) + (bits[226] ? 5'sd1 : -5'sd1) + (bits[227] ? 5'sd1 : -5'sd1) + (bits[241] ? -5'sd1 : 5'sd1) + (bits[243] ? -5'sd1 : 5'sd1) + (bits[257] ? -5'sd1 : 5'sd1) + (bits[258] ? 5'sd1 : -5'sd1) + (bits[259] ? -5'sd1 : 5'sd1);
243: raw_field = (bits[226] ? 5'sd1 : -5'sd1) + (bits[227] ? -5'sd1 : 5'sd1) + (bits[228] ? -5'sd1 : 5'sd1) + (bits[242] ? -5'sd1 : 5'sd1) + (bits[244] ? 5'sd1 : -5'sd1) + (bits[258] ? -5'sd1 : 5'sd1) + (bits[259] ? 5'sd1 : -5'sd1) + (bits[260] ? 5'sd1 : -5'sd1);
244: raw_field = (bits[227] ? 5'sd1 : -5'sd1) + (bits[228] ? 5'sd1 : -5'sd1) + (bits[229] ? -5'sd1 : 5'sd1) + (bits[243] ? 5'sd1 : -5'sd1) + (bits[245] ? 5'sd1 : -5'sd1) + (bits[259] ? 5'sd1 : -5'sd1) + (bits[260] ? 5'sd1 : -5'sd1) + (bits[261] ? 5'sd1 : -5'sd1);
245: raw_field = (bits[228] ? -5'sd1 : 5'sd1) + (bits[229] ? 5'sd1 : -5'sd1) + (bits[230] ? -5'sd1 : 5'sd1) + (bits[244] ? 5'sd1 : -5'sd1) + (bits[246] ? 5'sd1 : -5'sd1) + (bits[260] ? -5'sd1 : 5'sd1) + (bits[261] ? -5'sd1 : 5'sd1) + (bits[262] ? 5'sd1 : -5'sd1);
246: raw_field = (bits[229] ? 5'sd1 : -5'sd1) + (bits[230] ? 5'sd1 : -5'sd1) + (bits[231] ? -5'sd1 : 5'sd1) + (bits[245] ? 5'sd1 : -5'sd1) + (bits[247] ? -5'sd1 : 5'sd1) + (bits[261] ? 5'sd1 : -5'sd1) + (bits[262] ? -5'sd1 : 5'sd1) + (bits[263] ? 5'sd1 : -5'sd1);
247: raw_field = (bits[230] ? -5'sd1 : 5'sd1) + (bits[231] ? -5'sd1 : 5'sd1) + (bits[232] ? 5'sd1 : -5'sd1) + (bits[246] ? -5'sd1 : 5'sd1) + (bits[248] ? -5'sd1 : 5'sd1) + (bits[262] ? 5'sd1 : -5'sd1) + (bits[263] ? -5'sd1 : 5'sd1) + (bits[264] ? -5'sd1 : 5'sd1);
248: raw_field = (bits[231] ? -5'sd1 : 5'sd1) + (bits[232] ? -5'sd1 : 5'sd1) + (bits[233] ? 5'sd1 : -5'sd1) + (bits[247] ? -5'sd1 : 5'sd1) + (bits[249] ? 5'sd1 : -5'sd1) + (bits[263] ? 5'sd1 : -5'sd1) + (bits[264] ? 5'sd1 : -5'sd1) + (bits[265] ? -5'sd1 : 5'sd1);
249: raw_field = (bits[232] ? -5'sd1 : 5'sd1) + (bits[233] ? 5'sd1 : -5'sd1) + (bits[234] ? -5'sd1 : 5'sd1) + (bits[248] ? 5'sd1 : -5'sd1) + (bits[250] ? -5'sd1 : 5'sd1) + (bits[264] ? -5'sd1 : 5'sd1) + (bits[265] ? -5'sd1 : 5'sd1) + (bits[266] ? 5'sd1 : -5'sd1);
250: raw_field = (bits[233] ? -5'sd1 : 5'sd1) + (bits[234] ? -5'sd1 : 5'sd1) + (bits[235] ? -5'sd1 : 5'sd1) + (bits[249] ? -5'sd1 : 5'sd1) + (bits[251] ? 5'sd1 : -5'sd1) + (bits[265] ? -5'sd1 : 5'sd1) + (bits[266] ? -5'sd1 : 5'sd1) + (bits[267] ? 5'sd1 : -5'sd1);
251: raw_field = (bits[234] ? -5'sd1 : 5'sd1) + (bits[235] ? 5'sd1 : -5'sd1) + (bits[236] ? 5'sd1 : -5'sd1) + (bits[250] ? 5'sd1 : -5'sd1) + (bits[252] ? 5'sd1 : -5'sd1) + (bits[266] ? 5'sd1 : -5'sd1) + (bits[267] ? 5'sd1 : -5'sd1) + (bits[268] ? 5'sd1 : -5'sd1);
252: raw_field = (bits[235] ? 5'sd1 : -5'sd1) + (bits[236] ? -5'sd1 : 5'sd1) + (bits[237] ? 5'sd1 : -5'sd1) + (bits[251] ? 5'sd1 : -5'sd1) + (bits[253] ? -5'sd1 : 5'sd1) + (bits[267] ? 5'sd1 : -5'sd1) + (bits[268] ? 5'sd1 : -5'sd1) + (bits[269] ? -5'sd1 : 5'sd1);
253: raw_field = (bits[236] ? 5'sd1 : -5'sd1) + (bits[237] ? 5'sd1 : -5'sd1) + (bits[238] ? 5'sd1 : -5'sd1) + (bits[252] ? -5'sd1 : 5'sd1) + (bits[254] ? -5'sd1 : 5'sd1) + (bits[268] ? 5'sd1 : -5'sd1) + (bits[269] ? 5'sd1 : -5'sd1) + (bits[270] ? 5'sd1 : -5'sd1);
254: raw_field = (bits[237] ? 5'sd1 : -5'sd1) + (bits[238] ? -5'sd1 : 5'sd1) + (bits[239] ? -5'sd1 : 5'sd1) + (bits[253] ? -5'sd1 : 5'sd1) + (bits[255] ? -5'sd1 : 5'sd1) + (bits[269] ? -5'sd1 : 5'sd1) + (bits[270] ? -5'sd1 : 5'sd1) + (bits[271] ? 5'sd1 : -5'sd1);
255: raw_field = (bits[238] ? 5'sd1 : -5'sd1) + (bits[239] ? 5'sd1 : -5'sd1) + (bits[254] ? -5'sd1 : 5'sd1) + (bits[270] ? 5'sd1 : -5'sd1) + (bits[271] ? -5'sd1 : 5'sd1);
256: raw_field = (bits[240] ? 5'sd1 : -5'sd1) + (bits[241] ? 5'sd1 : -5'sd1) + (bits[257] ? -5'sd1 : 5'sd1) + (bits[272] ? 5'sd1 : -5'sd1) + (bits[273] ? -5'sd1 : 5'sd1);
257: raw_field = (bits[240] ? -5'sd1 : 5'sd1) + (bits[241] ? 5'sd1 : -5'sd1) + (bits[242] ? -5'sd1 : 5'sd1) + (bits[256] ? -5'sd1 : 5'sd1) + (bits[258] ? 5'sd1 : -5'sd1) + (bits[272] ? 5'sd1 : -5'sd1) + (bits[273] ? -5'sd1 : 5'sd1) + (bits[274] ? 5'sd1 : -5'sd1);
258: raw_field = (bits[241] ? -5'sd1 : 5'sd1) + (bits[242] ? 5'sd1 : -5'sd1) + (bits[243] ? -5'sd1 : 5'sd1) + (bits[257] ? 5'sd1 : -5'sd1) + (bits[259] ? 5'sd1 : -5'sd1) + (bits[273] ? 5'sd1 : -5'sd1) + (bits[274] ? -5'sd1 : 5'sd1) + (bits[275] ? 5'sd1 : -5'sd1);
259: raw_field = (bits[242] ? -5'sd1 : 5'sd1) + (bits[243] ? 5'sd1 : -5'sd1) + (bits[244] ? 5'sd1 : -5'sd1) + (bits[258] ? 5'sd1 : -5'sd1) + (bits[260] ? -5'sd1 : 5'sd1) + (bits[274] ? -5'sd1 : 5'sd1) + (bits[275] ? -5'sd1 : 5'sd1) + (bits[276] ? 5'sd1 : -5'sd1);
260: raw_field = (bits[243] ? 5'sd1 : -5'sd1) + (bits[244] ? 5'sd1 : -5'sd1) + (bits[245] ? -5'sd1 : 5'sd1) + (bits[259] ? -5'sd1 : 5'sd1) + (bits[261] ? 5'sd1 : -5'sd1) + (bits[275] ? 5'sd1 : -5'sd1) + (bits[276] ? 5'sd1 : -5'sd1) + (bits[277] ? -5'sd1 : 5'sd1);
261: raw_field = (bits[244] ? 5'sd1 : -5'sd1) + (bits[245] ? -5'sd1 : 5'sd1) + (bits[246] ? 5'sd1 : -5'sd1) + (bits[260] ? 5'sd1 : -5'sd1) + (bits[262] ? 5'sd1 : -5'sd1) + (bits[276] ? -5'sd1 : 5'sd1) + (bits[277] ? 5'sd1 : -5'sd1) + (bits[278] ? -5'sd1 : 5'sd1);
262: raw_field = (bits[245] ? 5'sd1 : -5'sd1) + (bits[246] ? -5'sd1 : 5'sd1) + (bits[247] ? 5'sd1 : -5'sd1) + (bits[261] ? 5'sd1 : -5'sd1) + (bits[263] ? -5'sd1 : 5'sd1) + (bits[277] ? 5'sd1 : -5'sd1) + (bits[278] ? 5'sd1 : -5'sd1) + (bits[279] ? -5'sd1 : 5'sd1);
263: raw_field = (bits[246] ? 5'sd1 : -5'sd1) + (bits[247] ? -5'sd1 : 5'sd1) + (bits[248] ? 5'sd1 : -5'sd1) + (bits[262] ? -5'sd1 : 5'sd1) + (bits[264] ? 5'sd1 : -5'sd1) + (bits[278] ? -5'sd1 : 5'sd1) + (bits[279] ? -5'sd1 : 5'sd1) + (bits[280] ? 5'sd1 : -5'sd1);
264: raw_field = (bits[247] ? -5'sd1 : 5'sd1) + (bits[248] ? 5'sd1 : -5'sd1) + (bits[249] ? -5'sd1 : 5'sd1) + (bits[263] ? 5'sd1 : -5'sd1) + (bits[265] ? -5'sd1 : 5'sd1) + (bits[279] ? -5'sd1 : 5'sd1) + (bits[280] ? -5'sd1 : 5'sd1) + (bits[281] ? 5'sd1 : -5'sd1);
265: raw_field = (bits[248] ? -5'sd1 : 5'sd1) + (bits[249] ? -5'sd1 : 5'sd1) + (bits[250] ? -5'sd1 : 5'sd1) + (bits[264] ? -5'sd1 : 5'sd1) + (bits[266] ? -5'sd1 : 5'sd1) + (bits[280] ? 5'sd1 : -5'sd1) + (bits[281] ? -5'sd1 : 5'sd1) + (bits[282] ? 5'sd1 : -5'sd1);
266: raw_field = (bits[249] ? 5'sd1 : -5'sd1) + (bits[250] ? -5'sd1 : 5'sd1) + (bits[251] ? 5'sd1 : -5'sd1) + (bits[265] ? -5'sd1 : 5'sd1) + (bits[267] ? -5'sd1 : 5'sd1) + (bits[281] ? -5'sd1 : 5'sd1) + (bits[282] ? 5'sd1 : -5'sd1) + (bits[283] ? 5'sd1 : -5'sd1);
267: raw_field = (bits[250] ? 5'sd1 : -5'sd1) + (bits[251] ? 5'sd1 : -5'sd1) + (bits[252] ? 5'sd1 : -5'sd1) + (bits[266] ? -5'sd1 : 5'sd1) + (bits[268] ? 5'sd1 : -5'sd1) + (bits[282] ? -5'sd1 : 5'sd1) + (bits[283] ? 5'sd1 : -5'sd1) + (bits[284] ? 5'sd1 : -5'sd1);
268: raw_field = (bits[251] ? 5'sd1 : -5'sd1) + (bits[252] ? 5'sd1 : -5'sd1) + (bits[253] ? 5'sd1 : -5'sd1) + (bits[267] ? 5'sd1 : -5'sd1) + (bits[269] ? 5'sd1 : -5'sd1) + (bits[283] ? -5'sd1 : 5'sd1) + (bits[284] ? 5'sd1 : -5'sd1) + (bits[285] ? 5'sd1 : -5'sd1);
269: raw_field = (bits[252] ? -5'sd1 : 5'sd1) + (bits[253] ? 5'sd1 : -5'sd1) + (bits[254] ? -5'sd1 : 5'sd1) + (bits[268] ? 5'sd1 : -5'sd1) + (bits[270] ? 5'sd1 : -5'sd1) + (bits[284] ? 5'sd1 : -5'sd1) + (bits[285] ? 5'sd1 : -5'sd1) + (bits[286] ? 5'sd1 : -5'sd1);
270: raw_field = (bits[253] ? 5'sd1 : -5'sd1) + (bits[254] ? -5'sd1 : 5'sd1) + (bits[255] ? 5'sd1 : -5'sd1) + (bits[269] ? 5'sd1 : -5'sd1) + (bits[271] ? 5'sd1 : -5'sd1) + (bits[285] ? 5'sd1 : -5'sd1) + (bits[286] ? -5'sd1 : 5'sd1) + (bits[287] ? -5'sd1 : 5'sd1);
271: raw_field = (bits[254] ? 5'sd1 : -5'sd1) + (bits[255] ? -5'sd1 : 5'sd1) + (bits[270] ? 5'sd1 : -5'sd1) + (bits[286] ? 5'sd1 : -5'sd1) + (bits[287] ? -5'sd1 : 5'sd1);
272: raw_field = (bits[256] ? 5'sd1 : -5'sd1) + (bits[257] ? 5'sd1 : -5'sd1) + (bits[273] ? 5'sd1 : -5'sd1) + (bits[288] ? 5'sd1 : -5'sd1) + (bits[289] ? -5'sd1 : 5'sd1);
273: raw_field = (bits[256] ? -5'sd1 : 5'sd1) + (bits[257] ? -5'sd1 : 5'sd1) + (bits[258] ? 5'sd1 : -5'sd1) + (bits[272] ? 5'sd1 : -5'sd1) + (bits[274] ? 5'sd1 : -5'sd1) + (bits[288] ? 5'sd1 : -5'sd1) + (bits[289] ? 5'sd1 : -5'sd1) + (bits[290] ? 5'sd1 : -5'sd1);
274: raw_field = (bits[257] ? 5'sd1 : -5'sd1) + (bits[258] ? -5'sd1 : 5'sd1) + (bits[259] ? -5'sd1 : 5'sd1) + (bits[273] ? 5'sd1 : -5'sd1) + (bits[275] ? 5'sd1 : -5'sd1) + (bits[289] ? 5'sd1 : -5'sd1) + (bits[290] ? -5'sd1 : 5'sd1) + (bits[291] ? 5'sd1 : -5'sd1);
275: raw_field = (bits[258] ? 5'sd1 : -5'sd1) + (bits[259] ? -5'sd1 : 5'sd1) + (bits[260] ? 5'sd1 : -5'sd1) + (bits[274] ? 5'sd1 : -5'sd1) + (bits[276] ? 5'sd1 : -5'sd1) + (bits[290] ? 5'sd1 : -5'sd1) + (bits[291] ? -5'sd1 : 5'sd1) + (bits[292] ? 5'sd1 : -5'sd1);
276: raw_field = (bits[259] ? 5'sd1 : -5'sd1) + (bits[260] ? 5'sd1 : -5'sd1) + (bits[261] ? -5'sd1 : 5'sd1) + (bits[275] ? 5'sd1 : -5'sd1) + (bits[277] ? -5'sd1 : 5'sd1) + (bits[291] ? -5'sd1 : 5'sd1) + (bits[292] ? 5'sd1 : -5'sd1) + (bits[293] ? 5'sd1 : -5'sd1);
277: raw_field = (bits[260] ? -5'sd1 : 5'sd1) + (bits[261] ? 5'sd1 : -5'sd1) + (bits[262] ? 5'sd1 : -5'sd1) + (bits[276] ? -5'sd1 : 5'sd1) + (bits[278] ? 5'sd1 : -5'sd1) + (bits[292] ? -5'sd1 : 5'sd1) + (bits[293] ? 5'sd1 : -5'sd1) + (bits[294] ? 5'sd1 : -5'sd1);
278: raw_field = (bits[261] ? -5'sd1 : 5'sd1) + (bits[262] ? 5'sd1 : -5'sd1) + (bits[263] ? -5'sd1 : 5'sd1) + (bits[277] ? 5'sd1 : -5'sd1) + (bits[279] ? -5'sd1 : 5'sd1) + (bits[293] ? 5'sd1 : -5'sd1) + (bits[294] ? 5'sd1 : -5'sd1) + (bits[295] ? 5'sd1 : -5'sd1);
279: raw_field = (bits[262] ? -5'sd1 : 5'sd1) + (bits[263] ? -5'sd1 : 5'sd1) + (bits[264] ? -5'sd1 : 5'sd1) + (bits[278] ? -5'sd1 : 5'sd1) + (bits[280] ? -5'sd1 : 5'sd1) + (bits[294] ? -5'sd1 : 5'sd1) + (bits[295] ? 5'sd1 : -5'sd1) + (bits[296] ? 5'sd1 : -5'sd1);
280: raw_field = (bits[263] ? 5'sd1 : -5'sd1) + (bits[264] ? -5'sd1 : 5'sd1) + (bits[265] ? 5'sd1 : -5'sd1) + (bits[279] ? -5'sd1 : 5'sd1) + (bits[281] ? -5'sd1 : 5'sd1) + (bits[295] ? 5'sd1 : -5'sd1) + (bits[296] ? 5'sd1 : -5'sd1) + (bits[297] ? 5'sd1 : -5'sd1);
281: raw_field = (bits[264] ? 5'sd1 : -5'sd1) + (bits[265] ? -5'sd1 : 5'sd1) + (bits[266] ? -5'sd1 : 5'sd1) + (bits[280] ? -5'sd1 : 5'sd1) + (bits[282] ? 5'sd1 : -5'sd1) + (bits[296] ? 5'sd1 : -5'sd1) + (bits[297] ? -5'sd1 : 5'sd1) + (bits[298] ? 5'sd1 : -5'sd1);
282: raw_field = (bits[265] ? 5'sd1 : -5'sd1) + (bits[266] ? 5'sd1 : -5'sd1) + (bits[267] ? -5'sd1 : 5'sd1) + (bits[281] ? 5'sd1 : -5'sd1) + (bits[283] ? -5'sd1 : 5'sd1) + (bits[297] ? -5'sd1 : 5'sd1) + (bits[298] ? 5'sd1 : -5'sd1) + (bits[299] ? 5'sd1 : -5'sd1);
283: raw_field = (bits[266] ? 5'sd1 : -5'sd1) + (bits[267] ? 5'sd1 : -5'sd1) + (bits[268] ? -5'sd1 : 5'sd1) + (bits[282] ? -5'sd1 : 5'sd1) + (bits[284] ? 5'sd1 : -5'sd1) + (bits[298] ? -5'sd1 : 5'sd1) + (bits[299] ? -5'sd1 : 5'sd1) + (bits[300] ? -5'sd1 : 5'sd1);
284: raw_field = (bits[267] ? 5'sd1 : -5'sd1) + (bits[268] ? 5'sd1 : -5'sd1) + (bits[269] ? 5'sd1 : -5'sd1) + (bits[283] ? 5'sd1 : -5'sd1) + (bits[285] ? -5'sd1 : 5'sd1) + (bits[299] ? 5'sd1 : -5'sd1) + (bits[300] ? 5'sd1 : -5'sd1) + (bits[301] ? 5'sd1 : -5'sd1);
285: raw_field = (bits[268] ? 5'sd1 : -5'sd1) + (bits[269] ? 5'sd1 : -5'sd1) + (bits[270] ? 5'sd1 : -5'sd1) + (bits[284] ? -5'sd1 : 5'sd1) + (bits[286] ? 5'sd1 : -5'sd1) + (bits[300] ? 5'sd1 : -5'sd1) + (bits[301] ? 5'sd1 : -5'sd1) + (bits[302] ? -5'sd1 : 5'sd1);
286: raw_field = (bits[269] ? 5'sd1 : -5'sd1) + (bits[270] ? -5'sd1 : 5'sd1) + (bits[271] ? 5'sd1 : -5'sd1) + (bits[285] ? 5'sd1 : -5'sd1) + (bits[287] ? 5'sd1 : -5'sd1) + (bits[301] ? -5'sd1 : 5'sd1) + (bits[302] ? 5'sd1 : -5'sd1) + (bits[303] ? 5'sd1 : -5'sd1);
287: raw_field = (bits[270] ? -5'sd1 : 5'sd1) + (bits[271] ? -5'sd1 : 5'sd1) + (bits[286] ? 5'sd1 : -5'sd1) + (bits[302] ? -5'sd1 : 5'sd1) + (bits[303] ? 5'sd1 : -5'sd1);
288: raw_field = (bits[272] ? 5'sd1 : -5'sd1) + (bits[273] ? 5'sd1 : -5'sd1) + (bits[289] ? 5'sd1 : -5'sd1) + (bits[304] ? 5'sd1 : -5'sd1) + (bits[305] ? 5'sd1 : -5'sd1);
289: raw_field = (bits[272] ? -5'sd1 : 5'sd1) + (bits[273] ? 5'sd1 : -5'sd1) + (bits[274] ? 5'sd1 : -5'sd1) + (bits[288] ? 5'sd1 : -5'sd1) + (bits[290] ? 5'sd1 : -5'sd1) + (bits[304] ? -5'sd1 : 5'sd1) + (bits[305] ? -5'sd1 : 5'sd1) + (bits[306] ? 5'sd1 : -5'sd1);
290: raw_field = (bits[273] ? 5'sd1 : -5'sd1) + (bits[274] ? -5'sd1 : 5'sd1) + (bits[275] ? 5'sd1 : -5'sd1) + (bits[289] ? 5'sd1 : -5'sd1) + (bits[291] ? -5'sd1 : 5'sd1) + (bits[305] ? -5'sd1 : 5'sd1) + (bits[306] ? -5'sd1 : 5'sd1) + (bits[307] ? 5'sd1 : -5'sd1);
291: raw_field = (bits[274] ? 5'sd1 : -5'sd1) + (bits[275] ? -5'sd1 : 5'sd1) + (bits[276] ? -5'sd1 : 5'sd1) + (bits[290] ? -5'sd1 : 5'sd1) + (bits[292] ? 5'sd1 : -5'sd1) + (bits[306] ? 5'sd1 : -5'sd1) + (bits[307] ? -5'sd1 : 5'sd1) + (bits[308] ? 5'sd1 : -5'sd1);
292: raw_field = (bits[275] ? 5'sd1 : -5'sd1) + (bits[276] ? 5'sd1 : -5'sd1) + (bits[277] ? -5'sd1 : 5'sd1) + (bits[291] ? 5'sd1 : -5'sd1) + (bits[293] ? -5'sd1 : 5'sd1) + (bits[307] ? 5'sd1 : -5'sd1) + (bits[308] ? -5'sd1 : 5'sd1) + (bits[309] ? 5'sd1 : -5'sd1);
293: raw_field = (bits[276] ? 5'sd1 : -5'sd1) + (bits[277] ? 5'sd1 : -5'sd1) + (bits[278] ? 5'sd1 : -5'sd1) + (bits[292] ? -5'sd1 : 5'sd1) + (bits[294] ? -5'sd1 : 5'sd1) + (bits[308] ? -5'sd1 : 5'sd1) + (bits[309] ? 5'sd1 : -5'sd1) + (bits[310] ? -5'sd1 : 5'sd1);
294: raw_field = (bits[277] ? 5'sd1 : -5'sd1) + (bits[278] ? 5'sd1 : -5'sd1) + (bits[279] ? -5'sd1 : 5'sd1) + (bits[293] ? -5'sd1 : 5'sd1) + (bits[295] ? 5'sd1 : -5'sd1) + (bits[309] ? -5'sd1 : 5'sd1) + (bits[310] ? -5'sd1 : 5'sd1) + (bits[311] ? -5'sd1 : 5'sd1);
295: raw_field = (bits[278] ? 5'sd1 : -5'sd1) + (bits[279] ? 5'sd1 : -5'sd1) + (bits[280] ? 5'sd1 : -5'sd1) + (bits[294] ? 5'sd1 : -5'sd1) + (bits[296] ? -5'sd1 : 5'sd1) + (bits[310] ? 5'sd1 : -5'sd1) + (bits[311] ? -5'sd1 : 5'sd1) + (bits[312] ? 5'sd1 : -5'sd1);
296: raw_field = (bits[279] ? 5'sd1 : -5'sd1) + (bits[280] ? 5'sd1 : -5'sd1) + (bits[281] ? 5'sd1 : -5'sd1) + (bits[295] ? -5'sd1 : 5'sd1) + (bits[297] ? -5'sd1 : 5'sd1) + (bits[311] ? 5'sd1 : -5'sd1) + (bits[312] ? -5'sd1 : 5'sd1) + (bits[313] ? 5'sd1 : -5'sd1);
297: raw_field = (bits[280] ? 5'sd1 : -5'sd1) + (bits[281] ? -5'sd1 : 5'sd1) + (bits[282] ? -5'sd1 : 5'sd1) + (bits[296] ? -5'sd1 : 5'sd1) + (bits[298] ? -5'sd1 : 5'sd1) + (bits[312] ? -5'sd1 : 5'sd1) + (bits[313] ? -5'sd1 : 5'sd1) + (bits[314] ? -5'sd1 : 5'sd1);
298: raw_field = (bits[281] ? 5'sd1 : -5'sd1) + (bits[282] ? 5'sd1 : -5'sd1) + (bits[283] ? -5'sd1 : 5'sd1) + (bits[297] ? -5'sd1 : 5'sd1) + (bits[299] ? -5'sd1 : 5'sd1) + (bits[313] ? -5'sd1 : 5'sd1) + (bits[314] ? -5'sd1 : 5'sd1) + (bits[315] ? 5'sd1 : -5'sd1);
299: raw_field = (bits[282] ? 5'sd1 : -5'sd1) + (bits[283] ? -5'sd1 : 5'sd1) + (bits[284] ? 5'sd1 : -5'sd1) + (bits[298] ? -5'sd1 : 5'sd1) + (bits[300] ? 5'sd1 : -5'sd1) + (bits[314] ? 5'sd1 : -5'sd1) + (bits[315] ? 5'sd1 : -5'sd1) + (bits[316] ? 5'sd1 : -5'sd1);
300: raw_field = (bits[283] ? -5'sd1 : 5'sd1) + (bits[284] ? 5'sd1 : -5'sd1) + (bits[285] ? 5'sd1 : -5'sd1) + (bits[299] ? 5'sd1 : -5'sd1) + (bits[301] ? -5'sd1 : 5'sd1) + (bits[315] ? 5'sd1 : -5'sd1) + (bits[316] ? -5'sd1 : 5'sd1) + (bits[317] ? 5'sd1 : -5'sd1);
301: raw_field = (bits[284] ? 5'sd1 : -5'sd1) + (bits[285] ? 5'sd1 : -5'sd1) + (bits[286] ? -5'sd1 : 5'sd1) + (bits[300] ? -5'sd1 : 5'sd1) + (bits[302] ? 5'sd1 : -5'sd1) + (bits[316] ? 5'sd1 : -5'sd1) + (bits[317] ? -5'sd1 : 5'sd1) + (bits[318] ? -5'sd1 : 5'sd1);
302: raw_field = (bits[285] ? -5'sd1 : 5'sd1) + (bits[286] ? 5'sd1 : -5'sd1) + (bits[287] ? -5'sd1 : 5'sd1) + (bits[301] ? 5'sd1 : -5'sd1) + (bits[303] ? 5'sd1 : -5'sd1) + (bits[317] ? 5'sd1 : -5'sd1) + (bits[318] ? 5'sd1 : -5'sd1) + (bits[319] ? 5'sd1 : -5'sd1);
303: raw_field = (bits[286] ? 5'sd1 : -5'sd1) + (bits[287] ? 5'sd1 : -5'sd1) + (bits[302] ? 5'sd1 : -5'sd1) + (bits[318] ? -5'sd1 : 5'sd1) + (bits[319] ? 5'sd1 : -5'sd1);
304: raw_field = (bits[288] ? 5'sd1 : -5'sd1) + (bits[289] ? -5'sd1 : 5'sd1) + (bits[305] ? 5'sd1 : -5'sd1) + (bits[320] ? -5'sd1 : 5'sd1) + (bits[321] ? -5'sd1 : 5'sd1);
305: raw_field = (bits[288] ? 5'sd1 : -5'sd1) + (bits[289] ? -5'sd1 : 5'sd1) + (bits[290] ? -5'sd1 : 5'sd1) + (bits[304] ? 5'sd1 : -5'sd1) + (bits[306] ? 5'sd1 : -5'sd1) + (bits[320] ? 5'sd1 : -5'sd1) + (bits[321] ? 5'sd1 : -5'sd1) + (bits[322] ? 5'sd1 : -5'sd1);
306: raw_field = (bits[289] ? 5'sd1 : -5'sd1) + (bits[290] ? -5'sd1 : 5'sd1) + (bits[291] ? 5'sd1 : -5'sd1) + (bits[305] ? 5'sd1 : -5'sd1) + (bits[307] ? 5'sd1 : -5'sd1) + (bits[321] ? -5'sd1 : 5'sd1) + (bits[322] ? -5'sd1 : 5'sd1) + (bits[323] ? 5'sd1 : -5'sd1);
307: raw_field = (bits[290] ? 5'sd1 : -5'sd1) + (bits[291] ? -5'sd1 : 5'sd1) + (bits[292] ? 5'sd1 : -5'sd1) + (bits[306] ? 5'sd1 : -5'sd1) + (bits[308] ? 5'sd1 : -5'sd1) + (bits[322] ? -5'sd1 : 5'sd1) + (bits[323] ? -5'sd1 : 5'sd1) + (bits[324] ? -5'sd1 : 5'sd1);
308: raw_field = (bits[291] ? 5'sd1 : -5'sd1) + (bits[292] ? -5'sd1 : 5'sd1) + (bits[293] ? -5'sd1 : 5'sd1) + (bits[307] ? 5'sd1 : -5'sd1) + (bits[309] ? -5'sd1 : 5'sd1) + (bits[323] ? 5'sd1 : -5'sd1) + (bits[324] ? 5'sd1 : -5'sd1) + (bits[325] ? -5'sd1 : 5'sd1);
309: raw_field = (bits[292] ? 5'sd1 : -5'sd1) + (bits[293] ? 5'sd1 : -5'sd1) + (bits[294] ? -5'sd1 : 5'sd1) + (bits[308] ? -5'sd1 : 5'sd1) + (bits[310] ? 5'sd1 : -5'sd1) + (bits[324] ? 5'sd1 : -5'sd1) + (bits[325] ? 5'sd1 : -5'sd1) + (bits[326] ? 5'sd1 : -5'sd1);
310: raw_field = (bits[293] ? -5'sd1 : 5'sd1) + (bits[294] ? -5'sd1 : 5'sd1) + (bits[295] ? 5'sd1 : -5'sd1) + (bits[309] ? 5'sd1 : -5'sd1) + (bits[311] ? -5'sd1 : 5'sd1) + (bits[325] ? 5'sd1 : -5'sd1) + (bits[326] ? 5'sd1 : -5'sd1) + (bits[327] ? 5'sd1 : -5'sd1);
311: raw_field = (bits[294] ? -5'sd1 : 5'sd1) + (bits[295] ? -5'sd1 : 5'sd1) + (bits[296] ? 5'sd1 : -5'sd1) + (bits[310] ? -5'sd1 : 5'sd1) + (bits[312] ? -5'sd1 : 5'sd1) + (bits[326] ? -5'sd1 : 5'sd1) + (bits[327] ? -5'sd1 : 5'sd1) + (bits[328] ? 5'sd1 : -5'sd1);
312: raw_field = (bits[295] ? 5'sd1 : -5'sd1) + (bits[296] ? -5'sd1 : 5'sd1) + (bits[297] ? -5'sd1 : 5'sd1) + (bits[311] ? -5'sd1 : 5'sd1) + (bits[313] ? 5'sd1 : -5'sd1) + (bits[327] ? -5'sd1 : 5'sd1) + (bits[328] ? -5'sd1 : 5'sd1) + (bits[329] ? -5'sd1 : 5'sd1);
313: raw_field = (bits[296] ? 5'sd1 : -5'sd1) + (bits[297] ? -5'sd1 : 5'sd1) + (bits[298] ? -5'sd1 : 5'sd1) + (bits[312] ? 5'sd1 : -5'sd1) + (bits[314] ? -5'sd1 : 5'sd1) + (bits[328] ? 5'sd1 : -5'sd1) + (bits[329] ? -5'sd1 : 5'sd1) + (bits[330] ? -5'sd1 : 5'sd1);
314: raw_field = (bits[297] ? -5'sd1 : 5'sd1) + (bits[298] ? -5'sd1 : 5'sd1) + (bits[299] ? 5'sd1 : -5'sd1) + (bits[313] ? -5'sd1 : 5'sd1) + (bits[315] ? -5'sd1 : 5'sd1) + (bits[329] ? 5'sd1 : -5'sd1) + (bits[330] ? -5'sd1 : 5'sd1) + (bits[331] ? 5'sd1 : -5'sd1);
315: raw_field = (bits[298] ? 5'sd1 : -5'sd1) + (bits[299] ? 5'sd1 : -5'sd1) + (bits[300] ? 5'sd1 : -5'sd1) + (bits[314] ? -5'sd1 : 5'sd1) + (bits[316] ? 5'sd1 : -5'sd1) + (bits[330] ? 5'sd1 : -5'sd1) + (bits[331] ? 5'sd1 : -5'sd1) + (bits[332] ? 5'sd1 : -5'sd1);
316: raw_field = (bits[299] ? 5'sd1 : -5'sd1) + (bits[300] ? -5'sd1 : 5'sd1) + (bits[301] ? 5'sd1 : -5'sd1) + (bits[315] ? 5'sd1 : -5'sd1) + (bits[317] ? -5'sd1 : 5'sd1) + (bits[331] ? 5'sd1 : -5'sd1) + (bits[332] ? -5'sd1 : 5'sd1) + (bits[333] ? -5'sd1 : 5'sd1);
317: raw_field = (bits[300] ? 5'sd1 : -5'sd1) + (bits[301] ? -5'sd1 : 5'sd1) + (bits[302] ? 5'sd1 : -5'sd1) + (bits[316] ? -5'sd1 : 5'sd1) + (bits[318] ? 5'sd1 : -5'sd1) + (bits[332] ? -5'sd1 : 5'sd1) + (bits[333] ? 5'sd1 : -5'sd1) + (bits[334] ? -5'sd1 : 5'sd1);
318: raw_field = (bits[301] ? -5'sd1 : 5'sd1) + (bits[302] ? 5'sd1 : -5'sd1) + (bits[303] ? -5'sd1 : 5'sd1) + (bits[317] ? 5'sd1 : -5'sd1) + (bits[319] ? 5'sd1 : -5'sd1) + (bits[333] ? -5'sd1 : 5'sd1) + (bits[334] ? 5'sd1 : -5'sd1) + (bits[335] ? 5'sd1 : -5'sd1);
319: raw_field = (bits[302] ? 5'sd1 : -5'sd1) + (bits[303] ? 5'sd1 : -5'sd1) + (bits[318] ? 5'sd1 : -5'sd1) + (bits[334] ? -5'sd1 : 5'sd1) + (bits[335] ? 5'sd1 : -5'sd1);
320: raw_field = (bits[304] ? -5'sd1 : 5'sd1) + (bits[305] ? 5'sd1 : -5'sd1) + (bits[321] ? -5'sd1 : 5'sd1) + (bits[336] ? -5'sd1 : 5'sd1) + (bits[337] ? -5'sd1 : 5'sd1);
321: raw_field = (bits[304] ? -5'sd1 : 5'sd1) + (bits[305] ? 5'sd1 : -5'sd1) + (bits[306] ? -5'sd1 : 5'sd1) + (bits[320] ? -5'sd1 : 5'sd1) + (bits[322] ? -5'sd1 : 5'sd1) + (bits[336] ? 5'sd1 : -5'sd1) + (bits[337] ? 5'sd1 : -5'sd1) + (bits[338] ? -5'sd1 : 5'sd1);
322: raw_field = (bits[305] ? 5'sd1 : -5'sd1) + (bits[306] ? -5'sd1 : 5'sd1) + (bits[307] ? -5'sd1 : 5'sd1) + (bits[321] ? -5'sd1 : 5'sd1) + (bits[323] ? 5'sd1 : -5'sd1) + (bits[337] ? -5'sd1 : 5'sd1) + (bits[338] ? 5'sd1 : -5'sd1) + (bits[339] ? 5'sd1 : -5'sd1);
323: raw_field = (bits[306] ? 5'sd1 : -5'sd1) + (bits[307] ? -5'sd1 : 5'sd1) + (bits[308] ? 5'sd1 : -5'sd1) + (bits[322] ? 5'sd1 : -5'sd1) + (bits[324] ? -5'sd1 : 5'sd1) + (bits[338] ? 5'sd1 : -5'sd1) + (bits[339] ? -5'sd1 : 5'sd1) + (bits[340] ? -5'sd1 : 5'sd1);
324: raw_field = (bits[307] ? -5'sd1 : 5'sd1) + (bits[308] ? 5'sd1 : -5'sd1) + (bits[309] ? 5'sd1 : -5'sd1) + (bits[323] ? -5'sd1 : 5'sd1) + (bits[325] ? 5'sd1 : -5'sd1) + (bits[339] ? -5'sd1 : 5'sd1) + (bits[340] ? 5'sd1 : -5'sd1) + (bits[341] ? -5'sd1 : 5'sd1);
325: raw_field = (bits[308] ? -5'sd1 : 5'sd1) + (bits[309] ? 5'sd1 : -5'sd1) + (bits[310] ? 5'sd1 : -5'sd1) + (bits[324] ? 5'sd1 : -5'sd1) + (bits[326] ? -5'sd1 : 5'sd1) + (bits[340] ? 5'sd1 : -5'sd1) + (bits[341] ? 5'sd1 : -5'sd1) + (bits[342] ? 5'sd1 : -5'sd1);
326: raw_field = (bits[309] ? 5'sd1 : -5'sd1) + (bits[310] ? 5'sd1 : -5'sd1) + (bits[311] ? -5'sd1 : 5'sd1) + (bits[325] ? -5'sd1 : 5'sd1) + (bits[327] ? 5'sd1 : -5'sd1) + (bits[341] ? -5'sd1 : 5'sd1) + (bits[342] ? -5'sd1 : 5'sd1) + (bits[343] ? 5'sd1 : -5'sd1);
327: raw_field = (bits[310] ? 5'sd1 : -5'sd1) + (bits[311] ? -5'sd1 : 5'sd1) + (bits[312] ? -5'sd1 : 5'sd1) + (bits[326] ? 5'sd1 : -5'sd1) + (bits[328] ? -5'sd1 : 5'sd1) + (bits[342] ? 5'sd1 : -5'sd1) + (bits[343] ? 5'sd1 : -5'sd1) + (bits[344] ? 5'sd1 : -5'sd1);
328: raw_field = (bits[311] ? 5'sd1 : -5'sd1) + (bits[312] ? -5'sd1 : 5'sd1) + (bits[313] ? 5'sd1 : -5'sd1) + (bits[327] ? -5'sd1 : 5'sd1) + (bits[329] ? 5'sd1 : -5'sd1) + (bits[343] ? -5'sd1 : 5'sd1) + (bits[344] ? 5'sd1 : -5'sd1) + (bits[345] ? 5'sd1 : -5'sd1);
329: raw_field = (bits[312] ? -5'sd1 : 5'sd1) + (bits[313] ? -5'sd1 : 5'sd1) + (bits[314] ? 5'sd1 : -5'sd1) + (bits[328] ? 5'sd1 : -5'sd1) + (bits[330] ? -5'sd1 : 5'sd1) + (bits[344] ? -5'sd1 : 5'sd1) + (bits[345] ? 5'sd1 : -5'sd1) + (bits[346] ? 5'sd1 : -5'sd1);
330: raw_field = (bits[313] ? -5'sd1 : 5'sd1) + (bits[314] ? -5'sd1 : 5'sd1) + (bits[315] ? 5'sd1 : -5'sd1) + (bits[329] ? -5'sd1 : 5'sd1) + (bits[331] ? 5'sd1 : -5'sd1) + (bits[345] ? -5'sd1 : 5'sd1) + (bits[346] ? 5'sd1 : -5'sd1) + (bits[347] ? 5'sd1 : -5'sd1);
331: raw_field = (bits[314] ? 5'sd1 : -5'sd1) + (bits[315] ? 5'sd1 : -5'sd1) + (bits[316] ? 5'sd1 : -5'sd1) + (bits[330] ? 5'sd1 : -5'sd1) + (bits[332] ? 5'sd1 : -5'sd1) + (bits[346] ? -5'sd1 : 5'sd1) + (bits[347] ? -5'sd1 : 5'sd1) + (bits[348] ? 5'sd1 : -5'sd1);
332: raw_field = (bits[315] ? 5'sd1 : -5'sd1) + (bits[316] ? -5'sd1 : 5'sd1) + (bits[317] ? -5'sd1 : 5'sd1) + (bits[331] ? 5'sd1 : -5'sd1) + (bits[333] ? 5'sd1 : -5'sd1) + (bits[347] ? 5'sd1 : -5'sd1) + (bits[348] ? 5'sd1 : -5'sd1) + (bits[349] ? 5'sd1 : -5'sd1);
333: raw_field = (bits[316] ? -5'sd1 : 5'sd1) + (bits[317] ? 5'sd1 : -5'sd1) + (bits[318] ? -5'sd1 : 5'sd1) + (bits[332] ? 5'sd1 : -5'sd1) + (bits[334] ? 5'sd1 : -5'sd1) + (bits[348] ? 5'sd1 : -5'sd1) + (bits[349] ? 5'sd1 : -5'sd1) + (bits[350] ? 5'sd1 : -5'sd1);
334: raw_field = (bits[317] ? -5'sd1 : 5'sd1) + (bits[318] ? 5'sd1 : -5'sd1) + (bits[319] ? -5'sd1 : 5'sd1) + (bits[333] ? 5'sd1 : -5'sd1) + (bits[335] ? -5'sd1 : 5'sd1) + (bits[349] ? -5'sd1 : 5'sd1) + (bits[350] ? 5'sd1 : -5'sd1) + (bits[351] ? -5'sd1 : 5'sd1);
335: raw_field = (bits[318] ? 5'sd1 : -5'sd1) + (bits[319] ? 5'sd1 : -5'sd1) + (bits[334] ? -5'sd1 : 5'sd1) + (bits[350] ? -5'sd1 : 5'sd1) + (bits[351] ? 5'sd1 : -5'sd1);
336: raw_field = (bits[320] ? -5'sd1 : 5'sd1) + (bits[321] ? 5'sd1 : -5'sd1) + (bits[337] ? -5'sd1 : 5'sd1) + (bits[352] ? 5'sd1 : -5'sd1) + (bits[353] ? -5'sd1 : 5'sd1);
337: raw_field = (bits[320] ? -5'sd1 : 5'sd1) + (bits[321] ? 5'sd1 : -5'sd1) + (bits[322] ? -5'sd1 : 5'sd1) + (bits[336] ? -5'sd1 : 5'sd1) + (bits[338] ? -5'sd1 : 5'sd1) + (bits[352] ? 5'sd1 : -5'sd1) + (bits[353] ? 5'sd1 : -5'sd1) + (bits[354] ? -5'sd1 : 5'sd1);
338: raw_field = (bits[321] ? -5'sd1 : 5'sd1) + (bits[322] ? 5'sd1 : -5'sd1) + (bits[323] ? 5'sd1 : -5'sd1) + (bits[337] ? -5'sd1 : 5'sd1) + (bits[339] ? 5'sd1 : -5'sd1) + (bits[353] ? 5'sd1 : -5'sd1) + (bits[354] ? 5'sd1 : -5'sd1) + (bits[355] ? -5'sd1 : 5'sd1);
339: raw_field = (bits[322] ? 5'sd1 : -5'sd1) + (bits[323] ? -5'sd1 : 5'sd1) + (bits[324] ? -5'sd1 : 5'sd1) + (bits[338] ? 5'sd1 : -5'sd1) + (bits[340] ? -5'sd1 : 5'sd1) + (bits[354] ? 5'sd1 : -5'sd1) + (bits[355] ? 5'sd1 : -5'sd1) + (bits[356] ? -5'sd1 : 5'sd1);
340: raw_field = (bits[323] ? -5'sd1 : 5'sd1) + (bits[324] ? 5'sd1 : -5'sd1) + (bits[325] ? 5'sd1 : -5'sd1) + (bits[339] ? -5'sd1 : 5'sd1) + (bits[341] ? -5'sd1 : 5'sd1) + (bits[355] ? -5'sd1 : 5'sd1) + (bits[356] ? 5'sd1 : -5'sd1) + (bits[357] ? 5'sd1 : -5'sd1);
341: raw_field = (bits[324] ? -5'sd1 : 5'sd1) + (bits[325] ? 5'sd1 : -5'sd1) + (bits[326] ? -5'sd1 : 5'sd1) + (bits[340] ? -5'sd1 : 5'sd1) + (bits[342] ? 5'sd1 : -5'sd1) + (bits[356] ? 5'sd1 : -5'sd1) + (bits[357] ? 5'sd1 : -5'sd1) + (bits[358] ? 5'sd1 : -5'sd1);
342: raw_field = (bits[325] ? 5'sd1 : -5'sd1) + (bits[326] ? -5'sd1 : 5'sd1) + (bits[327] ? 5'sd1 : -5'sd1) + (bits[341] ? 5'sd1 : -5'sd1) + (bits[343] ? -5'sd1 : 5'sd1) + (bits[357] ? 5'sd1 : -5'sd1) + (bits[358] ? -5'sd1 : 5'sd1) + (bits[359] ? -5'sd1 : 5'sd1);
343: raw_field = (bits[326] ? 5'sd1 : -5'sd1) + (bits[327] ? 5'sd1 : -5'sd1) + (bits[328] ? -5'sd1 : 5'sd1) + (bits[342] ? -5'sd1 : 5'sd1) + (bits[344] ? -5'sd1 : 5'sd1) + (bits[358] ? 5'sd1 : -5'sd1) + (bits[359] ? 5'sd1 : -5'sd1) + (bits[360] ? 5'sd1 : -5'sd1);
344: raw_field = (bits[327] ? 5'sd1 : -5'sd1) + (bits[328] ? 5'sd1 : -5'sd1) + (bits[329] ? -5'sd1 : 5'sd1) + (bits[343] ? -5'sd1 : 5'sd1) + (bits[345] ? 5'sd1 : -5'sd1) + (bits[359] ? -5'sd1 : 5'sd1) + (bits[360] ? -5'sd1 : 5'sd1) + (bits[361] ? -5'sd1 : 5'sd1);
345: raw_field = (bits[328] ? 5'sd1 : -5'sd1) + (bits[329] ? 5'sd1 : -5'sd1) + (bits[330] ? -5'sd1 : 5'sd1) + (bits[344] ? 5'sd1 : -5'sd1) + (bits[346] ? 5'sd1 : -5'sd1) + (bits[360] ? 5'sd1 : -5'sd1) + (bits[361] ? -5'sd1 : 5'sd1) + (bits[362] ? -5'sd1 : 5'sd1);
346: raw_field = (bits[329] ? 5'sd1 : -5'sd1) + (bits[330] ? 5'sd1 : -5'sd1) + (bits[331] ? -5'sd1 : 5'sd1) + (bits[345] ? 5'sd1 : -5'sd1) + (bits[347] ? -5'sd1 : 5'sd1) + (bits[361] ? 5'sd1 : -5'sd1) + (bits[362] ? -5'sd1 : 5'sd1) + (bits[363] ? -5'sd1 : 5'sd1);
347: raw_field = (bits[330] ? 5'sd1 : -5'sd1) + (bits[331] ? -5'sd1 : 5'sd1) + (bits[332] ? 5'sd1 : -5'sd1) + (bits[346] ? -5'sd1 : 5'sd1) + (bits[348] ? -5'sd1 : 5'sd1) + (bits[362] ? -5'sd1 : 5'sd1) + (bits[363] ? -5'sd1 : 5'sd1) + (bits[364] ? -5'sd1 : 5'sd1);
348: raw_field = (bits[331] ? 5'sd1 : -5'sd1) + (bits[332] ? 5'sd1 : -5'sd1) + (bits[333] ? 5'sd1 : -5'sd1) + (bits[347] ? -5'sd1 : 5'sd1) + (bits[349] ? -5'sd1 : 5'sd1) + (bits[363] ? 5'sd1 : -5'sd1) + (bits[364] ? 5'sd1 : -5'sd1) + (bits[365] ? 5'sd1 : -5'sd1);
349: raw_field = (bits[332] ? 5'sd1 : -5'sd1) + (bits[333] ? 5'sd1 : -5'sd1) + (bits[334] ? -5'sd1 : 5'sd1) + (bits[348] ? -5'sd1 : 5'sd1) + (bits[350] ? -5'sd1 : 5'sd1) + (bits[364] ? -5'sd1 : 5'sd1) + (bits[365] ? 5'sd1 : -5'sd1) + (bits[366] ? 5'sd1 : -5'sd1);
350: raw_field = (bits[333] ? 5'sd1 : -5'sd1) + (bits[334] ? 5'sd1 : -5'sd1) + (bits[335] ? -5'sd1 : 5'sd1) + (bits[349] ? -5'sd1 : 5'sd1) + (bits[351] ? -5'sd1 : 5'sd1) + (bits[365] ? -5'sd1 : 5'sd1) + (bits[366] ? 5'sd1 : -5'sd1) + (bits[367] ? 5'sd1 : -5'sd1);
351: raw_field = (bits[334] ? -5'sd1 : 5'sd1) + (bits[335] ? 5'sd1 : -5'sd1) + (bits[350] ? -5'sd1 : 5'sd1) + (bits[366] ? 5'sd1 : -5'sd1) + (bits[367] ? -5'sd1 : 5'sd1);
352: raw_field = (bits[336] ? 5'sd1 : -5'sd1) + (bits[337] ? 5'sd1 : -5'sd1) + (bits[353] ? 5'sd1 : -5'sd1) + (bits[368] ? -5'sd1 : 5'sd1) + (bits[369] ? -5'sd1 : 5'sd1);
353: raw_field = (bits[336] ? -5'sd1 : 5'sd1) + (bits[337] ? 5'sd1 : -5'sd1) + (bits[338] ? 5'sd1 : -5'sd1) + (bits[352] ? 5'sd1 : -5'sd1) + (bits[354] ? -5'sd1 : 5'sd1) + (bits[368] ? -5'sd1 : 5'sd1) + (bits[369] ? 5'sd1 : -5'sd1) + (bits[370] ? -5'sd1 : 5'sd1);
354: raw_field = (bits[337] ? -5'sd1 : 5'sd1) + (bits[338] ? 5'sd1 : -5'sd1) + (bits[339] ? 5'sd1 : -5'sd1) + (bits[353] ? -5'sd1 : 5'sd1) + (bits[355] ? -5'sd1 : 5'sd1) + (bits[369] ? -5'sd1 : 5'sd1) + (bits[370] ? -5'sd1 : 5'sd1) + (bits[371] ? 5'sd1 : -5'sd1);
355: raw_field = (bits[338] ? -5'sd1 : 5'sd1) + (bits[339] ? 5'sd1 : -5'sd1) + (bits[340] ? -5'sd1 : 5'sd1) + (bits[354] ? -5'sd1 : 5'sd1) + (bits[356] ? -5'sd1 : 5'sd1) + (bits[370] ? -5'sd1 : 5'sd1) + (bits[371] ? 5'sd1 : -5'sd1) + (bits[372] ? -5'sd1 : 5'sd1);
356: raw_field = (bits[339] ? -5'sd1 : 5'sd1) + (bits[340] ? 5'sd1 : -5'sd1) + (bits[341] ? 5'sd1 : -5'sd1) + (bits[355] ? -5'sd1 : 5'sd1) + (bits[357] ? -5'sd1 : 5'sd1) + (bits[371] ? -5'sd1 : 5'sd1) + (bits[372] ? -5'sd1 : 5'sd1) + (bits[373] ? 5'sd1 : -5'sd1);
357: raw_field = (bits[340] ? 5'sd1 : -5'sd1) + (bits[341] ? 5'sd1 : -5'sd1) + (bits[342] ? 5'sd1 : -5'sd1) + (bits[356] ? -5'sd1 : 5'sd1) + (bits[358] ? -5'sd1 : 5'sd1) + (bits[372] ? -5'sd1 : 5'sd1) + (bits[373] ? 5'sd1 : -5'sd1) + (bits[374] ? 5'sd1 : -5'sd1);
358: raw_field = (bits[341] ? 5'sd1 : -5'sd1) + (bits[342] ? -5'sd1 : 5'sd1) + (bits[343] ? 5'sd1 : -5'sd1) + (bits[357] ? -5'sd1 : 5'sd1) + (bits[359] ? 5'sd1 : -5'sd1) + (bits[373] ? 5'sd1 : -5'sd1) + (bits[374] ? 5'sd1 : -5'sd1) + (bits[375] ? -5'sd1 : 5'sd1);
359: raw_field = (bits[342] ? -5'sd1 : 5'sd1) + (bits[343] ? 5'sd1 : -5'sd1) + (bits[344] ? -5'sd1 : 5'sd1) + (bits[358] ? 5'sd1 : -5'sd1) + (bits[360] ? -5'sd1 : 5'sd1) + (bits[374] ? 5'sd1 : -5'sd1) + (bits[375] ? 5'sd1 : -5'sd1) + (bits[376] ? -5'sd1 : 5'sd1);
360: raw_field = (bits[343] ? 5'sd1 : -5'sd1) + (bits[344] ? -5'sd1 : 5'sd1) + (bits[345] ? 5'sd1 : -5'sd1) + (bits[359] ? -5'sd1 : 5'sd1) + (bits[361] ? 5'sd1 : -5'sd1) + (bits[375] ? 5'sd1 : -5'sd1) + (bits[376] ? -5'sd1 : 5'sd1) + (bits[377] ? -5'sd1 : 5'sd1);
361: raw_field = (bits[344] ? -5'sd1 : 5'sd1) + (bits[345] ? -5'sd1 : 5'sd1) + (bits[346] ? 5'sd1 : -5'sd1) + (bits[360] ? 5'sd1 : -5'sd1) + (bits[362] ? 5'sd1 : -5'sd1) + (bits[376] ? 5'sd1 : -5'sd1) + (bits[377] ? -5'sd1 : 5'sd1) + (bits[378] ? 5'sd1 : -5'sd1);
362: raw_field = (bits[345] ? -5'sd1 : 5'sd1) + (bits[346] ? -5'sd1 : 5'sd1) + (bits[347] ? -5'sd1 : 5'sd1) + (bits[361] ? 5'sd1 : -5'sd1) + (bits[363] ? -5'sd1 : 5'sd1) + (bits[377] ? 5'sd1 : -5'sd1) + (bits[378] ? -5'sd1 : 5'sd1) + (bits[379] ? 5'sd1 : -5'sd1);
363: raw_field = (bits[346] ? -5'sd1 : 5'sd1) + (bits[347] ? -5'sd1 : 5'sd1) + (bits[348] ? 5'sd1 : -5'sd1) + (bits[362] ? -5'sd1 : 5'sd1) + (bits[364] ? 5'sd1 : -5'sd1) + (bits[378] ? -5'sd1 : 5'sd1) + (bits[379] ? -5'sd1 : 5'sd1) + (bits[380] ? 5'sd1 : -5'sd1);
364: raw_field = (bits[347] ? -5'sd1 : 5'sd1) + (bits[348] ? 5'sd1 : -5'sd1) + (bits[349] ? -5'sd1 : 5'sd1) + (bits[363] ? 5'sd1 : -5'sd1) + (bits[365] ? -5'sd1 : 5'sd1) + (bits[379] ? -5'sd1 : 5'sd1) + (bits[380] ? -5'sd1 : 5'sd1) + (bits[381] ? -5'sd1 : 5'sd1);
365: raw_field = (bits[348] ? 5'sd1 : -5'sd1) + (bits[349] ? 5'sd1 : -5'sd1) + (bits[350] ? -5'sd1 : 5'sd1) + (bits[364] ? -5'sd1 : 5'sd1) + (bits[366] ? 5'sd1 : -5'sd1) + (bits[380] ? -5'sd1 : 5'sd1) + (bits[381] ? 5'sd1 : -5'sd1) + (bits[382] ? 5'sd1 : -5'sd1);
366: raw_field = (bits[349] ? 5'sd1 : -5'sd1) + (bits[350] ? 5'sd1 : -5'sd1) + (bits[351] ? 5'sd1 : -5'sd1) + (bits[365] ? 5'sd1 : -5'sd1) + (bits[367] ? 5'sd1 : -5'sd1) + (bits[381] ? 5'sd1 : -5'sd1) + (bits[382] ? 5'sd1 : -5'sd1) + (bits[383] ? 5'sd1 : -5'sd1);
367: raw_field = (bits[350] ? 5'sd1 : -5'sd1) + (bits[351] ? -5'sd1 : 5'sd1) + (bits[366] ? 5'sd1 : -5'sd1) + (bits[382] ? 5'sd1 : -5'sd1) + (bits[383] ? 5'sd1 : -5'sd1);
368: raw_field = (bits[352] ? -5'sd1 : 5'sd1) + (bits[353] ? -5'sd1 : 5'sd1) + (bits[369] ? -5'sd1 : 5'sd1) + (bits[384] ? -5'sd1 : 5'sd1) + (bits[385] ? 5'sd1 : -5'sd1);
369: raw_field = (bits[352] ? -5'sd1 : 5'sd1) + (bits[353] ? 5'sd1 : -5'sd1) + (bits[354] ? -5'sd1 : 5'sd1) + (bits[368] ? -5'sd1 : 5'sd1) + (bits[370] ? -5'sd1 : 5'sd1) + (bits[384] ? -5'sd1 : 5'sd1) + (bits[385] ? -5'sd1 : 5'sd1) + (bits[386] ? -5'sd1 : 5'sd1);
370: raw_field = (bits[353] ? -5'sd1 : 5'sd1) + (bits[354] ? -5'sd1 : 5'sd1) + (bits[355] ? -5'sd1 : 5'sd1) + (bits[369] ? -5'sd1 : 5'sd1) + (bits[371] ? -5'sd1 : 5'sd1) + (bits[385] ? 5'sd1 : -5'sd1) + (bits[386] ? 5'sd1 : -5'sd1) + (bits[387] ? 5'sd1 : -5'sd1);
371: raw_field = (bits[354] ? 5'sd1 : -5'sd1) + (bits[355] ? 5'sd1 : -5'sd1) + (bits[356] ? -5'sd1 : 5'sd1) + (bits[370] ? -5'sd1 : 5'sd1) + (bits[372] ? 5'sd1 : -5'sd1) + (bits[386] ? 5'sd1 : -5'sd1) + (bits[387] ? 5'sd1 : -5'sd1) + (bits[388] ? -5'sd1 : 5'sd1);
372: raw_field = (bits[355] ? -5'sd1 : 5'sd1) + (bits[356] ? -5'sd1 : 5'sd1) + (bits[357] ? -5'sd1 : 5'sd1) + (bits[371] ? 5'sd1 : -5'sd1) + (bits[373] ? -5'sd1 : 5'sd1) + (bits[387] ? -5'sd1 : 5'sd1) + (bits[388] ? 5'sd1 : -5'sd1) + (bits[389] ? -5'sd1 : 5'sd1);
373: raw_field = (bits[356] ? 5'sd1 : -5'sd1) + (bits[357] ? 5'sd1 : -5'sd1) + (bits[358] ? 5'sd1 : -5'sd1) + (bits[372] ? -5'sd1 : 5'sd1) + (bits[374] ? -5'sd1 : 5'sd1) + (bits[388] ? -5'sd1 : 5'sd1) + (bits[389] ? -5'sd1 : 5'sd1) + (bits[390] ? -5'sd1 : 5'sd1);
374: raw_field = (bits[357] ? 5'sd1 : -5'sd1) + (bits[358] ? 5'sd1 : -5'sd1) + (bits[359] ? 5'sd1 : -5'sd1) + (bits[373] ? -5'sd1 : 5'sd1) + (bits[375] ? 5'sd1 : -5'sd1) + (bits[389] ? -5'sd1 : 5'sd1) + (bits[390] ? -5'sd1 : 5'sd1) + (bits[391] ? 5'sd1 : -5'sd1);
375: raw_field = (bits[358] ? -5'sd1 : 5'sd1) + (bits[359] ? 5'sd1 : -5'sd1) + (bits[360] ? 5'sd1 : -5'sd1) + (bits[374] ? 5'sd1 : -5'sd1) + (bits[376] ? -5'sd1 : 5'sd1) + (bits[390] ? 5'sd1 : -5'sd1) + (bits[391] ? 5'sd1 : -5'sd1) + (bits[392] ? 5'sd1 : -5'sd1);
376: raw_field = (bits[359] ? -5'sd1 : 5'sd1) + (bits[360] ? -5'sd1 : 5'sd1) + (bits[361] ? 5'sd1 : -5'sd1) + (bits[375] ? -5'sd1 : 5'sd1) + (bits[377] ? 5'sd1 : -5'sd1) + (bits[391] ? 5'sd1 : -5'sd1) + (bits[392] ? -5'sd1 : 5'sd1) + (bits[393] ? 5'sd1 : -5'sd1);
377: raw_field = (bits[360] ? -5'sd1 : 5'sd1) + (bits[361] ? -5'sd1 : 5'sd1) + (bits[362] ? 5'sd1 : -5'sd1) + (bits[376] ? 5'sd1 : -5'sd1) + (bits[378] ? -5'sd1 : 5'sd1) + (bits[392] ? 5'sd1 : -5'sd1) + (bits[393] ? -5'sd1 : 5'sd1) + (bits[394] ? -5'sd1 : 5'sd1);
378: raw_field = (bits[361] ? 5'sd1 : -5'sd1) + (bits[362] ? -5'sd1 : 5'sd1) + (bits[363] ? -5'sd1 : 5'sd1) + (bits[377] ? -5'sd1 : 5'sd1) + (bits[379] ? -5'sd1 : 5'sd1) + (bits[393] ? 5'sd1 : -5'sd1) + (bits[394] ? -5'sd1 : 5'sd1) + (bits[395] ? 5'sd1 : -5'sd1);
379: raw_field = (bits[362] ? 5'sd1 : -5'sd1) + (bits[363] ? -5'sd1 : 5'sd1) + (bits[364] ? -5'sd1 : 5'sd1) + (bits[378] ? -5'sd1 : 5'sd1) + (bits[380] ? 5'sd1 : -5'sd1) + (bits[394] ? 5'sd1 : -5'sd1) + (bits[395] ? -5'sd1 : 5'sd1) + (bits[396] ? -5'sd1 : 5'sd1);
380: raw_field = (bits[363] ? 5'sd1 : -5'sd1) + (bits[364] ? -5'sd1 : 5'sd1) + (bits[365] ? -5'sd1 : 5'sd1) + (bits[379] ? 5'sd1 : -5'sd1) + (bits[381] ? 5'sd1 : -5'sd1) + (bits[395] ? -5'sd1 : 5'sd1) + (bits[396] ? -5'sd1 : 5'sd1) + (bits[397] ? 5'sd1 : -5'sd1);
381: raw_field = (bits[364] ? -5'sd1 : 5'sd1) + (bits[365] ? 5'sd1 : -5'sd1) + (bits[366] ? 5'sd1 : -5'sd1) + (bits[380] ? 5'sd1 : -5'sd1) + (bits[382] ? -5'sd1 : 5'sd1) + (bits[396] ? 5'sd1 : -5'sd1) + (bits[397] ? 5'sd1 : -5'sd1) + (bits[398] ? 5'sd1 : -5'sd1);
382: raw_field = (bits[365] ? 5'sd1 : -5'sd1) + (bits[366] ? 5'sd1 : -5'sd1) + (bits[367] ? 5'sd1 : -5'sd1) + (bits[381] ? -5'sd1 : 5'sd1) + (bits[383] ? 5'sd1 : -5'sd1) + (bits[397] ? -5'sd1 : 5'sd1) + (bits[398] ? 5'sd1 : -5'sd1) + (bits[399] ? -5'sd1 : 5'sd1);
383: raw_field = (bits[366] ? 5'sd1 : -5'sd1) + (bits[367] ? 5'sd1 : -5'sd1) + (bits[382] ? 5'sd1 : -5'sd1) + (bits[398] ? 5'sd1 : -5'sd1) + (bits[399] ? -5'sd1 : 5'sd1);
384: raw_field = (bits[368] ? -5'sd1 : 5'sd1) + (bits[369] ? -5'sd1 : 5'sd1) + (bits[385] ? 5'sd1 : -5'sd1) + (bits[400] ? -5'sd1 : 5'sd1) + (bits[401] ? 5'sd1 : -5'sd1);
385: raw_field = (bits[368] ? 5'sd1 : -5'sd1) + (bits[369] ? -5'sd1 : 5'sd1) + (bits[370] ? 5'sd1 : -5'sd1) + (bits[384] ? 5'sd1 : -5'sd1) + (bits[386] ? 5'sd1 : -5'sd1) + (bits[400] ? 5'sd1 : -5'sd1) + (bits[401] ? 5'sd1 : -5'sd1) + (bits[402] ? 5'sd1 : -5'sd1);
386: raw_field = (bits[369] ? -5'sd1 : 5'sd1) + (bits[370] ? 5'sd1 : -5'sd1) + (bits[371] ? 5'sd1 : -5'sd1) + (bits[385] ? 5'sd1 : -5'sd1) + (bits[387] ? -5'sd1 : 5'sd1) + (bits[401] ? -5'sd1 : 5'sd1) + (bits[402] ? 5'sd1 : -5'sd1) + (bits[403] ? 5'sd1 : -5'sd1);
387: raw_field = (bits[370] ? 5'sd1 : -5'sd1) + (bits[371] ? 5'sd1 : -5'sd1) + (bits[372] ? -5'sd1 : 5'sd1) + (bits[386] ? -5'sd1 : 5'sd1) + (bits[388] ? -5'sd1 : 5'sd1) + (bits[402] ? -5'sd1 : 5'sd1) + (bits[403] ? -5'sd1 : 5'sd1) + (bits[404] ? -5'sd1 : 5'sd1);
388: raw_field = (bits[371] ? -5'sd1 : 5'sd1) + (bits[372] ? 5'sd1 : -5'sd1) + (bits[373] ? -5'sd1 : 5'sd1) + (bits[387] ? -5'sd1 : 5'sd1) + (bits[389] ? 5'sd1 : -5'sd1) + (bits[403] ? 5'sd1 : -5'sd1) + (bits[404] ? -5'sd1 : 5'sd1) + (bits[405] ? 5'sd1 : -5'sd1);
389: raw_field = (bits[372] ? -5'sd1 : 5'sd1) + (bits[373] ? -5'sd1 : 5'sd1) + (bits[374] ? -5'sd1 : 5'sd1) + (bits[388] ? 5'sd1 : -5'sd1) + (bits[390] ? -5'sd1 : 5'sd1) + (bits[404] ? -5'sd1 : 5'sd1) + (bits[405] ? 5'sd1 : -5'sd1) + (bits[406] ? 5'sd1 : -5'sd1);
390: raw_field = (bits[373] ? -5'sd1 : 5'sd1) + (bits[374] ? -5'sd1 : 5'sd1) + (bits[375] ? 5'sd1 : -5'sd1) + (bits[389] ? -5'sd1 : 5'sd1) + (bits[391] ? 5'sd1 : -5'sd1) + (bits[405] ? -5'sd1 : 5'sd1) + (bits[406] ? -5'sd1 : 5'sd1) + (bits[407] ? -5'sd1 : 5'sd1);
391: raw_field = (bits[374] ? 5'sd1 : -5'sd1) + (bits[375] ? 5'sd1 : -5'sd1) + (bits[376] ? 5'sd1 : -5'sd1) + (bits[390] ? 5'sd1 : -5'sd1) + (bits[392] ? -5'sd1 : 5'sd1) + (bits[406] ? 5'sd1 : -5'sd1) + (bits[407] ? -5'sd1 : 5'sd1) + (bits[408] ? -5'sd1 : 5'sd1);
392: raw_field = (bits[375] ? 5'sd1 : -5'sd1) + (bits[376] ? -5'sd1 : 5'sd1) + (bits[377] ? 5'sd1 : -5'sd1) + (bits[391] ? -5'sd1 : 5'sd1) + (bits[393] ? -5'sd1 : 5'sd1) + (bits[407] ? 5'sd1 : -5'sd1) + (bits[408] ? -5'sd1 : 5'sd1) + (bits[409] ? -5'sd1 : 5'sd1);
393: raw_field = (bits[376] ? 5'sd1 : -5'sd1) + (bits[377] ? -5'sd1 : 5'sd1) + (bits[378] ? 5'sd1 : -5'sd1) + (bits[392] ? -5'sd1 : 5'sd1) + (bits[394] ? -5'sd1 : 5'sd1) + (bits[408] ? -5'sd1 : 5'sd1) + (bits[409] ? -5'sd1 : 5'sd1) + (bits[410] ? 5'sd1 : -5'sd1);
394: raw_field = (bits[377] ? -5'sd1 : 5'sd1) + (bits[378] ? -5'sd1 : 5'sd1) + (bits[379] ? 5'sd1 : -5'sd1) + (bits[393] ? -5'sd1 : 5'sd1) + (bits[395] ? -5'sd1 : 5'sd1) + (bits[409] ? 5'sd1 : -5'sd1) + (bits[410] ? -5'sd1 : 5'sd1) + (bits[411] ? -5'sd1 : 5'sd1);
395: raw_field = (bits[378] ? 5'sd1 : -5'sd1) + (bits[379] ? -5'sd1 : 5'sd1) + (bits[380] ? -5'sd1 : 5'sd1) + (bits[394] ? -5'sd1 : 5'sd1) + (bits[396] ? -5'sd1 : 5'sd1) + (bits[410] ? 5'sd1 : -5'sd1) + (bits[411] ? -5'sd1 : 5'sd1) + (bits[412] ? -5'sd1 : 5'sd1);
396: raw_field = (bits[379] ? -5'sd1 : 5'sd1) + (bits[380] ? -5'sd1 : 5'sd1) + (bits[381] ? 5'sd1 : -5'sd1) + (bits[395] ? -5'sd1 : 5'sd1) + (bits[397] ? -5'sd1 : 5'sd1) + (bits[411] ? -5'sd1 : 5'sd1) + (bits[412] ? -5'sd1 : 5'sd1) + (bits[413] ? 5'sd1 : -5'sd1);
397: raw_field = (bits[380] ? 5'sd1 : -5'sd1) + (bits[381] ? 5'sd1 : -5'sd1) + (bits[382] ? -5'sd1 : 5'sd1) + (bits[396] ? -5'sd1 : 5'sd1) + (bits[398] ? -5'sd1 : 5'sd1) + (bits[412] ? 5'sd1 : -5'sd1) + (bits[413] ? 5'sd1 : -5'sd1) + (bits[414] ? 5'sd1 : -5'sd1);
398: raw_field = (bits[381] ? 5'sd1 : -5'sd1) + (bits[382] ? 5'sd1 : -5'sd1) + (bits[383] ? 5'sd1 : -5'sd1) + (bits[397] ? -5'sd1 : 5'sd1) + (bits[399] ? 5'sd1 : -5'sd1) + (bits[413] ? 5'sd1 : -5'sd1) + (bits[414] ? -5'sd1 : 5'sd1) + (bits[415] ? -5'sd1 : 5'sd1);
399: raw_field = (bits[382] ? -5'sd1 : 5'sd1) + (bits[383] ? -5'sd1 : 5'sd1) + (bits[398] ? 5'sd1 : -5'sd1) + (bits[414] ? 5'sd1 : -5'sd1) + (bits[415] ? 5'sd1 : -5'sd1);
400: raw_field = (bits[384] ? -5'sd1 : 5'sd1) + (bits[385] ? 5'sd1 : -5'sd1) + (bits[401] ? -5'sd1 : 5'sd1) + (bits[416] ? -5'sd1 : 5'sd1) + (bits[417] ? -5'sd1 : 5'sd1);
401: raw_field = (bits[384] ? 5'sd1 : -5'sd1) + (bits[385] ? 5'sd1 : -5'sd1) + (bits[386] ? -5'sd1 : 5'sd1) + (bits[400] ? -5'sd1 : 5'sd1) + (bits[402] ? -5'sd1 : 5'sd1) + (bits[416] ? -5'sd1 : 5'sd1) + (bits[417] ? 5'sd1 : -5'sd1) + (bits[418] ? -5'sd1 : 5'sd1);
402: raw_field = (bits[385] ? 5'sd1 : -5'sd1) + (bits[386] ? 5'sd1 : -5'sd1) + (bits[387] ? -5'sd1 : 5'sd1) + (bits[401] ? -5'sd1 : 5'sd1) + (bits[403] ? 5'sd1 : -5'sd1) + (bits[417] ? 5'sd1 : -5'sd1) + (bits[418] ? -5'sd1 : 5'sd1) + (bits[419] ? 5'sd1 : -5'sd1);
403: raw_field = (bits[386] ? 5'sd1 : -5'sd1) + (bits[387] ? -5'sd1 : 5'sd1) + (bits[388] ? 5'sd1 : -5'sd1) + (bits[402] ? 5'sd1 : -5'sd1) + (bits[404] ? -5'sd1 : 5'sd1) + (bits[418] ? -5'sd1 : 5'sd1) + (bits[419] ? 5'sd1 : -5'sd1) + (bits[420] ? -5'sd1 : 5'sd1);
404: raw_field = (bits[387] ? -5'sd1 : 5'sd1) + (bits[388] ? -5'sd1 : 5'sd1) + (bits[389] ? -5'sd1 : 5'sd1) + (bits[403] ? -5'sd1 : 5'sd1) + (bits[405] ? 5'sd1 : -5'sd1) + (bits[419] ? 5'sd1 : -5'sd1) + (bits[420] ? -5'sd1 : 5'sd1) + (bits[421] ? -5'sd1 : 5'sd1);
405: raw_field = (bits[388] ? 5'sd1 : -5'sd1) + (bits[389] ? 5'sd1 : -5'sd1) + (bits[390] ? -5'sd1 : 5'sd1) + (bits[404] ? 5'sd1 : -5'sd1) + (bits[406] ? 5'sd1 : -5'sd1) + (bits[420] ? 5'sd1 : -5'sd1) + (bits[421] ? -5'sd1 : 5'sd1) + (bits[422] ? -5'sd1 : 5'sd1);
406: raw_field = (bits[389] ? 5'sd1 : -5'sd1) + (bits[390] ? -5'sd1 : 5'sd1) + (bits[391] ? 5'sd1 : -5'sd1) + (bits[405] ? 5'sd1 : -5'sd1) + (bits[407] ? -5'sd1 : 5'sd1) + (bits[421] ? -5'sd1 : 5'sd1) + (bits[422] ? 5'sd1 : -5'sd1) + (bits[423] ? 5'sd1 : -5'sd1);
407: raw_field = (bits[390] ? -5'sd1 : 5'sd1) + (bits[391] ? -5'sd1 : 5'sd1) + (bits[392] ? 5'sd1 : -5'sd1) + (bits[406] ? -5'sd1 : 5'sd1) + (bits[408] ? 5'sd1 : -5'sd1) + (bits[422] ? 5'sd1 : -5'sd1) + (bits[423] ? -5'sd1 : 5'sd1) + (bits[424] ? -5'sd1 : 5'sd1);
408: raw_field = (bits[391] ? -5'sd1 : 5'sd1) + (bits[392] ? -5'sd1 : 5'sd1) + (bits[393] ? -5'sd1 : 5'sd1) + (bits[407] ? 5'sd1 : -5'sd1) + (bits[409] ? 5'sd1 : -5'sd1) + (bits[423] ? -5'sd1 : 5'sd1) + (bits[424] ? -5'sd1 : 5'sd1) + (bits[425] ? -5'sd1 : 5'sd1);
409: raw_field = (bits[392] ? -5'sd1 : 5'sd1) + (bits[393] ? -5'sd1 : 5'sd1) + (bits[394] ? 5'sd1 : -5'sd1) + (bits[408] ? 5'sd1 : -5'sd1) + (bits[410] ? -5'sd1 : 5'sd1) + (bits[424] ? -5'sd1 : 5'sd1) + (bits[425] ? 5'sd1 : -5'sd1) + (bits[426] ? -5'sd1 : 5'sd1);
410: raw_field = (bits[393] ? 5'sd1 : -5'sd1) + (bits[394] ? -5'sd1 : 5'sd1) + (bits[395] ? 5'sd1 : -5'sd1) + (bits[409] ? -5'sd1 : 5'sd1) + (bits[411] ? 5'sd1 : -5'sd1) + (bits[425] ? -5'sd1 : 5'sd1) + (bits[426] ? -5'sd1 : 5'sd1) + (bits[427] ? 5'sd1 : -5'sd1);
411: raw_field = (bits[394] ? -5'sd1 : 5'sd1) + (bits[395] ? -5'sd1 : 5'sd1) + (bits[396] ? -5'sd1 : 5'sd1) + (bits[410] ? 5'sd1 : -5'sd1) + (bits[412] ? 5'sd1 : -5'sd1) + (bits[426] ? -5'sd1 : 5'sd1) + (bits[427] ? -5'sd1 : 5'sd1) + (bits[428] ? 5'sd1 : -5'sd1);
412: raw_field = (bits[395] ? -5'sd1 : 5'sd1) + (bits[396] ? -5'sd1 : 5'sd1) + (bits[397] ? 5'sd1 : -5'sd1) + (bits[411] ? 5'sd1 : -5'sd1) + (bits[413] ? -5'sd1 : 5'sd1) + (bits[427] ? 5'sd1 : -5'sd1) + (bits[428] ? -5'sd1 : 5'sd1) + (bits[429] ? -5'sd1 : 5'sd1);
413: raw_field = (bits[396] ? 5'sd1 : -5'sd1) + (bits[397] ? 5'sd1 : -5'sd1) + (bits[398] ? 5'sd1 : -5'sd1) + (bits[412] ? -5'sd1 : 5'sd1) + (bits[414] ? -5'sd1 : 5'sd1) + (bits[428] ? -5'sd1 : 5'sd1) + (bits[429] ? -5'sd1 : 5'sd1) + (bits[430] ? -5'sd1 : 5'sd1);
414: raw_field = (bits[397] ? 5'sd1 : -5'sd1) + (bits[398] ? -5'sd1 : 5'sd1) + (bits[399] ? 5'sd1 : -5'sd1) + (bits[413] ? -5'sd1 : 5'sd1) + (bits[415] ? 5'sd1 : -5'sd1) + (bits[429] ? -5'sd1 : 5'sd1) + (bits[430] ? 5'sd1 : -5'sd1) + (bits[431] ? -5'sd1 : 5'sd1);
415: raw_field = (bits[398] ? -5'sd1 : 5'sd1) + (bits[399] ? 5'sd1 : -5'sd1) + (bits[414] ? 5'sd1 : -5'sd1) + (bits[430] ? 5'sd1 : -5'sd1) + (bits[431] ? -5'sd1 : 5'sd1);
416: raw_field = (bits[400] ? -5'sd1 : 5'sd1) + (bits[401] ? -5'sd1 : 5'sd1) + (bits[417] ? -5'sd1 : 5'sd1) + (bits[432] ? -5'sd1 : 5'sd1) + (bits[433] ? 5'sd1 : -5'sd1);
417: raw_field = (bits[400] ? -5'sd1 : 5'sd1) + (bits[401] ? 5'sd1 : -5'sd1) + (bits[402] ? 5'sd1 : -5'sd1) + (bits[416] ? -5'sd1 : 5'sd1) + (bits[418] ? 5'sd1 : -5'sd1) + (bits[432] ? -5'sd1 : 5'sd1) + (bits[433] ? -5'sd1 : 5'sd1) + (bits[434] ? -5'sd1 : 5'sd1);
418: raw_field = (bits[401] ? -5'sd1 : 5'sd1) + (bits[402] ? -5'sd1 : 5'sd1) + (bits[403] ? -5'sd1 : 5'sd1) + (bits[417] ? 5'sd1 : -5'sd1) + (bits[419] ? -5'sd1 : 5'sd1) + (bits[433] ? -5'sd1 : 5'sd1) + (bits[434] ? -5'sd1 : 5'sd1) + (bits[435] ? -5'sd1 : 5'sd1);
419: raw_field = (bits[402] ? 5'sd1 : -5'sd1) + (bits[403] ? 5'sd1 : -5'sd1) + (bits[404] ? 5'sd1 : -5'sd1) + (bits[418] ? -5'sd1 : 5'sd1) + (bits[420] ? 5'sd1 : -5'sd1) + (bits[434] ? -5'sd1 : 5'sd1) + (bits[435] ? -5'sd1 : 5'sd1) + (bits[436] ? 5'sd1 : -5'sd1);
420: raw_field = (bits[403] ? -5'sd1 : 5'sd1) + (bits[404] ? -5'sd1 : 5'sd1) + (bits[405] ? 5'sd1 : -5'sd1) + (bits[419] ? 5'sd1 : -5'sd1) + (bits[421] ? -5'sd1 : 5'sd1) + (bits[435] ? 5'sd1 : -5'sd1) + (bits[436] ? -5'sd1 : 5'sd1) + (bits[437] ? -5'sd1 : 5'sd1);
421: raw_field = (bits[404] ? -5'sd1 : 5'sd1) + (bits[405] ? -5'sd1 : 5'sd1) + (bits[406] ? -5'sd1 : 5'sd1) + (bits[420] ? -5'sd1 : 5'sd1) + (bits[422] ? 5'sd1 : -5'sd1) + (bits[436] ? -5'sd1 : 5'sd1) + (bits[437] ? 5'sd1 : -5'sd1) + (bits[438] ? 5'sd1 : -5'sd1);
422: raw_field = (bits[405] ? -5'sd1 : 5'sd1) + (bits[406] ? 5'sd1 : -5'sd1) + (bits[407] ? 5'sd1 : -5'sd1) + (bits[421] ? 5'sd1 : -5'sd1) + (bits[423] ? -5'sd1 : 5'sd1) + (bits[437] ? 5'sd1 : -5'sd1) + (bits[438] ? 5'sd1 : -5'sd1) + (bits[439] ? -5'sd1 : 5'sd1);
423: raw_field = (bits[406] ? 5'sd1 : -5'sd1) + (bits[407] ? -5'sd1 : 5'sd1) + (bits[408] ? -5'sd1 : 5'sd1) + (bits[422] ? -5'sd1 : 5'sd1) + (bits[424] ? 5'sd1 : -5'sd1) + (bits[438] ? 5'sd1 : -5'sd1) + (bits[439] ? -5'sd1 : 5'sd1) + (bits[440] ? -5'sd1 : 5'sd1);
424: raw_field = (bits[407] ? -5'sd1 : 5'sd1) + (bits[408] ? -5'sd1 : 5'sd1) + (bits[409] ? -5'sd1 : 5'sd1) + (bits[423] ? 5'sd1 : -5'sd1) + (bits[425] ? -5'sd1 : 5'sd1) + (bits[439] ? 5'sd1 : -5'sd1) + (bits[440] ? 5'sd1 : -5'sd1) + (bits[441] ? -5'sd1 : 5'sd1);
425: raw_field = (bits[408] ? -5'sd1 : 5'sd1) + (bits[409] ? 5'sd1 : -5'sd1) + (bits[410] ? -5'sd1 : 5'sd1) + (bits[424] ? -5'sd1 : 5'sd1) + (bits[426] ? 5'sd1 : -5'sd1) + (bits[440] ? -5'sd1 : 5'sd1) + (bits[441] ? 5'sd1 : -5'sd1) + (bits[442] ? 5'sd1 : -5'sd1);
426: raw_field = (bits[409] ? -5'sd1 : 5'sd1) + (bits[410] ? -5'sd1 : 5'sd1) + (bits[411] ? -5'sd1 : 5'sd1) + (bits[425] ? 5'sd1 : -5'sd1) + (bits[427] ? -5'sd1 : 5'sd1) + (bits[441] ? 5'sd1 : -5'sd1) + (bits[442] ? -5'sd1 : 5'sd1) + (bits[443] ? -5'sd1 : 5'sd1);
427: raw_field = (bits[410] ? 5'sd1 : -5'sd1) + (bits[411] ? -5'sd1 : 5'sd1) + (bits[412] ? 5'sd1 : -5'sd1) + (bits[426] ? -5'sd1 : 5'sd1) + (bits[428] ? -5'sd1 : 5'sd1) + (bits[442] ? 5'sd1 : -5'sd1) + (bits[443] ? 5'sd1 : -5'sd1) + (bits[444] ? -5'sd1 : 5'sd1);
428: raw_field = (bits[411] ? 5'sd1 : -5'sd1) + (bits[412] ? -5'sd1 : 5'sd1) + (bits[413] ? -5'sd1 : 5'sd1) + (bits[427] ? -5'sd1 : 5'sd1) + (bits[429] ? 5'sd1 : -5'sd1) + (bits[443] ? -5'sd1 : 5'sd1) + (bits[444] ? -5'sd1 : 5'sd1) + (bits[445] ? -5'sd1 : 5'sd1);
429: raw_field = (bits[412] ? -5'sd1 : 5'sd1) + (bits[413] ? -5'sd1 : 5'sd1) + (bits[414] ? -5'sd1 : 5'sd1) + (bits[428] ? 5'sd1 : -5'sd1) + (bits[430] ? -5'sd1 : 5'sd1) + (bits[444] ? -5'sd1 : 5'sd1) + (bits[445] ? 5'sd1 : -5'sd1) + (bits[446] ? -5'sd1 : 5'sd1);
430: raw_field = (bits[413] ? -5'sd1 : 5'sd1) + (bits[414] ? 5'sd1 : -5'sd1) + (bits[415] ? 5'sd1 : -5'sd1) + (bits[429] ? -5'sd1 : 5'sd1) + (bits[431] ? -5'sd1 : 5'sd1) + (bits[445] ? -5'sd1 : 5'sd1) + (bits[446] ? 5'sd1 : -5'sd1) + (bits[447] ? -5'sd1 : 5'sd1);
431: raw_field = (bits[414] ? -5'sd1 : 5'sd1) + (bits[415] ? -5'sd1 : 5'sd1) + (bits[430] ? -5'sd1 : 5'sd1) + (bits[446] ? 5'sd1 : -5'sd1) + (bits[447] ? -5'sd1 : 5'sd1);
432: raw_field = (bits[416] ? -5'sd1 : 5'sd1) + (bits[417] ? -5'sd1 : 5'sd1) + (bits[433] ? 5'sd1 : -5'sd1) + (bits[448] ? 5'sd1 : -5'sd1) + (bits[449] ? -5'sd1 : 5'sd1);
433: raw_field = (bits[416] ? 5'sd1 : -5'sd1) + (bits[417] ? -5'sd1 : 5'sd1) + (bits[418] ? -5'sd1 : 5'sd1) + (bits[432] ? 5'sd1 : -5'sd1) + (bits[434] ? -5'sd1 : 5'sd1) + (bits[448] ? -5'sd1 : 5'sd1) + (bits[449] ? 5'sd1 : -5'sd1) + (bits[450] ? -5'sd1 : 5'sd1);
434: raw_field = (bits[417] ? -5'sd1 : 5'sd1) + (bits[418] ? -5'sd1 : 5'sd1) + (bits[419] ? -5'sd1 : 5'sd1) + (bits[433] ? -5'sd1 : 5'sd1) + (bits[435] ? -5'sd1 : 5'sd1) + (bits[449] ? -5'sd1 : 5'sd1) + (bits[450] ? -5'sd1 : 5'sd1) + (bits[451] ? 5'sd1 : -5'sd1);
435: raw_field = (bits[418] ? -5'sd1 : 5'sd1) + (bits[419] ? -5'sd1 : 5'sd1) + (bits[420] ? 5'sd1 : -5'sd1) + (bits[434] ? -5'sd1 : 5'sd1) + (bits[436] ? -5'sd1 : 5'sd1) + (bits[450] ? 5'sd1 : -5'sd1) + (bits[451] ? 5'sd1 : -5'sd1) + (bits[452] ? -5'sd1 : 5'sd1);
436: raw_field = (bits[419] ? 5'sd1 : -5'sd1) + (bits[420] ? -5'sd1 : 5'sd1) + (bits[421] ? -5'sd1 : 5'sd1) + (bits[435] ? -5'sd1 : 5'sd1) + (bits[437] ? -5'sd1 : 5'sd1) + (bits[451] ? -5'sd1 : 5'sd1) + (bits[452] ? 5'sd1 : -5'sd1) + (bits[453] ? -5'sd1 : 5'sd1);
437: raw_field = (bits[420] ? -5'sd1 : 5'sd1) + (bits[421] ? 5'sd1 : -5'sd1) + (bits[422] ? 5'sd1 : -5'sd1) + (bits[436] ? -5'sd1 : 5'sd1) + (bits[438] ? -5'sd1 : 5'sd1) + (bits[452] ? 5'sd1 : -5'sd1) + (bits[453] ? -5'sd1 : 5'sd1) + (bits[454] ? 5'sd1 : -5'sd1);
438: raw_field = (bits[421] ? 5'sd1 : -5'sd1) + (bits[422] ? 5'sd1 : -5'sd1) + (bits[423] ? 5'sd1 : -5'sd1) + (bits[437] ? -5'sd1 : 5'sd1) + (bits[439] ? -5'sd1 : 5'sd1) + (bits[453] ? -5'sd1 : 5'sd1) + (bits[454] ? 5'sd1 : -5'sd1) + (bits[455] ? -5'sd1 : 5'sd1);
439: raw_field = (bits[422] ? -5'sd1 : 5'sd1) + (bits[423] ? -5'sd1 : 5'sd1) + (bits[424] ? 5'sd1 : -5'sd1) + (bits[438] ? -5'sd1 : 5'sd1) + (bits[440] ? 5'sd1 : -5'sd1) + (bits[454] ? -5'sd1 : 5'sd1) + (bits[455] ? 5'sd1 : -5'sd1) + (bits[456] ? -5'sd1 : 5'sd1);
440: raw_field = (bits[423] ? -5'sd1 : 5'sd1) + (bits[424] ? 5'sd1 : -5'sd1) + (bits[425] ? -5'sd1 : 5'sd1) + (bits[439] ? 5'sd1 : -5'sd1) + (bits[441] ? -5'sd1 : 5'sd1) + (bits[455] ? -5'sd1 : 5'sd1) + (bits[456] ? 5'sd1 : -5'sd1) + (bits[457] ? -5'sd1 : 5'sd1);
441: raw_field = (bits[424] ? -5'sd1 : 5'sd1) + (bits[425] ? 5'sd1 : -5'sd1) + (bits[426] ? 5'sd1 : -5'sd1) + (bits[440] ? -5'sd1 : 5'sd1) + (bits[442] ? -5'sd1 : 5'sd1) + (bits[456] ? 5'sd1 : -5'sd1) + (bits[457] ? 5'sd1 : -5'sd1) + (bits[458] ? 5'sd1 : -5'sd1);
442: raw_field = (bits[425] ? 5'sd1 : -5'sd1) + (bits[426] ? -5'sd1 : 5'sd1) + (bits[427] ? 5'sd1 : -5'sd1) + (bits[441] ? -5'sd1 : 5'sd1) + (bits[443] ? 5'sd1 : -5'sd1) + (bits[457] ? 5'sd1 : -5'sd1) + (bits[458] ? 5'sd1 : -5'sd1) + (bits[459] ? 5'sd1 : -5'sd1);
443: raw_field = (bits[426] ? -5'sd1 : 5'sd1) + (bits[427] ? 5'sd1 : -5'sd1) + (bits[428] ? -5'sd1 : 5'sd1) + (bits[442] ? 5'sd1 : -5'sd1) + (bits[444] ? -5'sd1 : 5'sd1) + (bits[458] ? 5'sd1 : -5'sd1) + (bits[459] ? 5'sd1 : -5'sd1) + (bits[460] ? 5'sd1 : -5'sd1);
444: raw_field = (bits[427] ? -5'sd1 : 5'sd1) + (bits[428] ? -5'sd1 : 5'sd1) + (bits[429] ? -5'sd1 : 5'sd1) + (bits[443] ? -5'sd1 : 5'sd1) + (bits[445] ? 5'sd1 : -5'sd1) + (bits[459] ? 5'sd1 : -5'sd1) + (bits[460] ? 5'sd1 : -5'sd1) + (bits[461] ? 5'sd1 : -5'sd1);
445: raw_field = (bits[428] ? -5'sd1 : 5'sd1) + (bits[429] ? 5'sd1 : -5'sd1) + (bits[430] ? -5'sd1 : 5'sd1) + (bits[444] ? 5'sd1 : -5'sd1) + (bits[446] ? -5'sd1 : 5'sd1) + (bits[460] ? -5'sd1 : 5'sd1) + (bits[461] ? -5'sd1 : 5'sd1) + (bits[462] ? -5'sd1 : 5'sd1);
446: raw_field = (bits[429] ? -5'sd1 : 5'sd1) + (bits[430] ? 5'sd1 : -5'sd1) + (bits[431] ? 5'sd1 : -5'sd1) + (bits[445] ? -5'sd1 : 5'sd1) + (bits[447] ? 5'sd1 : -5'sd1) + (bits[461] ? -5'sd1 : 5'sd1) + (bits[462] ? -5'sd1 : 5'sd1) + (bits[463] ? 5'sd1 : -5'sd1);
447: raw_field = (bits[430] ? -5'sd1 : 5'sd1) + (bits[431] ? -5'sd1 : 5'sd1) + (bits[446] ? 5'sd1 : -5'sd1) + (bits[462] ? 5'sd1 : -5'sd1) + (bits[463] ? -5'sd1 : 5'sd1);
448: raw_field = (bits[432] ? 5'sd1 : -5'sd1) + (bits[433] ? -5'sd1 : 5'sd1) + (bits[449] ? 5'sd1 : -5'sd1) + (bits[464] ? 5'sd1 : -5'sd1) + (bits[465] ? 5'sd1 : -5'sd1);
449: raw_field = (bits[432] ? -5'sd1 : 5'sd1) + (bits[433] ? 5'sd1 : -5'sd1) + (bits[434] ? -5'sd1 : 5'sd1) + (bits[448] ? 5'sd1 : -5'sd1) + (bits[450] ? 5'sd1 : -5'sd1) + (bits[464] ? -5'sd1 : 5'sd1) + (bits[465] ? 5'sd1 : -5'sd1) + (bits[466] ? 5'sd1 : -5'sd1);
450: raw_field = (bits[433] ? -5'sd1 : 5'sd1) + (bits[434] ? -5'sd1 : 5'sd1) + (bits[435] ? 5'sd1 : -5'sd1) + (bits[449] ? 5'sd1 : -5'sd1) + (bits[451] ? -5'sd1 : 5'sd1) + (bits[465] ? 5'sd1 : -5'sd1) + (bits[466] ? -5'sd1 : 5'sd1) + (bits[467] ? -5'sd1 : 5'sd1);
451: raw_field = (bits[434] ? 5'sd1 : -5'sd1) + (bits[435] ? 5'sd1 : -5'sd1) + (bits[436] ? -5'sd1 : 5'sd1) + (bits[450] ? -5'sd1 : 5'sd1) + (bits[452] ? -5'sd1 : 5'sd1) + (bits[466] ? 5'sd1 : -5'sd1) + (bits[467] ? -5'sd1 : 5'sd1) + (bits[468] ? 5'sd1 : -5'sd1);
452: raw_field = (bits[435] ? -5'sd1 : 5'sd1) + (bits[436] ? 5'sd1 : -5'sd1) + (bits[437] ? 5'sd1 : -5'sd1) + (bits[451] ? -5'sd1 : 5'sd1) + (bits[453] ? 5'sd1 : -5'sd1) + (bits[467] ? 5'sd1 : -5'sd1) + (bits[468] ? 5'sd1 : -5'sd1) + (bits[469] ? -5'sd1 : 5'sd1);
453: raw_field = (bits[436] ? -5'sd1 : 5'sd1) + (bits[437] ? -5'sd1 : 5'sd1) + (bits[438] ? -5'sd1 : 5'sd1) + (bits[452] ? 5'sd1 : -5'sd1) + (bits[454] ? -5'sd1 : 5'sd1) + (bits[468] ? -5'sd1 : 5'sd1) + (bits[469] ? 5'sd1 : -5'sd1) + (bits[470] ? -5'sd1 : 5'sd1);
454: raw_field = (bits[437] ? 5'sd1 : -5'sd1) + (bits[438] ? 5'sd1 : -5'sd1) + (bits[439] ? -5'sd1 : 5'sd1) + (bits[453] ? -5'sd1 : 5'sd1) + (bits[455] ? 5'sd1 : -5'sd1) + (bits[469] ? -5'sd1 : 5'sd1) + (bits[470] ? -5'sd1 : 5'sd1) + (bits[471] ? -5'sd1 : 5'sd1);
455: raw_field = (bits[438] ? -5'sd1 : 5'sd1) + (bits[439] ? 5'sd1 : -5'sd1) + (bits[440] ? -5'sd1 : 5'sd1) + (bits[454] ? 5'sd1 : -5'sd1) + (bits[456] ? -5'sd1 : 5'sd1) + (bits[470] ? -5'sd1 : 5'sd1) + (bits[471] ? -5'sd1 : 5'sd1) + (bits[472] ? -5'sd1 : 5'sd1);
456: raw_field = (bits[439] ? -5'sd1 : 5'sd1) + (bits[440] ? 5'sd1 : -5'sd1) + (bits[441] ? 5'sd1 : -5'sd1) + (bits[455] ? -5'sd1 : 5'sd1) + (bits[457] ? 5'sd1 : -5'sd1) + (bits[471] ? -5'sd1 : 5'sd1) + (bits[472] ? -5'sd1 : 5'sd1) + (bits[473] ? 5'sd1 : -5'sd1);
457: raw_field = (bits[440] ? -5'sd1 : 5'sd1) + (bits[441] ? 5'sd1 : -5'sd1) + (bits[442] ? 5'sd1 : -5'sd1) + (bits[456] ? 5'sd1 : -5'sd1) + (bits[458] ? 5'sd1 : -5'sd1) + (bits[472] ? -5'sd1 : 5'sd1) + (bits[473] ? 5'sd1 : -5'sd1) + (bits[474] ? -5'sd1 : 5'sd1);
458: raw_field = (bits[441] ? 5'sd1 : -5'sd1) + (bits[442] ? 5'sd1 : -5'sd1) + (bits[443] ? 5'sd1 : -5'sd1) + (bits[457] ? 5'sd1 : -5'sd1) + (bits[459] ? 5'sd1 : -5'sd1) + (bits[473] ? -5'sd1 : 5'sd1) + (bits[474] ? -5'sd1 : 5'sd1) + (bits[475] ? 5'sd1 : -5'sd1);
459: raw_field = (bits[442] ? 5'sd1 : -5'sd1) + (bits[443] ? 5'sd1 : -5'sd1) + (bits[444] ? 5'sd1 : -5'sd1) + (bits[458] ? 5'sd1 : -5'sd1) + (bits[460] ? 5'sd1 : -5'sd1) + (bits[474] ? 5'sd1 : -5'sd1) + (bits[475] ? -5'sd1 : 5'sd1) + (bits[476] ? -5'sd1 : 5'sd1);
460: raw_field = (bits[443] ? 5'sd1 : -5'sd1) + (bits[444] ? 5'sd1 : -5'sd1) + (bits[445] ? -5'sd1 : 5'sd1) + (bits[459] ? 5'sd1 : -5'sd1) + (bits[461] ? 5'sd1 : -5'sd1) + (bits[475] ? 5'sd1 : -5'sd1) + (bits[476] ? -5'sd1 : 5'sd1) + (bits[477] ? -5'sd1 : 5'sd1);
461: raw_field = (bits[444] ? 5'sd1 : -5'sd1) + (bits[445] ? -5'sd1 : 5'sd1) + (bits[446] ? -5'sd1 : 5'sd1) + (bits[460] ? 5'sd1 : -5'sd1) + (bits[462] ? -5'sd1 : 5'sd1) + (bits[476] ? 5'sd1 : -5'sd1) + (bits[477] ? 5'sd1 : -5'sd1) + (bits[478] ? 5'sd1 : -5'sd1);
462: raw_field = (bits[445] ? -5'sd1 : 5'sd1) + (bits[446] ? -5'sd1 : 5'sd1) + (bits[447] ? 5'sd1 : -5'sd1) + (bits[461] ? -5'sd1 : 5'sd1) + (bits[463] ? 5'sd1 : -5'sd1) + (bits[477] ? -5'sd1 : 5'sd1) + (bits[478] ? 5'sd1 : -5'sd1) + (bits[479] ? 5'sd1 : -5'sd1);
463: raw_field = (bits[446] ? 5'sd1 : -5'sd1) + (bits[447] ? -5'sd1 : 5'sd1) + (bits[462] ? 5'sd1 : -5'sd1) + (bits[478] ? 5'sd1 : -5'sd1) + (bits[479] ? -5'sd1 : 5'sd1);
464: raw_field = (bits[448] ? 5'sd1 : -5'sd1) + (bits[449] ? -5'sd1 : 5'sd1) + (bits[465] ? -5'sd1 : 5'sd1) + (bits[480] ? 5'sd1 : -5'sd1) + (bits[481] ? 5'sd1 : -5'sd1);
465: raw_field = (bits[448] ? 5'sd1 : -5'sd1) + (bits[449] ? 5'sd1 : -5'sd1) + (bits[450] ? 5'sd1 : -5'sd1) + (bits[464] ? -5'sd1 : 5'sd1) + (bits[466] ? -5'sd1 : 5'sd1) + (bits[480] ? -5'sd1 : 5'sd1) + (bits[481] ? 5'sd1 : -5'sd1) + (bits[482] ? 5'sd1 : -5'sd1);
466: raw_field = (bits[449] ? 5'sd1 : -5'sd1) + (bits[450] ? -5'sd1 : 5'sd1) + (bits[451] ? 5'sd1 : -5'sd1) + (bits[465] ? -5'sd1 : 5'sd1) + (bits[467] ? -5'sd1 : 5'sd1) + (bits[481] ? 5'sd1 : -5'sd1) + (bits[482] ? -5'sd1 : 5'sd1) + (bits[483] ? -5'sd1 : 5'sd1);
467: raw_field = (bits[450] ? -5'sd1 : 5'sd1) + (bits[451] ? -5'sd1 : 5'sd1) + (bits[452] ? 5'sd1 : -5'sd1) + (bits[466] ? -5'sd1 : 5'sd1) + (bits[468] ? -5'sd1 : 5'sd1) + (bits[482] ? -5'sd1 : 5'sd1) + (bits[483] ? 5'sd1 : -5'sd1) + (bits[484] ? -5'sd1 : 5'sd1);
468: raw_field = (bits[451] ? 5'sd1 : -5'sd1) + (bits[452] ? 5'sd1 : -5'sd1) + (bits[453] ? -5'sd1 : 5'sd1) + (bits[467] ? -5'sd1 : 5'sd1) + (bits[469] ? 5'sd1 : -5'sd1) + (bits[483] ? -5'sd1 : 5'sd1) + (bits[484] ? 5'sd1 : -5'sd1) + (bits[485] ? 5'sd1 : -5'sd1);
469: raw_field = (bits[452] ? -5'sd1 : 5'sd1) + (bits[453] ? 5'sd1 : -5'sd1) + (bits[454] ? -5'sd1 : 5'sd1) + (bits[468] ? 5'sd1 : -5'sd1) + (bits[470] ? 5'sd1 : -5'sd1) + (bits[484] ? 5'sd1 : -5'sd1) + (bits[485] ? 5'sd1 : -5'sd1) + (bits[486] ? -5'sd1 : 5'sd1);
470: raw_field = (bits[453] ? -5'sd1 : 5'sd1) + (bits[454] ? -5'sd1 : 5'sd1) + (bits[455] ? -5'sd1 : 5'sd1) + (bits[469] ? 5'sd1 : -5'sd1) + (bits[471] ? 5'sd1 : -5'sd1) + (bits[485] ? -5'sd1 : 5'sd1) + (bits[486] ? -5'sd1 : 5'sd1) + (bits[487] ? -5'sd1 : 5'sd1);
471: raw_field = (bits[454] ? -5'sd1 : 5'sd1) + (bits[455] ? -5'sd1 : 5'sd1) + (bits[456] ? -5'sd1 : 5'sd1) + (bits[470] ? 5'sd1 : -5'sd1) + (bits[472] ? 5'sd1 : -5'sd1) + (bits[486] ? 5'sd1 : -5'sd1) + (bits[487] ? 5'sd1 : -5'sd1) + (bits[488] ? 5'sd1 : -5'sd1);
472: raw_field = (bits[455] ? -5'sd1 : 5'sd1) + (bits[456] ? -5'sd1 : 5'sd1) + (bits[457] ? -5'sd1 : 5'sd1) + (bits[471] ? 5'sd1 : -5'sd1) + (bits[473] ? 5'sd1 : -5'sd1) + (bits[487] ? -5'sd1 : 5'sd1) + (bits[488] ? -5'sd1 : 5'sd1) + (bits[489] ? 5'sd1 : -5'sd1);
473: raw_field = (bits[456] ? 5'sd1 : -5'sd1) + (bits[457] ? 5'sd1 : -5'sd1) + (bits[458] ? -5'sd1 : 5'sd1) + (bits[472] ? 5'sd1 : -5'sd1) + (bits[474] ? 5'sd1 : -5'sd1) + (bits[488] ? -5'sd1 : 5'sd1) + (bits[489] ? 5'sd1 : -5'sd1) + (bits[490] ? -5'sd1 : 5'sd1);
474: raw_field = (bits[457] ? -5'sd1 : 5'sd1) + (bits[458] ? -5'sd1 : 5'sd1) + (bits[459] ? 5'sd1 : -5'sd1) + (bits[473] ? 5'sd1 : -5'sd1) + (bits[475] ? 5'sd1 : -5'sd1) + (bits[489] ? -5'sd1 : 5'sd1) + (bits[490] ? 5'sd1 : -5'sd1) + (bits[491] ? -5'sd1 : 5'sd1);
475: raw_field = (bits[458] ? 5'sd1 : -5'sd1) + (bits[459] ? -5'sd1 : 5'sd1) + (bits[460] ? 5'sd1 : -5'sd1) + (bits[474] ? 5'sd1 : -5'sd1) + (bits[476] ? -5'sd1 : 5'sd1) + (bits[490] ? -5'sd1 : 5'sd1) + (bits[491] ? -5'sd1 : 5'sd1) + (bits[492] ? -5'sd1 : 5'sd1);
476: raw_field = (bits[459] ? -5'sd1 : 5'sd1) + (bits[460] ? -5'sd1 : 5'sd1) + (bits[461] ? 5'sd1 : -5'sd1) + (bits[475] ? -5'sd1 : 5'sd1) + (bits[477] ? -5'sd1 : 5'sd1) + (bits[491] ? 5'sd1 : -5'sd1) + (bits[492] ? 5'sd1 : -5'sd1) + (bits[493] ? 5'sd1 : -5'sd1);
477: raw_field = (bits[460] ? -5'sd1 : 5'sd1) + (bits[461] ? 5'sd1 : -5'sd1) + (bits[462] ? -5'sd1 : 5'sd1) + (bits[476] ? -5'sd1 : 5'sd1) + (bits[478] ? -5'sd1 : 5'sd1) + (bits[492] ? -5'sd1 : 5'sd1) + (bits[493] ? -5'sd1 : 5'sd1) + (bits[494] ? -5'sd1 : 5'sd1);
478: raw_field = (bits[461] ? 5'sd1 : -5'sd1) + (bits[462] ? 5'sd1 : -5'sd1) + (bits[463] ? 5'sd1 : -5'sd1) + (bits[477] ? -5'sd1 : 5'sd1) + (bits[479] ? -5'sd1 : 5'sd1) + (bits[493] ? -5'sd1 : 5'sd1) + (bits[494] ? -5'sd1 : 5'sd1) + (bits[495] ? -5'sd1 : 5'sd1);
479: raw_field = (bits[462] ? 5'sd1 : -5'sd1) + (bits[463] ? -5'sd1 : 5'sd1) + (bits[478] ? -5'sd1 : 5'sd1) + (bits[494] ? -5'sd1 : 5'sd1) + (bits[495] ? 5'sd1 : -5'sd1);
480: raw_field = (bits[464] ? 5'sd1 : -5'sd1) + (bits[465] ? -5'sd1 : 5'sd1) + (bits[481] ? 5'sd1 : -5'sd1) + (bits[496] ? -5'sd1 : 5'sd1) + (bits[497] ? -5'sd1 : 5'sd1);
481: raw_field = (bits[464] ? 5'sd1 : -5'sd1) + (bits[465] ? 5'sd1 : -5'sd1) + (bits[466] ? 5'sd1 : -5'sd1) + (bits[480] ? 5'sd1 : -5'sd1) + (bits[482] ? 5'sd1 : -5'sd1) + (bits[496] ? -5'sd1 : 5'sd1) + (bits[497] ? 5'sd1 : -5'sd1) + (bits[498] ? 5'sd1 : -5'sd1);
482: raw_field = (bits[465] ? 5'sd1 : -5'sd1) + (bits[466] ? -5'sd1 : 5'sd1) + (bits[467] ? -5'sd1 : 5'sd1) + (bits[481] ? 5'sd1 : -5'sd1) + (bits[483] ? -5'sd1 : 5'sd1) + (bits[497] ? 5'sd1 : -5'sd1) + (bits[498] ? -5'sd1 : 5'sd1) + (bits[499] ? 5'sd1 : -5'sd1);
483: raw_field = (bits[466] ? -5'sd1 : 5'sd1) + (bits[467] ? 5'sd1 : -5'sd1) + (bits[468] ? -5'sd1 : 5'sd1) + (bits[482] ? -5'sd1 : 5'sd1) + (bits[484] ? -5'sd1 : 5'sd1) + (bits[498] ? -5'sd1 : 5'sd1) + (bits[499] ? 5'sd1 : -5'sd1) + (bits[500] ? 5'sd1 : -5'sd1);
484: raw_field = (bits[467] ? -5'sd1 : 5'sd1) + (bits[468] ? 5'sd1 : -5'sd1) + (bits[469] ? 5'sd1 : -5'sd1) + (bits[483] ? -5'sd1 : 5'sd1) + (bits[485] ? -5'sd1 : 5'sd1) + (bits[499] ? 5'sd1 : -5'sd1) + (bits[500] ? -5'sd1 : 5'sd1) + (bits[501] ? 5'sd1 : -5'sd1);
485: raw_field = (bits[468] ? 5'sd1 : -5'sd1) + (bits[469] ? 5'sd1 : -5'sd1) + (bits[470] ? -5'sd1 : 5'sd1) + (bits[484] ? -5'sd1 : 5'sd1) + (bits[486] ? 5'sd1 : -5'sd1) + (bits[500] ? 5'sd1 : -5'sd1) + (bits[501] ? -5'sd1 : 5'sd1) + (bits[502] ? -5'sd1 : 5'sd1);
486: raw_field = (bits[469] ? -5'sd1 : 5'sd1) + (bits[470] ? -5'sd1 : 5'sd1) + (bits[471] ? 5'sd1 : -5'sd1) + (bits[485] ? 5'sd1 : -5'sd1) + (bits[487] ? 5'sd1 : -5'sd1) + (bits[501] ? 5'sd1 : -5'sd1) + (bits[502] ? -5'sd1 : 5'sd1) + (bits[503] ? 5'sd1 : -5'sd1);
487: raw_field = (bits[470] ? -5'sd1 : 5'sd1) + (bits[471] ? 5'sd1 : -5'sd1) + (bits[472] ? -5'sd1 : 5'sd1) + (bits[486] ? 5'sd1 : -5'sd1) + (bits[488] ? 5'sd1 : -5'sd1) + (bits[502] ? 5'sd1 : -5'sd1) + (bits[503] ? -5'sd1 : 5'sd1) + (bits[504] ? -5'sd1 : 5'sd1);
488: raw_field = (bits[471] ? 5'sd1 : -5'sd1) + (bits[472] ? -5'sd1 : 5'sd1) + (bits[473] ? -5'sd1 : 5'sd1) + (bits[487] ? 5'sd1 : -5'sd1) + (bits[489] ? 5'sd1 : -5'sd1) + (bits[503] ? 5'sd1 : -5'sd1) + (bits[504] ? -5'sd1 : 5'sd1) + (bits[505] ? 5'sd1 : -5'sd1);
489: raw_field = (bits[472] ? 5'sd1 : -5'sd1) + (bits[473] ? 5'sd1 : -5'sd1) + (bits[474] ? -5'sd1 : 5'sd1) + (bits[488] ? 5'sd1 : -5'sd1) + (bits[490] ? -5'sd1 : 5'sd1) + (bits[504] ? -5'sd1 : 5'sd1) + (bits[505] ? -5'sd1 : 5'sd1) + (bits[506] ? -5'sd1 : 5'sd1);
490: raw_field = (bits[473] ? -5'sd1 : 5'sd1) + (bits[474] ? 5'sd1 : -5'sd1) + (bits[475] ? -5'sd1 : 5'sd1) + (bits[489] ? -5'sd1 : 5'sd1) + (bits[491] ? 5'sd1 : -5'sd1) + (bits[505] ? -5'sd1 : 5'sd1) + (bits[506] ? 5'sd1 : -5'sd1) + (bits[507] ? 5'sd1 : -5'sd1);
491: raw_field = (bits[474] ? -5'sd1 : 5'sd1) + (bits[475] ? -5'sd1 : 5'sd1) + (bits[476] ? 5'sd1 : -5'sd1) + (bits[490] ? 5'sd1 : -5'sd1) + (bits[492] ? 5'sd1 : -5'sd1) + (bits[506] ? -5'sd1 : 5'sd1) + (bits[507] ? 5'sd1 : -5'sd1) + (bits[508] ? 5'sd1 : -5'sd1);
492: raw_field = (bits[475] ? -5'sd1 : 5'sd1) + (bits[476] ? 5'sd1 : -5'sd1) + (bits[477] ? -5'sd1 : 5'sd1) + (bits[491] ? 5'sd1 : -5'sd1) + (bits[493] ? -5'sd1 : 5'sd1) + (bits[507] ? -5'sd1 : 5'sd1) + (bits[508] ? -5'sd1 : 5'sd1) + (bits[509] ? -5'sd1 : 5'sd1);
493: raw_field = (bits[476] ? 5'sd1 : -5'sd1) + (bits[477] ? -5'sd1 : 5'sd1) + (bits[478] ? -5'sd1 : 5'sd1) + (bits[492] ? -5'sd1 : 5'sd1) + (bits[494] ? -5'sd1 : 5'sd1) + (bits[508] ? 5'sd1 : -5'sd1) + (bits[509] ? -5'sd1 : 5'sd1) + (bits[510] ? 5'sd1 : -5'sd1);
494: raw_field = (bits[477] ? -5'sd1 : 5'sd1) + (bits[478] ? -5'sd1 : 5'sd1) + (bits[479] ? -5'sd1 : 5'sd1) + (bits[493] ? -5'sd1 : 5'sd1) + (bits[495] ? -5'sd1 : 5'sd1) + (bits[509] ? -5'sd1 : 5'sd1) + (bits[510] ? 5'sd1 : -5'sd1) + (bits[511] ? -5'sd1 : 5'sd1);
495: raw_field = (bits[478] ? -5'sd1 : 5'sd1) + (bits[479] ? 5'sd1 : -5'sd1) + (bits[494] ? -5'sd1 : 5'sd1) + (bits[510] ? -5'sd1 : 5'sd1) + (bits[511] ? -5'sd1 : 5'sd1);
496: raw_field = (bits[480] ? -5'sd1 : 5'sd1) + (bits[481] ? -5'sd1 : 5'sd1) + (bits[497] ? -5'sd1 : 5'sd1);
497: raw_field = (bits[480] ? -5'sd1 : 5'sd1) + (bits[481] ? 5'sd1 : -5'sd1) + (bits[482] ? 5'sd1 : -5'sd1) + (bits[496] ? -5'sd1 : 5'sd1) + (bits[498] ? 5'sd1 : -5'sd1);
498: raw_field = (bits[481] ? 5'sd1 : -5'sd1) + (bits[482] ? -5'sd1 : 5'sd1) + (bits[483] ? -5'sd1 : 5'sd1) + (bits[497] ? 5'sd1 : -5'sd1) + (bits[499] ? 5'sd1 : -5'sd1);
499: raw_field = (bits[482] ? 5'sd1 : -5'sd1) + (bits[483] ? 5'sd1 : -5'sd1) + (bits[484] ? 5'sd1 : -5'sd1) + (bits[498] ? 5'sd1 : -5'sd1) + (bits[500] ? -5'sd1 : 5'sd1);
500: raw_field = (bits[483] ? 5'sd1 : -5'sd1) + (bits[484] ? -5'sd1 : 5'sd1) + (bits[485] ? 5'sd1 : -5'sd1) + (bits[499] ? -5'sd1 : 5'sd1) + (bits[501] ? 5'sd1 : -5'sd1);
501: raw_field = (bits[484] ? 5'sd1 : -5'sd1) + (bits[485] ? -5'sd1 : 5'sd1) + (bits[486] ? 5'sd1 : -5'sd1) + (bits[500] ? 5'sd1 : -5'sd1) + (bits[502] ? 5'sd1 : -5'sd1);
502: raw_field = (bits[485] ? -5'sd1 : 5'sd1) + (bits[486] ? -5'sd1 : 5'sd1) + (bits[487] ? 5'sd1 : -5'sd1) + (bits[501] ? 5'sd1 : -5'sd1) + (bits[503] ? 5'sd1 : -5'sd1);
503: raw_field = (bits[486] ? 5'sd1 : -5'sd1) + (bits[487] ? -5'sd1 : 5'sd1) + (bits[488] ? 5'sd1 : -5'sd1) + (bits[502] ? 5'sd1 : -5'sd1) + (bits[504] ? -5'sd1 : 5'sd1);
504: raw_field = (bits[487] ? -5'sd1 : 5'sd1) + (bits[488] ? -5'sd1 : 5'sd1) + (bits[489] ? -5'sd1 : 5'sd1) + (bits[503] ? -5'sd1 : 5'sd1) + (bits[505] ? -5'sd1 : 5'sd1);
505: raw_field = (bits[488] ? 5'sd1 : -5'sd1) + (bits[489] ? -5'sd1 : 5'sd1) + (bits[490] ? -5'sd1 : 5'sd1) + (bits[504] ? -5'sd1 : 5'sd1) + (bits[506] ? 5'sd1 : -5'sd1);
506: raw_field = (bits[489] ? -5'sd1 : 5'sd1) + (bits[490] ? 5'sd1 : -5'sd1) + (bits[491] ? -5'sd1 : 5'sd1) + (bits[505] ? 5'sd1 : -5'sd1) + (bits[507] ? 5'sd1 : -5'sd1);
507: raw_field = (bits[490] ? 5'sd1 : -5'sd1) + (bits[491] ? 5'sd1 : -5'sd1) + (bits[492] ? -5'sd1 : 5'sd1) + (bits[506] ? 5'sd1 : -5'sd1) + (bits[508] ? -5'sd1 : 5'sd1);
508: raw_field = (bits[491] ? 5'sd1 : -5'sd1) + (bits[492] ? -5'sd1 : 5'sd1) + (bits[493] ? 5'sd1 : -5'sd1) + (bits[507] ? -5'sd1 : 5'sd1) + (bits[509] ? -5'sd1 : 5'sd1);
509: raw_field = (bits[492] ? -5'sd1 : 5'sd1) + (bits[493] ? -5'sd1 : 5'sd1) + (bits[494] ? -5'sd1 : 5'sd1) + (bits[508] ? -5'sd1 : 5'sd1) + (bits[510] ? -5'sd1 : 5'sd1);
510: raw_field = (bits[493] ? 5'sd1 : -5'sd1) + (bits[494] ? 5'sd1 : -5'sd1) + (bits[495] ? -5'sd1 : 5'sd1) + (bits[509] ? -5'sd1 : 5'sd1) + (bits[511] ? 5'sd1 : -5'sd1);
511: raw_field = (bits[494] ? -5'sd1 : 5'sd1) + (bits[495] ? -5'sd1 : 5'sd1) + (bits[510] ? 5'sd1 : -5'sd1);
default: raw_field=0;
endcase
end
endfunction
function automatic signed [11:0] score(input logic [511:0] bits);
begin
score = ((((((((((((bits[0] ^ bits[1]) ? 12'sd1 : 12'sd0) +
(((bits[0] ^ bits[16]) ? 12'sd1 : 12'sd0) +
((bits[0] ^ bits[17]) ? -12'sd1 : 12'sd0))) +
((((bits[1] ^ bits[2]) ? 12'sd1 : 12'sd0) +
((bits[1] ^ bits[16]) ? 12'sd1 : 12'sd0)) +
(((bits[1] ^ bits[17]) ? 12'sd1 : 12'sd0) +
((bits[1] ^ bits[18]) ? -12'sd1 : 12'sd0)))) +
((((bits[2] ^ bits[3]) ? 12'sd1 : 12'sd0) +
(((bits[2] ^ bits[17]) ? 12'sd1 : 12'sd0) +
((bits[2] ^ bits[18]) ? -12'sd1 : 12'sd0))) +
((((bits[2] ^ bits[19]) ? -12'sd1 : 12'sd0) +
((bits[3] ^ bits[4]) ? 12'sd1 : 12'sd0)) +
(((bits[3] ^ bits[18]) ? 12'sd1 : 12'sd0) +
((bits[3] ^ bits[19]) ? -12'sd1 : 12'sd0))))) +
(((((bits[3] ^ bits[20]) ? 12'sd1 : 12'sd0) +
(((bits[4] ^ bits[5]) ? 12'sd1 : 12'sd0) +
((bits[4] ^ bits[19]) ? -12'sd1 : 12'sd0))) +
((((bits[4] ^ bits[20]) ? 12'sd1 : 12'sd0) +
((bits[4] ^ bits[21]) ? 12'sd1 : 12'sd0)) +
(((bits[5] ^ bits[6]) ? -12'sd1 : 12'sd0) +
((bits[5] ^ bits[20]) ? 12'sd1 : 12'sd0)))) +
(((((bits[5] ^ bits[21]) ? -12'sd1 : 12'sd0) +
((bits[5] ^ bits[22]) ? 12'sd1 : 12'sd0)) +
(((bits[6] ^ bits[7]) ? -12'sd1 : 12'sd0) +
((bits[6] ^ bits[21]) ? 12'sd1 : 12'sd0))) +
((((bits[6] ^ bits[22]) ? 12'sd1 : 12'sd0) +
((bits[6] ^ bits[23]) ? 12'sd1 : 12'sd0)) +
(((bits[7] ^ bits[8]) ? 12'sd1 : 12'sd0) +
((bits[7] ^ bits[22]) ? -12'sd1 : 12'sd0)))))) +
((((((bits[7] ^ bits[23]) ? 12'sd1 : 12'sd0) +
(((bits[7] ^ bits[24]) ? -12'sd1 : 12'sd0) +
((bits[8] ^ bits[9]) ? 12'sd1 : 12'sd0))) +
((((bits[8] ^ bits[23]) ? 12'sd1 : 12'sd0) +
((bits[8] ^ bits[24]) ? 12'sd1 : 12'sd0)) +
(((bits[8] ^ bits[25]) ? 12'sd1 : 12'sd0) +
((bits[9] ^ bits[10]) ? 12'sd1 : 12'sd0)))) +
(((((bits[9] ^ bits[24]) ? 12'sd1 : 12'sd0) +
((bits[9] ^ bits[25]) ? -12'sd1 : 12'sd0)) +
(((bits[9] ^ bits[26]) ? 12'sd1 : 12'sd0) +
((bits[10] ^ bits[11]) ? -12'sd1 : 12'sd0))) +
((((bits[10] ^ bits[25]) ? 12'sd1 : 12'sd0) +
((bits[10] ^ bits[26]) ? 12'sd1 : 12'sd0)) +
(((bits[10] ^ bits[27]) ? 12'sd1 : 12'sd0) +
((bits[11] ^ bits[12]) ? -12'sd1 : 12'sd0))))) +
(((((bits[11] ^ bits[26]) ? -12'sd1 : 12'sd0) +
(((bits[11] ^ bits[27]) ? 12'sd1 : 12'sd0) +
((bits[11] ^ bits[28]) ? 12'sd1 : 12'sd0))) +
((((bits[12] ^ bits[13]) ? -12'sd1 : 12'sd0) +
((bits[12] ^ bits[27]) ? 12'sd1 : 12'sd0)) +
(((bits[12] ^ bits[28]) ? -12'sd1 : 12'sd0) +
((bits[12] ^ bits[29]) ? -12'sd1 : 12'sd0)))) +
(((((bits[13] ^ bits[14]) ? -12'sd1 : 12'sd0) +
((bits[13] ^ bits[28]) ? 12'sd1 : 12'sd0)) +
(((bits[13] ^ bits[29]) ? 12'sd1 : 12'sd0) +
((bits[13] ^ bits[30]) ? 12'sd1 : 12'sd0))) +
((((bits[14] ^ bits[15]) ? 12'sd1 : 12'sd0) +
((bits[14] ^ bits[29]) ? 12'sd1 : 12'sd0)) +
(((bits[14] ^ bits[30]) ? 12'sd1 : 12'sd0) +
((bits[14] ^ bits[31]) ? -12'sd1 : 12'sd0))))))) +
(((((((bits[15] ^ bits[30]) ? -12'sd1 : 12'sd0) +
(((bits[15] ^ bits[31]) ? -12'sd1 : 12'sd0) +
((bits[16] ^ bits[17]) ? -12'sd1 : 12'sd0))) +
((((bits[16] ^ bits[32]) ? 12'sd1 : 12'sd0) +
((bits[16] ^ bits[33]) ? -12'sd1 : 12'sd0)) +
(((bits[17] ^ bits[18]) ? 12'sd1 : 12'sd0) +
((bits[17] ^ bits[32]) ? -12'sd1 : 12'sd0)))) +
(((((bits[17] ^ bits[33]) ? 12'sd1 : 12'sd0) +
((bits[17] ^ bits[34]) ? -12'sd1 : 12'sd0)) +
(((bits[18] ^ bits[19]) ? -12'sd1 : 12'sd0) +
((bits[18] ^ bits[33]) ? -12'sd1 : 12'sd0))) +
((((bits[18] ^ bits[34]) ? 12'sd1 : 12'sd0) +
((bits[18] ^ bits[35]) ? -12'sd1 : 12'sd0)) +
(((bits[19] ^ bits[20]) ? -12'sd1 : 12'sd0) +
((bits[19] ^ bits[34]) ? -12'sd1 : 12'sd0))))) +
(((((bits[19] ^ bits[35]) ? -12'sd1 : 12'sd0) +
(((bits[19] ^ bits[36]) ? -12'sd1 : 12'sd0) +
((bits[20] ^ bits[21]) ? 12'sd1 : 12'sd0))) +
((((bits[20] ^ bits[35]) ? 12'sd1 : 12'sd0) +
((bits[20] ^ bits[36]) ? -12'sd1 : 12'sd0)) +
(((bits[20] ^ bits[37]) ? 12'sd1 : 12'sd0) +
((bits[21] ^ bits[22]) ? 12'sd1 : 12'sd0)))) +
(((((bits[21] ^ bits[36]) ? 12'sd1 : 12'sd0) +
((bits[21] ^ bits[37]) ? -12'sd1 : 12'sd0)) +
(((bits[21] ^ bits[38]) ? 12'sd1 : 12'sd0) +
((bits[22] ^ bits[23]) ? -12'sd1 : 12'sd0))) +
((((bits[22] ^ bits[37]) ? -12'sd1 : 12'sd0) +
((bits[22] ^ bits[38]) ? 12'sd1 : 12'sd0)) +
(((bits[22] ^ bits[39]) ? 12'sd1 : 12'sd0) +
((bits[23] ^ bits[24]) ? -12'sd1 : 12'sd0)))))) +
((((((bits[23] ^ bits[38]) ? 12'sd1 : 12'sd0) +
(((bits[23] ^ bits[39]) ? -12'sd1 : 12'sd0) +
((bits[23] ^ bits[40]) ? 12'sd1 : 12'sd0))) +
((((bits[24] ^ bits[25]) ? 12'sd1 : 12'sd0) +
((bits[24] ^ bits[39]) ? -12'sd1 : 12'sd0)) +
(((bits[24] ^ bits[40]) ? 12'sd1 : 12'sd0) +
((bits[24] ^ bits[41]) ? -12'sd1 : 12'sd0)))) +
(((((bits[25] ^ bits[26]) ? -12'sd1 : 12'sd0) +
((bits[25] ^ bits[40]) ? -12'sd1 : 12'sd0)) +
(((bits[25] ^ bits[41]) ? 12'sd1 : 12'sd0) +
((bits[25] ^ bits[42]) ? 12'sd1 : 12'sd0))) +
((((bits[26] ^ bits[27]) ? -12'sd1 : 12'sd0) +
((bits[26] ^ bits[41]) ? 12'sd1 : 12'sd0)) +
(((bits[26] ^ bits[42]) ? 12'sd1 : 12'sd0) +
((bits[26] ^ bits[43]) ? 12'sd1 : 12'sd0))))) +
(((((bits[27] ^ bits[28]) ? -12'sd1 : 12'sd0) +
(((bits[27] ^ bits[42]) ? 12'sd1 : 12'sd0) +
((bits[27] ^ bits[43]) ? 12'sd1 : 12'sd0))) +
((((bits[27] ^ bits[44]) ? -12'sd1 : 12'sd0) +
((bits[28] ^ bits[29]) ? 12'sd1 : 12'sd0)) +
(((bits[28] ^ bits[43]) ? -12'sd1 : 12'sd0) +
((bits[28] ^ bits[44]) ? 12'sd1 : 12'sd0)))) +
(((((bits[28] ^ bits[45]) ? -12'sd1 : 12'sd0) +
((bits[29] ^ bits[30]) ? 12'sd1 : 12'sd0)) +
(((bits[29] ^ bits[44]) ? 12'sd1 : 12'sd0) +
((bits[29] ^ bits[45]) ? -12'sd1 : 12'sd0))) +
((((bits[29] ^ bits[46]) ? -12'sd1 : 12'sd0) +
((bits[30] ^ bits[31]) ? 12'sd1 : 12'sd0)) +
(((bits[30] ^ bits[45]) ? 12'sd1 : 12'sd0) +
((bits[30] ^ bits[46]) ? -12'sd1 : 12'sd0)))))))) +
((((((((bits[30] ^ bits[47]) ? -12'sd1 : 12'sd0) +
(((bits[31] ^ bits[46]) ? 12'sd1 : 12'sd0) +
((bits[31] ^ bits[47]) ? 12'sd1 : 12'sd0))) +
((((bits[32] ^ bits[33]) ? 12'sd1 : 12'sd0) +
((bits[32] ^ bits[48]) ? -12'sd1 : 12'sd0)) +
(((bits[32] ^ bits[49]) ? 12'sd1 : 12'sd0) +
((bits[33] ^ bits[34]) ? 12'sd1 : 12'sd0)))) +
((((bits[33] ^ bits[48]) ? 12'sd1 : 12'sd0) +
(((bits[33] ^ bits[49]) ? -12'sd1 : 12'sd0) +
((bits[33] ^ bits[50]) ? 12'sd1 : 12'sd0))) +
((((bits[34] ^ bits[35]) ? 12'sd1 : 12'sd0) +
((bits[34] ^ bits[49]) ? -12'sd1 : 12'sd0)) +
(((bits[34] ^ bits[50]) ? 12'sd1 : 12'sd0) +
((bits[34] ^ bits[51]) ? -12'sd1 : 12'sd0))))) +
(((((bits[35] ^ bits[36]) ? 12'sd1 : 12'sd0) +
(((bits[35] ^ bits[50]) ? -12'sd1 : 12'sd0) +
((bits[35] ^ bits[51]) ? -12'sd1 : 12'sd0))) +
((((bits[35] ^ bits[52]) ? -12'sd1 : 12'sd0) +
((bits[36] ^ bits[37]) ? 12'sd1 : 12'sd0)) +
(((bits[36] ^ bits[51]) ? -12'sd1 : 12'sd0) +
((bits[36] ^ bits[52]) ? 12'sd1 : 12'sd0)))) +
(((((bits[36] ^ bits[53]) ? -12'sd1 : 12'sd0) +
((bits[37] ^ bits[38]) ? -12'sd1 : 12'sd0)) +
(((bits[37] ^ bits[52]) ? -12'sd1 : 12'sd0) +
((bits[37] ^ bits[53]) ? 12'sd1 : 12'sd0))) +
((((bits[37] ^ bits[54]) ? -12'sd1 : 12'sd0) +
((bits[38] ^ bits[39]) ? -12'sd1 : 12'sd0)) +
(((bits[38] ^ bits[53]) ? -12'sd1 : 12'sd0) +
((bits[38] ^ bits[54]) ? -12'sd1 : 12'sd0)))))) +
((((((bits[38] ^ bits[55]) ? -12'sd1 : 12'sd0) +
(((bits[39] ^ bits[40]) ? 12'sd1 : 12'sd0) +
((bits[39] ^ bits[54]) ? -12'sd1 : 12'sd0))) +
((((bits[39] ^ bits[55]) ? -12'sd1 : 12'sd0) +
((bits[39] ^ bits[56]) ? -12'sd1 : 12'sd0)) +
(((bits[40] ^ bits[41]) ? 12'sd1 : 12'sd0) +
((bits[40] ^ bits[55]) ? -12'sd1 : 12'sd0)))) +
(((((bits[40] ^ bits[56]) ? 12'sd1 : 12'sd0) +
((bits[40] ^ bits[57]) ? -12'sd1 : 12'sd0)) +
(((bits[41] ^ bits[42]) ? 12'sd1 : 12'sd0) +
((bits[41] ^ bits[56]) ? 12'sd1 : 12'sd0))) +
((((bits[41] ^ bits[57]) ? 12'sd1 : 12'sd0) +
((bits[41] ^ bits[58]) ? 12'sd1 : 12'sd0)) +
(((bits[42] ^ bits[43]) ? -12'sd1 : 12'sd0) +
((bits[42] ^ bits[57]) ? -12'sd1 : 12'sd0))))) +
(((((bits[42] ^ bits[58]) ? -12'sd1 : 12'sd0) +
(((bits[42] ^ bits[59]) ? -12'sd1 : 12'sd0) +
((bits[43] ^ bits[44]) ? 12'sd1 : 12'sd0))) +
((((bits[43] ^ bits[58]) ? 12'sd1 : 12'sd0) +
((bits[43] ^ bits[59]) ? 12'sd1 : 12'sd0)) +
(((bits[43] ^ bits[60]) ? 12'sd1 : 12'sd0) +
((bits[44] ^ bits[45]) ? 12'sd1 : 12'sd0)))) +
(((((bits[44] ^ bits[59]) ? -12'sd1 : 12'sd0) +
((bits[44] ^ bits[60]) ? 12'sd1 : 12'sd0)) +
(((bits[44] ^ bits[61]) ? 12'sd1 : 12'sd0) +
((bits[45] ^ bits[46]) ? -12'sd1 : 12'sd0))) +
((((bits[45] ^ bits[60]) ? -12'sd1 : 12'sd0) +
((bits[45] ^ bits[61]) ? 12'sd1 : 12'sd0)) +
(((bits[45] ^ bits[62]) ? 12'sd1 : 12'sd0) +
((bits[46] ^ bits[47]) ? -12'sd1 : 12'sd0))))))) +
(((((((bits[46] ^ bits[61]) ? -12'sd1 : 12'sd0) +
(((bits[46] ^ bits[62]) ? 12'sd1 : 12'sd0) +
((bits[46] ^ bits[63]) ? -12'sd1 : 12'sd0))) +
((((bits[47] ^ bits[62]) ? -12'sd1 : 12'sd0) +
((bits[47] ^ bits[63]) ? -12'sd1 : 12'sd0)) +
(((bits[48] ^ bits[49]) ? -12'sd1 : 12'sd0) +
((bits[48] ^ bits[64]) ? -12'sd1 : 12'sd0)))) +
(((((bits[48] ^ bits[65]) ? 12'sd1 : 12'sd0) +
((bits[49] ^ bits[50]) ? -12'sd1 : 12'sd0)) +
(((bits[49] ^ bits[64]) ? 12'sd1 : 12'sd0) +
((bits[49] ^ bits[65]) ? 12'sd1 : 12'sd0))) +
((((bits[49] ^ bits[66]) ? -12'sd1 : 12'sd0) +
((bits[50] ^ bits[51]) ? -12'sd1 : 12'sd0)) +
(((bits[50] ^ bits[65]) ? 12'sd1 : 12'sd0) +
((bits[50] ^ bits[66]) ? 12'sd1 : 12'sd0))))) +
(((((bits[50] ^ bits[67]) ? -12'sd1 : 12'sd0) +
(((bits[51] ^ bits[52]) ? -12'sd1 : 12'sd0) +
((bits[51] ^ bits[66]) ? 12'sd1 : 12'sd0))) +
((((bits[51] ^ bits[67]) ? 12'sd1 : 12'sd0) +
((bits[51] ^ bits[68]) ? 12'sd1 : 12'sd0)) +
(((bits[52] ^ bits[53]) ? 12'sd1 : 12'sd0) +
((bits[52] ^ bits[67]) ? 12'sd1 : 12'sd0)))) +
(((((bits[52] ^ bits[68]) ? -12'sd1 : 12'sd0) +
((bits[52] ^ bits[69]) ? -12'sd1 : 12'sd0)) +
(((bits[53] ^ bits[54]) ? 12'sd1 : 12'sd0) +
((bits[53] ^ bits[68]) ? -12'sd1 : 12'sd0))) +
((((bits[53] ^ bits[69]) ? -12'sd1 : 12'sd0) +
((bits[53] ^ bits[70]) ? -12'sd1 : 12'sd0)) +
(((bits[54] ^ bits[55]) ? 12'sd1 : 12'sd0) +
((bits[54] ^ bits[69]) ? -12'sd1 : 12'sd0)))))) +
((((((bits[54] ^ bits[70]) ? 12'sd1 : 12'sd0) +
(((bits[54] ^ bits[71]) ? 12'sd1 : 12'sd0) +
((bits[55] ^ bits[56]) ? -12'sd1 : 12'sd0))) +
((((bits[55] ^ bits[70]) ? -12'sd1 : 12'sd0) +
((bits[55] ^ bits[71]) ? -12'sd1 : 12'sd0)) +
(((bits[55] ^ bits[72]) ? -12'sd1 : 12'sd0) +
((bits[56] ^ bits[57]) ? 12'sd1 : 12'sd0)))) +
(((((bits[56] ^ bits[71]) ? -12'sd1 : 12'sd0) +
((bits[56] ^ bits[72]) ? -12'sd1 : 12'sd0)) +
(((bits[56] ^ bits[73]) ? -12'sd1 : 12'sd0) +
((bits[57] ^ bits[58]) ? 12'sd1 : 12'sd0))) +
((((bits[57] ^ bits[72]) ? -12'sd1 : 12'sd0) +
((bits[57] ^ bits[73]) ? 12'sd1 : 12'sd0)) +
(((bits[57] ^ bits[74]) ? 12'sd1 : 12'sd0) +
((bits[58] ^ bits[59]) ? 12'sd1 : 12'sd0))))) +
(((((bits[58] ^ bits[73]) ? -12'sd1 : 12'sd0) +
(((bits[58] ^ bits[74]) ? 12'sd1 : 12'sd0) +
((bits[58] ^ bits[75]) ? 12'sd1 : 12'sd0))) +
((((bits[59] ^ bits[60]) ? -12'sd1 : 12'sd0) +
((bits[59] ^ bits[74]) ? -12'sd1 : 12'sd0)) +
(((bits[59] ^ bits[75]) ? 12'sd1 : 12'sd0) +
((bits[59] ^ bits[76]) ? 12'sd1 : 12'sd0)))) +
(((((bits[60] ^ bits[61]) ? -12'sd1 : 12'sd0) +
((bits[60] ^ bits[75]) ? -12'sd1 : 12'sd0)) +
(((bits[60] ^ bits[76]) ? -12'sd1 : 12'sd0) +
((bits[60] ^ bits[77]) ? -12'sd1 : 12'sd0))) +
((((bits[61] ^ bits[62]) ? -12'sd1 : 12'sd0) +
((bits[61] ^ bits[76]) ? 12'sd1 : 12'sd0)) +
(((bits[61] ^ bits[77]) ? 12'sd1 : 12'sd0) +
((bits[61] ^ bits[78]) ? 12'sd1 : 12'sd0))))))))) +
(((((((((bits[62] ^ bits[63]) ? -12'sd1 : 12'sd0) +
(((bits[62] ^ bits[77]) ? -12'sd1 : 12'sd0) +
((bits[62] ^ bits[78]) ? 12'sd1 : 12'sd0))) +
((((bits[62] ^ bits[79]) ? -12'sd1 : 12'sd0) +
((bits[63] ^ bits[78]) ? 12'sd1 : 12'sd0)) +
(((bits[63] ^ bits[79]) ? 12'sd1 : 12'sd0) +
((bits[64] ^ bits[65]) ? 12'sd1 : 12'sd0)))) +
((((bits[64] ^ bits[80]) ? -12'sd1 : 12'sd0) +
(((bits[64] ^ bits[81]) ? -12'sd1 : 12'sd0) +
((bits[65] ^ bits[66]) ? -12'sd1 : 12'sd0))) +
((((bits[65] ^ bits[80]) ? -12'sd1 : 12'sd0) +
((bits[65] ^ bits[81]) ? 12'sd1 : 12'sd0)) +
(((bits[65] ^ bits[82]) ? -12'sd1 : 12'sd0) +
((bits[66] ^ bits[67]) ? -12'sd1 : 12'sd0))))) +
(((((bits[66] ^ bits[81]) ? -12'sd1 : 12'sd0) +
(((bits[66] ^ bits[82]) ? -12'sd1 : 12'sd0) +
((bits[66] ^ bits[83]) ? 12'sd1 : 12'sd0))) +
((((bits[67] ^ bits[68]) ? -12'sd1 : 12'sd0) +
((bits[67] ^ bits[82]) ? -12'sd1 : 12'sd0)) +
(((bits[67] ^ bits[83]) ? 12'sd1 : 12'sd0) +
((bits[67] ^ bits[84]) ? -12'sd1 : 12'sd0)))) +
(((((bits[68] ^ bits[69]) ? -12'sd1 : 12'sd0) +
((bits[68] ^ bits[83]) ? 12'sd1 : 12'sd0)) +
(((bits[68] ^ bits[84]) ? -12'sd1 : 12'sd0) +
((bits[68] ^ bits[85]) ? 12'sd1 : 12'sd0))) +
((((bits[69] ^ bits[70]) ? 12'sd1 : 12'sd0) +
((bits[69] ^ bits[84]) ? -12'sd1 : 12'sd0)) +
(((bits[69] ^ bits[85]) ? -12'sd1 : 12'sd0) +
((bits[69] ^ bits[86]) ? 12'sd1 : 12'sd0)))))) +
((((((bits[70] ^ bits[71]) ? -12'sd1 : 12'sd0) +
(((bits[70] ^ bits[85]) ? 12'sd1 : 12'sd0) +
((bits[70] ^ bits[86]) ? -12'sd1 : 12'sd0))) +
((((bits[70] ^ bits[87]) ? -12'sd1 : 12'sd0) +
((bits[71] ^ bits[72]) ? -12'sd1 : 12'sd0)) +
(((bits[71] ^ bits[86]) ? 12'sd1 : 12'sd0) +
((bits[71] ^ bits[87]) ? -12'sd1 : 12'sd0)))) +
(((((bits[71] ^ bits[88]) ? -12'sd1 : 12'sd0) +
((bits[72] ^ bits[73]) ? 12'sd1 : 12'sd0)) +
(((bits[72] ^ bits[87]) ? 12'sd1 : 12'sd0) +
((bits[72] ^ bits[88]) ? 12'sd1 : 12'sd0))) +
((((bits[72] ^ bits[89]) ? 12'sd1 : 12'sd0) +
((bits[73] ^ bits[74]) ? 12'sd1 : 12'sd0)) +
(((bits[73] ^ bits[88]) ? 12'sd1 : 12'sd0) +
((bits[73] ^ bits[89]) ? -12'sd1 : 12'sd0))))) +
(((((bits[73] ^ bits[90]) ? 12'sd1 : 12'sd0) +
(((bits[74] ^ bits[75]) ? -12'sd1 : 12'sd0) +
((bits[74] ^ bits[89]) ? 12'sd1 : 12'sd0))) +
((((bits[74] ^ bits[90]) ? -12'sd1 : 12'sd0) +
((bits[74] ^ bits[91]) ? 12'sd1 : 12'sd0)) +
(((bits[75] ^ bits[76]) ? 12'sd1 : 12'sd0) +
((bits[75] ^ bits[90]) ? 12'sd1 : 12'sd0)))) +
(((((bits[75] ^ bits[91]) ? 12'sd1 : 12'sd0) +
((bits[75] ^ bits[92]) ? -12'sd1 : 12'sd0)) +
(((bits[76] ^ bits[77]) ? -12'sd1 : 12'sd0) +
((bits[76] ^ bits[91]) ? -12'sd1 : 12'sd0))) +
((((bits[76] ^ bits[92]) ? -12'sd1 : 12'sd0) +
((bits[76] ^ bits[93]) ? -12'sd1 : 12'sd0)) +
(((bits[77] ^ bits[78]) ? 12'sd1 : 12'sd0) +
((bits[77] ^ bits[92]) ? 12'sd1 : 12'sd0))))))) +
(((((((bits[77] ^ bits[93]) ? 12'sd1 : 12'sd0) +
(((bits[77] ^ bits[94]) ? 12'sd1 : 12'sd0) +
((bits[78] ^ bits[79]) ? 12'sd1 : 12'sd0))) +
((((bits[78] ^ bits[93]) ? 12'sd1 : 12'sd0) +
((bits[78] ^ bits[94]) ? 12'sd1 : 12'sd0)) +
(((bits[78] ^ bits[95]) ? -12'sd1 : 12'sd0) +
((bits[79] ^ bits[94]) ? 12'sd1 : 12'sd0)))) +
(((((bits[79] ^ bits[95]) ? 12'sd1 : 12'sd0) +
((bits[80] ^ bits[81]) ? 12'sd1 : 12'sd0)) +
(((bits[80] ^ bits[96]) ? -12'sd1 : 12'sd0) +
((bits[80] ^ bits[97]) ? 12'sd1 : 12'sd0))) +
((((bits[81] ^ bits[82]) ? -12'sd1 : 12'sd0) +
((bits[81] ^ bits[96]) ? -12'sd1 : 12'sd0)) +
(((bits[81] ^ bits[97]) ? 12'sd1 : 12'sd0) +
((bits[81] ^ bits[98]) ? -12'sd1 : 12'sd0))))) +
(((((bits[82] ^ bits[83]) ? -12'sd1 : 12'sd0) +
(((bits[82] ^ bits[97]) ? -12'sd1 : 12'sd0) +
((bits[82] ^ bits[98]) ? 12'sd1 : 12'sd0))) +
((((bits[82] ^ bits[99]) ? -12'sd1 : 12'sd0) +
((bits[83] ^ bits[84]) ? -12'sd1 : 12'sd0)) +
(((bits[83] ^ bits[98]) ? 12'sd1 : 12'sd0) +
((bits[83] ^ bits[99]) ? 12'sd1 : 12'sd0)))) +
(((((bits[83] ^ bits[100]) ? -12'sd1 : 12'sd0) +
((bits[84] ^ bits[85]) ? -12'sd1 : 12'sd0)) +
(((bits[84] ^ bits[99]) ? 12'sd1 : 12'sd0) +
((bits[84] ^ bits[100]) ? 12'sd1 : 12'sd0))) +
((((bits[84] ^ bits[101]) ? 12'sd1 : 12'sd0) +
((bits[85] ^ bits[86]) ? -12'sd1 : 12'sd0)) +
(((bits[85] ^ bits[100]) ? 12'sd1 : 12'sd0) +
((bits[85] ^ bits[101]) ? 12'sd1 : 12'sd0)))))) +
((((((bits[85] ^ bits[102]) ? -12'sd1 : 12'sd0) +
(((bits[86] ^ bits[87]) ? -12'sd1 : 12'sd0) +
((bits[86] ^ bits[101]) ? 12'sd1 : 12'sd0))) +
((((bits[86] ^ bits[102]) ? 12'sd1 : 12'sd0) +
((bits[86] ^ bits[103]) ? 12'sd1 : 12'sd0)) +
(((bits[87] ^ bits[88]) ? -12'sd1 : 12'sd0) +
((bits[87] ^ bits[102]) ? 12'sd1 : 12'sd0)))) +
(((((bits[87] ^ bits[103]) ? -12'sd1 : 12'sd0) +
((bits[87] ^ bits[104]) ? -12'sd1 : 12'sd0)) +
(((bits[88] ^ bits[89]) ? -12'sd1 : 12'sd0) +
((bits[88] ^ bits[103]) ? -12'sd1 : 12'sd0))) +
((((bits[88] ^ bits[104]) ? -12'sd1 : 12'sd0) +
((bits[88] ^ bits[105]) ? 12'sd1 : 12'sd0)) +
(((bits[89] ^ bits[90]) ? 12'sd1 : 12'sd0) +
((bits[89] ^ bits[104]) ? -12'sd1 : 12'sd0))))) +
(((((bits[89] ^ bits[105]) ? 12'sd1 : 12'sd0) +
(((bits[89] ^ bits[106]) ? -12'sd1 : 12'sd0) +
((bits[90] ^ bits[91]) ? -12'sd1 : 12'sd0))) +
((((bits[90] ^ bits[105]) ? 12'sd1 : 12'sd0) +
((bits[90] ^ bits[106]) ? -12'sd1 : 12'sd0)) +
(((bits[90] ^ bits[107]) ? 12'sd1 : 12'sd0) +
((bits[91] ^ bits[92]) ? 12'sd1 : 12'sd0)))) +
(((((bits[91] ^ bits[106]) ? 12'sd1 : 12'sd0) +
((bits[91] ^ bits[107]) ? -12'sd1 : 12'sd0)) +
(((bits[91] ^ bits[108]) ? 12'sd1 : 12'sd0) +
((bits[92] ^ bits[93]) ? 12'sd1 : 12'sd0))) +
((((bits[92] ^ bits[107]) ? 12'sd1 : 12'sd0) +
((bits[92] ^ bits[108]) ? -12'sd1 : 12'sd0)) +
(((bits[92] ^ bits[109]) ? -12'sd1 : 12'sd0) +
((bits[93] ^ bits[94]) ? -12'sd1 : 12'sd0)))))))) +
((((((((bits[93] ^ bits[108]) ? -12'sd1 : 12'sd0) +
(((bits[93] ^ bits[109]) ? 12'sd1 : 12'sd0) +
((bits[93] ^ bits[110]) ? 12'sd1 : 12'sd0))) +
((((bits[94] ^ bits[95]) ? -12'sd1 : 12'sd0) +
((bits[94] ^ bits[109]) ? -12'sd1 : 12'sd0)) +
(((bits[94] ^ bits[110]) ? 12'sd1 : 12'sd0) +
((bits[94] ^ bits[111]) ? -12'sd1 : 12'sd0)))) +
((((bits[95] ^ bits[110]) ? -12'sd1 : 12'sd0) +
(((bits[95] ^ bits[111]) ? 12'sd1 : 12'sd0) +
((bits[96] ^ bits[97]) ? 12'sd1 : 12'sd0))) +
((((bits[96] ^ bits[112]) ? -12'sd1 : 12'sd0) +
((bits[96] ^ bits[113]) ? 12'sd1 : 12'sd0)) +
(((bits[97] ^ bits[98]) ? 12'sd1 : 12'sd0) +
((bits[97] ^ bits[112]) ? -12'sd1 : 12'sd0))))) +
(((((bits[97] ^ bits[113]) ? -12'sd1 : 12'sd0) +
(((bits[97] ^ bits[114]) ? 12'sd1 : 12'sd0) +
((bits[98] ^ bits[99]) ? 12'sd1 : 12'sd0))) +
((((bits[98] ^ bits[113]) ? -12'sd1 : 12'sd0) +
((bits[98] ^ bits[114]) ? -12'sd1 : 12'sd0)) +
(((bits[98] ^ bits[115]) ? 12'sd1 : 12'sd0) +
((bits[99] ^ bits[100]) ? 12'sd1 : 12'sd0)))) +
(((((bits[99] ^ bits[114]) ? -12'sd1 : 12'sd0) +
((bits[99] ^ bits[115]) ? 12'sd1 : 12'sd0)) +
(((bits[99] ^ bits[116]) ? -12'sd1 : 12'sd0) +
((bits[100] ^ bits[101]) ? 12'sd1 : 12'sd0))) +
((((bits[100] ^ bits[115]) ? -12'sd1 : 12'sd0) +
((bits[100] ^ bits[116]) ? -12'sd1 : 12'sd0)) +
(((bits[100] ^ bits[117]) ? -12'sd1 : 12'sd0) +
((bits[101] ^ bits[102]) ? -12'sd1 : 12'sd0)))))) +
((((((bits[101] ^ bits[116]) ? -12'sd1 : 12'sd0) +
(((bits[101] ^ bits[117]) ? 12'sd1 : 12'sd0) +
((bits[101] ^ bits[118]) ? -12'sd1 : 12'sd0))) +
((((bits[102] ^ bits[103]) ? 12'sd1 : 12'sd0) +
((bits[102] ^ bits[117]) ? -12'sd1 : 12'sd0)) +
(((bits[102] ^ bits[118]) ? 12'sd1 : 12'sd0) +
((bits[102] ^ bits[119]) ? 12'sd1 : 12'sd0)))) +
(((((bits[103] ^ bits[104]) ? 12'sd1 : 12'sd0) +
((bits[103] ^ bits[118]) ? 12'sd1 : 12'sd0)) +
(((bits[103] ^ bits[119]) ? 12'sd1 : 12'sd0) +
((bits[103] ^ bits[120]) ? -12'sd1 : 12'sd0))) +
((((bits[104] ^ bits[105]) ? 12'sd1 : 12'sd0) +
((bits[104] ^ bits[119]) ? -12'sd1 : 12'sd0)) +
(((bits[104] ^ bits[120]) ? 12'sd1 : 12'sd0) +
((bits[104] ^ bits[121]) ? 12'sd1 : 12'sd0))))) +
(((((bits[105] ^ bits[106]) ? -12'sd1 : 12'sd0) +
(((bits[105] ^ bits[120]) ? -12'sd1 : 12'sd0) +
((bits[105] ^ bits[121]) ? 12'sd1 : 12'sd0))) +
((((bits[105] ^ bits[122]) ? -12'sd1 : 12'sd0) +
((bits[106] ^ bits[107]) ? 12'sd1 : 12'sd0)) +
(((bits[106] ^ bits[121]) ? -12'sd1 : 12'sd0) +
((bits[106] ^ bits[122]) ? -12'sd1 : 12'sd0)))) +
(((((bits[106] ^ bits[123]) ? 12'sd1 : 12'sd0) +
((bits[107] ^ bits[108]) ? -12'sd1 : 12'sd0)) +
(((bits[107] ^ bits[122]) ? -12'sd1 : 12'sd0) +
((bits[107] ^ bits[123]) ? 12'sd1 : 12'sd0))) +
((((bits[107] ^ bits[124]) ? 12'sd1 : 12'sd0) +
((bits[108] ^ bits[109]) ? -12'sd1 : 12'sd0)) +
(((bits[108] ^ bits[123]) ? -12'sd1 : 12'sd0) +
((bits[108] ^ bits[124]) ? -12'sd1 : 12'sd0))))))) +
(((((((bits[108] ^ bits[125]) ? -12'sd1 : 12'sd0) +
(((bits[109] ^ bits[110]) ? 12'sd1 : 12'sd0) +
((bits[109] ^ bits[124]) ? -12'sd1 : 12'sd0))) +
((((bits[109] ^ bits[125]) ? 12'sd1 : 12'sd0) +
((bits[109] ^ bits[126]) ? 12'sd1 : 12'sd0)) +
(((bits[110] ^ bits[111]) ? -12'sd1 : 12'sd0) +
((bits[110] ^ bits[125]) ? -12'sd1 : 12'sd0)))) +
(((((bits[110] ^ bits[126]) ? 12'sd1 : 12'sd0) +
((bits[110] ^ bits[127]) ? 12'sd1 : 12'sd0)) +
(((bits[111] ^ bits[126]) ? 12'sd1 : 12'sd0) +
((bits[111] ^ bits[127]) ? -12'sd1 : 12'sd0))) +
((((bits[112] ^ bits[113]) ? -12'sd1 : 12'sd0) +
((bits[112] ^ bits[128]) ? -12'sd1 : 12'sd0)) +
(((bits[112] ^ bits[129]) ? -12'sd1 : 12'sd0) +
((bits[113] ^ bits[114]) ? -12'sd1 : 12'sd0))))) +
(((((bits[113] ^ bits[128]) ? 12'sd1 : 12'sd0) +
(((bits[113] ^ bits[129]) ? -12'sd1 : 12'sd0) +
((bits[113] ^ bits[130]) ? 12'sd1 : 12'sd0))) +
((((bits[114] ^ bits[115]) ? 12'sd1 : 12'sd0) +
((bits[114] ^ bits[129]) ? 12'sd1 : 12'sd0)) +
(((bits[114] ^ bits[130]) ? -12'sd1 : 12'sd0) +
((bits[114] ^ bits[131]) ? 12'sd1 : 12'sd0)))) +
(((((bits[115] ^ bits[116]) ? -12'sd1 : 12'sd0) +
((bits[115] ^ bits[130]) ? -12'sd1 : 12'sd0)) +
(((bits[115] ^ bits[131]) ? 12'sd1 : 12'sd0) +
((bits[115] ^ bits[132]) ? 12'sd1 : 12'sd0))) +
((((bits[116] ^ bits[117]) ? 12'sd1 : 12'sd0) +
((bits[116] ^ bits[131]) ? 12'sd1 : 12'sd0)) +
(((bits[116] ^ bits[132]) ? -12'sd1 : 12'sd0) +
((bits[116] ^ bits[133]) ? 12'sd1 : 12'sd0)))))) +
((((((bits[117] ^ bits[118]) ? 12'sd1 : 12'sd0) +
(((bits[117] ^ bits[132]) ? 12'sd1 : 12'sd0) +
((bits[117] ^ bits[133]) ? 12'sd1 : 12'sd0))) +
((((bits[117] ^ bits[134]) ? 12'sd1 : 12'sd0) +
((bits[118] ^ bits[119]) ? 12'sd1 : 12'sd0)) +
(((bits[118] ^ bits[133]) ? 12'sd1 : 12'sd0) +
((bits[118] ^ bits[134]) ? -12'sd1 : 12'sd0)))) +
(((((bits[118] ^ bits[135]) ? -12'sd1 : 12'sd0) +
((bits[119] ^ bits[120]) ? -12'sd1 : 12'sd0)) +
(((bits[119] ^ bits[134]) ? -12'sd1 : 12'sd0) +
((bits[119] ^ bits[135]) ? 12'sd1 : 12'sd0))) +
((((bits[119] ^ bits[136]) ? 12'sd1 : 12'sd0) +
((bits[120] ^ bits[121]) ? 12'sd1 : 12'sd0)) +
(((bits[120] ^ bits[135]) ? -12'sd1 : 12'sd0) +
((bits[120] ^ bits[136]) ? 12'sd1 : 12'sd0))))) +
(((((bits[120] ^ bits[137]) ? -12'sd1 : 12'sd0) +
(((bits[121] ^ bits[122]) ? 12'sd1 : 12'sd0) +
((bits[121] ^ bits[136]) ? -12'sd1 : 12'sd0))) +
((((bits[121] ^ bits[137]) ? 12'sd1 : 12'sd0) +
((bits[121] ^ bits[138]) ? 12'sd1 : 12'sd0)) +
(((bits[122] ^ bits[123]) ? 12'sd1 : 12'sd0) +
((bits[122] ^ bits[137]) ? -12'sd1 : 12'sd0)))) +
(((((bits[122] ^ bits[138]) ? -12'sd1 : 12'sd0) +
((bits[122] ^ bits[139]) ? 12'sd1 : 12'sd0)) +
(((bits[123] ^ bits[124]) ? -12'sd1 : 12'sd0) +
((bits[123] ^ bits[138]) ? -12'sd1 : 12'sd0))) +
((((bits[123] ^ bits[139]) ? -12'sd1 : 12'sd0) +
((bits[123] ^ bits[140]) ? 12'sd1 : 12'sd0)) +
(((bits[124] ^ bits[125]) ? 12'sd1 : 12'sd0) +
((bits[124] ^ bits[139]) ? -12'sd1 : 12'sd0)))))))))) +
((((((((((bits[124] ^ bits[140]) ? 12'sd1 : 12'sd0) +
(((bits[124] ^ bits[141]) ? 12'sd1 : 12'sd0) +
((bits[125] ^ bits[126]) ? -12'sd1 : 12'sd0))) +
((((bits[125] ^ bits[140]) ? -12'sd1 : 12'sd0) +
((bits[125] ^ bits[141]) ? 12'sd1 : 12'sd0)) +
(((bits[125] ^ bits[142]) ? -12'sd1 : 12'sd0) +
((bits[126] ^ bits[127]) ? 12'sd1 : 12'sd0)))) +
((((bits[126] ^ bits[141]) ? -12'sd1 : 12'sd0) +
(((bits[126] ^ bits[142]) ? -12'sd1 : 12'sd0) +
((bits[126] ^ bits[143]) ? -12'sd1 : 12'sd0))) +
((((bits[127] ^ bits[142]) ? 12'sd1 : 12'sd0) +
((bits[127] ^ bits[143]) ? -12'sd1 : 12'sd0)) +
(((bits[128] ^ bits[129]) ? 12'sd1 : 12'sd0) +
((bits[128] ^ bits[144]) ? -12'sd1 : 12'sd0))))) +
(((((bits[128] ^ bits[145]) ? 12'sd1 : 12'sd0) +
(((bits[129] ^ bits[130]) ? -12'sd1 : 12'sd0) +
((bits[129] ^ bits[144]) ? 12'sd1 : 12'sd0))) +
((((bits[129] ^ bits[145]) ? -12'sd1 : 12'sd0) +
((bits[129] ^ bits[146]) ? -12'sd1 : 12'sd0)) +
(((bits[130] ^ bits[131]) ? -12'sd1 : 12'sd0) +
((bits[130] ^ bits[145]) ? 12'sd1 : 12'sd0)))) +
(((((bits[130] ^ bits[146]) ? -12'sd1 : 12'sd0) +
((bits[130] ^ bits[147]) ? 12'sd1 : 12'sd0)) +
(((bits[131] ^ bits[132]) ? 12'sd1 : 12'sd0) +
((bits[131] ^ bits[146]) ? -12'sd1 : 12'sd0))) +
((((bits[131] ^ bits[147]) ? -12'sd1 : 12'sd0) +
((bits[131] ^ bits[148]) ? 12'sd1 : 12'sd0)) +
(((bits[132] ^ bits[133]) ? 12'sd1 : 12'sd0) +
((bits[132] ^ bits[147]) ? 12'sd1 : 12'sd0)))))) +
((((((bits[132] ^ bits[148]) ? -12'sd1 : 12'sd0) +
(((bits[132] ^ bits[149]) ? 12'sd1 : 12'sd0) +
((bits[133] ^ bits[134]) ? -12'sd1 : 12'sd0))) +
((((bits[133] ^ bits[148]) ? 12'sd1 : 12'sd0) +
((bits[133] ^ bits[149]) ? -12'sd1 : 12'sd0)) +
(((bits[133] ^ bits[150]) ? 12'sd1 : 12'sd0) +
((bits[134] ^ bits[135]) ? -12'sd1 : 12'sd0)))) +
(((((bits[134] ^ bits[149]) ? -12'sd1 : 12'sd0) +
((bits[134] ^ bits[150]) ? -12'sd1 : 12'sd0)) +
(((bits[134] ^ bits[151]) ? 12'sd1 : 12'sd0) +
((bits[135] ^ bits[136]) ? 12'sd1 : 12'sd0))) +
((((bits[135] ^ bits[150]) ? -12'sd1 : 12'sd0) +
((bits[135] ^ bits[151]) ? -12'sd1 : 12'sd0)) +
(((bits[135] ^ bits[152]) ? 12'sd1 : 12'sd0) +
((bits[136] ^ bits[137]) ? -12'sd1 : 12'sd0))))) +
(((((bits[136] ^ bits[151]) ? -12'sd1 : 12'sd0) +
(((bits[136] ^ bits[152]) ? -12'sd1 : 12'sd0) +
((bits[136] ^ bits[153]) ? -12'sd1 : 12'sd0))) +
((((bits[137] ^ bits[138]) ? 12'sd1 : 12'sd0) +
((bits[137] ^ bits[152]) ? 12'sd1 : 12'sd0)) +
(((bits[137] ^ bits[153]) ? -12'sd1 : 12'sd0) +
((bits[137] ^ bits[154]) ? -12'sd1 : 12'sd0)))) +
(((((bits[138] ^ bits[139]) ? 12'sd1 : 12'sd0) +
((bits[138] ^ bits[153]) ? -12'sd1 : 12'sd0)) +
(((bits[138] ^ bits[154]) ? -12'sd1 : 12'sd0) +
((bits[138] ^ bits[155]) ? -12'sd1 : 12'sd0))) +
((((bits[139] ^ bits[140]) ? 12'sd1 : 12'sd0) +
((bits[139] ^ bits[154]) ? 12'sd1 : 12'sd0)) +
(((bits[139] ^ bits[155]) ? 12'sd1 : 12'sd0) +
((bits[139] ^ bits[156]) ? -12'sd1 : 12'sd0))))))) +
(((((((bits[140] ^ bits[141]) ? 12'sd1 : 12'sd0) +
(((bits[140] ^ bits[155]) ? -12'sd1 : 12'sd0) +
((bits[140] ^ bits[156]) ? 12'sd1 : 12'sd0))) +
((((bits[140] ^ bits[157]) ? 12'sd1 : 12'sd0) +
((bits[141] ^ bits[142]) ? -12'sd1 : 12'sd0)) +
(((bits[141] ^ bits[156]) ? -12'sd1 : 12'sd0) +
((bits[141] ^ bits[157]) ? 12'sd1 : 12'sd0)))) +
(((((bits[141] ^ bits[158]) ? 12'sd1 : 12'sd0) +
((bits[142] ^ bits[143]) ? -12'sd1 : 12'sd0)) +
(((bits[142] ^ bits[157]) ? -12'sd1 : 12'sd0) +
((bits[142] ^ bits[158]) ? -12'sd1 : 12'sd0))) +
((((bits[142] ^ bits[159]) ? 12'sd1 : 12'sd0) +
((bits[143] ^ bits[158]) ? 12'sd1 : 12'sd0)) +
(((bits[143] ^ bits[159]) ? 12'sd1 : 12'sd0) +
((bits[144] ^ bits[145]) ? -12'sd1 : 12'sd0))))) +
(((((bits[144] ^ bits[160]) ? -12'sd1 : 12'sd0) +
(((bits[144] ^ bits[161]) ? -12'sd1 : 12'sd0) +
((bits[145] ^ bits[146]) ? -12'sd1 : 12'sd0))) +
((((bits[145] ^ bits[160]) ? 12'sd1 : 12'sd0) +
((bits[145] ^ bits[161]) ? 12'sd1 : 12'sd0)) +
(((bits[145] ^ bits[162]) ? 12'sd1 : 12'sd0) +
((bits[146] ^ bits[147]) ? 12'sd1 : 12'sd0)))) +
(((((bits[146] ^ bits[161]) ? 12'sd1 : 12'sd0) +
((bits[146] ^ bits[162]) ? -12'sd1 : 12'sd0)) +
(((bits[146] ^ bits[163]) ? -12'sd1 : 12'sd0) +
((bits[147] ^ bits[148]) ? 12'sd1 : 12'sd0))) +
((((bits[147] ^ bits[162]) ? 12'sd1 : 12'sd0) +
((bits[147] ^ bits[163]) ? -12'sd1 : 12'sd0)) +
(((bits[147] ^ bits[164]) ? -12'sd1 : 12'sd0) +
((bits[148] ^ bits[149]) ? -12'sd1 : 12'sd0)))))) +
((((((bits[148] ^ bits[163]) ? 12'sd1 : 12'sd0) +
(((bits[148] ^ bits[164]) ? 12'sd1 : 12'sd0) +
((bits[148] ^ bits[165]) ? 12'sd1 : 12'sd0))) +
((((bits[149] ^ bits[150]) ? 12'sd1 : 12'sd0) +
((bits[149] ^ bits[164]) ? -12'sd1 : 12'sd0)) +
(((bits[149] ^ bits[165]) ? 12'sd1 : 12'sd0) +
((bits[149] ^ bits[166]) ? 12'sd1 : 12'sd0)))) +
(((((bits[150] ^ bits[151]) ? -12'sd1 : 12'sd0) +
((bits[150] ^ bits[165]) ? -12'sd1 : 12'sd0)) +
(((bits[150] ^ bits[166]) ? -12'sd1 : 12'sd0) +
((bits[150] ^ bits[167]) ? -12'sd1 : 12'sd0))) +
((((bits[151] ^ bits[152]) ? -12'sd1 : 12'sd0) +
((bits[151] ^ bits[166]) ? 12'sd1 : 12'sd0)) +
(((bits[151] ^ bits[167]) ? 12'sd1 : 12'sd0) +
((bits[151] ^ bits[168]) ? 12'sd1 : 12'sd0))))) +
(((((bits[152] ^ bits[153]) ? -12'sd1 : 12'sd0) +
(((bits[152] ^ bits[167]) ? -12'sd1 : 12'sd0) +
((bits[152] ^ bits[168]) ? -12'sd1 : 12'sd0))) +
((((bits[152] ^ bits[169]) ? -12'sd1 : 12'sd0) +
((bits[153] ^ bits[154]) ? -12'sd1 : 12'sd0)) +
(((bits[153] ^ bits[168]) ? 12'sd1 : 12'sd0) +
((bits[153] ^ bits[169]) ? 12'sd1 : 12'sd0)))) +
(((((bits[153] ^ bits[170]) ? -12'sd1 : 12'sd0) +
((bits[154] ^ bits[155]) ? -12'sd1 : 12'sd0)) +
(((bits[154] ^ bits[169]) ? -12'sd1 : 12'sd0) +
((bits[154] ^ bits[170]) ? 12'sd1 : 12'sd0))) +
((((bits[154] ^ bits[171]) ? 12'sd1 : 12'sd0) +
((bits[155] ^ bits[156]) ? 12'sd1 : 12'sd0)) +
(((bits[155] ^ bits[170]) ? 12'sd1 : 12'sd0) +
((bits[155] ^ bits[171]) ? 12'sd1 : 12'sd0)))))))) +
((((((((bits[155] ^ bits[172]) ? 12'sd1 : 12'sd0) +
(((bits[156] ^ bits[157]) ? -12'sd1 : 12'sd0) +
((bits[156] ^ bits[171]) ? -12'sd1 : 12'sd0))) +
((((bits[156] ^ bits[172]) ? -12'sd1 : 12'sd0) +
((bits[156] ^ bits[173]) ? 12'sd1 : 12'sd0)) +
(((bits[157] ^ bits[158]) ? -12'sd1 : 12'sd0) +
((bits[157] ^ bits[172]) ? -12'sd1 : 12'sd0)))) +
((((bits[157] ^ bits[173]) ? 12'sd1 : 12'sd0) +
(((bits[157] ^ bits[174]) ? -12'sd1 : 12'sd0) +
((bits[158] ^ bits[159]) ? 12'sd1 : 12'sd0))) +
((((bits[158] ^ bits[173]) ? 12'sd1 : 12'sd0) +
((bits[158] ^ bits[174]) ? -12'sd1 : 12'sd0)) +
(((bits[158] ^ bits[175]) ? -12'sd1 : 12'sd0) +
((bits[159] ^ bits[174]) ? -12'sd1 : 12'sd0))))) +
(((((bits[159] ^ bits[175]) ? 12'sd1 : 12'sd0) +
(((bits[160] ^ bits[161]) ? 12'sd1 : 12'sd0) +
((bits[160] ^ bits[176]) ? 12'sd1 : 12'sd0))) +
((((bits[160] ^ bits[177]) ? -12'sd1 : 12'sd0) +
((bits[161] ^ bits[162]) ? 12'sd1 : 12'sd0)) +
(((bits[161] ^ bits[176]) ? 12'sd1 : 12'sd0) +
((bits[161] ^ bits[177]) ? 12'sd1 : 12'sd0)))) +
(((((bits[161] ^ bits[178]) ? 12'sd1 : 12'sd0) +
((bits[162] ^ bits[163]) ? 12'sd1 : 12'sd0)) +
(((bits[162] ^ bits[177]) ? -12'sd1 : 12'sd0) +
((bits[162] ^ bits[178]) ? 12'sd1 : 12'sd0))) +
((((bits[162] ^ bits[179]) ? -12'sd1 : 12'sd0) +
((bits[163] ^ bits[164]) ? 12'sd1 : 12'sd0)) +
(((bits[163] ^ bits[178]) ? 12'sd1 : 12'sd0) +
((bits[163] ^ bits[179]) ? 12'sd1 : 12'sd0)))))) +
((((((bits[163] ^ bits[180]) ? 12'sd1 : 12'sd0) +
(((bits[164] ^ bits[165]) ? -12'sd1 : 12'sd0) +
((bits[164] ^ bits[179]) ? -12'sd1 : 12'sd0))) +
((((bits[164] ^ bits[180]) ? 12'sd1 : 12'sd0) +
((bits[164] ^ bits[181]) ? -12'sd1 : 12'sd0)) +
(((bits[165] ^ bits[166]) ? -12'sd1 : 12'sd0) +
((bits[165] ^ bits[180]) ? 12'sd1 : 12'sd0)))) +
(((((bits[165] ^ bits[181]) ? 12'sd1 : 12'sd0) +
((bits[165] ^ bits[182]) ? 12'sd1 : 12'sd0)) +
(((bits[166] ^ bits[167]) ? -12'sd1 : 12'sd0) +
((bits[166] ^ bits[181]) ? 12'sd1 : 12'sd0))) +
((((bits[166] ^ bits[182]) ? -12'sd1 : 12'sd0) +
((bits[166] ^ bits[183]) ? -12'sd1 : 12'sd0)) +
(((bits[167] ^ bits[168]) ? 12'sd1 : 12'sd0) +
((bits[167] ^ bits[182]) ? 12'sd1 : 12'sd0))))) +
(((((bits[167] ^ bits[183]) ? -12'sd1 : 12'sd0) +
(((bits[167] ^ bits[184]) ? 12'sd1 : 12'sd0) +
((bits[168] ^ bits[169]) ? 12'sd1 : 12'sd0))) +
((((bits[168] ^ bits[183]) ? -12'sd1 : 12'sd0) +
((bits[168] ^ bits[184]) ? 12'sd1 : 12'sd0)) +
(((bits[168] ^ bits[185]) ? -12'sd1 : 12'sd0) +
((bits[169] ^ bits[170]) ? -12'sd1 : 12'sd0)))) +
(((((bits[169] ^ bits[184]) ? 12'sd1 : 12'sd0) +
((bits[169] ^ bits[185]) ? 12'sd1 : 12'sd0)) +
(((bits[169] ^ bits[186]) ? 12'sd1 : 12'sd0) +
((bits[170] ^ bits[171]) ? 12'sd1 : 12'sd0))) +
((((bits[170] ^ bits[185]) ? -12'sd1 : 12'sd0) +
((bits[170] ^ bits[186]) ? 12'sd1 : 12'sd0)) +
(((bits[170] ^ bits[187]) ? 12'sd1 : 12'sd0) +
((bits[171] ^ bits[172]) ? -12'sd1 : 12'sd0))))))) +
(((((((bits[171] ^ bits[186]) ? -12'sd1 : 12'sd0) +
(((bits[171] ^ bits[187]) ? -12'sd1 : 12'sd0) +
((bits[171] ^ bits[188]) ? 12'sd1 : 12'sd0))) +
((((bits[172] ^ bits[173]) ? 12'sd1 : 12'sd0) +
((bits[172] ^ bits[187]) ? 12'sd1 : 12'sd0)) +
(((bits[172] ^ bits[188]) ? 12'sd1 : 12'sd0) +
((bits[172] ^ bits[189]) ? -12'sd1 : 12'sd0)))) +
(((((bits[173] ^ bits[174]) ? 12'sd1 : 12'sd0) +
((bits[173] ^ bits[188]) ? 12'sd1 : 12'sd0)) +
(((bits[173] ^ bits[189]) ? -12'sd1 : 12'sd0) +
((bits[173] ^ bits[190]) ? -12'sd1 : 12'sd0))) +
((((bits[174] ^ bits[175]) ? -12'sd1 : 12'sd0) +
((bits[174] ^ bits[189]) ? -12'sd1 : 12'sd0)) +
(((bits[174] ^ bits[190]) ? 12'sd1 : 12'sd0) +
((bits[174] ^ bits[191]) ? -12'sd1 : 12'sd0))))) +
(((((bits[175] ^ bits[190]) ? -12'sd1 : 12'sd0) +
(((bits[175] ^ bits[191]) ? -12'sd1 : 12'sd0) +
((bits[176] ^ bits[177]) ? 12'sd1 : 12'sd0))) +
((((bits[176] ^ bits[192]) ? -12'sd1 : 12'sd0) +
((bits[176] ^ bits[193]) ? 12'sd1 : 12'sd0)) +
(((bits[177] ^ bits[178]) ? 12'sd1 : 12'sd0) +
((bits[177] ^ bits[192]) ? 12'sd1 : 12'sd0)))) +
(((((bits[177] ^ bits[193]) ? 12'sd1 : 12'sd0) +
((bits[177] ^ bits[194]) ? 12'sd1 : 12'sd0)) +
(((bits[178] ^ bits[179]) ? 12'sd1 : 12'sd0) +
((bits[178] ^ bits[193]) ? 12'sd1 : 12'sd0))) +
((((bits[178] ^ bits[194]) ? -12'sd1 : 12'sd0) +
((bits[178] ^ bits[195]) ? 12'sd1 : 12'sd0)) +
(((bits[179] ^ bits[180]) ? -12'sd1 : 12'sd0) +
((bits[179] ^ bits[194]) ? -12'sd1 : 12'sd0)))))) +
((((((bits[179] ^ bits[195]) ? -12'sd1 : 12'sd0) +
(((bits[179] ^ bits[196]) ? 12'sd1 : 12'sd0) +
((bits[180] ^ bits[181]) ? 12'sd1 : 12'sd0))) +
((((bits[180] ^ bits[195]) ? -12'sd1 : 12'sd0) +
((bits[180] ^ bits[196]) ? -12'sd1 : 12'sd0)) +
(((bits[180] ^ bits[197]) ? 12'sd1 : 12'sd0) +
((bits[181] ^ bits[182]) ? -12'sd1 : 12'sd0)))) +
(((((bits[181] ^ bits[196]) ? 12'sd1 : 12'sd0) +
((bits[181] ^ bits[197]) ? -12'sd1 : 12'sd0)) +
(((bits[181] ^ bits[198]) ? -12'sd1 : 12'sd0) +
((bits[182] ^ bits[183]) ? 12'sd1 : 12'sd0))) +
((((bits[182] ^ bits[197]) ? 12'sd1 : 12'sd0) +
((bits[182] ^ bits[198]) ? 12'sd1 : 12'sd0)) +
(((bits[182] ^ bits[199]) ? 12'sd1 : 12'sd0) +
((bits[183] ^ bits[184]) ? 12'sd1 : 12'sd0))))) +
(((((bits[183] ^ bits[198]) ? 12'sd1 : 12'sd0) +
(((bits[183] ^ bits[199]) ? -12'sd1 : 12'sd0) +
((bits[183] ^ bits[200]) ? -12'sd1 : 12'sd0))) +
((((bits[184] ^ bits[185]) ? 12'sd1 : 12'sd0) +
((bits[184] ^ bits[199]) ? 12'sd1 : 12'sd0)) +
(((bits[184] ^ bits[200]) ? -12'sd1 : 12'sd0) +
((bits[184] ^ bits[201]) ? -12'sd1 : 12'sd0)))) +
(((((bits[185] ^ bits[186]) ? 12'sd1 : 12'sd0) +
((bits[185] ^ bits[200]) ? 12'sd1 : 12'sd0)) +
(((bits[185] ^ bits[201]) ? -12'sd1 : 12'sd0) +
((bits[185] ^ bits[202]) ? 12'sd1 : 12'sd0))) +
((((bits[186] ^ bits[187]) ? 12'sd1 : 12'sd0) +
((bits[186] ^ bits[201]) ? 12'sd1 : 12'sd0)) +
(((bits[186] ^ bits[202]) ? 12'sd1 : 12'sd0) +
((bits[186] ^ bits[203]) ? 12'sd1 : 12'sd0))))))))) +
(((((((((bits[187] ^ bits[188]) ? 12'sd1 : 12'sd0) +
(((bits[187] ^ bits[202]) ? -12'sd1 : 12'sd0) +
((bits[187] ^ bits[203]) ? -12'sd1 : 12'sd0))) +
((((bits[187] ^ bits[204]) ? -12'sd1 : 12'sd0) +
((bits[188] ^ bits[189]) ? 12'sd1 : 12'sd0)) +
(((bits[188] ^ bits[203]) ? -12'sd1 : 12'sd0) +
((bits[188] ^ bits[204]) ? 12'sd1 : 12'sd0)))) +
((((bits[188] ^ bits[205]) ? -12'sd1 : 12'sd0) +
(((bits[189] ^ bits[190]) ? 12'sd1 : 12'sd0) +
((bits[189] ^ bits[204]) ? -12'sd1 : 12'sd0))) +
((((bits[189] ^ bits[205]) ? -12'sd1 : 12'sd0) +
((bits[189] ^ bits[206]) ? 12'sd1 : 12'sd0)) +
(((bits[190] ^ bits[191]) ? -12'sd1 : 12'sd0) +
((bits[190] ^ bits[205]) ? -12'sd1 : 12'sd0))))) +
(((((bits[190] ^ bits[206]) ? -12'sd1 : 12'sd0) +
(((bits[190] ^ bits[207]) ? 12'sd1 : 12'sd0) +
((bits[191] ^ bits[206]) ? 12'sd1 : 12'sd0))) +
((((bits[191] ^ bits[207]) ? 12'sd1 : 12'sd0) +
((bits[192] ^ bits[193]) ? 12'sd1 : 12'sd0)) +
(((bits[192] ^ bits[208]) ? 12'sd1 : 12'sd0) +
((bits[192] ^ bits[209]) ? -12'sd1 : 12'sd0)))) +
(((((bits[193] ^ bits[194]) ? -12'sd1 : 12'sd0) +
((bits[193] ^ bits[208]) ? -12'sd1 : 12'sd0)) +
(((bits[193] ^ bits[209]) ? 12'sd1 : 12'sd0) +
((bits[193] ^ bits[210]) ? 12'sd1 : 12'sd0))) +
((((bits[194] ^ bits[195]) ? -12'sd1 : 12'sd0) +
((bits[194] ^ bits[209]) ? 12'sd1 : 12'sd0)) +
(((bits[194] ^ bits[210]) ? -12'sd1 : 12'sd0) +
((bits[194] ^ bits[211]) ? -12'sd1 : 12'sd0)))))) +
((((((bits[195] ^ bits[196]) ? 12'sd1 : 12'sd0) +
(((bits[195] ^ bits[210]) ? -12'sd1 : 12'sd0) +
((bits[195] ^ bits[211]) ? 12'sd1 : 12'sd0))) +
((((bits[195] ^ bits[212]) ? -12'sd1 : 12'sd0) +
((bits[196] ^ bits[197]) ? -12'sd1 : 12'sd0)) +
(((bits[196] ^ bits[211]) ? -12'sd1 : 12'sd0) +
((bits[196] ^ bits[212]) ? -12'sd1 : 12'sd0)))) +
(((((bits[196] ^ bits[213]) ? -12'sd1 : 12'sd0) +
((bits[197] ^ bits[198]) ? 12'sd1 : 12'sd0)) +
(((bits[197] ^ bits[212]) ? 12'sd1 : 12'sd0) +
((bits[197] ^ bits[213]) ? -12'sd1 : 12'sd0))) +
((((bits[197] ^ bits[214]) ? 12'sd1 : 12'sd0) +
((bits[198] ^ bits[199]) ? 12'sd1 : 12'sd0)) +
(((bits[198] ^ bits[213]) ? 12'sd1 : 12'sd0) +
((bits[198] ^ bits[214]) ? 12'sd1 : 12'sd0))))) +
(((((bits[198] ^ bits[215]) ? -12'sd1 : 12'sd0) +
(((bits[199] ^ bits[200]) ? -12'sd1 : 12'sd0) +
((bits[199] ^ bits[214]) ? 12'sd1 : 12'sd0))) +
((((bits[199] ^ bits[215]) ? -12'sd1 : 12'sd0) +
((bits[199] ^ bits[216]) ? -12'sd1 : 12'sd0)) +
(((bits[200] ^ bits[201]) ? -12'sd1 : 12'sd0) +
((bits[200] ^ bits[215]) ? -12'sd1 : 12'sd0)))) +
(((((bits[200] ^ bits[216]) ? -12'sd1 : 12'sd0) +
((bits[200] ^ bits[217]) ? -12'sd1 : 12'sd0)) +
(((bits[201] ^ bits[202]) ? 12'sd1 : 12'sd0) +
((bits[201] ^ bits[216]) ? 12'sd1 : 12'sd0))) +
((((bits[201] ^ bits[217]) ? -12'sd1 : 12'sd0) +
((bits[201] ^ bits[218]) ? 12'sd1 : 12'sd0)) +
(((bits[202] ^ bits[203]) ? 12'sd1 : 12'sd0) +
((bits[202] ^ bits[217]) ? 12'sd1 : 12'sd0))))))) +
(((((((bits[202] ^ bits[218]) ? -12'sd1 : 12'sd0) +
(((bits[202] ^ bits[219]) ? 12'sd1 : 12'sd0) +
((bits[203] ^ bits[204]) ? 12'sd1 : 12'sd0))) +
((((bits[203] ^ bits[218]) ? 12'sd1 : 12'sd0) +
((bits[203] ^ bits[219]) ? -12'sd1 : 12'sd0)) +
(((bits[203] ^ bits[220]) ? -12'sd1 : 12'sd0) +
((bits[204] ^ bits[205]) ? -12'sd1 : 12'sd0)))) +
(((((bits[204] ^ bits[219]) ? 12'sd1 : 12'sd0) +
((bits[204] ^ bits[220]) ? -12'sd1 : 12'sd0)) +
(((bits[204] ^ bits[221]) ? -12'sd1 : 12'sd0) +
((bits[205] ^ bits[206]) ? 12'sd1 : 12'sd0))) +
((((bits[205] ^ bits[220]) ? -12'sd1 : 12'sd0) +
((bits[205] ^ bits[221]) ? -12'sd1 : 12'sd0)) +
(((bits[205] ^ bits[222]) ? 12'sd1 : 12'sd0) +
((bits[206] ^ bits[207]) ? -12'sd1 : 12'sd0))))) +
(((((bits[206] ^ bits[221]) ? -12'sd1 : 12'sd0) +
(((bits[206] ^ bits[222]) ? -12'sd1 : 12'sd0) +
((bits[206] ^ bits[223]) ? -12'sd1 : 12'sd0))) +
((((bits[207] ^ bits[222]) ? 12'sd1 : 12'sd0) +
((bits[207] ^ bits[223]) ? -12'sd1 : 12'sd0)) +
(((bits[208] ^ bits[209]) ? 12'sd1 : 12'sd0) +
((bits[208] ^ bits[224]) ? -12'sd1 : 12'sd0)))) +
(((((bits[208] ^ bits[225]) ? 12'sd1 : 12'sd0) +
((bits[209] ^ bits[210]) ? 12'sd1 : 12'sd0)) +
(((bits[209] ^ bits[224]) ? -12'sd1 : 12'sd0) +
((bits[209] ^ bits[225]) ? -12'sd1 : 12'sd0))) +
((((bits[209] ^ bits[226]) ? 12'sd1 : 12'sd0) +
((bits[210] ^ bits[211]) ? -12'sd1 : 12'sd0)) +
(((bits[210] ^ bits[225]) ? -12'sd1 : 12'sd0) +
((bits[210] ^ bits[226]) ? -12'sd1 : 12'sd0)))))) +
((((((bits[210] ^ bits[227]) ? -12'sd1 : 12'sd0) +
(((bits[211] ^ bits[212]) ? -12'sd1 : 12'sd0) +
((bits[211] ^ bits[226]) ? 12'sd1 : 12'sd0))) +
((((bits[211] ^ bits[227]) ? 12'sd1 : 12'sd0) +
((bits[211] ^ bits[228]) ? 12'sd1 : 12'sd0)) +
(((bits[212] ^ bits[213]) ? -12'sd1 : 12'sd0) +
((bits[212] ^ bits[227]) ? -12'sd1 : 12'sd0)))) +
(((((bits[212] ^ bits[228]) ? 12'sd1 : 12'sd0) +
((bits[212] ^ bits[229]) ? 12'sd1 : 12'sd0)) +
(((bits[213] ^ bits[214]) ? 12'sd1 : 12'sd0) +
((bits[213] ^ bits[228]) ? 12'sd1 : 12'sd0))) +
((((bits[213] ^ bits[229]) ? 12'sd1 : 12'sd0) +
((bits[213] ^ bits[230]) ? 12'sd1 : 12'sd0)) +
(((bits[214] ^ bits[215]) ? -12'sd1 : 12'sd0) +
((bits[214] ^ bits[229]) ? -12'sd1 : 12'sd0))))) +
(((((bits[214] ^ bits[230]) ? -12'sd1 : 12'sd0) +
(((bits[214] ^ bits[231]) ? -12'sd1 : 12'sd0) +
((bits[215] ^ bits[216]) ? -12'sd1 : 12'sd0))) +
((((bits[215] ^ bits[230]) ? 12'sd1 : 12'sd0) +
((bits[215] ^ bits[231]) ? 12'sd1 : 12'sd0)) +
(((bits[215] ^ bits[232]) ? 12'sd1 : 12'sd0) +
((bits[216] ^ bits[217]) ? -12'sd1 : 12'sd0)))) +
(((((bits[216] ^ bits[231]) ? 12'sd1 : 12'sd0) +
((bits[216] ^ bits[232]) ? 12'sd1 : 12'sd0)) +
(((bits[216] ^ bits[233]) ? 12'sd1 : 12'sd0) +
((bits[217] ^ bits[218]) ? 12'sd1 : 12'sd0))) +
((((bits[217] ^ bits[232]) ? 12'sd1 : 12'sd0) +
((bits[217] ^ bits[233]) ? 12'sd1 : 12'sd0)) +
(((bits[217] ^ bits[234]) ? -12'sd1 : 12'sd0) +
((bits[218] ^ bits[219]) ? -12'sd1 : 12'sd0)))))))) +
((((((((bits[218] ^ bits[233]) ? -12'sd1 : 12'sd0) +
(((bits[218] ^ bits[234]) ? 12'sd1 : 12'sd0) +
((bits[218] ^ bits[235]) ? 12'sd1 : 12'sd0))) +
((((bits[219] ^ bits[220]) ? 12'sd1 : 12'sd0) +
((bits[219] ^ bits[234]) ? 12'sd1 : 12'sd0)) +
(((bits[219] ^ bits[235]) ? 12'sd1 : 12'sd0) +
((bits[219] ^ bits[236]) ? -12'sd1 : 12'sd0)))) +
(((((bits[220] ^ bits[221]) ? -12'sd1 : 12'sd0) +
((bits[220] ^ bits[235]) ? -12'sd1 : 12'sd0)) +
(((bits[220] ^ bits[236]) ? -12'sd1 : 12'sd0) +
((bits[220] ^ bits[237]) ? -12'sd1 : 12'sd0))) +
((((bits[221] ^ bits[222]) ? -12'sd1 : 12'sd0) +
((bits[221] ^ bits[236]) ? -12'sd1 : 12'sd0)) +
(((bits[221] ^ bits[237]) ? 12'sd1 : 12'sd0) +
((bits[221] ^ bits[238]) ? 12'sd1 : 12'sd0))))) +
(((((bits[222] ^ bits[223]) ? -12'sd1 : 12'sd0) +
(((bits[222] ^ bits[237]) ? -12'sd1 : 12'sd0) +
((bits[222] ^ bits[238]) ? 12'sd1 : 12'sd0))) +
((((bits[222] ^ bits[239]) ? 12'sd1 : 12'sd0) +
((bits[223] ^ bits[238]) ? 12'sd1 : 12'sd0)) +
(((bits[223] ^ bits[239]) ? 12'sd1 : 12'sd0) +
((bits[224] ^ bits[225]) ? 12'sd1 : 12'sd0)))) +
(((((bits[224] ^ bits[240]) ? -12'sd1 : 12'sd0) +
((bits[224] ^ bits[241]) ? 12'sd1 : 12'sd0)) +
(((bits[225] ^ bits[226]) ? 12'sd1 : 12'sd0) +
((bits[225] ^ bits[240]) ? -12'sd1 : 12'sd0))) +
((((bits[225] ^ bits[241]) ? 12'sd1 : 12'sd0) +
((bits[225] ^ bits[242]) ? -12'sd1 : 12'sd0)) +
(((bits[226] ^ bits[227]) ? -12'sd1 : 12'sd0) +
((bits[226] ^ bits[241]) ? 12'sd1 : 12'sd0)))))) +
((((((bits[226] ^ bits[242]) ? -12'sd1 : 12'sd0) +
(((bits[226] ^ bits[243]) ? -12'sd1 : 12'sd0) +
((bits[227] ^ bits[228]) ? -12'sd1 : 12'sd0))) +
((((bits[227] ^ bits[242]) ? -12'sd1 : 12'sd0) +
((bits[227] ^ bits[243]) ? 12'sd1 : 12'sd0)) +
(((bits[227] ^ bits[244]) ? -12'sd1 : 12'sd0) +
((bits[228] ^ bits[229]) ? 12'sd1 : 12'sd0)))) +
(((((bits[228] ^ bits[243]) ? 12'sd1 : 12'sd0) +
((bits[228] ^ bits[244]) ? -12'sd1 : 12'sd0)) +
(((bits[228] ^ bits[245]) ? 12'sd1 : 12'sd0) +
((bits[229] ^ bits[230]) ? -12'sd1 : 12'sd0))) +
((((bits[229] ^ bits[244]) ? 12'sd1 : 12'sd0) +
((bits[229] ^ bits[245]) ? -12'sd1 : 12'sd0)) +
(((bits[229] ^ bits[246]) ? -12'sd1 : 12'sd0) +
((bits[230] ^ bits[231]) ? 12'sd1 : 12'sd0))))) +
(((((bits[230] ^ bits[245]) ? 12'sd1 : 12'sd0) +
(((bits[230] ^ bits[246]) ? -12'sd1 : 12'sd0) +
((bits[230] ^ bits[247]) ? 12'sd1 : 12'sd0))) +
((((bits[231] ^ bits[232]) ? 12'sd1 : 12'sd0) +
((bits[231] ^ bits[246]) ? 12'sd1 : 12'sd0)) +
(((bits[231] ^ bits[247]) ? 12'sd1 : 12'sd0) +
((bits[231] ^ bits[248]) ? 12'sd1 : 12'sd0)))) +
(((((bits[232] ^ bits[233]) ? 12'sd1 : 12'sd0) +
((bits[232] ^ bits[247]) ? -12'sd1 : 12'sd0)) +
(((bits[232] ^ bits[248]) ? 12'sd1 : 12'sd0) +
((bits[232] ^ bits[249]) ? 12'sd1 : 12'sd0))) +
((((bits[233] ^ bits[234]) ? -12'sd1 : 12'sd0) +
((bits[233] ^ bits[248]) ? -12'sd1 : 12'sd0)) +
(((bits[233] ^ bits[249]) ? -12'sd1 : 12'sd0) +
((bits[233] ^ bits[250]) ? 12'sd1 : 12'sd0))))))) +
(((((((bits[234] ^ bits[235]) ? -12'sd1 : 12'sd0) +
(((bits[234] ^ bits[249]) ? 12'sd1 : 12'sd0) +
((bits[234] ^ bits[250]) ? 12'sd1 : 12'sd0))) +
((((bits[234] ^ bits[251]) ? 12'sd1 : 12'sd0) +
((bits[235] ^ bits[236]) ? 12'sd1 : 12'sd0)) +
(((bits[235] ^ bits[250]) ? 12'sd1 : 12'sd0) +
((bits[235] ^ bits[251]) ? -12'sd1 : 12'sd0)))) +
(((((bits[235] ^ bits[252]) ? -12'sd1 : 12'sd0) +
((bits[236] ^ bits[237]) ? -12'sd1 : 12'sd0)) +
(((bits[236] ^ bits[251]) ? -12'sd1 : 12'sd0) +
((bits[236] ^ bits[252]) ? 12'sd1 : 12'sd0))) +
((((bits[236] ^ bits[253]) ? -12'sd1 : 12'sd0) +
((bits[237] ^ bits[238]) ? -12'sd1 : 12'sd0)) +
(((bits[237] ^ bits[252]) ? -12'sd1 : 12'sd0) +
((bits[237] ^ bits[253]) ? -12'sd1 : 12'sd0))))) +
(((((bits[237] ^ bits[254]) ? -12'sd1 : 12'sd0) +
(((bits[238] ^ bits[239]) ? -12'sd1 : 12'sd0) +
((bits[238] ^ bits[253]) ? -12'sd1 : 12'sd0))) +
((((bits[238] ^ bits[254]) ? 12'sd1 : 12'sd0) +
((bits[238] ^ bits[255]) ? -12'sd1 : 12'sd0)) +
(((bits[239] ^ bits[254]) ? 12'sd1 : 12'sd0) +
((bits[239] ^ bits[255]) ? -12'sd1 : 12'sd0)))) +
(((((bits[240] ^ bits[241]) ? -12'sd1 : 12'sd0) +
((bits[240] ^ bits[256]) ? -12'sd1 : 12'sd0)) +
(((bits[240] ^ bits[257]) ? 12'sd1 : 12'sd0) +
((bits[241] ^ bits[242]) ? 12'sd1 : 12'sd0))) +
((((bits[241] ^ bits[256]) ? -12'sd1 : 12'sd0) +
((bits[241] ^ bits[257]) ? -12'sd1 : 12'sd0)) +
(((bits[241] ^ bits[258]) ? 12'sd1 : 12'sd0) +
((bits[242] ^ bits[243]) ? 12'sd1 : 12'sd0)))))) +
((((((bits[242] ^ bits[257]) ? 12'sd1 : 12'sd0) +
(((bits[242] ^ bits[258]) ? -12'sd1 : 12'sd0) +
((bits[242] ^ bits[259]) ? 12'sd1 : 12'sd0))) +
((((bits[243] ^ bits[244]) ? -12'sd1 : 12'sd0) +
((bits[243] ^ bits[258]) ? 12'sd1 : 12'sd0)) +
(((bits[243] ^ bits[259]) ? -12'sd1 : 12'sd0) +
((bits[243] ^ bits[260]) ? -12'sd1 : 12'sd0)))) +
(((((bits[244] ^ bits[245]) ? -12'sd1 : 12'sd0) +
((bits[244] ^ bits[259]) ? -12'sd1 : 12'sd0)) +
(((bits[244] ^ bits[260]) ? -12'sd1 : 12'sd0) +
((bits[244] ^ bits[261]) ? -12'sd1 : 12'sd0))) +
((((bits[245] ^ bits[246]) ? -12'sd1 : 12'sd0) +
((bits[245] ^ bits[260]) ? 12'sd1 : 12'sd0)) +
(((bits[245] ^ bits[261]) ? 12'sd1 : 12'sd0) +
((bits[245] ^ bits[262]) ? -12'sd1 : 12'sd0))))) +
(((((bits[246] ^ bits[247]) ? 12'sd1 : 12'sd0) +
(((bits[246] ^ bits[261]) ? -12'sd1 : 12'sd0) +
((bits[246] ^ bits[262]) ? 12'sd1 : 12'sd0))) +
((((bits[246] ^ bits[263]) ? -12'sd1 : 12'sd0) +
((bits[247] ^ bits[248]) ? 12'sd1 : 12'sd0)) +
(((bits[247] ^ bits[262]) ? -12'sd1 : 12'sd0) +
((bits[247] ^ bits[263]) ? 12'sd1 : 12'sd0)))) +
(((((bits[247] ^ bits[264]) ? 12'sd1 : 12'sd0) +
((bits[248] ^ bits[249]) ? -12'sd1 : 12'sd0)) +
(((bits[248] ^ bits[263]) ? -12'sd1 : 12'sd0) +
((bits[248] ^ bits[264]) ? -12'sd1 : 12'sd0))) +
((((bits[248] ^ bits[265]) ? 12'sd1 : 12'sd0) +
((bits[249] ^ bits[250]) ? 12'sd1 : 12'sd0)) +
(((bits[249] ^ bits[264]) ? 12'sd1 : 12'sd0) +
((bits[249] ^ bits[265]) ? 12'sd1 : 12'sd0))))))))))) +
(((((((((((bits[249] ^ bits[266]) ? -12'sd1 : 12'sd0) +
(((bits[250] ^ bits[251]) ? -12'sd1 : 12'sd0) +
((bits[250] ^ bits[265]) ? 12'sd1 : 12'sd0))) +
((((bits[250] ^ bits[266]) ? 12'sd1 : 12'sd0) +
((bits[250] ^ bits[267]) ? -12'sd1 : 12'sd0)) +
(((bits[251] ^ bits[252]) ? -12'sd1 : 12'sd0) +
((bits[251] ^ bits[266]) ? -12'sd1 : 12'sd0)))) +
((((bits[251] ^ bits[267]) ? -12'sd1 : 12'sd0) +
(((bits[251] ^ bits[268]) ? -12'sd1 : 12'sd0) +
((bits[252] ^ bits[253]) ? 12'sd1 : 12'sd0))) +
((((bits[252] ^ bits[267]) ? -12'sd1 : 12'sd0) +
((bits[252] ^ bits[268]) ? -12'sd1 : 12'sd0)) +
(((bits[252] ^ bits[269]) ? 12'sd1 : 12'sd0) +
((bits[253] ^ bits[254]) ? 12'sd1 : 12'sd0))))) +
(((((bits[253] ^ bits[268]) ? -12'sd1 : 12'sd0) +
(((bits[253] ^ bits[269]) ? -12'sd1 : 12'sd0) +
((bits[253] ^ bits[270]) ? -12'sd1 : 12'sd0))) +
((((bits[254] ^ bits[255]) ? 12'sd1 : 12'sd0) +
((bits[254] ^ bits[269]) ? 12'sd1 : 12'sd0)) +
(((bits[254] ^ bits[270]) ? 12'sd1 : 12'sd0) +
((bits[254] ^ bits[271]) ? -12'sd1 : 12'sd0)))) +
(((((bits[255] ^ bits[270]) ? -12'sd1 : 12'sd0) +
((bits[255] ^ bits[271]) ? 12'sd1 : 12'sd0)) +
(((bits[256] ^ bits[257]) ? 12'sd1 : 12'sd0) +
((bits[256] ^ bits[272]) ? -12'sd1 : 12'sd0))) +
((((bits[256] ^ bits[273]) ? 12'sd1 : 12'sd0) +
((bits[257] ^ bits[258]) ? -12'sd1 : 12'sd0)) +
(((bits[257] ^ bits[272]) ? -12'sd1 : 12'sd0) +
((bits[257] ^ bits[273]) ? 12'sd1 : 12'sd0)))))) +
((((((bits[257] ^ bits[274]) ? -12'sd1 : 12'sd0) +
(((bits[258] ^ bits[259]) ? -12'sd1 : 12'sd0) +
((bits[258] ^ bits[273]) ? -12'sd1 : 12'sd0))) +
((((bits[258] ^ bits[274]) ? 12'sd1 : 12'sd0) +
((bits[258] ^ bits[275]) ? -12'sd1 : 12'sd0)) +
(((bits[259] ^ bits[260]) ? 12'sd1 : 12'sd0) +
((bits[259] ^ bits[274]) ? 12'sd1 : 12'sd0)))) +
(((((bits[259] ^ bits[275]) ? 12'sd1 : 12'sd0) +
((bits[259] ^ bits[276]) ? -12'sd1 : 12'sd0)) +
(((bits[260] ^ bits[261]) ? -12'sd1 : 12'sd0) +
((bits[260] ^ bits[275]) ? -12'sd1 : 12'sd0))) +
((((bits[260] ^ bits[276]) ? -12'sd1 : 12'sd0) +
((bits[260] ^ bits[277]) ? 12'sd1 : 12'sd0)) +
(((bits[261] ^ bits[262]) ? -12'sd1 : 12'sd0) +
((bits[261] ^ bits[276]) ? 12'sd1 : 12'sd0))))) +
(((((bits[261] ^ bits[277]) ? -12'sd1 : 12'sd0) +
(((bits[261] ^ bits[278]) ? 12'sd1 : 12'sd0) +
((bits[262] ^ bits[263]) ? 12'sd1 : 12'sd0))) +
((((bits[262] ^ bits[277]) ? -12'sd1 : 12'sd0) +
((bits[262] ^ bits[278]) ? -12'sd1 : 12'sd0)) +
(((bits[262] ^ bits[279]) ? 12'sd1 : 12'sd0) +
((bits[263] ^ bits[264]) ? -12'sd1 : 12'sd0)))) +
(((((bits[263] ^ bits[278]) ? 12'sd1 : 12'sd0) +
((bits[263] ^ bits[279]) ? 12'sd1 : 12'sd0)) +
(((bits[263] ^ bits[280]) ? -12'sd1 : 12'sd0) +
((bits[264] ^ bits[265]) ? 12'sd1 : 12'sd0))) +
((((bits[264] ^ bits[279]) ? 12'sd1 : 12'sd0) +
((bits[264] ^ bits[280]) ? 12'sd1 : 12'sd0)) +
(((bits[264] ^ bits[281]) ? -12'sd1 : 12'sd0) +
((bits[265] ^ bits[266]) ? 12'sd1 : 12'sd0))))))) +
(((((((bits[265] ^ bits[280]) ? -12'sd1 : 12'sd0) +
(((bits[265] ^ bits[281]) ? 12'sd1 : 12'sd0) +
((bits[265] ^ bits[282]) ? -12'sd1 : 12'sd0))) +
((((bits[266] ^ bits[267]) ? 12'sd1 : 12'sd0) +
((bits[266] ^ bits[281]) ? 12'sd1 : 12'sd0)) +
(((bits[266] ^ bits[282]) ? -12'sd1 : 12'sd0) +
((bits[266] ^ bits[283]) ? -12'sd1 : 12'sd0)))) +
(((((bits[267] ^ bits[268]) ? -12'sd1 : 12'sd0) +
((bits[267] ^ bits[282]) ? 12'sd1 : 12'sd0)) +
(((bits[267] ^ bits[283]) ? -12'sd1 : 12'sd0) +
((bits[267] ^ bits[284]) ? -12'sd1 : 12'sd0))) +
((((bits[268] ^ bits[269]) ? -12'sd1 : 12'sd0) +
((bits[268] ^ bits[283]) ? 12'sd1 : 12'sd0)) +
(((bits[268] ^ bits[284]) ? -12'sd1 : 12'sd0) +
((bits[268] ^ bits[285]) ? -12'sd1 : 12'sd0))))) +
(((((bits[269] ^ bits[270]) ? -12'sd1 : 12'sd0) +
(((bits[269] ^ bits[284]) ? -12'sd1 : 12'sd0) +
((bits[269] ^ bits[285]) ? -12'sd1 : 12'sd0))) +
((((bits[269] ^ bits[286]) ? -12'sd1 : 12'sd0) +
((bits[270] ^ bits[271]) ? -12'sd1 : 12'sd0)) +
(((bits[270] ^ bits[285]) ? -12'sd1 : 12'sd0) +
((bits[270] ^ bits[286]) ? 12'sd1 : 12'sd0)))) +
(((((bits[270] ^ bits[287]) ? 12'sd1 : 12'sd0) +
((bits[271] ^ bits[286]) ? -12'sd1 : 12'sd0)) +
(((bits[271] ^ bits[287]) ? 12'sd1 : 12'sd0) +
((bits[272] ^ bits[273]) ? -12'sd1 : 12'sd0))) +
((((bits[272] ^ bits[288]) ? -12'sd1 : 12'sd0) +
((bits[272] ^ bits[289]) ? 12'sd1 : 12'sd0)) +
(((bits[273] ^ bits[274]) ? -12'sd1 : 12'sd0) +
((bits[273] ^ bits[288]) ? -12'sd1 : 12'sd0)))))) +
((((((bits[273] ^ bits[289]) ? -12'sd1 : 12'sd0) +
(((bits[273] ^ bits[290]) ? -12'sd1 : 12'sd0) +
((bits[274] ^ bits[275]) ? -12'sd1 : 12'sd0))) +
((((bits[274] ^ bits[289]) ? -12'sd1 : 12'sd0) +
((bits[274] ^ bits[290]) ? 12'sd1 : 12'sd0)) +
(((bits[274] ^ bits[291]) ? -12'sd1 : 12'sd0) +
((bits[275] ^ bits[276]) ? -12'sd1 : 12'sd0)))) +
(((((bits[275] ^ bits[290]) ? -12'sd1 : 12'sd0) +
((bits[275] ^ bits[291]) ? 12'sd1 : 12'sd0)) +
(((bits[275] ^ bits[292]) ? -12'sd1 : 12'sd0) +
((bits[276] ^ bits[277]) ? 12'sd1 : 12'sd0))) +
((((bits[276] ^ bits[291]) ? 12'sd1 : 12'sd0) +
((bits[276] ^ bits[292]) ? -12'sd1 : 12'sd0)) +
(((bits[276] ^ bits[293]) ? -12'sd1 : 12'sd0) +
((bits[277] ^ bits[278]) ? -12'sd1 : 12'sd0))))) +
(((((bits[277] ^ bits[292]) ? 12'sd1 : 12'sd0) +
(((bits[277] ^ bits[293]) ? -12'sd1 : 12'sd0) +
((bits[277] ^ bits[294]) ? -12'sd1 : 12'sd0))) +
((((bits[278] ^ bits[279]) ? 12'sd1 : 12'sd0) +
((bits[278] ^ bits[293]) ? -12'sd1 : 12'sd0)) +
(((bits[278] ^ bits[294]) ? -12'sd1 : 12'sd0) +
((bits[278] ^ bits[295]) ? -12'sd1 : 12'sd0)))) +
(((((bits[279] ^ bits[280]) ? 12'sd1 : 12'sd0) +
((bits[279] ^ bits[294]) ? 12'sd1 : 12'sd0)) +
(((bits[279] ^ bits[295]) ? -12'sd1 : 12'sd0) +
((bits[279] ^ bits[296]) ? -12'sd1 : 12'sd0))) +
((((bits[280] ^ bits[281]) ? 12'sd1 : 12'sd0) +
((bits[280] ^ bits[295]) ? -12'sd1 : 12'sd0)) +
(((bits[280] ^ bits[296]) ? -12'sd1 : 12'sd0) +
((bits[280] ^ bits[297]) ? -12'sd1 : 12'sd0)))))))) +
((((((((bits[281] ^ bits[282]) ? -12'sd1 : 12'sd0) +
(((bits[281] ^ bits[296]) ? -12'sd1 : 12'sd0) +
((bits[281] ^ bits[297]) ? 12'sd1 : 12'sd0))) +
((((bits[281] ^ bits[298]) ? -12'sd1 : 12'sd0) +
((bits[282] ^ bits[283]) ? 12'sd1 : 12'sd0)) +
(((bits[282] ^ bits[297]) ? 12'sd1 : 12'sd0) +
((bits[282] ^ bits[298]) ? -12'sd1 : 12'sd0)))) +
((((bits[282] ^ bits[299]) ? -12'sd1 : 12'sd0) +
(((bits[283] ^ bits[284]) ? -12'sd1 : 12'sd0) +
((bits[283] ^ bits[298]) ? 12'sd1 : 12'sd0))) +
((((bits[283] ^ bits[299]) ? 12'sd1 : 12'sd0) +
((bits[283] ^ bits[300]) ? 12'sd1 : 12'sd0)) +
(((bits[284] ^ bits[285]) ? 12'sd1 : 12'sd0) +
((bits[284] ^ bits[299]) ? -12'sd1 : 12'sd0))))) +
(((((bits[284] ^ bits[300]) ? -12'sd1 : 12'sd0) +
(((bits[284] ^ bits[301]) ? -12'sd1 : 12'sd0) +
((bits[285] ^ bits[286]) ? -12'sd1 : 12'sd0))) +
((((bits[285] ^ bits[300]) ? -12'sd1 : 12'sd0) +
((bits[285] ^ bits[301]) ? -12'sd1 : 12'sd0)) +
(((bits[285] ^ bits[302]) ? 12'sd1 : 12'sd0) +
((bits[286] ^ bits[287]) ? -12'sd1 : 12'sd0)))) +
(((((bits[286] ^ bits[301]) ? 12'sd1 : 12'sd0) +
((bits[286] ^ bits[302]) ? -12'sd1 : 12'sd0)) +
(((bits[286] ^ bits[303]) ? -12'sd1 : 12'sd0) +
((bits[287] ^ bits[302]) ? 12'sd1 : 12'sd0))) +
((((bits[287] ^ bits[303]) ? -12'sd1 : 12'sd0) +
((bits[288] ^ bits[289]) ? -12'sd1 : 12'sd0)) +
(((bits[288] ^ bits[304]) ? -12'sd1 : 12'sd0) +
((bits[288] ^ bits[305]) ? -12'sd1 : 12'sd0)))))) +
((((((bits[289] ^ bits[290]) ? -12'sd1 : 12'sd0) +
(((bits[289] ^ bits[304]) ? 12'sd1 : 12'sd0) +
((bits[289] ^ bits[305]) ? 12'sd1 : 12'sd0))) +
((((bits[289] ^ bits[306]) ? -12'sd1 : 12'sd0) +
((bits[290] ^ bits[291]) ? 12'sd1 : 12'sd0)) +
(((bits[290] ^ bits[305]) ? 12'sd1 : 12'sd0) +
((bits[290] ^ bits[306]) ? 12'sd1 : 12'sd0)))) +
(((((bits[290] ^ bits[307]) ? -12'sd1 : 12'sd0) +
((bits[291] ^ bits[292]) ? -12'sd1 : 12'sd0)) +
(((bits[291] ^ bits[306]) ? -12'sd1 : 12'sd0) +
((bits[291] ^ bits[307]) ? 12'sd1 : 12'sd0))) +
((((bits[291] ^ bits[308]) ? -12'sd1 : 12'sd0) +
((bits[292] ^ bits[293]) ? 12'sd1 : 12'sd0)) +
(((bits[292] ^ bits[307]) ? -12'sd1 : 12'sd0) +
((bits[292] ^ bits[308]) ? 12'sd1 : 12'sd0))))) +
(((((bits[292] ^ bits[309]) ? -12'sd1 : 12'sd0) +
(((bits[293] ^ bits[294]) ? 12'sd1 : 12'sd0) +
((bits[293] ^ bits[308]) ? 12'sd1 : 12'sd0))) +
((((bits[293] ^ bits[309]) ? -12'sd1 : 12'sd0) +
((bits[293] ^ bits[310]) ? 12'sd1 : 12'sd0)) +
(((bits[294] ^ bits[295]) ? -12'sd1 : 12'sd0) +
((bits[294] ^ bits[309]) ? 12'sd1 : 12'sd0)))) +
(((((bits[294] ^ bits[310]) ? 12'sd1 : 12'sd0) +
((bits[294] ^ bits[311]) ? 12'sd1 : 12'sd0)) +
(((bits[295] ^ bits[296]) ? 12'sd1 : 12'sd0) +
((bits[295] ^ bits[310]) ? -12'sd1 : 12'sd0))) +
((((bits[295] ^ bits[311]) ? 12'sd1 : 12'sd0) +
((bits[295] ^ bits[312]) ? -12'sd1 : 12'sd0)) +
(((bits[296] ^ bits[297]) ? 12'sd1 : 12'sd0) +
((bits[296] ^ bits[311]) ? -12'sd1 : 12'sd0))))))) +
(((((((bits[296] ^ bits[312]) ? 12'sd1 : 12'sd0) +
(((bits[296] ^ bits[313]) ? -12'sd1 : 12'sd0) +
((bits[297] ^ bits[298]) ? 12'sd1 : 12'sd0))) +
((((bits[297] ^ bits[312]) ? 12'sd1 : 12'sd0) +
((bits[297] ^ bits[313]) ? 12'sd1 : 12'sd0)) +
(((bits[297] ^ bits[314]) ? 12'sd1 : 12'sd0) +
((bits[298] ^ bits[299]) ? 12'sd1 : 12'sd0)))) +
(((((bits[298] ^ bits[313]) ? 12'sd1 : 12'sd0) +
((bits[298] ^ bits[314]) ? 12'sd1 : 12'sd0)) +
(((bits[298] ^ bits[315]) ? -12'sd1 : 12'sd0) +
((bits[299] ^ bits[300]) ? -12'sd1 : 12'sd0))) +
((((bits[299] ^ bits[314]) ? -12'sd1 : 12'sd0) +
((bits[299] ^ bits[315]) ? -12'sd1 : 12'sd0)) +
(((bits[299] ^ bits[316]) ? -12'sd1 : 12'sd0) +
((bits[300] ^ bits[301]) ? 12'sd1 : 12'sd0))))) +
(((((bits[300] ^ bits[315]) ? -12'sd1 : 12'sd0) +
(((bits[300] ^ bits[316]) ? 12'sd1 : 12'sd0) +
((bits[300] ^ bits[317]) ? -12'sd1 : 12'sd0))) +
((((bits[301] ^ bits[302]) ? -12'sd1 : 12'sd0) +
((bits[301] ^ bits[316]) ? -12'sd1 : 12'sd0)) +
(((bits[301] ^ bits[317]) ? 12'sd1 : 12'sd0) +
((bits[301] ^ bits[318]) ? 12'sd1 : 12'sd0)))) +
(((((bits[302] ^ bits[303]) ? -12'sd1 : 12'sd0) +
((bits[302] ^ bits[317]) ? -12'sd1 : 12'sd0)) +
(((bits[302] ^ bits[318]) ? -12'sd1 : 12'sd0) +
((bits[302] ^ bits[319]) ? -12'sd1 : 12'sd0))) +
((((bits[303] ^ bits[318]) ? 12'sd1 : 12'sd0) +
((bits[303] ^ bits[319]) ? -12'sd1 : 12'sd0)) +
(((bits[304] ^ bits[305]) ? -12'sd1 : 12'sd0) +
((bits[304] ^ bits[320]) ? 12'sd1 : 12'sd0)))))) +
((((((bits[304] ^ bits[321]) ? 12'sd1 : 12'sd0) +
(((bits[305] ^ bits[306]) ? -12'sd1 : 12'sd0) +
((bits[305] ^ bits[320]) ? -12'sd1 : 12'sd0))) +
((((bits[305] ^ bits[321]) ? -12'sd1 : 12'sd0) +
((bits[305] ^ bits[322]) ? -12'sd1 : 12'sd0)) +
(((bits[306] ^ bits[307]) ? -12'sd1 : 12'sd0) +
((bits[306] ^ bits[321]) ? 12'sd1 : 12'sd0)))) +
(((((bits[306] ^ bits[322]) ? 12'sd1 : 12'sd0) +
((bits[306] ^ bits[323]) ? -12'sd1 : 12'sd0)) +
(((bits[307] ^ bits[308]) ? -12'sd1 : 12'sd0) +
((bits[307] ^ bits[322]) ? 12'sd1 : 12'sd0))) +
((((bits[307] ^ bits[323]) ? 12'sd1 : 12'sd0) +
((bits[307] ^ bits[324]) ? 12'sd1 : 12'sd0)) +
(((bits[308] ^ bits[309]) ? 12'sd1 : 12'sd0) +
((bits[308] ^ bits[323]) ? -12'sd1 : 12'sd0))))) +
(((((bits[308] ^ bits[324]) ? -12'sd1 : 12'sd0) +
(((bits[308] ^ bits[325]) ? 12'sd1 : 12'sd0) +
((bits[309] ^ bits[310]) ? -12'sd1 : 12'sd0))) +
((((bits[309] ^ bits[324]) ? -12'sd1 : 12'sd0) +
((bits[309] ^ bits[325]) ? -12'sd1 : 12'sd0)) +
(((bits[309] ^ bits[326]) ? -12'sd1 : 12'sd0) +
((bits[310] ^ bits[311]) ? 12'sd1 : 12'sd0)))) +
(((((bits[310] ^ bits[325]) ? -12'sd1 : 12'sd0) +
((bits[310] ^ bits[326]) ? -12'sd1 : 12'sd0)) +
(((bits[310] ^ bits[327]) ? -12'sd1 : 12'sd0) +
((bits[311] ^ bits[312]) ? 12'sd1 : 12'sd0))) +
((((bits[311] ^ bits[326]) ? 12'sd1 : 12'sd0) +
((bits[311] ^ bits[327]) ? 12'sd1 : 12'sd0)) +
(((bits[311] ^ bits[328]) ? -12'sd1 : 12'sd0) +
((bits[312] ^ bits[313]) ? -12'sd1 : 12'sd0))))))))) +
(((((((((bits[312] ^ bits[327]) ? 12'sd1 : 12'sd0) +
(((bits[312] ^ bits[328]) ? 12'sd1 : 12'sd0) +
((bits[312] ^ bits[329]) ? 12'sd1 : 12'sd0))) +
((((bits[313] ^ bits[314]) ? 12'sd1 : 12'sd0) +
((bits[313] ^ bits[328]) ? -12'sd1 : 12'sd0)) +
(((bits[313] ^ bits[329]) ? 12'sd1 : 12'sd0) +
((bits[313] ^ bits[330]) ? 12'sd1 : 12'sd0)))) +
((((bits[314] ^ bits[315]) ? 12'sd1 : 12'sd0) +
(((bits[314] ^ bits[329]) ? -12'sd1 : 12'sd0) +
((bits[314] ^ bits[330]) ? 12'sd1 : 12'sd0))) +
((((bits[314] ^ bits[331]) ? -12'sd1 : 12'sd0) +
((bits[315] ^ bits[316]) ? -12'sd1 : 12'sd0)) +
(((bits[315] ^ bits[330]) ? -12'sd1 : 12'sd0) +
((bits[315] ^ bits[331]) ? -12'sd1 : 12'sd0))))) +
(((((bits[315] ^ bits[332]) ? -12'sd1 : 12'sd0) +
(((bits[316] ^ bits[317]) ? 12'sd1 : 12'sd0) +
((bits[316] ^ bits[331]) ? -12'sd1 : 12'sd0))) +
((((bits[316] ^ bits[332]) ? 12'sd1 : 12'sd0) +
((bits[316] ^ bits[333]) ? 12'sd1 : 12'sd0)) +
(((bits[317] ^ bits[318]) ? -12'sd1 : 12'sd0) +
((bits[317] ^ bits[332]) ? 12'sd1 : 12'sd0)))) +
(((((bits[317] ^ bits[333]) ? -12'sd1 : 12'sd0) +
((bits[317] ^ bits[334]) ? 12'sd1 : 12'sd0)) +
(((bits[318] ^ bits[319]) ? -12'sd1 : 12'sd0) +
((bits[318] ^ bits[333]) ? 12'sd1 : 12'sd0))) +
((((bits[318] ^ bits[334]) ? -12'sd1 : 12'sd0) +
((bits[318] ^ bits[335]) ? -12'sd1 : 12'sd0)) +
(((bits[319] ^ bits[334]) ? 12'sd1 : 12'sd0) +
((bits[319] ^ bits[335]) ? -12'sd1 : 12'sd0)))))) +
((((((bits[320] ^ bits[321]) ? 12'sd1 : 12'sd0) +
(((bits[320] ^ bits[336]) ? 12'sd1 : 12'sd0) +
((bits[320] ^ bits[337]) ? 12'sd1 : 12'sd0))) +
((((bits[321] ^ bits[322]) ? 12'sd1 : 12'sd0) +
((bits[321] ^ bits[336]) ? -12'sd1 : 12'sd0)) +
(((bits[321] ^ bits[337]) ? -12'sd1 : 12'sd0) +
((bits[321] ^ bits[338]) ? 12'sd1 : 12'sd0)))) +
(((((bits[322] ^ bits[323]) ? -12'sd1 : 12'sd0) +
((bits[322] ^ bits[337]) ? 12'sd1 : 12'sd0)) +
(((bits[322] ^ bits[338]) ? -12'sd1 : 12'sd0) +
((bits[322] ^ bits[339]) ? -12'sd1 : 12'sd0))) +
((((bits[323] ^ bits[324]) ? 12'sd1 : 12'sd0) +
((bits[323] ^ bits[338]) ? -12'sd1 : 12'sd0)) +
(((bits[323] ^ bits[339]) ? 12'sd1 : 12'sd0) +
((bits[323] ^ bits[340]) ? 12'sd1 : 12'sd0))))) +
(((((bits[324] ^ bits[325]) ? -12'sd1 : 12'sd0) +
(((bits[324] ^ bits[339]) ? 12'sd1 : 12'sd0) +
((bits[324] ^ bits[340]) ? -12'sd1 : 12'sd0))) +
((((bits[324] ^ bits[341]) ? 12'sd1 : 12'sd0) +
((bits[325] ^ bits[326]) ? 12'sd1 : 12'sd0)) +
(((bits[325] ^ bits[340]) ? -12'sd1 : 12'sd0) +
((bits[325] ^ bits[341]) ? -12'sd1 : 12'sd0)))) +
(((((bits[325] ^ bits[342]) ? -12'sd1 : 12'sd0) +
((bits[326] ^ bits[327]) ? -12'sd1 : 12'sd0)) +
(((bits[326] ^ bits[341]) ? 12'sd1 : 12'sd0) +
((bits[326] ^ bits[342]) ? 12'sd1 : 12'sd0))) +
((((bits[326] ^ bits[343]) ? -12'sd1 : 12'sd0) +
((bits[327] ^ bits[328]) ? 12'sd1 : 12'sd0)) +
(((bits[327] ^ bits[342]) ? -12'sd1 : 12'sd0) +
((bits[327] ^ bits[343]) ? -12'sd1 : 12'sd0))))))) +
(((((((bits[327] ^ bits[344]) ? -12'sd1 : 12'sd0) +
(((bits[328] ^ bits[329]) ? -12'sd1 : 12'sd0) +
((bits[328] ^ bits[343]) ? 12'sd1 : 12'sd0))) +
((((bits[328] ^ bits[344]) ? -12'sd1 : 12'sd0) +
((bits[328] ^ bits[345]) ? -12'sd1 : 12'sd0)) +
(((bits[329] ^ bits[330]) ? 12'sd1 : 12'sd0) +
((bits[329] ^ bits[344]) ? 12'sd1 : 12'sd0)))) +
(((((bits[329] ^ bits[345]) ? -12'sd1 : 12'sd0) +
((bits[329] ^ bits[346]) ? -12'sd1 : 12'sd0)) +
(((bits[330] ^ bits[331]) ? -12'sd1 : 12'sd0) +
((bits[330] ^ bits[345]) ? 12'sd1 : 12'sd0))) +
((((bits[330] ^ bits[346]) ? -12'sd1 : 12'sd0) +
((bits[330] ^ bits[347]) ? -12'sd1 : 12'sd0)) +
(((bits[331] ^ bits[332]) ? -12'sd1 : 12'sd0) +
((bits[331] ^ bits[346]) ? 12'sd1 : 12'sd0))))) +
(((((bits[331] ^ bits[347]) ? 12'sd1 : 12'sd0) +
(((bits[331] ^ bits[348]) ? -12'sd1 : 12'sd0) +
((bits[332] ^ bits[333]) ? -12'sd1 : 12'sd0))) +
((((bits[332] ^ bits[347]) ? -12'sd1 : 12'sd0) +
((bits[332] ^ bits[348]) ? -12'sd1 : 12'sd0)) +
(((bits[332] ^ bits[349]) ? -12'sd1 : 12'sd0) +
((bits[333] ^ bits[334]) ? -12'sd1 : 12'sd0)))) +
(((((bits[333] ^ bits[348]) ? -12'sd1 : 12'sd0) +
((bits[333] ^ bits[349]) ? -12'sd1 : 12'sd0)) +
(((bits[333] ^ bits[350]) ? -12'sd1 : 12'sd0) +
((bits[334] ^ bits[335]) ? 12'sd1 : 12'sd0))) +
((((bits[334] ^ bits[349]) ? 12'sd1 : 12'sd0) +
((bits[334] ^ bits[350]) ? -12'sd1 : 12'sd0)) +
(((bits[334] ^ bits[351]) ? 12'sd1 : 12'sd0) +
((bits[335] ^ bits[350]) ? 12'sd1 : 12'sd0)))))) +
((((((bits[335] ^ bits[351]) ? -12'sd1 : 12'sd0) +
(((bits[336] ^ bits[337]) ? 12'sd1 : 12'sd0) +
((bits[336] ^ bits[352]) ? -12'sd1 : 12'sd0))) +
((((bits[336] ^ bits[353]) ? 12'sd1 : 12'sd0) +
((bits[337] ^ bits[338]) ? 12'sd1 : 12'sd0)) +
(((bits[337] ^ bits[352]) ? -12'sd1 : 12'sd0) +
((bits[337] ^ bits[353]) ? -12'sd1 : 12'sd0)))) +
(((((bits[337] ^ bits[354]) ? 12'sd1 : 12'sd0) +
((bits[338] ^ bits[339]) ? -12'sd1 : 12'sd0)) +
(((bits[338] ^ bits[353]) ? -12'sd1 : 12'sd0) +
((bits[338] ^ bits[354]) ? -12'sd1 : 12'sd0))) +
((((bits[338] ^ bits[355]) ? 12'sd1 : 12'sd0) +
((bits[339] ^ bits[340]) ? 12'sd1 : 12'sd0)) +
(((bits[339] ^ bits[354]) ? -12'sd1 : 12'sd0) +
((bits[339] ^ bits[355]) ? -12'sd1 : 12'sd0))))) +
(((((bits[339] ^ bits[356]) ? 12'sd1 : 12'sd0) +
(((bits[340] ^ bits[341]) ? 12'sd1 : 12'sd0) +
((bits[340] ^ bits[355]) ? 12'sd1 : 12'sd0))) +
((((bits[340] ^ bits[356]) ? -12'sd1 : 12'sd0) +
((bits[340] ^ bits[357]) ? -12'sd1 : 12'sd0)) +
(((bits[341] ^ bits[342]) ? -12'sd1 : 12'sd0) +
((bits[341] ^ bits[356]) ? -12'sd1 : 12'sd0)))) +
(((((bits[341] ^ bits[357]) ? -12'sd1 : 12'sd0) +
((bits[341] ^ bits[358]) ? -12'sd1 : 12'sd0)) +
(((bits[342] ^ bits[343]) ? 12'sd1 : 12'sd0) +
((bits[342] ^ bits[357]) ? -12'sd1 : 12'sd0))) +
((((bits[342] ^ bits[358]) ? 12'sd1 : 12'sd0) +
((bits[342] ^ bits[359]) ? 12'sd1 : 12'sd0)) +
(((bits[343] ^ bits[344]) ? 12'sd1 : 12'sd0) +
((bits[343] ^ bits[358]) ? -12'sd1 : 12'sd0)))))))) +
((((((((bits[343] ^ bits[359]) ? -12'sd1 : 12'sd0) +
(((bits[343] ^ bits[360]) ? -12'sd1 : 12'sd0) +
((bits[344] ^ bits[345]) ? -12'sd1 : 12'sd0))) +
((((bits[344] ^ bits[359]) ? 12'sd1 : 12'sd0) +
((bits[344] ^ bits[360]) ? 12'sd1 : 12'sd0)) +
(((bits[344] ^ bits[361]) ? 12'sd1 : 12'sd0) +
((bits[345] ^ bits[346]) ? -12'sd1 : 12'sd0)))) +
((((bits[345] ^ bits[360]) ? -12'sd1 : 12'sd0) +
(((bits[345] ^ bits[361]) ? 12'sd1 : 12'sd0) +
((bits[345] ^ bits[362]) ? 12'sd1 : 12'sd0))) +
((((bits[346] ^ bits[347]) ? 12'sd1 : 12'sd0) +
((bits[346] ^ bits[361]) ? -12'sd1 : 12'sd0)) +
(((bits[346] ^ bits[362]) ? 12'sd1 : 12'sd0) +
((bits[346] ^ bits[363]) ? 12'sd1 : 12'sd0))))) +
(((((bits[347] ^ bits[348]) ? 12'sd1 : 12'sd0) +
(((bits[347] ^ bits[362]) ? 12'sd1 : 12'sd0) +
((bits[347] ^ bits[363]) ? 12'sd1 : 12'sd0))) +
((((bits[347] ^ bits[364]) ? 12'sd1 : 12'sd0) +
((bits[348] ^ bits[349]) ? 12'sd1 : 12'sd0)) +
(((bits[348] ^ bits[363]) ? -12'sd1 : 12'sd0) +
((bits[348] ^ bits[364]) ? -12'sd1 : 12'sd0)))) +
(((((bits[348] ^ bits[365]) ? -12'sd1 : 12'sd0) +
((bits[349] ^ bits[350]) ? 12'sd1 : 12'sd0)) +
(((bits[349] ^ bits[364]) ? 12'sd1 : 12'sd0) +
((bits[349] ^ bits[365]) ? -12'sd1 : 12'sd0))) +
((((bits[349] ^ bits[366]) ? -12'sd1 : 12'sd0) +
((bits[350] ^ bits[351]) ? 12'sd1 : 12'sd0)) +
(((bits[350] ^ bits[365]) ? 12'sd1 : 12'sd0) +
((bits[350] ^ bits[366]) ? -12'sd1 : 12'sd0)))))) +
((((((bits[350] ^ bits[367]) ? -12'sd1 : 12'sd0) +
(((bits[351] ^ bits[366]) ? -12'sd1 : 12'sd0) +
((bits[351] ^ bits[367]) ? 12'sd1 : 12'sd0))) +
((((bits[352] ^ bits[353]) ? -12'sd1 : 12'sd0) +
((bits[352] ^ bits[368]) ? 12'sd1 : 12'sd0)) +
(((bits[352] ^ bits[369]) ? 12'sd1 : 12'sd0) +
((bits[353] ^ bits[354]) ? 12'sd1 : 12'sd0)))) +
(((((bits[353] ^ bits[368]) ? 12'sd1 : 12'sd0) +
((bits[353] ^ bits[369]) ? -12'sd1 : 12'sd0)) +
(((bits[353] ^ bits[370]) ? 12'sd1 : 12'sd0) +
((bits[354] ^ bits[355]) ? 12'sd1 : 12'sd0))) +
((((bits[354] ^ bits[369]) ? 12'sd1 : 12'sd0) +
((bits[354] ^ bits[370]) ? 12'sd1 : 12'sd0)) +
(((bits[354] ^ bits[371]) ? -12'sd1 : 12'sd0) +
((bits[355] ^ bits[356]) ? 12'sd1 : 12'sd0))))) +
(((((bits[355] ^ bits[370]) ? 12'sd1 : 12'sd0) +
(((bits[355] ^ bits[371]) ? -12'sd1 : 12'sd0) +
((bits[355] ^ bits[372]) ? 12'sd1 : 12'sd0))) +
((((bits[356] ^ bits[357]) ? 12'sd1 : 12'sd0) +
((bits[356] ^ bits[371]) ? 12'sd1 : 12'sd0)) +
(((bits[356] ^ bits[372]) ? 12'sd1 : 12'sd0) +
((bits[356] ^ bits[373]) ? -12'sd1 : 12'sd0)))) +
(((((bits[357] ^ bits[358]) ? 12'sd1 : 12'sd0) +
((bits[357] ^ bits[372]) ? 12'sd1 : 12'sd0)) +
(((bits[357] ^ bits[373]) ? -12'sd1 : 12'sd0) +
((bits[357] ^ bits[374]) ? -12'sd1 : 12'sd0))) +
((((bits[358] ^ bits[359]) ? -12'sd1 : 12'sd0) +
((bits[358] ^ bits[373]) ? -12'sd1 : 12'sd0)) +
(((bits[358] ^ bits[374]) ? -12'sd1 : 12'sd0) +
((bits[358] ^ bits[375]) ? 12'sd1 : 12'sd0))))))) +
(((((((bits[359] ^ bits[360]) ? 12'sd1 : 12'sd0) +
(((bits[359] ^ bits[374]) ? -12'sd1 : 12'sd0) +
((bits[359] ^ bits[375]) ? -12'sd1 : 12'sd0))) +
((((bits[359] ^ bits[376]) ? 12'sd1 : 12'sd0) +
((bits[360] ^ bits[361]) ? -12'sd1 : 12'sd0)) +
(((bits[360] ^ bits[375]) ? -12'sd1 : 12'sd0) +
((bits[360] ^ bits[376]) ? 12'sd1 : 12'sd0)))) +
(((((bits[360] ^ bits[377]) ? 12'sd1 : 12'sd0) +
((bits[361] ^ bits[362]) ? -12'sd1 : 12'sd0)) +
(((bits[361] ^ bits[376]) ? -12'sd1 : 12'sd0) +
((bits[361] ^ bits[377]) ? 12'sd1 : 12'sd0))) +
((((bits[361] ^ bits[378]) ? -12'sd1 : 12'sd0) +
((bits[362] ^ bits[363]) ? 12'sd1 : 12'sd0)) +
(((bits[362] ^ bits[377]) ? -12'sd1 : 12'sd0) +
((bits[362] ^ bits[378]) ? 12'sd1 : 12'sd0))))) +
(((((bits[362] ^ bits[379]) ? -12'sd1 : 12'sd0) +
(((bits[363] ^ bits[364]) ? -12'sd1 : 12'sd0) +
((bits[363] ^ bits[378]) ? 12'sd1 : 12'sd0))) +
((((bits[363] ^ bits[379]) ? 12'sd1 : 12'sd0) +
((bits[363] ^ bits[380]) ? -12'sd1 : 12'sd0)) +
(((bits[364] ^ bits[365]) ? 12'sd1 : 12'sd0) +
((bits[364] ^ bits[379]) ? 12'sd1 : 12'sd0)))) +
(((((bits[364] ^ bits[380]) ? 12'sd1 : 12'sd0) +
((bits[364] ^ bits[381]) ? 12'sd1 : 12'sd0)) +
(((bits[365] ^ bits[366]) ? -12'sd1 : 12'sd0) +
((bits[365] ^ bits[380]) ? 12'sd1 : 12'sd0))) +
((((bits[365] ^ bits[381]) ? -12'sd1 : 12'sd0) +
((bits[365] ^ bits[382]) ? -12'sd1 : 12'sd0)) +
(((bits[366] ^ bits[367]) ? -12'sd1 : 12'sd0) +
((bits[366] ^ bits[381]) ? -12'sd1 : 12'sd0)))))) +
((((((bits[366] ^ bits[382]) ? -12'sd1 : 12'sd0) +
(((bits[366] ^ bits[383]) ? -12'sd1 : 12'sd0) +
((bits[367] ^ bits[382]) ? -12'sd1 : 12'sd0))) +
((((bits[367] ^ bits[383]) ? -12'sd1 : 12'sd0) +
((bits[368] ^ bits[369]) ? 12'sd1 : 12'sd0)) +
(((bits[368] ^ bits[384]) ? 12'sd1 : 12'sd0) +
((bits[368] ^ bits[385]) ? -12'sd1 : 12'sd0)))) +
(((((bits[369] ^ bits[370]) ? 12'sd1 : 12'sd0) +
((bits[369] ^ bits[384]) ? 12'sd1 : 12'sd0)) +
(((bits[369] ^ bits[385]) ? 12'sd1 : 12'sd0) +
((bits[369] ^ bits[386]) ? 12'sd1 : 12'sd0))) +
((((bits[370] ^ bits[371]) ? 12'sd1 : 12'sd0) +
((bits[370] ^ bits[385]) ? -12'sd1 : 12'sd0)) +
(((bits[370] ^ bits[386]) ? -12'sd1 : 12'sd0) +
((bits[370] ^ bits[387]) ? -12'sd1 : 12'sd0))))) +
(((((bits[371] ^ bits[372]) ? -12'sd1 : 12'sd0) +
(((bits[371] ^ bits[386]) ? -12'sd1 : 12'sd0) +
((bits[371] ^ bits[387]) ? -12'sd1 : 12'sd0))) +
((((bits[371] ^ bits[388]) ? 12'sd1 : 12'sd0) +
((bits[372] ^ bits[373]) ? 12'sd1 : 12'sd0)) +
(((bits[372] ^ bits[387]) ? 12'sd1 : 12'sd0) +
((bits[372] ^ bits[388]) ? -12'sd1 : 12'sd0)))) +
(((((bits[372] ^ bits[389]) ? 12'sd1 : 12'sd0) +
((bits[373] ^ bits[374]) ? 12'sd1 : 12'sd0)) +
(((bits[373] ^ bits[388]) ? 12'sd1 : 12'sd0) +
((bits[373] ^ bits[389]) ? 12'sd1 : 12'sd0))) +
((((bits[373] ^ bits[390]) ? 12'sd1 : 12'sd0) +
((bits[374] ^ bits[375]) ? -12'sd1 : 12'sd0)) +
(((bits[374] ^ bits[389]) ? 12'sd1 : 12'sd0) +
((bits[374] ^ bits[390]) ? 12'sd1 : 12'sd0)))))))))) +
((((((((((bits[374] ^ bits[391]) ? -12'sd1 : 12'sd0) +
(((bits[375] ^ bits[376]) ? 12'sd1 : 12'sd0) +
((bits[375] ^ bits[390]) ? -12'sd1 : 12'sd0))) +
((((bits[375] ^ bits[391]) ? -12'sd1 : 12'sd0) +
((bits[375] ^ bits[392]) ? -12'sd1 : 12'sd0)) +
(((bits[376] ^ bits[377]) ? -12'sd1 : 12'sd0) +
((bits[376] ^ bits[391]) ? -12'sd1 : 12'sd0)))) +
((((bits[376] ^ bits[392]) ? 12'sd1 : 12'sd0) +
(((bits[376] ^ bits[393]) ? -12'sd1 : 12'sd0) +
((bits[377] ^ bits[378]) ? 12'sd1 : 12'sd0))) +
((((bits[377] ^ bits[392]) ? -12'sd1 : 12'sd0) +
((bits[377] ^ bits[393]) ? 12'sd1 : 12'sd0)) +
(((bits[377] ^ bits[394]) ? 12'sd1 : 12'sd0) +
((bits[378] ^ bits[379]) ? 12'sd1 : 12'sd0))))) +
(((((bits[378] ^ bits[393]) ? -12'sd1 : 12'sd0) +
(((bits[378] ^ bits[394]) ? 12'sd1 : 12'sd0) +
((bits[378] ^ bits[395]) ? -12'sd1 : 12'sd0))) +
((((bits[379] ^ bits[380]) ? -12'sd1 : 12'sd0) +
((bits[379] ^ bits[394]) ? -12'sd1 : 12'sd0)) +
(((bits[379] ^ bits[395]) ? 12'sd1 : 12'sd0) +
((bits[379] ^ bits[396]) ? 12'sd1 : 12'sd0)))) +
(((((bits[380] ^ bits[381]) ? -12'sd1 : 12'sd0) +
((bits[380] ^ bits[395]) ? 12'sd1 : 12'sd0)) +
(((bits[380] ^ bits[396]) ? 12'sd1 : 12'sd0) +
((bits[380] ^ bits[397]) ? -12'sd1 : 12'sd0))) +
((((bits[381] ^ bits[382]) ? 12'sd1 : 12'sd0) +
((bits[381] ^ bits[396]) ? -12'sd1 : 12'sd0)) +
(((bits[381] ^ bits[397]) ? -12'sd1 : 12'sd0) +
((bits[381] ^ bits[398]) ? -12'sd1 : 12'sd0)))))) +
((((((bits[382] ^ bits[383]) ? -12'sd1 : 12'sd0) +
(((bits[382] ^ bits[397]) ? 12'sd1 : 12'sd0) +
((bits[382] ^ bits[398]) ? -12'sd1 : 12'sd0))) +
((((bits[382] ^ bits[399]) ? 12'sd1 : 12'sd0) +
((bits[383] ^ bits[398]) ? -12'sd1 : 12'sd0)) +
(((bits[383] ^ bits[399]) ? 12'sd1 : 12'sd0) +
((bits[384] ^ bits[385]) ? -12'sd1 : 12'sd0)))) +
(((((bits[384] ^ bits[400]) ? 12'sd1 : 12'sd0) +
((bits[384] ^ bits[401]) ? -12'sd1 : 12'sd0)) +
(((bits[385] ^ bits[386]) ? -12'sd1 : 12'sd0) +
((bits[385] ^ bits[400]) ? -12'sd1 : 12'sd0))) +
((((bits[385] ^ bits[401]) ? -12'sd1 : 12'sd0) +
((bits[385] ^ bits[402]) ? -12'sd1 : 12'sd0)) +
(((bits[386] ^ bits[387]) ? 12'sd1 : 12'sd0) +
((bits[386] ^ bits[401]) ? 12'sd1 : 12'sd0))))) +
(((((bits[386] ^ bits[402]) ? -12'sd1 : 12'sd0) +
(((bits[386] ^ bits[403]) ? -12'sd1 : 12'sd0) +
((bits[387] ^ bits[388]) ? 12'sd1 : 12'sd0))) +
((((bits[387] ^ bits[402]) ? 12'sd1 : 12'sd0) +
((bits[387] ^ bits[403]) ? 12'sd1 : 12'sd0)) +
(((bits[387] ^ bits[404]) ? 12'sd1 : 12'sd0) +
((bits[388] ^ bits[389]) ? -12'sd1 : 12'sd0)))) +
(((((bits[388] ^ bits[403]) ? -12'sd1 : 12'sd0) +
((bits[388] ^ bits[404]) ? 12'sd1 : 12'sd0)) +
(((bits[388] ^ bits[405]) ? -12'sd1 : 12'sd0) +
((bits[389] ^ bits[390]) ? 12'sd1 : 12'sd0))) +
((((bits[389] ^ bits[404]) ? 12'sd1 : 12'sd0) +
((bits[389] ^ bits[405]) ? -12'sd1 : 12'sd0)) +
(((bits[389] ^ bits[406]) ? -12'sd1 : 12'sd0) +
((bits[390] ^ bits[391]) ? -12'sd1 : 12'sd0))))))) +
(((((((bits[390] ^ bits[405]) ? 12'sd1 : 12'sd0) +
(((bits[390] ^ bits[406]) ? 12'sd1 : 12'sd0) +
((bits[390] ^ bits[407]) ? 12'sd1 : 12'sd0))) +
((((bits[391] ^ bits[392]) ? 12'sd1 : 12'sd0) +
((bits[391] ^ bits[406]) ? -12'sd1 : 12'sd0)) +
(((bits[391] ^ bits[407]) ? 12'sd1 : 12'sd0) +
((bits[391] ^ bits[408]) ? 12'sd1 : 12'sd0)))) +
(((((bits[392] ^ bits[393]) ? 12'sd1 : 12'sd0) +
((bits[392] ^ bits[407]) ? -12'sd1 : 12'sd0)) +
(((bits[392] ^ bits[408]) ? 12'sd1 : 12'sd0) +
((bits[392] ^ bits[409]) ? 12'sd1 : 12'sd0))) +
((((bits[393] ^ bits[394]) ? 12'sd1 : 12'sd0) +
((bits[393] ^ bits[408]) ? 12'sd1 : 12'sd0)) +
(((bits[393] ^ bits[409]) ? 12'sd1 : 12'sd0) +
((bits[393] ^ bits[410]) ? -12'sd1 : 12'sd0))))) +
(((((bits[394] ^ bits[395]) ? 12'sd1 : 12'sd0) +
(((bits[394] ^ bits[409]) ? -12'sd1 : 12'sd0) +
((bits[394] ^ bits[410]) ? 12'sd1 : 12'sd0))) +
((((bits[394] ^ bits[411]) ? 12'sd1 : 12'sd0) +
((bits[395] ^ bits[396]) ? 12'sd1 : 12'sd0)) +
(((bits[395] ^ bits[410]) ? -12'sd1 : 12'sd0) +
((bits[395] ^ bits[411]) ? 12'sd1 : 12'sd0)))) +
(((((bits[395] ^ bits[412]) ? 12'sd1 : 12'sd0) +
((bits[396] ^ bits[397]) ? 12'sd1 : 12'sd0)) +
(((bits[396] ^ bits[411]) ? 12'sd1 : 12'sd0) +
((bits[396] ^ bits[412]) ? 12'sd1 : 12'sd0))) +
((((bits[396] ^ bits[413]) ? -12'sd1 : 12'sd0) +
((bits[397] ^ bits[398]) ? 12'sd1 : 12'sd0)) +
(((bits[397] ^ bits[412]) ? -12'sd1 : 12'sd0) +
((bits[397] ^ bits[413]) ? -12'sd1 : 12'sd0)))))) +
((((((bits[397] ^ bits[414]) ? -12'sd1 : 12'sd0) +
(((bits[398] ^ bits[399]) ? -12'sd1 : 12'sd0) +
((bits[398] ^ bits[413]) ? -12'sd1 : 12'sd0))) +
((((bits[398] ^ bits[414]) ? 12'sd1 : 12'sd0) +
((bits[398] ^ bits[415]) ? 12'sd1 : 12'sd0)) +
(((bits[399] ^ bits[414]) ? -12'sd1 : 12'sd0) +
((bits[399] ^ bits[415]) ? -12'sd1 : 12'sd0)))) +
(((((bits[400] ^ bits[401]) ? 12'sd1 : 12'sd0) +
((bits[400] ^ bits[416]) ? 12'sd1 : 12'sd0)) +
(((bits[400] ^ bits[417]) ? 12'sd1 : 12'sd0) +
((bits[401] ^ bits[402]) ? 12'sd1 : 12'sd0))) +
((((bits[401] ^ bits[416]) ? 12'sd1 : 12'sd0) +
((bits[401] ^ bits[417]) ? -12'sd1 : 12'sd0)) +
(((bits[401] ^ bits[418]) ? 12'sd1 : 12'sd0) +
((bits[402] ^ bits[403]) ? -12'sd1 : 12'sd0))))) +
(((((bits[402] ^ bits[417]) ? -12'sd1 : 12'sd0) +
(((bits[402] ^ bits[418]) ? 12'sd1 : 12'sd0) +
((bits[402] ^ bits[419]) ? -12'sd1 : 12'sd0))) +
((((bits[403] ^ bits[404]) ? 12'sd1 : 12'sd0) +
((bits[403] ^ bits[418]) ? 12'sd1 : 12'sd0)) +
(((bits[403] ^ bits[419]) ? -12'sd1 : 12'sd0) +
((bits[403] ^ bits[420]) ? 12'sd1 : 12'sd0)))) +
(((((bits[404] ^ bits[405]) ? -12'sd1 : 12'sd0) +
((bits[404] ^ bits[419]) ? -12'sd1 : 12'sd0)) +
(((bits[404] ^ bits[420]) ? 12'sd1 : 12'sd0) +
((bits[404] ^ bits[421]) ? 12'sd1 : 12'sd0))) +
((((bits[405] ^ bits[406]) ? -12'sd1 : 12'sd0) +
((bits[405] ^ bits[420]) ? -12'sd1 : 12'sd0)) +
(((bits[405] ^ bits[421]) ? 12'sd1 : 12'sd0) +
((bits[405] ^ bits[422]) ? 12'sd1 : 12'sd0)))))))) +
((((((((bits[406] ^ bits[407]) ? 12'sd1 : 12'sd0) +
(((bits[406] ^ bits[421]) ? 12'sd1 : 12'sd0) +
((bits[406] ^ bits[422]) ? -12'sd1 : 12'sd0))) +
((((bits[406] ^ bits[423]) ? -12'sd1 : 12'sd0) +
((bits[407] ^ bits[408]) ? -12'sd1 : 12'sd0)) +
(((bits[407] ^ bits[422]) ? -12'sd1 : 12'sd0) +
((bits[407] ^ bits[423]) ? 12'sd1 : 12'sd0)))) +
((((bits[407] ^ bits[424]) ? 12'sd1 : 12'sd0) +
(((bits[408] ^ bits[409]) ? -12'sd1 : 12'sd0) +
((bits[408] ^ bits[423]) ? 12'sd1 : 12'sd0))) +
((((bits[408] ^ bits[424]) ? 12'sd1 : 12'sd0) +
((bits[408] ^ bits[425]) ? 12'sd1 : 12'sd0)) +
(((bits[409] ^ bits[410]) ? 12'sd1 : 12'sd0) +
((bits[409] ^ bits[424]) ? 12'sd1 : 12'sd0))))) +
(((((bits[409] ^ bits[425]) ? -12'sd1 : 12'sd0) +
(((bits[409] ^ bits[426]) ? 12'sd1 : 12'sd0) +
((bits[410] ^ bits[411]) ? -12'sd1 : 12'sd0))) +
((((bits[410] ^ bits[425]) ? 12'sd1 : 12'sd0) +
((bits[410] ^ bits[426]) ? 12'sd1 : 12'sd0)) +
(((bits[410] ^ bits[427]) ? -12'sd1 : 12'sd0) +
((bits[411] ^ bits[412]) ? -12'sd1 : 12'sd0)))) +
(((((bits[411] ^ bits[426]) ? 12'sd1 : 12'sd0) +
((bits[411] ^ bits[427]) ? 12'sd1 : 12'sd0)) +
(((bits[411] ^ bits[428]) ? -12'sd1 : 12'sd0) +
((bits[412] ^ bits[413]) ? 12'sd1 : 12'sd0))) +
((((bits[412] ^ bits[427]) ? -12'sd1 : 12'sd0) +
((bits[412] ^ bits[428]) ? 12'sd1 : 12'sd0)) +
(((bits[412] ^ bits[429]) ? 12'sd1 : 12'sd0) +
((bits[413] ^ bits[414]) ? 12'sd1 : 12'sd0)))))) +
((((((bits[413] ^ bits[428]) ? 12'sd1 : 12'sd0) +
(((bits[413] ^ bits[429]) ? 12'sd1 : 12'sd0) +
((bits[413] ^ bits[430]) ? 12'sd1 : 12'sd0))) +
((((bits[414] ^ bits[415]) ? -12'sd1 : 12'sd0) +
((bits[414] ^ bits[429]) ? 12'sd1 : 12'sd0)) +
(((bits[414] ^ bits[430]) ? -12'sd1 : 12'sd0) +
((bits[414] ^ bits[431]) ? 12'sd1 : 12'sd0)))) +
(((((bits[415] ^ bits[430]) ? -12'sd1 : 12'sd0) +
((bits[415] ^ bits[431]) ? 12'sd1 : 12'sd0)) +
(((bits[416] ^ bits[417]) ? 12'sd1 : 12'sd0) +
((bits[416] ^ bits[432]) ? 12'sd1 : 12'sd0))) +
((((bits[416] ^ bits[433]) ? -12'sd1 : 12'sd0) +
((bits[417] ^ bits[418]) ? -12'sd1 : 12'sd0)) +
(((bits[417] ^ bits[432]) ? 12'sd1 : 12'sd0) +
((bits[417] ^ bits[433]) ? 12'sd1 : 12'sd0))))) +
(((((bits[417] ^ bits[434]) ? 12'sd1 : 12'sd0) +
(((bits[418] ^ bits[419]) ? 12'sd1 : 12'sd0) +
((bits[418] ^ bits[433]) ? 12'sd1 : 12'sd0))) +
((((bits[418] ^ bits[434]) ? 12'sd1 : 12'sd0) +
((bits[418] ^ bits[435]) ? 12'sd1 : 12'sd0)) +
(((bits[419] ^ bits[420]) ? -12'sd1 : 12'sd0) +
((bits[419] ^ bits[434]) ? 12'sd1 : 12'sd0)))) +
(((((bits[419] ^ bits[435]) ? 12'sd1 : 12'sd0) +
((bits[419] ^ bits[436]) ? -12'sd1 : 12'sd0)) +
(((bits[420] ^ bits[421]) ? 12'sd1 : 12'sd0) +
((bits[420] ^ bits[435]) ? -12'sd1 : 12'sd0))) +
((((bits[420] ^ bits[436]) ? 12'sd1 : 12'sd0) +
((bits[420] ^ bits[437]) ? 12'sd1 : 12'sd0)) +
(((bits[421] ^ bits[422]) ? -12'sd1 : 12'sd0) +
((bits[421] ^ bits[436]) ? 12'sd1 : 12'sd0))))))) +
(((((((bits[421] ^ bits[437]) ? -12'sd1 : 12'sd0) +
(((bits[421] ^ bits[438]) ? -12'sd1 : 12'sd0) +
((bits[422] ^ bits[423]) ? 12'sd1 : 12'sd0))) +
((((bits[422] ^ bits[437]) ? -12'sd1 : 12'sd0) +
((bits[422] ^ bits[438]) ? -12'sd1 : 12'sd0)) +
(((bits[422] ^ bits[439]) ? 12'sd1 : 12'sd0) +
((bits[423] ^ bits[424]) ? -12'sd1 : 12'sd0)))) +
(((((bits[423] ^ bits[438]) ? -12'sd1 : 12'sd0) +
((bits[423] ^ bits[439]) ? 12'sd1 : 12'sd0)) +
(((bits[423] ^ bits[440]) ? 12'sd1 : 12'sd0) +
((bits[424] ^ bits[425]) ? 12'sd1 : 12'sd0))) +
((((bits[424] ^ bits[439]) ? -12'sd1 : 12'sd0) +
((bits[424] ^ bits[440]) ? -12'sd1 : 12'sd0)) +
(((bits[424] ^ bits[441]) ? 12'sd1 : 12'sd0) +
((bits[425] ^ bits[426]) ? -12'sd1 : 12'sd0))))) +
(((((bits[425] ^ bits[440]) ? 12'sd1 : 12'sd0) +
(((bits[425] ^ bits[441]) ? -12'sd1 : 12'sd0) +
((bits[425] ^ bits[442]) ? -12'sd1 : 12'sd0))) +
((((bits[426] ^ bits[427]) ? 12'sd1 : 12'sd0) +
((bits[426] ^ bits[441]) ? -12'sd1 : 12'sd0)) +
(((bits[426] ^ bits[442]) ? 12'sd1 : 12'sd0) +
((bits[426] ^ bits[443]) ? 12'sd1 : 12'sd0)))) +
(((((bits[427] ^ bits[428]) ? 12'sd1 : 12'sd0) +
((bits[427] ^ bits[442]) ? -12'sd1 : 12'sd0)) +
(((bits[427] ^ bits[443]) ? -12'sd1 : 12'sd0) +
((bits[427] ^ bits[444]) ? 12'sd1 : 12'sd0))) +
((((bits[428] ^ bits[429]) ? -12'sd1 : 12'sd0) +
((bits[428] ^ bits[443]) ? 12'sd1 : 12'sd0)) +
(((bits[428] ^ bits[444]) ? 12'sd1 : 12'sd0) +
((bits[428] ^ bits[445]) ? 12'sd1 : 12'sd0)))))) +
((((((bits[429] ^ bits[430]) ? 12'sd1 : 12'sd0) +
(((bits[429] ^ bits[444]) ? 12'sd1 : 12'sd0) +
((bits[429] ^ bits[445]) ? -12'sd1 : 12'sd0))) +
((((bits[429] ^ bits[446]) ? 12'sd1 : 12'sd0) +
((bits[430] ^ bits[431]) ? 12'sd1 : 12'sd0)) +
(((bits[430] ^ bits[445]) ? 12'sd1 : 12'sd0) +
((bits[430] ^ bits[446]) ? -12'sd1 : 12'sd0)))) +
(((((bits[430] ^ bits[447]) ? 12'sd1 : 12'sd0) +
((bits[431] ^ bits[446]) ? -12'sd1 : 12'sd0)) +
(((bits[431] ^ bits[447]) ? 12'sd1 : 12'sd0) +
((bits[432] ^ bits[433]) ? -12'sd1 : 12'sd0))) +
((((bits[432] ^ bits[448]) ? -12'sd1 : 12'sd0) +
((bits[432] ^ bits[449]) ? 12'sd1 : 12'sd0)) +
(((bits[433] ^ bits[434]) ? 12'sd1 : 12'sd0) +
((bits[433] ^ bits[448]) ? 12'sd1 : 12'sd0))))) +
(((((bits[433] ^ bits[449]) ? -12'sd1 : 12'sd0) +
(((bits[433] ^ bits[450]) ? 12'sd1 : 12'sd0) +
((bits[434] ^ bits[435]) ? 12'sd1 : 12'sd0))) +
((((bits[434] ^ bits[449]) ? 12'sd1 : 12'sd0) +
((bits[434] ^ bits[450]) ? 12'sd1 : 12'sd0)) +
(((bits[434] ^ bits[451]) ? -12'sd1 : 12'sd0) +
((bits[435] ^ bits[436]) ? 12'sd1 : 12'sd0)))) +
(((((bits[435] ^ bits[450]) ? -12'sd1 : 12'sd0) +
((bits[435] ^ bits[451]) ? -12'sd1 : 12'sd0)) +
(((bits[435] ^ bits[452]) ? 12'sd1 : 12'sd0) +
((bits[436] ^ bits[437]) ? 12'sd1 : 12'sd0))) +
((((bits[436] ^ bits[451]) ? 12'sd1 : 12'sd0) +
((bits[436] ^ bits[452]) ? -12'sd1 : 12'sd0)) +
(((bits[436] ^ bits[453]) ? 12'sd1 : 12'sd0) +
((bits[437] ^ bits[438]) ? 12'sd1 : 12'sd0))))))))) +
(((((((((bits[437] ^ bits[452]) ? -12'sd1 : 12'sd0) +
(((bits[437] ^ bits[453]) ? 12'sd1 : 12'sd0) +
((bits[437] ^ bits[454]) ? -12'sd1 : 12'sd0))) +
((((bits[438] ^ bits[439]) ? 12'sd1 : 12'sd0) +
((bits[438] ^ bits[453]) ? 12'sd1 : 12'sd0)) +
(((bits[438] ^ bits[454]) ? -12'sd1 : 12'sd0) +
((bits[438] ^ bits[455]) ? 12'sd1 : 12'sd0)))) +
((((bits[439] ^ bits[440]) ? -12'sd1 : 12'sd0) +
(((bits[439] ^ bits[454]) ? 12'sd1 : 12'sd0) +
((bits[439] ^ bits[455]) ? -12'sd1 : 12'sd0))) +
((((bits[439] ^ bits[456]) ? 12'sd1 : 12'sd0) +
((bits[440] ^ bits[441]) ? 12'sd1 : 12'sd0)) +
(((bits[440] ^ bits[455]) ? 12'sd1 : 12'sd0) +
((bits[440] ^ bits[456]) ? -12'sd1 : 12'sd0))))) +
(((((bits[440] ^ bits[457]) ? 12'sd1 : 12'sd0) +
(((bits[441] ^ bits[442]) ? 12'sd1 : 12'sd0) +
((bits[441] ^ bits[456]) ? -12'sd1 : 12'sd0))) +
((((bits[441] ^ bits[457]) ? -12'sd1 : 12'sd0) +
((bits[441] ^ bits[458]) ? -12'sd1 : 12'sd0)) +
(((bits[442] ^ bits[443]) ? -12'sd1 : 12'sd0) +
((bits[442] ^ bits[457]) ? -12'sd1 : 12'sd0)))) +
(((((bits[442] ^ bits[458]) ? -12'sd1 : 12'sd0) +
((bits[442] ^ bits[459]) ? -12'sd1 : 12'sd0)) +
(((bits[443] ^ bits[444]) ? 12'sd1 : 12'sd0) +
((bits[443] ^ bits[458]) ? -12'sd1 : 12'sd0))) +
((((bits[443] ^ bits[459]) ? -12'sd1 : 12'sd0) +
((bits[443] ^ bits[460]) ? -12'sd1 : 12'sd0)) +
(((bits[444] ^ bits[445]) ? -12'sd1 : 12'sd0) +
((bits[444] ^ bits[459]) ? -12'sd1 : 12'sd0)))))) +
((((((bits[444] ^ bits[460]) ? -12'sd1 : 12'sd0) +
(((bits[444] ^ bits[461]) ? -12'sd1 : 12'sd0) +
((bits[445] ^ bits[446]) ? 12'sd1 : 12'sd0))) +
((((bits[445] ^ bits[460]) ? 12'sd1 : 12'sd0) +
((bits[445] ^ bits[461]) ? 12'sd1 : 12'sd0)) +
(((bits[445] ^ bits[462]) ? 12'sd1 : 12'sd0) +
((bits[446] ^ bits[447]) ? -12'sd1 : 12'sd0)))) +
(((((bits[446] ^ bits[461]) ? 12'sd1 : 12'sd0) +
((bits[446] ^ bits[462]) ? 12'sd1 : 12'sd0)) +
(((bits[446] ^ bits[463]) ? -12'sd1 : 12'sd0) +
((bits[447] ^ bits[462]) ? -12'sd1 : 12'sd0))) +
((((bits[447] ^ bits[463]) ? 12'sd1 : 12'sd0) +
((bits[448] ^ bits[449]) ? -12'sd1 : 12'sd0)) +
(((bits[448] ^ bits[464]) ? -12'sd1 : 12'sd0) +
((bits[448] ^ bits[465]) ? -12'sd1 : 12'sd0))))) +
(((((bits[449] ^ bits[450]) ? -12'sd1 : 12'sd0) +
(((bits[449] ^ bits[464]) ? 12'sd1 : 12'sd0) +
((bits[449] ^ bits[465]) ? -12'sd1 : 12'sd0))) +
((((bits[449] ^ bits[466]) ? -12'sd1 : 12'sd0) +
((bits[450] ^ bits[451]) ? 12'sd1 : 12'sd0)) +
(((bits[450] ^ bits[465]) ? -12'sd1 : 12'sd0) +
((bits[450] ^ bits[466]) ? 12'sd1 : 12'sd0)))) +
(((((bits[450] ^ bits[467]) ? 12'sd1 : 12'sd0) +
((bits[451] ^ bits[452]) ? 12'sd1 : 12'sd0)) +
(((bits[451] ^ bits[466]) ? -12'sd1 : 12'sd0) +
((bits[451] ^ bits[467]) ? 12'sd1 : 12'sd0))) +
((((bits[451] ^ bits[468]) ? -12'sd1 : 12'sd0) +
((bits[452] ^ bits[453]) ? -12'sd1 : 12'sd0)) +
(((bits[452] ^ bits[467]) ? -12'sd1 : 12'sd0) +
((bits[452] ^ bits[468]) ? -12'sd1 : 12'sd0))))))) +
(((((((bits[452] ^ bits[469]) ? 12'sd1 : 12'sd0) +
(((bits[453] ^ bits[454]) ? 12'sd1 : 12'sd0) +
((bits[453] ^ bits[468]) ? 12'sd1 : 12'sd0))) +
((((bits[453] ^ bits[469]) ? -12'sd1 : 12'sd0) +
((bits[453] ^ bits[470]) ? 12'sd1 : 12'sd0)) +
(((bits[454] ^ bits[455]) ? -12'sd1 : 12'sd0) +
((bits[454] ^ bits[469]) ? 12'sd1 : 12'sd0)))) +
(((((bits[454] ^ bits[470]) ? 12'sd1 : 12'sd0) +
((bits[454] ^ bits[471]) ? 12'sd1 : 12'sd0)) +
(((bits[455] ^ bits[456]) ? 12'sd1 : 12'sd0) +
((bits[455] ^ bits[470]) ? 12'sd1 : 12'sd0))) +
((((bits[455] ^ bits[471]) ? 12'sd1 : 12'sd0) +
((bits[455] ^ bits[472]) ? 12'sd1 : 12'sd0)) +
(((bits[456] ^ bits[457]) ? -12'sd1 : 12'sd0) +
((bits[456] ^ bits[471]) ? 12'sd1 : 12'sd0))))) +
(((((bits[456] ^ bits[472]) ? 12'sd1 : 12'sd0) +
(((bits[456] ^ bits[473]) ? -12'sd1 : 12'sd0) +
((bits[457] ^ bits[458]) ? -12'sd1 : 12'sd0))) +
((((bits[457] ^ bits[472]) ? 12'sd1 : 12'sd0) +
((bits[457] ^ bits[473]) ? -12'sd1 : 12'sd0)) +
(((bits[457] ^ bits[474]) ? 12'sd1 : 12'sd0) +
((bits[458] ^ bits[459]) ? -12'sd1 : 12'sd0)))) +
(((((bits[458] ^ bits[473]) ? 12'sd1 : 12'sd0) +
((bits[458] ^ bits[474]) ? 12'sd1 : 12'sd0)) +
(((bits[458] ^ bits[475]) ? -12'sd1 : 12'sd0) +
((bits[459] ^ bits[460]) ? -12'sd1 : 12'sd0))) +
((((bits[459] ^ bits[474]) ? -12'sd1 : 12'sd0) +
((bits[459] ^ bits[475]) ? 12'sd1 : 12'sd0)) +
(((bits[459] ^ bits[476]) ? 12'sd1 : 12'sd0) +
((bits[460] ^ bits[461]) ? -12'sd1 : 12'sd0)))))) +
((((((bits[460] ^ bits[475]) ? -12'sd1 : 12'sd0) +
(((bits[460] ^ bits[476]) ? 12'sd1 : 12'sd0) +
((bits[460] ^ bits[477]) ? 12'sd1 : 12'sd0))) +
((((bits[461] ^ bits[462]) ? 12'sd1 : 12'sd0) +
((bits[461] ^ bits[476]) ? -12'sd1 : 12'sd0)) +
(((bits[461] ^ bits[477]) ? -12'sd1 : 12'sd0) +
((bits[461] ^ bits[478]) ? -12'sd1 : 12'sd0)))) +
(((((bits[462] ^ bits[463]) ? -12'sd1 : 12'sd0) +
((bits[462] ^ bits[477]) ? 12'sd1 : 12'sd0)) +
(((bits[462] ^ bits[478]) ? -12'sd1 : 12'sd0) +
((bits[462] ^ bits[479]) ? -12'sd1 : 12'sd0))) +
((((bits[463] ^ bits[478]) ? -12'sd1 : 12'sd0) +
((bits[463] ^ bits[479]) ? 12'sd1 : 12'sd0)) +
(((bits[464] ^ bits[465]) ? 12'sd1 : 12'sd0) +
((bits[464] ^ bits[480]) ? -12'sd1 : 12'sd0))))) +
(((((bits[464] ^ bits[481]) ? -12'sd1 : 12'sd0) +
(((bits[465] ^ bits[466]) ? 12'sd1 : 12'sd0) +
((bits[465] ^ bits[480]) ? 12'sd1 : 12'sd0))) +
((((bits[465] ^ bits[481]) ? -12'sd1 : 12'sd0) +
((bits[465] ^ bits[482]) ? -12'sd1 : 12'sd0)) +
(((bits[466] ^ bits[467]) ? 12'sd1 : 12'sd0) +
((bits[466] ^ bits[481]) ? -12'sd1 : 12'sd0)))) +
(((((bits[466] ^ bits[482]) ? 12'sd1 : 12'sd0) +
((bits[466] ^ bits[483]) ? 12'sd1 : 12'sd0)) +
(((bits[467] ^ bits[468]) ? 12'sd1 : 12'sd0) +
((bits[467] ^ bits[482]) ? 12'sd1 : 12'sd0))) +
((((bits[467] ^ bits[483]) ? -12'sd1 : 12'sd0) +
((bits[467] ^ bits[484]) ? 12'sd1 : 12'sd0)) +
(((bits[468] ^ bits[469]) ? -12'sd1 : 12'sd0) +
((bits[468] ^ bits[483]) ? 12'sd1 : 12'sd0)))))))) +
((((((((bits[468] ^ bits[484]) ? -12'sd1 : 12'sd0) +
(((bits[468] ^ bits[485]) ? -12'sd1 : 12'sd0) +
((bits[469] ^ bits[470]) ? -12'sd1 : 12'sd0))) +
((((bits[469] ^ bits[484]) ? -12'sd1 : 12'sd0) +
((bits[469] ^ bits[485]) ? -12'sd1 : 12'sd0)) +
(((bits[469] ^ bits[486]) ? 12'sd1 : 12'sd0) +
((bits[470] ^ bits[471]) ? -12'sd1 : 12'sd0)))) +
(((((bits[470] ^ bits[485]) ? 12'sd1 : 12'sd0) +
((bits[470] ^ bits[486]) ? 12'sd1 : 12'sd0)) +
(((bits[470] ^ bits[487]) ? 12'sd1 : 12'sd0) +
((bits[471] ^ bits[472]) ? -12'sd1 : 12'sd0))) +
((((bits[471] ^ bits[486]) ? -12'sd1 : 12'sd0) +
((bits[471] ^ bits[487]) ? -12'sd1 : 12'sd0)) +
(((bits[471] ^ bits[488]) ? -12'sd1 : 12'sd0) +
((bits[472] ^ bits[473]) ? -12'sd1 : 12'sd0))))) +
(((((bits[472] ^ bits[487]) ? 12'sd1 : 12'sd0) +
(((bits[472] ^ bits[488]) ? 12'sd1 : 12'sd0) +
((bits[472] ^ bits[489]) ? -12'sd1 : 12'sd0))) +
((((bits[473] ^ bits[474]) ? -12'sd1 : 12'sd0) +
((bits[473] ^ bits[488]) ? 12'sd1 : 12'sd0)) +
(((bits[473] ^ bits[489]) ? -12'sd1 : 12'sd0) +
((bits[473] ^ bits[490]) ? 12'sd1 : 12'sd0)))) +
(((((bits[474] ^ bits[475]) ? -12'sd1 : 12'sd0) +
((bits[474] ^ bits[489]) ? 12'sd1 : 12'sd0)) +
(((bits[474] ^ bits[490]) ? -12'sd1 : 12'sd0) +
((bits[474] ^ bits[491]) ? 12'sd1 : 12'sd0))) +
((((bits[475] ^ bits[476]) ? 12'sd1 : 12'sd0) +
((bits[475] ^ bits[490]) ? 12'sd1 : 12'sd0)) +
(((bits[475] ^ bits[491]) ? 12'sd1 : 12'sd0) +
((bits[475] ^ bits[492]) ? 12'sd1 : 12'sd0)))))) +
((((((bits[476] ^ bits[477]) ? 12'sd1 : 12'sd0) +
(((bits[476] ^ bits[491]) ? -12'sd1 : 12'sd0) +
((bits[476] ^ bits[492]) ? -12'sd1 : 12'sd0))) +
((((bits[476] ^ bits[493]) ? -12'sd1 : 12'sd0) +
((bits[477] ^ bits[478]) ? 12'sd1 : 12'sd0)) +
(((bits[477] ^ bits[492]) ? 12'sd1 : 12'sd0) +
((bits[477] ^ bits[493]) ? 12'sd1 : 12'sd0)))) +
(((((bits[477] ^ bits[494]) ? 12'sd1 : 12'sd0) +
((bits[478] ^ bits[479]) ? 12'sd1 : 12'sd0)) +
(((bits[478] ^ bits[493]) ? 12'sd1 : 12'sd0) +
((bits[478] ^ bits[494]) ? 12'sd1 : 12'sd0))) +
((((bits[478] ^ bits[495]) ? 12'sd1 : 12'sd0) +
((bits[479] ^ bits[494]) ? 12'sd1 : 12'sd0)) +
(((bits[479] ^ bits[495]) ? -12'sd1 : 12'sd0) +
((bits[480] ^ bits[481]) ? -12'sd1 : 12'sd0))))) +
(((((bits[480] ^ bits[496]) ? 12'sd1 : 12'sd0) +
(((bits[480] ^ bits[497]) ? 12'sd1 : 12'sd0) +
((bits[481] ^ bits[482]) ? -12'sd1 : 12'sd0))) +
((((bits[481] ^ bits[496]) ? 12'sd1 : 12'sd0) +
((bits[481] ^ bits[497]) ? -12'sd1 : 12'sd0)) +
(((bits[481] ^ bits[498]) ? -12'sd1 : 12'sd0) +
((bits[482] ^ bits[483]) ? 12'sd1 : 12'sd0)))) +
(((((bits[482] ^ bits[497]) ? -12'sd1 : 12'sd0) +
((bits[482] ^ bits[498]) ? 12'sd1 : 12'sd0)) +
(((bits[482] ^ bits[499]) ? -12'sd1 : 12'sd0) +
((bits[483] ^ bits[484]) ? 12'sd1 : 12'sd0))) +
((((bits[483] ^ bits[498]) ? 12'sd1 : 12'sd0) +
((bits[483] ^ bits[499]) ? -12'sd1 : 12'sd0)) +
(((bits[483] ^ bits[500]) ? -12'sd1 : 12'sd0) +
((bits[484] ^ bits[485]) ? 12'sd1 : 12'sd0))))))) +
(((((((bits[484] ^ bits[499]) ? -12'sd1 : 12'sd0) +
(((bits[484] ^ bits[500]) ? 12'sd1 : 12'sd0) +
((bits[484] ^ bits[501]) ? -12'sd1 : 12'sd0))) +
((((bits[485] ^ bits[486]) ? -12'sd1 : 12'sd0) +
((bits[485] ^ bits[500]) ? -12'sd1 : 12'sd0)) +
(((bits[485] ^ bits[501]) ? 12'sd1 : 12'sd0) +
((bits[485] ^ bits[502]) ? 12'sd1 : 12'sd0)))) +
(((((bits[486] ^ bits[487]) ? -12'sd1 : 12'sd0) +
((bits[486] ^ bits[501]) ? -12'sd1 : 12'sd0)) +
(((bits[486] ^ bits[502]) ? 12'sd1 : 12'sd0) +
((bits[486] ^ bits[503]) ? -12'sd1 : 12'sd0))) +
((((bits[487] ^ bits[488]) ? -12'sd1 : 12'sd0) +
((bits[487] ^ bits[502]) ? -12'sd1 : 12'sd0)) +
(((bits[487] ^ bits[503]) ? 12'sd1 : 12'sd0) +
((bits[487] ^ bits[504]) ? 12'sd1 : 12'sd0))))) +
(((((bits[488] ^ bits[489]) ? -12'sd1 : 12'sd0) +
(((bits[488] ^ bits[503]) ? -12'sd1 : 12'sd0) +
((bits[488] ^ bits[504]) ? 12'sd1 : 12'sd0))) +
((((bits[488] ^ bits[505]) ? -12'sd1 : 12'sd0) +
((bits[489] ^ bits[490]) ? 12'sd1 : 12'sd0)) +
(((bits[489] ^ bits[504]) ? 12'sd1 : 12'sd0) +
((bits[489] ^ bits[505]) ? 12'sd1 : 12'sd0)))) +
(((((bits[489] ^ bits[506]) ? 12'sd1 : 12'sd0) +
((bits[490] ^ bits[491]) ? -12'sd1 : 12'sd0)) +
(((bits[490] ^ bits[505]) ? 12'sd1 : 12'sd0) +
((bits[490] ^ bits[506]) ? -12'sd1 : 12'sd0))) +
((((bits[490] ^ bits[507]) ? -12'sd1 : 12'sd0) +
((bits[491] ^ bits[492]) ? -12'sd1 : 12'sd0)) +
(((bits[491] ^ bits[506]) ? 12'sd1 : 12'sd0) +
((bits[491] ^ bits[507]) ? -12'sd1 : 12'sd0)))))) +
((((((bits[491] ^ bits[508]) ? -12'sd1 : 12'sd0) +
(((bits[492] ^ bits[493]) ? 12'sd1 : 12'sd0) +
((bits[492] ^ bits[507]) ? 12'sd1 : 12'sd0))) +
((((bits[492] ^ bits[508]) ? 12'sd1 : 12'sd0) +
((bits[492] ^ bits[509]) ? 12'sd1 : 12'sd0)) +
(((bits[493] ^ bits[494]) ? 12'sd1 : 12'sd0) +
((bits[493] ^ bits[508]) ? -12'sd1 : 12'sd0)))) +
(((((bits[493] ^ bits[509]) ? 12'sd1 : 12'sd0) +
((bits[493] ^ bits[510]) ? -12'sd1 : 12'sd0)) +
(((bits[494] ^ bits[495]) ? 12'sd1 : 12'sd0) +
((bits[494] ^ bits[509]) ? 12'sd1 : 12'sd0))) +
((((bits[494] ^ bits[510]) ? -12'sd1 : 12'sd0) +
((bits[494] ^ bits[511]) ? 12'sd1 : 12'sd0)) +
(((bits[495] ^ bits[510]) ? 12'sd1 : 12'sd0) +
((bits[495] ^ bits[511]) ? 12'sd1 : 12'sd0))))) +
(((((bits[496] ^ bits[497]) ? 12'sd1 : 12'sd0) +
(((bits[497] ^ bits[498]) ? -12'sd1 : 12'sd0) +
((bits[498] ^ bits[499]) ? -12'sd1 : 12'sd0))) +
((((bits[499] ^ bits[500]) ? 12'sd1 : 12'sd0) +
((bits[500] ^ bits[501]) ? -12'sd1 : 12'sd0)) +
(((bits[501] ^ bits[502]) ? -12'sd1 : 12'sd0) +
((bits[502] ^ bits[503]) ? -12'sd1 : 12'sd0)))) +
(((((bits[503] ^ bits[504]) ? 12'sd1 : 12'sd0) +
((bits[504] ^ bits[505]) ? 12'sd1 : 12'sd0)) +
(((bits[505] ^ bits[506]) ? -12'sd1 : 12'sd0) +
((bits[506] ^ bits[507]) ? -12'sd1 : 12'sd0))) +
((((bits[507] ^ bits[508]) ? 12'sd1 : 12'sd0) +
((bits[508] ^ bits[509]) ? 12'sd1 : 12'sd0)) +
(((bits[509] ^ bits[510]) ? 12'sd1 : 12'sd0) +
((bits[510] ^ bits[511]) ? -12'sd1 : 12'sd0))))))))))));
end
endfunction
function automatic [31:0] probability(input logic [4:0] temp,input logic signed [4:0] raw);
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
17: probability = 32'd4091274722;
18: probability = 32'd3969158894;
19: probability = 32'd3885444463;
20: probability = 32'd3659109422;
21: probability = 32'd3511455637;
22: probability = 32'd3139872687;
23: probability = 32'd2917050301;
24: probability = 32'd2414529686;
25: probability = 32'd2147483648;
26: probability = 32'd2414529686;
27: probability = 32'd2917050301;
28: probability = 32'd3139872687;
29: probability = 32'd3511455637;
30: probability = 32'd3659109422;
31: probability = 32'd3885444463;
32: probability = 32'd3969158894;
33: probability = 32'd4091274722;
34: probability = 32'd4169072224;
35: probability = 32'd4091274722;
36: probability = 32'd3969158894;
37: probability = 32'd3885444463;
38: probability = 32'd3659109422;
39: probability = 32'd3338477483;
40: probability = 32'd2917050301;
41: probability = 32'd2673442471;
42: probability = 32'd2147483648;
43: probability = 32'd2673442471;
44: probability = 32'd2917050301;
45: probability = 32'd3338477483;
46: probability = 32'd3659109422;
47: probability = 32'd3885444463;
48: probability = 32'd3969158894;
49: probability = 32'd4091274722;
50: probability = 32'd4169072224;
51: probability = 32'd4217717112;
52: probability = 32'd4169072224;
53: probability = 32'd4091274722;
54: probability = 32'd3969158894;
55: probability = 32'd3782994644;
56: probability = 32'd3511455637;
57: probability = 32'd3139872687;
58: probability = 32'd2673442471;
59: probability = 32'd2147483648;
60: probability = 32'd2673442471;
61: probability = 32'd3139872687;
62: probability = 32'd3511455637;
63: probability = 32'd3782994644;
64: probability = 32'd3969158894;
65: probability = 32'd4091274722;
66: probability = 32'd4169072224;
67: probability = 32'd4217717112;
68: probability = 32'd4247778737;
69: probability = 32'd4217717112;
70: probability = 32'd4169072224;
71: probability = 32'd4036897099;
72: probability = 32'd3885444463;
73: probability = 32'd3659109422;
74: probability = 32'd3338477483;
75: probability = 32'd2673442471;
76: probability = 32'd2147483648;
77: probability = 32'd2673442471;
78: probability = 32'd3338477483;
79: probability = 32'd3659109422;
80: probability = 32'd3885444463;
81: probability = 32'd4036897099;
82: probability = 32'd4169072224;
83: probability = 32'd4217717112;
84: probability = 32'd4247778737;
85: probability = 32'd4266221720;
86: probability = 32'd4247778737;
87: probability = 32'd4196280244;
88: probability = 32'd4134649536;
89: probability = 32'd3969158894;
90: probability = 32'd3782994644;
91: probability = 32'd3338477483;
92: probability = 32'd2917050301;
93: probability = 32'd2147483648;
94: probability = 32'd2917050301;
95: probability = 32'd3338477483;
96: probability = 32'd3782994644;
97: probability = 32'd3969158894;
98: probability = 32'd4134649536;
99: probability = 32'd4196280244;
100: probability = 32'd4247778737;
101: probability = 32'd4266221720;
102: probability = 32'd4281340727;
103: probability = 32'd4266221720;
104: probability = 32'd4234564478;
105: probability = 32'd4169072224;
106: probability = 32'd4036897099;
107: probability = 32'd3885444463;
108: probability = 32'd3511455637;
109: probability = 32'd2917050301;
110: probability = 32'd2147483648;
111: probability = 32'd2917050301;
112: probability = 32'd3511455637;
113: probability = 32'd3885444463;
114: probability = 32'd4036897099;
115: probability = 32'd4169072224;
116: probability = 32'd4234564478;
117: probability = 32'd4266221720;
118: probability = 32'd4281340727;
119: probability = 32'd4286692034;
120: probability = 32'd4277486188;
121: probability = 32'd4258127277;
122: probability = 32'd4217717112;
123: probability = 32'd4134649536;
124: probability = 32'd3969158894;
125: probability = 32'd3511455637;
126: probability = 32'd2917050301;
127: probability = 32'd2147483648;
128: probability = 32'd2917050301;
129: probability = 32'd3511455637;
130: probability = 32'd3969158894;
131: probability = 32'd4134649536;
132: probability = 32'd4217717112;
133: probability = 32'd4258127277;
134: probability = 32'd4277486188;
135: probability = 32'd4286692034;
136: probability = 32'd4291054361;
137: probability = 32'd4286692034;
138: probability = 32'd4272547027;
139: probability = 32'd4247778737;
140: probability = 32'd4169072224;
141: probability = 32'd4036897099;
142: probability = 32'd3659109422;
143: probability = 32'd3139872687;
144: probability = 32'd2147483648;
145: probability = 32'd3139872687;
146: probability = 32'd3659109422;
147: probability = 32'd4036897099;
148: probability = 32'd4169072224;
149: probability = 32'd4247778737;
150: probability = 32'd4272547027;
151: probability = 32'd4286692034;
152: probability = 32'd4291054361;
153: probability = 32'd4293118067;
154: probability = 32'd4289944288;
155: probability = 32'd4281340727;
156: probability = 32'd4258127277;
157: probability = 32'd4196280244;
158: probability = 32'd4091274722;
159: probability = 32'd3782994644;
160: probability = 32'd3139872687;
161: probability = 32'd2147483648;
162: probability = 32'd3139872687;
163: probability = 32'd3782994644;
164: probability = 32'd4091274722;
165: probability = 32'd4196280244;
166: probability = 32'd4258127277;
167: probability = 32'd4281340727;
168: probability = 32'd4289944288;
169: probability = 32'd4293118067;
170: probability = 32'd4294093584;
171: probability = 32'd4291919285;
172: probability = 32'd4286692034;
173: probability = 32'd4272547027;
174: probability = 32'd4234564478;
175: probability = 32'd4134649536;
176: probability = 32'd3782994644;
177: probability = 32'd3139872687;
178: probability = 32'd2147483648;
179: probability = 32'd3139872687;
180: probability = 32'd3782994644;
181: probability = 32'd4134649536;
182: probability = 32'd4234564478;
183: probability = 32'd4272547027;
184: probability = 32'd4286692034;
185: probability = 32'd4291919285;
186: probability = 32'd4294093584;
187: probability = 32'd4294554539;
188: probability = 32'd4293526978;
189: probability = 32'd4291054361;
190: probability = 32'd4281340727;
191: probability = 32'd4258127277;
192: probability = 32'd4169072224;
193: probability = 32'd3885444463;
194: probability = 32'd3338477483;
195: probability = 32'd2147483648;
196: probability = 32'd3338477483;
197: probability = 32'd3885444463;
198: probability = 32'd4169072224;
199: probability = 32'd4258127277;
200: probability = 32'd4281340727;
201: probability = 32'd4291054361;
202: probability = 32'd4293526978;
203: probability = 32'd4294554539;
204: probability = 32'd4294815442;
205: probability = 32'd4294286818;
206: probability = 32'd4292593130;
207: probability = 32'd4286692034;
208: probability = 32'd4266221720;
209: probability = 32'd4196280244;
210: probability = 32'd3969158894;
211: probability = 32'd3338477483;
212: probability = 32'd2147483648;
213: probability = 32'd3338477483;
214: probability = 32'd3969158894;
215: probability = 32'd4196280244;
216: probability = 32'd4266221720;
217: probability = 32'd4286692034;
218: probability = 32'd4292593130;
219: probability = 32'd4294286818;
220: probability = 32'd4294815442;
221: probability = 32'd4294895564;
222: probability = 32'd4294716937;
223: probability = 32'd4293845492;
224: probability = 32'd4291054361;
225: probability = 32'd4277486188;
226: probability = 32'd4234564478;
227: probability = 32'd4036897099;
228: probability = 32'd3511455637;
229: probability = 32'd2147483648;
230: probability = 32'd3511455637;
231: probability = 32'd4036897099;
232: probability = 32'd4234564478;
233: probability = 32'd4277486188;
234: probability = 32'd4291054361;
235: probability = 32'd4293845492;
236: probability = 32'd4294716937;
237: probability = 32'd4294895564;
238: probability = 32'd4294946744;
239: probability = 32'd4294875191;
240: probability = 32'd4294554539;
241: probability = 32'd4293118067;
242: probability = 32'd4286692034;
243: probability = 32'd4247778737;
244: probability = 32'd4091274722;
245: probability = 32'd3511455637;
246: probability = 32'd2147483648;
247: probability = 32'd3511455637;
248: probability = 32'd4091274722;
249: probability = 32'd4247778737;
250: probability = 32'd4286692034;
251: probability = 32'd4293118067;
252: probability = 32'd4294554539;
253: probability = 32'd4294875191;
254: probability = 32'd4294946744;
255: probability = 32'd4294961408;
256: probability = 32'd4294933412;
257: probability = 32'd4294815442;
258: probability = 32'd4294093584;
259: probability = 32'd4289944288;
260: probability = 32'd4266221720;
261: probability = 32'd4169072224;
262: probability = 32'd3659109422;
263: probability = 32'd2147483648;
264: probability = 32'd3659109422;
265: probability = 32'd4169072224;
266: probability = 32'd4266221720;
267: probability = 32'd4289944288;
268: probability = 32'd4294093584;
269: probability = 32'd4294815442;
270: probability = 32'd4294933412;
271: probability = 32'd4294961408;
272: probability = 32'd4294966273;
273: probability = 32'd4294959735;
274: probability = 32'd4294923788;
275: probability = 32'd4294645834;
276: probability = 32'd4293118067;
277: probability = 32'd4281340727;
278: probability = 32'd4196280244;
279: probability = 32'd3782994644;
280: probability = 32'd2147483648;
281: probability = 32'd3782994644;
282: probability = 32'd4196280244;
283: probability = 32'd4281340727;
284: probability = 32'd4293118067;
285: probability = 32'd4294645834;
286: probability = 32'd4294923788;
287: probability = 32'd4294959735;
288: probability = 32'd4294966273;
289: probability = 32'd4294967188;
290: probability = 32'd4294966273;
291: probability = 32'd4294957588;
292: probability = 32'd4294875191;
293: probability = 32'd4294286818;
294: probability = 32'd4288519767;
295: probability = 32'd4234564478;
296: probability = 32'd3885444463;
297: probability = 32'd2147483648;
298: probability = 32'd3885444463;
299: probability = 32'd4234564478;
300: probability = 32'd4288519767;
301: probability = 32'd4294286818;
302: probability = 32'd4294875191;
303: probability = 32'd4294957588;
304: probability = 32'd4294966273;
305: probability = 32'd4294967188;
306: probability = 32'd4294967289;
307: probability = 32'd4294967212;
308: probability = 32'd4294966273;
309: probability = 32'd4294954831;
310: probability = 32'd4294815442;
311: probability = 32'd4292593130;
312: probability = 32'd4266221720;
313: probability = 32'd3969158894;
314: probability = 32'd2147483648;
315: probability = 32'd3969158894;
316: probability = 32'd4266221720;
317: probability = 32'd4292593130;
318: probability = 32'd4294815442;
319: probability = 32'd4294954831;
320: probability = 32'd4294966273;
321: probability = 32'd4294967212;
322: probability = 32'd4294967289;
323: probability = 32'd4294967295;
324: probability = 32'd4294967295;
325: probability = 32'd4294967231;
326: probability = 32'd4294965982;
327: probability = 32'd4294940907;
328: probability = 32'd4294437320;
329: probability = 32'd4284347460;
330: probability = 32'd4091274722;
331: probability = 32'd2147483648;
332: probability = 32'd4091274722;
333: probability = 32'd4284347460;
334: probability = 32'd4294437320;
335: probability = 32'd4294940907;
336: probability = 32'd4294965982;
337: probability = 32'd4294967231;
338: probability = 32'd4294967295;
339: probability = 32'd4294967295;
340: probability = 32'd4294967295;
341: probability = 32'd4294967295;
342: probability = 32'd4294967295;
343: probability = 32'd4294967231;
344: probability = 32'd4294964515;
345: probability = 32'd4294875191;
346: probability = 32'd4291919285;
347: probability = 32'd4169072224;
348: probability = 32'd2147483648;
349: probability = 32'd4169072224;
350: probability = 32'd4291919285;
351: probability = 32'd4294875191;
352: probability = 32'd4294964515;
353: probability = 32'd4294967231;
354: probability = 32'd4294967295;
355: probability = 32'd4294967295;
356: probability = 32'd4294967295;
357: probability = 32'd4294967295;
358: probability = 32'd4294967295;
359: probability = 32'd4294967295;
360: probability = 32'd4294967295;
361: probability = 32'd4294967188;
362: probability = 32'd4294959735;
363: probability = 32'd4294286818;
364: probability = 32'd4247778737;
365: probability = 32'd2147483648;
366: probability = 32'd4247778737;
367: probability = 32'd4294286818;
368: probability = 32'd4294959735;
369: probability = 32'd4294967188;
370: probability = 32'd4294967295;
371: probability = 32'd4294967295;
372: probability = 32'd4294967295;
373: probability = 32'd4294967295;
374: probability = 32'd4294967295;
375: probability = 32'd4294967295;
376: probability = 32'd4294967295;
377: probability = 32'd4294967295;
378: probability = 32'd4294967295;
379: probability = 32'd4294967003;
380: probability = 32'd4294895564;
381: probability = 32'd4277486188;
382: probability = 32'd2147483648;
383: probability = 32'd4277486188;
384: probability = 32'd4294895564;
385: probability = 32'd4294967003;
386: probability = 32'd4294967295;
387: probability = 32'd4294967295;
388: probability = 32'd4294967295;
389: probability = 32'd4294967295;
390: probability = 32'd4294967295;
391: probability = 32'd4294967295;
392: probability = 32'd4294967295;
393: probability = 32'd4294967295;
394: probability = 32'd4294967295;
395: probability = 32'd4294967295;
396: probability = 32'd4294967231;
397: probability = 32'd4294940907;
398: probability = 32'd4284347460;
399: probability = 32'd2147483648;
400: probability = 32'd4284347460;
401: probability = 32'd4294940907;
402: probability = 32'd4294967231;
403: probability = 32'd4294967295;
404: probability = 32'd4294967295;
405: probability = 32'd4294967295;
406: probability = 32'd4294967295;
407: probability = 32'd4294967295;
default: probability=0;
endcase
end
endfunction
function automatic [31:0] swap_threshold(input logic [4:0] left,input logic [11:0] gap);
begin
case(left)
0: begin case(gap)
1: swap_threshold=32'd4016264695;
2: swap_threshold=32'd3755647247;
3: swap_threshold=32'd3511941396;
4: swap_threshold=32'd3284049742;
5: swap_threshold=32'd3070946093;
6: swap_threshold=32'd2871670847;
7: swap_threshold=32'd2685326673;
8: swap_threshold=32'd2511074467;
9: swap_threshold=32'd2348129574;
10: swap_threshold=32'd2195758258;
11: swap_threshold=32'd2053274393;
12: swap_threshold=32'd1920036379;
13: swap_threshold=32'd1795444247;
14: swap_threshold=32'd1678936961;
15: swap_threshold=32'd1569989892;
16: swap_threshold=32'd1468112454;
17: swap_threshold=32'd1372845894;
18: swap_threshold=32'd1283761229;
19: swap_threshold=32'd1200457314;
20: swap_threshold=32'd1122559031;
21: swap_threshold=32'd1049715608;
22: swap_threshold=32'd981599031;
23: swap_threshold=32'd917902573;
24: swap_threshold=32'd858339411;
25: swap_threshold=32'd802641332;
26: swap_threshold=32'd750557530;
27: swap_threshold=32'd701853472;
28: swap_threshold=32'd656309845;
29: swap_threshold=32'd613721567;
30: swap_threshold=32'd573896864;
31: swap_threshold=32'd536656406;
32: swap_threshold=32'd501832500;
33: swap_threshold=32'd469268335;
34: swap_threshold=32'd438817276;
35: swap_threshold=32'd410342201;
36: swap_threshold=32'd383714888;
37: swap_threshold=32'd358815434;
38: swap_threshold=32'd335531719;
39: swap_threshold=32'd313758896;
40: swap_threshold=32'd293398923;
41: swap_threshold=32'd274360118;
42: swap_threshold=32'd256556751;
43: swap_threshold=32'd239908654;
44: swap_threshold=32'd224340860;
45: swap_threshold=32'd209783268;
46: swap_threshold=32'd196170325;
47: swap_threshold=32'd183440734;
48: swap_threshold=32'd171537172;
49: swap_threshold=32'd160406038;
50: swap_threshold=32'd149997209;
51: swap_threshold=32'd140263814;
52: swap_threshold=32'd131162024;
53: swap_threshold=32'd122650854;
54: swap_threshold=32'd114691978;
55: swap_threshold=32'd107249557;
56: swap_threshold=32'd100290079;
57: swap_threshold=32'd93782205;
58: swap_threshold=32'd87696631;
59: swap_threshold=32'd82005952;
60: swap_threshold=32'd76684544;
61: swap_threshold=32'd71708445;
62: swap_threshold=32'd67055248;
63: swap_threshold=32'd62703999;
64: swap_threshold=32'd58635105;
65: swap_threshold=32'd54830243;
66: swap_threshold=32'd51272281;
67: swap_threshold=32'd47945196;
68: swap_threshold=32'd44834008;
69: swap_threshold=32'd41924707;
70: swap_threshold=32'd39204191;
71: swap_threshold=32'd36660212;
72: swap_threshold=32'd34281312;
73: swap_threshold=32'd32056780;
74: swap_threshold=32'd29976599;
75: swap_threshold=32'd28031403;
76: swap_threshold=32'd26212431;
77: swap_threshold=32'd24511493;
78: swap_threshold=32'd22920930;
79: swap_threshold=32'd21433579;
80: swap_threshold=32'd20042743;
81: swap_threshold=32'd18742159;
82: swap_threshold=32'd17525971;
83: swap_threshold=32'd16388702;
84: swap_threshold=32'd15325231;
85: swap_threshold=32'd14330769;
86: swap_threshold=32'd13400838;
87: swap_threshold=32'd12531251;
88: swap_threshold=32'd11718091;
89: swap_threshold=32'd10957699;
90: swap_threshold=32'd10246648;
91: swap_threshold=32'd9581738;
92: swap_threshold=32'd8959974;
93: swap_threshold=32'd8378557;
94: swap_threshold=32'd7834868;
95: swap_threshold=32'd7326459;
96: swap_threshold=32'd6851042;
97: swap_threshold=32'd6406474;
98: swap_threshold=32'd5990755;
99: swap_threshold=32'd5602011;
100: swap_threshold=32'd5238494;
101: swap_threshold=32'd4898565;
102: swap_threshold=32'd4580695;
103: swap_threshold=32'd4283451;
104: swap_threshold=32'd4005496;
105: swap_threshold=32'd3745577;
106: swap_threshold=32'd3502525;
107: swap_threshold=32'd3275244;
108: swap_threshold=32'd3062712;
109: swap_threshold=32'd2863971;
110: swap_threshold=32'd2678126;
111: swap_threshold=32'd2504341;
112: swap_threshold=32'd2341833;
113: swap_threshold=32'd2189871;
114: swap_threshold=32'd2047769;
115: swap_threshold=32'd1914888;
116: swap_threshold=32'd1790630;
117: swap_threshold=32'd1674435;
118: swap_threshold=32'd1565780;
119: swap_threshold=32'd1464176;
120: swap_threshold=32'd1369165;
121: swap_threshold=32'd1280319;
122: swap_threshold=32'd1197238;
123: swap_threshold=32'd1119549;
124: swap_threshold=32'd1046901;
125: swap_threshold=32'd978967;
126: swap_threshold=32'd915441;
127: swap_threshold=32'd856038;
128: swap_threshold=32'd800489;
129: swap_threshold=32'd748545;
130: swap_threshold=32'd699971;
131: swap_threshold=32'd654550;
132: swap_threshold=32'd612076;
133: swap_threshold=32'd572358;
134: swap_threshold=32'd535217;
135: swap_threshold=32'd500487;
136: swap_threshold=32'd468010;
137: swap_threshold=32'd437640;
138: swap_threshold=32'd409242;
139: swap_threshold=32'd382686;
140: swap_threshold=32'd357853;
141: swap_threshold=32'd334632;
142: swap_threshold=32'd312917;
143: swap_threshold=32'd292612;
144: swap_threshold=32'd273624;
145: swap_threshold=32'd255868;
146: swap_threshold=32'd239265;
147: swap_threshold=32'd223739;
148: swap_threshold=32'd209220;
149: swap_threshold=32'd195644;
150: swap_threshold=32'd182948;
151: swap_threshold=32'd171077;
152: swap_threshold=32'd159975;
153: swap_threshold=32'd149595;
154: swap_threshold=32'd139887;
155: swap_threshold=32'd130810;
156: swap_threshold=32'd122322;
157: swap_threshold=32'd114384;
158: swap_threshold=32'd106962;
159: swap_threshold=32'd100021;
160: swap_threshold=32'd93530;
161: swap_threshold=32'd87461;
162: swap_threshold=32'd81786;
163: swap_threshold=32'd76478;
164: swap_threshold=32'd71516;
165: swap_threshold=32'd66875;
166: swap_threshold=32'd62535;
167: swap_threshold=32'd58477;
168: swap_threshold=32'd54683;
169: swap_threshold=32'd51134;
170: swap_threshold=32'd47816;
171: swap_threshold=32'd44713;
172: swap_threshold=32'd41812;
173: swap_threshold=32'd39099;
174: swap_threshold=32'd36561;
175: swap_threshold=32'd34189;
176: swap_threshold=32'd31970;
177: swap_threshold=32'd29896;
178: swap_threshold=32'd27956;
179: swap_threshold=32'd26142;
180: swap_threshold=32'd24445;
181: swap_threshold=32'd22859;
182: swap_threshold=32'd21376;
183: swap_threshold=32'd19989;
184: swap_threshold=32'd18691;
185: swap_threshold=32'd17478;
186: swap_threshold=32'd16344;
187: swap_threshold=32'd15284;
188: swap_threshold=32'd14292;
189: swap_threshold=32'd13364;
190: swap_threshold=32'd12497;
191: swap_threshold=32'd11686;
192: swap_threshold=32'd10928;
193: swap_threshold=32'd10219;
194: swap_threshold=32'd9556;
195: swap_threshold=32'd8935;
196: swap_threshold=32'd8356;
197: swap_threshold=32'd7813;
198: swap_threshold=32'd7306;
199: swap_threshold=32'd6832;
200: swap_threshold=32'd6389;
201: swap_threshold=32'd5974;
202: swap_threshold=32'd5586;
203: swap_threshold=32'd5224;
204: swap_threshold=32'd4885;
205: swap_threshold=32'd4568;
206: swap_threshold=32'd4271;
207: swap_threshold=32'd3994;
208: swap_threshold=32'd3735;
209: swap_threshold=32'd3493;
210: swap_threshold=32'd3266;
211: swap_threshold=32'd3054;
212: swap_threshold=32'd2856;
213: swap_threshold=32'd2670;
214: swap_threshold=32'd2497;
215: swap_threshold=32'd2335;
216: swap_threshold=32'd2183;
217: swap_threshold=32'd2042;
218: swap_threshold=32'd1909;
219: swap_threshold=32'd1785;
220: swap_threshold=32'd1669;
221: swap_threshold=32'd1561;
222: swap_threshold=32'd1460;
223: swap_threshold=32'd1365;
224: swap_threshold=32'd1276;
225: swap_threshold=32'd1194;
226: swap_threshold=32'd1116;
227: swap_threshold=32'd1044;
228: swap_threshold=32'd976;
229: swap_threshold=32'd912;
230: swap_threshold=32'd853;
231: swap_threshold=32'd798;
232: swap_threshold=32'd746;
233: swap_threshold=32'd698;
234: swap_threshold=32'd652;
235: swap_threshold=32'd610;
236: swap_threshold=32'd570;
237: swap_threshold=32'd533;
238: swap_threshold=32'd499;
239: swap_threshold=32'd466;
240: swap_threshold=32'd436;
241: swap_threshold=32'd408;
242: swap_threshold=32'd381;
243: swap_threshold=32'd356;
244: swap_threshold=32'd333;
245: swap_threshold=32'd312;
246: swap_threshold=32'd291;
247: swap_threshold=32'd272;
248: swap_threshold=32'd255;
249: swap_threshold=32'd238;
250: swap_threshold=32'd223;
251: swap_threshold=32'd208;
252: swap_threshold=32'd195;
253: swap_threshold=32'd182;
254: swap_threshold=32'd170;
255: swap_threshold=32'd159;
256: swap_threshold=32'd149;
257: swap_threshold=32'd139;
258: swap_threshold=32'd130;
259: swap_threshold=32'd121;
260: swap_threshold=32'd114;
261: swap_threshold=32'd106;
262: swap_threshold=32'd99;
263: swap_threshold=32'd93;
264: swap_threshold=32'd87;
265: swap_threshold=32'd81;
266: swap_threshold=32'd76;
267: swap_threshold=32'd71;
268: swap_threshold=32'd66;
269: swap_threshold=32'd62;
270: swap_threshold=32'd58;
271: swap_threshold=32'd54;
272: swap_threshold=32'd50;
273: swap_threshold=32'd47;
274: swap_threshold=32'd44;
275: swap_threshold=32'd41;
276: swap_threshold=32'd38;
277: swap_threshold=32'd36;
278: swap_threshold=32'd34;
279: swap_threshold=32'd31;
280: swap_threshold=32'd29;
281: swap_threshold=32'd27;
282: swap_threshold=32'd26;
283: swap_threshold=32'd24;
284: swap_threshold=32'd22;
285: swap_threshold=32'd21;
286: swap_threshold=32'd19;
287: swap_threshold=32'd18;
288: swap_threshold=32'd17;
289: swap_threshold=32'd16;
290: swap_threshold=32'd15;
291: swap_threshold=32'd14;
292: swap_threshold=32'd13;
293: swap_threshold=32'd12;
294: swap_threshold=32'd11;
295: swap_threshold=32'd10;
296: swap_threshold=32'd10;
297: swap_threshold=32'd9;
298: swap_threshold=32'd8;
299: swap_threshold=32'd8;
300: swap_threshold=32'd7;
301: swap_threshold=32'd7;
302: swap_threshold=32'd6;
303: swap_threshold=32'd6;
304: swap_threshold=32'd5;
305: swap_threshold=32'd5;
306: swap_threshold=32'd5;
307: swap_threshold=32'd4;
308: swap_threshold=32'd4;
309: swap_threshold=32'd4;
310: swap_threshold=32'd3;
311: swap_threshold=32'd3;
312: swap_threshold=32'd3;
313: swap_threshold=32'd3;
314: swap_threshold=32'd3;
315: swap_threshold=32'd2;
316: swap_threshold=32'd2;
317: swap_threshold=32'd2;
318: swap_threshold=32'd2;
319: swap_threshold=32'd2;
320: swap_threshold=32'd2;
321: swap_threshold=32'd1;
322: swap_threshold=32'd1;
323: swap_threshold=32'd1;
324: swap_threshold=32'd1;
325: swap_threshold=32'd1;
326: swap_threshold=32'd1;
327: swap_threshold=32'd1;
328: swap_threshold=32'd1;
329: swap_threshold=32'd1;
330: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
1: begin case(gap)
1: swap_threshold=32'd4016264695;
2: swap_threshold=32'd3755647247;
3: swap_threshold=32'd3511941396;
4: swap_threshold=32'd3284049742;
5: swap_threshold=32'd3070946093;
6: swap_threshold=32'd2871670847;
7: swap_threshold=32'd2685326673;
8: swap_threshold=32'd2511074467;
9: swap_threshold=32'd2348129574;
10: swap_threshold=32'd2195758258;
11: swap_threshold=32'd2053274393;
12: swap_threshold=32'd1920036379;
13: swap_threshold=32'd1795444247;
14: swap_threshold=32'd1678936961;
15: swap_threshold=32'd1569989892;
16: swap_threshold=32'd1468112454;
17: swap_threshold=32'd1372845894;
18: swap_threshold=32'd1283761229;
19: swap_threshold=32'd1200457314;
20: swap_threshold=32'd1122559031;
21: swap_threshold=32'd1049715608;
22: swap_threshold=32'd981599031;
23: swap_threshold=32'd917902573;
24: swap_threshold=32'd858339411;
25: swap_threshold=32'd802641332;
26: swap_threshold=32'd750557530;
27: swap_threshold=32'd701853472;
28: swap_threshold=32'd656309845;
29: swap_threshold=32'd613721567;
30: swap_threshold=32'd573896864;
31: swap_threshold=32'd536656406;
32: swap_threshold=32'd501832500;
33: swap_threshold=32'd469268335;
34: swap_threshold=32'd438817276;
35: swap_threshold=32'd410342201;
36: swap_threshold=32'd383714888;
37: swap_threshold=32'd358815434;
38: swap_threshold=32'd335531719;
39: swap_threshold=32'd313758896;
40: swap_threshold=32'd293398923;
41: swap_threshold=32'd274360118;
42: swap_threshold=32'd256556751;
43: swap_threshold=32'd239908654;
44: swap_threshold=32'd224340860;
45: swap_threshold=32'd209783268;
46: swap_threshold=32'd196170325;
47: swap_threshold=32'd183440734;
48: swap_threshold=32'd171537172;
49: swap_threshold=32'd160406038;
50: swap_threshold=32'd149997209;
51: swap_threshold=32'd140263814;
52: swap_threshold=32'd131162024;
53: swap_threshold=32'd122650854;
54: swap_threshold=32'd114691978;
55: swap_threshold=32'd107249557;
56: swap_threshold=32'd100290079;
57: swap_threshold=32'd93782205;
58: swap_threshold=32'd87696631;
59: swap_threshold=32'd82005952;
60: swap_threshold=32'd76684544;
61: swap_threshold=32'd71708445;
62: swap_threshold=32'd67055248;
63: swap_threshold=32'd62703999;
64: swap_threshold=32'd58635105;
65: swap_threshold=32'd54830243;
66: swap_threshold=32'd51272281;
67: swap_threshold=32'd47945196;
68: swap_threshold=32'd44834008;
69: swap_threshold=32'd41924707;
70: swap_threshold=32'd39204191;
71: swap_threshold=32'd36660212;
72: swap_threshold=32'd34281312;
73: swap_threshold=32'd32056780;
74: swap_threshold=32'd29976599;
75: swap_threshold=32'd28031403;
76: swap_threshold=32'd26212431;
77: swap_threshold=32'd24511493;
78: swap_threshold=32'd22920930;
79: swap_threshold=32'd21433579;
80: swap_threshold=32'd20042743;
81: swap_threshold=32'd18742159;
82: swap_threshold=32'd17525971;
83: swap_threshold=32'd16388702;
84: swap_threshold=32'd15325231;
85: swap_threshold=32'd14330769;
86: swap_threshold=32'd13400838;
87: swap_threshold=32'd12531251;
88: swap_threshold=32'd11718091;
89: swap_threshold=32'd10957699;
90: swap_threshold=32'd10246648;
91: swap_threshold=32'd9581738;
92: swap_threshold=32'd8959974;
93: swap_threshold=32'd8378557;
94: swap_threshold=32'd7834868;
95: swap_threshold=32'd7326459;
96: swap_threshold=32'd6851042;
97: swap_threshold=32'd6406474;
98: swap_threshold=32'd5990755;
99: swap_threshold=32'd5602011;
100: swap_threshold=32'd5238494;
101: swap_threshold=32'd4898565;
102: swap_threshold=32'd4580695;
103: swap_threshold=32'd4283451;
104: swap_threshold=32'd4005496;
105: swap_threshold=32'd3745577;
106: swap_threshold=32'd3502525;
107: swap_threshold=32'd3275244;
108: swap_threshold=32'd3062712;
109: swap_threshold=32'd2863971;
110: swap_threshold=32'd2678126;
111: swap_threshold=32'd2504341;
112: swap_threshold=32'd2341833;
113: swap_threshold=32'd2189871;
114: swap_threshold=32'd2047769;
115: swap_threshold=32'd1914888;
116: swap_threshold=32'd1790630;
117: swap_threshold=32'd1674435;
118: swap_threshold=32'd1565780;
119: swap_threshold=32'd1464176;
120: swap_threshold=32'd1369165;
121: swap_threshold=32'd1280319;
122: swap_threshold=32'd1197238;
123: swap_threshold=32'd1119549;
124: swap_threshold=32'd1046901;
125: swap_threshold=32'd978967;
126: swap_threshold=32'd915441;
127: swap_threshold=32'd856038;
128: swap_threshold=32'd800489;
129: swap_threshold=32'd748545;
130: swap_threshold=32'd699971;
131: swap_threshold=32'd654550;
132: swap_threshold=32'd612076;
133: swap_threshold=32'd572358;
134: swap_threshold=32'd535217;
135: swap_threshold=32'd500487;
136: swap_threshold=32'd468010;
137: swap_threshold=32'd437640;
138: swap_threshold=32'd409242;
139: swap_threshold=32'd382686;
140: swap_threshold=32'd357853;
141: swap_threshold=32'd334632;
142: swap_threshold=32'd312917;
143: swap_threshold=32'd292612;
144: swap_threshold=32'd273624;
145: swap_threshold=32'd255868;
146: swap_threshold=32'd239265;
147: swap_threshold=32'd223739;
148: swap_threshold=32'd209220;
149: swap_threshold=32'd195644;
150: swap_threshold=32'd182948;
151: swap_threshold=32'd171077;
152: swap_threshold=32'd159975;
153: swap_threshold=32'd149595;
154: swap_threshold=32'd139887;
155: swap_threshold=32'd130810;
156: swap_threshold=32'd122322;
157: swap_threshold=32'd114384;
158: swap_threshold=32'd106962;
159: swap_threshold=32'd100021;
160: swap_threshold=32'd93530;
161: swap_threshold=32'd87461;
162: swap_threshold=32'd81786;
163: swap_threshold=32'd76478;
164: swap_threshold=32'd71516;
165: swap_threshold=32'd66875;
166: swap_threshold=32'd62535;
167: swap_threshold=32'd58477;
168: swap_threshold=32'd54683;
169: swap_threshold=32'd51134;
170: swap_threshold=32'd47816;
171: swap_threshold=32'd44713;
172: swap_threshold=32'd41812;
173: swap_threshold=32'd39099;
174: swap_threshold=32'd36561;
175: swap_threshold=32'd34189;
176: swap_threshold=32'd31970;
177: swap_threshold=32'd29896;
178: swap_threshold=32'd27956;
179: swap_threshold=32'd26142;
180: swap_threshold=32'd24445;
181: swap_threshold=32'd22859;
182: swap_threshold=32'd21376;
183: swap_threshold=32'd19989;
184: swap_threshold=32'd18691;
185: swap_threshold=32'd17478;
186: swap_threshold=32'd16344;
187: swap_threshold=32'd15284;
188: swap_threshold=32'd14292;
189: swap_threshold=32'd13364;
190: swap_threshold=32'd12497;
191: swap_threshold=32'd11686;
192: swap_threshold=32'd10928;
193: swap_threshold=32'd10219;
194: swap_threshold=32'd9556;
195: swap_threshold=32'd8935;
196: swap_threshold=32'd8356;
197: swap_threshold=32'd7813;
198: swap_threshold=32'd7306;
199: swap_threshold=32'd6832;
200: swap_threshold=32'd6389;
201: swap_threshold=32'd5974;
202: swap_threshold=32'd5586;
203: swap_threshold=32'd5224;
204: swap_threshold=32'd4885;
205: swap_threshold=32'd4568;
206: swap_threshold=32'd4271;
207: swap_threshold=32'd3994;
208: swap_threshold=32'd3735;
209: swap_threshold=32'd3493;
210: swap_threshold=32'd3266;
211: swap_threshold=32'd3054;
212: swap_threshold=32'd2856;
213: swap_threshold=32'd2670;
214: swap_threshold=32'd2497;
215: swap_threshold=32'd2335;
216: swap_threshold=32'd2183;
217: swap_threshold=32'd2042;
218: swap_threshold=32'd1909;
219: swap_threshold=32'd1785;
220: swap_threshold=32'd1669;
221: swap_threshold=32'd1561;
222: swap_threshold=32'd1460;
223: swap_threshold=32'd1365;
224: swap_threshold=32'd1276;
225: swap_threshold=32'd1194;
226: swap_threshold=32'd1116;
227: swap_threshold=32'd1044;
228: swap_threshold=32'd976;
229: swap_threshold=32'd912;
230: swap_threshold=32'd853;
231: swap_threshold=32'd798;
232: swap_threshold=32'd746;
233: swap_threshold=32'd698;
234: swap_threshold=32'd652;
235: swap_threshold=32'd610;
236: swap_threshold=32'd570;
237: swap_threshold=32'd533;
238: swap_threshold=32'd499;
239: swap_threshold=32'd466;
240: swap_threshold=32'd436;
241: swap_threshold=32'd408;
242: swap_threshold=32'd381;
243: swap_threshold=32'd356;
244: swap_threshold=32'd333;
245: swap_threshold=32'd312;
246: swap_threshold=32'd291;
247: swap_threshold=32'd272;
248: swap_threshold=32'd255;
249: swap_threshold=32'd238;
250: swap_threshold=32'd223;
251: swap_threshold=32'd208;
252: swap_threshold=32'd195;
253: swap_threshold=32'd182;
254: swap_threshold=32'd170;
255: swap_threshold=32'd159;
256: swap_threshold=32'd149;
257: swap_threshold=32'd139;
258: swap_threshold=32'd130;
259: swap_threshold=32'd121;
260: swap_threshold=32'd114;
261: swap_threshold=32'd106;
262: swap_threshold=32'd99;
263: swap_threshold=32'd93;
264: swap_threshold=32'd87;
265: swap_threshold=32'd81;
266: swap_threshold=32'd76;
267: swap_threshold=32'd71;
268: swap_threshold=32'd66;
269: swap_threshold=32'd62;
270: swap_threshold=32'd58;
271: swap_threshold=32'd54;
272: swap_threshold=32'd50;
273: swap_threshold=32'd47;
274: swap_threshold=32'd44;
275: swap_threshold=32'd41;
276: swap_threshold=32'd38;
277: swap_threshold=32'd36;
278: swap_threshold=32'd34;
279: swap_threshold=32'd31;
280: swap_threshold=32'd29;
281: swap_threshold=32'd27;
282: swap_threshold=32'd26;
283: swap_threshold=32'd24;
284: swap_threshold=32'd22;
285: swap_threshold=32'd21;
286: swap_threshold=32'd19;
287: swap_threshold=32'd18;
288: swap_threshold=32'd17;
289: swap_threshold=32'd16;
290: swap_threshold=32'd15;
291: swap_threshold=32'd14;
292: swap_threshold=32'd13;
293: swap_threshold=32'd12;
294: swap_threshold=32'd11;
295: swap_threshold=32'd10;
296: swap_threshold=32'd10;
297: swap_threshold=32'd9;
298: swap_threshold=32'd8;
299: swap_threshold=32'd8;
300: swap_threshold=32'd7;
301: swap_threshold=32'd7;
302: swap_threshold=32'd6;
303: swap_threshold=32'd6;
304: swap_threshold=32'd5;
305: swap_threshold=32'd5;
306: swap_threshold=32'd5;
307: swap_threshold=32'd4;
308: swap_threshold=32'd4;
309: swap_threshold=32'd4;
310: swap_threshold=32'd3;
311: swap_threshold=32'd3;
312: swap_threshold=32'd3;
313: swap_threshold=32'd3;
314: swap_threshold=32'd3;
315: swap_threshold=32'd2;
316: swap_threshold=32'd2;
317: swap_threshold=32'd2;
318: swap_threshold=32'd2;
319: swap_threshold=32'd2;
320: swap_threshold=32'd2;
321: swap_threshold=32'd1;
322: swap_threshold=32'd1;
323: swap_threshold=32'd1;
324: swap_threshold=32'd1;
325: swap_threshold=32'd1;
326: swap_threshold=32'd1;
327: swap_threshold=32'd1;
328: swap_threshold=32'd1;
329: swap_threshold=32'd1;
330: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
2: begin case(gap)
1: swap_threshold=32'd4016264695;
2: swap_threshold=32'd3755647247;
3: swap_threshold=32'd3511941396;
4: swap_threshold=32'd3284049742;
5: swap_threshold=32'd3070946093;
6: swap_threshold=32'd2871670847;
7: swap_threshold=32'd2685326673;
8: swap_threshold=32'd2511074467;
9: swap_threshold=32'd2348129574;
10: swap_threshold=32'd2195758258;
11: swap_threshold=32'd2053274393;
12: swap_threshold=32'd1920036379;
13: swap_threshold=32'd1795444247;
14: swap_threshold=32'd1678936961;
15: swap_threshold=32'd1569989892;
16: swap_threshold=32'd1468112454;
17: swap_threshold=32'd1372845894;
18: swap_threshold=32'd1283761229;
19: swap_threshold=32'd1200457314;
20: swap_threshold=32'd1122559031;
21: swap_threshold=32'd1049715608;
22: swap_threshold=32'd981599031;
23: swap_threshold=32'd917902573;
24: swap_threshold=32'd858339411;
25: swap_threshold=32'd802641332;
26: swap_threshold=32'd750557530;
27: swap_threshold=32'd701853472;
28: swap_threshold=32'd656309845;
29: swap_threshold=32'd613721567;
30: swap_threshold=32'd573896864;
31: swap_threshold=32'd536656406;
32: swap_threshold=32'd501832500;
33: swap_threshold=32'd469268335;
34: swap_threshold=32'd438817276;
35: swap_threshold=32'd410342201;
36: swap_threshold=32'd383714888;
37: swap_threshold=32'd358815434;
38: swap_threshold=32'd335531719;
39: swap_threshold=32'd313758896;
40: swap_threshold=32'd293398923;
41: swap_threshold=32'd274360118;
42: swap_threshold=32'd256556751;
43: swap_threshold=32'd239908654;
44: swap_threshold=32'd224340860;
45: swap_threshold=32'd209783268;
46: swap_threshold=32'd196170325;
47: swap_threshold=32'd183440734;
48: swap_threshold=32'd171537172;
49: swap_threshold=32'd160406038;
50: swap_threshold=32'd149997209;
51: swap_threshold=32'd140263814;
52: swap_threshold=32'd131162024;
53: swap_threshold=32'd122650854;
54: swap_threshold=32'd114691978;
55: swap_threshold=32'd107249557;
56: swap_threshold=32'd100290079;
57: swap_threshold=32'd93782205;
58: swap_threshold=32'd87696631;
59: swap_threshold=32'd82005952;
60: swap_threshold=32'd76684544;
61: swap_threshold=32'd71708445;
62: swap_threshold=32'd67055248;
63: swap_threshold=32'd62703999;
64: swap_threshold=32'd58635105;
65: swap_threshold=32'd54830243;
66: swap_threshold=32'd51272281;
67: swap_threshold=32'd47945196;
68: swap_threshold=32'd44834008;
69: swap_threshold=32'd41924707;
70: swap_threshold=32'd39204191;
71: swap_threshold=32'd36660212;
72: swap_threshold=32'd34281312;
73: swap_threshold=32'd32056780;
74: swap_threshold=32'd29976599;
75: swap_threshold=32'd28031403;
76: swap_threshold=32'd26212431;
77: swap_threshold=32'd24511493;
78: swap_threshold=32'd22920930;
79: swap_threshold=32'd21433579;
80: swap_threshold=32'd20042743;
81: swap_threshold=32'd18742159;
82: swap_threshold=32'd17525971;
83: swap_threshold=32'd16388702;
84: swap_threshold=32'd15325231;
85: swap_threshold=32'd14330769;
86: swap_threshold=32'd13400838;
87: swap_threshold=32'd12531251;
88: swap_threshold=32'd11718091;
89: swap_threshold=32'd10957699;
90: swap_threshold=32'd10246648;
91: swap_threshold=32'd9581738;
92: swap_threshold=32'd8959974;
93: swap_threshold=32'd8378557;
94: swap_threshold=32'd7834868;
95: swap_threshold=32'd7326459;
96: swap_threshold=32'd6851042;
97: swap_threshold=32'd6406474;
98: swap_threshold=32'd5990755;
99: swap_threshold=32'd5602011;
100: swap_threshold=32'd5238494;
101: swap_threshold=32'd4898565;
102: swap_threshold=32'd4580695;
103: swap_threshold=32'd4283451;
104: swap_threshold=32'd4005496;
105: swap_threshold=32'd3745577;
106: swap_threshold=32'd3502525;
107: swap_threshold=32'd3275244;
108: swap_threshold=32'd3062712;
109: swap_threshold=32'd2863971;
110: swap_threshold=32'd2678126;
111: swap_threshold=32'd2504341;
112: swap_threshold=32'd2341833;
113: swap_threshold=32'd2189871;
114: swap_threshold=32'd2047769;
115: swap_threshold=32'd1914888;
116: swap_threshold=32'd1790630;
117: swap_threshold=32'd1674435;
118: swap_threshold=32'd1565780;
119: swap_threshold=32'd1464176;
120: swap_threshold=32'd1369165;
121: swap_threshold=32'd1280319;
122: swap_threshold=32'd1197238;
123: swap_threshold=32'd1119549;
124: swap_threshold=32'd1046901;
125: swap_threshold=32'd978967;
126: swap_threshold=32'd915441;
127: swap_threshold=32'd856038;
128: swap_threshold=32'd800489;
129: swap_threshold=32'd748545;
130: swap_threshold=32'd699971;
131: swap_threshold=32'd654550;
132: swap_threshold=32'd612076;
133: swap_threshold=32'd572358;
134: swap_threshold=32'd535217;
135: swap_threshold=32'd500487;
136: swap_threshold=32'd468010;
137: swap_threshold=32'd437640;
138: swap_threshold=32'd409242;
139: swap_threshold=32'd382686;
140: swap_threshold=32'd357853;
141: swap_threshold=32'd334632;
142: swap_threshold=32'd312917;
143: swap_threshold=32'd292612;
144: swap_threshold=32'd273624;
145: swap_threshold=32'd255868;
146: swap_threshold=32'd239265;
147: swap_threshold=32'd223739;
148: swap_threshold=32'd209220;
149: swap_threshold=32'd195644;
150: swap_threshold=32'd182948;
151: swap_threshold=32'd171077;
152: swap_threshold=32'd159975;
153: swap_threshold=32'd149595;
154: swap_threshold=32'd139887;
155: swap_threshold=32'd130810;
156: swap_threshold=32'd122322;
157: swap_threshold=32'd114384;
158: swap_threshold=32'd106962;
159: swap_threshold=32'd100021;
160: swap_threshold=32'd93530;
161: swap_threshold=32'd87461;
162: swap_threshold=32'd81786;
163: swap_threshold=32'd76478;
164: swap_threshold=32'd71516;
165: swap_threshold=32'd66875;
166: swap_threshold=32'd62535;
167: swap_threshold=32'd58477;
168: swap_threshold=32'd54683;
169: swap_threshold=32'd51134;
170: swap_threshold=32'd47816;
171: swap_threshold=32'd44713;
172: swap_threshold=32'd41812;
173: swap_threshold=32'd39099;
174: swap_threshold=32'd36561;
175: swap_threshold=32'd34189;
176: swap_threshold=32'd31970;
177: swap_threshold=32'd29896;
178: swap_threshold=32'd27956;
179: swap_threshold=32'd26142;
180: swap_threshold=32'd24445;
181: swap_threshold=32'd22859;
182: swap_threshold=32'd21376;
183: swap_threshold=32'd19989;
184: swap_threshold=32'd18691;
185: swap_threshold=32'd17478;
186: swap_threshold=32'd16344;
187: swap_threshold=32'd15284;
188: swap_threshold=32'd14292;
189: swap_threshold=32'd13364;
190: swap_threshold=32'd12497;
191: swap_threshold=32'd11686;
192: swap_threshold=32'd10928;
193: swap_threshold=32'd10219;
194: swap_threshold=32'd9556;
195: swap_threshold=32'd8935;
196: swap_threshold=32'd8356;
197: swap_threshold=32'd7813;
198: swap_threshold=32'd7306;
199: swap_threshold=32'd6832;
200: swap_threshold=32'd6389;
201: swap_threshold=32'd5974;
202: swap_threshold=32'd5586;
203: swap_threshold=32'd5224;
204: swap_threshold=32'd4885;
205: swap_threshold=32'd4568;
206: swap_threshold=32'd4271;
207: swap_threshold=32'd3994;
208: swap_threshold=32'd3735;
209: swap_threshold=32'd3493;
210: swap_threshold=32'd3266;
211: swap_threshold=32'd3054;
212: swap_threshold=32'd2856;
213: swap_threshold=32'd2670;
214: swap_threshold=32'd2497;
215: swap_threshold=32'd2335;
216: swap_threshold=32'd2183;
217: swap_threshold=32'd2042;
218: swap_threshold=32'd1909;
219: swap_threshold=32'd1785;
220: swap_threshold=32'd1669;
221: swap_threshold=32'd1561;
222: swap_threshold=32'd1460;
223: swap_threshold=32'd1365;
224: swap_threshold=32'd1276;
225: swap_threshold=32'd1194;
226: swap_threshold=32'd1116;
227: swap_threshold=32'd1044;
228: swap_threshold=32'd976;
229: swap_threshold=32'd912;
230: swap_threshold=32'd853;
231: swap_threshold=32'd798;
232: swap_threshold=32'd746;
233: swap_threshold=32'd698;
234: swap_threshold=32'd652;
235: swap_threshold=32'd610;
236: swap_threshold=32'd570;
237: swap_threshold=32'd533;
238: swap_threshold=32'd499;
239: swap_threshold=32'd466;
240: swap_threshold=32'd436;
241: swap_threshold=32'd408;
242: swap_threshold=32'd381;
243: swap_threshold=32'd356;
244: swap_threshold=32'd333;
245: swap_threshold=32'd312;
246: swap_threshold=32'd291;
247: swap_threshold=32'd272;
248: swap_threshold=32'd255;
249: swap_threshold=32'd238;
250: swap_threshold=32'd223;
251: swap_threshold=32'd208;
252: swap_threshold=32'd195;
253: swap_threshold=32'd182;
254: swap_threshold=32'd170;
255: swap_threshold=32'd159;
256: swap_threshold=32'd149;
257: swap_threshold=32'd139;
258: swap_threshold=32'd130;
259: swap_threshold=32'd121;
260: swap_threshold=32'd114;
261: swap_threshold=32'd106;
262: swap_threshold=32'd99;
263: swap_threshold=32'd93;
264: swap_threshold=32'd87;
265: swap_threshold=32'd81;
266: swap_threshold=32'd76;
267: swap_threshold=32'd71;
268: swap_threshold=32'd66;
269: swap_threshold=32'd62;
270: swap_threshold=32'd58;
271: swap_threshold=32'd54;
272: swap_threshold=32'd50;
273: swap_threshold=32'd47;
274: swap_threshold=32'd44;
275: swap_threshold=32'd41;
276: swap_threshold=32'd38;
277: swap_threshold=32'd36;
278: swap_threshold=32'd34;
279: swap_threshold=32'd31;
280: swap_threshold=32'd29;
281: swap_threshold=32'd27;
282: swap_threshold=32'd26;
283: swap_threshold=32'd24;
284: swap_threshold=32'd22;
285: swap_threshold=32'd21;
286: swap_threshold=32'd19;
287: swap_threshold=32'd18;
288: swap_threshold=32'd17;
289: swap_threshold=32'd16;
290: swap_threshold=32'd15;
291: swap_threshold=32'd14;
292: swap_threshold=32'd13;
293: swap_threshold=32'd12;
294: swap_threshold=32'd11;
295: swap_threshold=32'd10;
296: swap_threshold=32'd10;
297: swap_threshold=32'd9;
298: swap_threshold=32'd8;
299: swap_threshold=32'd8;
300: swap_threshold=32'd7;
301: swap_threshold=32'd7;
302: swap_threshold=32'd6;
303: swap_threshold=32'd6;
304: swap_threshold=32'd5;
305: swap_threshold=32'd5;
306: swap_threshold=32'd5;
307: swap_threshold=32'd4;
308: swap_threshold=32'd4;
309: swap_threshold=32'd4;
310: swap_threshold=32'd3;
311: swap_threshold=32'd3;
312: swap_threshold=32'd3;
313: swap_threshold=32'd3;
314: swap_threshold=32'd3;
315: swap_threshold=32'd2;
316: swap_threshold=32'd2;
317: swap_threshold=32'd2;
318: swap_threshold=32'd2;
319: swap_threshold=32'd2;
320: swap_threshold=32'd2;
321: swap_threshold=32'd1;
322: swap_threshold=32'd1;
323: swap_threshold=32'd1;
324: swap_threshold=32'd1;
325: swap_threshold=32'd1;
326: swap_threshold=32'd1;
327: swap_threshold=32'd1;
328: swap_threshold=32'd1;
329: swap_threshold=32'd1;
330: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
3: begin case(gap)
1: swap_threshold=32'd4016264695;
2: swap_threshold=32'd3755647247;
3: swap_threshold=32'd3511941396;
4: swap_threshold=32'd3284049742;
5: swap_threshold=32'd3070946093;
6: swap_threshold=32'd2871670847;
7: swap_threshold=32'd2685326673;
8: swap_threshold=32'd2511074467;
9: swap_threshold=32'd2348129574;
10: swap_threshold=32'd2195758258;
11: swap_threshold=32'd2053274393;
12: swap_threshold=32'd1920036379;
13: swap_threshold=32'd1795444247;
14: swap_threshold=32'd1678936961;
15: swap_threshold=32'd1569989892;
16: swap_threshold=32'd1468112454;
17: swap_threshold=32'd1372845894;
18: swap_threshold=32'd1283761229;
19: swap_threshold=32'd1200457314;
20: swap_threshold=32'd1122559031;
21: swap_threshold=32'd1049715608;
22: swap_threshold=32'd981599031;
23: swap_threshold=32'd917902573;
24: swap_threshold=32'd858339411;
25: swap_threshold=32'd802641332;
26: swap_threshold=32'd750557530;
27: swap_threshold=32'd701853472;
28: swap_threshold=32'd656309845;
29: swap_threshold=32'd613721567;
30: swap_threshold=32'd573896864;
31: swap_threshold=32'd536656406;
32: swap_threshold=32'd501832500;
33: swap_threshold=32'd469268335;
34: swap_threshold=32'd438817276;
35: swap_threshold=32'd410342201;
36: swap_threshold=32'd383714888;
37: swap_threshold=32'd358815434;
38: swap_threshold=32'd335531719;
39: swap_threshold=32'd313758896;
40: swap_threshold=32'd293398923;
41: swap_threshold=32'd274360118;
42: swap_threshold=32'd256556751;
43: swap_threshold=32'd239908654;
44: swap_threshold=32'd224340860;
45: swap_threshold=32'd209783268;
46: swap_threshold=32'd196170325;
47: swap_threshold=32'd183440734;
48: swap_threshold=32'd171537172;
49: swap_threshold=32'd160406038;
50: swap_threshold=32'd149997209;
51: swap_threshold=32'd140263814;
52: swap_threshold=32'd131162024;
53: swap_threshold=32'd122650854;
54: swap_threshold=32'd114691978;
55: swap_threshold=32'd107249557;
56: swap_threshold=32'd100290079;
57: swap_threshold=32'd93782205;
58: swap_threshold=32'd87696631;
59: swap_threshold=32'd82005952;
60: swap_threshold=32'd76684544;
61: swap_threshold=32'd71708445;
62: swap_threshold=32'd67055248;
63: swap_threshold=32'd62703999;
64: swap_threshold=32'd58635105;
65: swap_threshold=32'd54830243;
66: swap_threshold=32'd51272281;
67: swap_threshold=32'd47945196;
68: swap_threshold=32'd44834008;
69: swap_threshold=32'd41924707;
70: swap_threshold=32'd39204191;
71: swap_threshold=32'd36660212;
72: swap_threshold=32'd34281312;
73: swap_threshold=32'd32056780;
74: swap_threshold=32'd29976599;
75: swap_threshold=32'd28031403;
76: swap_threshold=32'd26212431;
77: swap_threshold=32'd24511493;
78: swap_threshold=32'd22920930;
79: swap_threshold=32'd21433579;
80: swap_threshold=32'd20042743;
81: swap_threshold=32'd18742159;
82: swap_threshold=32'd17525971;
83: swap_threshold=32'd16388702;
84: swap_threshold=32'd15325231;
85: swap_threshold=32'd14330769;
86: swap_threshold=32'd13400838;
87: swap_threshold=32'd12531251;
88: swap_threshold=32'd11718091;
89: swap_threshold=32'd10957699;
90: swap_threshold=32'd10246648;
91: swap_threshold=32'd9581738;
92: swap_threshold=32'd8959974;
93: swap_threshold=32'd8378557;
94: swap_threshold=32'd7834868;
95: swap_threshold=32'd7326459;
96: swap_threshold=32'd6851042;
97: swap_threshold=32'd6406474;
98: swap_threshold=32'd5990755;
99: swap_threshold=32'd5602011;
100: swap_threshold=32'd5238494;
101: swap_threshold=32'd4898565;
102: swap_threshold=32'd4580695;
103: swap_threshold=32'd4283451;
104: swap_threshold=32'd4005496;
105: swap_threshold=32'd3745577;
106: swap_threshold=32'd3502525;
107: swap_threshold=32'd3275244;
108: swap_threshold=32'd3062712;
109: swap_threshold=32'd2863971;
110: swap_threshold=32'd2678126;
111: swap_threshold=32'd2504341;
112: swap_threshold=32'd2341833;
113: swap_threshold=32'd2189871;
114: swap_threshold=32'd2047769;
115: swap_threshold=32'd1914888;
116: swap_threshold=32'd1790630;
117: swap_threshold=32'd1674435;
118: swap_threshold=32'd1565780;
119: swap_threshold=32'd1464176;
120: swap_threshold=32'd1369165;
121: swap_threshold=32'd1280319;
122: swap_threshold=32'd1197238;
123: swap_threshold=32'd1119549;
124: swap_threshold=32'd1046901;
125: swap_threshold=32'd978967;
126: swap_threshold=32'd915441;
127: swap_threshold=32'd856038;
128: swap_threshold=32'd800489;
129: swap_threshold=32'd748545;
130: swap_threshold=32'd699971;
131: swap_threshold=32'd654550;
132: swap_threshold=32'd612076;
133: swap_threshold=32'd572358;
134: swap_threshold=32'd535217;
135: swap_threshold=32'd500487;
136: swap_threshold=32'd468010;
137: swap_threshold=32'd437640;
138: swap_threshold=32'd409242;
139: swap_threshold=32'd382686;
140: swap_threshold=32'd357853;
141: swap_threshold=32'd334632;
142: swap_threshold=32'd312917;
143: swap_threshold=32'd292612;
144: swap_threshold=32'd273624;
145: swap_threshold=32'd255868;
146: swap_threshold=32'd239265;
147: swap_threshold=32'd223739;
148: swap_threshold=32'd209220;
149: swap_threshold=32'd195644;
150: swap_threshold=32'd182948;
151: swap_threshold=32'd171077;
152: swap_threshold=32'd159975;
153: swap_threshold=32'd149595;
154: swap_threshold=32'd139887;
155: swap_threshold=32'd130810;
156: swap_threshold=32'd122322;
157: swap_threshold=32'd114384;
158: swap_threshold=32'd106962;
159: swap_threshold=32'd100021;
160: swap_threshold=32'd93530;
161: swap_threshold=32'd87461;
162: swap_threshold=32'd81786;
163: swap_threshold=32'd76478;
164: swap_threshold=32'd71516;
165: swap_threshold=32'd66875;
166: swap_threshold=32'd62535;
167: swap_threshold=32'd58477;
168: swap_threshold=32'd54683;
169: swap_threshold=32'd51134;
170: swap_threshold=32'd47816;
171: swap_threshold=32'd44713;
172: swap_threshold=32'd41812;
173: swap_threshold=32'd39099;
174: swap_threshold=32'd36561;
175: swap_threshold=32'd34189;
176: swap_threshold=32'd31970;
177: swap_threshold=32'd29896;
178: swap_threshold=32'd27956;
179: swap_threshold=32'd26142;
180: swap_threshold=32'd24445;
181: swap_threshold=32'd22859;
182: swap_threshold=32'd21376;
183: swap_threshold=32'd19989;
184: swap_threshold=32'd18691;
185: swap_threshold=32'd17478;
186: swap_threshold=32'd16344;
187: swap_threshold=32'd15284;
188: swap_threshold=32'd14292;
189: swap_threshold=32'd13364;
190: swap_threshold=32'd12497;
191: swap_threshold=32'd11686;
192: swap_threshold=32'd10928;
193: swap_threshold=32'd10219;
194: swap_threshold=32'd9556;
195: swap_threshold=32'd8935;
196: swap_threshold=32'd8356;
197: swap_threshold=32'd7813;
198: swap_threshold=32'd7306;
199: swap_threshold=32'd6832;
200: swap_threshold=32'd6389;
201: swap_threshold=32'd5974;
202: swap_threshold=32'd5586;
203: swap_threshold=32'd5224;
204: swap_threshold=32'd4885;
205: swap_threshold=32'd4568;
206: swap_threshold=32'd4271;
207: swap_threshold=32'd3994;
208: swap_threshold=32'd3735;
209: swap_threshold=32'd3493;
210: swap_threshold=32'd3266;
211: swap_threshold=32'd3054;
212: swap_threshold=32'd2856;
213: swap_threshold=32'd2670;
214: swap_threshold=32'd2497;
215: swap_threshold=32'd2335;
216: swap_threshold=32'd2183;
217: swap_threshold=32'd2042;
218: swap_threshold=32'd1909;
219: swap_threshold=32'd1785;
220: swap_threshold=32'd1669;
221: swap_threshold=32'd1561;
222: swap_threshold=32'd1460;
223: swap_threshold=32'd1365;
224: swap_threshold=32'd1276;
225: swap_threshold=32'd1194;
226: swap_threshold=32'd1116;
227: swap_threshold=32'd1044;
228: swap_threshold=32'd976;
229: swap_threshold=32'd912;
230: swap_threshold=32'd853;
231: swap_threshold=32'd798;
232: swap_threshold=32'd746;
233: swap_threshold=32'd698;
234: swap_threshold=32'd652;
235: swap_threshold=32'd610;
236: swap_threshold=32'd570;
237: swap_threshold=32'd533;
238: swap_threshold=32'd499;
239: swap_threshold=32'd466;
240: swap_threshold=32'd436;
241: swap_threshold=32'd408;
242: swap_threshold=32'd381;
243: swap_threshold=32'd356;
244: swap_threshold=32'd333;
245: swap_threshold=32'd312;
246: swap_threshold=32'd291;
247: swap_threshold=32'd272;
248: swap_threshold=32'd255;
249: swap_threshold=32'd238;
250: swap_threshold=32'd223;
251: swap_threshold=32'd208;
252: swap_threshold=32'd195;
253: swap_threshold=32'd182;
254: swap_threshold=32'd170;
255: swap_threshold=32'd159;
256: swap_threshold=32'd149;
257: swap_threshold=32'd139;
258: swap_threshold=32'd130;
259: swap_threshold=32'd121;
260: swap_threshold=32'd114;
261: swap_threshold=32'd106;
262: swap_threshold=32'd99;
263: swap_threshold=32'd93;
264: swap_threshold=32'd87;
265: swap_threshold=32'd81;
266: swap_threshold=32'd76;
267: swap_threshold=32'd71;
268: swap_threshold=32'd66;
269: swap_threshold=32'd62;
270: swap_threshold=32'd58;
271: swap_threshold=32'd54;
272: swap_threshold=32'd50;
273: swap_threshold=32'd47;
274: swap_threshold=32'd44;
275: swap_threshold=32'd41;
276: swap_threshold=32'd38;
277: swap_threshold=32'd36;
278: swap_threshold=32'd34;
279: swap_threshold=32'd31;
280: swap_threshold=32'd29;
281: swap_threshold=32'd27;
282: swap_threshold=32'd26;
283: swap_threshold=32'd24;
284: swap_threshold=32'd22;
285: swap_threshold=32'd21;
286: swap_threshold=32'd19;
287: swap_threshold=32'd18;
288: swap_threshold=32'd17;
289: swap_threshold=32'd16;
290: swap_threshold=32'd15;
291: swap_threshold=32'd14;
292: swap_threshold=32'd13;
293: swap_threshold=32'd12;
294: swap_threshold=32'd11;
295: swap_threshold=32'd10;
296: swap_threshold=32'd10;
297: swap_threshold=32'd9;
298: swap_threshold=32'd8;
299: swap_threshold=32'd8;
300: swap_threshold=32'd7;
301: swap_threshold=32'd7;
302: swap_threshold=32'd6;
303: swap_threshold=32'd6;
304: swap_threshold=32'd5;
305: swap_threshold=32'd5;
306: swap_threshold=32'd5;
307: swap_threshold=32'd4;
308: swap_threshold=32'd4;
309: swap_threshold=32'd4;
310: swap_threshold=32'd3;
311: swap_threshold=32'd3;
312: swap_threshold=32'd3;
313: swap_threshold=32'd3;
314: swap_threshold=32'd3;
315: swap_threshold=32'd2;
316: swap_threshold=32'd2;
317: swap_threshold=32'd2;
318: swap_threshold=32'd2;
319: swap_threshold=32'd2;
320: swap_threshold=32'd2;
321: swap_threshold=32'd1;
322: swap_threshold=32'd1;
323: swap_threshold=32'd1;
324: swap_threshold=32'd1;
325: swap_threshold=32'd1;
326: swap_threshold=32'd1;
327: swap_threshold=32'd1;
328: swap_threshold=32'd1;
329: swap_threshold=32'd1;
330: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
4: begin case(gap)
1: swap_threshold=32'd4016264695;
2: swap_threshold=32'd3755647247;
3: swap_threshold=32'd3511941396;
4: swap_threshold=32'd3284049742;
5: swap_threshold=32'd3070946093;
6: swap_threshold=32'd2871670847;
7: swap_threshold=32'd2685326673;
8: swap_threshold=32'd2511074467;
9: swap_threshold=32'd2348129574;
10: swap_threshold=32'd2195758258;
11: swap_threshold=32'd2053274393;
12: swap_threshold=32'd1920036379;
13: swap_threshold=32'd1795444247;
14: swap_threshold=32'd1678936961;
15: swap_threshold=32'd1569989892;
16: swap_threshold=32'd1468112454;
17: swap_threshold=32'd1372845894;
18: swap_threshold=32'd1283761229;
19: swap_threshold=32'd1200457314;
20: swap_threshold=32'd1122559031;
21: swap_threshold=32'd1049715608;
22: swap_threshold=32'd981599031;
23: swap_threshold=32'd917902573;
24: swap_threshold=32'd858339411;
25: swap_threshold=32'd802641332;
26: swap_threshold=32'd750557530;
27: swap_threshold=32'd701853472;
28: swap_threshold=32'd656309845;
29: swap_threshold=32'd613721567;
30: swap_threshold=32'd573896864;
31: swap_threshold=32'd536656406;
32: swap_threshold=32'd501832500;
33: swap_threshold=32'd469268335;
34: swap_threshold=32'd438817276;
35: swap_threshold=32'd410342201;
36: swap_threshold=32'd383714888;
37: swap_threshold=32'd358815434;
38: swap_threshold=32'd335531719;
39: swap_threshold=32'd313758896;
40: swap_threshold=32'd293398923;
41: swap_threshold=32'd274360118;
42: swap_threshold=32'd256556751;
43: swap_threshold=32'd239908654;
44: swap_threshold=32'd224340860;
45: swap_threshold=32'd209783268;
46: swap_threshold=32'd196170325;
47: swap_threshold=32'd183440734;
48: swap_threshold=32'd171537172;
49: swap_threshold=32'd160406038;
50: swap_threshold=32'd149997209;
51: swap_threshold=32'd140263814;
52: swap_threshold=32'd131162024;
53: swap_threshold=32'd122650854;
54: swap_threshold=32'd114691978;
55: swap_threshold=32'd107249557;
56: swap_threshold=32'd100290079;
57: swap_threshold=32'd93782205;
58: swap_threshold=32'd87696631;
59: swap_threshold=32'd82005952;
60: swap_threshold=32'd76684544;
61: swap_threshold=32'd71708445;
62: swap_threshold=32'd67055248;
63: swap_threshold=32'd62703999;
64: swap_threshold=32'd58635105;
65: swap_threshold=32'd54830243;
66: swap_threshold=32'd51272281;
67: swap_threshold=32'd47945196;
68: swap_threshold=32'd44834008;
69: swap_threshold=32'd41924707;
70: swap_threshold=32'd39204191;
71: swap_threshold=32'd36660212;
72: swap_threshold=32'd34281312;
73: swap_threshold=32'd32056780;
74: swap_threshold=32'd29976599;
75: swap_threshold=32'd28031403;
76: swap_threshold=32'd26212431;
77: swap_threshold=32'd24511493;
78: swap_threshold=32'd22920930;
79: swap_threshold=32'd21433579;
80: swap_threshold=32'd20042743;
81: swap_threshold=32'd18742159;
82: swap_threshold=32'd17525971;
83: swap_threshold=32'd16388702;
84: swap_threshold=32'd15325231;
85: swap_threshold=32'd14330769;
86: swap_threshold=32'd13400838;
87: swap_threshold=32'd12531251;
88: swap_threshold=32'd11718091;
89: swap_threshold=32'd10957699;
90: swap_threshold=32'd10246648;
91: swap_threshold=32'd9581738;
92: swap_threshold=32'd8959974;
93: swap_threshold=32'd8378557;
94: swap_threshold=32'd7834868;
95: swap_threshold=32'd7326459;
96: swap_threshold=32'd6851042;
97: swap_threshold=32'd6406474;
98: swap_threshold=32'd5990755;
99: swap_threshold=32'd5602011;
100: swap_threshold=32'd5238494;
101: swap_threshold=32'd4898565;
102: swap_threshold=32'd4580695;
103: swap_threshold=32'd4283451;
104: swap_threshold=32'd4005496;
105: swap_threshold=32'd3745577;
106: swap_threshold=32'd3502525;
107: swap_threshold=32'd3275244;
108: swap_threshold=32'd3062712;
109: swap_threshold=32'd2863971;
110: swap_threshold=32'd2678126;
111: swap_threshold=32'd2504341;
112: swap_threshold=32'd2341833;
113: swap_threshold=32'd2189871;
114: swap_threshold=32'd2047769;
115: swap_threshold=32'd1914888;
116: swap_threshold=32'd1790630;
117: swap_threshold=32'd1674435;
118: swap_threshold=32'd1565780;
119: swap_threshold=32'd1464176;
120: swap_threshold=32'd1369165;
121: swap_threshold=32'd1280319;
122: swap_threshold=32'd1197238;
123: swap_threshold=32'd1119549;
124: swap_threshold=32'd1046901;
125: swap_threshold=32'd978967;
126: swap_threshold=32'd915441;
127: swap_threshold=32'd856038;
128: swap_threshold=32'd800489;
129: swap_threshold=32'd748545;
130: swap_threshold=32'd699971;
131: swap_threshold=32'd654550;
132: swap_threshold=32'd612076;
133: swap_threshold=32'd572358;
134: swap_threshold=32'd535217;
135: swap_threshold=32'd500487;
136: swap_threshold=32'd468010;
137: swap_threshold=32'd437640;
138: swap_threshold=32'd409242;
139: swap_threshold=32'd382686;
140: swap_threshold=32'd357853;
141: swap_threshold=32'd334632;
142: swap_threshold=32'd312917;
143: swap_threshold=32'd292612;
144: swap_threshold=32'd273624;
145: swap_threshold=32'd255868;
146: swap_threshold=32'd239265;
147: swap_threshold=32'd223739;
148: swap_threshold=32'd209220;
149: swap_threshold=32'd195644;
150: swap_threshold=32'd182948;
151: swap_threshold=32'd171077;
152: swap_threshold=32'd159975;
153: swap_threshold=32'd149595;
154: swap_threshold=32'd139887;
155: swap_threshold=32'd130810;
156: swap_threshold=32'd122322;
157: swap_threshold=32'd114384;
158: swap_threshold=32'd106962;
159: swap_threshold=32'd100021;
160: swap_threshold=32'd93530;
161: swap_threshold=32'd87461;
162: swap_threshold=32'd81786;
163: swap_threshold=32'd76478;
164: swap_threshold=32'd71516;
165: swap_threshold=32'd66875;
166: swap_threshold=32'd62535;
167: swap_threshold=32'd58477;
168: swap_threshold=32'd54683;
169: swap_threshold=32'd51134;
170: swap_threshold=32'd47816;
171: swap_threshold=32'd44713;
172: swap_threshold=32'd41812;
173: swap_threshold=32'd39099;
174: swap_threshold=32'd36561;
175: swap_threshold=32'd34189;
176: swap_threshold=32'd31970;
177: swap_threshold=32'd29896;
178: swap_threshold=32'd27956;
179: swap_threshold=32'd26142;
180: swap_threshold=32'd24445;
181: swap_threshold=32'd22859;
182: swap_threshold=32'd21376;
183: swap_threshold=32'd19989;
184: swap_threshold=32'd18691;
185: swap_threshold=32'd17478;
186: swap_threshold=32'd16344;
187: swap_threshold=32'd15284;
188: swap_threshold=32'd14292;
189: swap_threshold=32'd13364;
190: swap_threshold=32'd12497;
191: swap_threshold=32'd11686;
192: swap_threshold=32'd10928;
193: swap_threshold=32'd10219;
194: swap_threshold=32'd9556;
195: swap_threshold=32'd8935;
196: swap_threshold=32'd8356;
197: swap_threshold=32'd7813;
198: swap_threshold=32'd7306;
199: swap_threshold=32'd6832;
200: swap_threshold=32'd6389;
201: swap_threshold=32'd5974;
202: swap_threshold=32'd5586;
203: swap_threshold=32'd5224;
204: swap_threshold=32'd4885;
205: swap_threshold=32'd4568;
206: swap_threshold=32'd4271;
207: swap_threshold=32'd3994;
208: swap_threshold=32'd3735;
209: swap_threshold=32'd3493;
210: swap_threshold=32'd3266;
211: swap_threshold=32'd3054;
212: swap_threshold=32'd2856;
213: swap_threshold=32'd2670;
214: swap_threshold=32'd2497;
215: swap_threshold=32'd2335;
216: swap_threshold=32'd2183;
217: swap_threshold=32'd2042;
218: swap_threshold=32'd1909;
219: swap_threshold=32'd1785;
220: swap_threshold=32'd1669;
221: swap_threshold=32'd1561;
222: swap_threshold=32'd1460;
223: swap_threshold=32'd1365;
224: swap_threshold=32'd1276;
225: swap_threshold=32'd1194;
226: swap_threshold=32'd1116;
227: swap_threshold=32'd1044;
228: swap_threshold=32'd976;
229: swap_threshold=32'd912;
230: swap_threshold=32'd853;
231: swap_threshold=32'd798;
232: swap_threshold=32'd746;
233: swap_threshold=32'd698;
234: swap_threshold=32'd652;
235: swap_threshold=32'd610;
236: swap_threshold=32'd570;
237: swap_threshold=32'd533;
238: swap_threshold=32'd499;
239: swap_threshold=32'd466;
240: swap_threshold=32'd436;
241: swap_threshold=32'd408;
242: swap_threshold=32'd381;
243: swap_threshold=32'd356;
244: swap_threshold=32'd333;
245: swap_threshold=32'd312;
246: swap_threshold=32'd291;
247: swap_threshold=32'd272;
248: swap_threshold=32'd255;
249: swap_threshold=32'd238;
250: swap_threshold=32'd223;
251: swap_threshold=32'd208;
252: swap_threshold=32'd195;
253: swap_threshold=32'd182;
254: swap_threshold=32'd170;
255: swap_threshold=32'd159;
256: swap_threshold=32'd149;
257: swap_threshold=32'd139;
258: swap_threshold=32'd130;
259: swap_threshold=32'd121;
260: swap_threshold=32'd114;
261: swap_threshold=32'd106;
262: swap_threshold=32'd99;
263: swap_threshold=32'd93;
264: swap_threshold=32'd87;
265: swap_threshold=32'd81;
266: swap_threshold=32'd76;
267: swap_threshold=32'd71;
268: swap_threshold=32'd66;
269: swap_threshold=32'd62;
270: swap_threshold=32'd58;
271: swap_threshold=32'd54;
272: swap_threshold=32'd50;
273: swap_threshold=32'd47;
274: swap_threshold=32'd44;
275: swap_threshold=32'd41;
276: swap_threshold=32'd38;
277: swap_threshold=32'd36;
278: swap_threshold=32'd34;
279: swap_threshold=32'd31;
280: swap_threshold=32'd29;
281: swap_threshold=32'd27;
282: swap_threshold=32'd26;
283: swap_threshold=32'd24;
284: swap_threshold=32'd22;
285: swap_threshold=32'd21;
286: swap_threshold=32'd19;
287: swap_threshold=32'd18;
288: swap_threshold=32'd17;
289: swap_threshold=32'd16;
290: swap_threshold=32'd15;
291: swap_threshold=32'd14;
292: swap_threshold=32'd13;
293: swap_threshold=32'd12;
294: swap_threshold=32'd11;
295: swap_threshold=32'd10;
296: swap_threshold=32'd10;
297: swap_threshold=32'd9;
298: swap_threshold=32'd8;
299: swap_threshold=32'd8;
300: swap_threshold=32'd7;
301: swap_threshold=32'd7;
302: swap_threshold=32'd6;
303: swap_threshold=32'd6;
304: swap_threshold=32'd5;
305: swap_threshold=32'd5;
306: swap_threshold=32'd5;
307: swap_threshold=32'd4;
308: swap_threshold=32'd4;
309: swap_threshold=32'd4;
310: swap_threshold=32'd3;
311: swap_threshold=32'd3;
312: swap_threshold=32'd3;
313: swap_threshold=32'd3;
314: swap_threshold=32'd3;
315: swap_threshold=32'd2;
316: swap_threshold=32'd2;
317: swap_threshold=32'd2;
318: swap_threshold=32'd2;
319: swap_threshold=32'd2;
320: swap_threshold=32'd2;
321: swap_threshold=32'd1;
322: swap_threshold=32'd1;
323: swap_threshold=32'd1;
324: swap_threshold=32'd1;
325: swap_threshold=32'd1;
326: swap_threshold=32'd1;
327: swap_threshold=32'd1;
328: swap_threshold=32'd1;
329: swap_threshold=32'd1;
330: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
5: begin case(gap)
1: swap_threshold=32'd3974238796;
2: swap_threshold=32'd3677460833;
3: swap_threshold=32'd3402844889;
4: swap_threshold=32'd3148736008;
5: swap_threshold=32'd2913602814;
6: swap_threshold=32'd2696028292;
7: swap_threshold=32'd2494701238;
8: swap_threshold=32'd2308408368;
9: swap_threshold=32'd2136026997;
10: swap_threshold=32'd1976518277;
11: swap_threshold=32'd1828920939;
12: swap_threshold=32'd1692345494;
13: swap_threshold=32'd1565968878;
14: swap_threshold=32'd1449029490;
15: swap_threshold=32'd1340822600;
16: swap_threshold=32'd1240696105;
17: swap_threshold=32'd1148046598;
18: swap_threshold=32'd1062315733;
19: swap_threshold=32'd982986856;
20: swap_threshold=32'd909581897;
21: swap_threshold=32'd841658484;
22: swap_threshold=32'd778807280;
23: swap_threshold=32'd720649517;
24: swap_threshold=32'd666834710;
25: swap_threshold=32'd617038546;
26: swap_threshold=32'd570960931;
27: swap_threshold=32'd528324182;
28: swap_threshold=32'd488871350;
29: swap_threshold=32'd452364675;
30: swap_threshold=32'd418584152;
31: swap_threshold=32'd387326203;
32: swap_threshold=32'd358402455;
33: swap_threshold=32'd331638600;
34: swap_threshold=32'd306873347;
35: swap_threshold=32'd283957450;
36: swap_threshold=32'd262752807;
37: swap_threshold=32'd243131630;
38: swap_threshold=32'd224975673;
39: swap_threshold=32'd208175519;
40: swap_threshold=32'd192629924;
41: swap_threshold=32'd178245203;
42: swap_threshold=32'd164934667;
43: swap_threshold=32'd152618101;
44: swap_threshold=32'd141221280;
45: swap_threshold=32'd130675521;
46: swap_threshold=32'd120917271;
47: swap_threshold=32'd111887723;
48: swap_threshold=32'd103532460;
49: swap_threshold=32'd95801129;
50: swap_threshold=32'd88647140;
51: swap_threshold=32'd82027377;
52: swap_threshold=32'd75901948;
53: swap_threshold=32'd70233938;
54: swap_threshold=32'd64989189;
55: swap_threshold=32'd60136093;
56: swap_threshold=32'd55645405;
57: swap_threshold=32'd51490061;
58: swap_threshold=32'd47645019;
59: swap_threshold=32'd44087107;
60: swap_threshold=32'd40794883;
61: swap_threshold=32'd37748508;
62: swap_threshold=32'd34929622;
63: swap_threshold=32'd32321238;
64: swap_threshold=32'd29907636;
65: swap_threshold=32'd27674270;
66: swap_threshold=32'd25607683;
67: swap_threshold=32'd23695418;
68: swap_threshold=32'd21925953;
69: swap_threshold=32'd20288623;
70: swap_threshold=32'd18773561;
71: swap_threshold=32'd17371638;
72: swap_threshold=32'd16074403;
73: swap_threshold=32'd14874040;
74: swap_threshold=32'd13763315;
75: swap_threshold=32'd12735534;
76: swap_threshold=32'd11784502;
77: swap_threshold=32'd10904489;
78: swap_threshold=32'd10090192;
79: swap_threshold=32'd9336703;
80: swap_threshold=32'd8639480;
81: swap_threshold=32'd7994324;
82: swap_threshold=32'd7397344;
83: swap_threshold=32'd6844944;
84: swap_threshold=32'd6333795;
85: swap_threshold=32'd5860816;
86: swap_threshold=32'd5423157;
87: swap_threshold=32'd5018181;
88: swap_threshold=32'd4643446;
89: swap_threshold=32'd4296694;
90: swap_threshold=32'd3975837;
91: swap_threshold=32'd3678940;
92: swap_threshold=32'd3404213;
93: swap_threshold=32'd3150002;
94: swap_threshold=32'd2914774;
95: swap_threshold=32'd2697112;
96: swap_threshold=32'd2495704;
97: swap_threshold=32'd2309336;
98: swap_threshold=32'd2136886;
99: swap_threshold=32'd1977313;
100: swap_threshold=32'd1829656;
101: swap_threshold=32'd1693026;
102: swap_threshold=32'd1566598;
103: swap_threshold=32'd1449612;
104: swap_threshold=32'd1341361;
105: swap_threshold=32'd1241195;
106: swap_threshold=32'd1148508;
107: swap_threshold=32'd1062743;
108: swap_threshold=32'd983382;
109: swap_threshold=32'd909947;
110: swap_threshold=32'd841997;
111: swap_threshold=32'd779120;
112: swap_threshold=32'd720939;
113: swap_threshold=32'd667102;
114: swap_threshold=32'd617286;
115: swap_threshold=32'd571190;
116: swap_threshold=32'd528536;
117: swap_threshold=32'd489068;
118: swap_threshold=32'd452546;
119: swap_threshold=32'd418752;
120: swap_threshold=32'd387482;
121: swap_threshold=32'd358546;
122: swap_threshold=32'd331772;
123: swap_threshold=32'd306996;
124: swap_threshold=32'd284071;
125: swap_threshold=32'd262858;
126: swap_threshold=32'd243229;
127: swap_threshold=32'd225066;
128: swap_threshold=32'd208259;
129: swap_threshold=32'd192707;
130: swap_threshold=32'd178316;
131: swap_threshold=32'd165001;
132: swap_threshold=32'd152679;
133: swap_threshold=32'd141278;
134: swap_threshold=32'd130728;
135: swap_threshold=32'd120965;
136: swap_threshold=32'd111932;
137: swap_threshold=32'd103574;
138: swap_threshold=32'd95839;
139: swap_threshold=32'd88682;
140: swap_threshold=32'd82060;
141: swap_threshold=32'd75932;
142: swap_threshold=32'd70262;
143: swap_threshold=32'd65015;
144: swap_threshold=32'd60160;
145: swap_threshold=32'd55667;
146: swap_threshold=32'd51510;
147: swap_threshold=32'd47664;
148: swap_threshold=32'd44104;
149: swap_threshold=32'd40811;
150: swap_threshold=32'd37763;
151: swap_threshold=32'd34943;
152: swap_threshold=32'd32334;
153: swap_threshold=32'd29919;
154: swap_threshold=32'd27685;
155: swap_threshold=32'd25617;
156: swap_threshold=32'd23704;
157: swap_threshold=32'd21934;
158: swap_threshold=32'd20296;
159: swap_threshold=32'd18781;
160: swap_threshold=32'd17378;
161: swap_threshold=32'd16080;
162: swap_threshold=32'd14880;
163: swap_threshold=32'd13768;
164: swap_threshold=32'd12740;
165: swap_threshold=32'd11789;
166: swap_threshold=32'd10908;
167: swap_threshold=32'd10094;
168: swap_threshold=32'd9340;
169: swap_threshold=32'd8642;
170: swap_threshold=32'd7997;
171: swap_threshold=32'd7400;
172: swap_threshold=32'd6847;
173: swap_threshold=32'd6336;
174: swap_threshold=32'd5863;
175: swap_threshold=32'd5425;
176: swap_threshold=32'd5020;
177: swap_threshold=32'd4645;
178: swap_threshold=32'd4298;
179: swap_threshold=32'd3977;
180: swap_threshold=32'd3680;
181: swap_threshold=32'd3405;
182: swap_threshold=32'd3151;
183: swap_threshold=32'd2915;
184: swap_threshold=32'd2698;
185: swap_threshold=32'd2496;
186: swap_threshold=32'd2310;
187: swap_threshold=32'd2137;
188: swap_threshold=32'd1978;
189: swap_threshold=32'd1830;
190: swap_threshold=32'd1693;
191: swap_threshold=32'd1567;
192: swap_threshold=32'd1450;
193: swap_threshold=32'd1341;
194: swap_threshold=32'd1241;
195: swap_threshold=32'd1148;
196: swap_threshold=32'd1063;
197: swap_threshold=32'd983;
198: swap_threshold=32'd910;
199: swap_threshold=32'd842;
200: swap_threshold=32'd779;
201: swap_threshold=32'd721;
202: swap_threshold=32'd667;
203: swap_threshold=32'd617;
204: swap_threshold=32'd571;
205: swap_threshold=32'd528;
206: swap_threshold=32'd489;
207: swap_threshold=32'd452;
208: swap_threshold=32'd418;
209: swap_threshold=32'd387;
210: swap_threshold=32'd358;
211: swap_threshold=32'd331;
212: swap_threshold=32'd307;
213: swap_threshold=32'd284;
214: swap_threshold=32'd262;
215: swap_threshold=32'd243;
216: swap_threshold=32'd225;
217: swap_threshold=32'd208;
218: swap_threshold=32'd192;
219: swap_threshold=32'd178;
220: swap_threshold=32'd165;
221: swap_threshold=32'd152;
222: swap_threshold=32'd141;
223: swap_threshold=32'd130;
224: swap_threshold=32'd121;
225: swap_threshold=32'd111;
226: swap_threshold=32'd103;
227: swap_threshold=32'd95;
228: swap_threshold=32'd88;
229: swap_threshold=32'd82;
230: swap_threshold=32'd75;
231: swap_threshold=32'd70;
232: swap_threshold=32'd65;
233: swap_threshold=32'd60;
234: swap_threshold=32'd55;
235: swap_threshold=32'd51;
236: swap_threshold=32'd47;
237: swap_threshold=32'd44;
238: swap_threshold=32'd40;
239: swap_threshold=32'd37;
240: swap_threshold=32'd34;
241: swap_threshold=32'd32;
242: swap_threshold=32'd29;
243: swap_threshold=32'd27;
244: swap_threshold=32'd25;
245: swap_threshold=32'd23;
246: swap_threshold=32'd21;
247: swap_threshold=32'd20;
248: swap_threshold=32'd18;
249: swap_threshold=32'd17;
250: swap_threshold=32'd16;
251: swap_threshold=32'd14;
252: swap_threshold=32'd13;
253: swap_threshold=32'd12;
254: swap_threshold=32'd11;
255: swap_threshold=32'd10;
256: swap_threshold=32'd10;
257: swap_threshold=32'd9;
258: swap_threshold=32'd8;
259: swap_threshold=32'd8;
260: swap_threshold=32'd7;
261: swap_threshold=32'd6;
262: swap_threshold=32'd6;
263: swap_threshold=32'd5;
264: swap_threshold=32'd5;
265: swap_threshold=32'd5;
266: swap_threshold=32'd4;
267: swap_threshold=32'd4;
268: swap_threshold=32'd3;
269: swap_threshold=32'd3;
270: swap_threshold=32'd3;
271: swap_threshold=32'd3;
272: swap_threshold=32'd2;
273: swap_threshold=32'd2;
274: swap_threshold=32'd2;
275: swap_threshold=32'd2;
276: swap_threshold=32'd2;
277: swap_threshold=32'd1;
278: swap_threshold=32'd1;
279: swap_threshold=32'd1;
280: swap_threshold=32'd1;
281: swap_threshold=32'd1;
282: swap_threshold=32'd1;
283: swap_threshold=32'd1;
284: swap_threshold=32'd1;
285: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
6: begin case(gap)
1: swap_threshold=32'd3955509719;
2: swap_threshold=32'd3642881554;
3: swap_threshold=32'd3354962309;
4: swap_threshold=32'd3089799085;
5: swap_threshold=32'd2845593335;
6: swap_threshold=32'd2620688662;
7: swap_threshold=32'd2413559582;
8: swap_threshold=32'd2222801183;
9: swap_threshold=32'd2047119589;
10: swap_threshold=32'd1885323187;
11: swap_threshold=32'd1736314546;
12: swap_threshold=32'd1599082971;
13: swap_threshold=32'd1472697647;
14: swap_threshold=32'd1356301331;
15: swap_threshold=32'd1249104528;
16: swap_threshold=32'd1150380145;
17: swap_threshold=32'd1059458555;
18: swap_threshold=32'd975723055;
19: swap_threshold=32'd898605684;
20: swap_threshold=32'd827583372;
21: swap_threshold=32'd762174389;
22: swap_threshold=32'd701935078;
23: swap_threshold=32'd646456848;
24: swap_threshold=32'd595363403;
25: swap_threshold=32'd548308186;
26: swap_threshold=32'd504972031;
27: swap_threshold=32'd465060998;
28: swap_threshold=32'd428304379;
29: swap_threshold=32'd394452860;
30: swap_threshold=32'd363276834;
31: swap_threshold=32'd334564840;
32: swap_threshold=32'd308122131;
33: swap_threshold=32'd283769352;
34: swap_threshold=32'd261341321;
35: swap_threshold=32'd240685916;
36: swap_threshold=32'd221663033;
37: swap_threshold=32'd204143646;
38: swap_threshold=32'd188008923;
39: swap_threshold=32'd173149426;
40: swap_threshold=32'd159464366;
41: swap_threshold=32'd146860920;
42: swap_threshold=32'd135253602;
43: swap_threshold=32'd124563681;
44: swap_threshold=32'd114718650;
45: swap_threshold=32'd105651733;
46: swap_threshold=32'd97301429;
47: swap_threshold=32'd89611101;
48: swap_threshold=32'd82528587;
49: swap_threshold=32'd76005847;
50: swap_threshold=32'd69998639;
51: swap_threshold=32'd64466218;
52: swap_threshold=32'd59371058;
53: swap_threshold=32'd54678599;
54: swap_threshold=32'd50357014;
55: swap_threshold=32'd46376991;
56: swap_threshold=32'd42711533;
57: swap_threshold=32'd39335779;
58: swap_threshold=32'd36226832;
59: swap_threshold=32'd33363603;
60: swap_threshold=32'd30726673;
61: swap_threshold=32'd28298156;
62: swap_threshold=32'd26061579;
63: swap_threshold=32'd24001773;
64: swap_threshold=32'd22104766;
65: swap_threshold=32'd20357691;
66: swap_threshold=32'd18748698;
67: swap_threshold=32'd17266873;
68: swap_threshold=32'd15902166;
69: swap_threshold=32'd14645321;
70: swap_threshold=32'd13487811;
71: swap_threshold=32'd12421787;
72: swap_threshold=32'd11440017;
73: swap_threshold=32'd10535842;
74: swap_threshold=32'd9703130;
75: swap_threshold=32'd8936232;
76: swap_threshold=32'd8229947;
77: swap_threshold=32'd7579484;
78: swap_threshold=32'd6980431;
79: swap_threshold=32'd6428724;
80: swap_threshold=32'd5920623;
81: swap_threshold=32'd5452680;
82: swap_threshold=32'd5021721;
83: swap_threshold=32'd4624824;
84: swap_threshold=32'd4259295;
85: swap_threshold=32'd3922657;
86: swap_threshold=32'd3612626;
87: swap_threshold=32'd3327098;
88: swap_threshold=32'd3064137;
89: swap_threshold=32'd2821959;
90: swap_threshold=32'd2598922;
91: swap_threshold=32'd2393514;
92: swap_threshold=32'd2204339;
93: swap_threshold=32'd2030117;
94: swap_threshold=32'd1869664;
95: swap_threshold=32'd1721893;
96: swap_threshold=32'd1585801;
97: swap_threshold=32'd1460466;
98: swap_threshold=32'd1345036;
99: swap_threshold=32'd1238730;
100: swap_threshold=32'd1140825;
101: swap_threshold=32'd1050659;
102: swap_threshold=32'd967619;
103: swap_threshold=32'd891142;
104: swap_threshold=32'd820709;
105: swap_threshold=32'd755844;
106: swap_threshold=32'd696105;
107: swap_threshold=32'd641087;
108: swap_threshold=32'd590418;
109: swap_threshold=32'd543754;
110: swap_threshold=32'd500778;
111: swap_threshold=32'd461198;
112: swap_threshold=32'd424747;
113: swap_threshold=32'd391176;
114: swap_threshold=32'd360259;
115: swap_threshold=32'd331786;
116: swap_threshold=32'd305563;
117: swap_threshold=32'd281412;
118: swap_threshold=32'd259170;
119: swap_threshold=32'd238686;
120: swap_threshold=32'd219822;
121: swap_threshold=32'd202448;
122: swap_threshold=32'd186447;
123: swap_threshold=32'd171711;
124: swap_threshold=32'd158139;
125: swap_threshold=32'd145641;
126: swap_threshold=32'd134130;
127: swap_threshold=32'd123529;
128: swap_threshold=32'd113765;
129: swap_threshold=32'd104774;
130: swap_threshold=32'd96493;
131: swap_threshold=32'd88866;
132: swap_threshold=32'd81843;
133: swap_threshold=32'd75374;
134: swap_threshold=32'd69417;
135: swap_threshold=32'd63930;
136: swap_threshold=32'd58877;
137: swap_threshold=32'd54224;
138: swap_threshold=32'd49938;
139: swap_threshold=32'd45991;
140: swap_threshold=32'd42356;
141: swap_threshold=32'd39009;
142: swap_threshold=32'd35925;
143: swap_threshold=32'd33086;
144: swap_threshold=32'd30471;
145: swap_threshold=32'd28063;
146: swap_threshold=32'd25845;
147: swap_threshold=32'd23802;
148: swap_threshold=32'd21921;
149: swap_threshold=32'd20188;
150: swap_threshold=32'd18592;
151: swap_threshold=32'd17123;
152: swap_threshold=32'd15770;
153: swap_threshold=32'd14523;
154: swap_threshold=32'd13375;
155: swap_threshold=32'd12318;
156: swap_threshold=32'd11345;
157: swap_threshold=32'd10448;
158: swap_threshold=32'd9622;
159: swap_threshold=32'd8862;
160: swap_threshold=32'd8161;
161: swap_threshold=32'd7516;
162: swap_threshold=32'd6922;
163: swap_threshold=32'd6375;
164: swap_threshold=32'd5871;
165: swap_threshold=32'd5407;
166: swap_threshold=32'd4980;
167: swap_threshold=32'd4586;
168: swap_threshold=32'd4223;
169: swap_threshold=32'd3890;
170: swap_threshold=32'd3582;
171: swap_threshold=32'd3299;
172: swap_threshold=32'd3038;
173: swap_threshold=32'd2798;
174: swap_threshold=32'd2577;
175: swap_threshold=32'd2373;
176: swap_threshold=32'd2186;
177: swap_threshold=32'd2013;
178: swap_threshold=32'd1854;
179: swap_threshold=32'd1707;
180: swap_threshold=32'd1572;
181: swap_threshold=32'd1448;
182: swap_threshold=32'd1333;
183: swap_threshold=32'd1228;
184: swap_threshold=32'd1131;
185: swap_threshold=32'd1041;
186: swap_threshold=32'd959;
187: swap_threshold=32'd883;
188: swap_threshold=32'd813;
189: swap_threshold=32'd749;
190: swap_threshold=32'd690;
191: swap_threshold=32'd635;
192: swap_threshold=32'd585;
193: swap_threshold=32'd539;
194: swap_threshold=32'd496;
195: swap_threshold=32'd457;
196: swap_threshold=32'd421;
197: swap_threshold=32'd387;
198: swap_threshold=32'd357;
199: swap_threshold=32'd329;
200: swap_threshold=32'd303;
201: swap_threshold=32'd279;
202: swap_threshold=32'd257;
203: swap_threshold=32'd236;
204: swap_threshold=32'd217;
205: swap_threshold=32'd200;
206: swap_threshold=32'd184;
207: swap_threshold=32'd170;
208: swap_threshold=32'd156;
209: swap_threshold=32'd144;
210: swap_threshold=32'd133;
211: swap_threshold=32'd122;
212: swap_threshold=32'd112;
213: swap_threshold=32'd103;
214: swap_threshold=32'd95;
215: swap_threshold=32'd88;
216: swap_threshold=32'd81;
217: swap_threshold=32'd74;
218: swap_threshold=32'd68;
219: swap_threshold=32'd63;
220: swap_threshold=32'd58;
221: swap_threshold=32'd53;
222: swap_threshold=32'd49;
223: swap_threshold=32'd45;
224: swap_threshold=32'd42;
225: swap_threshold=32'd38;
226: swap_threshold=32'd35;
227: swap_threshold=32'd32;
228: swap_threshold=32'd30;
229: swap_threshold=32'd27;
230: swap_threshold=32'd25;
231: swap_threshold=32'd23;
232: swap_threshold=32'd21;
233: swap_threshold=32'd20;
234: swap_threshold=32'd18;
235: swap_threshold=32'd16;
236: swap_threshold=32'd15;
237: swap_threshold=32'd14;
238: swap_threshold=32'd13;
239: swap_threshold=32'd12;
240: swap_threshold=32'd11;
241: swap_threshold=32'd10;
242: swap_threshold=32'd9;
243: swap_threshold=32'd8;
244: swap_threshold=32'd8;
245: swap_threshold=32'd7;
246: swap_threshold=32'd6;
247: swap_threshold=32'd6;
248: swap_threshold=32'd5;
249: swap_threshold=32'd5;
250: swap_threshold=32'd4;
251: swap_threshold=32'd4;
252: swap_threshold=32'd4;
253: swap_threshold=32'd3;
254: swap_threshold=32'd3;
255: swap_threshold=32'd3;
256: swap_threshold=32'd3;
257: swap_threshold=32'd2;
258: swap_threshold=32'd2;
259: swap_threshold=32'd2;
260: swap_threshold=32'd2;
261: swap_threshold=32'd1;
262: swap_threshold=32'd1;
263: swap_threshold=32'd1;
264: swap_threshold=32'd1;
265: swap_threshold=32'd1;
266: swap_threshold=32'd1;
267: swap_threshold=32'd1;
268: swap_threshold=32'd1;
269: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
7: begin case(gap)
1: swap_threshold=32'd3955509719;
2: swap_threshold=32'd3642881554;
3: swap_threshold=32'd3354962309;
4: swap_threshold=32'd3089799085;
5: swap_threshold=32'd2845593335;
6: swap_threshold=32'd2620688662;
7: swap_threshold=32'd2413559582;
8: swap_threshold=32'd2222801183;
9: swap_threshold=32'd2047119589;
10: swap_threshold=32'd1885323187;
11: swap_threshold=32'd1736314546;
12: swap_threshold=32'd1599082971;
13: swap_threshold=32'd1472697647;
14: swap_threshold=32'd1356301331;
15: swap_threshold=32'd1249104528;
16: swap_threshold=32'd1150380145;
17: swap_threshold=32'd1059458555;
18: swap_threshold=32'd975723055;
19: swap_threshold=32'd898605684;
20: swap_threshold=32'd827583372;
21: swap_threshold=32'd762174389;
22: swap_threshold=32'd701935078;
23: swap_threshold=32'd646456848;
24: swap_threshold=32'd595363403;
25: swap_threshold=32'd548308186;
26: swap_threshold=32'd504972031;
27: swap_threshold=32'd465060998;
28: swap_threshold=32'd428304379;
29: swap_threshold=32'd394452860;
30: swap_threshold=32'd363276834;
31: swap_threshold=32'd334564840;
32: swap_threshold=32'd308122131;
33: swap_threshold=32'd283769352;
34: swap_threshold=32'd261341321;
35: swap_threshold=32'd240685916;
36: swap_threshold=32'd221663033;
37: swap_threshold=32'd204143646;
38: swap_threshold=32'd188008923;
39: swap_threshold=32'd173149426;
40: swap_threshold=32'd159464366;
41: swap_threshold=32'd146860920;
42: swap_threshold=32'd135253602;
43: swap_threshold=32'd124563681;
44: swap_threshold=32'd114718650;
45: swap_threshold=32'd105651733;
46: swap_threshold=32'd97301429;
47: swap_threshold=32'd89611101;
48: swap_threshold=32'd82528587;
49: swap_threshold=32'd76005847;
50: swap_threshold=32'd69998639;
51: swap_threshold=32'd64466218;
52: swap_threshold=32'd59371058;
53: swap_threshold=32'd54678599;
54: swap_threshold=32'd50357014;
55: swap_threshold=32'd46376991;
56: swap_threshold=32'd42711533;
57: swap_threshold=32'd39335779;
58: swap_threshold=32'd36226832;
59: swap_threshold=32'd33363603;
60: swap_threshold=32'd30726673;
61: swap_threshold=32'd28298156;
62: swap_threshold=32'd26061579;
63: swap_threshold=32'd24001773;
64: swap_threshold=32'd22104766;
65: swap_threshold=32'd20357691;
66: swap_threshold=32'd18748698;
67: swap_threshold=32'd17266873;
68: swap_threshold=32'd15902166;
69: swap_threshold=32'd14645321;
70: swap_threshold=32'd13487811;
71: swap_threshold=32'd12421787;
72: swap_threshold=32'd11440017;
73: swap_threshold=32'd10535842;
74: swap_threshold=32'd9703130;
75: swap_threshold=32'd8936232;
76: swap_threshold=32'd8229947;
77: swap_threshold=32'd7579484;
78: swap_threshold=32'd6980431;
79: swap_threshold=32'd6428724;
80: swap_threshold=32'd5920623;
81: swap_threshold=32'd5452680;
82: swap_threshold=32'd5021721;
83: swap_threshold=32'd4624824;
84: swap_threshold=32'd4259295;
85: swap_threshold=32'd3922657;
86: swap_threshold=32'd3612626;
87: swap_threshold=32'd3327098;
88: swap_threshold=32'd3064137;
89: swap_threshold=32'd2821959;
90: swap_threshold=32'd2598922;
91: swap_threshold=32'd2393514;
92: swap_threshold=32'd2204339;
93: swap_threshold=32'd2030117;
94: swap_threshold=32'd1869664;
95: swap_threshold=32'd1721893;
96: swap_threshold=32'd1585801;
97: swap_threshold=32'd1460466;
98: swap_threshold=32'd1345036;
99: swap_threshold=32'd1238730;
100: swap_threshold=32'd1140825;
101: swap_threshold=32'd1050659;
102: swap_threshold=32'd967619;
103: swap_threshold=32'd891142;
104: swap_threshold=32'd820709;
105: swap_threshold=32'd755844;
106: swap_threshold=32'd696105;
107: swap_threshold=32'd641087;
108: swap_threshold=32'd590418;
109: swap_threshold=32'd543754;
110: swap_threshold=32'd500778;
111: swap_threshold=32'd461198;
112: swap_threshold=32'd424747;
113: swap_threshold=32'd391176;
114: swap_threshold=32'd360259;
115: swap_threshold=32'd331786;
116: swap_threshold=32'd305563;
117: swap_threshold=32'd281412;
118: swap_threshold=32'd259170;
119: swap_threshold=32'd238686;
120: swap_threshold=32'd219822;
121: swap_threshold=32'd202448;
122: swap_threshold=32'd186447;
123: swap_threshold=32'd171711;
124: swap_threshold=32'd158139;
125: swap_threshold=32'd145641;
126: swap_threshold=32'd134130;
127: swap_threshold=32'd123529;
128: swap_threshold=32'd113765;
129: swap_threshold=32'd104774;
130: swap_threshold=32'd96493;
131: swap_threshold=32'd88866;
132: swap_threshold=32'd81843;
133: swap_threshold=32'd75374;
134: swap_threshold=32'd69417;
135: swap_threshold=32'd63930;
136: swap_threshold=32'd58877;
137: swap_threshold=32'd54224;
138: swap_threshold=32'd49938;
139: swap_threshold=32'd45991;
140: swap_threshold=32'd42356;
141: swap_threshold=32'd39009;
142: swap_threshold=32'd35925;
143: swap_threshold=32'd33086;
144: swap_threshold=32'd30471;
145: swap_threshold=32'd28063;
146: swap_threshold=32'd25845;
147: swap_threshold=32'd23802;
148: swap_threshold=32'd21921;
149: swap_threshold=32'd20188;
150: swap_threshold=32'd18592;
151: swap_threshold=32'd17123;
152: swap_threshold=32'd15770;
153: swap_threshold=32'd14523;
154: swap_threshold=32'd13375;
155: swap_threshold=32'd12318;
156: swap_threshold=32'd11345;
157: swap_threshold=32'd10448;
158: swap_threshold=32'd9622;
159: swap_threshold=32'd8862;
160: swap_threshold=32'd8161;
161: swap_threshold=32'd7516;
162: swap_threshold=32'd6922;
163: swap_threshold=32'd6375;
164: swap_threshold=32'd5871;
165: swap_threshold=32'd5407;
166: swap_threshold=32'd4980;
167: swap_threshold=32'd4586;
168: swap_threshold=32'd4223;
169: swap_threshold=32'd3890;
170: swap_threshold=32'd3582;
171: swap_threshold=32'd3299;
172: swap_threshold=32'd3038;
173: swap_threshold=32'd2798;
174: swap_threshold=32'd2577;
175: swap_threshold=32'd2373;
176: swap_threshold=32'd2186;
177: swap_threshold=32'd2013;
178: swap_threshold=32'd1854;
179: swap_threshold=32'd1707;
180: swap_threshold=32'd1572;
181: swap_threshold=32'd1448;
182: swap_threshold=32'd1333;
183: swap_threshold=32'd1228;
184: swap_threshold=32'd1131;
185: swap_threshold=32'd1041;
186: swap_threshold=32'd959;
187: swap_threshold=32'd883;
188: swap_threshold=32'd813;
189: swap_threshold=32'd749;
190: swap_threshold=32'd690;
191: swap_threshold=32'd635;
192: swap_threshold=32'd585;
193: swap_threshold=32'd539;
194: swap_threshold=32'd496;
195: swap_threshold=32'd457;
196: swap_threshold=32'd421;
197: swap_threshold=32'd387;
198: swap_threshold=32'd357;
199: swap_threshold=32'd329;
200: swap_threshold=32'd303;
201: swap_threshold=32'd279;
202: swap_threshold=32'd257;
203: swap_threshold=32'd236;
204: swap_threshold=32'd217;
205: swap_threshold=32'd200;
206: swap_threshold=32'd184;
207: swap_threshold=32'd170;
208: swap_threshold=32'd156;
209: swap_threshold=32'd144;
210: swap_threshold=32'd133;
211: swap_threshold=32'd122;
212: swap_threshold=32'd112;
213: swap_threshold=32'd103;
214: swap_threshold=32'd95;
215: swap_threshold=32'd88;
216: swap_threshold=32'd81;
217: swap_threshold=32'd74;
218: swap_threshold=32'd68;
219: swap_threshold=32'd63;
220: swap_threshold=32'd58;
221: swap_threshold=32'd53;
222: swap_threshold=32'd49;
223: swap_threshold=32'd45;
224: swap_threshold=32'd42;
225: swap_threshold=32'd38;
226: swap_threshold=32'd35;
227: swap_threshold=32'd32;
228: swap_threshold=32'd30;
229: swap_threshold=32'd27;
230: swap_threshold=32'd25;
231: swap_threshold=32'd23;
232: swap_threshold=32'd21;
233: swap_threshold=32'd20;
234: swap_threshold=32'd18;
235: swap_threshold=32'd16;
236: swap_threshold=32'd15;
237: swap_threshold=32'd14;
238: swap_threshold=32'd13;
239: swap_threshold=32'd12;
240: swap_threshold=32'd11;
241: swap_threshold=32'd10;
242: swap_threshold=32'd9;
243: swap_threshold=32'd8;
244: swap_threshold=32'd8;
245: swap_threshold=32'd7;
246: swap_threshold=32'd6;
247: swap_threshold=32'd6;
248: swap_threshold=32'd5;
249: swap_threshold=32'd5;
250: swap_threshold=32'd4;
251: swap_threshold=32'd4;
252: swap_threshold=32'd4;
253: swap_threshold=32'd3;
254: swap_threshold=32'd3;
255: swap_threshold=32'd3;
256: swap_threshold=32'd3;
257: swap_threshold=32'd2;
258: swap_threshold=32'd2;
259: swap_threshold=32'd2;
260: swap_threshold=32'd2;
261: swap_threshold=32'd1;
262: swap_threshold=32'd1;
263: swap_threshold=32'd1;
264: swap_threshold=32'd1;
265: swap_threshold=32'd1;
266: swap_threshold=32'd1;
267: swap_threshold=32'd1;
268: swap_threshold=32'd1;
269: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
8: begin case(gap)
1: swap_threshold=32'd3955509719;
2: swap_threshold=32'd3642881554;
3: swap_threshold=32'd3354962309;
4: swap_threshold=32'd3089799085;
5: swap_threshold=32'd2845593335;
6: swap_threshold=32'd2620688662;
7: swap_threshold=32'd2413559582;
8: swap_threshold=32'd2222801183;
9: swap_threshold=32'd2047119589;
10: swap_threshold=32'd1885323187;
11: swap_threshold=32'd1736314546;
12: swap_threshold=32'd1599082971;
13: swap_threshold=32'd1472697647;
14: swap_threshold=32'd1356301331;
15: swap_threshold=32'd1249104528;
16: swap_threshold=32'd1150380145;
17: swap_threshold=32'd1059458555;
18: swap_threshold=32'd975723055;
19: swap_threshold=32'd898605684;
20: swap_threshold=32'd827583372;
21: swap_threshold=32'd762174389;
22: swap_threshold=32'd701935078;
23: swap_threshold=32'd646456848;
24: swap_threshold=32'd595363403;
25: swap_threshold=32'd548308186;
26: swap_threshold=32'd504972031;
27: swap_threshold=32'd465060998;
28: swap_threshold=32'd428304379;
29: swap_threshold=32'd394452860;
30: swap_threshold=32'd363276834;
31: swap_threshold=32'd334564840;
32: swap_threshold=32'd308122131;
33: swap_threshold=32'd283769352;
34: swap_threshold=32'd261341321;
35: swap_threshold=32'd240685916;
36: swap_threshold=32'd221663033;
37: swap_threshold=32'd204143646;
38: swap_threshold=32'd188008923;
39: swap_threshold=32'd173149426;
40: swap_threshold=32'd159464366;
41: swap_threshold=32'd146860920;
42: swap_threshold=32'd135253602;
43: swap_threshold=32'd124563681;
44: swap_threshold=32'd114718650;
45: swap_threshold=32'd105651733;
46: swap_threshold=32'd97301429;
47: swap_threshold=32'd89611101;
48: swap_threshold=32'd82528587;
49: swap_threshold=32'd76005847;
50: swap_threshold=32'd69998639;
51: swap_threshold=32'd64466218;
52: swap_threshold=32'd59371058;
53: swap_threshold=32'd54678599;
54: swap_threshold=32'd50357014;
55: swap_threshold=32'd46376991;
56: swap_threshold=32'd42711533;
57: swap_threshold=32'd39335779;
58: swap_threshold=32'd36226832;
59: swap_threshold=32'd33363603;
60: swap_threshold=32'd30726673;
61: swap_threshold=32'd28298156;
62: swap_threshold=32'd26061579;
63: swap_threshold=32'd24001773;
64: swap_threshold=32'd22104766;
65: swap_threshold=32'd20357691;
66: swap_threshold=32'd18748698;
67: swap_threshold=32'd17266873;
68: swap_threshold=32'd15902166;
69: swap_threshold=32'd14645321;
70: swap_threshold=32'd13487811;
71: swap_threshold=32'd12421787;
72: swap_threshold=32'd11440017;
73: swap_threshold=32'd10535842;
74: swap_threshold=32'd9703130;
75: swap_threshold=32'd8936232;
76: swap_threshold=32'd8229947;
77: swap_threshold=32'd7579484;
78: swap_threshold=32'd6980431;
79: swap_threshold=32'd6428724;
80: swap_threshold=32'd5920623;
81: swap_threshold=32'd5452680;
82: swap_threshold=32'd5021721;
83: swap_threshold=32'd4624824;
84: swap_threshold=32'd4259295;
85: swap_threshold=32'd3922657;
86: swap_threshold=32'd3612626;
87: swap_threshold=32'd3327098;
88: swap_threshold=32'd3064137;
89: swap_threshold=32'd2821959;
90: swap_threshold=32'd2598922;
91: swap_threshold=32'd2393514;
92: swap_threshold=32'd2204339;
93: swap_threshold=32'd2030117;
94: swap_threshold=32'd1869664;
95: swap_threshold=32'd1721893;
96: swap_threshold=32'd1585801;
97: swap_threshold=32'd1460466;
98: swap_threshold=32'd1345036;
99: swap_threshold=32'd1238730;
100: swap_threshold=32'd1140825;
101: swap_threshold=32'd1050659;
102: swap_threshold=32'd967619;
103: swap_threshold=32'd891142;
104: swap_threshold=32'd820709;
105: swap_threshold=32'd755844;
106: swap_threshold=32'd696105;
107: swap_threshold=32'd641087;
108: swap_threshold=32'd590418;
109: swap_threshold=32'd543754;
110: swap_threshold=32'd500778;
111: swap_threshold=32'd461198;
112: swap_threshold=32'd424747;
113: swap_threshold=32'd391176;
114: swap_threshold=32'd360259;
115: swap_threshold=32'd331786;
116: swap_threshold=32'd305563;
117: swap_threshold=32'd281412;
118: swap_threshold=32'd259170;
119: swap_threshold=32'd238686;
120: swap_threshold=32'd219822;
121: swap_threshold=32'd202448;
122: swap_threshold=32'd186447;
123: swap_threshold=32'd171711;
124: swap_threshold=32'd158139;
125: swap_threshold=32'd145641;
126: swap_threshold=32'd134130;
127: swap_threshold=32'd123529;
128: swap_threshold=32'd113765;
129: swap_threshold=32'd104774;
130: swap_threshold=32'd96493;
131: swap_threshold=32'd88866;
132: swap_threshold=32'd81843;
133: swap_threshold=32'd75374;
134: swap_threshold=32'd69417;
135: swap_threshold=32'd63930;
136: swap_threshold=32'd58877;
137: swap_threshold=32'd54224;
138: swap_threshold=32'd49938;
139: swap_threshold=32'd45991;
140: swap_threshold=32'd42356;
141: swap_threshold=32'd39009;
142: swap_threshold=32'd35925;
143: swap_threshold=32'd33086;
144: swap_threshold=32'd30471;
145: swap_threshold=32'd28063;
146: swap_threshold=32'd25845;
147: swap_threshold=32'd23802;
148: swap_threshold=32'd21921;
149: swap_threshold=32'd20188;
150: swap_threshold=32'd18592;
151: swap_threshold=32'd17123;
152: swap_threshold=32'd15770;
153: swap_threshold=32'd14523;
154: swap_threshold=32'd13375;
155: swap_threshold=32'd12318;
156: swap_threshold=32'd11345;
157: swap_threshold=32'd10448;
158: swap_threshold=32'd9622;
159: swap_threshold=32'd8862;
160: swap_threshold=32'd8161;
161: swap_threshold=32'd7516;
162: swap_threshold=32'd6922;
163: swap_threshold=32'd6375;
164: swap_threshold=32'd5871;
165: swap_threshold=32'd5407;
166: swap_threshold=32'd4980;
167: swap_threshold=32'd4586;
168: swap_threshold=32'd4223;
169: swap_threshold=32'd3890;
170: swap_threshold=32'd3582;
171: swap_threshold=32'd3299;
172: swap_threshold=32'd3038;
173: swap_threshold=32'd2798;
174: swap_threshold=32'd2577;
175: swap_threshold=32'd2373;
176: swap_threshold=32'd2186;
177: swap_threshold=32'd2013;
178: swap_threshold=32'd1854;
179: swap_threshold=32'd1707;
180: swap_threshold=32'd1572;
181: swap_threshold=32'd1448;
182: swap_threshold=32'd1333;
183: swap_threshold=32'd1228;
184: swap_threshold=32'd1131;
185: swap_threshold=32'd1041;
186: swap_threshold=32'd959;
187: swap_threshold=32'd883;
188: swap_threshold=32'd813;
189: swap_threshold=32'd749;
190: swap_threshold=32'd690;
191: swap_threshold=32'd635;
192: swap_threshold=32'd585;
193: swap_threshold=32'd539;
194: swap_threshold=32'd496;
195: swap_threshold=32'd457;
196: swap_threshold=32'd421;
197: swap_threshold=32'd387;
198: swap_threshold=32'd357;
199: swap_threshold=32'd329;
200: swap_threshold=32'd303;
201: swap_threshold=32'd279;
202: swap_threshold=32'd257;
203: swap_threshold=32'd236;
204: swap_threshold=32'd217;
205: swap_threshold=32'd200;
206: swap_threshold=32'd184;
207: swap_threshold=32'd170;
208: swap_threshold=32'd156;
209: swap_threshold=32'd144;
210: swap_threshold=32'd133;
211: swap_threshold=32'd122;
212: swap_threshold=32'd112;
213: swap_threshold=32'd103;
214: swap_threshold=32'd95;
215: swap_threshold=32'd88;
216: swap_threshold=32'd81;
217: swap_threshold=32'd74;
218: swap_threshold=32'd68;
219: swap_threshold=32'd63;
220: swap_threshold=32'd58;
221: swap_threshold=32'd53;
222: swap_threshold=32'd49;
223: swap_threshold=32'd45;
224: swap_threshold=32'd42;
225: swap_threshold=32'd38;
226: swap_threshold=32'd35;
227: swap_threshold=32'd32;
228: swap_threshold=32'd30;
229: swap_threshold=32'd27;
230: swap_threshold=32'd25;
231: swap_threshold=32'd23;
232: swap_threshold=32'd21;
233: swap_threshold=32'd20;
234: swap_threshold=32'd18;
235: swap_threshold=32'd16;
236: swap_threshold=32'd15;
237: swap_threshold=32'd14;
238: swap_threshold=32'd13;
239: swap_threshold=32'd12;
240: swap_threshold=32'd11;
241: swap_threshold=32'd10;
242: swap_threshold=32'd9;
243: swap_threshold=32'd8;
244: swap_threshold=32'd8;
245: swap_threshold=32'd7;
246: swap_threshold=32'd6;
247: swap_threshold=32'd6;
248: swap_threshold=32'd5;
249: swap_threshold=32'd5;
250: swap_threshold=32'd4;
251: swap_threshold=32'd4;
252: swap_threshold=32'd4;
253: swap_threshold=32'd3;
254: swap_threshold=32'd3;
255: swap_threshold=32'd3;
256: swap_threshold=32'd3;
257: swap_threshold=32'd2;
258: swap_threshold=32'd2;
259: swap_threshold=32'd2;
260: swap_threshold=32'd2;
261: swap_threshold=32'd1;
262: swap_threshold=32'd1;
263: swap_threshold=32'd1;
264: swap_threshold=32'd1;
265: swap_threshold=32'd1;
266: swap_threshold=32'd1;
267: swap_threshold=32'd1;
268: swap_threshold=32'd1;
269: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
9: begin case(gap)
1: swap_threshold=32'd3919042073;
2: swap_threshold=32'd3576020424;
3: swap_threshold=32'd3263022401;
4: swap_threshold=32'd2977420128;
5: swap_threshold=32'd2716815739;
6: swap_threshold=32'd2479021249;
7: swap_threshold=32'd2262040175;
8: swap_threshold=32'd2064050785;
9: swap_threshold=32'd1883390794;
10: swap_threshold=32'd1718543415;
11: swap_threshold=32'd1568124617;
12: swap_threshold=32'd1430871513;
13: swap_threshold=32'd1305631748;
14: swap_threshold=32'd1191353834;
15: swap_threshold=32'd1087078312;
16: swap_threshold=32'd991929705;
17: swap_threshold=32'd905109161;
18: swap_threshold=32'd825887752;
19: swap_threshold=32'd753600347;
20: swap_threshold=32'd687640036;
21: swap_threshold=32'd627453028;
22: swap_threshold=32'd572534002;
23: swap_threshold=32'd522421869;
24: swap_threshold=32'd476695896;
25: swap_threshold=32'd434972177;
26: swap_threshold=32'd396900405;
27: swap_threshold=32'd362160939;
28: swap_threshold=32'd330462110;
29: swap_threshold=32'd301537782;
30: swap_threshold=32'd275145111;
31: swap_threshold=32'd251062510;
32: swap_threshold=32'd229087783;
33: swap_threshold=32'd209036437;
34: swap_threshold=32'd190740123;
35: swap_threshold=32'd174045230;
36: swap_threshold=32'd158811588;
37: swap_threshold=32'd144911300;
38: swap_threshold=32'd132227662;
39: swap_threshold=32'd120654183;
40: swap_threshold=32'd110093695;
41: swap_threshold=32'd100457534;
42: swap_threshold=32'd91664796;
43: swap_threshold=32'd83641659;
44: swap_threshold=32'd76320763;
45: swap_threshold=32'd69640642;
46: swap_threshold=32'd63545212;
47: swap_threshold=32'd57983296;
48: swap_threshold=32'd52908197;
49: swap_threshold=32'd48277306;
50: swap_threshold=32'd44051742;
51: swap_threshold=32'd40196029;
52: swap_threshold=32'd36677795;
53: swap_threshold=32'd33467501;
54: swap_threshold=32'd30538194;
55: swap_threshold=32'd27865280;
56: swap_threshold=32'd25426318;
57: swap_threshold=32'd23200831;
58: swap_threshold=32'd21170134;
59: swap_threshold=32'd19317177;
60: swap_threshold=32'd17626404;
61: swap_threshold=32'd16083620;
62: swap_threshold=32'd14675870;
63: swap_threshold=32'd13391336;
64: swap_threshold=32'd12219234;
65: swap_threshold=32'd11149722;
66: swap_threshold=32'd10173821;
67: swap_threshold=32'd9283338;
68: swap_threshold=32'd8470796;
69: swap_threshold=32'd7729374;
70: swap_threshold=32'd7052845;
71: swap_threshold=32'd6435531;
72: swap_threshold=32'd5872249;
73: swap_threshold=32'd5358269;
74: swap_threshold=32'd4889277;
75: swap_threshold=32'd4461333;
76: swap_threshold=32'd4070846;
77: swap_threshold=32'd3714538;
78: swap_threshold=32'd3389416;
79: swap_threshold=32'd3092751;
80: swap_threshold=32'd2822052;
81: swap_threshold=32'd2575046;
82: swap_threshold=32'd2349660;
83: swap_threshold=32'd2144002;
84: swap_threshold=32'd1956344;
85: swap_threshold=32'd1785111;
86: swap_threshold=32'd1628866;
87: swap_threshold=32'd1486296;
88: swap_threshold=32'd1356205;
89: swap_threshold=32'd1237501;
90: swap_threshold=32'd1129186;
91: swap_threshold=32'd1030352;
92: swap_threshold=32'd940168;
93: swap_threshold=32'd857878;
94: swap_threshold=32'd782791;
95: swap_threshold=32'd714275;
96: swap_threshold=32'd651757;
97: swap_threshold=32'd594711;
98: swap_threshold=32'd542657;
99: swap_threshold=32'd495160;
100: swap_threshold=32'd451820;
101: swap_threshold=32'd412274;
102: swap_threshold=32'd376189;
103: swap_threshold=32'd343262;
104: swap_threshold=32'd313217;
105: swap_threshold=32'd285802;
106: swap_threshold=32'd260787;
107: swap_threshold=32'd237961;
108: swap_threshold=32'd217133;
109: swap_threshold=32'd198128;
110: swap_threshold=32'd180786;
111: swap_threshold=32'd164963;
112: swap_threshold=32'd150524;
113: swap_threshold=32'd137349;
114: swap_threshold=32'd125327;
115: swap_threshold=32'd114358;
116: swap_threshold=32'd104348;
117: swap_threshold=32'd95215;
118: swap_threshold=32'd86881;
119: swap_threshold=32'd79277;
120: swap_threshold=32'd72338;
121: swap_threshold=32'd66006;
122: swap_threshold=32'd60229;
123: swap_threshold=32'd54957;
124: swap_threshold=32'd50147;
125: swap_threshold=32'd45758;
126: swap_threshold=32'd41753;
127: swap_threshold=32'd38098;
128: swap_threshold=32'd34763;
129: swap_threshold=32'd31721;
130: swap_threshold=32'd28944;
131: swap_threshold=32'd26411;
132: swap_threshold=32'd24099;
133: swap_threshold=32'd21990;
134: swap_threshold=32'd20065;
135: swap_threshold=32'd18309;
136: swap_threshold=32'd16706;
137: swap_threshold=32'd15244;
138: swap_threshold=32'd13910;
139: swap_threshold=32'd12692;
140: swap_threshold=32'd11581;
141: swap_threshold=32'd10567;
142: swap_threshold=32'd9642;
143: swap_threshold=32'd8798;
144: swap_threshold=32'd8028;
145: swap_threshold=32'd7326;
146: swap_threshold=32'd6684;
147: swap_threshold=32'd6099;
148: swap_threshold=32'd5565;
149: swap_threshold=32'd5078;
150: swap_threshold=32'd4634;
151: swap_threshold=32'd4228;
152: swap_threshold=32'd3858;
153: swap_threshold=32'd3520;
154: swap_threshold=32'd3212;
155: swap_threshold=32'd2931;
156: swap_threshold=32'd2674;
157: swap_threshold=32'd2440;
158: swap_threshold=32'd2227;
159: swap_threshold=32'd2032;
160: swap_threshold=32'd1854;
161: swap_threshold=32'd1691;
162: swap_threshold=32'd1543;
163: swap_threshold=32'd1408;
164: swap_threshold=32'd1285;
165: swap_threshold=32'd1172;
166: swap_threshold=32'd1070;
167: swap_threshold=32'd976;
168: swap_threshold=32'd891;
169: swap_threshold=32'd813;
170: swap_threshold=32'd741;
171: swap_threshold=32'd677;
172: swap_threshold=32'd617;
173: swap_threshold=32'd563;
174: swap_threshold=32'd514;
175: swap_threshold=32'd469;
176: swap_threshold=32'd428;
177: swap_threshold=32'd390;
178: swap_threshold=32'd356;
179: swap_threshold=32'd325;
180: swap_threshold=32'd296;
181: swap_threshold=32'd270;
182: swap_threshold=32'd247;
183: swap_threshold=32'd225;
184: swap_threshold=32'd205;
185: swap_threshold=32'd187;
186: swap_threshold=32'd171;
187: swap_threshold=32'd156;
188: swap_threshold=32'd142;
189: swap_threshold=32'd130;
190: swap_threshold=32'd118;
191: swap_threshold=32'd108;
192: swap_threshold=32'd98;
193: swap_threshold=32'd90;
194: swap_threshold=32'd82;
195: swap_threshold=32'd75;
196: swap_threshold=32'd68;
197: swap_threshold=32'd62;
198: swap_threshold=32'd57;
199: swap_threshold=32'd52;
200: swap_threshold=32'd47;
201: swap_threshold=32'd43;
202: swap_threshold=32'd39;
203: swap_threshold=32'd36;
204: swap_threshold=32'd32;
205: swap_threshold=32'd30;
206: swap_threshold=32'd27;
207: swap_threshold=32'd25;
208: swap_threshold=32'd22;
209: swap_threshold=32'd20;
210: swap_threshold=32'd19;
211: swap_threshold=32'd17;
212: swap_threshold=32'd15;
213: swap_threshold=32'd14;
214: swap_threshold=32'd13;
215: swap_threshold=32'd12;
216: swap_threshold=32'd10;
217: swap_threshold=32'd10;
218: swap_threshold=32'd9;
219: swap_threshold=32'd8;
220: swap_threshold=32'd7;
221: swap_threshold=32'd6;
222: swap_threshold=32'd6;
223: swap_threshold=32'd5;
224: swap_threshold=32'd5;
225: swap_threshold=32'd4;
226: swap_threshold=32'd4;
227: swap_threshold=32'd4;
228: swap_threshold=32'd3;
229: swap_threshold=32'd3;
230: swap_threshold=32'd3;
231: swap_threshold=32'd2;
232: swap_threshold=32'd2;
233: swap_threshold=32'd2;
234: swap_threshold=32'd2;
235: swap_threshold=32'd1;
236: swap_threshold=32'd1;
237: swap_threshold=32'd1;
238: swap_threshold=32'd1;
239: swap_threshold=32'd1;
240: swap_threshold=32'd1;
241: swap_threshold=32'd1;
242: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
10: begin case(gap)
1: swap_threshold=32'd3855922555;
2: swap_threshold=32'd3461758316;
3: swap_threshold=32'd3107886756;
4: swap_threshold=32'd2790189032;
5: swap_threshold=32'd2504967345;
6: swap_threshold=32'd2248901894;
7: swap_threshold=32'd2019012239;
8: swap_threshold=32'd1812622611;
9: swap_threshold=32'd1627330764;
10: swap_threshold=32'd1460980018;
11: swap_threshold=32'd1311634156;
12: swap_threshold=32'd1177554887;
13: swap_threshold=32'd1057181612;
14: swap_threshold=32'd949113263;
15: swap_threshold=32'd852091992;
16: swap_threshold=32'd764988533;
17: swap_threshold=32'd686789057;
18: swap_threshold=32'd616583371;
19: swap_threshold=32'd553554326;
20: swap_threshold=32'd496968304;
21: swap_threshold=32'd446166679;
22: swap_threshold=32'd400558151;
23: swap_threshold=32'd359611867;
24: swap_threshold=32'd322851238;
25: swap_threshold=32'd289848394;
26: swap_threshold=32'd260219201;
27: swap_threshold=32'd233618796;
28: swap_threshold=32'd209737565;
29: swap_threshold=32'd188297548;
30: swap_threshold=32'd169049194;
31: swap_threshold=32'd151768467;
32: swap_threshold=32'd136254228;
33: swap_threshold=32'd122325903;
34: swap_threshold=32'd109821373;
35: swap_threshold=32'd98595095;
36: swap_threshold=32'd88516402;
37: swap_threshold=32'd79467984;
38: swap_threshold=32'd71344522;
39: swap_threshold=32'd64051466;
40: swap_threshold=32'd57503929;
41: swap_threshold=32'd51625701;
42: swap_threshold=32'd46348363;
43: swap_threshold=32'd41610491;
44: swap_threshold=32'd37356939;
45: swap_threshold=32'd33538198;
46: swap_threshold=32'd30109820;
47: swap_threshold=32'd27031902;
48: swap_threshold=32'd24268618;
49: swap_threshold=32'd21787805;
50: swap_threshold=32'd19560589;
51: swap_threshold=32'd17561045;
52: swap_threshold=32'd15765901;
53: swap_threshold=32'd14154263;
54: swap_threshold=32'd12707370;
55: swap_threshold=32'd11408384;
56: swap_threshold=32'd10242184;
57: swap_threshold=32'd9195196;
58: swap_threshold=32'd8255235;
59: swap_threshold=32'd7411360;
60: swap_threshold=32'd6653748;
61: swap_threshold=32'd5973581;
62: swap_threshold=32'd5362943;
63: swap_threshold=32'd4814727;
64: swap_threshold=32'd4322550;
65: swap_threshold=32'd3880686;
66: swap_threshold=32'd3483990;
67: swap_threshold=32'd3127846;
68: swap_threshold=32'd2808108;
69: swap_threshold=32'd2521055;
70: swap_threshold=32'd2263345;
71: swap_threshold=32'd2031978;
72: swap_threshold=32'd1824263;
73: swap_threshold=32'd1637781;
74: swap_threshold=32'd1470362;
75: swap_threshold=32'd1320057;
76: swap_threshold=32'd1185117;
77: swap_threshold=32'd1063971;
78: swap_threshold=32'd955208;
79: swap_threshold=32'd857564;
80: swap_threshold=32'd769901;
81: swap_threshold=32'd691199;
82: swap_threshold=32'd620543;
83: swap_threshold=32'd557109;
84: swap_threshold=32'd500159;
85: swap_threshold=32'd449032;
86: swap_threshold=32'd403130;
87: swap_threshold=32'd361921;
88: swap_threshold=32'd324924;
89: swap_threshold=32'd291709;
90: swap_threshold=32'd261890;
91: swap_threshold=32'd235119;
92: swap_threshold=32'd211084;
93: swap_threshold=32'd189506;
94: swap_threshold=32'd170134;
95: swap_threshold=32'd152743;
96: swap_threshold=32'd137129;
97: swap_threshold=32'd123111;
98: swap_threshold=32'd110526;
99: swap_threshold=32'd99228;
100: swap_threshold=32'd89084;
101: swap_threshold=32'd79978;
102: swap_threshold=32'd71802;
103: swap_threshold=32'd64462;
104: swap_threshold=32'd57873;
105: swap_threshold=32'd51957;
106: swap_threshold=32'd46646;
107: swap_threshold=32'd41877;
108: swap_threshold=32'd37596;
109: swap_threshold=32'd33753;
110: swap_threshold=32'd30303;
111: swap_threshold=32'd27205;
112: swap_threshold=32'd24424;
113: swap_threshold=32'd21927;
114: swap_threshold=32'd19686;
115: swap_threshold=32'd17673;
116: swap_threshold=32'd15867;
117: swap_threshold=32'd14245;
118: swap_threshold=32'd12788;
119: swap_threshold=32'd11481;
120: swap_threshold=32'd10307;
121: swap_threshold=32'd9254;
122: swap_threshold=32'd8308;
123: swap_threshold=32'd7458;
124: swap_threshold=32'd6696;
125: swap_threshold=32'd6011;
126: swap_threshold=32'd5397;
127: swap_threshold=32'd4845;
128: swap_threshold=32'd4350;
129: swap_threshold=32'd3905;
130: swap_threshold=32'd3506;
131: swap_threshold=32'd3147;
132: swap_threshold=32'd2826;
133: swap_threshold=32'd2537;
134: swap_threshold=32'd2277;
135: swap_threshold=32'd2045;
136: swap_threshold=32'd1835;
137: swap_threshold=32'd1648;
138: swap_threshold=32'd1479;
139: swap_threshold=32'd1328;
140: swap_threshold=32'd1192;
141: swap_threshold=32'd1070;
142: swap_threshold=32'd961;
143: swap_threshold=32'd863;
144: swap_threshold=32'd774;
145: swap_threshold=32'd695;
146: swap_threshold=32'd624;
147: swap_threshold=32'd560;
148: swap_threshold=32'd503;
149: swap_threshold=32'd451;
150: swap_threshold=32'd405;
151: swap_threshold=32'd364;
152: swap_threshold=32'd327;
153: swap_threshold=32'd293;
154: swap_threshold=32'd263;
155: swap_threshold=32'd236;
156: swap_threshold=32'd212;
157: swap_threshold=32'd190;
158: swap_threshold=32'd171;
159: swap_threshold=32'd153;
160: swap_threshold=32'd138;
161: swap_threshold=32'd123;
162: swap_threshold=32'd111;
163: swap_threshold=32'd99;
164: swap_threshold=32'd89;
165: swap_threshold=32'd80;
166: swap_threshold=32'd72;
167: swap_threshold=32'd64;
168: swap_threshold=32'd58;
169: swap_threshold=32'd52;
170: swap_threshold=32'd46;
171: swap_threshold=32'd42;
172: swap_threshold=32'd37;
173: swap_threshold=32'd33;
174: swap_threshold=32'd30;
175: swap_threshold=32'd27;
176: swap_threshold=32'd24;
177: swap_threshold=32'd22;
178: swap_threshold=32'd19;
179: swap_threshold=32'd17;
180: swap_threshold=32'd15;
181: swap_threshold=32'd14;
182: swap_threshold=32'd12;
183: swap_threshold=32'd11;
184: swap_threshold=32'd10;
185: swap_threshold=32'd9;
186: swap_threshold=32'd8;
187: swap_threshold=32'd7;
188: swap_threshold=32'd6;
189: swap_threshold=32'd6;
190: swap_threshold=32'd5;
191: swap_threshold=32'd4;
192: swap_threshold=32'd4;
193: swap_threshold=32'd3;
194: swap_threshold=32'd3;
195: swap_threshold=32'd3;
196: swap_threshold=32'd2;
197: swap_threshold=32'd2;
198: swap_threshold=32'd2;
199: swap_threshold=32'd2;
200: swap_threshold=32'd1;
201: swap_threshold=32'd1;
202: swap_threshold=32'd1;
203: swap_threshold=32'd1;
204: swap_threshold=32'd1;
205: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
11: begin case(gap)
1: swap_threshold=32'd3855922555;
2: swap_threshold=32'd3461758316;
3: swap_threshold=32'd3107886756;
4: swap_threshold=32'd2790189032;
5: swap_threshold=32'd2504967345;
6: swap_threshold=32'd2248901894;
7: swap_threshold=32'd2019012239;
8: swap_threshold=32'd1812622611;
9: swap_threshold=32'd1627330764;
10: swap_threshold=32'd1460980018;
11: swap_threshold=32'd1311634156;
12: swap_threshold=32'd1177554887;
13: swap_threshold=32'd1057181612;
14: swap_threshold=32'd949113263;
15: swap_threshold=32'd852091992;
16: swap_threshold=32'd764988533;
17: swap_threshold=32'd686789057;
18: swap_threshold=32'd616583371;
19: swap_threshold=32'd553554326;
20: swap_threshold=32'd496968304;
21: swap_threshold=32'd446166679;
22: swap_threshold=32'd400558151;
23: swap_threshold=32'd359611867;
24: swap_threshold=32'd322851238;
25: swap_threshold=32'd289848394;
26: swap_threshold=32'd260219201;
27: swap_threshold=32'd233618796;
28: swap_threshold=32'd209737565;
29: swap_threshold=32'd188297548;
30: swap_threshold=32'd169049194;
31: swap_threshold=32'd151768467;
32: swap_threshold=32'd136254228;
33: swap_threshold=32'd122325903;
34: swap_threshold=32'd109821373;
35: swap_threshold=32'd98595095;
36: swap_threshold=32'd88516402;
37: swap_threshold=32'd79467984;
38: swap_threshold=32'd71344522;
39: swap_threshold=32'd64051466;
40: swap_threshold=32'd57503929;
41: swap_threshold=32'd51625701;
42: swap_threshold=32'd46348363;
43: swap_threshold=32'd41610491;
44: swap_threshold=32'd37356939;
45: swap_threshold=32'd33538198;
46: swap_threshold=32'd30109820;
47: swap_threshold=32'd27031902;
48: swap_threshold=32'd24268618;
49: swap_threshold=32'd21787805;
50: swap_threshold=32'd19560589;
51: swap_threshold=32'd17561045;
52: swap_threshold=32'd15765901;
53: swap_threshold=32'd14154263;
54: swap_threshold=32'd12707370;
55: swap_threshold=32'd11408384;
56: swap_threshold=32'd10242184;
57: swap_threshold=32'd9195196;
58: swap_threshold=32'd8255235;
59: swap_threshold=32'd7411360;
60: swap_threshold=32'd6653748;
61: swap_threshold=32'd5973581;
62: swap_threshold=32'd5362943;
63: swap_threshold=32'd4814727;
64: swap_threshold=32'd4322550;
65: swap_threshold=32'd3880686;
66: swap_threshold=32'd3483990;
67: swap_threshold=32'd3127846;
68: swap_threshold=32'd2808108;
69: swap_threshold=32'd2521055;
70: swap_threshold=32'd2263345;
71: swap_threshold=32'd2031978;
72: swap_threshold=32'd1824263;
73: swap_threshold=32'd1637781;
74: swap_threshold=32'd1470362;
75: swap_threshold=32'd1320057;
76: swap_threshold=32'd1185117;
77: swap_threshold=32'd1063971;
78: swap_threshold=32'd955208;
79: swap_threshold=32'd857564;
80: swap_threshold=32'd769901;
81: swap_threshold=32'd691199;
82: swap_threshold=32'd620543;
83: swap_threshold=32'd557109;
84: swap_threshold=32'd500159;
85: swap_threshold=32'd449032;
86: swap_threshold=32'd403130;
87: swap_threshold=32'd361921;
88: swap_threshold=32'd324924;
89: swap_threshold=32'd291709;
90: swap_threshold=32'd261890;
91: swap_threshold=32'd235119;
92: swap_threshold=32'd211084;
93: swap_threshold=32'd189506;
94: swap_threshold=32'd170134;
95: swap_threshold=32'd152743;
96: swap_threshold=32'd137129;
97: swap_threshold=32'd123111;
98: swap_threshold=32'd110526;
99: swap_threshold=32'd99228;
100: swap_threshold=32'd89084;
101: swap_threshold=32'd79978;
102: swap_threshold=32'd71802;
103: swap_threshold=32'd64462;
104: swap_threshold=32'd57873;
105: swap_threshold=32'd51957;
106: swap_threshold=32'd46646;
107: swap_threshold=32'd41877;
108: swap_threshold=32'd37596;
109: swap_threshold=32'd33753;
110: swap_threshold=32'd30303;
111: swap_threshold=32'd27205;
112: swap_threshold=32'd24424;
113: swap_threshold=32'd21927;
114: swap_threshold=32'd19686;
115: swap_threshold=32'd17673;
116: swap_threshold=32'd15867;
117: swap_threshold=32'd14245;
118: swap_threshold=32'd12788;
119: swap_threshold=32'd11481;
120: swap_threshold=32'd10307;
121: swap_threshold=32'd9254;
122: swap_threshold=32'd8308;
123: swap_threshold=32'd7458;
124: swap_threshold=32'd6696;
125: swap_threshold=32'd6011;
126: swap_threshold=32'd5397;
127: swap_threshold=32'd4845;
128: swap_threshold=32'd4350;
129: swap_threshold=32'd3905;
130: swap_threshold=32'd3506;
131: swap_threshold=32'd3147;
132: swap_threshold=32'd2826;
133: swap_threshold=32'd2537;
134: swap_threshold=32'd2277;
135: swap_threshold=32'd2045;
136: swap_threshold=32'd1835;
137: swap_threshold=32'd1648;
138: swap_threshold=32'd1479;
139: swap_threshold=32'd1328;
140: swap_threshold=32'd1192;
141: swap_threshold=32'd1070;
142: swap_threshold=32'd961;
143: swap_threshold=32'd863;
144: swap_threshold=32'd774;
145: swap_threshold=32'd695;
146: swap_threshold=32'd624;
147: swap_threshold=32'd560;
148: swap_threshold=32'd503;
149: swap_threshold=32'd451;
150: swap_threshold=32'd405;
151: swap_threshold=32'd364;
152: swap_threshold=32'd327;
153: swap_threshold=32'd293;
154: swap_threshold=32'd263;
155: swap_threshold=32'd236;
156: swap_threshold=32'd212;
157: swap_threshold=32'd190;
158: swap_threshold=32'd171;
159: swap_threshold=32'd153;
160: swap_threshold=32'd138;
161: swap_threshold=32'd123;
162: swap_threshold=32'd111;
163: swap_threshold=32'd99;
164: swap_threshold=32'd89;
165: swap_threshold=32'd80;
166: swap_threshold=32'd72;
167: swap_threshold=32'd64;
168: swap_threshold=32'd58;
169: swap_threshold=32'd52;
170: swap_threshold=32'd46;
171: swap_threshold=32'd42;
172: swap_threshold=32'd37;
173: swap_threshold=32'd33;
174: swap_threshold=32'd30;
175: swap_threshold=32'd27;
176: swap_threshold=32'd24;
177: swap_threshold=32'd22;
178: swap_threshold=32'd19;
179: swap_threshold=32'd17;
180: swap_threshold=32'd15;
181: swap_threshold=32'd14;
182: swap_threshold=32'd12;
183: swap_threshold=32'd11;
184: swap_threshold=32'd10;
185: swap_threshold=32'd9;
186: swap_threshold=32'd8;
187: swap_threshold=32'd7;
188: swap_threshold=32'd6;
189: swap_threshold=32'd6;
190: swap_threshold=32'd5;
191: swap_threshold=32'd4;
192: swap_threshold=32'd4;
193: swap_threshold=32'd3;
194: swap_threshold=32'd3;
195: swap_threshold=32'd3;
196: swap_threshold=32'd2;
197: swap_threshold=32'd2;
198: swap_threshold=32'd2;
199: swap_threshold=32'd2;
200: swap_threshold=32'd1;
201: swap_threshold=32'd1;
202: swap_threshold=32'd1;
203: swap_threshold=32'd1;
204: swap_threshold=32'd1;
205: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
12: begin case(gap)
1: swap_threshold=32'd3845014992;
2: swap_threshold=32'd3442200900;
3: swap_threshold=32'd3081586693;
4: swap_threshold=32'd2758751399;
5: swap_threshold=32'd2469737197;
6: swap_threshold=32'd2211000898;
7: swap_threshold=32'd1979370509;
8: swap_threshold=32'd1772006341;
9: swap_threshold=32'd1586366200;
10: swap_threshold=32'd1420174218;
11: swap_threshold=32'd1271392955;
12: swap_threshold=32'd1138198416;
13: swap_threshold=32'd1018957694;
14: swap_threshold=32'd912208951;
15: swap_threshold=32'd816643492;
16: swap_threshold=32'd731089728;
17: swap_threshold=32'd654498805;
18: swap_threshold=32'd585931754;
19: swap_threshold=32'd524547970;
20: swap_threshold=32'd469594917;
21: swap_threshold=32'd420398892;
22: swap_threshold=32'd376356776;
23: swap_threshold=32'd336928630;
24: swap_threshold=32'd301631082;
25: swap_threshold=32'd270031400;
26: swap_threshold=32'd241742186;
27: swap_threshold=32'd216416625;
28: swap_threshold=32'd193744239;
29: swap_threshold=32'd173447072;
30: swap_threshold=32'd155276291;
31: swap_threshold=32'd139009130;
32: swap_threshold=32'd124446160;
33: swap_threshold=32'd111408846;
34: swap_threshold=32'd99737357;
35: swap_threshold=32'd89288603;
36: swap_threshold=32'd79934490;
37: swap_threshold=32'd71560338;
38: swap_threshold=32'd64063485;
39: swap_threshold=32'd57352022;
40: swap_threshold=32'd51343670;
41: swap_threshold=32'd45964769;
42: swap_threshold=32'd41149377;
43: swap_threshold=32'd36838457;
44: swap_threshold=32'd32979162;
45: swap_threshold=32'd29524176;
46: swap_threshold=32'd26431144;
47: swap_threshold=32'd23662146;
48: swap_threshold=32'd21183236;
49: swap_threshold=32'd18964024;
50: swap_threshold=32'd16977302;
51: swap_threshold=32'd15198714;
52: swap_threshold=32'd13606456;
53: swap_threshold=32'd12181007;
54: swap_threshold=32'd10904892;
55: swap_threshold=32'd9762466;
56: swap_threshold=32'd8739724;
57: swap_threshold=32'd7824127;
58: swap_threshold=32'd7004450;
59: swap_threshold=32'd6270645;
60: swap_threshold=32'd5613716;
61: swap_threshold=32'd5025608;
62: swap_threshold=32'd4499111;
63: swap_threshold=32'd4027772;
64: swap_threshold=32'd3605812;
65: swap_threshold=32'd3228057;
66: swap_threshold=32'd2889877;
67: swap_threshold=32'd2587126;
68: swap_threshold=32'd2316092;
69: swap_threshold=32'd2073452;
70: swap_threshold=32'd1856231;
71: swap_threshold=32'd1661767;
72: swap_threshold=32'd1487676;
73: swap_threshold=32'd1331823;
74: swap_threshold=32'd1192298;
75: swap_threshold=32'd1067389;
76: swap_threshold=32'd955567;
77: swap_threshold=32'd855459;
78: swap_threshold=32'd765839;
79: swap_threshold=32'd685607;
80: swap_threshold=32'd613781;
81: swap_threshold=32'd549480;
82: swap_threshold=32'd491915;
83: swap_threshold=32'd440380;
84: swap_threshold=32'd394245;
85: swap_threshold=32'd352943;
86: swap_threshold=32'd315967;
87: swap_threshold=32'd282866;
88: swap_threshold=32'd253232;
89: swap_threshold=32'd226703;
90: swap_threshold=32'd202953;
91: swap_threshold=32'd181691;
92: swap_threshold=32'd162656;
93: swap_threshold=32'd145616;
94: swap_threshold=32'd130361;
95: swap_threshold=32'd116704;
96: swap_threshold=32'd104477;
97: swap_threshold=32'd93532;
98: swap_threshold=32'd83733;
99: swap_threshold=32'd74961;
100: swap_threshold=32'd67108;
101: swap_threshold=32'd60078;
102: swap_threshold=32'd53784;
103: swap_threshold=32'd48149;
104: swap_threshold=32'd43105;
105: swap_threshold=32'd38589;
106: swap_threshold=32'd34546;
107: swap_threshold=32'd30927;
108: swap_threshold=32'd27687;
109: swap_threshold=32'd24786;
110: swap_threshold=32'd22190;
111: swap_threshold=32'd19865;
112: swap_threshold=32'd17784;
113: swap_threshold=32'd15921;
114: swap_threshold=32'd14253;
115: swap_threshold=32'd12759;
116: swap_threshold=32'd11423;
117: swap_threshold=32'd10226;
118: swap_threshold=32'd9155;
119: swap_threshold=32'd8196;
120: swap_threshold=32'd7337;
121: swap_threshold=32'd6568;
122: swap_threshold=32'd5880;
123: swap_threshold=32'd5264;
124: swap_threshold=32'd4712;
125: swap_threshold=32'd4219;
126: swap_threshold=32'd3777;
127: swap_threshold=32'd3381;
128: swap_threshold=32'd3027;
129: swap_threshold=32'd2710;
130: swap_threshold=32'd2426;
131: swap_threshold=32'd2172;
132: swap_threshold=32'd1944;
133: swap_threshold=32'd1740;
134: swap_threshold=32'd1558;
135: swap_threshold=32'd1395;
136: swap_threshold=32'd1248;
137: swap_threshold=32'd1118;
138: swap_threshold=32'd1000;
139: swap_threshold=32'd896;
140: swap_threshold=32'd802;
141: swap_threshold=32'd718;
142: swap_threshold=32'd642;
143: swap_threshold=32'd575;
144: swap_threshold=32'd515;
145: swap_threshold=32'd461;
146: swap_threshold=32'd412;
147: swap_threshold=32'd369;
148: swap_threshold=32'd330;
149: swap_threshold=32'd296;
150: swap_threshold=32'd265;
151: swap_threshold=32'd237;
152: swap_threshold=32'd212;
153: swap_threshold=32'd190;
154: swap_threshold=32'd170;
155: swap_threshold=32'd152;
156: swap_threshold=32'd136;
157: swap_threshold=32'd122;
158: swap_threshold=32'd109;
159: swap_threshold=32'd97;
160: swap_threshold=32'd87;
161: swap_threshold=32'd78;
162: swap_threshold=32'd70;
163: swap_threshold=32'd62;
164: swap_threshold=32'd56;
165: swap_threshold=32'd50;
166: swap_threshold=32'd45;
167: swap_threshold=32'd40;
168: swap_threshold=32'd36;
169: swap_threshold=32'd32;
170: swap_threshold=32'd29;
171: swap_threshold=32'd25;
172: swap_threshold=32'd23;
173: swap_threshold=32'd20;
174: swap_threshold=32'd18;
175: swap_threshold=32'd16;
176: swap_threshold=32'd14;
177: swap_threshold=32'd13;
178: swap_threshold=32'd11;
179: swap_threshold=32'd10;
180: swap_threshold=32'd9;
181: swap_threshold=32'd8;
182: swap_threshold=32'd7;
183: swap_threshold=32'd6;
184: swap_threshold=32'd6;
185: swap_threshold=32'd5;
186: swap_threshold=32'd4;
187: swap_threshold=32'd4;
188: swap_threshold=32'd3;
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
13: begin case(gap)
1: swap_threshold=32'd3676750204;
2: swap_threshold=32'd3147519208;
3: swap_threshold=32'd2694465660;
4: swap_threshold=32'd2306624587;
5: swap_threshold=32'd1974609313;
6: swap_threshold=32'd1690384279;
7: swap_threshold=32'd1447070563;
8: swap_threshold=32'd1238779395;
9: swap_threshold=32'd1060469633;
10: swap_threshold=32'd907825758;
11: swap_threshold=32'd777153424;
12: swap_threshold=32'd665290051;
13: swap_threshold=32'd569528278;
14: swap_threshold=32'd487550444;
15: swap_threshold=32'd417372490;
16: swap_threshold=32'd357295942;
17: swap_threshold=32'd305866806;
18: swap_threshold=32'd261840374;
19: swap_threshold=32'd224151101;
20: swap_threshold=32'd191886817;
21: swap_threshold=32'd164266651;
22: swap_threshold=32'd140622128;
23: swap_threshold=32'd120380996;
24: swap_threshold=32'd103053369;
25: swap_threshold=32'd88219879;
26: swap_threshold=32'd75521520;
27: swap_threshold=32'd64650961;
28: swap_threshold=32'd55345109;
29: swap_threshold=32'd47378741;
30: swap_threshold=32'd40559050;
31: swap_threshold=32'd34720985;
32: swap_threshold=32'd29723250;
33: swap_threshold=32'd25444889;
34: swap_threshold=32'd21782355;
35: swap_threshold=32'd18647005;
36: swap_threshold=32'd15962957;
37: swap_threshold=32'd13665251;
38: swap_threshold=32'd11698276;
39: swap_threshold=32'd10014428;
40: swap_threshold=32'd8572952;
41: swap_threshold=32'd7338962;
42: swap_threshold=32'd6282593;
43: swap_threshold=32'd5378277;
44: swap_threshold=32'd4604128;
45: swap_threshold=32'd3941411;
46: swap_threshold=32'd3374084;
47: swap_threshold=32'd2888419;
48: swap_threshold=32'd2472660;
49: swap_threshold=32'd2116746;
50: swap_threshold=32'd1812062;
51: swap_threshold=32'd1551234;
52: swap_threshold=32'd1327949;
53: swap_threshold=32'd1136804;
54: swap_threshold=32'd973173;
55: swap_threshold=32'd833094;
56: swap_threshold=32'd713179;
57: swap_threshold=32'd610524;
58: swap_threshold=32'd522645;
59: swap_threshold=32'd447415;
60: swap_threshold=32'd383014;
61: swap_threshold=32'd327883;
62: swap_threshold=32'd280688;
63: swap_threshold=32'd240286;
64: swap_threshold=32'd205699;
65: swap_threshold=32'd176090;
66: swap_threshold=32'd150744;
67: swap_threshold=32'd129046;
68: swap_threshold=32'd110471;
69: swap_threshold=32'd94570;
70: swap_threshold=32'd80957;
71: swap_threshold=32'd69304;
72: swap_threshold=32'd59328;
73: swap_threshold=32'd50789;
74: swap_threshold=32'd43478;
75: swap_threshold=32'd37220;
76: swap_threshold=32'd31862;
77: swap_threshold=32'd27276;
78: swap_threshold=32'd23350;
79: swap_threshold=32'd19989;
80: swap_threshold=32'd17112;
81: swap_threshold=32'd14648;
82: swap_threshold=32'd12540;
83: swap_threshold=32'd10735;
84: swap_threshold=32'd9190;
85: swap_threshold=32'd7867;
86: swap_threshold=32'd6734;
87: swap_threshold=32'd5765;
88: swap_threshold=32'd4935;
89: swap_threshold=32'd4225;
90: swap_threshold=32'd3616;
91: swap_threshold=32'd3096;
92: swap_threshold=32'd2650;
93: swap_threshold=32'd2269;
94: swap_threshold=32'd1942;
95: swap_threshold=32'd1662;
96: swap_threshold=32'd1423;
97: swap_threshold=32'd1218;
98: swap_threshold=32'd1043;
99: swap_threshold=32'd893;
100: swap_threshold=32'd764;
101: swap_threshold=32'd654;
102: swap_threshold=32'd560;
103: swap_threshold=32'd479;
104: swap_threshold=32'd410;
105: swap_threshold=32'd351;
106: swap_threshold=32'd300;
107: swap_threshold=32'd257;
108: swap_threshold=32'd220;
109: swap_threshold=32'd188;
110: swap_threshold=32'd161;
111: swap_threshold=32'd138;
112: swap_threshold=32'd118;
113: swap_threshold=32'd101;
114: swap_threshold=32'd86;
115: swap_threshold=32'd74;
116: swap_threshold=32'd63;
117: swap_threshold=32'd54;
118: swap_threshold=32'd46;
119: swap_threshold=32'd39;
120: swap_threshold=32'd34;
121: swap_threshold=32'd29;
122: swap_threshold=32'd25;
123: swap_threshold=32'd21;
124: swap_threshold=32'd18;
125: swap_threshold=32'd15;
126: swap_threshold=32'd13;
127: swap_threshold=32'd11;
128: swap_threshold=32'd9;
129: swap_threshold=32'd8;
130: swap_threshold=32'd7;
131: swap_threshold=32'd6;
132: swap_threshold=32'd5;
133: swap_threshold=32'd4;
134: swap_threshold=32'd3;
135: swap_threshold=32'd3;
136: swap_threshold=32'd2;
137: swap_threshold=32'd2;
138: swap_threshold=32'd2;
139: swap_threshold=32'd1;
140: swap_threshold=32'd1;
141: swap_threshold=32'd1;
142: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
14: begin case(gap)
1: swap_threshold=32'd3676750204;
2: swap_threshold=32'd3147519208;
3: swap_threshold=32'd2694465660;
4: swap_threshold=32'd2306624587;
5: swap_threshold=32'd1974609313;
6: swap_threshold=32'd1690384279;
7: swap_threshold=32'd1447070563;
8: swap_threshold=32'd1238779395;
9: swap_threshold=32'd1060469633;
10: swap_threshold=32'd907825758;
11: swap_threshold=32'd777153424;
12: swap_threshold=32'd665290051;
13: swap_threshold=32'd569528278;
14: swap_threshold=32'd487550444;
15: swap_threshold=32'd417372490;
16: swap_threshold=32'd357295942;
17: swap_threshold=32'd305866806;
18: swap_threshold=32'd261840374;
19: swap_threshold=32'd224151101;
20: swap_threshold=32'd191886817;
21: swap_threshold=32'd164266651;
22: swap_threshold=32'd140622128;
23: swap_threshold=32'd120380996;
24: swap_threshold=32'd103053369;
25: swap_threshold=32'd88219879;
26: swap_threshold=32'd75521520;
27: swap_threshold=32'd64650961;
28: swap_threshold=32'd55345109;
29: swap_threshold=32'd47378741;
30: swap_threshold=32'd40559050;
31: swap_threshold=32'd34720985;
32: swap_threshold=32'd29723250;
33: swap_threshold=32'd25444889;
34: swap_threshold=32'd21782355;
35: swap_threshold=32'd18647005;
36: swap_threshold=32'd15962957;
37: swap_threshold=32'd13665251;
38: swap_threshold=32'd11698276;
39: swap_threshold=32'd10014428;
40: swap_threshold=32'd8572952;
41: swap_threshold=32'd7338962;
42: swap_threshold=32'd6282593;
43: swap_threshold=32'd5378277;
44: swap_threshold=32'd4604128;
45: swap_threshold=32'd3941411;
46: swap_threshold=32'd3374084;
47: swap_threshold=32'd2888419;
48: swap_threshold=32'd2472660;
49: swap_threshold=32'd2116746;
50: swap_threshold=32'd1812062;
51: swap_threshold=32'd1551234;
52: swap_threshold=32'd1327949;
53: swap_threshold=32'd1136804;
54: swap_threshold=32'd973173;
55: swap_threshold=32'd833094;
56: swap_threshold=32'd713179;
57: swap_threshold=32'd610524;
58: swap_threshold=32'd522645;
59: swap_threshold=32'd447415;
60: swap_threshold=32'd383014;
61: swap_threshold=32'd327883;
62: swap_threshold=32'd280688;
63: swap_threshold=32'd240286;
64: swap_threshold=32'd205699;
65: swap_threshold=32'd176090;
66: swap_threshold=32'd150744;
67: swap_threshold=32'd129046;
68: swap_threshold=32'd110471;
69: swap_threshold=32'd94570;
70: swap_threshold=32'd80957;
71: swap_threshold=32'd69304;
72: swap_threshold=32'd59328;
73: swap_threshold=32'd50789;
74: swap_threshold=32'd43478;
75: swap_threshold=32'd37220;
76: swap_threshold=32'd31862;
77: swap_threshold=32'd27276;
78: swap_threshold=32'd23350;
79: swap_threshold=32'd19989;
80: swap_threshold=32'd17112;
81: swap_threshold=32'd14648;
82: swap_threshold=32'd12540;
83: swap_threshold=32'd10735;
84: swap_threshold=32'd9190;
85: swap_threshold=32'd7867;
86: swap_threshold=32'd6734;
87: swap_threshold=32'd5765;
88: swap_threshold=32'd4935;
89: swap_threshold=32'd4225;
90: swap_threshold=32'd3616;
91: swap_threshold=32'd3096;
92: swap_threshold=32'd2650;
93: swap_threshold=32'd2269;
94: swap_threshold=32'd1942;
95: swap_threshold=32'd1662;
96: swap_threshold=32'd1423;
97: swap_threshold=32'd1218;
98: swap_threshold=32'd1043;
99: swap_threshold=32'd893;
100: swap_threshold=32'd764;
101: swap_threshold=32'd654;
102: swap_threshold=32'd560;
103: swap_threshold=32'd479;
104: swap_threshold=32'd410;
105: swap_threshold=32'd351;
106: swap_threshold=32'd300;
107: swap_threshold=32'd257;
108: swap_threshold=32'd220;
109: swap_threshold=32'd188;
110: swap_threshold=32'd161;
111: swap_threshold=32'd138;
112: swap_threshold=32'd118;
113: swap_threshold=32'd101;
114: swap_threshold=32'd86;
115: swap_threshold=32'd74;
116: swap_threshold=32'd63;
117: swap_threshold=32'd54;
118: swap_threshold=32'd46;
119: swap_threshold=32'd39;
120: swap_threshold=32'd34;
121: swap_threshold=32'd29;
122: swap_threshold=32'd25;
123: swap_threshold=32'd21;
124: swap_threshold=32'd18;
125: swap_threshold=32'd15;
126: swap_threshold=32'd13;
127: swap_threshold=32'd11;
128: swap_threshold=32'd9;
129: swap_threshold=32'd8;
130: swap_threshold=32'd7;
131: swap_threshold=32'd6;
132: swap_threshold=32'd5;
133: swap_threshold=32'd4;
134: swap_threshold=32'd3;
135: swap_threshold=32'd3;
136: swap_threshold=32'd2;
137: swap_threshold=32'd2;
138: swap_threshold=32'd2;
139: swap_threshold=32'd1;
140: swap_threshold=32'd1;
141: swap_threshold=32'd1;
142: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
15: begin case(gap)
1: swap_threshold=32'd3449820885;
2: swap_threshold=32'd2770978990;
3: swap_threshold=32'd2225716876;
4: swap_threshold=32'd1787749250;
5: swap_threshold=32'd1435963134;
6: swap_threshold=32'd1153400077;
7: swap_threshold=32'd926438643;
8: swap_threshold=32'd744137769;
9: swap_threshold=32'd597709328;
10: swap_threshold=32'd480094487;
11: swap_threshold=32'd385623423;
12: swap_threshold=32'd309741995;
13: swap_threshold=32'd248792209;
14: swap_threshold=32'd199835878;
15: swap_threshold=32'd160512976;
16: swap_threshold=32'd128927878;
17: swap_threshold=32'd103557968;
18: swap_threshold=32'd83180247;
19: swap_threshold=32'd66812372;
20: swap_threshold=32'd53665302;
21: swap_threshold=32'd43105259;
22: swap_threshold=32'd34623179;
23: swap_threshold=32'd27810169;
24: swap_threshold=32'd22337796;
25: swap_threshold=32'd17942254;
26: swap_threshold=32'd14411649;
27: swap_threshold=32'd11575783;
28: swap_threshold=32'd9297946;
29: swap_threshold=32'd7468334;
30: swap_threshold=32'd5998745;
31: swap_threshold=32'd4818336;
32: swap_threshold=32'd3870203;
33: swap_threshold=32'd3108640;
34: swap_threshold=32'd2496934;
35: swap_threshold=32'd2005597;
36: swap_threshold=32'd1610944;
37: swap_threshold=32'd1293949;
38: swap_threshold=32'd1039331;
39: swap_threshold=32'd834815;
40: swap_threshold=32'd670544;
41: swap_threshold=32'd538597;
42: swap_threshold=32'd432614;
43: swap_threshold=32'd347486;
44: swap_threshold=32'd279109;
45: swap_threshold=32'd224187;
46: swap_threshold=32'd180072;
47: swap_threshold=32'd144638;
48: swap_threshold=32'd116177;
49: swap_threshold=32'd93316;
50: swap_threshold=32'd74953;
51: swap_threshold=32'd60204;
52: swap_threshold=32'd48357;
53: swap_threshold=32'd38842;
54: swap_threshold=32'd31199;
55: swap_threshold=32'd25059;
56: swap_threshold=32'd20128;
57: swap_threshold=32'd16167;
58: swap_threshold=32'd12986;
59: swap_threshold=32'd10430;
60: swap_threshold=32'd8378;
61: swap_threshold=32'd6729;
62: swap_threshold=32'd5405;
63: swap_threshold=32'd4341;
64: swap_threshold=32'd3487;
65: swap_threshold=32'd2801;
66: swap_threshold=32'd2249;
67: swap_threshold=32'd1807;
68: swap_threshold=32'd1451;
69: swap_threshold=32'd1165;
70: swap_threshold=32'd936;
71: swap_threshold=32'd752;
72: swap_threshold=32'd604;
73: swap_threshold=32'd485;
74: swap_threshold=32'd389;
75: swap_threshold=32'd313;
76: swap_threshold=32'd251;
77: swap_threshold=32'd202;
78: swap_threshold=32'd162;
79: swap_threshold=32'd130;
80: swap_threshold=32'd104;
81: swap_threshold=32'd84;
82: swap_threshold=32'd67;
83: swap_threshold=32'd54;
84: swap_threshold=32'd43;
85: swap_threshold=32'd35;
86: swap_threshold=32'd28;
87: swap_threshold=32'd22;
88: swap_threshold=32'd18;
89: swap_threshold=32'd14;
90: swap_threshold=32'd11;
91: swap_threshold=32'd9;
92: swap_threshold=32'd7;
93: swap_threshold=32'd6;
94: swap_threshold=32'd4;
95: swap_threshold=32'd3;
96: swap_threshold=32'd3;
97: swap_threshold=32'd2;
98: swap_threshold=32'd2;
99: swap_threshold=32'd1;
100: swap_threshold=32'd1;
101: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
16: begin case(gap)
1: swap_threshold=32'd3288436530;
2: swap_threshold=32'd2517787464;
3: swap_threshold=32'd1927740935;
4: swap_threshold=32'd1475972522;
5: swap_threshold=32'd1130076582;
6: swap_threshold=32'd865241772;
7: swap_threshold=32'd662471319;
8: swap_threshold=32'd507220366;
9: swap_threshold=32'd388352662;
10: swap_threshold=32'd297341747;
11: swap_threshold=32'd227659350;
12: swap_threshold=32'd174307107;
13: swap_threshold=32'd133458026;
14: swap_threshold=32'd102181976;
15: swap_threshold=32'd78235507;
16: swap_threshold=32'd59900921;
17: swap_threshold=32'd45863068;
18: swap_threshold=32'd35115003;
19: swap_threshold=32'd26885759;
20: swap_threshold=32'd20585049;
21: swap_threshold=32'd15760918;
22: swap_threshold=32'd12067328;
23: swap_threshold=32'd9239335;
24: swap_threshold=32'd7074085;
25: swap_threshold=32'd5416265;
26: swap_threshold=32'd4146957;
27: swap_threshold=32'd3175112;
28: swap_threshold=32'd2431021;
29: swap_threshold=32'd1861308;
30: swap_threshold=32'd1425108;
31: swap_threshold=32'd1091132;
32: swap_threshold=32'd835424;
33: swap_threshold=32'd639641;
34: swap_threshold=32'd489740;
35: swap_threshold=32'd374969;
36: swap_threshold=32'd287094;
37: swap_threshold=32'd219813;
38: swap_threshold=32'd168300;
39: swap_threshold=32'd128858;
40: swap_threshold=32'd98660;
41: swap_threshold=32'd75539;
42: swap_threshold=32'd57836;
43: swap_threshold=32'd44282;
44: swap_threshold=32'd33904;
45: swap_threshold=32'd25959;
46: swap_threshold=32'd19875;
47: swap_threshold=32'd15217;
48: swap_threshold=32'd11651;
49: swap_threshold=32'd8920;
50: swap_threshold=32'd6830;
51: swap_threshold=32'd5229;
52: swap_threshold=32'd4004;
53: swap_threshold=32'd3065;
54: swap_threshold=32'd2347;
55: swap_threshold=32'd1797;
56: swap_threshold=32'd1375;
57: swap_threshold=32'd1053;
58: swap_threshold=32'd806;
59: swap_threshold=32'd617;
60: swap_threshold=32'd472;
61: swap_threshold=32'd362;
62: swap_threshold=32'd277;
63: swap_threshold=32'd212;
64: swap_threshold=32'd162;
65: swap_threshold=32'd124;
66: swap_threshold=32'd95;
67: swap_threshold=32'd72;
68: swap_threshold=32'd55;
69: swap_threshold=32'd42;
70: swap_threshold=32'd32;
71: swap_threshold=32'd25;
72: swap_threshold=32'd19;
73: swap_threshold=32'd14;
74: swap_threshold=32'd11;
75: swap_threshold=32'd8;
76: swap_threshold=32'd6;
77: swap_threshold=32'd5;
78: swap_threshold=32'd3;
79: swap_threshold=32'd2;
80: swap_threshold=32'd2;
81: swap_threshold=32'd1;
82: swap_threshold=32'd1;
83: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
17: begin case(gap)
1: swap_threshold=32'd2978542572;
2: swap_threshold=32'd2065607312;
3: swap_threshold=32'd1432490376;
4: swap_threshold=32'd993426323;
5: swap_threshold=32'd688937165;
6: swap_threshold=32'd477775157;
7: swap_threshold=32'd331335153;
8: swap_threshold=32'd229779598;
9: swap_threshold=32'd159351228;
10: swap_threshold=32'd110509437;
11: swap_threshold=32'd76637850;
12: swap_threshold=32'd53148041;
13: swap_threshold=32'd36857953;
14: swap_threshold=32'd25560842;
15: swap_threshold=32'd17726341;
16: swap_threshold=32'd12293146;
17: swap_threshold=32'd8525247;
18: swap_threshold=32'd5912225;
19: swap_threshold=32'd4100104;
20: swap_threshold=32'd2843405;
21: swap_threshold=32'd1971890;
22: swap_threshold=32'd1367498;
23: swap_threshold=32'd948354;
24: swap_threshold=32'd657680;
25: swap_threshold=32'd456098;
26: swap_threshold=32'd316302;
27: swap_threshold=32'd219354;
28: swap_threshold=32'd152121;
29: swap_threshold=32'd105495;
30: swap_threshold=32'd73160;
31: swap_threshold=32'd50736;
32: swap_threshold=32'd35185;
33: swap_threshold=32'd24401;
34: swap_threshold=32'd16922;
35: swap_threshold=32'd11735;
36: swap_threshold=32'd8138;
37: swap_threshold=32'd5643;
38: swap_threshold=32'd3914;
39: swap_threshold=32'd2714;
40: swap_threshold=32'd1882;
41: swap_threshold=32'd1305;
42: swap_threshold=32'd905;
43: swap_threshold=32'd627;
44: swap_threshold=32'd435;
45: swap_threshold=32'd301;
46: swap_threshold=32'd209;
47: swap_threshold=32'd145;
48: swap_threshold=32'd100;
49: swap_threshold=32'd69;
50: swap_threshold=32'd48;
51: swap_threshold=32'd33;
52: swap_threshold=32'd23;
53: swap_threshold=32'd16;
54: swap_threshold=32'd11;
55: swap_threshold=32'd7;
56: swap_threshold=32'd5;
57: swap_threshold=32'd3;
58: swap_threshold=32'd2;
59: swap_threshold=32'd1;
60: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
18: begin case(gap)
1: swap_threshold=32'd2660873083;
2: swap_threshold=32'd1648498132;
3: swap_threshold=32'd1021298651;
4: swap_threshold=32'd632728005;
5: swap_threshold=32'd391995748;
6: swap_threshold=32'd242854220;
7: swap_threshold=32'd150456153;
8: swap_threshold=32'd93212521;
9: swap_threshold=32'd57748213;
10: swap_threshold=32'd35776911;
11: swap_threshold=32'd22164970;
12: swap_threshold=32'd13731925;
13: swap_threshold=32'd8507378;
14: swap_threshold=32'd5270599;
15: swap_threshold=32'd3265309;
16: swap_threshold=32'd2022966;
17: swap_threshold=32'd1253293;
18: swap_threshold=32'd776456;
19: swap_threshold=32'd481040;
20: swap_threshold=32'd298020;
21: swap_threshold=32'd184633;
22: swap_threshold=32'd114386;
23: swap_threshold=32'd70866;
24: swap_threshold=32'd43903;
25: swap_threshold=32'd27199;
26: swap_threshold=32'd16851;
27: swap_threshold=32'd10439;
28: swap_threshold=32'd6467;
29: swap_threshold=32'd4007;
30: swap_threshold=32'd2482;
31: swap_threshold=32'd1537;
32: swap_threshold=32'd952;
33: swap_threshold=32'd590;
34: swap_threshold=32'd365;
35: swap_threshold=32'd226;
36: swap_threshold=32'd140;
37: swap_threshold=32'd86;
38: swap_threshold=32'd53;
39: swap_threshold=32'd33;
40: swap_threshold=32'd20;
41: swap_threshold=32'd12;
42: swap_threshold=32'd7;
43: swap_threshold=32'd4;
44: swap_threshold=32'd3;
45: swap_threshold=32'd1;
46: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
19: begin case(gap)
1: swap_threshold=32'd2423116833;
2: swap_threshold=32'd1367064003;
3: swap_threshold=32'd771264498;
4: swap_threshold=32'd435128805;
5: swap_threshold=32'd245489164;
6: swap_threshold=32'd138499058;
7: swap_threshold=32'd78137824;
8: swap_threshold=32'd44083473;
9: swap_threshold=32'd24870831;
10: swap_threshold=32'd14031522;
11: swap_threshold=32'd7916246;
12: swap_threshold=32'd4466154;
13: swap_threshold=32'd2519696;
14: swap_threshold=32'd1421552;
15: swap_threshold=32'd802005;
16: swap_threshold=32'd452472;
17: swap_threshold=32'd255273;
18: swap_threshold=32'd144019;
19: swap_threshold=32'd81252;
20: swap_threshold=32'd45840;
21: swap_threshold=32'd25862;
22: swap_threshold=32'd14590;
23: swap_threshold=32'd8231;
24: swap_threshold=32'd4644;
25: swap_threshold=32'd2620;
26: swap_threshold=32'd1478;
27: swap_threshold=32'd833;
28: swap_threshold=32'd470;
29: swap_threshold=32'd265;
30: swap_threshold=32'd149;
31: swap_threshold=32'd84;
32: swap_threshold=32'd47;
33: swap_threshold=32'd26;
34: swap_threshold=32'd15;
35: swap_threshold=32'd8;
36: swap_threshold=32'd4;
37: swap_threshold=32'd2;
38: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
20: begin case(gap)
1: swap_threshold=32'd1924803530;
2: swap_threshold=32'd862606948;
3: swap_threshold=32'd386580103;
4: swap_threshold=32'd173247127;
5: swap_threshold=32'd77641262;
6: swap_threshold=32'd34795183;
7: swap_threshold=32'd15593574;
8: swap_threshold=32'd6988311;
9: swap_threshold=32'd3131834;
10: swap_threshold=32'd1403541;
11: swap_threshold=32'd629001;
12: swap_threshold=32'd281889;
13: swap_threshold=32'd126329;
14: swap_threshold=32'd56614;
15: swap_threshold=32'd25372;
16: swap_threshold=32'd11370;
17: swap_threshold=32'd5095;
18: swap_threshold=32'd2283;
19: swap_threshold=32'd1023;
20: swap_threshold=32'd458;
21: swap_threshold=32'd205;
22: swap_threshold=32'd92;
23: swap_threshold=32'd41;
24: swap_threshold=32'd18;
25: swap_threshold=32'd8;
26: swap_threshold=32'd3;
27: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
21: begin case(gap)
1: swap_threshold=32'd1389944239;
2: swap_threshold=32'd449815995;
3: swap_threshold=32'd145570177;
4: swap_threshold=32'd47109655;
5: swap_threshold=32'd15245702;
6: swap_threshold=32'd4933838;
7: swap_threshold=32'd1596696;
8: swap_threshold=32'd516725;
9: swap_threshold=32'd167223;
10: swap_threshold=32'd54117;
11: swap_threshold=32'd17513;
12: swap_threshold=32'd5667;
13: swap_threshold=32'd1834;
14: swap_threshold=32'd593;
15: swap_threshold=32'd192;
16: swap_threshold=32'd62;
17: swap_threshold=32'd20;
18: swap_threshold=32'd6;
19: swap_threshold=32'd2;
default: swap_threshold=0;
endcase end
22: begin case(gap)
1: swap_threshold=32'd2665571615;
2: swap_threshold=32'd1654325061;
3: swap_threshold=32'd1026718394;
4: swap_threshold=32'd637208905;
5: swap_threshold=32'd395468895;
6: swap_threshold=32'd245438577;
7: swap_threshold=32'd152325747;
8: swap_threshold=32'd94537434;
9: swap_threshold=32'd58672461;
10: swap_threshold=32'd36413699;
11: swap_threshold=32'd22599315;
12: swap_threshold=32'd14025740;
13: swap_threshold=32'd8704749;
14: swap_threshold=32'd5402400;
15: swap_threshold=32'd3352874;
16: swap_threshold=32'd2080883;
17: swap_threshold=32'd1291451;
18: swap_threshold=32'd801509;
19: swap_threshold=32'd497438;
20: swap_threshold=32'd308723;
21: swap_threshold=32'd191602;
22: swap_threshold=32'd118913;
23: swap_threshold=32'd73800;
24: swap_threshold=32'd45802;
25: swap_threshold=32'd28426;
26: swap_threshold=32'd17642;
27: swap_threshold=32'd10949;
28: swap_threshold=32'd6795;
29: swap_threshold=32'd4217;
30: swap_threshold=32'd2617;
31: swap_threshold=32'd1624;
32: swap_threshold=32'd1008;
33: swap_threshold=32'd625;
34: swap_threshold=32'd388;
35: swap_threshold=32'd241;
36: swap_threshold=32'd149;
37: swap_threshold=32'd92;
38: swap_threshold=32'd57;
39: swap_threshold=32'd35;
40: swap_threshold=32'd22;
41: swap_threshold=32'd13;
42: swap_threshold=32'd8;
43: swap_threshold=32'd5;
44: swap_threshold=32'd3;
45: swap_threshold=32'd2;
46: swap_threshold=32'd1;
default: swap_threshold=0;
endcase end
default: swap_threshold=0;
endcase
end
endfunction
function automatic [511:0] expand(input logic [511:0] mask);
begin
expand[0] = mask[0] | mask[1] | mask[16] | mask[17];
expand[1] = mask[1] | mask[0] | mask[2] | mask[16] | mask[17] | mask[18];
expand[2] = mask[2] | mask[1] | mask[3] | mask[17] | mask[18] | mask[19];
expand[3] = mask[3] | mask[2] | mask[4] | mask[18] | mask[19] | mask[20];
expand[4] = mask[4] | mask[3] | mask[5] | mask[19] | mask[20] | mask[21];
expand[5] = mask[5] | mask[4] | mask[6] | mask[20] | mask[21] | mask[22];
expand[6] = mask[6] | mask[5] | mask[7] | mask[21] | mask[22] | mask[23];
expand[7] = mask[7] | mask[6] | mask[8] | mask[22] | mask[23] | mask[24];
expand[8] = mask[8] | mask[7] | mask[9] | mask[23] | mask[24] | mask[25];
expand[9] = mask[9] | mask[8] | mask[10] | mask[24] | mask[25] | mask[26];
expand[10] = mask[10] | mask[9] | mask[11] | mask[25] | mask[26] | mask[27];
expand[11] = mask[11] | mask[10] | mask[12] | mask[26] | mask[27] | mask[28];
expand[12] = mask[12] | mask[11] | mask[13] | mask[27] | mask[28] | mask[29];
expand[13] = mask[13] | mask[12] | mask[14] | mask[28] | mask[29] | mask[30];
expand[14] = mask[14] | mask[13] | mask[15] | mask[29] | mask[30] | mask[31];
expand[15] = mask[15] | mask[14] | mask[30] | mask[31];
expand[16] = mask[16] | mask[0] | mask[1] | mask[17] | mask[32] | mask[33];
expand[17] = mask[17] | mask[0] | mask[1] | mask[2] | mask[16] | mask[18] | mask[32] | mask[33] | mask[34];
expand[18] = mask[18] | mask[1] | mask[2] | mask[3] | mask[17] | mask[19] | mask[33] | mask[34] | mask[35];
expand[19] = mask[19] | mask[2] | mask[3] | mask[4] | mask[18] | mask[20] | mask[34] | mask[35] | mask[36];
expand[20] = mask[20] | mask[3] | mask[4] | mask[5] | mask[19] | mask[21] | mask[35] | mask[36] | mask[37];
expand[21] = mask[21] | mask[4] | mask[5] | mask[6] | mask[20] | mask[22] | mask[36] | mask[37] | mask[38];
expand[22] = mask[22] | mask[5] | mask[6] | mask[7] | mask[21] | mask[23] | mask[37] | mask[38] | mask[39];
expand[23] = mask[23] | mask[6] | mask[7] | mask[8] | mask[22] | mask[24] | mask[38] | mask[39] | mask[40];
expand[24] = mask[24] | mask[7] | mask[8] | mask[9] | mask[23] | mask[25] | mask[39] | mask[40] | mask[41];
expand[25] = mask[25] | mask[8] | mask[9] | mask[10] | mask[24] | mask[26] | mask[40] | mask[41] | mask[42];
expand[26] = mask[26] | mask[9] | mask[10] | mask[11] | mask[25] | mask[27] | mask[41] | mask[42] | mask[43];
expand[27] = mask[27] | mask[10] | mask[11] | mask[12] | mask[26] | mask[28] | mask[42] | mask[43] | mask[44];
expand[28] = mask[28] | mask[11] | mask[12] | mask[13] | mask[27] | mask[29] | mask[43] | mask[44] | mask[45];
expand[29] = mask[29] | mask[12] | mask[13] | mask[14] | mask[28] | mask[30] | mask[44] | mask[45] | mask[46];
expand[30] = mask[30] | mask[13] | mask[14] | mask[15] | mask[29] | mask[31] | mask[45] | mask[46] | mask[47];
expand[31] = mask[31] | mask[14] | mask[15] | mask[30] | mask[46] | mask[47];
expand[32] = mask[32] | mask[16] | mask[17] | mask[33] | mask[48] | mask[49];
expand[33] = mask[33] | mask[16] | mask[17] | mask[18] | mask[32] | mask[34] | mask[48] | mask[49] | mask[50];
expand[34] = mask[34] | mask[17] | mask[18] | mask[19] | mask[33] | mask[35] | mask[49] | mask[50] | mask[51];
expand[35] = mask[35] | mask[18] | mask[19] | mask[20] | mask[34] | mask[36] | mask[50] | mask[51] | mask[52];
expand[36] = mask[36] | mask[19] | mask[20] | mask[21] | mask[35] | mask[37] | mask[51] | mask[52] | mask[53];
expand[37] = mask[37] | mask[20] | mask[21] | mask[22] | mask[36] | mask[38] | mask[52] | mask[53] | mask[54];
expand[38] = mask[38] | mask[21] | mask[22] | mask[23] | mask[37] | mask[39] | mask[53] | mask[54] | mask[55];
expand[39] = mask[39] | mask[22] | mask[23] | mask[24] | mask[38] | mask[40] | mask[54] | mask[55] | mask[56];
expand[40] = mask[40] | mask[23] | mask[24] | mask[25] | mask[39] | mask[41] | mask[55] | mask[56] | mask[57];
expand[41] = mask[41] | mask[24] | mask[25] | mask[26] | mask[40] | mask[42] | mask[56] | mask[57] | mask[58];
expand[42] = mask[42] | mask[25] | mask[26] | mask[27] | mask[41] | mask[43] | mask[57] | mask[58] | mask[59];
expand[43] = mask[43] | mask[26] | mask[27] | mask[28] | mask[42] | mask[44] | mask[58] | mask[59] | mask[60];
expand[44] = mask[44] | mask[27] | mask[28] | mask[29] | mask[43] | mask[45] | mask[59] | mask[60] | mask[61];
expand[45] = mask[45] | mask[28] | mask[29] | mask[30] | mask[44] | mask[46] | mask[60] | mask[61] | mask[62];
expand[46] = mask[46] | mask[29] | mask[30] | mask[31] | mask[45] | mask[47] | mask[61] | mask[62] | mask[63];
expand[47] = mask[47] | mask[30] | mask[31] | mask[46] | mask[62] | mask[63];
expand[48] = mask[48] | mask[32] | mask[33] | mask[49] | mask[64] | mask[65];
expand[49] = mask[49] | mask[32] | mask[33] | mask[34] | mask[48] | mask[50] | mask[64] | mask[65] | mask[66];
expand[50] = mask[50] | mask[33] | mask[34] | mask[35] | mask[49] | mask[51] | mask[65] | mask[66] | mask[67];
expand[51] = mask[51] | mask[34] | mask[35] | mask[36] | mask[50] | mask[52] | mask[66] | mask[67] | mask[68];
expand[52] = mask[52] | mask[35] | mask[36] | mask[37] | mask[51] | mask[53] | mask[67] | mask[68] | mask[69];
expand[53] = mask[53] | mask[36] | mask[37] | mask[38] | mask[52] | mask[54] | mask[68] | mask[69] | mask[70];
expand[54] = mask[54] | mask[37] | mask[38] | mask[39] | mask[53] | mask[55] | mask[69] | mask[70] | mask[71];
expand[55] = mask[55] | mask[38] | mask[39] | mask[40] | mask[54] | mask[56] | mask[70] | mask[71] | mask[72];
expand[56] = mask[56] | mask[39] | mask[40] | mask[41] | mask[55] | mask[57] | mask[71] | mask[72] | mask[73];
expand[57] = mask[57] | mask[40] | mask[41] | mask[42] | mask[56] | mask[58] | mask[72] | mask[73] | mask[74];
expand[58] = mask[58] | mask[41] | mask[42] | mask[43] | mask[57] | mask[59] | mask[73] | mask[74] | mask[75];
expand[59] = mask[59] | mask[42] | mask[43] | mask[44] | mask[58] | mask[60] | mask[74] | mask[75] | mask[76];
expand[60] = mask[60] | mask[43] | mask[44] | mask[45] | mask[59] | mask[61] | mask[75] | mask[76] | mask[77];
expand[61] = mask[61] | mask[44] | mask[45] | mask[46] | mask[60] | mask[62] | mask[76] | mask[77] | mask[78];
expand[62] = mask[62] | mask[45] | mask[46] | mask[47] | mask[61] | mask[63] | mask[77] | mask[78] | mask[79];
expand[63] = mask[63] | mask[46] | mask[47] | mask[62] | mask[78] | mask[79];
expand[64] = mask[64] | mask[48] | mask[49] | mask[65] | mask[80] | mask[81];
expand[65] = mask[65] | mask[48] | mask[49] | mask[50] | mask[64] | mask[66] | mask[80] | mask[81] | mask[82];
expand[66] = mask[66] | mask[49] | mask[50] | mask[51] | mask[65] | mask[67] | mask[81] | mask[82] | mask[83];
expand[67] = mask[67] | mask[50] | mask[51] | mask[52] | mask[66] | mask[68] | mask[82] | mask[83] | mask[84];
expand[68] = mask[68] | mask[51] | mask[52] | mask[53] | mask[67] | mask[69] | mask[83] | mask[84] | mask[85];
expand[69] = mask[69] | mask[52] | mask[53] | mask[54] | mask[68] | mask[70] | mask[84] | mask[85] | mask[86];
expand[70] = mask[70] | mask[53] | mask[54] | mask[55] | mask[69] | mask[71] | mask[85] | mask[86] | mask[87];
expand[71] = mask[71] | mask[54] | mask[55] | mask[56] | mask[70] | mask[72] | mask[86] | mask[87] | mask[88];
expand[72] = mask[72] | mask[55] | mask[56] | mask[57] | mask[71] | mask[73] | mask[87] | mask[88] | mask[89];
expand[73] = mask[73] | mask[56] | mask[57] | mask[58] | mask[72] | mask[74] | mask[88] | mask[89] | mask[90];
expand[74] = mask[74] | mask[57] | mask[58] | mask[59] | mask[73] | mask[75] | mask[89] | mask[90] | mask[91];
expand[75] = mask[75] | mask[58] | mask[59] | mask[60] | mask[74] | mask[76] | mask[90] | mask[91] | mask[92];
expand[76] = mask[76] | mask[59] | mask[60] | mask[61] | mask[75] | mask[77] | mask[91] | mask[92] | mask[93];
expand[77] = mask[77] | mask[60] | mask[61] | mask[62] | mask[76] | mask[78] | mask[92] | mask[93] | mask[94];
expand[78] = mask[78] | mask[61] | mask[62] | mask[63] | mask[77] | mask[79] | mask[93] | mask[94] | mask[95];
expand[79] = mask[79] | mask[62] | mask[63] | mask[78] | mask[94] | mask[95];
expand[80] = mask[80] | mask[64] | mask[65] | mask[81] | mask[96] | mask[97];
expand[81] = mask[81] | mask[64] | mask[65] | mask[66] | mask[80] | mask[82] | mask[96] | mask[97] | mask[98];
expand[82] = mask[82] | mask[65] | mask[66] | mask[67] | mask[81] | mask[83] | mask[97] | mask[98] | mask[99];
expand[83] = mask[83] | mask[66] | mask[67] | mask[68] | mask[82] | mask[84] | mask[98] | mask[99] | mask[100];
expand[84] = mask[84] | mask[67] | mask[68] | mask[69] | mask[83] | mask[85] | mask[99] | mask[100] | mask[101];
expand[85] = mask[85] | mask[68] | mask[69] | mask[70] | mask[84] | mask[86] | mask[100] | mask[101] | mask[102];
expand[86] = mask[86] | mask[69] | mask[70] | mask[71] | mask[85] | mask[87] | mask[101] | mask[102] | mask[103];
expand[87] = mask[87] | mask[70] | mask[71] | mask[72] | mask[86] | mask[88] | mask[102] | mask[103] | mask[104];
expand[88] = mask[88] | mask[71] | mask[72] | mask[73] | mask[87] | mask[89] | mask[103] | mask[104] | mask[105];
expand[89] = mask[89] | mask[72] | mask[73] | mask[74] | mask[88] | mask[90] | mask[104] | mask[105] | mask[106];
expand[90] = mask[90] | mask[73] | mask[74] | mask[75] | mask[89] | mask[91] | mask[105] | mask[106] | mask[107];
expand[91] = mask[91] | mask[74] | mask[75] | mask[76] | mask[90] | mask[92] | mask[106] | mask[107] | mask[108];
expand[92] = mask[92] | mask[75] | mask[76] | mask[77] | mask[91] | mask[93] | mask[107] | mask[108] | mask[109];
expand[93] = mask[93] | mask[76] | mask[77] | mask[78] | mask[92] | mask[94] | mask[108] | mask[109] | mask[110];
expand[94] = mask[94] | mask[77] | mask[78] | mask[79] | mask[93] | mask[95] | mask[109] | mask[110] | mask[111];
expand[95] = mask[95] | mask[78] | mask[79] | mask[94] | mask[110] | mask[111];
expand[96] = mask[96] | mask[80] | mask[81] | mask[97] | mask[112] | mask[113];
expand[97] = mask[97] | mask[80] | mask[81] | mask[82] | mask[96] | mask[98] | mask[112] | mask[113] | mask[114];
expand[98] = mask[98] | mask[81] | mask[82] | mask[83] | mask[97] | mask[99] | mask[113] | mask[114] | mask[115];
expand[99] = mask[99] | mask[82] | mask[83] | mask[84] | mask[98] | mask[100] | mask[114] | mask[115] | mask[116];
expand[100] = mask[100] | mask[83] | mask[84] | mask[85] | mask[99] | mask[101] | mask[115] | mask[116] | mask[117];
expand[101] = mask[101] | mask[84] | mask[85] | mask[86] | mask[100] | mask[102] | mask[116] | mask[117] | mask[118];
expand[102] = mask[102] | mask[85] | mask[86] | mask[87] | mask[101] | mask[103] | mask[117] | mask[118] | mask[119];
expand[103] = mask[103] | mask[86] | mask[87] | mask[88] | mask[102] | mask[104] | mask[118] | mask[119] | mask[120];
expand[104] = mask[104] | mask[87] | mask[88] | mask[89] | mask[103] | mask[105] | mask[119] | mask[120] | mask[121];
expand[105] = mask[105] | mask[88] | mask[89] | mask[90] | mask[104] | mask[106] | mask[120] | mask[121] | mask[122];
expand[106] = mask[106] | mask[89] | mask[90] | mask[91] | mask[105] | mask[107] | mask[121] | mask[122] | mask[123];
expand[107] = mask[107] | mask[90] | mask[91] | mask[92] | mask[106] | mask[108] | mask[122] | mask[123] | mask[124];
expand[108] = mask[108] | mask[91] | mask[92] | mask[93] | mask[107] | mask[109] | mask[123] | mask[124] | mask[125];
expand[109] = mask[109] | mask[92] | mask[93] | mask[94] | mask[108] | mask[110] | mask[124] | mask[125] | mask[126];
expand[110] = mask[110] | mask[93] | mask[94] | mask[95] | mask[109] | mask[111] | mask[125] | mask[126] | mask[127];
expand[111] = mask[111] | mask[94] | mask[95] | mask[110] | mask[126] | mask[127];
expand[112] = mask[112] | mask[96] | mask[97] | mask[113] | mask[128] | mask[129];
expand[113] = mask[113] | mask[96] | mask[97] | mask[98] | mask[112] | mask[114] | mask[128] | mask[129] | mask[130];
expand[114] = mask[114] | mask[97] | mask[98] | mask[99] | mask[113] | mask[115] | mask[129] | mask[130] | mask[131];
expand[115] = mask[115] | mask[98] | mask[99] | mask[100] | mask[114] | mask[116] | mask[130] | mask[131] | mask[132];
expand[116] = mask[116] | mask[99] | mask[100] | mask[101] | mask[115] | mask[117] | mask[131] | mask[132] | mask[133];
expand[117] = mask[117] | mask[100] | mask[101] | mask[102] | mask[116] | mask[118] | mask[132] | mask[133] | mask[134];
expand[118] = mask[118] | mask[101] | mask[102] | mask[103] | mask[117] | mask[119] | mask[133] | mask[134] | mask[135];
expand[119] = mask[119] | mask[102] | mask[103] | mask[104] | mask[118] | mask[120] | mask[134] | mask[135] | mask[136];
expand[120] = mask[120] | mask[103] | mask[104] | mask[105] | mask[119] | mask[121] | mask[135] | mask[136] | mask[137];
expand[121] = mask[121] | mask[104] | mask[105] | mask[106] | mask[120] | mask[122] | mask[136] | mask[137] | mask[138];
expand[122] = mask[122] | mask[105] | mask[106] | mask[107] | mask[121] | mask[123] | mask[137] | mask[138] | mask[139];
expand[123] = mask[123] | mask[106] | mask[107] | mask[108] | mask[122] | mask[124] | mask[138] | mask[139] | mask[140];
expand[124] = mask[124] | mask[107] | mask[108] | mask[109] | mask[123] | mask[125] | mask[139] | mask[140] | mask[141];
expand[125] = mask[125] | mask[108] | mask[109] | mask[110] | mask[124] | mask[126] | mask[140] | mask[141] | mask[142];
expand[126] = mask[126] | mask[109] | mask[110] | mask[111] | mask[125] | mask[127] | mask[141] | mask[142] | mask[143];
expand[127] = mask[127] | mask[110] | mask[111] | mask[126] | mask[142] | mask[143];
expand[128] = mask[128] | mask[112] | mask[113] | mask[129] | mask[144] | mask[145];
expand[129] = mask[129] | mask[112] | mask[113] | mask[114] | mask[128] | mask[130] | mask[144] | mask[145] | mask[146];
expand[130] = mask[130] | mask[113] | mask[114] | mask[115] | mask[129] | mask[131] | mask[145] | mask[146] | mask[147];
expand[131] = mask[131] | mask[114] | mask[115] | mask[116] | mask[130] | mask[132] | mask[146] | mask[147] | mask[148];
expand[132] = mask[132] | mask[115] | mask[116] | mask[117] | mask[131] | mask[133] | mask[147] | mask[148] | mask[149];
expand[133] = mask[133] | mask[116] | mask[117] | mask[118] | mask[132] | mask[134] | mask[148] | mask[149] | mask[150];
expand[134] = mask[134] | mask[117] | mask[118] | mask[119] | mask[133] | mask[135] | mask[149] | mask[150] | mask[151];
expand[135] = mask[135] | mask[118] | mask[119] | mask[120] | mask[134] | mask[136] | mask[150] | mask[151] | mask[152];
expand[136] = mask[136] | mask[119] | mask[120] | mask[121] | mask[135] | mask[137] | mask[151] | mask[152] | mask[153];
expand[137] = mask[137] | mask[120] | mask[121] | mask[122] | mask[136] | mask[138] | mask[152] | mask[153] | mask[154];
expand[138] = mask[138] | mask[121] | mask[122] | mask[123] | mask[137] | mask[139] | mask[153] | mask[154] | mask[155];
expand[139] = mask[139] | mask[122] | mask[123] | mask[124] | mask[138] | mask[140] | mask[154] | mask[155] | mask[156];
expand[140] = mask[140] | mask[123] | mask[124] | mask[125] | mask[139] | mask[141] | mask[155] | mask[156] | mask[157];
expand[141] = mask[141] | mask[124] | mask[125] | mask[126] | mask[140] | mask[142] | mask[156] | mask[157] | mask[158];
expand[142] = mask[142] | mask[125] | mask[126] | mask[127] | mask[141] | mask[143] | mask[157] | mask[158] | mask[159];
expand[143] = mask[143] | mask[126] | mask[127] | mask[142] | mask[158] | mask[159];
expand[144] = mask[144] | mask[128] | mask[129] | mask[145] | mask[160] | mask[161];
expand[145] = mask[145] | mask[128] | mask[129] | mask[130] | mask[144] | mask[146] | mask[160] | mask[161] | mask[162];
expand[146] = mask[146] | mask[129] | mask[130] | mask[131] | mask[145] | mask[147] | mask[161] | mask[162] | mask[163];
expand[147] = mask[147] | mask[130] | mask[131] | mask[132] | mask[146] | mask[148] | mask[162] | mask[163] | mask[164];
expand[148] = mask[148] | mask[131] | mask[132] | mask[133] | mask[147] | mask[149] | mask[163] | mask[164] | mask[165];
expand[149] = mask[149] | mask[132] | mask[133] | mask[134] | mask[148] | mask[150] | mask[164] | mask[165] | mask[166];
expand[150] = mask[150] | mask[133] | mask[134] | mask[135] | mask[149] | mask[151] | mask[165] | mask[166] | mask[167];
expand[151] = mask[151] | mask[134] | mask[135] | mask[136] | mask[150] | mask[152] | mask[166] | mask[167] | mask[168];
expand[152] = mask[152] | mask[135] | mask[136] | mask[137] | mask[151] | mask[153] | mask[167] | mask[168] | mask[169];
expand[153] = mask[153] | mask[136] | mask[137] | mask[138] | mask[152] | mask[154] | mask[168] | mask[169] | mask[170];
expand[154] = mask[154] | mask[137] | mask[138] | mask[139] | mask[153] | mask[155] | mask[169] | mask[170] | mask[171];
expand[155] = mask[155] | mask[138] | mask[139] | mask[140] | mask[154] | mask[156] | mask[170] | mask[171] | mask[172];
expand[156] = mask[156] | mask[139] | mask[140] | mask[141] | mask[155] | mask[157] | mask[171] | mask[172] | mask[173];
expand[157] = mask[157] | mask[140] | mask[141] | mask[142] | mask[156] | mask[158] | mask[172] | mask[173] | mask[174];
expand[158] = mask[158] | mask[141] | mask[142] | mask[143] | mask[157] | mask[159] | mask[173] | mask[174] | mask[175];
expand[159] = mask[159] | mask[142] | mask[143] | mask[158] | mask[174] | mask[175];
expand[160] = mask[160] | mask[144] | mask[145] | mask[161] | mask[176] | mask[177];
expand[161] = mask[161] | mask[144] | mask[145] | mask[146] | mask[160] | mask[162] | mask[176] | mask[177] | mask[178];
expand[162] = mask[162] | mask[145] | mask[146] | mask[147] | mask[161] | mask[163] | mask[177] | mask[178] | mask[179];
expand[163] = mask[163] | mask[146] | mask[147] | mask[148] | mask[162] | mask[164] | mask[178] | mask[179] | mask[180];
expand[164] = mask[164] | mask[147] | mask[148] | mask[149] | mask[163] | mask[165] | mask[179] | mask[180] | mask[181];
expand[165] = mask[165] | mask[148] | mask[149] | mask[150] | mask[164] | mask[166] | mask[180] | mask[181] | mask[182];
expand[166] = mask[166] | mask[149] | mask[150] | mask[151] | mask[165] | mask[167] | mask[181] | mask[182] | mask[183];
expand[167] = mask[167] | mask[150] | mask[151] | mask[152] | mask[166] | mask[168] | mask[182] | mask[183] | mask[184];
expand[168] = mask[168] | mask[151] | mask[152] | mask[153] | mask[167] | mask[169] | mask[183] | mask[184] | mask[185];
expand[169] = mask[169] | mask[152] | mask[153] | mask[154] | mask[168] | mask[170] | mask[184] | mask[185] | mask[186];
expand[170] = mask[170] | mask[153] | mask[154] | mask[155] | mask[169] | mask[171] | mask[185] | mask[186] | mask[187];
expand[171] = mask[171] | mask[154] | mask[155] | mask[156] | mask[170] | mask[172] | mask[186] | mask[187] | mask[188];
expand[172] = mask[172] | mask[155] | mask[156] | mask[157] | mask[171] | mask[173] | mask[187] | mask[188] | mask[189];
expand[173] = mask[173] | mask[156] | mask[157] | mask[158] | mask[172] | mask[174] | mask[188] | mask[189] | mask[190];
expand[174] = mask[174] | mask[157] | mask[158] | mask[159] | mask[173] | mask[175] | mask[189] | mask[190] | mask[191];
expand[175] = mask[175] | mask[158] | mask[159] | mask[174] | mask[190] | mask[191];
expand[176] = mask[176] | mask[160] | mask[161] | mask[177] | mask[192] | mask[193];
expand[177] = mask[177] | mask[160] | mask[161] | mask[162] | mask[176] | mask[178] | mask[192] | mask[193] | mask[194];
expand[178] = mask[178] | mask[161] | mask[162] | mask[163] | mask[177] | mask[179] | mask[193] | mask[194] | mask[195];
expand[179] = mask[179] | mask[162] | mask[163] | mask[164] | mask[178] | mask[180] | mask[194] | mask[195] | mask[196];
expand[180] = mask[180] | mask[163] | mask[164] | mask[165] | mask[179] | mask[181] | mask[195] | mask[196] | mask[197];
expand[181] = mask[181] | mask[164] | mask[165] | mask[166] | mask[180] | mask[182] | mask[196] | mask[197] | mask[198];
expand[182] = mask[182] | mask[165] | mask[166] | mask[167] | mask[181] | mask[183] | mask[197] | mask[198] | mask[199];
expand[183] = mask[183] | mask[166] | mask[167] | mask[168] | mask[182] | mask[184] | mask[198] | mask[199] | mask[200];
expand[184] = mask[184] | mask[167] | mask[168] | mask[169] | mask[183] | mask[185] | mask[199] | mask[200] | mask[201];
expand[185] = mask[185] | mask[168] | mask[169] | mask[170] | mask[184] | mask[186] | mask[200] | mask[201] | mask[202];
expand[186] = mask[186] | mask[169] | mask[170] | mask[171] | mask[185] | mask[187] | mask[201] | mask[202] | mask[203];
expand[187] = mask[187] | mask[170] | mask[171] | mask[172] | mask[186] | mask[188] | mask[202] | mask[203] | mask[204];
expand[188] = mask[188] | mask[171] | mask[172] | mask[173] | mask[187] | mask[189] | mask[203] | mask[204] | mask[205];
expand[189] = mask[189] | mask[172] | mask[173] | mask[174] | mask[188] | mask[190] | mask[204] | mask[205] | mask[206];
expand[190] = mask[190] | mask[173] | mask[174] | mask[175] | mask[189] | mask[191] | mask[205] | mask[206] | mask[207];
expand[191] = mask[191] | mask[174] | mask[175] | mask[190] | mask[206] | mask[207];
expand[192] = mask[192] | mask[176] | mask[177] | mask[193] | mask[208] | mask[209];
expand[193] = mask[193] | mask[176] | mask[177] | mask[178] | mask[192] | mask[194] | mask[208] | mask[209] | mask[210];
expand[194] = mask[194] | mask[177] | mask[178] | mask[179] | mask[193] | mask[195] | mask[209] | mask[210] | mask[211];
expand[195] = mask[195] | mask[178] | mask[179] | mask[180] | mask[194] | mask[196] | mask[210] | mask[211] | mask[212];
expand[196] = mask[196] | mask[179] | mask[180] | mask[181] | mask[195] | mask[197] | mask[211] | mask[212] | mask[213];
expand[197] = mask[197] | mask[180] | mask[181] | mask[182] | mask[196] | mask[198] | mask[212] | mask[213] | mask[214];
expand[198] = mask[198] | mask[181] | mask[182] | mask[183] | mask[197] | mask[199] | mask[213] | mask[214] | mask[215];
expand[199] = mask[199] | mask[182] | mask[183] | mask[184] | mask[198] | mask[200] | mask[214] | mask[215] | mask[216];
expand[200] = mask[200] | mask[183] | mask[184] | mask[185] | mask[199] | mask[201] | mask[215] | mask[216] | mask[217];
expand[201] = mask[201] | mask[184] | mask[185] | mask[186] | mask[200] | mask[202] | mask[216] | mask[217] | mask[218];
expand[202] = mask[202] | mask[185] | mask[186] | mask[187] | mask[201] | mask[203] | mask[217] | mask[218] | mask[219];
expand[203] = mask[203] | mask[186] | mask[187] | mask[188] | mask[202] | mask[204] | mask[218] | mask[219] | mask[220];
expand[204] = mask[204] | mask[187] | mask[188] | mask[189] | mask[203] | mask[205] | mask[219] | mask[220] | mask[221];
expand[205] = mask[205] | mask[188] | mask[189] | mask[190] | mask[204] | mask[206] | mask[220] | mask[221] | mask[222];
expand[206] = mask[206] | mask[189] | mask[190] | mask[191] | mask[205] | mask[207] | mask[221] | mask[222] | mask[223];
expand[207] = mask[207] | mask[190] | mask[191] | mask[206] | mask[222] | mask[223];
expand[208] = mask[208] | mask[192] | mask[193] | mask[209] | mask[224] | mask[225];
expand[209] = mask[209] | mask[192] | mask[193] | mask[194] | mask[208] | mask[210] | mask[224] | mask[225] | mask[226];
expand[210] = mask[210] | mask[193] | mask[194] | mask[195] | mask[209] | mask[211] | mask[225] | mask[226] | mask[227];
expand[211] = mask[211] | mask[194] | mask[195] | mask[196] | mask[210] | mask[212] | mask[226] | mask[227] | mask[228];
expand[212] = mask[212] | mask[195] | mask[196] | mask[197] | mask[211] | mask[213] | mask[227] | mask[228] | mask[229];
expand[213] = mask[213] | mask[196] | mask[197] | mask[198] | mask[212] | mask[214] | mask[228] | mask[229] | mask[230];
expand[214] = mask[214] | mask[197] | mask[198] | mask[199] | mask[213] | mask[215] | mask[229] | mask[230] | mask[231];
expand[215] = mask[215] | mask[198] | mask[199] | mask[200] | mask[214] | mask[216] | mask[230] | mask[231] | mask[232];
expand[216] = mask[216] | mask[199] | mask[200] | mask[201] | mask[215] | mask[217] | mask[231] | mask[232] | mask[233];
expand[217] = mask[217] | mask[200] | mask[201] | mask[202] | mask[216] | mask[218] | mask[232] | mask[233] | mask[234];
expand[218] = mask[218] | mask[201] | mask[202] | mask[203] | mask[217] | mask[219] | mask[233] | mask[234] | mask[235];
expand[219] = mask[219] | mask[202] | mask[203] | mask[204] | mask[218] | mask[220] | mask[234] | mask[235] | mask[236];
expand[220] = mask[220] | mask[203] | mask[204] | mask[205] | mask[219] | mask[221] | mask[235] | mask[236] | mask[237];
expand[221] = mask[221] | mask[204] | mask[205] | mask[206] | mask[220] | mask[222] | mask[236] | mask[237] | mask[238];
expand[222] = mask[222] | mask[205] | mask[206] | mask[207] | mask[221] | mask[223] | mask[237] | mask[238] | mask[239];
expand[223] = mask[223] | mask[206] | mask[207] | mask[222] | mask[238] | mask[239];
expand[224] = mask[224] | mask[208] | mask[209] | mask[225] | mask[240] | mask[241];
expand[225] = mask[225] | mask[208] | mask[209] | mask[210] | mask[224] | mask[226] | mask[240] | mask[241] | mask[242];
expand[226] = mask[226] | mask[209] | mask[210] | mask[211] | mask[225] | mask[227] | mask[241] | mask[242] | mask[243];
expand[227] = mask[227] | mask[210] | mask[211] | mask[212] | mask[226] | mask[228] | mask[242] | mask[243] | mask[244];
expand[228] = mask[228] | mask[211] | mask[212] | mask[213] | mask[227] | mask[229] | mask[243] | mask[244] | mask[245];
expand[229] = mask[229] | mask[212] | mask[213] | mask[214] | mask[228] | mask[230] | mask[244] | mask[245] | mask[246];
expand[230] = mask[230] | mask[213] | mask[214] | mask[215] | mask[229] | mask[231] | mask[245] | mask[246] | mask[247];
expand[231] = mask[231] | mask[214] | mask[215] | mask[216] | mask[230] | mask[232] | mask[246] | mask[247] | mask[248];
expand[232] = mask[232] | mask[215] | mask[216] | mask[217] | mask[231] | mask[233] | mask[247] | mask[248] | mask[249];
expand[233] = mask[233] | mask[216] | mask[217] | mask[218] | mask[232] | mask[234] | mask[248] | mask[249] | mask[250];
expand[234] = mask[234] | mask[217] | mask[218] | mask[219] | mask[233] | mask[235] | mask[249] | mask[250] | mask[251];
expand[235] = mask[235] | mask[218] | mask[219] | mask[220] | mask[234] | mask[236] | mask[250] | mask[251] | mask[252];
expand[236] = mask[236] | mask[219] | mask[220] | mask[221] | mask[235] | mask[237] | mask[251] | mask[252] | mask[253];
expand[237] = mask[237] | mask[220] | mask[221] | mask[222] | mask[236] | mask[238] | mask[252] | mask[253] | mask[254];
expand[238] = mask[238] | mask[221] | mask[222] | mask[223] | mask[237] | mask[239] | mask[253] | mask[254] | mask[255];
expand[239] = mask[239] | mask[222] | mask[223] | mask[238] | mask[254] | mask[255];
expand[240] = mask[240] | mask[224] | mask[225] | mask[241] | mask[256] | mask[257];
expand[241] = mask[241] | mask[224] | mask[225] | mask[226] | mask[240] | mask[242] | mask[256] | mask[257] | mask[258];
expand[242] = mask[242] | mask[225] | mask[226] | mask[227] | mask[241] | mask[243] | mask[257] | mask[258] | mask[259];
expand[243] = mask[243] | mask[226] | mask[227] | mask[228] | mask[242] | mask[244] | mask[258] | mask[259] | mask[260];
expand[244] = mask[244] | mask[227] | mask[228] | mask[229] | mask[243] | mask[245] | mask[259] | mask[260] | mask[261];
expand[245] = mask[245] | mask[228] | mask[229] | mask[230] | mask[244] | mask[246] | mask[260] | mask[261] | mask[262];
expand[246] = mask[246] | mask[229] | mask[230] | mask[231] | mask[245] | mask[247] | mask[261] | mask[262] | mask[263];
expand[247] = mask[247] | mask[230] | mask[231] | mask[232] | mask[246] | mask[248] | mask[262] | mask[263] | mask[264];
expand[248] = mask[248] | mask[231] | mask[232] | mask[233] | mask[247] | mask[249] | mask[263] | mask[264] | mask[265];
expand[249] = mask[249] | mask[232] | mask[233] | mask[234] | mask[248] | mask[250] | mask[264] | mask[265] | mask[266];
expand[250] = mask[250] | mask[233] | mask[234] | mask[235] | mask[249] | mask[251] | mask[265] | mask[266] | mask[267];
expand[251] = mask[251] | mask[234] | mask[235] | mask[236] | mask[250] | mask[252] | mask[266] | mask[267] | mask[268];
expand[252] = mask[252] | mask[235] | mask[236] | mask[237] | mask[251] | mask[253] | mask[267] | mask[268] | mask[269];
expand[253] = mask[253] | mask[236] | mask[237] | mask[238] | mask[252] | mask[254] | mask[268] | mask[269] | mask[270];
expand[254] = mask[254] | mask[237] | mask[238] | mask[239] | mask[253] | mask[255] | mask[269] | mask[270] | mask[271];
expand[255] = mask[255] | mask[238] | mask[239] | mask[254] | mask[270] | mask[271];
expand[256] = mask[256] | mask[240] | mask[241] | mask[257] | mask[272] | mask[273];
expand[257] = mask[257] | mask[240] | mask[241] | mask[242] | mask[256] | mask[258] | mask[272] | mask[273] | mask[274];
expand[258] = mask[258] | mask[241] | mask[242] | mask[243] | mask[257] | mask[259] | mask[273] | mask[274] | mask[275];
expand[259] = mask[259] | mask[242] | mask[243] | mask[244] | mask[258] | mask[260] | mask[274] | mask[275] | mask[276];
expand[260] = mask[260] | mask[243] | mask[244] | mask[245] | mask[259] | mask[261] | mask[275] | mask[276] | mask[277];
expand[261] = mask[261] | mask[244] | mask[245] | mask[246] | mask[260] | mask[262] | mask[276] | mask[277] | mask[278];
expand[262] = mask[262] | mask[245] | mask[246] | mask[247] | mask[261] | mask[263] | mask[277] | mask[278] | mask[279];
expand[263] = mask[263] | mask[246] | mask[247] | mask[248] | mask[262] | mask[264] | mask[278] | mask[279] | mask[280];
expand[264] = mask[264] | mask[247] | mask[248] | mask[249] | mask[263] | mask[265] | mask[279] | mask[280] | mask[281];
expand[265] = mask[265] | mask[248] | mask[249] | mask[250] | mask[264] | mask[266] | mask[280] | mask[281] | mask[282];
expand[266] = mask[266] | mask[249] | mask[250] | mask[251] | mask[265] | mask[267] | mask[281] | mask[282] | mask[283];
expand[267] = mask[267] | mask[250] | mask[251] | mask[252] | mask[266] | mask[268] | mask[282] | mask[283] | mask[284];
expand[268] = mask[268] | mask[251] | mask[252] | mask[253] | mask[267] | mask[269] | mask[283] | mask[284] | mask[285];
expand[269] = mask[269] | mask[252] | mask[253] | mask[254] | mask[268] | mask[270] | mask[284] | mask[285] | mask[286];
expand[270] = mask[270] | mask[253] | mask[254] | mask[255] | mask[269] | mask[271] | mask[285] | mask[286] | mask[287];
expand[271] = mask[271] | mask[254] | mask[255] | mask[270] | mask[286] | mask[287];
expand[272] = mask[272] | mask[256] | mask[257] | mask[273] | mask[288] | mask[289];
expand[273] = mask[273] | mask[256] | mask[257] | mask[258] | mask[272] | mask[274] | mask[288] | mask[289] | mask[290];
expand[274] = mask[274] | mask[257] | mask[258] | mask[259] | mask[273] | mask[275] | mask[289] | mask[290] | mask[291];
expand[275] = mask[275] | mask[258] | mask[259] | mask[260] | mask[274] | mask[276] | mask[290] | mask[291] | mask[292];
expand[276] = mask[276] | mask[259] | mask[260] | mask[261] | mask[275] | mask[277] | mask[291] | mask[292] | mask[293];
expand[277] = mask[277] | mask[260] | mask[261] | mask[262] | mask[276] | mask[278] | mask[292] | mask[293] | mask[294];
expand[278] = mask[278] | mask[261] | mask[262] | mask[263] | mask[277] | mask[279] | mask[293] | mask[294] | mask[295];
expand[279] = mask[279] | mask[262] | mask[263] | mask[264] | mask[278] | mask[280] | mask[294] | mask[295] | mask[296];
expand[280] = mask[280] | mask[263] | mask[264] | mask[265] | mask[279] | mask[281] | mask[295] | mask[296] | mask[297];
expand[281] = mask[281] | mask[264] | mask[265] | mask[266] | mask[280] | mask[282] | mask[296] | mask[297] | mask[298];
expand[282] = mask[282] | mask[265] | mask[266] | mask[267] | mask[281] | mask[283] | mask[297] | mask[298] | mask[299];
expand[283] = mask[283] | mask[266] | mask[267] | mask[268] | mask[282] | mask[284] | mask[298] | mask[299] | mask[300];
expand[284] = mask[284] | mask[267] | mask[268] | mask[269] | mask[283] | mask[285] | mask[299] | mask[300] | mask[301];
expand[285] = mask[285] | mask[268] | mask[269] | mask[270] | mask[284] | mask[286] | mask[300] | mask[301] | mask[302];
expand[286] = mask[286] | mask[269] | mask[270] | mask[271] | mask[285] | mask[287] | mask[301] | mask[302] | mask[303];
expand[287] = mask[287] | mask[270] | mask[271] | mask[286] | mask[302] | mask[303];
expand[288] = mask[288] | mask[272] | mask[273] | mask[289] | mask[304] | mask[305];
expand[289] = mask[289] | mask[272] | mask[273] | mask[274] | mask[288] | mask[290] | mask[304] | mask[305] | mask[306];
expand[290] = mask[290] | mask[273] | mask[274] | mask[275] | mask[289] | mask[291] | mask[305] | mask[306] | mask[307];
expand[291] = mask[291] | mask[274] | mask[275] | mask[276] | mask[290] | mask[292] | mask[306] | mask[307] | mask[308];
expand[292] = mask[292] | mask[275] | mask[276] | mask[277] | mask[291] | mask[293] | mask[307] | mask[308] | mask[309];
expand[293] = mask[293] | mask[276] | mask[277] | mask[278] | mask[292] | mask[294] | mask[308] | mask[309] | mask[310];
expand[294] = mask[294] | mask[277] | mask[278] | mask[279] | mask[293] | mask[295] | mask[309] | mask[310] | mask[311];
expand[295] = mask[295] | mask[278] | mask[279] | mask[280] | mask[294] | mask[296] | mask[310] | mask[311] | mask[312];
expand[296] = mask[296] | mask[279] | mask[280] | mask[281] | mask[295] | mask[297] | mask[311] | mask[312] | mask[313];
expand[297] = mask[297] | mask[280] | mask[281] | mask[282] | mask[296] | mask[298] | mask[312] | mask[313] | mask[314];
expand[298] = mask[298] | mask[281] | mask[282] | mask[283] | mask[297] | mask[299] | mask[313] | mask[314] | mask[315];
expand[299] = mask[299] | mask[282] | mask[283] | mask[284] | mask[298] | mask[300] | mask[314] | mask[315] | mask[316];
expand[300] = mask[300] | mask[283] | mask[284] | mask[285] | mask[299] | mask[301] | mask[315] | mask[316] | mask[317];
expand[301] = mask[301] | mask[284] | mask[285] | mask[286] | mask[300] | mask[302] | mask[316] | mask[317] | mask[318];
expand[302] = mask[302] | mask[285] | mask[286] | mask[287] | mask[301] | mask[303] | mask[317] | mask[318] | mask[319];
expand[303] = mask[303] | mask[286] | mask[287] | mask[302] | mask[318] | mask[319];
expand[304] = mask[304] | mask[288] | mask[289] | mask[305] | mask[320] | mask[321];
expand[305] = mask[305] | mask[288] | mask[289] | mask[290] | mask[304] | mask[306] | mask[320] | mask[321] | mask[322];
expand[306] = mask[306] | mask[289] | mask[290] | mask[291] | mask[305] | mask[307] | mask[321] | mask[322] | mask[323];
expand[307] = mask[307] | mask[290] | mask[291] | mask[292] | mask[306] | mask[308] | mask[322] | mask[323] | mask[324];
expand[308] = mask[308] | mask[291] | mask[292] | mask[293] | mask[307] | mask[309] | mask[323] | mask[324] | mask[325];
expand[309] = mask[309] | mask[292] | mask[293] | mask[294] | mask[308] | mask[310] | mask[324] | mask[325] | mask[326];
expand[310] = mask[310] | mask[293] | mask[294] | mask[295] | mask[309] | mask[311] | mask[325] | mask[326] | mask[327];
expand[311] = mask[311] | mask[294] | mask[295] | mask[296] | mask[310] | mask[312] | mask[326] | mask[327] | mask[328];
expand[312] = mask[312] | mask[295] | mask[296] | mask[297] | mask[311] | mask[313] | mask[327] | mask[328] | mask[329];
expand[313] = mask[313] | mask[296] | mask[297] | mask[298] | mask[312] | mask[314] | mask[328] | mask[329] | mask[330];
expand[314] = mask[314] | mask[297] | mask[298] | mask[299] | mask[313] | mask[315] | mask[329] | mask[330] | mask[331];
expand[315] = mask[315] | mask[298] | mask[299] | mask[300] | mask[314] | mask[316] | mask[330] | mask[331] | mask[332];
expand[316] = mask[316] | mask[299] | mask[300] | mask[301] | mask[315] | mask[317] | mask[331] | mask[332] | mask[333];
expand[317] = mask[317] | mask[300] | mask[301] | mask[302] | mask[316] | mask[318] | mask[332] | mask[333] | mask[334];
expand[318] = mask[318] | mask[301] | mask[302] | mask[303] | mask[317] | mask[319] | mask[333] | mask[334] | mask[335];
expand[319] = mask[319] | mask[302] | mask[303] | mask[318] | mask[334] | mask[335];
expand[320] = mask[320] | mask[304] | mask[305] | mask[321] | mask[336] | mask[337];
expand[321] = mask[321] | mask[304] | mask[305] | mask[306] | mask[320] | mask[322] | mask[336] | mask[337] | mask[338];
expand[322] = mask[322] | mask[305] | mask[306] | mask[307] | mask[321] | mask[323] | mask[337] | mask[338] | mask[339];
expand[323] = mask[323] | mask[306] | mask[307] | mask[308] | mask[322] | mask[324] | mask[338] | mask[339] | mask[340];
expand[324] = mask[324] | mask[307] | mask[308] | mask[309] | mask[323] | mask[325] | mask[339] | mask[340] | mask[341];
expand[325] = mask[325] | mask[308] | mask[309] | mask[310] | mask[324] | mask[326] | mask[340] | mask[341] | mask[342];
expand[326] = mask[326] | mask[309] | mask[310] | mask[311] | mask[325] | mask[327] | mask[341] | mask[342] | mask[343];
expand[327] = mask[327] | mask[310] | mask[311] | mask[312] | mask[326] | mask[328] | mask[342] | mask[343] | mask[344];
expand[328] = mask[328] | mask[311] | mask[312] | mask[313] | mask[327] | mask[329] | mask[343] | mask[344] | mask[345];
expand[329] = mask[329] | mask[312] | mask[313] | mask[314] | mask[328] | mask[330] | mask[344] | mask[345] | mask[346];
expand[330] = mask[330] | mask[313] | mask[314] | mask[315] | mask[329] | mask[331] | mask[345] | mask[346] | mask[347];
expand[331] = mask[331] | mask[314] | mask[315] | mask[316] | mask[330] | mask[332] | mask[346] | mask[347] | mask[348];
expand[332] = mask[332] | mask[315] | mask[316] | mask[317] | mask[331] | mask[333] | mask[347] | mask[348] | mask[349];
expand[333] = mask[333] | mask[316] | mask[317] | mask[318] | mask[332] | mask[334] | mask[348] | mask[349] | mask[350];
expand[334] = mask[334] | mask[317] | mask[318] | mask[319] | mask[333] | mask[335] | mask[349] | mask[350] | mask[351];
expand[335] = mask[335] | mask[318] | mask[319] | mask[334] | mask[350] | mask[351];
expand[336] = mask[336] | mask[320] | mask[321] | mask[337] | mask[352] | mask[353];
expand[337] = mask[337] | mask[320] | mask[321] | mask[322] | mask[336] | mask[338] | mask[352] | mask[353] | mask[354];
expand[338] = mask[338] | mask[321] | mask[322] | mask[323] | mask[337] | mask[339] | mask[353] | mask[354] | mask[355];
expand[339] = mask[339] | mask[322] | mask[323] | mask[324] | mask[338] | mask[340] | mask[354] | mask[355] | mask[356];
expand[340] = mask[340] | mask[323] | mask[324] | mask[325] | mask[339] | mask[341] | mask[355] | mask[356] | mask[357];
expand[341] = mask[341] | mask[324] | mask[325] | mask[326] | mask[340] | mask[342] | mask[356] | mask[357] | mask[358];
expand[342] = mask[342] | mask[325] | mask[326] | mask[327] | mask[341] | mask[343] | mask[357] | mask[358] | mask[359];
expand[343] = mask[343] | mask[326] | mask[327] | mask[328] | mask[342] | mask[344] | mask[358] | mask[359] | mask[360];
expand[344] = mask[344] | mask[327] | mask[328] | mask[329] | mask[343] | mask[345] | mask[359] | mask[360] | mask[361];
expand[345] = mask[345] | mask[328] | mask[329] | mask[330] | mask[344] | mask[346] | mask[360] | mask[361] | mask[362];
expand[346] = mask[346] | mask[329] | mask[330] | mask[331] | mask[345] | mask[347] | mask[361] | mask[362] | mask[363];
expand[347] = mask[347] | mask[330] | mask[331] | mask[332] | mask[346] | mask[348] | mask[362] | mask[363] | mask[364];
expand[348] = mask[348] | mask[331] | mask[332] | mask[333] | mask[347] | mask[349] | mask[363] | mask[364] | mask[365];
expand[349] = mask[349] | mask[332] | mask[333] | mask[334] | mask[348] | mask[350] | mask[364] | mask[365] | mask[366];
expand[350] = mask[350] | mask[333] | mask[334] | mask[335] | mask[349] | mask[351] | mask[365] | mask[366] | mask[367];
expand[351] = mask[351] | mask[334] | mask[335] | mask[350] | mask[366] | mask[367];
expand[352] = mask[352] | mask[336] | mask[337] | mask[353] | mask[368] | mask[369];
expand[353] = mask[353] | mask[336] | mask[337] | mask[338] | mask[352] | mask[354] | mask[368] | mask[369] | mask[370];
expand[354] = mask[354] | mask[337] | mask[338] | mask[339] | mask[353] | mask[355] | mask[369] | mask[370] | mask[371];
expand[355] = mask[355] | mask[338] | mask[339] | mask[340] | mask[354] | mask[356] | mask[370] | mask[371] | mask[372];
expand[356] = mask[356] | mask[339] | mask[340] | mask[341] | mask[355] | mask[357] | mask[371] | mask[372] | mask[373];
expand[357] = mask[357] | mask[340] | mask[341] | mask[342] | mask[356] | mask[358] | mask[372] | mask[373] | mask[374];
expand[358] = mask[358] | mask[341] | mask[342] | mask[343] | mask[357] | mask[359] | mask[373] | mask[374] | mask[375];
expand[359] = mask[359] | mask[342] | mask[343] | mask[344] | mask[358] | mask[360] | mask[374] | mask[375] | mask[376];
expand[360] = mask[360] | mask[343] | mask[344] | mask[345] | mask[359] | mask[361] | mask[375] | mask[376] | mask[377];
expand[361] = mask[361] | mask[344] | mask[345] | mask[346] | mask[360] | mask[362] | mask[376] | mask[377] | mask[378];
expand[362] = mask[362] | mask[345] | mask[346] | mask[347] | mask[361] | mask[363] | mask[377] | mask[378] | mask[379];
expand[363] = mask[363] | mask[346] | mask[347] | mask[348] | mask[362] | mask[364] | mask[378] | mask[379] | mask[380];
expand[364] = mask[364] | mask[347] | mask[348] | mask[349] | mask[363] | mask[365] | mask[379] | mask[380] | mask[381];
expand[365] = mask[365] | mask[348] | mask[349] | mask[350] | mask[364] | mask[366] | mask[380] | mask[381] | mask[382];
expand[366] = mask[366] | mask[349] | mask[350] | mask[351] | mask[365] | mask[367] | mask[381] | mask[382] | mask[383];
expand[367] = mask[367] | mask[350] | mask[351] | mask[366] | mask[382] | mask[383];
expand[368] = mask[368] | mask[352] | mask[353] | mask[369] | mask[384] | mask[385];
expand[369] = mask[369] | mask[352] | mask[353] | mask[354] | mask[368] | mask[370] | mask[384] | mask[385] | mask[386];
expand[370] = mask[370] | mask[353] | mask[354] | mask[355] | mask[369] | mask[371] | mask[385] | mask[386] | mask[387];
expand[371] = mask[371] | mask[354] | mask[355] | mask[356] | mask[370] | mask[372] | mask[386] | mask[387] | mask[388];
expand[372] = mask[372] | mask[355] | mask[356] | mask[357] | mask[371] | mask[373] | mask[387] | mask[388] | mask[389];
expand[373] = mask[373] | mask[356] | mask[357] | mask[358] | mask[372] | mask[374] | mask[388] | mask[389] | mask[390];
expand[374] = mask[374] | mask[357] | mask[358] | mask[359] | mask[373] | mask[375] | mask[389] | mask[390] | mask[391];
expand[375] = mask[375] | mask[358] | mask[359] | mask[360] | mask[374] | mask[376] | mask[390] | mask[391] | mask[392];
expand[376] = mask[376] | mask[359] | mask[360] | mask[361] | mask[375] | mask[377] | mask[391] | mask[392] | mask[393];
expand[377] = mask[377] | mask[360] | mask[361] | mask[362] | mask[376] | mask[378] | mask[392] | mask[393] | mask[394];
expand[378] = mask[378] | mask[361] | mask[362] | mask[363] | mask[377] | mask[379] | mask[393] | mask[394] | mask[395];
expand[379] = mask[379] | mask[362] | mask[363] | mask[364] | mask[378] | mask[380] | mask[394] | mask[395] | mask[396];
expand[380] = mask[380] | mask[363] | mask[364] | mask[365] | mask[379] | mask[381] | mask[395] | mask[396] | mask[397];
expand[381] = mask[381] | mask[364] | mask[365] | mask[366] | mask[380] | mask[382] | mask[396] | mask[397] | mask[398];
expand[382] = mask[382] | mask[365] | mask[366] | mask[367] | mask[381] | mask[383] | mask[397] | mask[398] | mask[399];
expand[383] = mask[383] | mask[366] | mask[367] | mask[382] | mask[398] | mask[399];
expand[384] = mask[384] | mask[368] | mask[369] | mask[385] | mask[400] | mask[401];
expand[385] = mask[385] | mask[368] | mask[369] | mask[370] | mask[384] | mask[386] | mask[400] | mask[401] | mask[402];
expand[386] = mask[386] | mask[369] | mask[370] | mask[371] | mask[385] | mask[387] | mask[401] | mask[402] | mask[403];
expand[387] = mask[387] | mask[370] | mask[371] | mask[372] | mask[386] | mask[388] | mask[402] | mask[403] | mask[404];
expand[388] = mask[388] | mask[371] | mask[372] | mask[373] | mask[387] | mask[389] | mask[403] | mask[404] | mask[405];
expand[389] = mask[389] | mask[372] | mask[373] | mask[374] | mask[388] | mask[390] | mask[404] | mask[405] | mask[406];
expand[390] = mask[390] | mask[373] | mask[374] | mask[375] | mask[389] | mask[391] | mask[405] | mask[406] | mask[407];
expand[391] = mask[391] | mask[374] | mask[375] | mask[376] | mask[390] | mask[392] | mask[406] | mask[407] | mask[408];
expand[392] = mask[392] | mask[375] | mask[376] | mask[377] | mask[391] | mask[393] | mask[407] | mask[408] | mask[409];
expand[393] = mask[393] | mask[376] | mask[377] | mask[378] | mask[392] | mask[394] | mask[408] | mask[409] | mask[410];
expand[394] = mask[394] | mask[377] | mask[378] | mask[379] | mask[393] | mask[395] | mask[409] | mask[410] | mask[411];
expand[395] = mask[395] | mask[378] | mask[379] | mask[380] | mask[394] | mask[396] | mask[410] | mask[411] | mask[412];
expand[396] = mask[396] | mask[379] | mask[380] | mask[381] | mask[395] | mask[397] | mask[411] | mask[412] | mask[413];
expand[397] = mask[397] | mask[380] | mask[381] | mask[382] | mask[396] | mask[398] | mask[412] | mask[413] | mask[414];
expand[398] = mask[398] | mask[381] | mask[382] | mask[383] | mask[397] | mask[399] | mask[413] | mask[414] | mask[415];
expand[399] = mask[399] | mask[382] | mask[383] | mask[398] | mask[414] | mask[415];
expand[400] = mask[400] | mask[384] | mask[385] | mask[401] | mask[416] | mask[417];
expand[401] = mask[401] | mask[384] | mask[385] | mask[386] | mask[400] | mask[402] | mask[416] | mask[417] | mask[418];
expand[402] = mask[402] | mask[385] | mask[386] | mask[387] | mask[401] | mask[403] | mask[417] | mask[418] | mask[419];
expand[403] = mask[403] | mask[386] | mask[387] | mask[388] | mask[402] | mask[404] | mask[418] | mask[419] | mask[420];
expand[404] = mask[404] | mask[387] | mask[388] | mask[389] | mask[403] | mask[405] | mask[419] | mask[420] | mask[421];
expand[405] = mask[405] | mask[388] | mask[389] | mask[390] | mask[404] | mask[406] | mask[420] | mask[421] | mask[422];
expand[406] = mask[406] | mask[389] | mask[390] | mask[391] | mask[405] | mask[407] | mask[421] | mask[422] | mask[423];
expand[407] = mask[407] | mask[390] | mask[391] | mask[392] | mask[406] | mask[408] | mask[422] | mask[423] | mask[424];
expand[408] = mask[408] | mask[391] | mask[392] | mask[393] | mask[407] | mask[409] | mask[423] | mask[424] | mask[425];
expand[409] = mask[409] | mask[392] | mask[393] | mask[394] | mask[408] | mask[410] | mask[424] | mask[425] | mask[426];
expand[410] = mask[410] | mask[393] | mask[394] | mask[395] | mask[409] | mask[411] | mask[425] | mask[426] | mask[427];
expand[411] = mask[411] | mask[394] | mask[395] | mask[396] | mask[410] | mask[412] | mask[426] | mask[427] | mask[428];
expand[412] = mask[412] | mask[395] | mask[396] | mask[397] | mask[411] | mask[413] | mask[427] | mask[428] | mask[429];
expand[413] = mask[413] | mask[396] | mask[397] | mask[398] | mask[412] | mask[414] | mask[428] | mask[429] | mask[430];
expand[414] = mask[414] | mask[397] | mask[398] | mask[399] | mask[413] | mask[415] | mask[429] | mask[430] | mask[431];
expand[415] = mask[415] | mask[398] | mask[399] | mask[414] | mask[430] | mask[431];
expand[416] = mask[416] | mask[400] | mask[401] | mask[417] | mask[432] | mask[433];
expand[417] = mask[417] | mask[400] | mask[401] | mask[402] | mask[416] | mask[418] | mask[432] | mask[433] | mask[434];
expand[418] = mask[418] | mask[401] | mask[402] | mask[403] | mask[417] | mask[419] | mask[433] | mask[434] | mask[435];
expand[419] = mask[419] | mask[402] | mask[403] | mask[404] | mask[418] | mask[420] | mask[434] | mask[435] | mask[436];
expand[420] = mask[420] | mask[403] | mask[404] | mask[405] | mask[419] | mask[421] | mask[435] | mask[436] | mask[437];
expand[421] = mask[421] | mask[404] | mask[405] | mask[406] | mask[420] | mask[422] | mask[436] | mask[437] | mask[438];
expand[422] = mask[422] | mask[405] | mask[406] | mask[407] | mask[421] | mask[423] | mask[437] | mask[438] | mask[439];
expand[423] = mask[423] | mask[406] | mask[407] | mask[408] | mask[422] | mask[424] | mask[438] | mask[439] | mask[440];
expand[424] = mask[424] | mask[407] | mask[408] | mask[409] | mask[423] | mask[425] | mask[439] | mask[440] | mask[441];
expand[425] = mask[425] | mask[408] | mask[409] | mask[410] | mask[424] | mask[426] | mask[440] | mask[441] | mask[442];
expand[426] = mask[426] | mask[409] | mask[410] | mask[411] | mask[425] | mask[427] | mask[441] | mask[442] | mask[443];
expand[427] = mask[427] | mask[410] | mask[411] | mask[412] | mask[426] | mask[428] | mask[442] | mask[443] | mask[444];
expand[428] = mask[428] | mask[411] | mask[412] | mask[413] | mask[427] | mask[429] | mask[443] | mask[444] | mask[445];
expand[429] = mask[429] | mask[412] | mask[413] | mask[414] | mask[428] | mask[430] | mask[444] | mask[445] | mask[446];
expand[430] = mask[430] | mask[413] | mask[414] | mask[415] | mask[429] | mask[431] | mask[445] | mask[446] | mask[447];
expand[431] = mask[431] | mask[414] | mask[415] | mask[430] | mask[446] | mask[447];
expand[432] = mask[432] | mask[416] | mask[417] | mask[433] | mask[448] | mask[449];
expand[433] = mask[433] | mask[416] | mask[417] | mask[418] | mask[432] | mask[434] | mask[448] | mask[449] | mask[450];
expand[434] = mask[434] | mask[417] | mask[418] | mask[419] | mask[433] | mask[435] | mask[449] | mask[450] | mask[451];
expand[435] = mask[435] | mask[418] | mask[419] | mask[420] | mask[434] | mask[436] | mask[450] | mask[451] | mask[452];
expand[436] = mask[436] | mask[419] | mask[420] | mask[421] | mask[435] | mask[437] | mask[451] | mask[452] | mask[453];
expand[437] = mask[437] | mask[420] | mask[421] | mask[422] | mask[436] | mask[438] | mask[452] | mask[453] | mask[454];
expand[438] = mask[438] | mask[421] | mask[422] | mask[423] | mask[437] | mask[439] | mask[453] | mask[454] | mask[455];
expand[439] = mask[439] | mask[422] | mask[423] | mask[424] | mask[438] | mask[440] | mask[454] | mask[455] | mask[456];
expand[440] = mask[440] | mask[423] | mask[424] | mask[425] | mask[439] | mask[441] | mask[455] | mask[456] | mask[457];
expand[441] = mask[441] | mask[424] | mask[425] | mask[426] | mask[440] | mask[442] | mask[456] | mask[457] | mask[458];
expand[442] = mask[442] | mask[425] | mask[426] | mask[427] | mask[441] | mask[443] | mask[457] | mask[458] | mask[459];
expand[443] = mask[443] | mask[426] | mask[427] | mask[428] | mask[442] | mask[444] | mask[458] | mask[459] | mask[460];
expand[444] = mask[444] | mask[427] | mask[428] | mask[429] | mask[443] | mask[445] | mask[459] | mask[460] | mask[461];
expand[445] = mask[445] | mask[428] | mask[429] | mask[430] | mask[444] | mask[446] | mask[460] | mask[461] | mask[462];
expand[446] = mask[446] | mask[429] | mask[430] | mask[431] | mask[445] | mask[447] | mask[461] | mask[462] | mask[463];
expand[447] = mask[447] | mask[430] | mask[431] | mask[446] | mask[462] | mask[463];
expand[448] = mask[448] | mask[432] | mask[433] | mask[449] | mask[464] | mask[465];
expand[449] = mask[449] | mask[432] | mask[433] | mask[434] | mask[448] | mask[450] | mask[464] | mask[465] | mask[466];
expand[450] = mask[450] | mask[433] | mask[434] | mask[435] | mask[449] | mask[451] | mask[465] | mask[466] | mask[467];
expand[451] = mask[451] | mask[434] | mask[435] | mask[436] | mask[450] | mask[452] | mask[466] | mask[467] | mask[468];
expand[452] = mask[452] | mask[435] | mask[436] | mask[437] | mask[451] | mask[453] | mask[467] | mask[468] | mask[469];
expand[453] = mask[453] | mask[436] | mask[437] | mask[438] | mask[452] | mask[454] | mask[468] | mask[469] | mask[470];
expand[454] = mask[454] | mask[437] | mask[438] | mask[439] | mask[453] | mask[455] | mask[469] | mask[470] | mask[471];
expand[455] = mask[455] | mask[438] | mask[439] | mask[440] | mask[454] | mask[456] | mask[470] | mask[471] | mask[472];
expand[456] = mask[456] | mask[439] | mask[440] | mask[441] | mask[455] | mask[457] | mask[471] | mask[472] | mask[473];
expand[457] = mask[457] | mask[440] | mask[441] | mask[442] | mask[456] | mask[458] | mask[472] | mask[473] | mask[474];
expand[458] = mask[458] | mask[441] | mask[442] | mask[443] | mask[457] | mask[459] | mask[473] | mask[474] | mask[475];
expand[459] = mask[459] | mask[442] | mask[443] | mask[444] | mask[458] | mask[460] | mask[474] | mask[475] | mask[476];
expand[460] = mask[460] | mask[443] | mask[444] | mask[445] | mask[459] | mask[461] | mask[475] | mask[476] | mask[477];
expand[461] = mask[461] | mask[444] | mask[445] | mask[446] | mask[460] | mask[462] | mask[476] | mask[477] | mask[478];
expand[462] = mask[462] | mask[445] | mask[446] | mask[447] | mask[461] | mask[463] | mask[477] | mask[478] | mask[479];
expand[463] = mask[463] | mask[446] | mask[447] | mask[462] | mask[478] | mask[479];
expand[464] = mask[464] | mask[448] | mask[449] | mask[465] | mask[480] | mask[481];
expand[465] = mask[465] | mask[448] | mask[449] | mask[450] | mask[464] | mask[466] | mask[480] | mask[481] | mask[482];
expand[466] = mask[466] | mask[449] | mask[450] | mask[451] | mask[465] | mask[467] | mask[481] | mask[482] | mask[483];
expand[467] = mask[467] | mask[450] | mask[451] | mask[452] | mask[466] | mask[468] | mask[482] | mask[483] | mask[484];
expand[468] = mask[468] | mask[451] | mask[452] | mask[453] | mask[467] | mask[469] | mask[483] | mask[484] | mask[485];
expand[469] = mask[469] | mask[452] | mask[453] | mask[454] | mask[468] | mask[470] | mask[484] | mask[485] | mask[486];
expand[470] = mask[470] | mask[453] | mask[454] | mask[455] | mask[469] | mask[471] | mask[485] | mask[486] | mask[487];
expand[471] = mask[471] | mask[454] | mask[455] | mask[456] | mask[470] | mask[472] | mask[486] | mask[487] | mask[488];
expand[472] = mask[472] | mask[455] | mask[456] | mask[457] | mask[471] | mask[473] | mask[487] | mask[488] | mask[489];
expand[473] = mask[473] | mask[456] | mask[457] | mask[458] | mask[472] | mask[474] | mask[488] | mask[489] | mask[490];
expand[474] = mask[474] | mask[457] | mask[458] | mask[459] | mask[473] | mask[475] | mask[489] | mask[490] | mask[491];
expand[475] = mask[475] | mask[458] | mask[459] | mask[460] | mask[474] | mask[476] | mask[490] | mask[491] | mask[492];
expand[476] = mask[476] | mask[459] | mask[460] | mask[461] | mask[475] | mask[477] | mask[491] | mask[492] | mask[493];
expand[477] = mask[477] | mask[460] | mask[461] | mask[462] | mask[476] | mask[478] | mask[492] | mask[493] | mask[494];
expand[478] = mask[478] | mask[461] | mask[462] | mask[463] | mask[477] | mask[479] | mask[493] | mask[494] | mask[495];
expand[479] = mask[479] | mask[462] | mask[463] | mask[478] | mask[494] | mask[495];
expand[480] = mask[480] | mask[464] | mask[465] | mask[481] | mask[496] | mask[497];
expand[481] = mask[481] | mask[464] | mask[465] | mask[466] | mask[480] | mask[482] | mask[496] | mask[497] | mask[498];
expand[482] = mask[482] | mask[465] | mask[466] | mask[467] | mask[481] | mask[483] | mask[497] | mask[498] | mask[499];
expand[483] = mask[483] | mask[466] | mask[467] | mask[468] | mask[482] | mask[484] | mask[498] | mask[499] | mask[500];
expand[484] = mask[484] | mask[467] | mask[468] | mask[469] | mask[483] | mask[485] | mask[499] | mask[500] | mask[501];
expand[485] = mask[485] | mask[468] | mask[469] | mask[470] | mask[484] | mask[486] | mask[500] | mask[501] | mask[502];
expand[486] = mask[486] | mask[469] | mask[470] | mask[471] | mask[485] | mask[487] | mask[501] | mask[502] | mask[503];
expand[487] = mask[487] | mask[470] | mask[471] | mask[472] | mask[486] | mask[488] | mask[502] | mask[503] | mask[504];
expand[488] = mask[488] | mask[471] | mask[472] | mask[473] | mask[487] | mask[489] | mask[503] | mask[504] | mask[505];
expand[489] = mask[489] | mask[472] | mask[473] | mask[474] | mask[488] | mask[490] | mask[504] | mask[505] | mask[506];
expand[490] = mask[490] | mask[473] | mask[474] | mask[475] | mask[489] | mask[491] | mask[505] | mask[506] | mask[507];
expand[491] = mask[491] | mask[474] | mask[475] | mask[476] | mask[490] | mask[492] | mask[506] | mask[507] | mask[508];
expand[492] = mask[492] | mask[475] | mask[476] | mask[477] | mask[491] | mask[493] | mask[507] | mask[508] | mask[509];
expand[493] = mask[493] | mask[476] | mask[477] | mask[478] | mask[492] | mask[494] | mask[508] | mask[509] | mask[510];
expand[494] = mask[494] | mask[477] | mask[478] | mask[479] | mask[493] | mask[495] | mask[509] | mask[510] | mask[511];
expand[495] = mask[495] | mask[478] | mask[479] | mask[494] | mask[510] | mask[511];
expand[496] = mask[496] | mask[480] | mask[481] | mask[497];
expand[497] = mask[497] | mask[480] | mask[481] | mask[482] | mask[496] | mask[498];
expand[498] = mask[498] | mask[481] | mask[482] | mask[483] | mask[497] | mask[499];
expand[499] = mask[499] | mask[482] | mask[483] | mask[484] | mask[498] | mask[500];
expand[500] = mask[500] | mask[483] | mask[484] | mask[485] | mask[499] | mask[501];
expand[501] = mask[501] | mask[484] | mask[485] | mask[486] | mask[500] | mask[502];
expand[502] = mask[502] | mask[485] | mask[486] | mask[487] | mask[501] | mask[503];
expand[503] = mask[503] | mask[486] | mask[487] | mask[488] | mask[502] | mask[504];
expand[504] = mask[504] | mask[487] | mask[488] | mask[489] | mask[503] | mask[505];
expand[505] = mask[505] | mask[488] | mask[489] | mask[490] | mask[504] | mask[506];
expand[506] = mask[506] | mask[489] | mask[490] | mask[491] | mask[505] | mask[507];
expand[507] = mask[507] | mask[490] | mask[491] | mask[492] | mask[506] | mask[508];
expand[508] = mask[508] | mask[491] | mask[492] | mask[493] | mask[507] | mask[509];
expand[509] = mask[509] | mask[492] | mask[493] | mask[494] | mask[508] | mask[510];
expand[510] = mask[510] | mask[493] | mask[494] | mask[495] | mask[509] | mask[511];
expand[511] = mask[511] | mask[494] | mask[495] | mask[510];
end
endfunction
