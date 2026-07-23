#' Default UI value producers for sciVizModules plot modules
#'
#' This file collects the internal helpers that compute the `defaults` lists
#' handed to the wrapped VizModules plot servers/UIs. Keeping them together keeps
#' the auto-detected initial state and the reset state in one place per module.
#'
#' All detection routes through [.detect_column()] (see `enrichment_helpers.R`).
#'
#' @name defaults_helpers
#' @keywords internal
NULL

#' Default UI values for the dose-response module
#'
#' Produces the `defaults` list handed to the scatter plot module so the
#' dose-response module opens with sensible mappings: the dose column on the
#' x-axis (log10-adjusted), the response column on the y-axis, and a **drc**
#' log-logistic (`LL.4`) custom model enabled and drawn as the fitted curve.
#'
#' User-supplied `defaults` take precedence over these auto-detected values.
#'
#' @param data A dose-response data frame.
#' @param defaults An optional named list of user overrides.
#' @return A named list of scatter plot module defaults.
#'
#' @author Jacob Martin
#' @rdname INTERNAL_dose_response_defaults
#' @keywords internal
.dose_response_defaults <- function(data, defaults = NULL) {
    if (is.null(defaults)) defaults <- list()

    num_cols <- names(data)[vapply(data, is.numeric, logical(1))]

    # Detect the dose (concentration) column, falling back to the first
    # numeric column.
    dose_col <- .detect_column(
        data,
        c(
            "dose", "Dose", "dose_uM", "dose_nM", "dose_mM", "conc",
            "Concentration", "concentration", "conc_uM", "x"
        ),
        numeric = TRUE
    )
    if (is.null(dose_col)) dose_col <- if (length(num_cols)) num_cols[1] else NULL

    # Detect the response column (preferring mean/aggregated), falling back to
    # the first remaining numeric column.
    resp_col <- .detect_column(
        data,
        c(
            "mean_response_pct", "mean_response", "response_mean",
            "response", "Response", "response_pct", "viability",
            "Viability", "signal", "Signal", "effect", "Effect", "y"
        ),
        numeric = TRUE, exclude = dose_col
    )
    if (is.null(resp_col)) {
        resp_num <- setdiff(num_cols, dose_col)
        resp_col <- if (length(resp_num)) resp_num[1] else NULL
    }

    base <- list(
        x.by = dose_col,
        y.by = resp_col,
        # Points only; the fitted dose-response curve is the drc model line.
        linear.model = FALSE,
        custom.models = list(
            model1 = list(
                model_type = "drm",
                formula = if (!is.null(resp_col) && !is.null(dose_col)) {
                    paste(resp_col, "~", dose_col)
                } else {
                    ""
                },
                drc_fct = "LL.4",
                line_colour = "#D7191C",
                line_width = 2
            )
        ),
        custom.model.enable = TRUE
    )

    # User-supplied defaults win.
    utils::modifyList(base, defaults)
}

#' Register the **drc** dose-response model backend
#'
#' Adds a `"drm"` backend to the VizModules model registry so the scatter plot
#' modelling machinery can fit dose-response curves with [drc::drm()]. The
#' backend exposes a `drc_fct` select field for choosing the dose-response
#' family (log-logistic and Weibull models). Registration runs once when the
#' package namespace is loaded.
#'
#' @return Invisibly `NULL`; called for its side effect of registering the
#'   backend.
#'
#' @importFrom VizModules register_model_backend
#' @author Jacob Martin
#' @rdname INTERNAL_register_drm_backend
#' @keywords internal
.register_drm_backend <- function() {
    register_model_backend("drm", list(
        fit = function(formula, data, drc_fct = "LL.4", ...) {
            fct_map <- list(
                "LL.4" = drc::LL.4, "LL.3" = drc::LL.3, "LL.2" = drc::LL.2,
                "W1.4" = drc::W1.4, "W2.4" = drc::W2.4
            )
            fct_fn <- fct_map[[drc_fct]]
            if (is.null(fct_fn)) stop("Unknown drc family: ", drc_fct)
            drc::drm(formula, data = data, fct = fct_fn())
        },
        predict = function(model, newdata) {
            as.numeric(stats::predict(model, newdata = newdata))
        },
        validate_classes = "drc",
        fields = list(
            drc_fct = list(
                type = "select",
                args = list(
                    choices = c("LL.4", "LL.3", "LL.2", "W1.4", "W2.4"),
                    selected = "LL.4"
                )
            )
        )
    ))
    invisible(NULL)
}

