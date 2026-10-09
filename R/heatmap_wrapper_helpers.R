# Shared plumbing for the modules that wrap VizModules' ComplexHeatmap_Heatmap
# module (dittoHeatmap, sampleDistanceHeatmap, deHeatmap). Each wrapper turns its
# object into the `list(matrix =, column_annotations =)` the base takes, fixes
# the base's Matrix Columns / Row Name Column choices to what it built, and
# hands the base everything else.

# The packages the wrapped heatmap module draws with. Its server stops without
# any of them.
.heatmap_pkgs <- c("ComplexHeatmap", "InteractiveComplexHeatmap", "circlize")

# The base inputs a wrapper fixes and hides. `column_key` is fixed through its
# default (the key column comes first) but cannot be hidden: it shares a grid
# cell with the column annotation editor.
.heatmap_wrapper_hidden <- c("matrix.cols", "rowname.col")

# The base module's input ids. A colData column with one of these names cannot
# have its annotation colours seeded through `defaults` without clobbering the
# input, so those are skipped.
.heatmap_input_ids <- c(
    "matrix.cols", "rowname.col", "name", "na_col", "scale", "row_filter", "column_filter",
    "low_color", "mid_color", "high_color", "min_value", "mid_value", "max_value", "reverse.palette",
    "show_heatmap_legend", "border", "cluster_rows", "cluster_columns", "clustering_distance_rows",
    "clustering_distance_columns", "clustering_method_rows", "clustering_method_columns", "show_row_dend",
    "show_column_dend", "row_split_by", "row_split_n", "row_split_cols", "column_split_by", "column_split_n",
    "column_split_cols", "row_gap", "column_gap", "row_title", "column_title", "show_row_slice_titles",
    "show_column_slice_titles", "show_row_names", "show_column_names", "row_names_side", "column_names_side",
    "column_names_rot", "row_names_fontsize", "column_names_fontsize", "title_fontsize", "row_annotations",
    "column_annotations", "column_key", "auto.update", "update", "reset"
)


#' Whether the heatmap modules can run
#'
#' @return `TRUE` when ComplexHeatmap, InteractiveComplexHeatmap and circlize
#'   are all installed.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_available
#' @keywords internal
.heatmap_available <- function() {
    all(vapply(.heatmap_pkgs, requireNamespace, logical(1), quietly = TRUE))
}


#' Stop unless the heatmap packages are installed
#'
#' @return `TRUE`, invisibly.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_assert_heatmap_packages
#' @keywords internal
.assert_heatmap_packages <- function() {
    missing <- .heatmap_pkgs[!vapply(.heatmap_pkgs, requireNamespace, logical(1), quietly = TRUE)]
    if (length(missing)) {
        stop(
            "This module draws with ComplexHeatmap and needs ", paste(missing, collapse = ", "), ". ",
            "Install with BiocManager::install(c(", paste0("'", missing, "'", collapse = ", "), ")).",
            call. = FALSE
        )
    }
    invisible(TRUE)
}


#' A name not already taken
#'
#' @param base The preferred name.
#' @param taken Names already in use.
#' @return `base`, or `base` with a numeric suffix when it is taken.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_unique_name
#' @keywords internal
.heatmap_unique_name <- function(base, taken) {
    utils::tail(make.unique(c(as.character(taken), base), sep = "_"), 1)
}


#' Drop the rows a heatmap cannot cluster or scale
#'
#' Rows holding a missing or non-finite value, or with no variance, make
#' Pearson distances and row z-scores undefined, and ComplexHeatmap then fails
#' inside the base module's observer.
#'
#' @param mat A numeric matrix.
#' @param min.rows The fewest rows to accept.
#' @return `mat` without those rows.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_clean_rows
#' @keywords internal
.heatmap_clean_rows <- function(mat, min.rows = 2) {
    finite <- rowSums(!is.finite(mat)) == 0
    v <- .row_vars(mat)
    keep <- finite & is.finite(v) & v > 0
    mat <- mat[keep, , drop = FALSE]
    if (nrow(mat) < min.rows) {
        stop("Fewer than ", min.rows, " rows vary across the columns, so there is nothing to draw.", call. = FALSE)
    }
    mat
}


