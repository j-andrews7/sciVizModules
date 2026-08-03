# Unit tests for the GO sunburst ("fan") plot helpers (goFanPlot_helpers.R).
#
# These target the pure GO-identifier and ontology detection helpers; they do
# not require the (Suggested) GOfan package.

test_that(".extract_go_id pulls the first GO id out of messy strings", {
    x <- c("immune response (GO:0006955)", "GO:0002376", "no id here", NA)
    expect_identical(
        .extract_go_id(x),
        c("GO:0006955", "GO:0002376", NA_character_, NA_character_)
    )
})

test_that(".extract_go_id accepts factors and one-column data frames", {
    expect_identical(
        .extract_go_id(factor("GO:0006955")),
        "GO:0006955"
    )
    expect_identical(
        .extract_go_id(data.frame(x = "GO:0002376")),
        "GO:0002376"
    )
})

test_that(".gofan_id_col finds a column containing GO ids", {
    df <- data.frame(
        term = c("immune response (GO:0006955)", "response (GO:0002376)"),
        score = c(1, 2),
        stringsAsFactors = FALSE
    )
    expect_identical(.gofan_id_col(df), "term")
})

test_that(".gofan_id_col falls back to an 'ID' column when no GO ids present", {
    df <- data.frame(ID = c("A", "B"), value = c(1, 2), stringsAsFactors = FALSE)
    expect_identical(.gofan_id_col(df), "ID")
    expect_null(.gofan_id_col(data.frame(a = 1, b = 2)))
})

test_that(".gofan_onto returns the most common valid ontology, defaulting to BP", {
    df <- data.frame(ONTOLOGY = c("BP", "BP", "MF"), stringsAsFactors = FALSE)
    expect_identical(.gofan_onto(df), "BP")
    # No ontology column -> default.
    expect_identical(.gofan_onto(data.frame(x = 1)), "BP")
    # Case-insensitive and ignores invalid values.
    df2 <- data.frame(ontology = c("mf", "mf", "junk"), stringsAsFactors = FALSE)
    expect_identical(.gofan_onto(df2), "MF")
})

test_that(".gofan_palettes is a named character vector of colorscales", {
    pal <- .gofan_palettes
    expect_type(pal, "character")
    expect_true(all(nzchar(names(pal))))
    expect_true("Viridis" %in% pal)
})
