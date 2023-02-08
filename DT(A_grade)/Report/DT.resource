 
****************************************
Report : resources
Design : DT
Version: R-2020.09
Date   : Tue Mar 16 06:13:46 2021
****************************************

Resource Sharing Report for design DT in file /home/wtwu/DT/DT.v

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r477     | DW01_inc     | width=7    |               | add_125 add_142      |
| r480     | DW01_inc     | width=8    |               | add_238 add_277      |
| r482     | DW_cmp       | width=7    |               | gt_241 gt_286        |
| r483     | DW01_inc     | width=8    |               | add_241 add_286      |
|          |              |            |               | add_287              |
| r484     | DW_cmp       | width=8    |               | gt_241_2 gt_286_2    |
| r490     | DW01_inc     | width=8    |               | add_277_2 add_291    |
| r494     | DW01_inc     | width=14   |               | add_338 add_349      |
|          |              |            |               | add_353 add_355      |
|          |              |            |               | add_356 add_370      |
|          |              |            |               | add_371              |
| r495     | DW01_sub     | width=14   |               | sub_354 sub_378      |
| r496     | DW01_add     | width=14   |               | add_357 add_369      |
| r497     | DW01_dec     | width=14   |               | sub_364 sub_368      |
| r517     | DW01_add     | width=7    |               | add_122              |
| r521     | DW01_inc     | width=10   |               | add_202              |
| r523     | DW_cmp       | width=8    |               | gt_238               |
| r525     | DW01_sub     | width=4    |               | sub_262              |
| r527     | DW01_sub     | width=4    |               | sub_265              |
| r529     | DW_cmp       | width=7    |               | gt_272               |
| r531     | DW_cmp       | width=8    |               | gt_272_2             |
| r533     | DW_cmp       | width=8    |               | lt_277               |
| r535     | DW_cmp       | width=8    |               | lt_291               |
| r537     | DW01_inc     | width=8    |               | add_291_2            |
| r539     | DW01_add     | width=14   |               | add_335              |
| r541     | DW01_sub     | width=14   |               | sub_381              |
| r543     | DW_cmp       | width=3    |               | gt_467               |
| r1265    | DW_mult_uns  | a_width=7  |               | mult_add_150_aco     |
|          |              | b_width=1  |               |                      |
| r1267    | DW01_inc     | width=7    |               | add_150_aco          |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_150_aco        | DW01_inc         | rpl                |                |
| r477               | DW01_inc         | rpl                |                |
| r480               | DW01_inc         | rpl                |                |
| r483               | DW01_inc         | rpl                |                |
| r490               | DW01_inc         | rpl                |                |
| r494               | DW01_inc         | rpl                |                |
| r497               | DW01_dec         | rpl                |                |
| add_202            | DW01_inc         | rpl                |                |
| add_291_2          | DW01_inc         | rpl                |                |
===============================================================================

1
