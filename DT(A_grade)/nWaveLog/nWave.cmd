wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 {/home/wtwu/DT/DT.fsdb}
wvResizeWindow -win $_nWave1 0 23 1366 745
wvResizeWindow -win $_nWave1 0 23 1366 745
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/testfixture"
wvSetFileTimeRange -win $_nWave1 -time_unit 10p 0 114295933
wvGetSignalOpen -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 21)}
wvSetPosition -win $_nWave1 {("G1" 21)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
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
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 \
           18 19 20 21 )} 
wvSetPosition -win $_nWave1 {("G1" 21)}
wvGetSignalSetScope -win $_nWave1 "/testfixture/u_dut"
wvGetSignalSetScope -win $_nWave1 "/testfixture/u_res_RAM"
wvGetSignalSetScope -win $_nWave1 "/testfixture/u_sti_ROM"
wvSetPosition -win $_nWave1 {("G1" 21)}
wvSetPosition -win $_nWave1 {("G1" 21)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
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
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 \
           18 19 20 21 )} 
wvSetPosition -win $_nWave1 {("G1" 21)}
wvGetSignalClose -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvSetCursor -win $_nWave1 8111255.713999 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 8113558.139532 -snap {("G1" 4)}
wvExit
