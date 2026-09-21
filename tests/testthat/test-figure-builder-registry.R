# Tests for the Figure Builder registry.
#
# The registry is a contract with VizModules::figureBuilderServer(), which reads
# `label`, `dataset`, `inputs_ui`, `output_ui`, `server_fn` and `defaults` off
# each entry, calls `output_ui(id, resizable = FALSE)`, and treats each server's
# return value as the panel's source reactive.

test_that("sci_figure_builder_registry() returns well-formed entries", {
    registry <- sci_figure_builder_registry()

    expect_type(registry, "list")
    expect_gte(length(registry), 4)
    expect_true(all(nzchar(names(registry))))

    for (key in names(registry)) {
        mod <- registry[[key]]
        for (field in c("label", "dataset", "inputs_ui", "output_ui", "server_fn")) {
            expect_true(field %in% names(mod), info = paste(key, field))
        }
        expect_type(mod$label, "character")
        expect_type(mod$dataset, "character")
        for (field in c("inputs_ui", "output_ui", "server_fn")) {
            expect_true(is.function(mod[[field]]), info = paste(key, field))
        }
        if (!is.null(mod$defaults)) {
            expect_type(mod$defaults, "list")
            expect_true(all(nzchar(names(mod$defaults))), info = key)
        }
    }
})

test_that("every registered output_ui accepts resizable", {
    # The builder renders each panel with `output_ui(id, resizable = FALSE)`,
    # since its own cards already carry a resize handle.
    for (mod in sci_figure_builder_registry()) {
        expect_true("resizable" %in% names(formals(mod$output_ui)), info = mod$label)
        ui <- mod$output_ui("panel1", resizable = FALSE)
        expect_true(inherits(ui, c("shiny.tag", "shiny.tag.list", "shiny.tag.function")))
    }
})

test_that("every registered server takes the standard module arguments", {
    for (mod in sci_figure_builder_registry()) {
        expect_true(
            all(c("id", "data", "defaults") %in% names(formals(mod$server_fn))),
            info = mod$label
        )
        expect_true(
            all(c("id", "data", "defaults") %in% names(formals(mod$inputs_ui))),
            info = mod$label
        )
    }
})

test_that("every entry's dataset is in the bundled catalogue", {
    data_list <- .sci_figure_builder_data()
    expect_true(all(vapply(data_list, is.data.frame, logical(1))))

    for (mod in sci_figure_builder_registry()) {
        expect_true(mod$dataset %in% names(data_list), info = mod$label)
    }
})

test_that("registry defaults are keys the modules actually read", {
    data_list <- .sci_figure_builder_data()
    # `get_default()` falls back silently on an unknown key, so a typo here is
    # a no-op rather than an error. Column-naming keys are checkable; the rest
    # at least have to be scalars the module can seed a control with.
    column_keys <- c("x.by", "y.by", "time", "status", "group.by")
    checked <- 0

    for (mod in sci_figure_builder_registry()) {
        if (is.null(mod$defaults)) next
        df <- data_list[[mod$dataset]]
        for (key in names(mod$defaults)) {
            value <- mod$defaults[[key]]
            expect_false(is.null(value), info = paste(mod$label, key))
            if (key %in% column_keys) {
                expect_true(value %in% names(df),
                    info = paste(mod$label, key, value))
            }
            checked <- checked + 1
        }
    }

    # Guards against this test quietly becoming empty if the defaults are
    # dropped from every entry.
    expect_gt(checked, 0)
})

test_that("sciFigureBuilderApp() builds without launching", {
    skip_if_not_installed("dittoViz")
    parts <- sciFigureBuilderApp(return_components = TRUE)
    expect_type(parts, "list")
    expect_true(all(c("ui", "server") %in% names(parts)))
    expect_true(is.function(parts$server))
})
