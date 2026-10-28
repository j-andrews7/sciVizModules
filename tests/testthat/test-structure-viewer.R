# Tests for read_structure() and the structureViewer module.

structure_example_file <- function() {
    system.file("extdata", "AF-P04637-F1-model_v6.pdb.gz", package = "sciVizModules")
}

test_that("all structureViewer functions are exported", {
    for (name in c("read_structure", "structureViewer", "structureViewerInputsUI", "structureViewerOutputUI",
        "structureViewerServer", "structureViewerApp")) {
        expect_true(is.function(get0(name, envir = asNamespace("sciVizModules"))), info = name)
    }
})

test_that("read_structure() reads the bundled AlphaFold model", {
    x <- read_structure(structure_example_file())
    expect_s3_class(x, "sci_structure")
    expect_identical(x$format, "pdb")
    expect_true(x$alphafold)
    expect_identical(nrow(x$residues), 393L)
    expect_identical(names(x$residues), c("chain", "residue", "bfactor", "category"))
    expect_output(print(x), "393 residues")
    # The same model gives read_alphafold() its pLDDT.
    expect_equal(read_alphafold(structure = structure_example_file())$plddt$plddt, x$residues$bfactor)
})

test_that("read_structure() reads mmCIF and flags non-AlphaFold files", {
    cif <- tempfile(fileext = ".cif")
    writeLines(c(
        "data_test", "loop_",
        "_atom_site.group_PDB", "_atom_site.id", "_atom_site.label_atom_id", "_atom_site.label_comp_id",
        "_atom_site.auth_asym_id", "_atom_site.auth_seq_id", "_atom_site.B_iso_or_equiv",
        "ATOM 1 CA ALA A 1 20.5", "ATOM 2 CA GLY A 2 31.0", "ATOM 3 CA SER B 1 25.0", "#"
    ), cif)
    x <- read_structure(cif)
    expect_identical(x$format, "cif")
    expect_false(x$alphafold)
    expect_identical(x$residues$chain, c("A", "A", "B"))
    expect_error(read_structure("missing.pdb"), "File not found")
})

test_that("pLDDT bands cover every residue once and highlights parse", {
    x <- read_structure(structure_example_file())
    sel <- .structure_selections(x)
    bands <- Filter(function(s) startsWith(s$param$name, "band."), sel)
    expect_length(bands, 4)
    expect_identical(vapply(bands, function(s) s$param$color, ""), c("#0053D6", "#65CBF3", "#FFDB13", "#FF7D45"))

    # Expand the selection strings back into residues: every residue, exactly once.
    expand <- function(sele) {
        unlist(lapply(strsplit(sele, " or ", fixed = TRUE)[[1]], function(part) {
            r <- as.integer(strsplit(sub(":.*$", "", part), "-", fixed = TRUE)[[1]])
            if (length(r) == 2) seq(r[1], r[2]) else r
        }))
    }
    covered <- unlist(lapply(bands, function(s) expand(s$param$sele)))
    expect_identical(sort(covered), sort(x$residues$residue))

    expect_identical(.structure_sele(data.frame(chain = c("A", "A", "A", "B"), residue = c(1, 2, 5, 9))),
        "1-2:A or 5:A or 9:B")
    expect_identical(.structure_parse_highlight("175, 245-250 B:12; nope"), "175 or 245-250 or 12:B")
    expect_null(.structure_parse_highlight(""))

    chains <- .structure_selections(x, color.by = "chainname", show.ligands = FALSE, highlight = "175")
    expect_identical(vapply(chains, function(s) s$param$name, ""), c("main", "highlight"))
    expect_identical(chains[[1]]$param$colorScheme, "chainname")
})

test_that("structureViewer() returns an NGL widget with the representations", {
    x <- read_structure(structure_example_file())
    w <- structureViewer(x, color.by = "sstruc", highlight = "175", background = "#000000")
    expect_s3_class(w, "NGLVieweR")
    reps <- w$x$structures[[1]]$addRepresentation
    expect_true(length(reps) >= 2)
    expect_identical(w$x$stageParameters$backgroundColor, "#000000")
    expect_error(structureViewer(list()), "read_structure")
})

test_that("the server restyles through the proxy without re-rendering", {
    x <- read_structure(structure_example_file())
    renders <- 0
    added <- list()
    removed <- character(0)
    real_viewer <- structureViewer
    local_mocked_bindings(
        structureViewer = function(...) {
            renders <<- renders + 1
            real_viewer(...)
        },
        addSelection = function(proxy, type, param = list(), structureIndex = NULL) {
            added[[length(added) + 1]] <<- param
            proxy
        },
        removeSelection = function(proxy, name) {
            removed <<- c(removed, name)
            proxy
        }
    )
    shiny::testServer(structureViewerServer, args = list(data = shiny::reactive(x)), expr = {
        session$setInputs(representation = "cartoon", color.by = "plddt", highlight.residues = "",
            highlight.color = "#E7298A", highlight.representation = "ball+stick", show.ligands = TRUE,
            background = "#FFFFFF", quality = "medium", spin = FALSE)
        output$structureViewer
        expect_identical(renders, 1)
        expect_true(all(paste0("band.", 1:4) %in% drawn()))

        session$setInputs(color.by = "chainname")
        session$flushReact()
        expect_identical(renders, 1)
        expect_true(all(paste0("band.", 1:4) %in% removed))
        expect_true("main" %in% vapply(added, function(p) p$name, ""))
        expect_identical(drawn(), c("main", "ligand"))
    })
})

test_that("the module UI builds and the download names the structure file", {
    x <- read_structure(structure_example_file())
    expect_true(inherits(structureViewerInputsUI("v", x), c("shiny.tag", "shiny.tag.list")))
    expect_true(inherits(structureViewerOutputUI("v"), c("shiny.tag", "shiny.tag.list")))
    expect_identical(.structure_defaults(x)$color.by, "plddt")
    expect_identical(.structure_defaults(x, list(color.by = "sstruc"))$color.by, "sstruc")
})
