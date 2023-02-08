/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : R-2020.09
// Date      : Tue Mar 16 06:13:46 2021
/////////////////////////////////////////////////////////////


module DT_DW01_inc_0 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;

  wire   [7:2] carry;

  ADDHXL U1_1_6 ( .A(A[6]), .B(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  ADDHXL U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  ADDHXL U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHXL U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHXL U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHXL U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  XOR2X1 U1 ( .A(carry[7]), .B(A[7]), .Y(SUM[7]) );
  CLKINVX1 U2 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module DT_DW01_inc_1 ( A, SUM );
  input [9:0] A;
  output [9:0] SUM;

  wire   [9:2] carry;

  ADDHXL U1_1_8 ( .A(A[8]), .B(carry[8]), .CO(carry[9]), .S(SUM[8]) );
  ADDHXL U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHXL U1_1_7 ( .A(A[7]), .B(carry[7]), .CO(carry[8]), .S(SUM[7]) );
  ADDHXL U1_1_6 ( .A(A[6]), .B(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  ADDHXL U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHXL U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHXL U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHXL U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  INVXL U1 ( .A(A[0]), .Y(SUM[0]) );
  XOR2XL U2 ( .A(carry[9]), .B(A[9]), .Y(SUM[9]) );
endmodule


module DT_DW01_dec_0 ( A, SUM );
  input [13:0] A;
  output [13:0] SUM;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15;

  CLKINVX1 U1 ( .A(n15), .Y(n1) );
  OR2X1 U2 ( .A(A[1]), .B(A[0]), .Y(n12) );
  CLKINVX1 U3 ( .A(A[10]), .Y(n3) );
  CLKINVX1 U4 ( .A(A[11]), .Y(n2) );
  AO21X1 U5 ( .A0(n4), .A1(A[9]), .B0(n5), .Y(SUM[9]) );
  OAI2BB1X1 U6 ( .A0N(n6), .A1N(A[8]), .B0(n4), .Y(SUM[8]) );
  OAI2BB1X1 U7 ( .A0N(n7), .A1N(A[7]), .B0(n6), .Y(SUM[7]) );
  OAI2BB1X1 U8 ( .A0N(n8), .A1N(A[6]), .B0(n7), .Y(SUM[6]) );
  OAI2BB1X1 U9 ( .A0N(n9), .A1N(A[5]), .B0(n8), .Y(SUM[5]) );
  OAI2BB1X1 U10 ( .A0N(n10), .A1N(A[4]), .B0(n9), .Y(SUM[4]) );
  OAI2BB1X1 U11 ( .A0N(n11), .A1N(A[3]), .B0(n10), .Y(SUM[3]) );
  OAI2BB1X1 U12 ( .A0N(n12), .A1N(A[2]), .B0(n11), .Y(SUM[2]) );
  OAI2BB1X1 U13 ( .A0N(A[0]), .A1N(A[1]), .B0(n12), .Y(SUM[1]) );
  XOR2X1 U14 ( .A(A[13]), .B(n13), .Y(SUM[13]) );
  NOR2X1 U15 ( .A(A[12]), .B(n14), .Y(n13) );
  XNOR2X1 U16 ( .A(A[12]), .B(n14), .Y(SUM[12]) );
  OAI21XL U17 ( .A0(n1), .A1(n2), .B0(n14), .Y(SUM[11]) );
  NAND2X1 U18 ( .A(n1), .B(n2), .Y(n14) );
  OAI21XL U19 ( .A0(n5), .A1(n3), .B0(n15), .Y(SUM[10]) );
  NAND2X1 U20 ( .A(n5), .B(n3), .Y(n15) );
  NOR2X1 U21 ( .A(n4), .B(A[9]), .Y(n5) );
  OR2X1 U22 ( .A(n6), .B(A[8]), .Y(n4) );
  OR2X1 U23 ( .A(n7), .B(A[7]), .Y(n6) );
  OR2X1 U24 ( .A(n8), .B(A[6]), .Y(n7) );
  OR2X1 U25 ( .A(n9), .B(A[5]), .Y(n8) );
  OR2X1 U26 ( .A(n10), .B(A[4]), .Y(n9) );
  OR2X1 U27 ( .A(n11), .B(A[3]), .Y(n10) );
  OR2X1 U28 ( .A(n12), .B(A[2]), .Y(n11) );
  CLKINVX1 U29 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module DT_DW01_inc_2 ( A, SUM );
  input [13:0] A;
  output [13:0] SUM;

  wire   [13:2] carry;

  ADDHXL U1_1_12 ( .A(A[12]), .B(carry[12]), .CO(carry[13]), .S(SUM[12]) );
  ADDHXL U1_1_10 ( .A(A[10]), .B(carry[10]), .CO(carry[11]), .S(SUM[10]) );
  ADDHXL U1_1_11 ( .A(A[11]), .B(carry[11]), .CO(carry[12]), .S(SUM[11]) );
  ADDHXL U1_1_6 ( .A(A[6]), .B(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  ADDHXL U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHXL U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHXL U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHXL U1_1_9 ( .A(A[9]), .B(carry[9]), .CO(carry[10]), .S(SUM[9]) );
  ADDHXL U1_1_8 ( .A(A[8]), .B(carry[8]), .CO(carry[9]), .S(SUM[8]) );
  ADDHXL U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHXL U1_1_7 ( .A(A[7]), .B(carry[7]), .CO(carry[8]), .S(SUM[7]) );
  ADDHXL U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  XOR2X1 U1 ( .A(carry[13]), .B(A[13]), .Y(SUM[13]) );
  CLKINVX1 U2 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module DT_DW01_inc_3 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;

  wire   [7:2] carry;

  ADDHXL U1_1_6 ( .A(A[6]), .B(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  ADDHX1 U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  ADDHX1 U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHX1 U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHX1 U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHX1 U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  XOR2X1 U1 ( .A(carry[7]), .B(A[7]), .Y(SUM[7]) );
  CLKINVX1 U2 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module DT_DW01_inc_4 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;
  wire   n1;
  wire   [7:2] carry;

  ADDHX1 U1_1_6 ( .A(A[6]), .B(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  ADDHX1 U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHX2 U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  CMPR22X2 U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHX4 U1_1_2 ( .A(A[2]), .B(n1), .CO(carry[3]), .S(SUM[2]) );
  XOR2X1 U1 ( .A(A[1]), .B(A[0]), .Y(SUM[1]) );
  AND2X4 U2 ( .A(A[1]), .B(A[0]), .Y(n1) );
  XOR2X1 U3 ( .A(carry[7]), .B(A[7]), .Y(SUM[7]) );
  CLKINVX1 U4 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module DT_DW01_inc_5 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;

  wire   [7:2] carry;

  ADDHXL U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHX1 U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHXL U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHX1 U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  ADDHX1 U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHX1 U1_1_6 ( .A(A[6]), .B(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  XOR2X1 U1 ( .A(carry[7]), .B(A[7]), .Y(SUM[7]) );
  INVXL U2 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module DT_DW01_inc_6 ( A, SUM );
  input [6:0] A;
  output [6:0] SUM;

  wire   [6:2] carry;

  ADDHXL U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHXL U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHXL U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  ADDHXL U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHXL U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  XOR2X1 U1 ( .A(carry[6]), .B(A[6]), .Y(SUM[6]) );
  CLKINVX1 U2 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module DT_DW01_inc_7 ( A, SUM );
  input [6:0] A;
  output [6:0] SUM;

  wire   [6:2] carry;

  ADDHXL U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHXL U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHXL U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHXL U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHXL U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  XOR2X1 U1 ( .A(carry[6]), .B(A[6]), .Y(SUM[6]) );
  CLKINVX1 U2 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module DT ( clk, reset, done, sti_rd, sti_addr, sti_di, res_wr, res_rd, 
        res_addr, res_do, res_di, fw_finish );
  output [9:0] sti_addr;
  input [15:0] sti_di;
  output [13:0] res_addr;
  output [7:0] res_do;
  input [7:0] res_di;
  input clk, reset;
  output done, sti_rd, res_wr, res_rd, fw_finish;
  wire   N73, N74, N75, N76, N78, N79, n768, n769, n770, n771, n772, n773,
         n774, n775, n776, n777, n778, n779, n780, n781, n782, n783, n784,
         n785, n786, n787, n788, n789, n790, n791, n792, n793, n794, N142,
         N144, N145, N146, N147, N148, N149, N150, N151, N152, N153, N154,
         N155, N187, N189, N190, N191, N192, N193, N194, N195, N196, N224,
         N225, N226, N227, N228, N229, N230, N231, N232, N233, N239, N240,
         N241, N242, N243, N244, N245, N246, N250, N251, N252, N253, N254,
         N255, N256, N257, N290, N295, N323, N324, N325, N326, N327, N328,
         N329, N330, N385, N386, N387, N388, N389, N390, N391, N392, N464,
         N465, N466, N467, N468, N469, N470, N471, N472, N473, N474, N475,
         N476, N564, N565, N566, N567, N568, N569, N570, N571, N572, N573,
         N574, N575, N576, N606, N607, N608, N609, N610, N611, N612, N613,
         N614, N615, N616, N617, N618, N664, N665, N666, N667, N668, N669,
         N670, N671, N672, N673, N674, N675, N676, N677, N801, N803, N804,
         N805, N806, N807, N808, N809, N810, N811, N812, N813, N814, N854,
         N867, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30,
         n31, n288, n289, n290, n291, n292, n293, n294, n295, n296, n297, n304,
         n309, n310, n311, n312, n313, n314, n315, n316, n317, n318, n319,
         n320, n321, n322, n323, n324, n325, n326, n327, n328, n329, n330,
         n331, n332, n333, n334, n335, n336, n337, n338, n339, n340, n341,
         N1194, N1193, N1192, N1191, N1190, N1189, N1188, \add_335/carry[2] ,
         \add_335/carry[3] , \add_335/carry[4] , \add_335/carry[5] ,
         \add_335/carry[6] , \add_335/carry[7] , \add_335/carry[8] ,
         \add_335/carry[9] , \add_335/carry[10] , \add_335/carry[11] ,
         \add_335/carry[12] , \add_335/carry[13] , \r496/carry[2] ,
         \r496/carry[3] , \r496/carry[4] , \r496/carry[5] , \r496/carry[6] ,
         \r496/carry[7] , \r496/carry[8] , \r496/carry[9] , \r496/carry[10] ,
         \r496/carry[11] , \r496/carry[12] , \r496/carry[13] , \r495/carry[2] ,
         \r495/carry[3] , \r495/carry[4] , \r495/carry[5] , \r495/carry[6] ,
         \r495/carry[7] , \r495/carry[8] , \r495/carry[9] , \r495/carry[10] ,
         \r495/carry[11] , \r495/carry[12] , \r495/carry[13] , n342, n343,
         n344, n345, n346, n347, n348, n349, n350, n351, n352, n354, n355,
         n357, n358, n360, n361, n363, n365, n366, n368, n369, n371, n372,
         n374, n376, n377, n379, n381, n386, n388, n390, n393, n396, n397,
         n398, n399, n400, n401, n402, n403, n404, n405, n406, n407, n408,
         n409, n410, n411, n412, n427, n429, n430, n431, n432, n433, n434,
         n435, n436, n437, n438, n439, n440, n441, n442, n443, n444, n445,
         n446, n447, n448, n449, n450, n451, n452, n453, n454, n455, n456,
         n457, n458, n459, n460, n461, n462, n463, n464, n465, n466, n467,
         n468, n469, n470, n471, n472, n473, n474, n475, n476, n477, n478,
         n479, n480, n481, n482, n483, n484, n485, n486, n487, n488, n489,
         n490, n491, n492, n493, n494, n495, n496, n497, n498, n499, n500,
         n501, n502, n503, n504, n505, n506, n507, n508, n509, n510, n511,
         n512, n513, n514, n515, n516, n517, n518, n519, n520, n521, n522,
         n523, n524, n525, n526, n527, n528, n529, n530, n531, n532, n533,
         n534, n535, n536, n537, n538, n539, n540, n541, n542, n543, n544,
         n545, n546, n547, n548, n549, n550, n551, n552, n553, n554, n555,
         n556, n557, n558, n559, n560, n561, n562, n563, n564, n565, n566,
         n567, n568, n569, n570, n571, n572, n573, n574, n575, n576, n577,
         n578, n579, n580, n581, n582, n583, n584, n585, n586, n587, n588,
         n589, n590, n591, n592, n593, n594, n595, n596, n597, n598, n599,
         n600, n601, n602, n603, n604, n605, n606, n607, n608, n609, n610,
         n611, n612, n613, n614, n615, n616, n617, n618, n619, n620, n621,
         n622, n623, n624, n625, n626, n627, n628, n629, n630, n631, n632,
         n633, n634, n635, n636, n637, n638, n639, n640, n641, n642, n643,
         n644, n645, n646, n647, n648, n649, n650, n651, n652, n653, n654,
         n655, n656, n657, n658, n659, n660, n661, n662, n663, n664, n665,
         n666, n667, n668, n669, n670, n671, n672, n673, n674, n675, n676,
         n677, n678, n679, n680, n681, n682, n683, n684, n685, n686, n687,
         n688, n689, n690, n691, n692, n693, n694, n695, n696, n697, n698,
         n699, n700, n701, n702, n703, n704, n705, n706, n707, n708, n709,
         n710, n711, n712, n713, n714, n715, n716, n717, n718, n719, n720,
         n721, n722, n723, n724, n725, n726, n727, n728, n729, n731, n732,
         n733, n734, n735, n736, n737, n738, n739, n740, n741, n742, n743,
         n744, n745, n746, n747, n748, n749, n750, n751, n752, n753, n754,
         n755, n756, n757, n758, n759, n760, n761, n762, n763, n764, n765,
         n766, n767;
  wire   [2:0] NState;
  wire   [6:0] cnt;
  wire   [7:0] pre_result;
  wire   [14:0] \sub_381/carry ;
  wire   [6:1] \add_122/carry ;

  DFFRX4 \res_do_reg[0]  ( .D(n331), .CK(clk), .RN(n430), .Q(n794), .QN(n598)
         );
  DT_DW01_inc_0 add_291_2 ( .A(pre_result), .SUM({N392, N391, N390, N389, N388, 
        N387, N386, N385}) );
  DT_DW01_inc_1 add_202 ( .A({n355, n358, n372, n369, n361, n366, n377, n374, 
        n363, n379}), .SUM({N233, N232, N231, N230, N229, N228, N227, N226, 
        N225, N224}) );
  DT_DW01_dec_0 r497 ( .A({res_addr[13:1], n429}), .SUM({N677, N676, N675, 
        N674, N673, N672, N671, N670, N669, N668, N667, N666, N665, N664}) );
  DT_DW01_inc_2 r494 ( .A({res_addr[13:1], n429}), .SUM({n18, n19, n20, n21, 
        n22, n23, n24, n25, n26, n27, n28, n29, n30, n31}) );
  DT_DW01_inc_3 r490 ( .A(pre_result), .SUM({N330, N329, N328, N327, N326, 
        N325, N324, N323}) );
  DT_DW01_inc_4 r483 ( .A(res_di), .SUM({N257, N256, N255, N254, N253, N252, 
        N251, N250}) );
  DT_DW01_inc_5 r480 ( .A({n393, res_do[6], n789, n790, n791, n792, n793, n794}), .SUM({N246, N245, N244, N243, N242, N241, N240, N239}) );
  DT_DW01_inc_6 r477 ( .A({cnt[6:3], n462, n427, N142}), .SUM({N155, N154, 
        N153, N152, N151, N150, N149}) );
  DT_DW01_inc_7 add_150_aco ( .A({N1194, N1193, N1192, N1191, N1190, N1189, 
        N1188}), .SUM({N195, N194, N193, N192, N191, N190, N189}) );
  DFFRX2 \cnt_reg[0]  ( .D(N196), .CK(clk), .RN(n430), .Q(N142), .QN(N76) );
  DFFSX1 \res_addr_reg[5]  ( .D(n334), .CK(clk), .SN(n431), .Q(n783) );
  DFFSX1 \res_addr_reg[6]  ( .D(n333), .CK(clk), .SN(n430), .Q(n782) );
  DFFSX1 \res_addr_reg[4]  ( .D(n335), .CK(clk), .SN(n352), .Q(n784) );
  DFFSX1 \res_addr_reg[3]  ( .D(n336), .CK(clk), .SN(n352), .Q(n785) );
  DFFRX2 \cnt_reg[2]  ( .D(n765), .CK(clk), .RN(n431), .Q(n462), .QN(N78) );
  DFFSX1 \res_addr_reg[2]  ( .D(n337), .CK(clk), .SN(n352), .Q(n786) );
  DFFRX2 \cnt_reg[3]  ( .D(n764), .CK(clk), .RN(n430), .Q(cnt[3]), .QN(N79) );
  DFFSX1 \res_addr_reg[1]  ( .D(n338), .CK(clk), .SN(n352), .Q(n787), .QN(n345) );
  DFFRX2 \PState_reg[2]  ( .D(NState[2]), .CK(clk), .RN(n430), .QN(n304) );
  DFFRX1 done_reg ( .D(n341), .CK(clk), .RN(reset), .QN(n390) );
  DFFRX1 res_rd_reg ( .D(N867), .CK(clk), .RN(reset), .QN(n388) );
  DFFRX1 sti_rd_reg ( .D(n767), .CK(clk), .RN(n430), .QN(n386) );
  DFFRX1 res_wr_reg ( .D(N854), .CK(clk), .RN(n352), .QN(n350) );
  DFFRX1 jump_flag_reg ( .D(n339), .CK(clk), .RN(n352), .Q(n755), .QN(n485) );
  DFFRX1 \pre_result_reg[5]  ( .D(n318), .CK(clk), .RN(reset), .Q(
        pre_result[5]) );
  DFFRX1 \pre_result_reg[4]  ( .D(n319), .CK(clk), .RN(reset), .Q(
        pre_result[4]) );
  DFFRX1 \pre_result_reg[2]  ( .D(n321), .CK(clk), .RN(n431), .Q(pre_result[2]) );
  DFFRX1 \pre_result_reg[7]  ( .D(n316), .CK(clk), .RN(n430), .Q(pre_result[7]), .QN(n549) );
  DFFRX1 \pre_result_reg[6]  ( .D(n317), .CK(clk), .RN(n430), .Q(pre_result[6]), .QN(n557) );
  DFFRX1 \pre_result_reg[3]  ( .D(n320), .CK(clk), .RN(n431), .Q(pre_result[3]), .QN(n561) );
  DFFRX1 \pre_result_reg[1]  ( .D(n322), .CK(clk), .RN(n431), .Q(pre_result[1]), .QN(n567) );
  DFFRX1 \pre_result_reg[0]  ( .D(n323), .CK(clk), .RN(n431), .Q(pre_result[0]), .QN(n568) );
  DFFRX1 \PState_reg[0]  ( .D(NState[0]), .CK(clk), .RN(n430), .Q(n756), .QN(
        n712) );
  DFFRX1 comp_flag_reg ( .D(n324), .CK(clk), .RN(n430), .Q(n754), .QN(n619) );
  DFFRX1 \res_addr_reg[7]  ( .D(n315), .CK(clk), .RN(n352), .Q(n781) );
  DFFRX1 \res_addr_reg[0]  ( .D(n340), .CK(clk), .RN(reset), .Q(N801), .QN(
        n349) );
  DFFRX1 \res_addr_reg[13]  ( .D(n309), .CK(clk), .RN(n431), .Q(n775) );
  DFFRX1 \res_addr_reg[12]  ( .D(n310), .CK(clk), .RN(n431), .Q(n776) );
  DFFRX1 \res_addr_reg[11]  ( .D(n311), .CK(clk), .RN(n352), .Q(n777) );
  DFFRX1 \res_addr_reg[10]  ( .D(n312), .CK(clk), .RN(n352), .Q(n778) );
  DFFRX1 \res_addr_reg[9]  ( .D(n313), .CK(clk), .RN(n352), .Q(n779) );
  DFFRX1 \res_addr_reg[8]  ( .D(n314), .CK(clk), .RN(n352), .Q(n780) );
  DFFRX1 \res_do_reg[6]  ( .D(n330), .CK(clk), .RN(n430), .Q(n788), .QN(n348)
         );
  DFFRX2 \PState_reg[1]  ( .D(NState[1]), .CK(clk), .RN(n352), .Q(n757), .QN(
        n699) );
  DFFRX1 \res_do_reg[5]  ( .D(n329), .CK(clk), .RN(n430), .Q(n789) );
  DFFRX1 \res_do_reg[7]  ( .D(n332), .CK(clk), .RN(n431), .Q(n393), .QN(n344)
         );
  DFFSX1 \sti_addr_reg[2]  ( .D(n294), .CK(clk), .SN(n352), .QN(n347) );
  DFFRX2 \res_do_reg[3]  ( .D(n327), .CK(clk), .RN(n431), .Q(n791), .QN(n346)
         );
  DFFRHQX1 \cnt_reg[1]  ( .D(n766), .CK(clk), .RN(n352), .Q(cnt[1]) );
  DFFSX1 \sti_addr_reg[1]  ( .D(n295), .CK(clk), .SN(n352), .QN(n343) );
  DFFSX1 \sti_addr_reg[0]  ( .D(n296), .CK(clk), .SN(n352), .QN(n342) );
  DFFRX2 \res_do_reg[4]  ( .D(n328), .CK(clk), .RN(n430), .Q(n790), .QN(n558)
         );
  DFFRX2 \res_do_reg[1]  ( .D(n325), .CK(clk), .RN(n431), .Q(n793), .QN(n597)
         );
  DFFRX2 \res_do_reg[2]  ( .D(n326), .CK(clk), .RN(n431), .Q(n792), .QN(n564)
         );
  DFFRHQX1 \sti_addr_reg[6]  ( .D(n290), .CK(clk), .RN(n352), .Q(n771) );
  DFFRHQX1 \sti_addr_reg[5]  ( .D(n291), .CK(clk), .RN(n431), .Q(n772) );
  DFFRHQX1 \sti_addr_reg[4]  ( .D(n292), .CK(clk), .RN(n430), .Q(n773) );
  DFFRHQX1 \sti_addr_reg[3]  ( .D(n293), .CK(clk), .RN(n430), .Q(n774) );
  DFFRHQX1 \sti_addr_reg[7]  ( .D(n289), .CK(clk), .RN(n431), .Q(n770) );
  DFFRHQX1 \sti_addr_reg[8]  ( .D(n288), .CK(clk), .RN(n431), .Q(n769) );
  DFFRHQX1 \sti_addr_reg[9]  ( .D(n297), .CK(clk), .RN(n430), .Q(n768) );
  DFFRHQX1 \cnt_reg[4]  ( .D(n763), .CK(clk), .RN(n431), .Q(cnt[4]) );
  DFFRHQX1 \cnt_reg[6]  ( .D(n761), .CK(clk), .RN(n430), .Q(cnt[6]) );
  DFFRHQX1 \cnt_reg[5]  ( .D(n762), .CK(clk), .RN(n431), .Q(cnt[5]) );
  AOI222X1 U295 ( .A0(N148), .A1(n409), .B0(N155), .B1(n402), .C0(N195), .C1(
        n408), .Y(n463) );
  OAI22XL U296 ( .A0(n606), .A1(n607), .B0(res_di[7]), .B1(n344), .Y(n603) );
  NAND2X6 U297 ( .A(N255), .B(n559), .Y(n628) );
  OAI222XL U298 ( .A0(n791), .A1(n638), .B0(res_do[2]), .B1(n639), .C0(n640), 
        .C1(n641), .Y(n636) );
  OA21XL U299 ( .A0(res_do[1]), .A1(n543), .B0(n527), .Y(n617) );
  NAND4X4 U300 ( .A(n692), .B(n693), .C(n694), .D(n526), .Y(n479) );
  INVX16 U301 ( .A(n564), .Y(res_do[2]) );
  NOR2X1 U302 ( .A(n399), .B(n400), .Y(n541) );
  CLKBUFX3 U303 ( .A(N801), .Y(n429) );
  INVXL U304 ( .A(reset), .Y(n351) );
  INVX3 U305 ( .A(n351), .Y(n352) );
  INVX12 U306 ( .A(n350), .Y(res_wr) );
  CLKINVX1 U307 ( .A(n768), .Y(n354) );
  INVXL U308 ( .A(n354), .Y(n355) );
  INVX16 U309 ( .A(n354), .Y(sti_addr[9]) );
  CLKINVX1 U310 ( .A(n769), .Y(n357) );
  INVXL U311 ( .A(n357), .Y(n358) );
  INVX16 U312 ( .A(n357), .Y(sti_addr[8]) );
  CLKINVX1 U313 ( .A(n772), .Y(n360) );
  INVXL U314 ( .A(n360), .Y(n361) );
  INVX16 U315 ( .A(n360), .Y(sti_addr[5]) );
  INVXL U316 ( .A(n343), .Y(n363) );
  INVX16 U317 ( .A(n343), .Y(sti_addr[1]) );
  CLKINVX1 U318 ( .A(n773), .Y(n365) );
  INVXL U319 ( .A(n365), .Y(n366) );
  INVX16 U320 ( .A(n365), .Y(sti_addr[4]) );
  CLKINVX1 U321 ( .A(n771), .Y(n368) );
  INVXL U322 ( .A(n368), .Y(n369) );
  INVX16 U323 ( .A(n368), .Y(sti_addr[6]) );
  CLKINVX1 U324 ( .A(n770), .Y(n371) );
  INVXL U325 ( .A(n371), .Y(n372) );
  INVX16 U326 ( .A(n371), .Y(sti_addr[7]) );
  INVXL U327 ( .A(n347), .Y(n374) );
  INVX16 U328 ( .A(n347), .Y(sti_addr[2]) );
  CLKINVX1 U329 ( .A(n774), .Y(n376) );
  INVXL U330 ( .A(n376), .Y(n377) );
  INVX16 U331 ( .A(n376), .Y(sti_addr[3]) );
  INVXL U332 ( .A(n342), .Y(n379) );
  INVX16 U333 ( .A(n342), .Y(sti_addr[0]) );
  CLKINVX1 U334 ( .A(n393), .Y(n381) );
  INVX12 U335 ( .A(n381), .Y(res_do[7]) );
  INVXL U336 ( .A(cnt[5]), .Y(n758) );
  INVXL U337 ( .A(cnt[6]), .Y(n759) );
  INVXL U338 ( .A(cnt[4]), .Y(n760) );
  CLKINVX1 U339 ( .A(res_di[5]), .Y(n531) );
  AND2X4 U340 ( .A(n580), .B(n408), .Y(n401) );
  AND2X6 U341 ( .A(n396), .B(n624), .Y(n580) );
  OAI211XL U342 ( .A0(n513), .A1(n540), .B0(n541), .C0(n542), .Y(n326) );
  OAI222XL U343 ( .A0(n791), .A1(n537), .B0(res_do[2]), .B1(n540), .C0(n617), 
        .C1(n618), .Y(n615) );
  INVX1 U344 ( .A(res_di[2]), .Y(n540) );
  INVX8 U345 ( .A(n628), .Y(n634) );
  AOI32X2 U346 ( .A0(n627), .A1(n628), .A2(n629), .B0(n630), .B1(n631), .Y(
        n625) );
  AOI22XL U347 ( .A0(res_do[6]), .A1(n520), .B0(N256), .B1(n401), .Y(n529) );
  NOR4X4 U348 ( .A(n401), .B(n577), .C(n578), .D(n579), .Y(n575) );
  AOI2BB1X2 U349 ( .A0N(n546), .A1N(n547), .B0(n548), .Y(n518) );
  AOI21X1 U350 ( .A0(n393), .A1(n549), .B0(n550), .Y(n547) );
  NOR3X2 U351 ( .A(n546), .B(n547), .C(n548), .Y(n519) );
  BUFX12 U352 ( .A(n789), .Y(res_do[5]) );
  AOI22XL U353 ( .A0(res_do[5]), .A1(n520), .B0(N255), .B1(n401), .Y(n532) );
  CLKINVX2 U354 ( .A(n789), .Y(n559) );
  INVX16 U355 ( .A(n598), .Y(res_do[0]) );
  AO22XL U356 ( .A0(res_do[0]), .A1(n520), .B0(N385), .B1(n517), .Y(n524) );
  INVX12 U357 ( .A(n346), .Y(res_do[3]) );
  AOI22XL U358 ( .A0(n791), .A1(n520), .B0(N253), .B1(n401), .Y(n538) );
  OAI21X1 U359 ( .A0(n723), .A1(n729), .B0(n579), .Y(n526) );
  INVX12 U360 ( .A(n386), .Y(sti_rd) );
  INVX12 U361 ( .A(n388), .Y(res_rd) );
  INVX12 U362 ( .A(n390), .Y(done) );
  INVX16 U363 ( .A(n304), .Y(fw_finish) );
  INVX16 U364 ( .A(n558), .Y(res_do[4]) );
  AOI22XL U365 ( .A0(res_do[4]), .A1(n520), .B0(N254), .B1(n401), .Y(n535) );
  MX2XL U366 ( .A(N224), .B(sti_addr[0]), .S0(n407), .Y(n296) );
  AND3XL U367 ( .A(sti_addr[1]), .B(sti_addr[9]), .C(sti_addr[0]), .Y(n717) );
  AOI22XL U368 ( .A0(res_do[7]), .A1(n520), .B0(N257), .B1(n401), .Y(n515) );
  NOR2XL U369 ( .A(n393), .B(n514), .Y(n607) );
  NAND2XL U370 ( .A(res_do[2]), .B(n540), .Y(n614) );
  NAND2XL U371 ( .A(res_do[2]), .B(n639), .Y(n635) );
  INVX16 U372 ( .A(n597), .Y(res_do[1]) );
  AOI22XL U373 ( .A0(res_do[1]), .A1(n520), .B0(N251), .B1(n401), .Y(n544) );
  OAI21X2 U374 ( .A0(n408), .A1(n661), .B0(n487), .Y(n659) );
  INVX3 U375 ( .A(n660), .Y(n487) );
  OR2X8 U376 ( .A(n625), .B(n626), .Y(n398) );
  NAND2XL U377 ( .A(n632), .B(N256), .Y(n630) );
  NOR2X4 U378 ( .A(n599), .B(n739), .Y(n578) );
  OR2X1 U379 ( .A(n427), .B(n623), .Y(n396) );
  OR2X4 U380 ( .A(N257), .B(n344), .Y(n397) );
  NAND2X6 U381 ( .A(n397), .B(n398), .Y(n624) );
  AOI211XL U382 ( .A0(n621), .A1(n622), .B0(n600), .C0(n580), .Y(n620) );
  NAND3X8 U383 ( .A(n407), .B(n472), .C(n573), .Y(n520) );
  AND3X2 U384 ( .A(n569), .B(n570), .C(n571), .Y(n517) );
  AOI2BB2XL U385 ( .B0(res_do[6]), .B1(n589), .A0N(n558), .A1N(N327), .Y(n585)
         );
  OAI2BB1XL U386 ( .A0N(n591), .A1N(n590), .B0(n346), .Y(n593) );
  AOI2BB2XL U387 ( .B0(res_do[6]), .B1(n557), .A0N(n558), .A1N(pre_result[4]), 
        .Y(n553) );
  NOR2XL U388 ( .A(res_do[1]), .B(n567), .Y(n566) );
  AOI211XL U389 ( .A0(n793), .A1(n567), .B0(n568), .C0(res_do[0]), .Y(n565) );
  AO21XL U390 ( .A0(n561), .A1(n560), .B0(n791), .Y(n563) );
  NOR2BXL U391 ( .AN(N324), .B(res_do[1]), .Y(n595) );
  MX2XL U392 ( .A(N233), .B(sti_addr[9]), .S0(n407), .Y(n297) );
  MX2XL U393 ( .A(N232), .B(sti_addr[8]), .S0(n407), .Y(n288) );
  NOR2XL U394 ( .A(n549), .B(n393), .Y(n546) );
  MX2XL U395 ( .A(N231), .B(sti_addr[7]), .S0(n407), .Y(n289) );
  MX2XL U396 ( .A(N230), .B(sti_addr[6]), .S0(n407), .Y(n290) );
  NOR3XL U397 ( .A(n725), .B(sti_addr[3]), .C(n726), .Y(n718) );
  MX2XL U398 ( .A(N229), .B(sti_addr[5]), .S0(n407), .Y(n291) );
  MX2XL U399 ( .A(N228), .B(sti_addr[4]), .S0(n407), .Y(n292) );
  MX2XL U400 ( .A(N226), .B(sti_addr[2]), .S0(n407), .Y(n294) );
  MX2XL U401 ( .A(N225), .B(sti_addr[1]), .S0(n407), .Y(n295) );
  MX2XL U402 ( .A(N227), .B(sti_addr[3]), .S0(n407), .Y(n293) );
  AND4XL U403 ( .A(n724), .B(sti_addr[8]), .C(sti_addr[6]), .D(sti_addr[7]), 
        .Y(n719) );
  AND3XL U404 ( .A(sti_addr[4]), .B(sti_addr[2]), .C(sti_addr[5]), .Y(n724) );
  OAI21X1 U405 ( .A0(n632), .A1(N256), .B0(n348), .Y(n631) );
  MXI2X4 U406 ( .A(n574), .B(n575), .S0(n576), .Y(n573) );
  AND4XL U407 ( .A(n703), .B(n483), .C(n706), .D(n412), .Y(n704) );
  NOR4BXL U408 ( .AN(res_addr[4]), .B(n746), .C(n739), .D(n722), .Y(n745) );
  AOI32XL U409 ( .A0(N327), .A1(n558), .A2(n584), .B0(n559), .B1(N328), .Y(
        n588) );
  OR2XL U410 ( .A(N328), .B(n559), .Y(n584) );
  OAI211XL U411 ( .A0(n346), .A1(n635), .B0(n636), .C0(n637), .Y(n627) );
  OA22X4 U412 ( .A0(n599), .A1(n600), .B0(n601), .B1(n482), .Y(n513) );
  AOI32XL U413 ( .A0(res_do[4]), .A1(n534), .A2(n609), .B0(n531), .B1(n789), 
        .Y(n613) );
  NAND2XL U414 ( .A(res_di[5]), .B(n559), .Y(n609) );
  AND2X2 U415 ( .A(N142), .B(n412), .Y(N1188) );
  AND2XL U416 ( .A(n412), .B(cnt[6]), .Y(N1194) );
  INVX1 U417 ( .A(n463), .Y(n761) );
  INVXL U418 ( .A(res_di[4]), .Y(n534) );
  INVX1 U419 ( .A(res_di[3]), .Y(n537) );
  INVX1 U420 ( .A(n467), .Y(n762) );
  NAND2XL U421 ( .A(n613), .B(res_di[6]), .Y(n611) );
  INVX1 U422 ( .A(n468), .Y(n763) );
  INVX1 U423 ( .A(res_di[6]), .Y(n528) );
  INVX1 U424 ( .A(res_di[7]), .Y(n514) );
  OAI2BB1XL U425 ( .A0N(n738), .A1N(n412), .B0(n661), .Y(n742) );
  AOI32XL U426 ( .A0(pre_result[4]), .A1(n558), .A2(n552), .B0(n559), .B1(
        pre_result[5]), .Y(n556) );
  OR2XL U427 ( .A(pre_result[5]), .B(n559), .Y(n552) );
  AOI32XL U428 ( .A0(res_di[4]), .A1(n650), .A2(n645), .B0(n651), .B1(
        res_di[5]), .Y(n649) );
  AOI2BB2XL U429 ( .B0(N245), .B1(n528), .A0N(res_di[4]), .A1N(n650), .Y(n646)
         );
  OAI211XL U430 ( .A0(n537), .A1(n652), .B0(n653), .C0(n654), .Y(n644) );
  NOR2XL U431 ( .A(N240), .B(n543), .Y(n658) );
  AOI211XL U432 ( .A0(N240), .A1(n543), .B0(n527), .C0(N239), .Y(n657) );
  NAND2XL U433 ( .A(res_di[2]), .B(n656), .Y(n652) );
  AND2XL U434 ( .A(res_do[2]), .B(n520), .Y(n399) );
  AND2XL U435 ( .A(N252), .B(n401), .Y(n400) );
  INVX3 U436 ( .A(n633), .Y(n632) );
  CLKBUFX3 U437 ( .A(N187), .Y(n412) );
  CLKINVX1 U438 ( .A(n578), .Y(N187) );
  CLKINVX1 U439 ( .A(N73), .Y(n447) );
  CLKINVX1 U440 ( .A(N74), .Y(n446) );
  BUFX4 U441 ( .A(n464), .Y(n409) );
  NOR3X1 U442 ( .A(n729), .B(n723), .C(n725), .Y(n464) );
  CLKBUFX3 U443 ( .A(n477), .Y(n403) );
  AND2X2 U444 ( .A(n690), .B(n408), .Y(n477) );
  CLKBUFX3 U445 ( .A(n478), .Y(n404) );
  OAI221XL U446 ( .A0(n698), .A1(n699), .B0(n602), .B1(n600), .C0(n700), .Y(
        n478) );
  CLKBUFX3 U447 ( .A(n492), .Y(n411) );
  NOR2X1 U448 ( .A(n706), .B(n482), .Y(n492) );
  CLKBUFX3 U449 ( .A(n572), .Y(n407) );
  NAND2X1 U450 ( .A(n698), .B(n699), .Y(n572) );
  AOI32X1 U451 ( .A0(n608), .A1(n609), .A2(n610), .B0(n611), .B1(n612), .Y(
        n606) );
  AOI32X1 U452 ( .A0(n427), .A1(n602), .A2(N76), .B0(n603), .B1(n604), .Y(n601) );
  CLKBUFX3 U453 ( .A(n480), .Y(n406) );
  CLKBUFX3 U454 ( .A(n481), .Y(n405) );
  OAI32X1 U455 ( .A0(n697), .A1(n427), .A2(N76), .B0(n576), .B1(n619), .Y(n481) );
  BUFX16 U456 ( .A(n787), .Y(res_addr[1]) );
  BUFX16 U457 ( .A(n786), .Y(res_addr[2]) );
  BUFX16 U458 ( .A(n785), .Y(res_addr[3]) );
  BUFX12 U459 ( .A(N801), .Y(res_addr[0]) );
  BUFX16 U460 ( .A(n781), .Y(res_addr[7]) );
  BUFX16 U461 ( .A(n780), .Y(res_addr[8]) );
  BUFX16 U462 ( .A(n776), .Y(res_addr[12]) );
  BUFX16 U463 ( .A(n779), .Y(res_addr[9]) );
  BUFX16 U464 ( .A(n777), .Y(res_addr[11]) );
  BUFX16 U465 ( .A(n778), .Y(res_addr[10]) );
  BUFX16 U466 ( .A(n788), .Y(res_do[6]) );
  BUFX16 U467 ( .A(n775), .Y(res_addr[13]) );
  BUFX16 U468 ( .A(n784), .Y(res_addr[4]) );
  BUFX16 U469 ( .A(n782), .Y(res_addr[6]) );
  BUFX16 U470 ( .A(n783), .Y(res_addr[5]) );
  CLKBUFX3 U471 ( .A(cnt[1]), .Y(n427) );
  CLKBUFX3 U472 ( .A(n466), .Y(n408) );
  NOR3X1 U473 ( .A(n757), .B(n756), .C(n304), .Y(n466) );
  CLKBUFX3 U474 ( .A(n484), .Y(n410) );
  NOR2X1 U475 ( .A(n576), .B(n754), .Y(n484) );
  CLKBUFX3 U476 ( .A(n352), .Y(n431) );
  CLKBUFX3 U477 ( .A(n352), .Y(n430) );
  OAI211XL U478 ( .A0(n346), .A1(n614), .B0(n615), .C0(n616), .Y(n608) );
  CLKBUFX3 U479 ( .A(n465), .Y(n402) );
  OAI32XL U480 ( .A0(n558), .A1(N254), .A2(n634), .B0(N255), .B1(n559), .Y(
        n633) );
  XNOR2X1 U481 ( .A(res_addr[13]), .B(\r495/carry[13] ), .Y(N576) );
  OR2X1 U482 ( .A(res_addr[12]), .B(\r495/carry[12] ), .Y(\r495/carry[13] ) );
  XNOR2X1 U483 ( .A(\r495/carry[12] ), .B(res_addr[12]), .Y(N575) );
  OR2X1 U484 ( .A(res_addr[11]), .B(\r495/carry[11] ), .Y(\r495/carry[12] ) );
  XNOR2X1 U485 ( .A(\r495/carry[11] ), .B(res_addr[11]), .Y(N574) );
  OR2X1 U486 ( .A(res_addr[10]), .B(\r495/carry[10] ), .Y(\r495/carry[11] ) );
  XNOR2X1 U487 ( .A(\r495/carry[10] ), .B(res_addr[10]), .Y(N573) );
  OR2X1 U488 ( .A(res_addr[9]), .B(\r495/carry[9] ), .Y(\r495/carry[10] ) );
  XNOR2X1 U489 ( .A(\r495/carry[9] ), .B(res_addr[9]), .Y(N572) );
  OR2X1 U490 ( .A(res_addr[8]), .B(\r495/carry[8] ), .Y(\r495/carry[9] ) );
  XNOR2X1 U491 ( .A(\r495/carry[8] ), .B(res_addr[8]), .Y(N571) );
  AND2X1 U492 ( .A(\r495/carry[7] ), .B(res_addr[7]), .Y(\r495/carry[8] ) );
  XOR2X1 U493 ( .A(res_addr[7]), .B(\r495/carry[7] ), .Y(N570) );
  OR2X1 U494 ( .A(res_addr[6]), .B(\r495/carry[6] ), .Y(\r495/carry[7] ) );
  XNOR2X1 U495 ( .A(\r495/carry[6] ), .B(res_addr[6]), .Y(N569) );
  OR2X1 U496 ( .A(res_addr[5]), .B(\r495/carry[5] ), .Y(\r495/carry[6] ) );
  XNOR2X1 U497 ( .A(\r495/carry[5] ), .B(res_addr[5]), .Y(N568) );
  OR2X1 U498 ( .A(res_addr[4]), .B(\r495/carry[4] ), .Y(\r495/carry[5] ) );
  XNOR2X1 U499 ( .A(\r495/carry[4] ), .B(res_addr[4]), .Y(N567) );
  OR2X1 U500 ( .A(res_addr[3]), .B(\r495/carry[3] ), .Y(\r495/carry[4] ) );
  XNOR2X1 U501 ( .A(\r495/carry[3] ), .B(res_addr[3]), .Y(N566) );
  OR2X1 U502 ( .A(res_addr[2]), .B(\r495/carry[2] ), .Y(\r495/carry[3] ) );
  XNOR2X1 U503 ( .A(\r495/carry[2] ), .B(res_addr[2]), .Y(N565) );
  OR2X1 U504 ( .A(res_addr[1]), .B(n429), .Y(\r495/carry[2] ) );
  XNOR2X1 U505 ( .A(n429), .B(res_addr[1]), .Y(N564) );
  XOR2X1 U506 ( .A(res_addr[13]), .B(\r496/carry[13] ), .Y(N618) );
  AND2X1 U507 ( .A(\r496/carry[12] ), .B(res_addr[12]), .Y(\r496/carry[13] )
         );
  XOR2X1 U508 ( .A(res_addr[12]), .B(\r496/carry[12] ), .Y(N617) );
  AND2X1 U509 ( .A(\r496/carry[11] ), .B(res_addr[11]), .Y(\r496/carry[12] )
         );
  XOR2X1 U510 ( .A(res_addr[11]), .B(\r496/carry[11] ), .Y(N616) );
  AND2X1 U511 ( .A(\r496/carry[10] ), .B(res_addr[10]), .Y(\r496/carry[11] )
         );
  XOR2X1 U512 ( .A(res_addr[10]), .B(\r496/carry[10] ), .Y(N615) );
  AND2X1 U513 ( .A(\r496/carry[9] ), .B(res_addr[9]), .Y(\r496/carry[10] ) );
  XOR2X1 U514 ( .A(res_addr[9]), .B(\r496/carry[9] ), .Y(N614) );
  AND2X1 U515 ( .A(\r496/carry[8] ), .B(res_addr[8]), .Y(\r496/carry[9] ) );
  XOR2X1 U516 ( .A(res_addr[8]), .B(\r496/carry[8] ), .Y(N613) );
  AND2X1 U517 ( .A(\r496/carry[7] ), .B(res_addr[7]), .Y(\r496/carry[8] ) );
  XOR2X1 U518 ( .A(res_addr[7]), .B(\r496/carry[7] ), .Y(N612) );
  OR2X1 U519 ( .A(res_addr[6]), .B(\r496/carry[6] ), .Y(\r496/carry[7] ) );
  XNOR2X1 U520 ( .A(\r496/carry[6] ), .B(res_addr[6]), .Y(N611) );
  OR2X1 U521 ( .A(res_addr[5]), .B(\r496/carry[5] ), .Y(\r496/carry[6] ) );
  XNOR2X1 U522 ( .A(\r496/carry[5] ), .B(res_addr[5]), .Y(N610) );
  OR2X1 U523 ( .A(res_addr[4]), .B(\r496/carry[4] ), .Y(\r496/carry[5] ) );
  XNOR2X1 U524 ( .A(\r496/carry[4] ), .B(res_addr[4]), .Y(N609) );
  OR2X1 U525 ( .A(res_addr[3]), .B(\r496/carry[3] ), .Y(\r496/carry[4] ) );
  XNOR2X1 U526 ( .A(\r496/carry[3] ), .B(res_addr[3]), .Y(N608) );
  OR2X1 U527 ( .A(res_addr[2]), .B(\r496/carry[2] ), .Y(\r496/carry[3] ) );
  XNOR2X1 U528 ( .A(\r496/carry[2] ), .B(res_addr[2]), .Y(N607) );
  OR2X1 U529 ( .A(res_addr[1]), .B(n429), .Y(\r496/carry[2] ) );
  XNOR2X1 U530 ( .A(n429), .B(res_addr[1]), .Y(N606) );
  XNOR2X1 U531 ( .A(res_addr[13]), .B(\sub_381/carry [13]), .Y(N814) );
  OR2X1 U532 ( .A(res_addr[12]), .B(\sub_381/carry [12]), .Y(
        \sub_381/carry [13]) );
  XNOR2X1 U533 ( .A(\sub_381/carry [12]), .B(res_addr[12]), .Y(N813) );
  OR2X1 U534 ( .A(res_addr[11]), .B(\sub_381/carry [11]), .Y(
        \sub_381/carry [12]) );
  XNOR2X1 U535 ( .A(\sub_381/carry [11]), .B(res_addr[11]), .Y(N812) );
  OR2X1 U536 ( .A(res_addr[10]), .B(\sub_381/carry [10]), .Y(
        \sub_381/carry [11]) );
  XNOR2X1 U537 ( .A(\sub_381/carry [10]), .B(res_addr[10]), .Y(N811) );
  OR2X1 U538 ( .A(res_addr[9]), .B(\sub_381/carry [9]), .Y(\sub_381/carry [10]) );
  XNOR2X1 U539 ( .A(\sub_381/carry [9]), .B(res_addr[9]), .Y(N810) );
  OR2X1 U540 ( .A(res_addr[8]), .B(\sub_381/carry [8]), .Y(\sub_381/carry [9])
         );
  XNOR2X1 U541 ( .A(\sub_381/carry [8]), .B(res_addr[8]), .Y(N809) );
  AND2X1 U542 ( .A(\sub_381/carry [7]), .B(res_addr[7]), .Y(\sub_381/carry [8]) );
  XOR2X1 U543 ( .A(res_addr[7]), .B(\sub_381/carry [7]), .Y(N808) );
  OR2X1 U544 ( .A(res_addr[6]), .B(\sub_381/carry [6]), .Y(\sub_381/carry [7])
         );
  XNOR2X1 U545 ( .A(\sub_381/carry [6]), .B(res_addr[6]), .Y(N807) );
  OR2X1 U546 ( .A(res_addr[5]), .B(\sub_381/carry [5]), .Y(\sub_381/carry [6])
         );
  XNOR2X1 U547 ( .A(\sub_381/carry [5]), .B(res_addr[5]), .Y(N806) );
  OR2X1 U548 ( .A(res_addr[4]), .B(\sub_381/carry [4]), .Y(\sub_381/carry [5])
         );
  XNOR2X1 U549 ( .A(\sub_381/carry [4]), .B(res_addr[4]), .Y(N805) );
  OR2X1 U550 ( .A(res_addr[3]), .B(\sub_381/carry [3]), .Y(\sub_381/carry [4])
         );
  XNOR2X1 U551 ( .A(\sub_381/carry [3]), .B(res_addr[3]), .Y(N804) );
  OR2X1 U552 ( .A(res_addr[2]), .B(res_addr[1]), .Y(\sub_381/carry [3]) );
  XNOR2X1 U553 ( .A(res_addr[1]), .B(res_addr[2]), .Y(N803) );
  XOR2X1 U554 ( .A(res_addr[13]), .B(\add_335/carry[13] ), .Y(N476) );
  AND2X1 U555 ( .A(\add_335/carry[12] ), .B(res_addr[12]), .Y(
        \add_335/carry[13] ) );
  XOR2X1 U556 ( .A(res_addr[12]), .B(\add_335/carry[12] ), .Y(N475) );
  AND2X1 U557 ( .A(\add_335/carry[11] ), .B(res_addr[11]), .Y(
        \add_335/carry[12] ) );
  XOR2X1 U558 ( .A(res_addr[11]), .B(\add_335/carry[11] ), .Y(N474) );
  AND2X1 U559 ( .A(\add_335/carry[10] ), .B(res_addr[10]), .Y(
        \add_335/carry[11] ) );
  XOR2X1 U560 ( .A(res_addr[10]), .B(\add_335/carry[10] ), .Y(N473) );
  AND2X1 U561 ( .A(\add_335/carry[9] ), .B(res_addr[9]), .Y(
        \add_335/carry[10] ) );
  XOR2X1 U562 ( .A(res_addr[9]), .B(\add_335/carry[9] ), .Y(N472) );
  AND2X1 U563 ( .A(\add_335/carry[8] ), .B(res_addr[8]), .Y(\add_335/carry[9] ) );
  XOR2X1 U564 ( .A(res_addr[8]), .B(\add_335/carry[8] ), .Y(N471) );
  AND2X1 U565 ( .A(\add_335/carry[7] ), .B(res_addr[7]), .Y(\add_335/carry[8] ) );
  XOR2X1 U566 ( .A(res_addr[7]), .B(\add_335/carry[7] ), .Y(N470) );
  AND2X1 U567 ( .A(\add_335/carry[6] ), .B(res_addr[6]), .Y(\add_335/carry[7] ) );
  XOR2X1 U568 ( .A(res_addr[6]), .B(\add_335/carry[6] ), .Y(N469) );
  AND2X1 U569 ( .A(\add_335/carry[5] ), .B(res_addr[5]), .Y(\add_335/carry[6] ) );
  XOR2X1 U570 ( .A(res_addr[5]), .B(\add_335/carry[5] ), .Y(N468) );
  AND2X1 U571 ( .A(\add_335/carry[4] ), .B(res_addr[4]), .Y(\add_335/carry[5] ) );
  XOR2X1 U572 ( .A(res_addr[4]), .B(\add_335/carry[4] ), .Y(N467) );
  AND2X1 U573 ( .A(\add_335/carry[3] ), .B(res_addr[3]), .Y(\add_335/carry[4] ) );
  XOR2X1 U574 ( .A(res_addr[3]), .B(\add_335/carry[3] ), .Y(N466) );
  AND2X1 U575 ( .A(\add_335/carry[2] ), .B(res_addr[2]), .Y(\add_335/carry[3] ) );
  XOR2X1 U576 ( .A(res_addr[2]), .B(\add_335/carry[2] ), .Y(N465) );
  OR2X1 U577 ( .A(res_addr[1]), .B(n429), .Y(\add_335/carry[2] ) );
  XNOR2X1 U578 ( .A(n429), .B(res_addr[1]), .Y(N464) );
  XOR2X1 U579 ( .A(cnt[6]), .B(\add_122/carry [6]), .Y(N148) );
  AND2X1 U580 ( .A(\add_122/carry [5]), .B(cnt[5]), .Y(\add_122/carry [6]) );
  XOR2X1 U581 ( .A(cnt[5]), .B(\add_122/carry [5]), .Y(N147) );
  AND2X1 U582 ( .A(\add_122/carry [4]), .B(cnt[4]), .Y(\add_122/carry [5]) );
  XOR2X1 U583 ( .A(cnt[4]), .B(\add_122/carry [4]), .Y(N146) );
  AND2X1 U584 ( .A(\add_122/carry [3]), .B(cnt[3]), .Y(\add_122/carry [4]) );
  XOR2X1 U585 ( .A(cnt[3]), .B(\add_122/carry [3]), .Y(N145) );
  AND2X1 U586 ( .A(n427), .B(n462), .Y(\add_122/carry [3]) );
  XOR2X1 U587 ( .A(n462), .B(n427), .Y(N144) );
  AND2X1 U588 ( .A(n427), .B(n412), .Y(N1189) );
  AND2X1 U589 ( .A(n462), .B(n412), .Y(N1190) );
  AND2X1 U590 ( .A(cnt[3]), .B(n412), .Y(N1191) );
  AND2X1 U591 ( .A(cnt[4]), .B(n412), .Y(N1192) );
  AND2X1 U592 ( .A(cnt[5]), .B(n412), .Y(N1193) );
  NOR2X1 U593 ( .A(n447), .B(N142), .Y(n441) );
  NOR2X1 U594 ( .A(n447), .B(N76), .Y(n440) );
  NOR2X1 U595 ( .A(N76), .B(N73), .Y(n438) );
  NOR2X1 U596 ( .A(N142), .B(N73), .Y(n437) );
  AO22X1 U597 ( .A0(sti_di[5]), .A1(n438), .B0(sti_di[4]), .B1(n437), .Y(n432)
         );
  AOI221XL U598 ( .A0(sti_di[6]), .A1(n441), .B0(sti_di[7]), .B1(n440), .C0(
        n432), .Y(n435) );
  AO22X1 U599 ( .A0(sti_di[1]), .A1(n438), .B0(sti_di[0]), .B1(n437), .Y(n433)
         );
  AOI221XL U600 ( .A0(sti_di[2]), .A1(n441), .B0(sti_di[3]), .B1(n440), .C0(
        n433), .Y(n434) );
  OA22X1 U601 ( .A0(n446), .A1(n435), .B0(N74), .B1(n434), .Y(n445) );
  AO22X1 U602 ( .A0(sti_di[13]), .A1(n438), .B0(sti_di[12]), .B1(n437), .Y(
        n436) );
  AOI221XL U603 ( .A0(sti_di[14]), .A1(n441), .B0(sti_di[15]), .B1(n440), .C0(
        n436), .Y(n443) );
  AO22X1 U604 ( .A0(sti_di[9]), .A1(n438), .B0(sti_di[8]), .B1(n437), .Y(n439)
         );
  AOI221XL U605 ( .A0(sti_di[10]), .A1(n441), .B0(sti_di[11]), .B1(n440), .C0(
        n439), .Y(n442) );
  OAI22XL U606 ( .A0(n443), .A1(n446), .B0(N74), .B1(n442), .Y(n444) );
  OAI2BB2XL U607 ( .B0(n445), .B1(N75), .A0N(N75), .A1N(n444), .Y(N290) );
  NOR2X1 U608 ( .A(cnt[1]), .B(N76), .Y(n457) );
  NOR2X1 U609 ( .A(cnt[1]), .B(N142), .Y(n456) );
  NOR2X1 U610 ( .A(N142), .B(n696), .Y(n454) );
  NOR2X1 U611 ( .A(N76), .B(n696), .Y(n453) );
  AO22X1 U612 ( .A0(sti_di[5]), .A1(n454), .B0(sti_di[4]), .B1(n453), .Y(n448)
         );
  AOI221XL U613 ( .A0(sti_di[6]), .A1(n457), .B0(sti_di[7]), .B1(n456), .C0(
        n448), .Y(n451) );
  AO22X1 U614 ( .A0(sti_di[1]), .A1(n454), .B0(sti_di[0]), .B1(n453), .Y(n449)
         );
  AOI221XL U615 ( .A0(sti_di[2]), .A1(n457), .B0(sti_di[3]), .B1(n456), .C0(
        n449), .Y(n450) );
  OA22X1 U616 ( .A0(n462), .A1(n451), .B0(N78), .B1(n450), .Y(n461) );
  AO22X1 U617 ( .A0(sti_di[13]), .A1(n454), .B0(sti_di[12]), .B1(n453), .Y(
        n452) );
  AOI221XL U618 ( .A0(sti_di[14]), .A1(n457), .B0(sti_di[15]), .B1(n456), .C0(
        n452), .Y(n459) );
  AO22X1 U619 ( .A0(sti_di[9]), .A1(n454), .B0(sti_di[8]), .B1(n453), .Y(n455)
         );
  AOI221XL U620 ( .A0(sti_di[10]), .A1(n457), .B0(sti_di[11]), .B1(n456), .C0(
        n455), .Y(n458) );
  OAI22XL U621 ( .A0(n459), .A1(n462), .B0(N78), .B1(n458), .Y(n460) );
  OAI2BB2XL U622 ( .B0(n461), .B1(N79), .A0N(N79), .A1N(n460), .Y(N295) );
  AOI222XL U623 ( .A0(N147), .A1(n409), .B0(N154), .B1(n402), .C0(N194), .C1(
        n408), .Y(n467) );
  AOI222XL U624 ( .A0(N146), .A1(n409), .B0(N153), .B1(n402), .C0(N193), .C1(
        n408), .Y(n468) );
  CLKINVX1 U625 ( .A(n469), .Y(n764) );
  AOI222XL U626 ( .A0(N145), .A1(n409), .B0(N152), .B1(n402), .C0(N192), .C1(
        n408), .Y(n469) );
  CLKINVX1 U627 ( .A(n470), .Y(n765) );
  AOI222XL U628 ( .A0(N144), .A1(n409), .B0(N151), .B1(n402), .C0(N191), .C1(
        n408), .Y(n470) );
  CLKINVX1 U629 ( .A(n471), .Y(n766) );
  AOI222XL U630 ( .A0(n696), .A1(n409), .B0(N150), .B1(n402), .C0(N190), .C1(
        n408), .Y(n471) );
  NOR2X1 U631 ( .A(n756), .B(n472), .Y(n341) );
  NAND4X1 U632 ( .A(n473), .B(n474), .C(n475), .D(n476), .Y(n340) );
  AOI22X1 U633 ( .A0(N664), .A1(n403), .B0(n429), .B1(n404), .Y(n476) );
  AOI22X1 U634 ( .A0(n31), .A1(n479), .B0(n349), .B1(n406), .Y(n475) );
  AOI2BB2X1 U635 ( .B0(n349), .B1(n405), .A0N(n482), .A1N(n483), .Y(n474) );
  AOI22X1 U636 ( .A0(n349), .A1(n409), .B0(n429), .B1(n410), .Y(n473) );
  MXI2X1 U637 ( .A(n485), .B(n486), .S0(n487), .Y(n339) );
  NAND4X1 U638 ( .A(n488), .B(n489), .C(n490), .D(n491), .Y(n338) );
  AOI21X1 U639 ( .A0(N665), .A1(n403), .B0(n411), .Y(n491) );
  AOI22X1 U640 ( .A0(res_addr[1]), .A1(n404), .B0(n30), .B1(n479), .Y(n490) );
  AOI22X1 U641 ( .A0(N606), .A1(n406), .B0(N564), .B1(n405), .Y(n489) );
  AOI22X1 U642 ( .A0(N464), .A1(n409), .B0(n345), .B1(n410), .Y(n488) );
  NAND4X1 U643 ( .A(n493), .B(n494), .C(n495), .D(n496), .Y(n337) );
  AOI21X1 U644 ( .A0(N666), .A1(n403), .B0(n411), .Y(n496) );
  AOI22X1 U645 ( .A0(res_addr[2]), .A1(n404), .B0(n29), .B1(n479), .Y(n495) );
  AOI22X1 U646 ( .A0(N607), .A1(n406), .B0(N565), .B1(n405), .Y(n494) );
  AOI22X1 U647 ( .A0(N465), .A1(n409), .B0(N803), .B1(n410), .Y(n493) );
  NAND4X1 U648 ( .A(n497), .B(n498), .C(n499), .D(n500), .Y(n336) );
  AOI21X1 U649 ( .A0(N667), .A1(n403), .B0(n411), .Y(n500) );
  AOI22X1 U650 ( .A0(res_addr[3]), .A1(n404), .B0(n28), .B1(n479), .Y(n499) );
  AOI22X1 U651 ( .A0(N608), .A1(n406), .B0(N566), .B1(n405), .Y(n498) );
  AOI22X1 U652 ( .A0(N466), .A1(n409), .B0(N804), .B1(n410), .Y(n497) );
  NAND4X1 U653 ( .A(n501), .B(n502), .C(n503), .D(n504), .Y(n335) );
  AOI21X1 U654 ( .A0(N668), .A1(n403), .B0(n411), .Y(n504) );
  AOI22X1 U655 ( .A0(res_addr[4]), .A1(n404), .B0(n27), .B1(n479), .Y(n503) );
  AOI22X1 U656 ( .A0(N609), .A1(n406), .B0(N567), .B1(n405), .Y(n502) );
  AOI22X1 U657 ( .A0(N467), .A1(n409), .B0(N805), .B1(n410), .Y(n501) );
  NAND4X1 U658 ( .A(n505), .B(n506), .C(n507), .D(n508), .Y(n334) );
  AOI21X1 U659 ( .A0(N669), .A1(n403), .B0(n411), .Y(n508) );
  AOI22X1 U660 ( .A0(res_addr[5]), .A1(n404), .B0(n26), .B1(n479), .Y(n507) );
  AOI22X1 U661 ( .A0(N610), .A1(n406), .B0(N568), .B1(n405), .Y(n506) );
  AOI22X1 U662 ( .A0(N468), .A1(n409), .B0(N806), .B1(n410), .Y(n505) );
  NAND4X1 U663 ( .A(n509), .B(n510), .C(n511), .D(n512), .Y(n333) );
  AOI21X1 U664 ( .A0(N670), .A1(n403), .B0(n411), .Y(n512) );
  AOI22X1 U665 ( .A0(res_addr[6]), .A1(n404), .B0(n25), .B1(n479), .Y(n511) );
  AOI22X1 U666 ( .A0(N611), .A1(n406), .B0(N569), .B1(n405), .Y(n510) );
  AOI22X1 U667 ( .A0(N469), .A1(n409), .B0(N807), .B1(n410), .Y(n509) );
  OAI211X1 U668 ( .A0(n513), .A1(n514), .B0(n515), .C0(n516), .Y(n332) );
  AOI222XL U669 ( .A0(N392), .A1(n517), .B0(N246), .B1(n518), .C0(N330), .C1(
        n519), .Y(n516) );
  OR4X1 U670 ( .A(n521), .B(n522), .C(n523), .D(n524), .Y(n331) );
  AO22X1 U671 ( .A0(n519), .A1(N323), .B0(n518), .B1(N239), .Y(n523) );
  OAI2BB2XL U672 ( .B0(n525), .B1(n526), .A0N(N290), .A1N(n409), .Y(n522) );
  CLKINVX1 U673 ( .A(N295), .Y(n525) );
  OAI2BB2XL U674 ( .B0(n513), .B1(n527), .A0N(n401), .A1N(N250), .Y(n521) );
  OAI211X1 U675 ( .A0(n513), .A1(n528), .B0(n529), .C0(n530), .Y(n330) );
  AOI222XL U676 ( .A0(N391), .A1(n517), .B0(N245), .B1(n518), .C0(N329), .C1(
        n519), .Y(n530) );
  OAI211X1 U677 ( .A0(n513), .A1(n531), .B0(n532), .C0(n533), .Y(n329) );
  AOI222XL U678 ( .A0(N390), .A1(n517), .B0(N244), .B1(n518), .C0(N328), .C1(
        n519), .Y(n533) );
  OAI211X1 U679 ( .A0(n513), .A1(n534), .B0(n535), .C0(n536), .Y(n328) );
  AOI222XL U680 ( .A0(N389), .A1(n517), .B0(N243), .B1(n518), .C0(N327), .C1(
        n519), .Y(n536) );
  OAI211X1 U681 ( .A0(n513), .A1(n537), .B0(n538), .C0(n539), .Y(n327) );
  AOI222XL U682 ( .A0(N388), .A1(n517), .B0(N242), .B1(n518), .C0(N326), .C1(
        n519), .Y(n539) );
  AOI222XL U683 ( .A0(N387), .A1(n517), .B0(N241), .B1(n518), .C0(N325), .C1(
        n519), .Y(n542) );
  OAI211X1 U684 ( .A0(n513), .A1(n543), .B0(n544), .C0(n545), .Y(n325) );
  AOI222XL U685 ( .A0(N386), .A1(n517), .B0(N240), .B1(n518), .C0(N324), .C1(
        n519), .Y(n545) );
  AOI32X1 U686 ( .A0(n551), .A1(n552), .A2(n553), .B0(n554), .B1(n555), .Y(
        n550) );
  OAI21XL U687 ( .A0(n556), .A1(n557), .B0(res_do[6]), .Y(n555) );
  NAND2X1 U688 ( .A(n556), .B(n557), .Y(n554) );
  OAI211X1 U689 ( .A0(n560), .A1(n561), .B0(n562), .C0(n563), .Y(n551) );
  OAI222XL U690 ( .A0(pre_result[3]), .A1(n346), .B0(pre_result[2]), .B1(n564), 
        .C0(n565), .C1(n566), .Y(n562) );
  NAND2X1 U691 ( .A(pre_result[2]), .B(n564), .Y(n560) );
  NAND2X1 U692 ( .A(n513), .B(n548), .Y(n577) );
  NAND2X1 U693 ( .A(n570), .B(n569), .Y(n574) );
  NAND2X1 U694 ( .A(N330), .B(n344), .Y(n569) );
  OAI21XL U695 ( .A0(n344), .A1(N330), .B0(n581), .Y(n570) );
  CLKINVX1 U696 ( .A(n582), .Y(n581) );
  AOI32X1 U697 ( .A0(n583), .A1(n584), .A2(n585), .B0(n586), .B1(n587), .Y(
        n582) );
  OAI21XL U698 ( .A0(n588), .A1(n589), .B0(res_do[6]), .Y(n587) );
  NAND2X1 U699 ( .A(n588), .B(n589), .Y(n586) );
  CLKINVX1 U700 ( .A(N329), .Y(n589) );
  OAI211X1 U701 ( .A0(n590), .A1(n591), .B0(n592), .C0(n593), .Y(n583) );
  OAI222XL U702 ( .A0(N326), .A1(n346), .B0(N325), .B1(n564), .C0(n594), .C1(
        n595), .Y(n592) );
  CLKINVX1 U703 ( .A(n596), .Y(n594) );
  OAI211X1 U704 ( .A0(n597), .A1(N324), .B0(N323), .C0(n598), .Y(n596) );
  CLKINVX1 U705 ( .A(N326), .Y(n591) );
  NAND2X1 U706 ( .A(N325), .B(n564), .Y(n590) );
  NAND2X1 U707 ( .A(n602), .B(n605), .Y(n604) );
  OAI21XL U708 ( .A0(n613), .A1(res_di[6]), .B0(n348), .Y(n612) );
  AOI2BB2X1 U709 ( .B0(n558), .B1(res_di[4]), .A0N(n528), .A1N(res_do[6]), .Y(
        n610) );
  AO21X1 U710 ( .A0(n346), .A1(n614), .B0(res_di[3]), .Y(n616) );
  NOR2X1 U711 ( .A(res_di[1]), .B(n597), .Y(n618) );
  MXI2X1 U712 ( .A(n600), .B(n619), .S0(n620), .Y(n324) );
  AND2X1 U713 ( .A(N257), .B(n344), .Y(n626) );
  AOI22X1 U714 ( .A0(n348), .A1(N256), .B0(n558), .B1(N254), .Y(n629) );
  AO21X1 U715 ( .A0(n346), .A1(n635), .B0(N253), .Y(n637) );
  NOR2X1 U716 ( .A(N251), .B(n597), .Y(n641) );
  AOI211X1 U717 ( .A0(N251), .A1(n597), .B0(n598), .C0(N250), .Y(n640) );
  CLKINVX1 U718 ( .A(N253), .Y(n638) );
  CLKINVX1 U719 ( .A(N252), .Y(n639) );
  OAI22XL U720 ( .A0(N246), .A1(n514), .B0(n642), .B1(n643), .Y(n622) );
  AND2X1 U721 ( .A(N246), .B(n514), .Y(n643) );
  AOI32X1 U722 ( .A0(n644), .A1(n645), .A2(n646), .B0(n647), .B1(n648), .Y(
        n642) );
  OAI21XL U723 ( .A0(n649), .A1(N245), .B0(n528), .Y(n648) );
  NAND2X1 U724 ( .A(n649), .B(N245), .Y(n647) );
  CLKINVX1 U725 ( .A(N244), .Y(n651) );
  CLKINVX1 U726 ( .A(N243), .Y(n650) );
  NAND2X1 U727 ( .A(N244), .B(n531), .Y(n645) );
  AO21X1 U728 ( .A0(n537), .A1(n652), .B0(N242), .Y(n654) );
  OAI222XL U729 ( .A0(res_di[3]), .A1(n655), .B0(res_di[2]), .B1(n656), .C0(
        n657), .C1(n658), .Y(n653) );
  CLKINVX1 U730 ( .A(res_di[0]), .Y(n527) );
  CLKINVX1 U731 ( .A(res_di[1]), .Y(n543) );
  CLKINVX1 U732 ( .A(N242), .Y(n655) );
  CLKINVX1 U733 ( .A(N241), .Y(n656) );
  OAI22XL U734 ( .A0(n487), .A1(n568), .B0(n598), .B1(n659), .Y(n323) );
  OAI22XL U735 ( .A0(n487), .A1(n567), .B0(n597), .B1(n659), .Y(n322) );
  OAI2BB2XL U736 ( .B0(n564), .B1(n659), .A0N(n660), .A1N(pre_result[2]), .Y(
        n321) );
  OAI22XL U737 ( .A0(n487), .A1(n561), .B0(n346), .B1(n659), .Y(n320) );
  OAI2BB2XL U738 ( .B0(n558), .B1(n659), .A0N(n660), .A1N(pre_result[4]), .Y(
        n319) );
  OAI2BB2XL U739 ( .B0(n559), .B1(n659), .A0N(n660), .A1N(pre_result[5]), .Y(
        n318) );
  OAI22XL U740 ( .A0(n487), .A1(n557), .B0(n348), .B1(n659), .Y(n317) );
  OAI22XL U741 ( .A0(n487), .A1(n549), .B0(n344), .B1(n659), .Y(n316) );
  NOR2X1 U742 ( .A(n486), .B(n621), .Y(n660) );
  NAND4X1 U743 ( .A(n662), .B(n663), .C(n664), .D(n665), .Y(n315) );
  AOI22X1 U744 ( .A0(N671), .A1(n403), .B0(res_addr[7]), .B1(n404), .Y(n665)
         );
  AOI22X1 U745 ( .A0(n24), .A1(n479), .B0(N612), .B1(n406), .Y(n664) );
  AOI2BB2X1 U746 ( .B0(N570), .B1(n405), .A0N(n482), .A1N(n483), .Y(n663) );
  AOI22X1 U747 ( .A0(N470), .A1(n409), .B0(N808), .B1(n410), .Y(n662) );
  NAND4X1 U748 ( .A(n666), .B(n667), .C(n668), .D(n669), .Y(n314) );
  AOI21X1 U749 ( .A0(N672), .A1(n403), .B0(n411), .Y(n669) );
  AOI22X1 U750 ( .A0(res_addr[8]), .A1(n404), .B0(n23), .B1(n479), .Y(n668) );
  AOI22X1 U751 ( .A0(N613), .A1(n406), .B0(N571), .B1(n405), .Y(n667) );
  AOI22X1 U752 ( .A0(N471), .A1(n409), .B0(N809), .B1(n410), .Y(n666) );
  NAND4X1 U753 ( .A(n670), .B(n671), .C(n672), .D(n673), .Y(n313) );
  AOI21X1 U754 ( .A0(N673), .A1(n403), .B0(n411), .Y(n673) );
  AOI22X1 U755 ( .A0(res_addr[9]), .A1(n404), .B0(n22), .B1(n479), .Y(n672) );
  AOI22X1 U756 ( .A0(N614), .A1(n406), .B0(N572), .B1(n405), .Y(n671) );
  AOI22X1 U757 ( .A0(N472), .A1(n409), .B0(N810), .B1(n410), .Y(n670) );
  NAND4X1 U758 ( .A(n674), .B(n675), .C(n676), .D(n677), .Y(n312) );
  AOI21X1 U759 ( .A0(N674), .A1(n403), .B0(n411), .Y(n677) );
  AOI22X1 U760 ( .A0(res_addr[10]), .A1(n404), .B0(n21), .B1(n479), .Y(n676)
         );
  AOI22X1 U761 ( .A0(N615), .A1(n406), .B0(N573), .B1(n405), .Y(n675) );
  AOI22X1 U762 ( .A0(N473), .A1(n409), .B0(N811), .B1(n410), .Y(n674) );
  NAND4X1 U763 ( .A(n678), .B(n679), .C(n680), .D(n681), .Y(n311) );
  AOI21X1 U764 ( .A0(N675), .A1(n403), .B0(n411), .Y(n681) );
  AOI22X1 U765 ( .A0(res_addr[11]), .A1(n404), .B0(n20), .B1(n479), .Y(n680)
         );
  AOI22X1 U766 ( .A0(N616), .A1(n406), .B0(N574), .B1(n405), .Y(n679) );
  AOI22X1 U767 ( .A0(N474), .A1(n409), .B0(N812), .B1(n410), .Y(n678) );
  NAND4X1 U768 ( .A(n682), .B(n683), .C(n684), .D(n685), .Y(n310) );
  AOI21X1 U769 ( .A0(N676), .A1(n403), .B0(n411), .Y(n685) );
  AOI22X1 U770 ( .A0(res_addr[12]), .A1(n404), .B0(n19), .B1(n479), .Y(n684)
         );
  AOI22X1 U771 ( .A0(N617), .A1(n406), .B0(N575), .B1(n405), .Y(n683) );
  AOI22X1 U772 ( .A0(N475), .A1(n409), .B0(N813), .B1(n410), .Y(n682) );
  NAND4X1 U773 ( .A(n686), .B(n687), .C(n688), .D(n689), .Y(n309) );
  AOI21X1 U774 ( .A0(N677), .A1(n403), .B0(n411), .Y(n689) );
  OAI21XL U775 ( .A0(n623), .A1(n691), .B0(n412), .Y(n690) );
  AOI22X1 U776 ( .A0(res_addr[13]), .A1(n404), .B0(n18), .B1(n479), .Y(n688)
         );
  NAND3X1 U777 ( .A(n483), .B(n578), .C(n695), .Y(n694) );
  NAND3X1 U778 ( .A(n427), .B(n602), .C(n408), .Y(n693) );
  AO21X1 U779 ( .A0(n696), .A1(n691), .B0(n697), .Y(n692) );
  AOI31X1 U780 ( .A0(n701), .A1(n483), .A2(n695), .B0(n767), .Y(n700) );
  CLKINVX1 U781 ( .A(n407), .Y(n767) );
  OAI21XL U782 ( .A0(n702), .A1(N78), .B0(n703), .Y(n701) );
  CLKINVX1 U783 ( .A(n623), .Y(n602) );
  AOI22X1 U784 ( .A0(N618), .A1(n406), .B0(N576), .B1(n405), .Y(n687) );
  NAND3X1 U785 ( .A(n661), .B(N78), .C(n704), .Y(n697) );
  OAI31XL U786 ( .A0(n600), .A1(n578), .A2(n599), .B0(n705), .Y(n480) );
  NAND4X1 U787 ( .A(n704), .B(n702), .C(n462), .D(n661), .Y(n705) );
  NAND2X1 U788 ( .A(n707), .B(n708), .Y(n483) );
  CLKINVX1 U789 ( .A(n408), .Y(n600) );
  AOI22X1 U790 ( .A0(N476), .A1(n409), .B0(N814), .B1(n410), .Y(n686) );
  OAI221XL U791 ( .A0(n304), .A1(n709), .B0(n548), .B1(n710), .C0(n711), .Y(
        NState[2]) );
  NAND3X1 U792 ( .A(n757), .B(n712), .C(n713), .Y(n711) );
  OAI221XL U793 ( .A0(n756), .A1(n714), .B0(n715), .B1(n548), .C0(n716), .Y(
        NState[1]) );
  AOI33X1 U794 ( .A0(n717), .A1(n718), .A2(n719), .B0(n720), .B1(n571), .B2(
        n721), .Y(n716) );
  NOR3X1 U795 ( .A(n722), .B(res_addr[7]), .C(res_addr[4]), .Y(n721) );
  NOR2BX1 U796 ( .AN(res_addr[8]), .B(n723), .Y(n720) );
  NAND2X1 U797 ( .A(n709), .B(n304), .Y(n548) );
  NOR2X1 U798 ( .A(n712), .B(n699), .Y(n709) );
  CLKINVX1 U799 ( .A(n710), .Y(n715) );
  NAND3X1 U800 ( .A(n429), .B(n345), .C(n707), .Y(n710) );
  NOR4BBX1 U801 ( .AN(n727), .BN(n728), .C(n729), .D(res_addr[7]), .Y(n707) );
  AND4X1 U802 ( .A(res_addr[12]), .B(res_addr[13]), .C(res_addr[8]), .D(
        res_addr[9]), .Y(n728) );
  AND2X1 U803 ( .A(res_addr[10]), .B(res_addr[11]), .Y(n727) );
  MXI2X1 U804 ( .A(n757), .B(fw_finish), .S0(n713), .Y(n714) );
  OAI211X1 U805 ( .A0(n731), .A1(n732), .B0(n407), .C0(n733), .Y(NState[0]) );
  NAND3X1 U806 ( .A(n304), .B(n699), .C(n726), .Y(n733) );
  CLKINVX1 U807 ( .A(n734), .Y(n726) );
  OAI31XL U808 ( .A0(n735), .A1(n736), .A2(n737), .B0(n738), .Y(n734) );
  NAND2X1 U809 ( .A(n429), .B(n758), .Y(n737) );
  NAND3X1 U810 ( .A(n760), .B(n345), .C(n759), .Y(n736) );
  NAND4BX1 U811 ( .AN(n729), .B(cnt[3]), .C(n462), .D(n427), .Y(n735) );
  NAND3X1 U812 ( .A(n462), .B(n703), .C(n702), .Y(n732) );
  CLKINVX1 U813 ( .A(n691), .Y(n702) );
  NAND3BX1 U814 ( .AN(n713), .B(n472), .C(n712), .Y(n731) );
  NOR2X1 U815 ( .A(n706), .B(n739), .Y(n713) );
  OAI31XL U816 ( .A0(n304), .A1(n754), .A2(n757), .B0(n486), .Y(N867) );
  OAI211X1 U817 ( .A0(n757), .A1(fw_finish), .B0(n472), .C0(n712), .Y(n486) );
  NAND2X1 U818 ( .A(n757), .B(fw_finish), .Y(n472) );
  OAI22XL U819 ( .A0(fw_finish), .A1(n712), .B0(n740), .B1(n619), .Y(N854) );
  XNOR2X1 U820 ( .A(cnt[3]), .B(n741), .Y(N75) );
  AO21X1 U821 ( .A0(N78), .A1(n605), .B0(n741), .Y(N74) );
  NAND2X1 U822 ( .A(n691), .B(n605), .Y(N73) );
  NAND2X1 U823 ( .A(N76), .B(n696), .Y(n691) );
  NAND4BBXL U824 ( .AN(n411), .BN(n410), .C(n742), .D(n743), .Y(N196) );
  AOI222XL U825 ( .A0(N142), .A1(n409), .B0(N149), .B1(n402), .C0(N189), .C1(
        n408), .Y(n743) );
  OAI31XL U826 ( .A0(n744), .A1(n578), .A2(n745), .B0(n526), .Y(n465) );
  OR4X1 U827 ( .A(n429), .B(res_addr[1]), .C(res_addr[7]), .D(res_addr[8]), 
        .Y(n746) );
  NAND2X1 U828 ( .A(n695), .B(n738), .Y(n744) );
  NOR2BX1 U829 ( .AN(n706), .B(n482), .Y(n695) );
  CLKINVX1 U830 ( .A(n579), .Y(n725) );
  NOR2X1 U831 ( .A(n740), .B(fw_finish), .Y(n579) );
  CLKINVX1 U832 ( .A(n708), .Y(n723) );
  NOR2X1 U833 ( .A(n345), .B(n429), .Y(n708) );
  NAND4X1 U834 ( .A(res_addr[2]), .B(res_addr[4]), .C(res_addr[3]), .D(n747), 
        .Y(n729) );
  AND2X1 U835 ( .A(res_addr[5]), .B(res_addr[6]), .Y(n747) );
  CLKINVX1 U836 ( .A(n482), .Y(n661) );
  NAND3X1 U837 ( .A(cnt[3]), .B(n741), .C(n748), .Y(n738) );
  AND3X1 U838 ( .A(n758), .B(n760), .C(n759), .Y(n748) );
  NOR2X1 U839 ( .A(N78), .B(n605), .Y(n741) );
  OR2X1 U840 ( .A(N76), .B(n696), .Y(n605) );
  CLKINVX1 U841 ( .A(n427), .Y(n696) );
  CLKINVX1 U842 ( .A(n571), .Y(n576) );
  NOR2X1 U843 ( .A(n740), .B(n304), .Y(n571) );
  NAND2X1 U844 ( .A(n756), .B(n699), .Y(n740) );
  NAND2X1 U845 ( .A(n757), .B(n698), .Y(n482) );
  NOR2X1 U846 ( .A(fw_finish), .B(n756), .Y(n698) );
  NAND4X1 U847 ( .A(n429), .B(n755), .C(res_addr[7]), .D(n749), .Y(n706) );
  NOR4X1 U848 ( .A(res_addr[8]), .B(res_addr[4]), .C(res_addr[1]), .D(n722), 
        .Y(n749) );
  NAND4BBXL U849 ( .AN(res_addr[2]), .BN(res_addr[3]), .C(n750), .D(n751), .Y(
        n722) );
  NOR4X1 U850 ( .A(res_addr[13]), .B(res_addr[12]), .C(res_addr[11]), .D(
        res_addr[10]), .Y(n751) );
  NOR3X1 U851 ( .A(res_addr[5]), .B(res_addr[9]), .C(res_addr[6]), .Y(n750) );
  NAND2X1 U852 ( .A(n752), .B(n753), .Y(n739) );
  NOR4X1 U853 ( .A(res_di[7]), .B(res_di[6]), .C(res_di[5]), .D(res_di[4]), 
        .Y(n753) );
  NOR4X1 U854 ( .A(res_di[3]), .B(res_di[2]), .C(res_di[1]), .D(res_di[0]), 
        .Y(n752) );
  CLKINVX1 U855 ( .A(n621), .Y(n599) );
  NOR3X1 U856 ( .A(N76), .B(n427), .C(n623), .Y(n621) );
  NAND2X1 U857 ( .A(n703), .B(N78), .Y(n623) );
  AND4X1 U858 ( .A(N79), .B(n758), .C(n759), .D(n760), .Y(n703) );
endmodule

