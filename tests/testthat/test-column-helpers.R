# Unit tests for the shared column-detection helpers (enrichment_helpers.R).
#
# These target the pure, deterministic internal primitives used across the
# differential-expression, enrichment, and dose-response modules.

test_that(".detect_column returns the first matching candidate in priority order", {
    df <- data.frame(padj = 1, FDR = 1, other = "x")
    expect_identical(
        .detect_column(df, c("FDR", "padj")),
        "FDR"
    )
    expect_identical(
        .detect_column(df, c("padj", "FDR")),
        "padj"
    )
})

test_that(".detect_column returns NULL when nothing matches", {
    df <- data.frame(a = 1, b = 2)
    expect_null(.detect_column(df, c("x", "y", "z")))
})

test_that(".detect_column honours the numeric requirement", {
    df <- data.frame(score = c("a", "b"), value = c(1, 2), stringsAsFactors = FALSE)
    expect_null(.detect_column(df, "score", numeric = TRUE))
    expect_identical(
        .detect_column(df, c("score", "value"), numeric = TRUE),
        "value"
    )
})

test_that(".detect_column skips excluded columns", {
    df <- data.frame(ID = "GO:1", Description = "term", stringsAsFactors = FALSE)
    expect_identical(
        .detect_column(df, c("ID", "Description"), exclude = "ID"),
        "Description"
    )
})

test_that(".enrichment_pval_candidates is a non-empty character vector", {
    cand <- .enrichment_pval_candidates
    expect_type(cand, "character")
    expect_true(all(c("qvalue", "p.adjust", "pvalue") %in% cand))
})