#' Assemble the data the wrapped heatmap module takes
#'
#' @param mat A numeric matrix; its column names become the matrix columns and
#'   its row names the row labels.
#' @param col.meta A data frame of column (sample or cell) metadata with row
#'   names matching `colnames(mat)`, or `NULL`.
#' @param label Preferred name of the row-label column.
#' @param row.annotations A data frame of per-row annotations, one row per row
#'   of `mat`, or `NULL`.
#' @param key Preferred name of the column-annotation key column.
#' @return `list(matrix =, column_annotations =)`, with attribute `"keys"`
#'   holding the `label`, `key` and `matrix.cols` names actually used.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_frame
#' @keywords internal
.heatmap_frame <- function(mat, col.meta = NULL, label = "feature", row.annotations = NULL, key = "sample") {
    cols <- colnames(mat)
    label <- .heatmap_unique_name(label, cols)
    m <- data.frame(rownames(mat) %||% as.character(seq_len(nrow(mat))), stringsAsFactors = FALSE)
    names(m) <- label

    if (!is.null(row.annotations) && ncol(row.annotations)) {
        ra <- as.data.frame(row.annotations, stringsAsFactors = FALSE)
        taken <- c(cols, label)
        for (i in seq_along(ra)) {
            names(ra)[i] <- .heatmap_unique_name(names(ra)[i], taken)
            taken <- c(taken, names(ra)[i])
        }
        rownames(ra) <- NULL
        m <- cbind(m, ra)
    }
    values <- as.data.frame(mat, optional = TRUE)
    names(values) <- cols
    rownames(values) <- NULL
    m <- cbind(m, values)

    ca <- NULL
    if (!is.null(col.meta)) {
        cm <- as.data.frame(col.meta, optional = TRUE)[cols, , drop = FALSE]
        key <- .heatmap_unique_name(key, names(cm))
        ca <- cbind(stats::setNames(data.frame(cols, stringsAsFactors = FALSE), key), cm)
        rownames(ca) <- NULL
    }

    out <- list(matrix = m, column_annotations = ca)
    attr(out, "keys") <- list(label = label, key = key, matrix.cols = cols)
    out
}


#' Defaults for the wrapped heatmap module
#'
#' Fixes the base's matrix columns, row-name column and annotation key to the
#' wrapper's frame; `base` carries the wrapper's own heatmap defaults, which a
#' caller's `defaults` override entry by entry.
#'
#' @param frame A result of [.heatmap_frame()].
#' @param defaults The caller's defaults, or `NULL`.
#' @param base The wrapper's heatmap defaults.
#' @param wrapper.keys The wrapper's own input ids, dropped before the list
#'   reaches the base module.
#' @return A named list of defaults for [VizModules::ComplexHeatmap_HeatmapServer()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_defaults
#' @keywords internal
.heatmap_defaults <- function(frame, defaults = NULL, base = list(), wrapper.keys = character(0)) {
    out <- base
    user <- defaults %||% list()
    user <- user[setdiff(names(user), wrapper.keys)]
    out[names(user)] <- user
    keys <- attr(frame, "keys")
    out$matrix.cols <- keys$matrix.cols
    out$rowname.col <- keys$label
    if (!is.null(frame$column_annotations)) out$column_key <- keys$key
    out
}


#' Annotation colours as heatmap defaults
#'
#' The wrapped module seeds an annotation's colour picker from a `defaults`
#' entry named after the annotated column. Columns whose names are input ids of
#' the module are skipped.
#'
#' @param colors A named list of named colour vectors, one per column.
#' @return The list, without unusable entries.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_annotation_colors
#' @keywords internal
.heatmap_annotation_colors <- function(colors) {
    if (!length(colors)) {
        return(list())
    }
    keep <- !names(colors) %in% .heatmap_input_ids & nzchar(names(colors)) &
        vapply(colors, function(x) is.character(x) && length(x) && !is.null(names(x)), logical(1))
    colors[keep]
}


#' Turn a preparation error into a validation message
#'
#' An error raised while the wrapped heatmap builds would end the session, since
#' the base draws inside an observer; a [shiny::validate()] failure only stops
#' that build. Pauses from [shiny::req()] pass through untouched.
#'
#' @param expr The expression to evaluate.
#' @return The value of `expr`.
#'
#' @import shiny
#' @author Jared Andrews
#' @rdname INTERNAL_sci_soft_errors
#' @keywords internal
.sci_soft_errors <- function(expr) {
    tryCatch(
        expr,
        shiny.silent.error = function(e) stop(e),
        error = function(e) validate(need(FALSE, conditionMessage(e)))
    )
}


#' The message, if any, a wrapper's preparation stopped with
#'
#' @param prepared The wrapper's prepared-data reactive.
#' @return A tag with the message, or `NULL`.
#'
#' @import shiny
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_status
#' @keywords internal
.heatmap_status <- function(prepared) {
    msg <- tryCatch(
        {
            prepared()
            NULL
        },
        error = function(e) {
            if (inherits(e, "shiny.silent.error") && !inherits(e, "validation")) NULL else conditionMessage(e)
        }
    )
    if (nz_value(msg)) tags$p(class = "text-danger", msg)
}


