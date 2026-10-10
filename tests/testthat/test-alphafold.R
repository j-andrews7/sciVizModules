# Tests for read_alphafold() and the alphafoldConfidence module. The bundled
# AlphaFold DB files are read as shipped; the other formats use small fixtures
# written here.

af_example_files <- function() {
    list(
        pae = system.file("extdata", "AF-P04637-F1-predicted_aligned_error_v6.json.gz", package = "sciVizModules"),
        confidence = system.file("extdata", "AF-P04637-F1-confidence_v6.json.gz", package = "sciVizModules")
    )
}

write_lines <- function(lines, ext) {
    path <- tempfile(fileext = ext)
    writeLines(lines, path)
    path
}

# A PDB with CA atoms for two residues in each of chains A and B, plus an N atom
# that must be ignored. B-factors carry the pLDDT, as AlphaFold writes them.
af_pdb_fixture <- function() {
    atom <- function(serial, name, chain, res, b) {
        sprintf("ATOM  %5d %-4s %3s %1s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f           %1s",
            serial, name, "ALA", chain, res, 1, 2, 3, 1, b, "C")
    }
    write_lines(c(
        atom(1, " N  ", "A", 1, 11),
        atom(2, " CA ", "A", 1, 95.5),
        atom(3, " CA ", "A", 2, 72.0),
        atom(4, " CA ", "B", 1, 55.0),
        atom(5, " CA ", "B", 2, 30.0),
        "END"
    ), ".pdb")
}

test_that("all alphafold functions are exported", {
    for (name in c("read_alphafold", "alphafoldConfidence", "alphafoldConfidenceInputsUI",
        "alphafoldConfidenceOutputUI", "alphafoldConfidenceServer", "alphafoldConfidenceApp")) {
        expect_true(is.function(get0(name, envir = asNamespace("sciVizModules"))), info = name)
    }
})

test_that("the bundled AlphaFold DB files read into pLDDT and a square PAE", {
    f <- af_example_files()
    af <- read_alphafold(pae = f$pae, confidence = f$confidence)
    expect_s3_class(af, "alphafold_confidence")
    expect_identical(nrow(af$plddt), 393L)
    expect_identical(dim(af$pae), c(393L, 393L))
    expect_true(all(diag(af$pae) == 0))
    expect_equal(af$max_pae, 31.75)
    expect_identical(as.character(af$plddt$category[af$plddt$plddt > 90][1]), "Very high")
    expect_output(print(af), "393 residues")
})

test_that("ColabFold scores give both pLDDT and PAE", {
    path <- write_lines(
        '{"plddt": [91.2, 80, 60, 40], "pae": [[0,1,2,3],[1,0,1,2],[2,1,0,1],[3,2,1,0]], "max_pae": 31.75, "ptm": 0.5}',
        ".json"
    )
    af <- read_alphafold(pae = path)
    expect_identical(af$plddt$plddt, c(91.2, 80, 60, 40))
    expect_identical(as.character(af$plddt$category), c("Very high", "Confident", "Low", "Very low"))
    expect_identical(af$pae[1, 4], 3)
})

test_that("the older AlphaFold DB PAE layout is read row by row", {
    path <- write_lines('[{"residue1": [1,1,2,2], "residue2": [1,2,1,2], "distance": [0,4,5,0]}]', ".json")
    af <- read_alphafold(pae = path)
    expect_identical(af$pae, matrix(c(0, 4, 5, 0), 2, byrow = TRUE))
})

