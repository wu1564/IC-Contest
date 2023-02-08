debLoadSimResult /home/jylin/CA_LAB/DT/SYN_Sim/DT.fsdb
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/testfixture"
wvSetPosition -win $_nWave2 {("G1" 21)}
wvSetPosition -win $_nWave2 {("G1" 21)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/testfixture/bc_err\[31:0\]} \
{/testfixture/bcexp_pat\[7:0\]} \
{/testfixture/bcpass_chk} \
{/testfixture/clk} \
{/testfixture/done} \
{/testfixture/exp_pat\[7:0\]} \
{/testfixture/fw_err\[31:0\]} \
{/testfixture/fwexp_pat\[7:0\]} \
{/testfixture/fwpass_chk} \
{/testfixture/fwpass_finish} \
{/testfixture/i\[31:0\]} \
{/testfixture/rel_pat\[7:0\]} \
{/testfixture/res_addr\[13:0\]} \
{/testfixture/res_di\[7:0\]} \
{/testfixture/res_do\[7:0\]} \
{/testfixture/res_rd} \
{/testfixture/res_wr} \
{/testfixture/reset} \
{/testfixture/sti_addr\[9:0\]} \
{/testfixture/sti_di\[15:0\]} \
{/testfixture/sti_rd} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 \
           18 19 20 21 )} 
wvSetPosition -win $_nWave2 {("G1" 21)}
wvGetSignalClose -win $_nWave2
wvSetCursor -win $_nWave2 2951163.841963 -snap {("G1" 15)}
wvZoom -win $_nWave2 3660733.290304 4854100.089786
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
