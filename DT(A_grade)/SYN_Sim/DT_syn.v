/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : Q-2019.12
// Date      : Mon Nov  2 17:34:31 2020
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
  input [7:0] A;
  output [7:0] SUM;

  wire   [7:2] carry;

  ADDHXL U1_1_6 ( .A(A[6]), .B(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  ADDHXL U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHXL U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHXL U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHXL U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHXL U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  XOR2XL U1 ( .A(carry[7]), .B(A[7]), .Y(SUM[7]) );
  CLKINVX1 U2 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module DT_DW01_inc_2 ( A, SUM );
  input [9:0] A;
  output [9:0] SUM;

  wire   [9:2] carry;

  ADDHXL U1_1_8 ( .A(A[8]), .B(carry[8]), .CO(carry[9]), .S(SUM[8]) );
  ADDHXL U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHXL U1_1_6 ( .A(A[6]), .B(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  ADDHXL U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHXL U1_1_7 ( .A(A[7]), .B(carry[7]), .CO(carry[8]), .S(SUM[7]) );
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
  CLKINVX1 U3 ( .A(A[11]), .Y(n2) );
  CLKINVX1 U4 ( .A(A[10]), .Y(n3) );
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


module DT_DW01_inc_3 ( A, SUM );
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


module DT_DW01_inc_4 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;

  wire   [7:2] carry;

  ADDHX1 U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  ADDHX1 U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHX1 U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHX1 U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHXL U1_1_6 ( .A(A[6]), .B(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  ADDHX1 U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  XOR2X1 U1 ( .A(carry[7]), .B(A[7]), .Y(SUM[7]) );
  CLKINVX1 U2 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module DT_DW01_inc_5 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;

  wire   [7:2] carry;

  ADDHX1 U1_1_6 ( .A(A[6]), .B(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  ADDHX4 U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHX4 U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  CMPR22X2 U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  CMPR22X2 U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  CMPR22X2 U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  XOR2X1 U1 ( .A(carry[7]), .B(A[7]), .Y(SUM[7]) );
  CLKINVX1 U2 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module DT_DW01_inc_6 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;

  wire   [7:2] carry;

  ADDHX1 U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHXL U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHXL U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHX1 U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  ADDHX1 U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHX1 U1_1_6 ( .A(A[6]), .B(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  XOR2X1 U1 ( .A(carry[7]), .B(A[7]), .Y(SUM[7]) );
  INVXL U2 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module DT_DW01_inc_7 ( A, SUM );
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


module DT_DW01_inc_8 ( A, SUM );
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
  wire   N73, N74, N75, N77, n785, n786, n787, n788, n789, n790, n791, n792,
         n793, n794, n795, n796, n797, n798, n799, n800, n801, n802, n803,
         n804, n805, n806, n807, n808, n809, n810, n811, n812, N142, N144,
         N145, N146, N147, N148, N149, N150, N151, N152, N153, N154, N155,
         N187, N189, N190, N191, N192, N193, N194, N195, N196, N224, N225,
         N226, N227, N228, N229, N230, N231, N232, N233, N239, N240, N241,
         N242, N243, N244, N245, N246, N250, N251, N252, N253, N254, N255,
         N256, N257, N290, N295, N323, N324, N325, N326, N327, N328, N329,
         N330, N357, N358, N359, N360, N361, N362, N363, N364, N385, N386,
         N387, N388, N389, N390, N391, N392, N464, N465, N466, N467, N468,
         N469, N470, N471, N472, N473, N474, N475, N476, N564, N565, N566,
         N567, N568, N569, N570, N571, N572, N573, N574, N575, N576, N606,
         N607, N608, N609, N610, N611, N612, N613, N614, N615, N616, N617,
         N618, N664, N665, N666, N667, N668, N669, N670, N671, N672, N673,
         N674, N675, N676, N677, N801, N803, N804, N805, N806, N807, N808,
         N809, N810, N811, N812, N813, N814, N854, N867, n18, n19, n20, n21,
         n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n288, n289, n290,
         n291, n292, n293, n294, n295, n296, n297, n304, n309, n310, n311,
         n312, n313, n314, n315, n316, n317, n318, n319, n320, n321, n322,
         n323, n324, n325, n326, n327, n328, n329, n330, n331, n332, n333,
         n334, n335, n336, n337, n338, n339, n340, n341, N1194, N1193, N1192,
         N1191, N1190, N1189, N1188, \add_335/carry[2] , \add_335/carry[3] ,
         \add_335/carry[4] , \add_335/carry[5] , \add_335/carry[6] ,
         \add_335/carry[7] , \add_335/carry[8] , \add_335/carry[9] ,
         \add_335/carry[10] , \add_335/carry[11] , \add_335/carry[12] ,
         \add_335/carry[13] , \r497/carry[2] , \r497/carry[3] ,
         \r497/carry[4] , \r497/carry[5] , \r497/carry[6] , \r497/carry[7] ,
         \r497/carry[8] , \r497/carry[9] , \r497/carry[10] , \r497/carry[11] ,
         \r497/carry[12] , \r497/carry[13] , \r496/carry[2] , \r496/carry[3] ,
         \r496/carry[4] , \r496/carry[5] , \r496/carry[6] , \r496/carry[7] ,
         \r496/carry[8] , \r496/carry[9] , \r496/carry[10] , \r496/carry[11] ,
         \r496/carry[12] , \r496/carry[13] , n342, n343, n344, n345, n346,
         n347, n348, n349, n350, n351, n352, n353, n354, n355, n356, n358,
         n360, n362, n364, n366, n367, n369, n371, n375, n377, n379, n381,
         n383, n385, n388, n389, n390, n391, n392, n395, n399, n401, n402,
         n403, n404, n405, n406, n407, n408, n409, n410, n411, n412, n413,
         n414, n415, n416, n417, n418, n419, n420, n421, n422, n423, n424,
         n425, n426, n427, n428, n443, n445, n446, n447, n448, n449, n450,
         n451, n452, n453, n454, n455, n456, n457, n458, n459, n460, n461,
         n462, n463, n464, n465, n466, n467, n468, n469, n470, n471, n472,
         n473, n474, n475, n476, n477, n478, n479, n480, n481, n482, n483,
         n484, n485, n486, n487, n488, n489, n490, n491, n492, n493, n494,
         n495, n496, n497, n498, n499, n500, n501, n502, n503, n504, n505,
         n506, n507, n508, n509, n510, n511, n512, n513, n514, n515, n516,
         n517, n518, n519, n520, n521, n522, n523, n524, n525, n526, n527,
         n528, n529, n530, n531, n532, n533, n534, n535, n536, n537, n538,
         n539, n540, n541, n542, n543, n544, n545, n546, n547, n548, n549,
         n550, n551, n552, n553, n554, n555, n556, n557, n558, n559, n560,
         n561, n562, n563, n564, n565, n566, n567, n568, n569, n570, n571,
         n572, n573, n574, n575, n576, n577, n578, n579, n580, n581, n582,
         n583, n584, n585, n586, n587, n588, n589, n590, n591, n592, n593,
         n594, n595, n596, n597, n598, n599, n600, n601, n602, n603, n604,
         n605, n606, n607, n608, n609, n610, n611, n612, n613, n614, n615,
         n616, n617, n618, n619, n620, n621, n622, n623, n624, n625, n626,
         n627, n628, n629, n630, n631, n632, n633, n634, n635, n636, n637,
         n638, n639, n640, n641, n642, n643, n644, n645, n646, n647, n648,
         n649, n650, n651, n652, n653, n654, n655, n656, n657, n658, n659,
         n660, n661, n662, n663, n664, n665, n666, n667, n668, n669, n670,
         n671, n672, n673, n674, n675, n676, n677, n678, n679, n680, n681,
         n682, n683, n684, n685, n686, n687, n688, n689, n690, n691, n692,
         n693, n694, n695, n696, n697, n698, n699, n700, n701, n702, n703,
         n704, n705, n706, n707, n708, n709, n710, n711, n712, n713, n714,
         n715, n716, n717, n718, n719, n720, n721, n722, n723, n724, n725,
         n726, n727, n728, n729, n730, n731, n732, n733, n734, n735, n736,
         n737, n738, n739, n740, n741, n742, n743, n744, n745, n746, n747,
         n748, n749, n750, n751, n752, n753, n754, n755, n756, n757, n758,
         n759, n760, n761, n762, n763, n764, n765, n766, n767, n768, n769,
         n770, n771, n772, n773, n774, n775, n776, n777, n778, n779, n780,
         n781, n782, n783, n784;
  wire   [2:0] NState;
  wire   [6:0] cnt;
  wire   [7:0] pre_result;
  wire   [14:0] \sub_381/carry ;
  wire   [6:1] \add_122/carry ;

  DT_DW01_inc_0 add_291_2 ( .A(pre_result), .SUM({N392, N391, N390, N389, N388, 
        N387, N386, N385}) );
  DT_DW01_inc_1 add_287 ( .A({res_di[7:5], n353, res_di[3:0]}), .SUM({N364, 
        N363, N362, N361, N360, N359, N358, N357}) );
  DT_DW01_inc_2 add_202 ( .A({n785, n786, n787, n367, n789, n790, n791, n369, 
        n364, n371}), .SUM({N233, N232, N231, N230, N229, N228, N227, N226, 
        N225, N224}) );
  DT_DW01_dec_0 r498 ( .A({res_addr[13:1], n445}), .SUM({N677, N676, N675, 
        N674, N673, N672, N671, N670, N669, N668, N667, N666, N665, N664}) );
  DT_DW01_inc_3 r495 ( .A({res_addr[13:1], n445}), .SUM({n18, n19, n20, n21, 
        n22, n23, n24, n25, n26, n27, n28, n29, n30, n31}) );
  DT_DW01_inc_4 r490 ( .A(pre_result), .SUM({N330, N329, N328, N327, N326, 
        N325, N324, N323}) );
  DT_DW01_inc_5 r483 ( .A({res_di[7:5], n352, res_di[3:0]}), .SUM({N257, N256, 
        N255, N254, N253, N252, N251, N250}) );
  DT_DW01_inc_6 r480 ( .A({n805, res_do[6], n807, n808, n809, n810, n811, n812}), .SUM({N246, N245, N244, N243, N242, N241, N240, N239}) );
  DT_DW01_inc_7 r477 ( .A({cnt[6:2], n443, N142}), .SUM({N155, N154, N153, 
        N152, N151, N150, N149}) );
  DT_DW01_inc_8 add_150_aco ( .A({N1194, N1193, N1192, N1191, N1190, N1189, 
        N1188}), .SUM({N195, N194, N193, N192, N191, N190, N189}) );
  DFFRX1 \cnt_reg[1]  ( .D(n783), .CK(clk), .RN(n355), .Q(cnt[1]), .QN(N77) );
  DFFSX1 \res_addr_reg[4]  ( .D(n335), .CK(clk), .SN(n355), .Q(n801) );
  DFFSX1 \res_addr_reg[5]  ( .D(n334), .CK(clk), .SN(n447), .Q(n800) );
  DFFSX1 \res_addr_reg[6]  ( .D(n333), .CK(clk), .SN(n447), .Q(n799) );
  DFFSX1 \res_addr_reg[2]  ( .D(n337), .CK(clk), .SN(n355), .Q(n803) );
  DFFSX1 \res_addr_reg[3]  ( .D(n336), .CK(clk), .SN(n355), .Q(n802) );
  DFFRX1 \cnt_reg[5]  ( .D(n779), .CK(clk), .RN(reset), .Q(cnt[5]), .QN(n775)
         );
  DFFRX1 \cnt_reg[6]  ( .D(n778), .CK(clk), .RN(reset), .Q(cnt[6]), .QN(n776)
         );
  DFFRX1 \cnt_reg[4]  ( .D(n780), .CK(clk), .RN(n355), .Q(cnt[4]), .QN(n777)
         );
  DFFSX1 \res_addr_reg[1]  ( .D(n338), .CK(clk), .SN(n355), .Q(n804), .QN(n344) );
  DFFRX1 \res_do_reg[1]  ( .D(n325), .CK(clk), .RN(n447), .Q(n811), .QN(n399)
         );
  DFFRX2 \res_do_reg[2]  ( .D(n326), .CK(clk), .RN(n446), .Q(n810), .QN(n582)
         );
  DFFRX1 \res_do_reg[7]  ( .D(n332), .CK(clk), .RN(n355), .Q(n805), .QN(n395)
         );
  DFFRX1 \sti_addr_reg[3]  ( .D(n293), .CK(clk), .RN(n446), .Q(n791), .QN(n392) );
  DFFRX1 \res_do_reg[0]  ( .D(n331), .CK(clk), .RN(n446), .Q(n812), .QN(n385)
         );
  DFFRX1 \sti_addr_reg[7]  ( .D(n289), .CK(clk), .RN(n447), .Q(n787), .QN(n383) );
  DFFRX1 \sti_addr_reg[9]  ( .D(n297), .CK(clk), .RN(n446), .Q(n785), .QN(n381) );
  DFFRX1 \sti_addr_reg[4]  ( .D(n292), .CK(clk), .RN(n446), .Q(n790), .QN(n379) );
  DFFRX1 \sti_addr_reg[5]  ( .D(n291), .CK(clk), .RN(n355), .Q(n789), .QN(n377) );
  DFFRX1 \sti_addr_reg[8]  ( .D(n288), .CK(clk), .RN(n446), .Q(n786), .QN(n375) );
  DFFSRX2 \PState_reg[2]  ( .D(NState[2]), .CK(clk), .SN(1'b1), .RN(n355), 
        .QN(n304) );
  DFFRX1 \cnt_reg[3]  ( .D(n781), .CK(clk), .RN(n447), .Q(cnt[3]), .QN(n770)
         );
  DFFRX1 jump_flag_reg ( .D(n339), .CK(clk), .RN(n355), .Q(n772), .QN(n501) );
  DFFRX1 \pre_result_reg[5]  ( .D(n318), .CK(clk), .RN(n447), .Q(pre_result[5]) );
  DFFRX1 \pre_result_reg[4]  ( .D(n319), .CK(clk), .RN(n447), .Q(pre_result[4]) );
  DFFRX1 \pre_result_reg[2]  ( .D(n321), .CK(clk), .RN(n446), .Q(pre_result[2]) );
  DFFRX1 \pre_result_reg[7]  ( .D(n316), .CK(clk), .RN(n446), .Q(pre_result[7]), .QN(n566) );
  DFFRX1 \pre_result_reg[6]  ( .D(n317), .CK(clk), .RN(n446), .Q(pre_result[6]), .QN(n574) );
  DFFRX1 \pre_result_reg[3]  ( .D(n320), .CK(clk), .RN(n447), .Q(pre_result[3]), .QN(n578) );
  DFFRX1 \pre_result_reg[1]  ( .D(n322), .CK(clk), .RN(n446), .Q(pre_result[1]), .QN(n585) );
  DFFRX1 \pre_result_reg[0]  ( .D(n323), .CK(clk), .RN(reset), .Q(
        pre_result[0]), .QN(n586) );
  DFFRX1 \PState_reg[0]  ( .D(NState[0]), .CK(clk), .RN(reset), .Q(n773), .QN(
        n729) );
  DFFRX1 comp_flag_reg ( .D(n324), .CK(clk), .RN(n446), .Q(n771), .QN(n636) );
  DFFRX1 \res_do_reg[6]  ( .D(n330), .CK(clk), .RN(n446), .Q(n806), .QN(n347)
         );
  DFFRX1 \res_addr_reg[13]  ( .D(n309), .CK(clk), .RN(n447), .Q(n792) );
  DFFRX1 \res_addr_reg[12]  ( .D(n310), .CK(clk), .RN(n446), .Q(n793) );
  DFFRX1 \res_addr_reg[11]  ( .D(n311), .CK(clk), .RN(n447), .Q(n794) );
  DFFRX1 \res_addr_reg[10]  ( .D(n312), .CK(clk), .RN(n447), .Q(n795) );
  DFFRX1 \res_addr_reg[9]  ( .D(n313), .CK(clk), .RN(n447), .Q(n796) );
  DFFRX1 \res_addr_reg[8]  ( .D(n314), .CK(clk), .RN(n447), .Q(n797) );
  DFFRX1 \res_addr_reg[7]  ( .D(n315), .CK(clk), .RN(n447), .Q(n798) );
  DFFRX1 \res_addr_reg[0]  ( .D(n340), .CK(clk), .RN(reset), .Q(N801), .QN(
        n349) );
  DFFRHQX1 done_reg ( .D(n341), .CK(clk), .RN(n355), .Q(n391) );
  DFFRHQX1 res_wr_reg ( .D(N854), .CK(clk), .RN(n447), .Q(n389) );
  DFFRHQX1 res_rd_reg ( .D(N867), .CK(clk), .RN(n447), .Q(n390) );
  DFFRHQX1 sti_rd_reg ( .D(n784), .CK(clk), .RN(n446), .Q(n388) );
  DFFRX2 \res_do_reg[3]  ( .D(n327), .CK(clk), .RN(n447), .Q(n809), .QN(n581)
         );
  DFFRX2 \cnt_reg[0]  ( .D(N196), .CK(clk), .RN(n355), .Q(N142), .QN(n464) );
  DFFRX2 \res_do_reg[5]  ( .D(n329), .CK(clk), .RN(n446), .Q(n807), .QN(n576)
         );
  DFFRX2 \cnt_reg[2]  ( .D(n782), .CK(clk), .RN(n446), .Q(cnt[2]), .QN(n719)
         );
  DFFRX2 \res_do_reg[4]  ( .D(n328), .CK(clk), .RN(n446), .Q(n808), .QN(n575)
         );
  DFFRX2 \PState_reg[1]  ( .D(NState[1]), .CK(clk), .RN(n355), .Q(n774), .QN(
        n715) );
  DFFSX1 \sti_addr_reg[2]  ( .D(n294), .CK(clk), .SN(n355), .QN(n346) );
  DFFSX1 \sti_addr_reg[1]  ( .D(n295), .CK(clk), .SN(n355), .QN(n343) );
  DFFSX1 \sti_addr_reg[0]  ( .D(n296), .CK(clk), .SN(n355), .QN(n342) );
  DFFRHQX1 \sti_addr_reg[6]  ( .D(n290), .CK(clk), .RN(n355), .Q(n788) );
  INVX1 U295 ( .A(n353), .Y(n551) );
  AOI32X1 U296 ( .A0(n644), .A1(n645), .A2(n646), .B0(n647), .B1(n648), .Y(
        n642) );
  NAND2X6 U297 ( .A(N255), .B(n576), .Y(n645) );
  NAND2X4 U298 ( .A(n416), .B(n347), .Y(n648) );
  OR2X2 U299 ( .A(n642), .B(n643), .Y(n402) );
  OAI222XL U300 ( .A0(n809), .A1(n554), .B0(n810), .B1(n557), .C0(n634), .C1(
        n635), .Y(n632) );
  OAI222XL U301 ( .A0(n809), .A1(n655), .B0(n810), .B1(n656), .C0(n657), .C1(
        n658), .Y(n653) );
  NAND2X2 U302 ( .A(n414), .B(n415), .Y(n416) );
  AND2X2 U303 ( .A(n403), .B(n409), .Y(n593) );
  OR2X1 U304 ( .A(n623), .B(n624), .Y(n407) );
  INVX3 U305 ( .A(n350), .Y(n351) );
  INVX16 U306 ( .A(n304), .Y(fw_finish) );
  NAND2X1 U307 ( .A(n404), .B(n547), .Y(n330) );
  OA21X2 U308 ( .A0(n529), .A1(n545), .B0(n546), .Y(n404) );
  CLKAND2X3 U309 ( .A(n405), .B(n406), .Y(n546) );
  NOR2X1 U310 ( .A(n410), .B(n411), .Y(n561) );
  CLKINVX1 U311 ( .A(n350), .Y(n352) );
  NOR2X1 U312 ( .A(n537), .B(n345), .Y(n409) );
  AND2X4 U313 ( .A(n597), .B(n424), .Y(n537) );
  OR2X1 U314 ( .A(n595), .B(n596), .Y(n345) );
  AND2X2 U315 ( .A(n488), .B(n423), .Y(n348) );
  CLKBUFX3 U316 ( .A(N801), .Y(n445) );
  INVX12 U317 ( .A(res_di[4]), .Y(n350) );
  INVX1 U318 ( .A(n350), .Y(n353) );
  INVXL U319 ( .A(reset), .Y(n354) );
  INVX3 U320 ( .A(n354), .Y(n355) );
  XOR2XL U321 ( .A(cnt[3]), .B(\add_122/carry [3]), .Y(N145) );
  XNOR2XL U322 ( .A(cnt[3]), .B(n757), .Y(N75) );
  NAND4BXL U323 ( .AN(n746), .B(cnt[3]), .C(cnt[2]), .D(n443), .Y(n751) );
  AOI32XL U324 ( .A0(N327), .A1(n575), .A2(n602), .B0(n576), .B1(N328), .Y(
        n606) );
  INVXL U325 ( .A(n388), .Y(n356) );
  INVX12 U326 ( .A(n356), .Y(sti_rd) );
  INVXL U327 ( .A(n390), .Y(n358) );
  INVX12 U328 ( .A(n358), .Y(res_rd) );
  INVXL U329 ( .A(n389), .Y(n360) );
  INVX12 U330 ( .A(n360), .Y(res_wr) );
  INVXL U331 ( .A(n391), .Y(n362) );
  INVX12 U332 ( .A(n362), .Y(done) );
  INVXL U333 ( .A(n343), .Y(n364) );
  INVX16 U334 ( .A(n343), .Y(sti_addr[1]) );
  CLKINVX1 U335 ( .A(n788), .Y(n366) );
  INVXL U336 ( .A(n366), .Y(n367) );
  INVX16 U337 ( .A(n366), .Y(sti_addr[6]) );
  INVXL U338 ( .A(n346), .Y(n369) );
  INVX16 U339 ( .A(n346), .Y(sti_addr[2]) );
  INVXL U340 ( .A(n342), .Y(n371) );
  INVX16 U341 ( .A(n342), .Y(sti_addr[0]) );
  INVX12 U343 ( .A(n375), .Y(sti_addr[8]) );
  INVX12 U344 ( .A(n377), .Y(sti_addr[5]) );
  AOI2BB1X2 U345 ( .A0N(n563), .A1N(n564), .B0(n565), .Y(n534) );
  AOI21X1 U346 ( .A0(n805), .A1(n566), .B0(n567), .Y(n564) );
  INVX12 U347 ( .A(n379), .Y(sti_addr[4]) );
  INVX12 U348 ( .A(n381), .Y(sti_addr[9]) );
  NOR3X2 U349 ( .A(n563), .B(n564), .C(n565), .Y(n535) );
  INVX12 U350 ( .A(n383), .Y(sti_addr[7]) );
  INVX16 U351 ( .A(n385), .Y(res_do[0]) );
  NAND4X1 U352 ( .A(n540), .B(n539), .C(n538), .D(n541), .Y(n331) );
  INVX12 U353 ( .A(n576), .Y(res_do[5]) );
  OAI21X1 U354 ( .A0(n740), .A1(n746), .B0(n596), .Y(n544) );
  INVX12 U355 ( .A(n392), .Y(sti_addr[3]) );
  INVX12 U356 ( .A(n575), .Y(res_do[4]) );
  AOI2BB2XL U357 ( .B0(n347), .B1(N256), .A0N(n808), .A1N(n650), .Y(n646) );
  INVX12 U358 ( .A(n395), .Y(res_do[7]) );
  NOR2XL U359 ( .A(n805), .B(n530), .Y(n624) );
  INVX12 U360 ( .A(n581), .Y(res_do[3]) );
  INVX12 U361 ( .A(n582), .Y(res_do[2]) );
  NAND2XL U362 ( .A(n810), .B(n656), .Y(n652) );
  NAND2XL U363 ( .A(n810), .B(n557), .Y(n631) );
  INVX16 U364 ( .A(n399), .Y(res_do[1]) );
  AND2XL U365 ( .A(res_do[1]), .B(n536), .Y(n410) );
  OAI21X2 U366 ( .A0(n424), .A1(n678), .B0(n503), .Y(n676) );
  INVX3 U367 ( .A(n677), .Y(n503) );
  AND2X2 U368 ( .A(n529), .B(n565), .Y(n403) );
  NAND2XL U369 ( .A(n649), .B(N256), .Y(n647) );
  NAND4XL U370 ( .A(n721), .B(n718), .C(cnt[2]), .D(n678), .Y(n722) );
  NAND2X8 U371 ( .A(n348), .B(n591), .Y(n536) );
  OR2X1 U372 ( .A(N257), .B(n598), .Y(n401) );
  NAND2X2 U373 ( .A(n401), .B(n402), .Y(n641) );
  OA21X2 U374 ( .A0(n443), .A1(n640), .B0(n641), .Y(n597) );
  NOR2X4 U375 ( .A(n616), .B(n755), .Y(n595) );
  BUFX16 U376 ( .A(n806), .Y(res_do[6]) );
  NAND2XL U377 ( .A(res_do[6]), .B(n536), .Y(n405) );
  NAND2XL U378 ( .A(N363), .B(n537), .Y(n406) );
  OA22X4 U379 ( .A0(n616), .A1(n617), .B0(n618), .B1(n498), .Y(n529) );
  OR2X1 U380 ( .A(res_di[7]), .B(n598), .Y(n408) );
  AOI32X1 U381 ( .A0(n625), .A1(n626), .A2(n627), .B0(n628), .B1(n629), .Y(
        n623) );
  AND2XL U382 ( .A(res_do[0]), .B(n536), .Y(n413) );
  NOR2X1 U383 ( .A(n412), .B(n413), .Y(n540) );
  AOI22XL U384 ( .A0(n807), .A1(n536), .B0(N362), .B1(n537), .Y(n549) );
  AOI22XL U385 ( .A0(n805), .A1(n536), .B0(N364), .B1(n537), .Y(n531) );
  AOI22XL U386 ( .A0(n810), .A1(n536), .B0(N359), .B1(n537), .Y(n558) );
  AOI22XL U387 ( .A0(n808), .A1(n536), .B0(N361), .B1(n537), .Y(n552) );
  AOI22XL U388 ( .A0(n809), .A1(n536), .B0(N360), .B1(n537), .Y(n555) );
  OAI21XL U389 ( .A0(n630), .A1(res_di[6]), .B0(n347), .Y(n629) );
  AND3XL U390 ( .A(sti_addr[1]), .B(n785), .C(sti_addr[0]), .Y(n734) );
  MX2XL U391 ( .A(N224), .B(sti_addr[0]), .S0(n423), .Y(n296) );
  NAND2X6 U392 ( .A(n407), .B(n408), .Y(n620) );
  AOI32X2 U393 ( .A0(n443), .A1(n619), .A2(n464), .B0(n620), .B1(n621), .Y(
        n618) );
  CLKBUFX3 U394 ( .A(n495), .Y(n419) );
  AOI222XL U395 ( .A0(N148), .A1(n425), .B0(N155), .B1(n417), .C0(N195), .C1(
        n424), .Y(n479) );
  AOI2BB2XL U396 ( .B0(N357), .B1(n537), .A0N(n529), .A1N(n542), .Y(n539) );
  CLKINVX1 U397 ( .A(N256), .Y(n415) );
  NAND2XL U398 ( .A(N244), .B(n548), .Y(n662) );
  OAI211X1 U399 ( .A0(n529), .A1(n560), .B0(n561), .C0(n562), .Y(n325) );
  NAND2X1 U400 ( .A(n630), .B(res_di[6]), .Y(n628) );
  INVX4 U401 ( .A(n649), .Y(n414) );
  OAI2BB1XL U402 ( .A0N(n609), .A1N(n608), .B0(n581), .Y(n611) );
  AOI32XL U403 ( .A0(n808), .A1(n551), .A2(n626), .B0(n548), .B1(n807), .Y(
        n630) );
  NOR2XL U404 ( .A(res_do[1]), .B(n585), .Y(n584) );
  AOI211XL U405 ( .A0(n811), .A1(n585), .B0(n586), .C0(res_do[0]), .Y(n583) );
  INVX1 U406 ( .A(n811), .Y(n615) );
  AO21XL U407 ( .A0(n578), .A1(n577), .B0(n809), .Y(n580) );
  INVX1 U408 ( .A(n805), .Y(n598) );
  MX2XL U409 ( .A(N233), .B(n785), .S0(n423), .Y(n297) );
  NOR2BXL U410 ( .AN(N324), .B(res_do[1]), .Y(n613) );
  NOR2XL U411 ( .A(n566), .B(n805), .Y(n563) );
  MX2XL U412 ( .A(N231), .B(n787), .S0(n423), .Y(n289) );
  MX2XL U413 ( .A(N230), .B(sti_addr[6]), .S0(n423), .Y(n290) );
  MX2XL U414 ( .A(N232), .B(n786), .S0(n423), .Y(n288) );
  NOR3XL U415 ( .A(n742), .B(n791), .C(n743), .Y(n735) );
  MX2XL U416 ( .A(N226), .B(sti_addr[2]), .S0(n423), .Y(n294) );
  MX2XL U417 ( .A(N225), .B(sti_addr[1]), .S0(n423), .Y(n295) );
  MX2XL U418 ( .A(N227), .B(n791), .S0(n423), .Y(n293) );
  MX2XL U419 ( .A(N229), .B(n789), .S0(n423), .Y(n291) );
  MX2XL U420 ( .A(N228), .B(n790), .S0(n423), .Y(n292) );
  AND4XL U421 ( .A(n741), .B(n786), .C(sti_addr[6]), .D(n787), .Y(n736) );
  AND3XL U422 ( .A(n790), .B(sti_addr[2]), .C(n789), .Y(n741) );
  AND2XL U423 ( .A(N358), .B(n537), .Y(n411) );
  AND2X2 U424 ( .A(N385), .B(n533), .Y(n412) );
  AND3X2 U425 ( .A(n587), .B(n588), .C(n589), .Y(n533) );
  AND4XL U426 ( .A(n720), .B(n499), .C(n723), .D(n428), .Y(n721) );
  NOR4BXL U427 ( .AN(res_addr[4]), .B(n762), .C(n755), .D(n739), .Y(n761) );
  NAND2XL U428 ( .A(res_di[5]), .B(n576), .Y(n626) );
  INVX1 U429 ( .A(res_di[3]), .Y(n554) );
  INVX1 U430 ( .A(res_di[6]), .Y(n545) );
  INVX1 U431 ( .A(res_di[7]), .Y(n530) );
  AND2X2 U432 ( .A(N142), .B(n428), .Y(N1188) );
  INVXL U433 ( .A(res_di[5]), .Y(n548) );
  INVXL U434 ( .A(res_di[2]), .Y(n557) );
  AND2XL U435 ( .A(n428), .B(cnt[6]), .Y(N1194) );
  INVX1 U436 ( .A(n479), .Y(n778) );
  INVX1 U437 ( .A(n483), .Y(n779) );
  INVX1 U438 ( .A(n484), .Y(n780) );
  AOI32XL U439 ( .A0(n352), .A1(n667), .A2(n662), .B0(n668), .B1(res_di[5]), 
        .Y(n666) );
  OAI2BB1XL U440 ( .A0N(n754), .A1N(n428), .B0(n678), .Y(n758) );
  AOI2BB2XL U441 ( .B0(N245), .B1(n545), .A0N(n352), .A1N(n667), .Y(n663) );
  NAND2XL U442 ( .A(res_di[2]), .B(n673), .Y(n669) );
  MXI2X4 U443 ( .A(n592), .B(n593), .S0(n594), .Y(n591) );
  CLKBUFX3 U444 ( .A(N187), .Y(n428) );
  CLKINVX1 U445 ( .A(n595), .Y(N187) );
  CLKINVX1 U446 ( .A(N73), .Y(n463) );
  CLKINVX1 U447 ( .A(N74), .Y(n462) );
  BUFX4 U448 ( .A(n480), .Y(n425) );
  NOR3X1 U449 ( .A(n746), .B(n740), .C(n742), .Y(n480) );
  NAND4XL U450 ( .A(n709), .B(n710), .C(n711), .D(n544), .Y(n495) );
  CLKBUFX3 U451 ( .A(n493), .Y(n418) );
  AND2X2 U452 ( .A(n707), .B(n424), .Y(n493) );
  CLKBUFX3 U453 ( .A(n494), .Y(n420) );
  OAI221XL U454 ( .A0(n714), .A1(n715), .B0(n619), .B1(n617), .C0(n716), .Y(
        n494) );
  CLKBUFX3 U455 ( .A(n508), .Y(n427) );
  NOR2X1 U456 ( .A(n723), .B(n498), .Y(n508) );
  CLKBUFX3 U457 ( .A(n590), .Y(n423) );
  NAND2X1 U458 ( .A(n714), .B(n715), .Y(n590) );
  CLKBUFX3 U459 ( .A(n496), .Y(n422) );
  CLKBUFX3 U460 ( .A(n497), .Y(n421) );
  OAI32X1 U461 ( .A0(n713), .A1(n443), .A2(n464), .B0(n594), .B1(n636), .Y(
        n497) );
  BUFX16 U462 ( .A(n804), .Y(res_addr[1]) );
  BUFX16 U463 ( .A(n803), .Y(res_addr[2]) );
  BUFX16 U464 ( .A(n802), .Y(res_addr[3]) );
  BUFX16 U465 ( .A(n798), .Y(res_addr[7]) );
  BUFX16 U466 ( .A(n801), .Y(res_addr[4]) );
  BUFX16 U467 ( .A(n797), .Y(res_addr[8]) );
  BUFX16 U468 ( .A(n793), .Y(res_addr[12]) );
  BUFX16 U469 ( .A(n796), .Y(res_addr[9]) );
  BUFX16 U470 ( .A(n799), .Y(res_addr[6]) );
  BUFX16 U471 ( .A(n800), .Y(res_addr[5]) );
  BUFX16 U472 ( .A(n794), .Y(res_addr[11]) );
  BUFX16 U473 ( .A(n795), .Y(res_addr[10]) );
  BUFX16 U474 ( .A(n792), .Y(res_addr[13]) );
  BUFX12 U475 ( .A(N801), .Y(res_addr[0]) );
  CLKBUFX3 U476 ( .A(cnt[1]), .Y(n443) );
  CLKBUFX3 U477 ( .A(n500), .Y(n426) );
  NOR2X1 U478 ( .A(n594), .B(n771), .Y(n500) );
  CLKBUFX3 U479 ( .A(n482), .Y(n424) );
  NOR3X1 U480 ( .A(n774), .B(n773), .C(n304), .Y(n482) );
  CLKBUFX3 U481 ( .A(n355), .Y(n447) );
  CLKBUFX3 U482 ( .A(n355), .Y(n446) );
  CLKBUFX3 U483 ( .A(n481), .Y(n417) );
  AOI32X4 U484 ( .A0(n808), .A1(n650), .A2(n645), .B0(n651), .B1(n807), .Y(
        n649) );
  INVXL U485 ( .A(N255), .Y(n651) );
  XNOR2X1 U486 ( .A(res_addr[13]), .B(\r496/carry[13] ), .Y(N576) );
  OR2X1 U487 ( .A(res_addr[12]), .B(\r496/carry[12] ), .Y(\r496/carry[13] ) );
  XNOR2X1 U488 ( .A(\r496/carry[12] ), .B(res_addr[12]), .Y(N575) );
  OR2X1 U489 ( .A(res_addr[11]), .B(\r496/carry[11] ), .Y(\r496/carry[12] ) );
  XNOR2X1 U490 ( .A(\r496/carry[11] ), .B(res_addr[11]), .Y(N574) );
  OR2X1 U491 ( .A(res_addr[10]), .B(\r496/carry[10] ), .Y(\r496/carry[11] ) );
  XNOR2X1 U492 ( .A(\r496/carry[10] ), .B(res_addr[10]), .Y(N573) );
  OR2X1 U493 ( .A(res_addr[9]), .B(\r496/carry[9] ), .Y(\r496/carry[10] ) );
  XNOR2X1 U494 ( .A(\r496/carry[9] ), .B(res_addr[9]), .Y(N572) );
  OR2X1 U495 ( .A(res_addr[8]), .B(\r496/carry[8] ), .Y(\r496/carry[9] ) );
  XNOR2X1 U496 ( .A(\r496/carry[8] ), .B(res_addr[8]), .Y(N571) );
  AND2X1 U497 ( .A(\r496/carry[7] ), .B(res_addr[7]), .Y(\r496/carry[8] ) );
  XOR2X1 U498 ( .A(res_addr[7]), .B(\r496/carry[7] ), .Y(N570) );
  OR2X1 U499 ( .A(res_addr[6]), .B(\r496/carry[6] ), .Y(\r496/carry[7] ) );
  XNOR2X1 U500 ( .A(\r496/carry[6] ), .B(res_addr[6]), .Y(N569) );
  OR2X1 U501 ( .A(res_addr[5]), .B(\r496/carry[5] ), .Y(\r496/carry[6] ) );
  XNOR2X1 U502 ( .A(\r496/carry[5] ), .B(res_addr[5]), .Y(N568) );
  OR2X1 U503 ( .A(res_addr[4]), .B(\r496/carry[4] ), .Y(\r496/carry[5] ) );
  XNOR2X1 U504 ( .A(\r496/carry[4] ), .B(res_addr[4]), .Y(N567) );
  OR2X1 U505 ( .A(res_addr[3]), .B(\r496/carry[3] ), .Y(\r496/carry[4] ) );
  XNOR2X1 U506 ( .A(\r496/carry[3] ), .B(res_addr[3]), .Y(N566) );
  OR2X1 U507 ( .A(res_addr[2]), .B(\r496/carry[2] ), .Y(\r496/carry[3] ) );
  XNOR2X1 U508 ( .A(\r496/carry[2] ), .B(res_addr[2]), .Y(N565) );
  OR2X1 U509 ( .A(res_addr[1]), .B(n445), .Y(\r496/carry[2] ) );
  XNOR2X1 U510 ( .A(n445), .B(res_addr[1]), .Y(N564) );
  XOR2X1 U511 ( .A(res_addr[13]), .B(\r497/carry[13] ), .Y(N618) );
  AND2X1 U512 ( .A(\r497/carry[12] ), .B(res_addr[12]), .Y(\r497/carry[13] )
         );
  XOR2X1 U513 ( .A(res_addr[12]), .B(\r497/carry[12] ), .Y(N617) );
  AND2X1 U514 ( .A(\r497/carry[11] ), .B(res_addr[11]), .Y(\r497/carry[12] )
         );
  XOR2X1 U515 ( .A(res_addr[11]), .B(\r497/carry[11] ), .Y(N616) );
  AND2X1 U516 ( .A(\r497/carry[10] ), .B(res_addr[10]), .Y(\r497/carry[11] )
         );
  XOR2X1 U517 ( .A(res_addr[10]), .B(\r497/carry[10] ), .Y(N615) );
  AND2X1 U518 ( .A(\r497/carry[9] ), .B(res_addr[9]), .Y(\r497/carry[10] ) );
  XOR2X1 U519 ( .A(res_addr[9]), .B(\r497/carry[9] ), .Y(N614) );
  AND2X1 U520 ( .A(\r497/carry[8] ), .B(res_addr[8]), .Y(\r497/carry[9] ) );
  XOR2X1 U521 ( .A(res_addr[8]), .B(\r497/carry[8] ), .Y(N613) );
  AND2X1 U522 ( .A(\r497/carry[7] ), .B(res_addr[7]), .Y(\r497/carry[8] ) );
  XOR2X1 U523 ( .A(res_addr[7]), .B(\r497/carry[7] ), .Y(N612) );
  OR2X1 U524 ( .A(res_addr[6]), .B(\r497/carry[6] ), .Y(\r497/carry[7] ) );
  XNOR2X1 U525 ( .A(\r497/carry[6] ), .B(res_addr[6]), .Y(N611) );
  OR2X1 U526 ( .A(res_addr[5]), .B(\r497/carry[5] ), .Y(\r497/carry[6] ) );
  XNOR2X1 U527 ( .A(\r497/carry[5] ), .B(res_addr[5]), .Y(N610) );
  OR2X1 U528 ( .A(res_addr[4]), .B(\r497/carry[4] ), .Y(\r497/carry[5] ) );
  XNOR2X1 U529 ( .A(\r497/carry[4] ), .B(res_addr[4]), .Y(N609) );
  OR2X1 U530 ( .A(res_addr[3]), .B(\r497/carry[3] ), .Y(\r497/carry[4] ) );
  XNOR2X1 U531 ( .A(\r497/carry[3] ), .B(res_addr[3]), .Y(N608) );
  OR2X1 U532 ( .A(res_addr[2]), .B(\r497/carry[2] ), .Y(\r497/carry[3] ) );
  XNOR2X1 U533 ( .A(\r497/carry[2] ), .B(res_addr[2]), .Y(N607) );
  OR2X1 U534 ( .A(res_addr[1]), .B(n445), .Y(\r497/carry[2] ) );
  XNOR2X1 U535 ( .A(n445), .B(res_addr[1]), .Y(N606) );
  XNOR2X1 U536 ( .A(res_addr[13]), .B(\sub_381/carry [13]), .Y(N814) );
  OR2X1 U537 ( .A(res_addr[12]), .B(\sub_381/carry [12]), .Y(
        \sub_381/carry [13]) );
  XNOR2X1 U538 ( .A(\sub_381/carry [12]), .B(res_addr[12]), .Y(N813) );
  OR2X1 U539 ( .A(res_addr[11]), .B(\sub_381/carry [11]), .Y(
        \sub_381/carry [12]) );
  XNOR2X1 U540 ( .A(\sub_381/carry [11]), .B(res_addr[11]), .Y(N812) );
  OR2X1 U541 ( .A(res_addr[10]), .B(\sub_381/carry [10]), .Y(
        \sub_381/carry [11]) );
  XNOR2X1 U542 ( .A(\sub_381/carry [10]), .B(res_addr[10]), .Y(N811) );
  OR2X1 U543 ( .A(res_addr[9]), .B(\sub_381/carry [9]), .Y(\sub_381/carry [10]) );
  XNOR2X1 U544 ( .A(\sub_381/carry [9]), .B(res_addr[9]), .Y(N810) );
  OR2X1 U545 ( .A(res_addr[8]), .B(\sub_381/carry [8]), .Y(\sub_381/carry [9])
         );
  XNOR2X1 U546 ( .A(\sub_381/carry [8]), .B(res_addr[8]), .Y(N809) );
  AND2X1 U547 ( .A(\sub_381/carry [7]), .B(res_addr[7]), .Y(\sub_381/carry [8]) );
  XOR2X1 U548 ( .A(res_addr[7]), .B(\sub_381/carry [7]), .Y(N808) );
  OR2X1 U549 ( .A(res_addr[6]), .B(\sub_381/carry [6]), .Y(\sub_381/carry [7])
         );
  XNOR2X1 U550 ( .A(\sub_381/carry [6]), .B(res_addr[6]), .Y(N807) );
  OR2X1 U551 ( .A(res_addr[5]), .B(\sub_381/carry [5]), .Y(\sub_381/carry [6])
         );
  XNOR2X1 U552 ( .A(\sub_381/carry [5]), .B(res_addr[5]), .Y(N806) );
  OR2X1 U553 ( .A(res_addr[4]), .B(\sub_381/carry [4]), .Y(\sub_381/carry [5])
         );
  XNOR2X1 U554 ( .A(\sub_381/carry [4]), .B(res_addr[4]), .Y(N805) );
  OR2X1 U555 ( .A(res_addr[3]), .B(\sub_381/carry [3]), .Y(\sub_381/carry [4])
         );
  XNOR2X1 U556 ( .A(\sub_381/carry [3]), .B(res_addr[3]), .Y(N804) );
  OR2X1 U557 ( .A(res_addr[2]), .B(res_addr[1]), .Y(\sub_381/carry [3]) );
  XNOR2X1 U558 ( .A(res_addr[1]), .B(res_addr[2]), .Y(N803) );
  XOR2X1 U559 ( .A(res_addr[13]), .B(\add_335/carry[13] ), .Y(N476) );
  AND2X1 U560 ( .A(\add_335/carry[12] ), .B(res_addr[12]), .Y(
        \add_335/carry[13] ) );
  XOR2X1 U561 ( .A(res_addr[12]), .B(\add_335/carry[12] ), .Y(N475) );
  AND2X1 U562 ( .A(\add_335/carry[11] ), .B(res_addr[11]), .Y(
        \add_335/carry[12] ) );
  XOR2X1 U563 ( .A(res_addr[11]), .B(\add_335/carry[11] ), .Y(N474) );
  AND2X1 U564 ( .A(\add_335/carry[10] ), .B(res_addr[10]), .Y(
        \add_335/carry[11] ) );
  XOR2X1 U565 ( .A(res_addr[10]), .B(\add_335/carry[10] ), .Y(N473) );
  AND2X1 U566 ( .A(\add_335/carry[9] ), .B(res_addr[9]), .Y(
        \add_335/carry[10] ) );
  XOR2X1 U567 ( .A(res_addr[9]), .B(\add_335/carry[9] ), .Y(N472) );
  AND2X1 U568 ( .A(\add_335/carry[8] ), .B(res_addr[8]), .Y(\add_335/carry[9] ) );
  XOR2X1 U569 ( .A(res_addr[8]), .B(\add_335/carry[8] ), .Y(N471) );
  AND2X1 U570 ( .A(\add_335/carry[7] ), .B(res_addr[7]), .Y(\add_335/carry[8] ) );
  XOR2X1 U571 ( .A(res_addr[7]), .B(\add_335/carry[7] ), .Y(N470) );
  AND2X1 U572 ( .A(\add_335/carry[6] ), .B(res_addr[6]), .Y(\add_335/carry[7] ) );
  XOR2X1 U573 ( .A(res_addr[6]), .B(\add_335/carry[6] ), .Y(N469) );
  AND2X1 U574 ( .A(\add_335/carry[5] ), .B(res_addr[5]), .Y(\add_335/carry[6] ) );
  XOR2X1 U575 ( .A(res_addr[5]), .B(\add_335/carry[5] ), .Y(N468) );
  AND2X1 U576 ( .A(\add_335/carry[4] ), .B(res_addr[4]), .Y(\add_335/carry[5] ) );
  XOR2X1 U577 ( .A(res_addr[4]), .B(\add_335/carry[4] ), .Y(N467) );
  AND2X1 U578 ( .A(\add_335/carry[3] ), .B(res_addr[3]), .Y(\add_335/carry[4] ) );
  XOR2X1 U579 ( .A(res_addr[3]), .B(\add_335/carry[3] ), .Y(N466) );
  AND2X1 U580 ( .A(\add_335/carry[2] ), .B(res_addr[2]), .Y(\add_335/carry[3] ) );
  XOR2X1 U581 ( .A(res_addr[2]), .B(\add_335/carry[2] ), .Y(N465) );
  OR2X1 U582 ( .A(res_addr[1]), .B(n445), .Y(\add_335/carry[2] ) );
  XNOR2X1 U583 ( .A(n445), .B(res_addr[1]), .Y(N464) );
  XOR2X1 U584 ( .A(cnt[6]), .B(\add_122/carry [6]), .Y(N148) );
  AND2X1 U585 ( .A(\add_122/carry [5]), .B(cnt[5]), .Y(\add_122/carry [6]) );
  XOR2X1 U586 ( .A(cnt[5]), .B(\add_122/carry [5]), .Y(N147) );
  AND2X1 U587 ( .A(\add_122/carry [4]), .B(cnt[4]), .Y(\add_122/carry [5]) );
  XOR2X1 U588 ( .A(cnt[4]), .B(\add_122/carry [4]), .Y(N146) );
  AND2X1 U589 ( .A(\add_122/carry [3]), .B(cnt[3]), .Y(\add_122/carry [4]) );
  AND2X1 U590 ( .A(n443), .B(cnt[2]), .Y(\add_122/carry [3]) );
  XOR2X1 U591 ( .A(cnt[2]), .B(n443), .Y(N144) );
  AND2X1 U592 ( .A(n443), .B(n428), .Y(N1189) );
  AND2X1 U593 ( .A(cnt[2]), .B(n428), .Y(N1190) );
  AND2X1 U594 ( .A(cnt[3]), .B(n428), .Y(N1191) );
  AND2X1 U595 ( .A(cnt[4]), .B(n428), .Y(N1192) );
  AND2X1 U596 ( .A(cnt[5]), .B(n428), .Y(N1193) );
  NOR2X1 U597 ( .A(n463), .B(N142), .Y(n457) );
  NOR2X1 U598 ( .A(n463), .B(n464), .Y(n456) );
  NOR2X1 U599 ( .A(n464), .B(N73), .Y(n454) );
  NOR2X1 U600 ( .A(N142), .B(N73), .Y(n453) );
  AO22X1 U601 ( .A0(sti_di[5]), .A1(n454), .B0(sti_di[4]), .B1(n453), .Y(n448)
         );
  AOI221XL U602 ( .A0(sti_di[6]), .A1(n457), .B0(sti_di[7]), .B1(n456), .C0(
        n448), .Y(n451) );
  AO22X1 U603 ( .A0(sti_di[1]), .A1(n454), .B0(sti_di[0]), .B1(n453), .Y(n449)
         );
  AOI221XL U604 ( .A0(sti_di[2]), .A1(n457), .B0(sti_di[3]), .B1(n456), .C0(
        n449), .Y(n450) );
  OA22X1 U605 ( .A0(n462), .A1(n451), .B0(N74), .B1(n450), .Y(n461) );
  AO22X1 U606 ( .A0(sti_di[13]), .A1(n454), .B0(sti_di[12]), .B1(n453), .Y(
        n452) );
  AOI221XL U607 ( .A0(sti_di[14]), .A1(n457), .B0(sti_di[15]), .B1(n456), .C0(
        n452), .Y(n459) );
  AO22X1 U608 ( .A0(sti_di[9]), .A1(n454), .B0(sti_di[8]), .B1(n453), .Y(n455)
         );
  AOI221XL U609 ( .A0(sti_di[10]), .A1(n457), .B0(sti_di[11]), .B1(n456), .C0(
        n455), .Y(n458) );
  OAI22XL U610 ( .A0(n459), .A1(n462), .B0(N74), .B1(n458), .Y(n460) );
  OAI2BB2XL U611 ( .B0(n461), .B1(N75), .A0N(N75), .A1N(n460), .Y(N290) );
  NOR2X1 U612 ( .A(cnt[1]), .B(n464), .Y(n474) );
  NOR2X1 U613 ( .A(n443), .B(N142), .Y(n473) );
  NOR2X1 U614 ( .A(N142), .B(N77), .Y(n471) );
  NOR2X1 U615 ( .A(n464), .B(N77), .Y(n470) );
  AO22X1 U616 ( .A0(sti_di[5]), .A1(n471), .B0(sti_di[4]), .B1(n470), .Y(n465)
         );
  AOI221XL U617 ( .A0(sti_di[6]), .A1(n474), .B0(sti_di[7]), .B1(n473), .C0(
        n465), .Y(n468) );
  AO22X1 U618 ( .A0(sti_di[1]), .A1(n471), .B0(sti_di[0]), .B1(n470), .Y(n466)
         );
  AOI221XL U619 ( .A0(sti_di[2]), .A1(n474), .B0(sti_di[3]), .B1(n473), .C0(
        n466), .Y(n467) );
  OA22X1 U620 ( .A0(cnt[2]), .A1(n468), .B0(n719), .B1(n467), .Y(n478) );
  AO22X1 U621 ( .A0(sti_di[13]), .A1(n471), .B0(sti_di[12]), .B1(n470), .Y(
        n469) );
  AOI221XL U622 ( .A0(sti_di[14]), .A1(n474), .B0(sti_di[15]), .B1(n473), .C0(
        n469), .Y(n476) );
  AO22X1 U623 ( .A0(sti_di[9]), .A1(n471), .B0(sti_di[8]), .B1(n470), .Y(n472)
         );
  AOI221XL U624 ( .A0(sti_di[10]), .A1(n474), .B0(sti_di[11]), .B1(n473), .C0(
        n472), .Y(n475) );
  OAI22XL U625 ( .A0(n476), .A1(cnt[2]), .B0(n719), .B1(n475), .Y(n477) );
  OAI2BB2XL U626 ( .B0(n478), .B1(n770), .A0N(n770), .A1N(n477), .Y(N295) );
  AOI222XL U627 ( .A0(N147), .A1(n425), .B0(N154), .B1(n417), .C0(N194), .C1(
        n424), .Y(n483) );
  AOI222XL U628 ( .A0(N146), .A1(n425), .B0(N153), .B1(n417), .C0(N193), .C1(
        n424), .Y(n484) );
  CLKINVX1 U629 ( .A(n485), .Y(n781) );
  AOI222XL U630 ( .A0(N145), .A1(n425), .B0(N152), .B1(n417), .C0(N192), .C1(
        n424), .Y(n485) );
  CLKINVX1 U631 ( .A(n486), .Y(n782) );
  AOI222XL U632 ( .A0(N144), .A1(n425), .B0(N151), .B1(n417), .C0(N191), .C1(
        n424), .Y(n486) );
  CLKINVX1 U633 ( .A(n487), .Y(n783) );
  AOI222XL U634 ( .A0(N77), .A1(n425), .B0(N150), .B1(n417), .C0(N190), .C1(
        n424), .Y(n487) );
  NOR2X1 U635 ( .A(n773), .B(n488), .Y(n341) );
  NAND4X1 U636 ( .A(n489), .B(n490), .C(n491), .D(n492), .Y(n340) );
  AOI22X1 U637 ( .A0(N664), .A1(n418), .B0(n445), .B1(n420), .Y(n492) );
  AOI22X1 U638 ( .A0(n31), .A1(n419), .B0(n349), .B1(n422), .Y(n491) );
  AOI2BB2X1 U639 ( .B0(n349), .B1(n421), .A0N(n498), .A1N(n499), .Y(n490) );
  AOI22X1 U640 ( .A0(n349), .A1(n425), .B0(n445), .B1(n426), .Y(n489) );
  MXI2X1 U641 ( .A(n501), .B(n502), .S0(n503), .Y(n339) );
  NAND4X1 U642 ( .A(n504), .B(n505), .C(n506), .D(n507), .Y(n338) );
  AOI21X1 U643 ( .A0(N665), .A1(n418), .B0(n427), .Y(n507) );
  AOI22X1 U644 ( .A0(res_addr[1]), .A1(n420), .B0(n30), .B1(n419), .Y(n506) );
  AOI22X1 U645 ( .A0(N606), .A1(n422), .B0(N564), .B1(n421), .Y(n505) );
  AOI22X1 U646 ( .A0(N464), .A1(n425), .B0(n344), .B1(n426), .Y(n504) );
  NAND4X1 U647 ( .A(n509), .B(n510), .C(n511), .D(n512), .Y(n337) );
  AOI21X1 U648 ( .A0(N666), .A1(n418), .B0(n427), .Y(n512) );
  AOI22X1 U649 ( .A0(res_addr[2]), .A1(n420), .B0(n29), .B1(n419), .Y(n511) );
  AOI22X1 U650 ( .A0(N607), .A1(n422), .B0(N565), .B1(n421), .Y(n510) );
  AOI22X1 U651 ( .A0(N465), .A1(n425), .B0(N803), .B1(n426), .Y(n509) );
  NAND4X1 U652 ( .A(n513), .B(n514), .C(n515), .D(n516), .Y(n336) );
  AOI21X1 U653 ( .A0(N667), .A1(n418), .B0(n427), .Y(n516) );
  AOI22X1 U654 ( .A0(res_addr[3]), .A1(n420), .B0(n28), .B1(n419), .Y(n515) );
  AOI22X1 U655 ( .A0(N608), .A1(n422), .B0(N566), .B1(n421), .Y(n514) );
  AOI22X1 U656 ( .A0(N466), .A1(n425), .B0(N804), .B1(n426), .Y(n513) );
  NAND4X1 U657 ( .A(n517), .B(n518), .C(n519), .D(n520), .Y(n335) );
  AOI21X1 U658 ( .A0(N668), .A1(n418), .B0(n427), .Y(n520) );
  AOI22X1 U659 ( .A0(res_addr[4]), .A1(n420), .B0(n27), .B1(n419), .Y(n519) );
  AOI22X1 U660 ( .A0(N609), .A1(n422), .B0(N567), .B1(n421), .Y(n518) );
  AOI22X1 U661 ( .A0(N467), .A1(n425), .B0(N805), .B1(n426), .Y(n517) );
  NAND4X1 U662 ( .A(n521), .B(n522), .C(n523), .D(n524), .Y(n334) );
  AOI21X1 U663 ( .A0(N669), .A1(n418), .B0(n427), .Y(n524) );
  AOI22X1 U664 ( .A0(res_addr[5]), .A1(n420), .B0(n26), .B1(n419), .Y(n523) );
  AOI22X1 U665 ( .A0(N610), .A1(n422), .B0(N568), .B1(n421), .Y(n522) );
  AOI22X1 U666 ( .A0(N468), .A1(n425), .B0(N806), .B1(n426), .Y(n521) );
  NAND4X1 U667 ( .A(n525), .B(n526), .C(n527), .D(n528), .Y(n333) );
  AOI21X1 U668 ( .A0(N670), .A1(n418), .B0(n427), .Y(n528) );
  AOI22X1 U669 ( .A0(res_addr[6]), .A1(n420), .B0(n25), .B1(n419), .Y(n527) );
  AOI22X1 U670 ( .A0(N611), .A1(n422), .B0(N569), .B1(n421), .Y(n526) );
  AOI22X1 U671 ( .A0(N469), .A1(n425), .B0(N807), .B1(n426), .Y(n525) );
  OAI211X1 U672 ( .A0(n529), .A1(n530), .B0(n531), .C0(n532), .Y(n332) );
  AOI222XL U673 ( .A0(N392), .A1(n533), .B0(N246), .B1(n534), .C0(N330), .C1(
        n535), .Y(n532) );
  AOI22X1 U674 ( .A0(N239), .A1(n534), .B0(n535), .B1(N323), .Y(n541) );
  AOI2BB2X1 U675 ( .B0(N290), .B1(n425), .A0N(n543), .A1N(n544), .Y(n538) );
  CLKINVX1 U676 ( .A(N295), .Y(n543) );
  AOI222XL U677 ( .A0(N391), .A1(n533), .B0(N245), .B1(n534), .C0(N329), .C1(
        n535), .Y(n547) );
  OAI211X1 U678 ( .A0(n529), .A1(n548), .B0(n549), .C0(n550), .Y(n329) );
  AOI222XL U679 ( .A0(N390), .A1(n533), .B0(N244), .B1(n534), .C0(N328), .C1(
        n535), .Y(n550) );
  OAI211X1 U680 ( .A0(n529), .A1(n551), .B0(n552), .C0(n553), .Y(n328) );
  AOI222XL U681 ( .A0(N389), .A1(n533), .B0(N243), .B1(n534), .C0(N327), .C1(
        n535), .Y(n553) );
  OAI211X1 U682 ( .A0(n529), .A1(n554), .B0(n555), .C0(n556), .Y(n327) );
  AOI222XL U683 ( .A0(N388), .A1(n533), .B0(N242), .B1(n534), .C0(N326), .C1(
        n535), .Y(n556) );
  OAI211X1 U684 ( .A0(n529), .A1(n557), .B0(n558), .C0(n559), .Y(n326) );
  AOI222XL U685 ( .A0(N387), .A1(n533), .B0(N241), .B1(n534), .C0(N325), .C1(
        n535), .Y(n559) );
  AOI222XL U686 ( .A0(N386), .A1(n533), .B0(N240), .B1(n534), .C0(N324), .C1(
        n535), .Y(n562) );
  AOI32X1 U687 ( .A0(n568), .A1(n569), .A2(n570), .B0(n571), .B1(n572), .Y(
        n567) );
  OAI21XL U688 ( .A0(n573), .A1(n574), .B0(res_do[6]), .Y(n572) );
  NAND2X1 U689 ( .A(n573), .B(n574), .Y(n571) );
  AOI32X1 U690 ( .A0(pre_result[4]), .A1(n575), .A2(n569), .B0(n576), .B1(
        pre_result[5]), .Y(n573) );
  AOI2BB2X1 U691 ( .B0(res_do[6]), .B1(n574), .A0N(n575), .A1N(pre_result[4]), 
        .Y(n570) );
  OR2X1 U692 ( .A(pre_result[5]), .B(n576), .Y(n569) );
  OAI211X1 U693 ( .A0(n577), .A1(n578), .B0(n579), .C0(n580), .Y(n568) );
  OAI222XL U694 ( .A0(pre_result[3]), .A1(n581), .B0(pre_result[2]), .B1(n582), 
        .C0(n583), .C1(n584), .Y(n579) );
  NAND2X1 U695 ( .A(pre_result[2]), .B(n582), .Y(n577) );
  NAND2X1 U696 ( .A(n588), .B(n587), .Y(n592) );
  NAND2X1 U697 ( .A(N330), .B(n598), .Y(n587) );
  OAI21XL U698 ( .A0(n598), .A1(N330), .B0(n599), .Y(n588) );
  CLKINVX1 U699 ( .A(n600), .Y(n599) );
  AOI32X1 U700 ( .A0(n601), .A1(n602), .A2(n603), .B0(n604), .B1(n605), .Y(
        n600) );
  OAI21XL U701 ( .A0(n606), .A1(n607), .B0(res_do[6]), .Y(n605) );
  NAND2X1 U702 ( .A(n606), .B(n607), .Y(n604) );
  AOI2BB2X1 U703 ( .B0(res_do[6]), .B1(n607), .A0N(n575), .A1N(N327), .Y(n603)
         );
  CLKINVX1 U704 ( .A(N329), .Y(n607) );
  OR2X1 U705 ( .A(N328), .B(n576), .Y(n602) );
  OAI211X1 U706 ( .A0(n608), .A1(n609), .B0(n610), .C0(n611), .Y(n601) );
  OAI222XL U707 ( .A0(N326), .A1(n581), .B0(N325), .B1(n582), .C0(n612), .C1(
        n613), .Y(n610) );
  CLKINVX1 U708 ( .A(n614), .Y(n612) );
  OAI211X1 U709 ( .A0(n615), .A1(N324), .B0(N323), .C0(n385), .Y(n614) );
  CLKINVX1 U710 ( .A(N326), .Y(n609) );
  NAND2X1 U711 ( .A(N325), .B(n582), .Y(n608) );
  NAND2X1 U712 ( .A(n619), .B(n622), .Y(n621) );
  AOI2BB2X1 U713 ( .B0(n575), .B1(n353), .A0N(n545), .A1N(res_do[6]), .Y(n627)
         );
  OAI211X1 U714 ( .A0(n581), .A1(n631), .B0(n632), .C0(n633), .Y(n625) );
  AO21X1 U715 ( .A0(n581), .A1(n631), .B0(res_di[3]), .Y(n633) );
  NOR2X1 U716 ( .A(res_di[1]), .B(n615), .Y(n635) );
  OA21XL U717 ( .A0(res_do[1]), .A1(n560), .B0(n542), .Y(n634) );
  MXI2X1 U718 ( .A(n617), .B(n636), .S0(n637), .Y(n324) );
  AOI211X1 U719 ( .A0(n638), .A1(n639), .B0(n617), .C0(n597), .Y(n637) );
  AND2X1 U720 ( .A(N257), .B(n598), .Y(n643) );
  CLKINVX1 U721 ( .A(N254), .Y(n650) );
  OAI211X1 U722 ( .A0(n581), .A1(n652), .B0(n653), .C0(n654), .Y(n644) );
  AO21X1 U723 ( .A0(n581), .A1(n652), .B0(N253), .Y(n654) );
  NOR2X1 U724 ( .A(N251), .B(n615), .Y(n658) );
  AOI211X1 U725 ( .A0(N251), .A1(n615), .B0(n385), .C0(N250), .Y(n657) );
  CLKINVX1 U726 ( .A(N253), .Y(n655) );
  CLKINVX1 U727 ( .A(N252), .Y(n656) );
  OAI22XL U728 ( .A0(N246), .A1(n530), .B0(n659), .B1(n660), .Y(n639) );
  AND2X1 U729 ( .A(N246), .B(n530), .Y(n660) );
  AOI32X1 U730 ( .A0(n661), .A1(n662), .A2(n663), .B0(n664), .B1(n665), .Y(
        n659) );
  OAI21XL U731 ( .A0(n666), .A1(N245), .B0(n545), .Y(n665) );
  NAND2X1 U732 ( .A(n666), .B(N245), .Y(n664) );
  CLKINVX1 U733 ( .A(N244), .Y(n668) );
  CLKINVX1 U734 ( .A(N243), .Y(n667) );
  OAI211X1 U735 ( .A0(n554), .A1(n669), .B0(n670), .C0(n671), .Y(n661) );
  AO21X1 U736 ( .A0(n554), .A1(n669), .B0(N242), .Y(n671) );
  OAI222XL U737 ( .A0(res_di[3]), .A1(n672), .B0(res_di[2]), .B1(n673), .C0(
        n674), .C1(n675), .Y(n670) );
  NOR2X1 U738 ( .A(N240), .B(n560), .Y(n675) );
  AOI211X1 U739 ( .A0(N240), .A1(n560), .B0(n542), .C0(N239), .Y(n674) );
  CLKINVX1 U740 ( .A(res_di[0]), .Y(n542) );
  CLKINVX1 U741 ( .A(res_di[1]), .Y(n560) );
  CLKINVX1 U742 ( .A(N242), .Y(n672) );
  CLKINVX1 U743 ( .A(N241), .Y(n673) );
  OAI22XL U744 ( .A0(n503), .A1(n586), .B0(n385), .B1(n676), .Y(n323) );
  OAI22XL U745 ( .A0(n503), .A1(n585), .B0(n615), .B1(n676), .Y(n322) );
  OAI2BB2XL U746 ( .B0(n582), .B1(n676), .A0N(n677), .A1N(pre_result[2]), .Y(
        n321) );
  OAI22XL U747 ( .A0(n503), .A1(n578), .B0(n581), .B1(n676), .Y(n320) );
  OAI2BB2XL U748 ( .B0(n575), .B1(n676), .A0N(n677), .A1N(pre_result[4]), .Y(
        n319) );
  OAI2BB2XL U749 ( .B0(n576), .B1(n676), .A0N(n677), .A1N(pre_result[5]), .Y(
        n318) );
  OAI22XL U750 ( .A0(n503), .A1(n574), .B0(n347), .B1(n676), .Y(n317) );
  OAI22XL U751 ( .A0(n503), .A1(n566), .B0(n598), .B1(n676), .Y(n316) );
  NOR2X1 U752 ( .A(n502), .B(n638), .Y(n677) );
  NAND4X1 U753 ( .A(n679), .B(n680), .C(n681), .D(n682), .Y(n315) );
  AOI22X1 U754 ( .A0(N671), .A1(n418), .B0(res_addr[7]), .B1(n420), .Y(n682)
         );
  AOI22X1 U755 ( .A0(n24), .A1(n419), .B0(N612), .B1(n422), .Y(n681) );
  AOI2BB2X1 U756 ( .B0(N570), .B1(n421), .A0N(n498), .A1N(n499), .Y(n680) );
  AOI22X1 U757 ( .A0(N470), .A1(n425), .B0(N808), .B1(n426), .Y(n679) );
  NAND4X1 U758 ( .A(n683), .B(n684), .C(n685), .D(n686), .Y(n314) );
  AOI21X1 U759 ( .A0(N672), .A1(n418), .B0(n427), .Y(n686) );
  AOI22X1 U760 ( .A0(res_addr[8]), .A1(n420), .B0(n23), .B1(n419), .Y(n685) );
  AOI22X1 U761 ( .A0(N613), .A1(n422), .B0(N571), .B1(n421), .Y(n684) );
  AOI22X1 U762 ( .A0(N471), .A1(n425), .B0(N809), .B1(n426), .Y(n683) );
  NAND4X1 U763 ( .A(n687), .B(n688), .C(n689), .D(n690), .Y(n313) );
  AOI21X1 U764 ( .A0(N673), .A1(n418), .B0(n427), .Y(n690) );
  AOI22X1 U765 ( .A0(res_addr[9]), .A1(n420), .B0(n22), .B1(n419), .Y(n689) );
  AOI22X1 U766 ( .A0(N614), .A1(n422), .B0(N572), .B1(n421), .Y(n688) );
  AOI22X1 U767 ( .A0(N472), .A1(n425), .B0(N810), .B1(n426), .Y(n687) );
  NAND4X1 U768 ( .A(n691), .B(n692), .C(n693), .D(n694), .Y(n312) );
  AOI21X1 U769 ( .A0(N674), .A1(n418), .B0(n427), .Y(n694) );
  AOI22X1 U770 ( .A0(res_addr[10]), .A1(n420), .B0(n21), .B1(n419), .Y(n693)
         );
  AOI22X1 U771 ( .A0(N615), .A1(n422), .B0(N573), .B1(n421), .Y(n692) );
  AOI22X1 U772 ( .A0(N473), .A1(n425), .B0(N811), .B1(n426), .Y(n691) );
  NAND4X1 U773 ( .A(n695), .B(n696), .C(n697), .D(n698), .Y(n311) );
  AOI21X1 U774 ( .A0(N675), .A1(n418), .B0(n427), .Y(n698) );
  AOI22X1 U775 ( .A0(res_addr[11]), .A1(n420), .B0(n20), .B1(n419), .Y(n697)
         );
  AOI22X1 U776 ( .A0(N616), .A1(n422), .B0(N574), .B1(n421), .Y(n696) );
  AOI22X1 U777 ( .A0(N474), .A1(n425), .B0(N812), .B1(n426), .Y(n695) );
  NAND4X1 U778 ( .A(n699), .B(n700), .C(n701), .D(n702), .Y(n310) );
  AOI21X1 U779 ( .A0(N676), .A1(n418), .B0(n427), .Y(n702) );
  AOI22X1 U780 ( .A0(res_addr[12]), .A1(n420), .B0(n19), .B1(n419), .Y(n701)
         );
  AOI22X1 U781 ( .A0(N617), .A1(n422), .B0(N575), .B1(n421), .Y(n700) );
  AOI22X1 U782 ( .A0(N475), .A1(n425), .B0(N813), .B1(n426), .Y(n699) );
  NAND4X1 U783 ( .A(n703), .B(n704), .C(n705), .D(n706), .Y(n309) );
  AOI21X1 U784 ( .A0(N677), .A1(n418), .B0(n427), .Y(n706) );
  OAI21XL U785 ( .A0(n640), .A1(n708), .B0(n428), .Y(n707) );
  AOI22X1 U786 ( .A0(res_addr[13]), .A1(n420), .B0(n18), .B1(n419), .Y(n705)
         );
  NAND3X1 U787 ( .A(n499), .B(n595), .C(n712), .Y(n711) );
  NAND3X1 U788 ( .A(n443), .B(n619), .C(n424), .Y(n710) );
  AO21X1 U789 ( .A0(N77), .A1(n708), .B0(n713), .Y(n709) );
  AOI31X1 U790 ( .A0(n717), .A1(n499), .A2(n712), .B0(n784), .Y(n716) );
  CLKINVX1 U791 ( .A(n423), .Y(n784) );
  OAI21XL U792 ( .A0(n718), .A1(n719), .B0(n720), .Y(n717) );
  CLKINVX1 U793 ( .A(n640), .Y(n619) );
  AOI22X1 U794 ( .A0(N618), .A1(n422), .B0(N576), .B1(n421), .Y(n704) );
  NAND3X1 U795 ( .A(n678), .B(n719), .C(n721), .Y(n713) );
  OAI31XL U796 ( .A0(n617), .A1(n595), .A2(n616), .B0(n722), .Y(n496) );
  NAND2X1 U797 ( .A(n724), .B(n725), .Y(n499) );
  CLKINVX1 U798 ( .A(n424), .Y(n617) );
  AOI22X1 U799 ( .A0(N476), .A1(n425), .B0(N814), .B1(n426), .Y(n703) );
  OAI221XL U800 ( .A0(n304), .A1(n726), .B0(n565), .B1(n727), .C0(n728), .Y(
        NState[2]) );
  NAND3X1 U801 ( .A(n774), .B(n729), .C(n730), .Y(n728) );
  OAI221XL U802 ( .A0(n773), .A1(n731), .B0(n732), .B1(n565), .C0(n733), .Y(
        NState[1]) );
  AOI33X1 U803 ( .A0(n734), .A1(n735), .A2(n736), .B0(n737), .B1(n589), .B2(
        n738), .Y(n733) );
  NOR3X1 U804 ( .A(n739), .B(res_addr[7]), .C(res_addr[4]), .Y(n738) );
  NOR2BX1 U805 ( .AN(res_addr[8]), .B(n740), .Y(n737) );
  NAND2X1 U806 ( .A(n726), .B(n304), .Y(n565) );
  NOR2X1 U807 ( .A(n729), .B(n715), .Y(n726) );
  CLKINVX1 U808 ( .A(n727), .Y(n732) );
  NAND3X1 U809 ( .A(n445), .B(n344), .C(n724), .Y(n727) );
  NOR4BBX1 U810 ( .AN(n744), .BN(n745), .C(n746), .D(res_addr[7]), .Y(n724) );
  AND4X1 U811 ( .A(res_addr[12]), .B(res_addr[13]), .C(res_addr[8]), .D(
        res_addr[9]), .Y(n745) );
  AND2X1 U812 ( .A(res_addr[10]), .B(res_addr[11]), .Y(n744) );
  MXI2X1 U813 ( .A(n774), .B(fw_finish), .S0(n730), .Y(n731) );
  OAI211X1 U814 ( .A0(n747), .A1(n748), .B0(n423), .C0(n749), .Y(NState[0]) );
  NAND3X1 U815 ( .A(n304), .B(n715), .C(n743), .Y(n749) );
  CLKINVX1 U816 ( .A(n750), .Y(n743) );
  OAI31XL U817 ( .A0(n751), .A1(n752), .A2(n753), .B0(n754), .Y(n750) );
  NAND2X1 U818 ( .A(n445), .B(n775), .Y(n753) );
  NAND3X1 U819 ( .A(n777), .B(n344), .C(n776), .Y(n752) );
  NAND3X1 U820 ( .A(cnt[2]), .B(n720), .C(n718), .Y(n748) );
  CLKINVX1 U821 ( .A(n708), .Y(n718) );
  NAND3BX1 U822 ( .AN(n730), .B(n488), .C(n729), .Y(n747) );
  NOR2X1 U823 ( .A(n723), .B(n755), .Y(n730) );
  OAI31XL U824 ( .A0(n304), .A1(n771), .A2(n774), .B0(n502), .Y(N867) );
  OAI211X1 U825 ( .A0(n774), .A1(fw_finish), .B0(n488), .C0(n729), .Y(n502) );
  NAND2X1 U826 ( .A(n774), .B(fw_finish), .Y(n488) );
  OAI22XL U827 ( .A0(fw_finish), .A1(n729), .B0(n756), .B1(n636), .Y(N854) );
  AO21X1 U828 ( .A0(n719), .A1(n622), .B0(n757), .Y(N74) );
  NAND2X1 U829 ( .A(n708), .B(n622), .Y(N73) );
  NAND2X1 U830 ( .A(n464), .B(N77), .Y(n708) );
  NAND4BBXL U831 ( .AN(n427), .BN(n426), .C(n758), .D(n759), .Y(N196) );
  AOI222XL U832 ( .A0(N142), .A1(n425), .B0(N149), .B1(n417), .C0(N189), .C1(
        n424), .Y(n759) );
  OAI31XL U833 ( .A0(n760), .A1(n595), .A2(n761), .B0(n544), .Y(n481) );
  OR4X1 U834 ( .A(n445), .B(res_addr[1]), .C(res_addr[7]), .D(res_addr[8]), 
        .Y(n762) );
  NAND2X1 U835 ( .A(n712), .B(n754), .Y(n760) );
  NOR2BX1 U836 ( .AN(n723), .B(n498), .Y(n712) );
  CLKINVX1 U837 ( .A(n596), .Y(n742) );
  NOR2X1 U838 ( .A(n756), .B(fw_finish), .Y(n596) );
  CLKINVX1 U839 ( .A(n725), .Y(n740) );
  NOR2X1 U840 ( .A(n344), .B(n445), .Y(n725) );
  NAND4X1 U841 ( .A(res_addr[2]), .B(res_addr[4]), .C(res_addr[3]), .D(n763), 
        .Y(n746) );
  AND2X1 U842 ( .A(res_addr[5]), .B(res_addr[6]), .Y(n763) );
  CLKINVX1 U843 ( .A(n498), .Y(n678) );
  NAND3X1 U844 ( .A(cnt[3]), .B(n757), .C(n764), .Y(n754) );
  AND3X1 U845 ( .A(n775), .B(n777), .C(n776), .Y(n764) );
  NOR2X1 U846 ( .A(n719), .B(n622), .Y(n757) );
  OR2X1 U847 ( .A(n464), .B(N77), .Y(n622) );
  CLKINVX1 U848 ( .A(n589), .Y(n594) );
  NOR2X1 U849 ( .A(n756), .B(n304), .Y(n589) );
  NAND2X1 U850 ( .A(n773), .B(n715), .Y(n756) );
  NAND2X1 U851 ( .A(n774), .B(n714), .Y(n498) );
  NOR2X1 U852 ( .A(fw_finish), .B(n773), .Y(n714) );
  NAND4X1 U853 ( .A(n445), .B(n772), .C(res_addr[7]), .D(n765), .Y(n723) );
  NOR4X1 U854 ( .A(res_addr[8]), .B(res_addr[4]), .C(res_addr[1]), .D(n739), 
        .Y(n765) );
  NAND4BBXL U855 ( .AN(res_addr[2]), .BN(res_addr[3]), .C(n766), .D(n767), .Y(
        n739) );
  NOR4X1 U856 ( .A(res_addr[13]), .B(res_addr[12]), .C(res_addr[11]), .D(
        res_addr[10]), .Y(n767) );
  NOR3X1 U857 ( .A(res_addr[5]), .B(res_addr[9]), .C(res_addr[6]), .Y(n766) );
  NAND2X1 U858 ( .A(n768), .B(n769), .Y(n755) );
  NOR4X1 U859 ( .A(res_di[7]), .B(res_di[6]), .C(res_di[5]), .D(n351), .Y(n769) );
  NOR4X1 U860 ( .A(res_di[3]), .B(res_di[2]), .C(res_di[1]), .D(res_di[0]), 
        .Y(n768) );
  CLKINVX1 U861 ( .A(n638), .Y(n616) );
  NOR3X1 U862 ( .A(n464), .B(n443), .C(n640), .Y(n638) );
  NAND2X1 U863 ( .A(n720), .B(n719), .Y(n640) );
  AND4X1 U864 ( .A(n770), .B(n775), .C(n776), .D(n777), .Y(n720) );
endmodule