test_that("pLDDT and chains come from a structure's C-alpha B-factors (PDB and mmCIF)", {
    af <- read_alphafold(structure = af_pdb_fixture())
    expect_identical(af$plddt$chain, c("A", "A", "B", "B"))
    expect_identical(af$plddt$residue, c(1L, 2L, 1L, 2L))
    expect_identical(af$plddt$plddt, c(95.5, 72, 55, 30))

    cif <- write_lines(c(
        "data_model", "loop_",
        "_atom_site.group_PDB", "_atom_site.id", "_atom_site.label_atom_id", "_atom_site.label_comp_id",
        "_atom_site.auth_asym_id", "_atom_site.auth_seq_id", "_atom_site.B_iso_or_equiv",
        "ATOM 1 N ALA A 1 11.0",
        "ATOM 2 CA ALA A 1 95.5",
        "ATOM 3 CA ALA B 1 42.0",
        "#"
    ), ".cif")
    af_cif <- read_alphafold(structure = cif)
    expect_identical(af_cif$plddt$chain, c("A", "B"))
    expect_identical(af_cif$plddt$plddt, c(95.5, 42))
})

test_that("unrecognised or mismatched inputs fail clearly", {
    expect_error(read_alphafold(), "at least one")
    expect_error(read_alphafold(pae = write_lines('{"foo": 1}', ".json")), "not an AlphaFold DB PAE")
    expect_error(read_alphafold(confidence = write_lines('{"foo": 1}', ".json")), "confidence file")
    expect_error(read_alphafold(pae = write_lines("{not json", ".json")), "not valid JSON")
    f <- af_example_files()
    expect_error(read_alphafold(pae = f$pae, structure = af_pdb_fixture()), "covers 393 residues")
})

test_that("the plot has a pLDDT track over a reversed PAE heatmap, with bands and chain lines", {
    f <- af_example_files()
    af <- read_alphafold(pae = f$pae, confidence = f$confidence)
    built <- plotly::plotly_build(alphafoldConfidence(af))
    expect_identical(vapply(built$x$data, `[[`, "", "type"), c("scatter", "heatmap"))
    expect_identical(built$x$layout$yaxis2$autorange, "reversed")
    expect_length(built$x$layout$shapes, 4)

    zoom <- plotly::plotly_build(alphafoldConfidence(af, residue.start = 100, residue.end = 289, show.bands = FALSE))
    expect_identical(dim(zoom$x$data[[2]]$z), c(190L, 190L))
    expect_length(zoom$x$layout$shapes, 0)
    expect_error(alphafoldConfidence(af, residue.start = 300, residue.end = 10), "empty")

    # Two chains: one boundary across both panels.
    two <- read_alphafold(structure = af_pdb_fixture())
    two$pae <- matrix(1, 4, 4)
    shapes <- plotly::plotly_build(alphafoldConfidence(two, show.bands = FALSE))$x$layout$shapes
    expect_length(shapes, 2)
    expect_equal(shapes[[1]]$x0, 2.5)
})

test_that("the server builds, finishes and exports the pLDDT table", {
    f <- af_example_files()
    af <- read_alphafold(pae = f$pae, confidence = f$confidence)
    shiny::testServer(
        alphafoldConfidenceServer,
        args = list(data = shiny::reactive(af)),
        expr = {
            do.call(session$setInputs, c(
                list(auto.update = TRUE, residue.start = 1, residue.end = 120, max.pae = 30,
                    track.height = 0.3, show.bands = TRUE, show.chains = TRUE, line.color = "#333333",
                    band.very.high = "#0053D6", band.confident = "#65CBF3", band.low = "#FFDB13",
                    band.very.low = "#FF7D45", pae.low.color = "#0B4D1F", pae.high.color = "#FFFFFF",
                    download.format = "png"),
                test_axes_inputs(), test_legend_inputs()
            ))
            built <- plotly::plotly_build(generate_plot())
            expect_identical(built$x$data[[2]]$zmax, 30)
            # The four bands, and a border around the track and the heatmap, which share an axis.
            expect_length(built$x$layout$shapes, 6)
            expect_identical(nrow(plot_source_reactive()$stats), 120L)
        }
    )
    expect_true(inherits(alphafoldConfidenceInputsUI("af", af), c("shiny.tag", "shiny.tag.list")))
    expect_error(alphafoldConfidenceInputsUI("af", list()), "read_alphafold")
})
