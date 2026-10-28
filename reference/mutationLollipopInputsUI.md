# Input UI components for the mutationLollipop module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`mutationLollipopServer()`](https://j-andrews7.github.io/sciVizModules/reference/mutationLollipopServer.md)
and
[`mutationLollipopOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/mutationLollipopOutputUI.md)
functions.

## Usage

``` r
mutationLollipopInputsUI(
  id,
  data,
  defaults = NULL,
  title = "Lollipop Settings",
  columns = 2
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A maftools `MAF` object or a data frame in MAF columns.

- defaults:

  A named list of default values for the inputs.

- title:

  An optional title for the UI grid.

- columns:

  Number of columns for the UI grid.

## Value

A Shiny tagList containing the UI elements

## Details

The module draws
[`mutationLollipop()`](https://j-andrews7.github.io/sciVizModules/reference/mutationLollipop.md):
one gene's non-synonymous mutations along its protein, a stem per
position and a point per protein change, coloured by variant class, over
the protein's domains. Its data is a maftools `MAF` object or a data
frame in MAF columns with a protein-change column (see
[`mutationLollipop()`](https://j-andrews7.github.io/sciVizModules/reference/mutationLollipop.md)).
Domains and the protein length come from maftools' bundled domain table
when maftools is installed, or from the server's `domains` argument. The
inputs are organised into tabs via
[`VizModules::organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.html).

## Plot parameters and defaults

The following parameters can be accessed via UI inputs and/or the
`defaults` argument:

- `gene` - Gene to draw (default: the most often mutated)

- `label.top` - Most mutated positions to label (default: 3)

- `show.domains` - Draw the protein domains (default: TRUE)

- `point.size` - Marker size (default: 10)

- `palette.colours` - Named variant-class colours (multiColorPicker;
  default: maftools' palette)

The Legend, Axes, Lines and Plotly tabs carry the shared VizModules
inputs.

## See also

[`mutationLollipop()`](https://j-andrews7.github.io/sciVizModules/reference/mutationLollipop.md),
[`mutationLollipopOutputUI()`](https://j-andrews7.github.io/sciVizModules/reference/mutationLollipopOutputUI.md),
[`mutationLollipopServer()`](https://j-andrews7.github.io/sciVizModules/reference/mutationLollipopServer.md),
[`mutationLollipopApp()`](https://j-andrews7.github.io/sciVizModules/reference/mutationLollipopApp.md)

## Author

Jared Andrews

## Examples

``` r
library(sciVizModules)
if (requireNamespace("maftools", quietly = TRUE)) {
    # The TCGA LAML cohort maftools ships, with its clinical annotations.
    laml <- read.delim(system.file("extdata", "tcga_laml.maf.gz", package = "maftools"),
        comment.char = "#")
    clinical <- read.delim(system.file("extdata", "tcga_laml_annot.tsv", package = "maftools"))
    laml <- merge(laml, clinical, by = "Tumor_Sample_Barcode")
    mutationLollipopInputsUI("lollipop", laml)
}
#> <h3>Lollipop Settings</h3>
#> <div class="tabbable vizmodules-input-tabs">
#>   <ul class="nav nav-tabs shiny-tab-input" id="lollipop-mutationLollipopTabsetPanel" data-tabsetid="1299">
#>     <li class="active">
#>       <a href="#tab-1299-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1299-2" data-toggle="tab" data-bs-toggle="tab" data-value="Aesthetics">Aesthetics</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1299-3" data-toggle="tab" data-bs-toggle="tab" data-value="Legend">Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1299-4" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1299-5" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1299-6" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="1299">
#>     <div class="tab-pane active" data-value="Data" id="tab-1299-1">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9554548">
#>             <label class="control-label" id="lollipop-gene-label" for="lollipop-gene">Gene</label>
#>             <div id="lollipop-gene" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="lollipop-gene">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["FLT3","DNMT3A","NPM1","IDH2","IDH1","TET2","RUNX1","TP53","NRAS","CEBPA","WT1","PTPN11","KIT","KRAS","U2AF1","SMC3","PHF6","SMC1A","STAG2","TTN","FAM5C","ASXL1","RAD21","PLCE1","EZH2","CACNA1B","CACNA1E","COL12A1","CSMD1","DIS3","DNAH9","FCGBP","GBP4","KDM6A","MUC16","PTPRT","SMG1","SPEN","SUZ12","HNRNPK","MUC5B","ADAM11","APOB","ARAP2","ATP10B","BCOR","BMPER","BSN","C10orf28","CACNA2D3","CADM2","CADPS","CALR","CBFB","CBL","CD74","CECR2","CHD4","CMYA5","CNTN5","CNTNAP4","CRISPLD1","CSMD3","CUL1","DCLK1","DDR2","DDX41","DLC1","DOCK2","DRD2","DST","E2F8","EED","EGFR","ETV6","FAM154B","FAM40B","FAM57B","FAM65A","FRYL","GALNTL4","GATA2","GIGYF2","GJB3","GPR112","GRID1","GRIK2","GRIK4","GRM3","GRM8","GSTK1","HECW1","ILDR1","KCNA4","KCNK13","KCNU1","KDM3B","KDR","KIAA0240","KIAA1683","KIF2B","MAP2","MED12","MEFV","MTA2","MTMR8","MTUS2","NF1","NMUR2","NR2E1","NRXN3","OR11H12","OR13H1","PDCD2L","PHIP","PKHD1L1","PLEKHH1","PPP1R3A","PRAMEF2","PRPF8","PSME4","RBBP4","RBM16","RFC3","RIMS1","RNF213","RYR3","SCN1A","SEMA3A","SEMA4A","SETBP1","SI","TCEAL6","TET1","THRAP3","TNC","TOP3B","TRPM3","TTBK1","TUBA3C","UNC5B","WAC","ZBTB33","ZC3H18","ZNF687","CBX7","ABCA10","ABCA4","ABCB11","ABCC3","ABCF1","ABCG4","ABCG8","ABL1","ACOXL","ACPL2","ACSM2A","ACSS3","ACTBL2","ACTL7A","ACVR2B","ADAMTS1","ADAMTS12","ADAMTS16","ADAMTS17","ADAMTSL1","ADCY10","ADCY3","ADCY5","ADNP","ADRBK1","ADSS","AFF2","AFF4","AGBL2","AGXT2","AKAP12","AKAP13","AKAP5","AKD1","AKR7A2","ALDH1A3","ALG13","ALG6","ALMS1","ALPK3","ALS2CR11","AMOT","ANG","ANK2","ANK3","ANKRD12","ANKRD13A","ANKRD24","ANKRD26","ANKRD30A","ANO2","ANO3","AP1G2","AP1M1","AP3S2","AQP5","ARC","ARHGAP18","ARHGAP35","ARHGAP39","ARHGAP5","ARHGEF1","ARHGEF10L","ARHGEF11","ARHGEF19","ARHGEF5","ARHGEF6","ARID1A","ARID2","ARID4B","ARL3","ARSF","ASB11","ASB15","ASB4","ASTL","ASXL2","ASXL3","ATF7IP","ATG16L1","ATG4C","ATP11B","ATP13A5","ATP1B4","ATP2A2","ATP2B2","ATP2B3","ATP2C1","ATP6AP2","ATP6V1C1","ATP6V1G3","ATRNL1","ATXN7L1","AURKB","AURKC","B3GALT5","B4GALNT3","BAAT","BAI1","BAIAP2L1","BBS12","BCAN","BCHE","BCMO1","BCORL1","BECN1","BICD1","BLZF1","BMP10","BMP5","BMP6","BNC2","BOD1L","BPTF","BRCC3","BRMS1","BRPF1","BRS3","BRWD3","BTBD16","BTD","BUB1","BUB3","C10orf118","C10orf120","C10orf18","C10orf76","C11orf41","C11orf70","C12orf11","C12orf63","C13orf18","C15orf57","C15orf60","C16orf57","C19orf46","C19orf62","C1RL","C1orf103","C1orf105","C1orf168","C1orf183","C1orf51","C2","C20orf24","C20orf26","C22orf42","C2orf89","C3","C3orf67","C4BPB","C5","C6orf106","C6orf118","C6orf142","C6orf170","C6orf174","C7","C7orf10","C8orf80","C8orf84","C9orf171","C9orf43","C9orf78","C9orf93","CACNA1G","CACNA1S","CACNA2D4","CACNG2","CADM3","CAGE1","CAMK1G","CAMKV","CAMTA1","CAND1","CAPN6","CAPRIN2","CARD18","CASC5","CASP10","CASZ1","CATSPER4","CBX5","CC2D2A","CCBE1","CCDC150","CCDC24","CCDC57","CCDC60","CCDC67","CCL11","CCL16","CCL20","CCL21","CCNG2","CD109","CD320","CD70","CDC42","CDH16","CDH24","CDH4","CDHR2","CDON","CELSR1","CELSR3","CENPB","CENPF","CENPN","CEP170","CEP290","CFHR2","CGN","CHIC2","CHIT1","CHST6","CIC","CKAP4","CLCN1","CLCN6","CLDN11","CLDN14","CLDN18","CLPX","CLVS2","CNGA3","CNOT6","CNOT6L","CNTLN","CNTN6","CNTNAP5","COL11A2","COL22A1","COL25A1","COL27A1","COL2A1","COL5A3","COL7A1","COL9A1","COPS2","CORIN","CPNE3","CR1","CRB1","CRISPLD2","CROCC","CSF3R","CSTF2T","CTCF","CTNNA2","CTSG","CUL3","CUL9","CXorf58","CYBB","CYLC1","CYP26A1","CYP4A22","CYP4F12","CYP4F2","DAAM2","DAB2","DAG1","DAOA","DAXX","DAZAP2","DBX2","DCAF6","DCAF8","DCHS2","DCT","DCTD","DDX1","DDX17","DDX23","DDX53","DDX60","DHX32","DHX34","DIAPH2","DIO2","DLD","DLX3","DMD","DMRT3","DNAH11","DNAH3","DNAH5","DNAI1","DNAJC7","DNM2","DNMT1","DNMT3B","DOCK1","DOCK10","DOCK5","DOCK8","DOCK9","DOK2","DOPEY2","DSCAM","DUOXA2","DUSP1","DUSP26","DYNC1H1","DYNC2H1","DYRK4","DYSF","ECM2","EDC4","EFCAB6","EFTUD1","EGFL8","EGFLAM","EHD2","ELF1","ELF4","ELL","ELMOD1","ELN","ENC1","ENTPD1","EPB41L3","EPB41L5","EPGN","EPHA10","EPHA2","EPHA3","EPHA8","EPHB1","ESCO2","ETF1","ETV3","EWSR1","EXD1","EYA4","EZR","FAM115A","FAM123A","FAM171A1","FAM194A","FAM19A4","FAM47A","FAM48A","FAM90A1","FANCC","FANCI","FANCM","FAT1","FAT2","FAT4","FBN1","FBXO11","FBXO30","FCHSD1","FEZF2","FGD6","FGL2","FILIP1","FKBP8","FKTN","FLG","FLRT2","FLT1","FN1","FNDC1","FNIP2","FOXP4","FREM2","FRZB","FSD2","FZD1","G6PC","GABBR1","GABRA4","GABRB1","GABRG2","GABRR1","GALNT2","GANC","GATAD2B","GBP1","GCLM","GCM2","GCN1L1","GDF10","GDPD4","GDPD5","GEMIN4","GJB4","GLIS3","GLRA1","GNA15","GNAI2","GNB1","GNRHR","GPATCH8","GPBP1","GPR101","GPR115","GPR124","GPR125","GPR128","GPR183","GPR6","GPR98","GPRC5B","GPRC6A","GPX2","GRB10","GREM2","GRIK3","GRWD1","GSTM3","GUCA2A","GUCY2C","GUCY2D","GYG2","GZMB","HADH","HCFC1","HCLS1","HCN1","HDAC2","HDAC3","HEATR4","HEATR7B2","HELZ","HERC1","HERC2","HIST1H3D","HIVEP1","HIVEP2","HK1","HKR1","HLA-B","HMCN1","HNRNPUL1","HOOK3","HPS5","HSD17B1","HSD3B1","HSPA13","HSPA4","HSPB7","HSPG2","HTR5A","HYAL4","HYDIN","IFI44","IGHMBP2","IGSF5","IGSF9B","IKZF1","IKZF4","IL17RD","IL1R1","IL1RL2","IMMP2L","IMPG2","IPO7","ISLR","ITGA10","ITGAV","ITGAX","ITPR1","ITPR3","JAK3","JAM2","JMJD1C","JMJD5","KATNAL2","KCNE3","KCNH2","KCNH5","KCNH8","KCNJ6","KCNN3","KCNQ2","KCNQ3","KCNT1","KCNT2","KDM2B","KHDRBS3","KIAA0802","KIAA0831","KIAA0892","KIAA1109","KIAA1217","KIAA1267","KIAA1529","KIDINS220","KIF1C","KIF27","KLF15","KLHDC3","KLHDC7A","KLHL12","KLHL18","KLHL2","KLK7","KLRK1","KPRP","KRT13","KRT19","KRT20","KRT27","KRT79","KRTAP10-8","KRTAP24-1","KRTAP26-1","KRTAP4-2","KSR2","LAMA1","LAMA2","LAMA3","LAMA5","LARP4B","LARS","LAS1L","LBXCOR1","LCE1B","LEO1","LGTN","LILRB2","LIMA1","LIMS2","LMOD1","LNX1","LPA","LPPR1","LPPR4","LRBA","LRCH3","LRFN3","LRIG3","LRIT1","LRP1B","LRP5","LRRC15","LRRC2","LRRC37B","LRRC43","LRRC58","LRRFIP1","LRRTM2","LRWD1","LTA4H","LTBP3","LUZP2","LYRM5","LZTS1","MAEL","MAGEL2","MAGI1","MAGI3","MAP1B","MAP6","MAPK1","MAT1A","MAX","MBOAT1","MBTPS1","MCART2","MCHR2","MCM10","MDFI","MDH1B","MDM2","MECR","MED14","MED21","MEGF10","MEPE","METTL3","MEX3B","MFN1","MFSD6","MGA","MGAT4C","MGAT5B","MICAL2","MIER3","MLL2","MLL3","MLLT4","MMP25","MNDA","MORC3","MPI","MPL","MPND","MRE11A","MST1R","MTMR3","MUC17","MUC6","MXRA5","MYB","MYC","MYCBP2","MYEOV","MYF5","MYH14","MYH15","MYH6","MYLK","MYLK2","MYO1F","MYO3A","MYO5B","MYOC","MYST4","N4BP1","NAA15","NAE1","NAPA","NAPSA","NAT8L","NAV1","NBEAL1","NCCRP1","NCKAP5","NCOA3","NCOA7","NEB","NECAB2","NFKBIL2","NID2","NIPSNAP1","NKRF","NLRC4","NLRP11","NLRP8","NMNAT2","NOMO2","NONO","NOS1","NOTCH1","NOTCH2","NOTCH2NL","NOX3","NPAS4","NPC1","NPNT","NRAP","NRCAM","NRF1","NRK","NRXN1","NTRK3","NTSR2","NUMA1","NUP93","NXF3","OBSCN","ODZ2","ODZ3","OIT3","OLFML3","OPRM1","OR1J2","OR2AG1","OR2M2","OR2M3","OR2T10","OR3A2","OR4B1","OR4C15","OR4Q3","OR51A7","OR51L1","OR51S1","OR52D1","OR52E8","OR5AR1","OR5AS1","OR5K3","OR5M1","OR5W2","OR6B2","OR7D4","OR8A1","OR8B12","ORAI1","OSBP2","OSTalpha","OTOA","OXA1L","P2RY2","PA2G4","PABPC3","PAPPA2","PARD3","PARP14","PARP2","PARP6","PAX3","PCDH1","PCDH11X","PCDH15","PCDHA1","PCDHA4","PCDHA8","PCDHB1","PCDHB11","PCDHB16","PCDHB3","PCDHB6","PCDHGA10","PCDHGA3","PCDHGA5","PCDHGC4","PCLO","PDC","PDCL3","PDGFRA","PDGFRB","PDK4","PDS5B","PDXDC1","PEAR1","PEX13","PGBD1","PGM3","PHACTR1","PHLPP1","PI4KA","PIK3CB","PIWIL4","PKD2L1","PKHD1","PKIB","PKNOX1","PLA2G2D","PLA2G4C","PLA2G4D","PLCH2","PLCZ1","PLEC","PLEKHG2","PLOD1","PLRG1","PLXNA4","PLXND1","PMPCB","POC1A","POLA2","POLR2E","POLR3B","POM121C","POM121L12","POSTN","POU5F1","POU6F2","PPAP2A","PPIC","PPL","PPP1R9A","PPP2R2B","PPPDE2","PRAMEF16","PRDM16","PRDM9","PRKAA2","PRKCG","PRKD3","PRODH2","PRPF3","PRPF4B","PRR21","PRUNE2","PRX","PTAR1","PTPN14","PTPN5","PTPRE","PTPRG","PTPRN","PUS1","PXDNL","PYGO2","QRICH2","R3HDM1","RAB11FIP1","RAB17","RAB23","RAB25","RALGAPA2","RAP1B","RAP1GDS1","RAPGEF2","RASSF7","RASSF9","RBKS","RBM41","RBM9","RBMX","RCAN2","RCC2","RFC1","RFX3","RFX4","RGL1","RGNEF","RIF1","RIN2","RIT1","RNASEN","RNF111","RNF25","RP1","RPL32","RPL4","RPL6","RPL9","RPS3A","RPS6KA6","RSRC2","RTN4RL1","RUFY1","RUNX1T1","RYR1","SACS","SAGE1","SAP130","SBF2","SCAND3","SCARA3","SCARA5","SCARB1","SCEL","SCML2","SCN3A","SCTR","SDK1","SDK2","SDR42E1","SECISBP2L","SEL1L2","SELENBP1","SEMA6D","SENP7","SERPINA12","SERPINB12","SERPINB4","SETD2","SF3B1","SFRS2","SFRS6","SH2B3","SH3BP4","SH3TC2","SHANK1","SHQ1","SHROOM2","SIDT2","SIGLEC1","SLAMF7","SLC12A1","SLC12A3","SLC13A1","SLC15A1","SLC16A14","SLC17A3","SLC17A7","SLC18A1","SLC18A2","SLC1A1","SLC24A3","SLC24A4","SLC27A6","SLC30A6","SLC37A2","SLC38A6","SLC39A5","SLC43A1","SLC4A3","SLC6A20","SLC6A9","SLC7A13","SLC7A7","SLCO3A1","SLCO5A1","SLFNL1","SLITRK1","SLPI","SLTM","SMAD9","SMARCA2","SMC5","SMEK1","SMOC2","SMURF2","SNCAIP","SNED1","SNRNP200","SON","SORCS3","SOS1","SOX5","SPACA1","SPAM1","SPATA21","SPATS2L","SPDYA","SPEG","SPESP1","SPG11","SPHKAP","SPRR4","SPTLC2","SRCRB4D","SREBF2","SRRM2","SSSCA1","SSTR4","ST8SIA4","STC2","STEAP1","STEAP2","STK32A","STK33","STK36","STRC","STRN","STT3B","STX3","STXBP5L","SUDS3","SULF1","SULT1B1","SULT1C2","SUMO2","SUPT5H","SYNE1","SYNJ1","SYT1","SYT17","SYTL4","SYTL5","TACC2","TBC1D2","TBC1D21","TBC1D4","TBC1D8","TBC1D8B","TBX15","TBX18","TCEANC","TCEB3B","TCERG1L","TCF4","TCHHL1","TCL1A","TCTE3","TDRD10","TEK","TFAM","TGFBI","THEG","THOC5","THRB","TJAP1","TJP1","TLE6","TLR4","TM7SF4","TM9SF4","TMCO5A","TMEM104","TMEM108","TMEM18","TMEM198","TMEM200A","TMEM231","TMEM47","TMEM55A","TMPRSS13","TMTC2","TMTC4","TNNC2","TP73","TPH1","TPO","TPRG1","TPTE2","TRA2B","TRAM1L1","TRIM24","TRIM45","TRIM48","TRIO","TRIP4","TRNT1","TRO","TROAP","TRPC1","TRPC4AP","TRPM4","TRPM8","TSHZ3","TSKS","TSPAN2","TSPYL5","TTC26","TTLL2","TUBA1A","TUBGCP6","TUFT1","TUSC3","TYRO3","UBE2R2","UBN2","UBP1","UGT1A10","UNC45B","UPF1","UQCC","UQCR10","USP10","USP11","USP24","USP34","USP48","USP6","USP9X","VARS2","VASH1","VCAM1","VCAN","VIPR1","VLDLR","VPS13B","VPS13C","VPS13D","VPS26B","VPS72","VWA3B","VWCE","WAPAL","WBSCR17","WDR27","WDR35","WEE1","WEE2","WIPF1","WLS","WNK1","WNK3","WNK4","WRN","WSCD1","WSCD2","XIRP1","XIRP2","XKR4","YEATS2","ZBED4","ZBTB7B","ZC3HC1","ZFC3H1","ZFHX3","ZFHX4","ZFP42","ZMYND10","ZNF133","ZNF213","ZNF229","ZNF236","ZNF254","ZNF260","ZNF311","ZNF324B","ZNF37A","ZNF394","ZNF420","ZNF43","ZNF460","ZNF462","ZNF485","ZNF486","ZNF502","ZNF518B","ZNF548","ZNF616","ZNF638","ZNF642","ZNF646","ZNF677","ZNF689","ZNF75D","ZNF827","ZNF99","ZPBP"],"value":["FLT3","DNMT3A","NPM1","IDH2","IDH1","TET2","RUNX1","TP53","NRAS","CEBPA","WT1","PTPN11","KIT","KRAS","U2AF1","SMC3","PHF6","SMC1A","STAG2","TTN","FAM5C","ASXL1","RAD21","PLCE1","EZH2","CACNA1B","CACNA1E","COL12A1","CSMD1","DIS3","DNAH9","FCGBP","GBP4","KDM6A","MUC16","PTPRT","SMG1","SPEN","SUZ12","HNRNPK","MUC5B","ADAM11","APOB","ARAP2","ATP10B","BCOR","BMPER","BSN","C10orf28","CACNA2D3","CADM2","CADPS","CALR","CBFB","CBL","CD74","CECR2","CHD4","CMYA5","CNTN5","CNTNAP4","CRISPLD1","CSMD3","CUL1","DCLK1","DDR2","DDX41","DLC1","DOCK2","DRD2","DST","E2F8","EED","EGFR","ETV6","FAM154B","FAM40B","FAM57B","FAM65A","FRYL","GALNTL4","GATA2","GIGYF2","GJB3","GPR112","GRID1","GRIK2","GRIK4","GRM3","GRM8","GSTK1","HECW1","ILDR1","KCNA4","KCNK13","KCNU1","KDM3B","KDR","KIAA0240","KIAA1683","KIF2B","MAP2","MED12","MEFV","MTA2","MTMR8","MTUS2","NF1","NMUR2","NR2E1","NRXN3","OR11H12","OR13H1","PDCD2L","PHIP","PKHD1L1","PLEKHH1","PPP1R3A","PRAMEF2","PRPF8","PSME4","RBBP4","RBM16","RFC3","RIMS1","RNF213","RYR3","SCN1A","SEMA3A","SEMA4A","SETBP1","SI","TCEAL6","TET1","THRAP3","TNC","TOP3B","TRPM3","TTBK1","TUBA3C","UNC5B","WAC","ZBTB33","ZC3H18","ZNF687","CBX7","ABCA10","ABCA4","ABCB11","ABCC3","ABCF1","ABCG4","ABCG8","ABL1","ACOXL","ACPL2","ACSM2A","ACSS3","ACTBL2","ACTL7A","ACVR2B","ADAMTS1","ADAMTS12","ADAMTS16","ADAMTS17","ADAMTSL1","ADCY10","ADCY3","ADCY5","ADNP","ADRBK1","ADSS","AFF2","AFF4","AGBL2","AGXT2","AKAP12","AKAP13","AKAP5","AKD1","AKR7A2","ALDH1A3","ALG13","ALG6","ALMS1","ALPK3","ALS2CR11","AMOT","ANG","ANK2","ANK3","ANKRD12","ANKRD13A","ANKRD24","ANKRD26","ANKRD30A","ANO2","ANO3","AP1G2","AP1M1","AP3S2","AQP5","ARC","ARHGAP18","ARHGAP35","ARHGAP39","ARHGAP5","ARHGEF1","ARHGEF10L","ARHGEF11","ARHGEF19","ARHGEF5","ARHGEF6","ARID1A","ARID2","ARID4B","ARL3","ARSF","ASB11","ASB15","ASB4","ASTL","ASXL2","ASXL3","ATF7IP","ATG16L1","ATG4C","ATP11B","ATP13A5","ATP1B4","ATP2A2","ATP2B2","ATP2B3","ATP2C1","ATP6AP2","ATP6V1C1","ATP6V1G3","ATRNL1","ATXN7L1","AURKB","AURKC","B3GALT5","B4GALNT3","BAAT","BAI1","BAIAP2L1","BBS12","BCAN","BCHE","BCMO1","BCORL1","BECN1","BICD1","BLZF1","BMP10","BMP5","BMP6","BNC2","BOD1L","BPTF","BRCC3","BRMS1","BRPF1","BRS3","BRWD3","BTBD16","BTD","BUB1","BUB3","C10orf118","C10orf120","C10orf18","C10orf76","C11orf41","C11orf70","C12orf11","C12orf63","C13orf18","C15orf57","C15orf60","C16orf57","C19orf46","C19orf62","C1RL","C1orf103","C1orf105","C1orf168","C1orf183","C1orf51","C2","C20orf24","C20orf26","C22orf42","C2orf89","C3","C3orf67","C4BPB","C5","C6orf106","C6orf118","C6orf142","C6orf170","C6orf174","C7","C7orf10","C8orf80","C8orf84","C9orf171","C9orf43","C9orf78","C9orf93","CACNA1G","CACNA1S","CACNA2D4","CACNG2","CADM3","CAGE1","CAMK1G","CAMKV","CAMTA1","CAND1","CAPN6","CAPRIN2","CARD18","CASC5","CASP10","CASZ1","CATSPER4","CBX5","CC2D2A","CCBE1","CCDC150","CCDC24","CCDC57","CCDC60","CCDC67","CCL11","CCL16","CCL20","CCL21","CCNG2","CD109","CD320","CD70","CDC42","CDH16","CDH24","CDH4","CDHR2","CDON","CELSR1","CELSR3","CENPB","CENPF","CENPN","CEP170","CEP290","CFHR2","CGN","CHIC2","CHIT1","CHST6","CIC","CKAP4","CLCN1","CLCN6","CLDN11","CLDN14","CLDN18","CLPX","CLVS2","CNGA3","CNOT6","CNOT6L","CNTLN","CNTN6","CNTNAP5","COL11A2","COL22A1","COL25A1","COL27A1","COL2A1","COL5A3","COL7A1","COL9A1","COPS2","CORIN","CPNE3","CR1","CRB1","CRISPLD2","CROCC","CSF3R","CSTF2T","CTCF","CTNNA2","CTSG","CUL3","CUL9","CXorf58","CYBB","CYLC1","CYP26A1","CYP4A22","CYP4F12","CYP4F2","DAAM2","DAB2","DAG1","DAOA","DAXX","DAZAP2","DBX2","DCAF6","DCAF8","DCHS2","DCT","DCTD","DDX1","DDX17","DDX23","DDX53","DDX60","DHX32","DHX34","DIAPH2","DIO2","DLD","DLX3","DMD","DMRT3","DNAH11","DNAH3","DNAH5","DNAI1","DNAJC7","DNM2","DNMT1","DNMT3B","DOCK1","DOCK10","DOCK5","DOCK8","DOCK9","DOK2","DOPEY2","DSCAM","DUOXA2","DUSP1","DUSP26","DYNC1H1","DYNC2H1","DYRK4","DYSF","ECM2","EDC4","EFCAB6","EFTUD1","EGFL8","EGFLAM","EHD2","ELF1","ELF4","ELL","ELMOD1","ELN","ENC1","ENTPD1","EPB41L3","EPB41L5","EPGN","EPHA10","EPHA2","EPHA3","EPHA8","EPHB1","ESCO2","ETF1","ETV3","EWSR1","EXD1","EYA4","EZR","FAM115A","FAM123A","FAM171A1","FAM194A","FAM19A4","FAM47A","FAM48A","FAM90A1","FANCC","FANCI","FANCM","FAT1","FAT2","FAT4","FBN1","FBXO11","FBXO30","FCHSD1","FEZF2","FGD6","FGL2","FILIP1","FKBP8","FKTN","FLG","FLRT2","FLT1","FN1","FNDC1","FNIP2","FOXP4","FREM2","FRZB","FSD2","FZD1","G6PC","GABBR1","GABRA4","GABRB1","GABRG2","GABRR1","GALNT2","GANC","GATAD2B","GBP1","GCLM","GCM2","GCN1L1","GDF10","GDPD4","GDPD5","GEMIN4","GJB4","GLIS3","GLRA1","GNA15","GNAI2","GNB1","GNRHR","GPATCH8","GPBP1","GPR101","GPR115","GPR124","GPR125","GPR128","GPR183","GPR6","GPR98","GPRC5B","GPRC6A","GPX2","GRB10","GREM2","GRIK3","GRWD1","GSTM3","GUCA2A","GUCY2C","GUCY2D","GYG2","GZMB","HADH","HCFC1","HCLS1","HCN1","HDAC2","HDAC3","HEATR4","HEATR7B2","HELZ","HERC1","HERC2","HIST1H3D","HIVEP1","HIVEP2","HK1","HKR1","HLA-B","HMCN1","HNRNPUL1","HOOK3","HPS5","HSD17B1","HSD3B1","HSPA13","HSPA4","HSPB7","HSPG2","HTR5A","HYAL4","HYDIN","IFI44","IGHMBP2","IGSF5","IGSF9B","IKZF1","IKZF4","IL17RD","IL1R1","IL1RL2","IMMP2L","IMPG2","IPO7","ISLR","ITGA10","ITGAV","ITGAX","ITPR1","ITPR3","JAK3","JAM2","JMJD1C","JMJD5","KATNAL2","KCNE3","KCNH2","KCNH5","KCNH8","KCNJ6","KCNN3","KCNQ2","KCNQ3","KCNT1","KCNT2","KDM2B","KHDRBS3","KIAA0802","KIAA0831","KIAA0892","KIAA1109","KIAA1217","KIAA1267","KIAA1529","KIDINS220","KIF1C","KIF27","KLF15","KLHDC3","KLHDC7A","KLHL12","KLHL18","KLHL2","KLK7","KLRK1","KPRP","KRT13","KRT19","KRT20","KRT27","KRT79","KRTAP10-8","KRTAP24-1","KRTAP26-1","KRTAP4-2","KSR2","LAMA1","LAMA2","LAMA3","LAMA5","LARP4B","LARS","LAS1L","LBXCOR1","LCE1B","LEO1","LGTN","LILRB2","LIMA1","LIMS2","LMOD1","LNX1","LPA","LPPR1","LPPR4","LRBA","LRCH3","LRFN3","LRIG3","LRIT1","LRP1B","LRP5","LRRC15","LRRC2","LRRC37B","LRRC43","LRRC58","LRRFIP1","LRRTM2","LRWD1","LTA4H","LTBP3","LUZP2","LYRM5","LZTS1","MAEL","MAGEL2","MAGI1","MAGI3","MAP1B","MAP6","MAPK1","MAT1A","MAX","MBOAT1","MBTPS1","MCART2","MCHR2","MCM10","MDFI","MDH1B","MDM2","MECR","MED14","MED21","MEGF10","MEPE","METTL3","MEX3B","MFN1","MFSD6","MGA","MGAT4C","MGAT5B","MICAL2","MIER3","MLL2","MLL3","MLLT4","MMP25","MNDA","MORC3","MPI","MPL","MPND","MRE11A","MST1R","MTMR3","MUC17","MUC6","MXRA5","MYB","MYC","MYCBP2","MYEOV","MYF5","MYH14","MYH15","MYH6","MYLK","MYLK2","MYO1F","MYO3A","MYO5B","MYOC","MYST4","N4BP1","NAA15","NAE1","NAPA","NAPSA","NAT8L","NAV1","NBEAL1","NCCRP1","NCKAP5","NCOA3","NCOA7","NEB","NECAB2","NFKBIL2","NID2","NIPSNAP1","NKRF","NLRC4","NLRP11","NLRP8","NMNAT2","NOMO2","NONO","NOS1","NOTCH1","NOTCH2","NOTCH2NL","NOX3","NPAS4","NPC1","NPNT","NRAP","NRCAM","NRF1","NRK","NRXN1","NTRK3","NTSR2","NUMA1","NUP93","NXF3","OBSCN","ODZ2","ODZ3","OIT3","OLFML3","OPRM1","OR1J2","OR2AG1","OR2M2","OR2M3","OR2T10","OR3A2","OR4B1","OR4C15","OR4Q3","OR51A7","OR51L1","OR51S1","OR52D1","OR52E8","OR5AR1","OR5AS1","OR5K3","OR5M1","OR5W2","OR6B2","OR7D4","OR8A1","OR8B12","ORAI1","OSBP2","OSTalpha","OTOA","OXA1L","P2RY2","PA2G4","PABPC3","PAPPA2","PARD3","PARP14","PARP2","PARP6","PAX3","PCDH1","PCDH11X","PCDH15","PCDHA1","PCDHA4","PCDHA8","PCDHB1","PCDHB11","PCDHB16","PCDHB3","PCDHB6","PCDHGA10","PCDHGA3","PCDHGA5","PCDHGC4","PCLO","PDC","PDCL3","PDGFRA","PDGFRB","PDK4","PDS5B","PDXDC1","PEAR1","PEX13","PGBD1","PGM3","PHACTR1","PHLPP1","PI4KA","PIK3CB","PIWIL4","PKD2L1","PKHD1","PKIB","PKNOX1","PLA2G2D","PLA2G4C","PLA2G4D","PLCH2","PLCZ1","PLEC","PLEKHG2","PLOD1","PLRG1","PLXNA4","PLXND1","PMPCB","POC1A","POLA2","POLR2E","POLR3B","POM121C","POM121L12","POSTN","POU5F1","POU6F2","PPAP2A","PPIC","PPL","PPP1R9A","PPP2R2B","PPPDE2","PRAMEF16","PRDM16","PRDM9","PRKAA2","PRKCG","PRKD3","PRODH2","PRPF3","PRPF4B","PRR21","PRUNE2","PRX","PTAR1","PTPN14","PTPN5","PTPRE","PTPRG","PTPRN","PUS1","PXDNL","PYGO2","QRICH2","R3HDM1","RAB11FIP1","RAB17","RAB23","RAB25","RALGAPA2","RAP1B","RAP1GDS1","RAPGEF2","RASSF7","RASSF9","RBKS","RBM41","RBM9","RBMX","RCAN2","RCC2","RFC1","RFX3","RFX4","RGL1","RGNEF","RIF1","RIN2","RIT1","RNASEN","RNF111","RNF25","RP1","RPL32","RPL4","RPL6","RPL9","RPS3A","RPS6KA6","RSRC2","RTN4RL1","RUFY1","RUNX1T1","RYR1","SACS","SAGE1","SAP130","SBF2","SCAND3","SCARA3","SCARA5","SCARB1","SCEL","SCML2","SCN3A","SCTR","SDK1","SDK2","SDR42E1","SECISBP2L","SEL1L2","SELENBP1","SEMA6D","SENP7","SERPINA12","SERPINB12","SERPINB4","SETD2","SF3B1","SFRS2","SFRS6","SH2B3","SH3BP4","SH3TC2","SHANK1","SHQ1","SHROOM2","SIDT2","SIGLEC1","SLAMF7","SLC12A1","SLC12A3","SLC13A1","SLC15A1","SLC16A14","SLC17A3","SLC17A7","SLC18A1","SLC18A2","SLC1A1","SLC24A3","SLC24A4","SLC27A6","SLC30A6","SLC37A2","SLC38A6","SLC39A5","SLC43A1","SLC4A3","SLC6A20","SLC6A9","SLC7A13","SLC7A7","SLCO3A1","SLCO5A1","SLFNL1","SLITRK1","SLPI","SLTM","SMAD9","SMARCA2","SMC5","SMEK1","SMOC2","SMURF2","SNCAIP","SNED1","SNRNP200","SON","SORCS3","SOS1","SOX5","SPACA1","SPAM1","SPATA21","SPATS2L","SPDYA","SPEG","SPESP1","SPG11","SPHKAP","SPRR4","SPTLC2","SRCRB4D","SREBF2","SRRM2","SSSCA1","SSTR4","ST8SIA4","STC2","STEAP1","STEAP2","STK32A","STK33","STK36","STRC","STRN","STT3B","STX3","STXBP5L","SUDS3","SULF1","SULT1B1","SULT1C2","SUMO2","SUPT5H","SYNE1","SYNJ1","SYT1","SYT17","SYTL4","SYTL5","TACC2","TBC1D2","TBC1D21","TBC1D4","TBC1D8","TBC1D8B","TBX15","TBX18","TCEANC","TCEB3B","TCERG1L","TCF4","TCHHL1","TCL1A","TCTE3","TDRD10","TEK","TFAM","TGFBI","THEG","THOC5","THRB","TJAP1","TJP1","TLE6","TLR4","TM7SF4","TM9SF4","TMCO5A","TMEM104","TMEM108","TMEM18","TMEM198","TMEM200A","TMEM231","TMEM47","TMEM55A","TMPRSS13","TMTC2","TMTC4","TNNC2","TP73","TPH1","TPO","TPRG1","TPTE2","TRA2B","TRAM1L1","TRIM24","TRIM45","TRIM48","TRIO","TRIP4","TRNT1","TRO","TROAP","TRPC1","TRPC4AP","TRPM4","TRPM8","TSHZ3","TSKS","TSPAN2","TSPYL5","TTC26","TTLL2","TUBA1A","TUBGCP6","TUFT1","TUSC3","TYRO3","UBE2R2","UBN2","UBP1","UGT1A10","UNC45B","UPF1","UQCC","UQCR10","USP10","USP11","USP24","USP34","USP48","USP6","USP9X","VARS2","VASH1","VCAM1","VCAN","VIPR1","VLDLR","VPS13B","VPS13C","VPS13D","VPS26B","VPS72","VWA3B","VWCE","WAPAL","WBSCR17","WDR27","WDR35","WEE1","WEE2","WIPF1","WLS","WNK1","WNK3","WNK4","WRN","WSCD1","WSCD2","XIRP1","XIRP2","XKR4","YEATS2","ZBED4","ZBTB7B","ZC3HC1","ZFC3H1","ZFHX3","ZFHX4","ZFP42","ZMYND10","ZNF133","ZNF213","ZNF229","ZNF236","ZNF254","ZNF260","ZNF311","ZNF324B","ZNF37A","ZNF394","ZNF420","ZNF43","ZNF460","ZNF462","ZNF485","ZNF486","ZNF502","ZNF518B","ZNF548","ZNF616","ZNF638","ZNF642","ZNF646","ZNF677","ZNF689","ZNF75D","ZNF827","ZNF99","ZPBP"]}},"config":{"multiple":false,"search":true,"selectedValue":"FLT3","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9554548', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Gene to draw; genes are listed from most to least often mutated.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1405019">
#>             <label class="control-label" id="lollipop-label.top-label" for="lollipop-label.top">Label Top Positions</label>
#>             <input id="lollipop-label.top" type="number" class="shiny-input-number form-control" value="3" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1405019', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Label this many of the most mutated positions with their protein change.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7102736">
#>             <div class="material-switch">
#>               <label for="lollipop-show.domains" style="padding-right: 10px;">Domains</label>
#>               <input id="lollipop-show.domains" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="lollipop-show.domains"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7102736', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Draw the protein&#39;s domains (from maftools&#39; Pfam/SMART table, or the server&#39;s domains argument).'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Aesthetics" id="tab-1299-2">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div id="lollipop-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1264019">
#>             <label class="control-label" id="lollipop-point.size-label" for="lollipop-point.size">Point Size</label>
#>             <input id="lollipop-point.size" type="number" class="shiny-input-number form-control" value="10" data-update-on="change" min="2" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1264019', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Size of the mutation markers.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend" id="tab-1299-3">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8356562">
#>             <div class="material-switch">
#>               <label for="lollipop-legend.show" style="padding-right: 10px;">Show Legend</label>
#>               <input id="lollipop-legend.show" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="lollipop-legend.show"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8356562', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the legend. Turning it off also hides colorbars and any point size legend.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2981795">
#>             <label class="control-label" id="lollipop-legend.font.family-label" for="lollipop-legend.font.family">Legend Font</label>
#>             <div id="lollipop-legend.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="lollipop-legend.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2981795', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font family of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify3813288">
#>             <label class="control-label" for="lollipop-legend.font.color">Legend Font Color</label>
#>             <input id="lollipop-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3813288', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font color of the legend title and entry labels.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2478494">
#>             <label class="control-label" id="lollipop-legend.title.size-label" for="lollipop-legend.title.size">Legend Title Size</label>
#>             <input id="lollipop-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2478494', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify3449817">
#>             <label class="control-label" id="lollipop-legend.text.size-label" for="lollipop-legend.text.size">Legend Text Size</label>
#>             <input id="lollipop-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3449817', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-1299-4">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="lollipop-title.font.family-label" for="lollipop-title.font.family">Title Font</label>
#>             <div id="lollipop-title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="lollipop-title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="lollipop-title.font.color">Title Color</label>
#>             <input id="lollipop-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="lollipop-title.font.size-label" for="lollipop-title.font.size">Title Size</label>
#>             <input id="lollipop-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="lollipop-axis.title.horizontal.position-label" for="lollipop-axis.title.horizontal.position">Title position</label>
#>             <input id="lollipop-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="lollipop-axis.title.font.size-label" for="lollipop-axis.title.font.size">Axis Title Size</label>
#>             <input id="lollipop-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="lollipop-axis.title.font.color">Axis Title Color</label>
#>             <input id="lollipop-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="lollipop-axis.title.font.family-label" for="lollipop-axis.title.font.family">Axis Title Font</label>
#>             <div id="lollipop-axis.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="lollipop-axis.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="lollipop-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="lollipop-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="lollipop-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="lollipop-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="lollipop-grid.color">Gridline Color</label>
#>             <input id="lollipop-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="lollipop-axis.linecolor">Axis Line Color</label>
#>             <input id="lollipop-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="lollipop-axis.linewidth-label" for="lollipop-axis.linewidth">Axis Line Width</label>
#>             <input id="lollipop-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="lollipop-axis.tickfont.size-label" for="lollipop-axis.tickfont.size">Tick Label Size</label>
#>             <input id="lollipop-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="lollipop-axis.tickfont.color">Tick Label Color</label>
#>             <input id="lollipop-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="lollipop-axis.tickfont.family-label" for="lollipop-axis.tickfont.family">Tick Label Font</label>
#>             <div id="lollipop-axis.tickfont.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="lollipop-axis.tickfont.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="lollipop-axis.tickangle.x-label" for="lollipop-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="lollipop-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="lollipop-axis.tickangle.y-label" for="lollipop-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="lollipop-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="lollipop-axis.ticks-label" for="lollipop-axis.ticks">Tick Position</label>
#>             <div id="lollipop-axis.ticks" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="lollipop-axis.ticks">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Outside","Inside","(none)"],"value":["outside","inside",""]}},"config":{"multiple":false,"search":false,"selectedValue":"outside","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="lollipop-axis.tickcolor">Tick Mark Color</label>
#>             <input id="lollipop-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="lollipop-axis.ticklen-label" for="lollipop-axis.ticklen">Tick Mark Length</label>
#>             <input id="lollipop-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="lollipop-axis.tickwidth-label" for="lollipop-axis.tickwidth">Tick Mark Width</label>
#>             <input id="lollipop-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="lollipop-facet.title.font.size-label" for="lollipop-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="lollipop-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="lollipop-facet.title.font.color">Facet Title Color</label>
#>             <input id="lollipop-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="lollipop-facet.title.font.family-label" for="lollipop-facet.title.font.family">Facet Title Font</label>
#>             <div id="lollipop-facet.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="lollipop-facet.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-1299-5">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4197834">
#>             <label class="control-label" id="lollipop-hline.intercepts-label" for="lollipop-hline.intercepts">Y-intercepts</label>
#>             <input id="lollipop-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4197834', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6591100">
#>             <label class="control-label" id="lollipop-hline.colors-label" for="lollipop-hline.colors">Y Colors</label>
#>             <input id="lollipop-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6591100', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for horizontal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9539570">
#>             <label class="control-label" id="lollipop-hline.widths-label" for="lollipop-hline.widths">Y Widths</label>
#>             <input id="lollipop-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9539570', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for horizontal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4698937">
#>             <label class="control-label" id="lollipop-hline.linetypes-label" for="lollipop-hline.linetypes">Y Line Types</label>
#>             <input id="lollipop-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4698937', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for horizontal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1506211">
#>             <label class="control-label" id="lollipop-hline.opacities-label" for="lollipop-hline.opacities">Y Opacities (0-1)</label>
#>             <input id="lollipop-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1506211', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of horizontal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify9025228">
#>             <label class="control-label" id="lollipop-vline.intercepts-label" for="lollipop-vline.intercepts">X-intercepts</label>
#>             <input id="lollipop-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9025228', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4380257">
#>             <label class="control-label" id="lollipop-vline.colors-label" for="lollipop-vline.colors">X Colors</label>
#>             <input id="lollipop-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4380257', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for vertical reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify8067556">
#>             <label class="control-label" id="lollipop-vline.widths-label" for="lollipop-vline.widths">X Widths</label>
#>             <input id="lollipop-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8067556', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for vertical reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4814955">
#>             <label class="control-label" id="lollipop-vline.linetypes-label" for="lollipop-vline.linetypes">X Line Types</label>
#>             <input id="lollipop-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4814955', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for vertical reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2580382">
#>             <label class="control-label" id="lollipop-vline.opacities-label" for="lollipop-vline.opacities">X Opacities (0-1)</label>
#>             <input id="lollipop-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2580382', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of vertical reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1701358">
#>             <label class="control-label" id="lollipop-abline.slopes-label" for="lollipop-abline.slopes">Ab Slopes</label>
#>             <input id="lollipop-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1701358', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Slope(s) of diagonal reference lines (rise/run), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1606107">
#>             <label class="control-label" id="lollipop-abline.intercepts-label" for="lollipop-abline.intercepts">Ab Y-intercepts</label>
#>             <input id="lollipop-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1606107', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6613904">
#>             <label class="control-label" id="lollipop-abline.colors-label" for="lollipop-abline.colors">Ab Colors</label>
#>             <input id="lollipop-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6613904', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for diagonal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify4685521">
#>             <label class="control-label" id="lollipop-abline.widths-label" for="lollipop-abline.widths">Ab Widths</label>
#>             <input id="lollipop-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4685521', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for diagonal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5453928">
#>             <label class="control-label" id="lollipop-abline.linetypes-label" for="lollipop-abline.linetypes">Ab Line Types</label>
#>             <input id="lollipop-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5453928', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for diagonal reference lines (solid, dashed, dotted, dotdash, longdash, twodash)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7250982">
#>             <label class="control-label" id="lollipop-abline.opacities-label" for="lollipop-abline.opacities">Ab Opacities (0-1)</label>
#>             <input id="lollipop-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7250982', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of diagonal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-1299-6">
#>       <div class="vizmodules-input-grid" style="--viz-input-columns: 2;">
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="lollipop-download.format-label" for="lollipop-download.format">Download Format</label>
#>             <div id="lollipop-download.format" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="lollipop-download.format">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["svg","png","jpeg","webp"],"value":["svg","png","jpeg","webp"]}},"config":{"multiple":false,"search":false,"selectedValue":"svg","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify5254825">
#>             <label class="control-label" id="lollipop-margin.t-label" for="lollipop-margin.t">Margin Top</label>
#>             <input id="lollipop-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5254825', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify6189364">
#>             <label class="control-label" id="lollipop-margin.b-label" for="lollipop-margin.b">Margin Bottom</label>
#>             <input id="lollipop-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6189364', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify1789609">
#>             <label class="control-label" id="lollipop-margin.l-label" for="lollipop-margin.l">Margin Left</label>
#>             <input id="lollipop-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1789609', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7677212">
#>             <label class="control-label" id="lollipop-margin.r-label" for="lollipop-margin.r">Margin Right</label>
#>             <input id="lollipop-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7677212', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8162949">
#>             <label class="control-label" for="lollipop-shape.fill">Shape Fill</label>
#>             <input id="lollipop-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8162949', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1945824">
#>             <label class="control-label" for="lollipop-shape.line.color">Shape Line Color</label>
#>             <input id="lollipop-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1945824', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify2125141">
#>             <label class="control-label" id="lollipop-shape.line.width-label" for="lollipop-shape.line.width">Shape Line Width</label>
#>             <input id="lollipop-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2125141', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2488301">
#>             <label class="control-label" id="lollipop-shape.linetype-label" for="lollipop-shape.linetype">Shape Linetype</label>
#>             <div id="lollipop-shape.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="lollipop-shape.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dot","dash","longdash","dashdot","longdashdot"],"value":["solid","dot","dash","longdash","dashdot","longdashdot"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2488301', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell">
#>           <div class="form-group shiny-input-container" id="tipify7480038">
#>             <label class="control-label" id="lollipop-shape.opacity-label" for="lollipop-shape.opacity">Shape Opacity</label>
#>             <input id="lollipop-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7480038', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="module-tack" style="margin-top: 12px;">
#>   <div class="module-tack-switch" style="margin-bottom: 4px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="lollipop-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="lollipop-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="lollipop-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="lollipop-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="lollipop-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary viz-source-download" data-viz-source-ns="lollipop-" download href="" id="lollipop-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('lollipop-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file and as SVG and PNG images of it as it looks now, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
