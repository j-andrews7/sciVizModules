# The showcase registry (R/module_showcase.R) is what the module gallery
# (sciModuleGalleryApp()), the Figure Builder and every module's *App() open
# on. These tests keep it complete -- every module in the package has an entry,
# so a new module cannot ship without a gallery tab -- and keep its defaults
# honest: they must name things that exist in their datasets and be accepted
# by the controls they seed, since get_default() quietly drops a value it
# rejects and ignores a key it does not know.


# The package's modules: every X with XInputsUI, XOutputUI, XServer and XApp
# all exported. Derived from the exports so it cannot drift from the package.
.exported_modules <- function() {
    exports <- getNamespaceExports("sciVizModules")
    stems <- sub("InputsUI$", "", grep("InputsUI$", exports, value = TRUE))
    sort(stems[vapply(stems, function(s) {
        all(paste0(s, c("OutputUI", "Server", "App")) %in% exports)
    }, logical(1))])
}

# Modules without an entry, and entries naming no module of the package.
.showcase_gaps <- function(showcase, modules = .exported_modules()) {
    showcased <- vapply(showcase, function(e) e$module, character(1))
    list(missing = setdiff(modules, showcased), stale = setdiff(showcased, modules))
}


test_that("every module in the package has a gallery showcase entry", {
    modules <- .exported_modules()
    expect_gte(length(modules), 40)

    gaps <- .showcase_gaps(.sci_module_showcase(), modules)
    expect(
        !length(gaps$missing),
        paste0(
            "No gallery showcase entry for: ", paste(gaps$missing, collapse = ", "), ". ",
            "Every module needs one in .sci_module_showcase() (R/module_showcase.R); ",
            "it gives the module its gallery tab, its *App() example and, for a data-frame module, ",
            "its Figure Builder entry."
        )
    )
    expect(
        !length(gaps$stale),
        paste0("Showcase entries for modules the package does not export: ", paste(gaps$stale, collapse = ", "))
    )

    showcased <- vapply(.sci_module_showcase(), function(e) e$module, character(1))
    expect_false(anyDuplicated(showcased) > 0)
})

test_that("the completeness check reports a module whose entry is removed", {
    showcase <- .sci_module_showcase()
    gaps <- .showcase_gaps(showcase[setdiff(names(showcase), "volcano")])
    expect_identical(gaps$missing, "volcanoPlot")
    expect_length(gaps$stale, 0)
})

test_that("every showcase entry is well-formed", {
    showcase <- .sci_module_showcase()
    catalogue <- .sci_example_catalogue()

    for (id in names(showcase)) {
        e <- showcase[[id]]
        expect_true(e$group %in% .sci_gallery_groups, info = id)
        for (field in c("label", "tab_label", "description")) {
            value <- e[[field]]
            expect_true(is.character(value) && length(value) == 1 && nzchar(value), info = paste(id, field))
        }
        expect_true(e$kind %in% c("df", "object"), info = id)
        expect_true(e$dataset %in% names(catalogue), info = id)
        expect_true(all(e$app_datasets %in% names(catalogue)), info = id)
        expect_true(is.list(e$defaults), info = id)
        expect_true(all(nzchar(names(e$defaults))), info = id)

        # The trio really is the named module's.
        expect_identical(e$inputs_ui, get(paste0(e$module, "InputsUI")), info = id)
        expect_identical(e$output_ui, get(paste0(e$module, "OutputUI")), info = id)
        expect_identical(e$server_fn, get(paste0(e$module, "Server")), info = id)

        if (identical(e$kind, "object")) expect_true(is.function(e$preview), info = id)
    }

    # Labels a person picks a tab by are unique.
    tab_labels <- vapply(showcase, function(e) e$tab_label, character(1))
    expect_false(anyDuplicated(tab_labels) > 0)
})

test_that("every menu has a module, and the gallery groups have no strays", {
    groups <- vapply(.sci_module_showcase(), function(e) e$group, character(1))
    expect_setequal(unique(groups), .sci_gallery_groups)
})


# ---- Defaults name real columns and values ----------------------------------

# Defaults whose values are column names (or, for the single-cell modules,
# column or gene names) of the entry's dataset.
.column_keys <- c(
    "x.by", "y.by", "x.data", "y.data", "color.by", "size.by", "fill.by", "group.by", "annotate.by",
    "split.by", "time", "status", "covariates", "response", "predictors", "clinical.tracks", "var",
    "vars", "sample.by", "trajectory.group.by", "dh.genes", "dh.order.by", "annot.by", "color.var",
    "x.var", "y.var", "fill", "sub_rect", "column_split_cols"
)

