wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 {/home/wtwu/DT/SYN_Sim/DT.fsdb}
wvResizeWindow -win $_nWave1 0 23 1366 745
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/testfixture"
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
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvSelectGroup -win $_nWave1 {G2}
wvSetCursor -win $_nWave1 9513336920.637999 -snap {("G1" 16)}
wvSetCursor -win $_nWave1 201090.153392 -snap {("G1" 19)}
wvZoomAll -win $_nWave1
wvSetCursor -win $_nWave1 93693617021.276581 -snap {("G1" 13)}
wvSetCursor -win $_nWave1 96272340425.531906 -snap {("G1" 14)}
wvSetCursor -win $_nWave1 90942978723.404251 -snap {("G1" 18)}
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomAll -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvZoom -win $_nWave1 69170212765.957458 74914893617.021271
wvZoom -win $_nWave1 99836396559.523010 100990221819.821777
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 99918222551.050629 -snap {("G1" 8)}
wvSetCursor -win $_nWave1 65403.309787 -snap {("G1" 4)}
wvExit