#' Output UI shared by the heatmap wrappers
#'
#' The wrapped module's interactive heatmap, with a line above it that shows why
#' the wrapper could not build the matrix (the widget otherwise keeps showing
#' the last heatmap it drew).
#'
#' @param id The module id.
#' @param resizable Passed to [VizModules::ComplexHeatmap_HeatmapOutputUI()],
#'   which ignores it.
#' @param ... Passed to [VizModules::ComplexHeatmap_HeatmapOutputUI()].
#' @return The output UI.
#'
#' @import shiny
#' @importFrom VizModules ComplexHeatmap_HeatmapOutputUI
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_wrapper_output_ui
#' @keywords internal
.heatmap_wrapper_output_ui <- function(id, resizable = TRUE, ...) {
    tagList(
        uiOutput(NS(id)("wrapper.status")),
        ComplexHeatmap_HeatmapOutputUI(id, resizable = resizable, ...)
    )
}


#' Input UI shared by the heatmap wrappers
#'
#' The wrapper's own controls above the wrapped module's tabs.
#'
#' @param id The module id.
#' @param extras A `tagList` of the wrapper's inputs.
#' @param frame A result of [.heatmap_frame()] for the initial data.
#' @param heat.defaults Defaults for the wrapped module.
#' @param title,columns As for the module UIs.
#' @return The UI.
#'
#' @import shiny
#' @importFrom VizModules ComplexHeatmap_HeatmapInputsUI
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_wrapper_inputs_ui
#' @keywords internal
.heatmap_wrapper_inputs_ui <- function(id, extras, frame, heat.defaults, title, columns) {
    tagList(
        organize_inputs(extras, columns = columns),
        ComplexHeatmap_HeatmapInputsUI(
            id = id, data = frame, defaults = heat.defaults,
            title = if (is.null(title) || inherits(title, c("shiny.tag", "shiny.tag.list"))) title else h3(title),
            columns = columns
        )
    )
}


#' Server shared by the heatmap wrappers
#'
#' Prepares the wrapper's frame inside its own `moduleServer()` and hands it to
#' [VizModules::ComplexHeatmap_HeatmapServer()], called outside with the same
#' id. The frame's column order reaches the base as a reactive `matrix.cols`
#' default, since the base takes the column order from that input rather than
#' from the data. The base's source reactive is returned unchanged: its
#' `vector_svg` / `raster_png` attributes carry the Figure Builder export.
#'
#' @param id,data,hide.inputs,hide.tabs As for the module servers.
#' @param heat.defaults Defaults for the wrapped module.
#' @param prepare `function(staged, input, isolate_fn)` returning a
#'   [.heatmap_frame()] result, where `staged` is the result of `stage` (or the
#'   data itself). Inputs must be read as `isolate_fn(input$key)`.
#' @param stage Optional `function(obj, input, isolate_fn)` for the expensive
#'   first step (e.g. a variance-stabilising transformation), kept in its own
#'   reactive so changing only what `prepare` reads does not repeat it.
#' @param reactive.defaults Optional `function(input, prepared)` returning a
#'   named list of reactives that drive further base inputs from the wrapper's
#'   own (e.g. the legend title). They are read when the base server is
#'   constructed, before the wrapper's inputs exist, so they must fall back
#'   rather than pause.
#' @param reset Optional `function(session, obj)` restoring the wrapper's own
#'   inputs.
#' @return The wrapped module's source-data reactive.
#'
#' @import shiny
#' @importFrom VizModules ComplexHeatmap_HeatmapServer
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_wrapper_server
#' @keywords internal
.heatmap_wrapper_server <- function(id, data, hide.inputs, hide.tabs, heat.defaults, prepare, stage = NULL,
                                    reactive.defaults = NULL, reset = NULL) {
    stopifnot(is.reactive(data))
    .assert_heatmap_packages()

    wrapped <- moduleServer(id, function(input, output, session) {
        if (is.function(reset)) {
            observeEvent(input$reset, {
                obj <- data()
                req(obj)
                reset(session, obj)
            })
        }

        staged <- reactive({
            obj <- data()
            req(obj)
            if (!is.function(stage)) {
                return(obj)
            }
            isolate_fn <- setup_auto_update_logic(input)
            .sci_soft_errors(stage(obj, input, isolate_fn))
        })

        prepared <- reactive({
            s <- staged()
            isolate_fn <- setup_auto_update_logic(input)
            .sci_soft_errors(prepare(s, input, isolate_fn))
        })

        output$wrapper.status <- renderUI(.heatmap_status(prepared))

        # Read when the base server is built, before any input exists, so a
        # pause (or any error) is a NULL rather than the end of the session.
        col_order <- reactive(tryCatch(attr(prepared(), "keys")$matrix.cols, error = function(e) NULL))
        extra <- if (is.function(reactive.defaults)) reactive.defaults(input, prepared) else list()
        list(data = prepared, defaults = c(list(matrix.cols = col_order), extra))
    })

    heat.defaults[names(wrapped$defaults)] <- wrapped$defaults

    ComplexHeatmap_HeatmapServer(
        id = id,
        data = wrapped$data,
        hide.inputs = union(hide.inputs, .heatmap_wrapper_hidden),
        hide.tabs = hide.tabs,
        defaults = heat.defaults
    )
}