# The names a dataset's column-valued defaults may take.
.showcase_names <- function(data) {
    if (is.data.frame(data)) {
        return(names(data))
    }
    if (inherits(data, "pca")) {
        return(names(data$metadata))
    }
    if (is.list(data) && !is.null(data$object)) {
        data <- data$object
    }
    if (methods::is(data, "SummarizedExperiment")) {
        return(c(names(SummarizedExperiment::colData(data)), rownames(data)))
    }
    character(0)
}

test_that("every column-valued showcase default names a column of its dataset", {
    showcase <- .sci_module_showcase()
    checked <- 0

    for (id in names(showcase)) {
        e <- showcase[[id]]
        keys <- intersect(names(e$defaults), .column_keys)
        if (!length(keys) || length(.sci_showcase_missing(e))) next
        valid <- .showcase_names(.sci_example_dataset(e$dataset))
        for (key in keys) {
            expect_true(all(e$defaults[[key]] %in% valid), info = paste(id, key))
            checked <- checked + 1
        }
    }
    expect_gt(checked, 20)
})

test_that("the highlighted genes, variants and residues exist", {
    showcase <- .sci_module_showcase()
    split_values <- function(x) trimws(strsplit(x, ",")[[1]])

    # The column each module's highlight values are matched against.
    columns <- c(volcano = "symbol", ma = "symbol", manhattan = "SNP", gwasqq = "SNP", crispr = "gene")
    for (id in names(columns)) {
        e <- showcase[[id]]
        data <- .sci_example_dataset(e$dataset)
        values <- split_values(e$defaults$highlight.points)
        expect_gt(length(values), 0)
        expect_true(all(values %in% data[[columns[[id]]]]), info = id)
    }

    residues <- as.integer(split_values(showcase$structure$defaults$highlight.residues))
    expect_true(all(residues %in% .sci_example_dataset("example_structure")$residues$residue))

    skip_if_not_installed("maftools")
    expect_true(showcase$lollipop$defaults$gene %in% .sci_example_dataset("tcga_laml")$Hugo_Symbol)
})

test_that("every showcase default is accepted by the control it seeds", {
    showcase <- .sci_module_showcase()

    # get_default() quietly falls back when a value fails its check, and ignores
    # a key no control reads, so a typo'd column or key would just vanish from
    # the demo. Record what each InputsUI reads and rejects, in this package and
    # in the VizModules base modules it wraps.
    original <- VizModules::get_default
    seen <- character(0)
    rejected <- character(0)
    record <- function(defaults, key, fallback, validator = NULL) {
        seen <<- c(seen, key)
        given <- !is.null(defaults) && key %in% names(defaults)
        if (!is.null(validator) && given && !isTRUE(validator(defaults[[key]]))) {
            rejected <<- c(rejected, key)
        }
        original(defaults, key, fallback, validator)
    }
    local_mocked_bindings(get_default = record)
    local_mocked_bindings(get_default = record, .package = "VizModules")

    for (id in names(showcase)) {
        e <- showcase[[id]]
        if (!length(e$defaults) || length(.sci_showcase_missing(e))) next
        data <- .sci_example_dataset(e$dataset)
        ui_data <- if (is.function(e$ui_data)) e$ui_data(data) else data

        seen <- character(0)
        rejected <- character(0)
        html <- as.character(e$inputs_ui(id, ui_data, defaults = e$defaults))
        expect_identical(unique(rejected), character(0), info = id)

        # A key read outside get_default() still names a control of the module.
        unread <- setdiff(names(e$defaults), seen)
        unknown <- unread[!vapply(unread, function(k) grepl(paste0(id, "-", k), html, fixed = TRUE), logical(1))]
        expect_identical(unknown, character(0), info = id)
    }
})


# ---- The registry's consumers --------------------------------------------------

test_that("the Figure Builder registry is the showcase's data-frame modules", {
    showcase <- .sci_module_showcase()
    registry <- sci_figure_builder_registry()

    expected <- names(showcase)[vapply(showcase, function(e) {
        isTRUE(e$figure_builder) && !length(.sci_showcase_missing(e))
    }, logical(1))]
    expect_named(registry, expected)
    for (id in names(registry)) {
        expect_identical(registry[[id]]$defaults, showcase[[id]]$defaults, info = id)
        expect_identical(registry[[id]]$dataset, showcase[[id]]$dataset, info = id)
        expect_identical(registry[[id]]$label, showcase[[id]]$label, info = id)
        expect_identical(showcase[[id]]$kind, "df", info = id)
    }
})

