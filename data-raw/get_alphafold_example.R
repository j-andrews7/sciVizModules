# Download the AlphaFold example shipped with sciVizModules.
#
# The per-residue confidence (pLDDT) and predicted aligned error (PAE) files and
# the predicted model of the AlphaFold DB prediction for human p53 (TP53, UniProt
# P04637, 393 residues), used by read_alphafold(), read_structure(), and the
# alphafoldConfidence and structureViewer modules. p53 makes a good
# example: a confident DNA-binding domain and tetramerisation domain separated
# by disordered linkers, which shows up as blocks in the PAE.
#
# AlphaFold DB data is available under CC-BY 4.0
# (https://alphafold.ebi.ac.uk/assets/License-Disclaimer.pdf). Please cite
# Jumper et al. (2021) Nature 596:583-589 and Varadi et al. (2024) Nucleic Acids
# Research 52:D368-D375.
#
# Retrieved 2026-10-01; database version 6.

base <- "https://alphafold.ebi.ac.uk/files/AF-P04637-F1-"
files <- c("predicted_aligned_error_v6.json", "confidence_v6.json", "model_v6.pdb")

dir.create("inst/extdata", showWarnings = FALSE, recursive = TRUE)
for (f in files) {
    tmp <- tempfile(fileext = paste0(".", tools::file_ext(f)))
    utils::download.file(paste0(base, f), tmp, mode = "wb")
    out <- gzfile(file.path("inst/extdata", paste0("AF-P04637-F1-", f, ".gz")), "wb")
    writeLines(readLines(tmp, warn = FALSE), out)
    close(out)
}