test_that("every module's *App() opens on its showcase datasets and defaults", {
    showcase <- .sci_module_showcase()
    catalogue <- .sci_example_catalogue()

    # Capture what each app hands its factory rather than building the apps.
    captured <- NULL
    capture_object <- function(inputs_ui_fn, output_ui_fn, server_fn, object_list, title, ...,
                               defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
        captured <<- list(data = object_list, defaults = defaults)
        "app"
    }
    capture_df <- function(inputs_ui_fn, output_ui_fn, server_fn, data_list, defaults = NULL, ...) {
        captured <<- list(data = data_list, defaults = defaults)
        "app"
    }
    # The hand-rolled apps build their own shinyApp(); their server closes over
    # what they were given.
    capture_shiny <- function(ui, server, ...) {
        env <- environment(server)
        data <- if (exists("data_list", env)) {
            get("data_list", env)
        } else if (exists("seg", env)) {
            list(get("seg", env))
        } else {
            list(list(data = get("data", env), model = get("model", env), stats = get("stats", env)))
        }
        captured <<- list(data = data, defaults = get("defaults", env))
        "app"
    }
    local_mocked_bindings(
        createModuleApp = capture_df, .sci_object_app = capture_object, .ditto_module_app = capture_object,
        shinyApp = capture_shiny
    )

    for (id in names(showcase)) {
        e <- showcase[[id]]
        if (length(.sci_showcase_missing(e))) next
        captured <- NULL
        get(paste0(e$module, "App"))()

        keys <- c(e$dataset, e$app_datasets)
        if (!e$module %in% c("cnSegmentPlot", "michaelisMenten")) {
            labels <- vapply(keys, function(k) catalogue[[k]]$label, character(1), USE.NAMES = FALSE)
            expect_named(captured$data, labels, info = id)
        }
        expect_identical(captured$defaults, .sci_merge_defaults(e$defaults, NULL), info = id)
    }
})

test_that("a caller's defaults are layered over the showcase ones, and its data gets none", {
    captured <- NULL
    local_mocked_bindings(createModuleApp = function(..., data_list, defaults = NULL, hide.tabs = NULL) {
        captured <<- list(data = data_list, defaults = defaults, hide.tabs = hide.tabs)
        "app"
    })

    survivalCurveApp(defaults = list(group.by = "ph.ecog"))
    expect_identical(captured$defaults$group.by, "ph.ecog")
    expect_true(captured$defaults$risk.table)

    survivalCurveApp(list(lung = .sci_example_data("survival_lung")), hide.tabs = "Legend")
    expect_null(captured$defaults)
    expect_identical(captured$hide.tabs, "Legend")
})

test_that(".sci_merge_defaults() replaces a key whole rather than merging into it", {
    base <- list(a = 1, tracks = list(c1 = "x", c2 = "y"))
    merged <- .sci_merge_defaults(base, list(tracks = list(c1 = "z"), b = 2))
    expect_identical(merged$tracks, list(c1 = "z"))
    expect_identical(merged$a, 1)
    expect_identical(merged$b, 2)
    expect_null(.sci_merge_defaults(list(), NULL))
    expect_identical(.sci_merge_defaults(NULL, list(a = 1)), list(a = 1))
})

test_that(".sci_server_args() leaves out the arguments not given", {
    data <- reactive(1)
    args <- .sci_server_args("x", data)
    expect_named(args, c("id", "data"))

    args <- .sci_server_args("x", data, defaults = list(a = 1), hide.tabs = "Facet")
    expect_named(args, c("id", "data", "defaults", "hide.tabs"))
})

test_that("the example catalogue loads each dataset and names what it needs", {
    expect_error(.sci_example_dataset("no_such_dataset"), "No example dataset")
    expect_s3_class(.sci_example_dataset("theoph"), "data.frame")
    expect_identical(.sci_example_catalogue()$tcga_laml$needs, "maftools")

    local_mocked_bindings(.sci_missing_packages = function(pkgs) pkgs)
    expect_error(.sci_example_dataset("airway"), "airway")
})
