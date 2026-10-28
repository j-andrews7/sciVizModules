#' Launch the sciVizModules module gallery
#'
#' Builds the **sciVizModules Gallery**: every module on its own tab, each
#' opening on an example dataset with the module's main features already
#' switched on (labelled genes and variants, risk tables, trajectories,
#' terminal fits, annotation tracks, splits and so on), plus a **Figure
#' Builder** tab for composing the data-frame modules into one multi-panel
#' figure.
#'
#' The tabs sit in navbar menus by field (Expression, Enrichment, Single-cell,
#' PCA, Genomics, Mutations, Clinical, Pharmacology, Structure), and an
#' **Overview** page lists every module as a card that opens
#' its tab. Each tab carries the module's full set of controls, a link to its
#' reference documentation, and beneath the plot either a filterable data
#' table that feeds it (for the modules that take a data frame) or a read-only
#' preview of the object it is bound to.
#'
#' A module's server starts the first time its tab is opened, so the gallery
#' launches quickly and a module that is never visited costs nothing. Example
#' datasets are read once and shared between the tabs that use them.
#'
#' The settings each tab opens on are the ones the module's own `*App()`
#' function (e.g. [volcanoPlotApp()]) and the Figure Builder start from, so
#' any of them can be reproduced by passing the same `defaults` to the module
#' in your own app.
#'
#' Modules whose optional packages are not installed are left out, and their
#' cards on the Overview name the packages to install: the heatmap modules need
#' \pkg{ComplexHeatmap}, \pkg{InteractiveComplexHeatmap} and \pkg{circlize}; the
#' bulk expression modules the \pkg{airway} data package; the somatic-mutation
#' modules \pkg{maftools}; `goFanPlot` \pkg{GOfan} and \pkg{org.Hs.eg.db}; and
#' `doseResponse` \pkg{drc}.
#'
#' The same app ships as `system.file("apps/module-gallery", package =
#' "sciVizModules")` for deployment to a Shiny server, shinyapps.io or Posit
#' Connect.
#'
#' @param title A character string used as the navbar title and page title.
#' @param return_components Logical. When `FALSE` (the default) a
#'   [shiny::shinyApp()] object is returned. When `TRUE` a named list with `ui`
#'   and `server` elements is returned instead, which is convenient for
#'   deployment scripts that need an explicit `shinyApp(ui, server)` call.
#'
#' @return Either a [shiny::shinyApp()] object, or (when
#'   `return_components = TRUE`) a list with elements `ui` and `server`.
#'
#' @import shiny
#'
#' @seealso [sciFigureBuilderApp()], [VizModules::moduleGalleryApp()] for the
#'   VizModules modules.
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(sciVizModules)
#' app <- sciModuleGalleryApp()
#' if (interactive()) shiny::runApp(app)
#'
#' # The UI and server separately, e.g. for a deployment app.R:
#' parts <- sciModuleGalleryApp(return_components = TRUE)
#' if (interactive()) shiny::shinyApp(parts$ui, parts$server)
sciModuleGalleryApp <- function(title = "sciVizModules Gallery", return_components = FALSE) {
    showcase <- .sci_module_showcase()
    info <- .sci_gallery_package_info()

    ui <- .sci_gallery_ui(showcase, title, info)
    server <- .sci_gallery_server(showcase)

    if (isTRUE(return_components)) {
        return(list(ui = ui, server = server))
    }

    shinyApp(ui, server)
}


#' The gallery's UI
#'
#' @param showcase A [.sci_module_showcase()] registry.
#' @param title The navbar and page title.
#' @param info The list from [.sci_gallery_package_info()].
#'
#' @return A tag wrapping the [shiny::navbarPage()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_gallery_ui
#' @keywords internal
.sci_gallery_ui <- function(showcase, title, info) {
    available <- .sci_gallery_available(showcase)

    menus <- lapply(.sci_gallery_groups, function(group) {
        ids <- names(available)[vapply(available, function(e) identical(e$group, group), logical(1))]
        if (!length(ids)) {
            return(NULL)
        }
        tabs <- lapply(ids, function(id) .sci_gallery_module_tab(id, available[[id]], info))
        do.call(navbarMenu, c(list(group), tabs))
    })

    page <- do.call(navbarPage, c(
        list(
            title = title,
            id = "active_tab",
            position = "static-top",
            windowTitle = title,
            header = .sci_gallery_header(info)
        ),
        list(.sci_gallery_overview_tab(showcase, info)),
        Filter(Negate(is.null), menus),
        list(tabPanel("Figure Builder", value = "figure_builder", VizModules::figureBuilderUI("figure_builder")))
    ))

    # The stylesheet is scoped to this class, so the whole page carries it.
    # navbarPage() returns a tag list rather than a single tag, so wrap rather
    # than append an attribute.
    tags$div(class = "scivizmodules-gallery", page)
}


#' The showcase entries whose packages are all installed
#'
#' @param showcase A [.sci_module_showcase()] registry.
#' @return The entries the gallery can show.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_gallery_available
#' @keywords internal
.sci_gallery_available <- function(showcase) {
    Filter(function(entry) !length(.sci_showcase_missing(entry)), showcase)
}


#' One module's gallery tab
#'
#' Its controls beside the plot, with the module's description and docs link
#' above the plot and, beneath it, the filterable data table that feeds it or a
#' read-only preview of the object it is bound to.
#'
#' @param id The module id, used as the module's namespace.
#' @param entry The module's [.sci_module_showcase()] entry.
#' @param info The list from [.sci_gallery_package_info()].
#'
#' @return A [shiny::tabPanel()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_gallery_module_tab
#' @keywords internal
.sci_gallery_module_tab <- function(id, entry, info) {
    lower <- if (identical(entry$kind, "df")) {
        tagList(
            h4("Data Table"),
            p(class = "sci-gallery-note", "Filtering the data table will update the plot."),
            VizModules::dataFilterUI(paste0(id, "_filter"))
        )
    } else {
        tagList(
            h4("Data Preview"),
            p(
                class = "sci-gallery-note",
                "A read-only preview of the example ", tags$code(entry$dataset), " the module is bound to."
            ),
            DT::DTOutput(paste0(id, "_preview"))
        )
    }

    tabPanel(
        entry$tab_label,
        value = id,
        sidebarLayout(
            sidebarPanel(
                width = 4,
                uiOutput(paste0(id, "_inputs_ui"))
            ),
            mainPanel(
                width = 8,
                tags$div(
                    class = "sci-gallery-tab-header",
                    tags$span(class = "sci-gallery-tab-desc", entry$description),
                    .sci_gallery_docs_link(entry, info)
                ),
                entry$output_ui(id),
                hr(),
                lower
            )
        )
    )
}


#' A link to a module's reference page on the package website
#'
#' @param entry A [.sci_module_showcase()] entry.
#' @param info The list from [.sci_gallery_package_info()].
#' @param label The link text.
#'
#' @return An `<a>` tag opening the module's `*InputsUI()` reference page,
#'   which lists every control and its default.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_gallery_docs_link
#' @keywords internal
.sci_gallery_docs_link <- function(entry, info, label = "Docs") {
    tags$a(
        class = "sci-gallery-docs-link",
        href = paste0(info$docs_url, "reference/", entry$module, "InputsUI.html"),
        target = "_blank", rel = "noopener noreferrer",
        title = paste("Reference documentation for", entry$module),
        icon("book"), label
    )
}


#' The gallery's Overview tab
#'
#' The package's description, then every module as a card under its menu's
#' heading. A card opens its module's tab; one whose packages are missing is
#' greyed out and names them instead.
#'
#' @param showcase A [.sci_module_showcase()] registry.
#' @param info The list from [.sci_gallery_package_info()].
#'
#' @return A [shiny::tabPanel()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_gallery_overview_tab
#' @keywords internal
.sci_gallery_overview_tab <- function(showcase, info) {
    link <- function(url) tags$a(href = url, target = "_blank", rel = "noopener noreferrer", url)

    card <- function(id, entry) {
        missing <- .sci_showcase_missing(entry)
        ok <- !length(missing)
        tags$div(
            class = paste(c("sci-gallery-card", if (!ok) "sci-gallery-card-unavailable"), collapse = " "),
            `data-sci-goto` = if (ok) id,
            tags$div(class = "sci-gallery-card-title", entry$label),
            tags$p(class = "sci-gallery-card-desc", entry$description),
            tags$div(
                class = "sci-gallery-card-meta",
                tags$span("Data: ", tags$code(entry$dataset)),
                .sci_gallery_docs_link(entry, info)
            ),
            if (!ok) {
                tags$p(
                    class = "sci-gallery-card-missing",
                    paste0("Install ", paste(missing, collapse = ", "), " to use this module.")
                )
            }
        )
    }

    groups <- lapply(.sci_gallery_groups, function(group) {
        ids <- names(showcase)[vapply(showcase, function(e) identical(e$group, group), logical(1))]
        if (!length(ids)) {
            return(NULL)
        }
        tagList(
            h3(class = "sci-gallery-group-title", group),
            tags$div(class = "sci-gallery-cards", lapply(ids, function(id) card(id, showcase[[id]])))
        )
    })

    tabPanel(
        "Overview",
        value = "overview",
        tags$div(
            class = "sci-gallery-overview",
            h2("sciVizModules Gallery"),
            p(info$title),
            p(info$description),
            p(
                "Every module opens on an example dataset with its main features switched on, and every",
                "control can be changed from its sidebar. Pick a module below or from the menus above;",
                "its", tags$strong("Docs"), "link opens the reference page listing each control. The",
                tags$strong("Figure Builder"), "tab composes several modules into one multi-panel figure."
            ),
            groups,
            hr(),
            tags$p(tags$strong("Repository: "), link(info$repo_url)),
            tags$p(tags$strong("Documentation: "), link(info$docs_url)),
            tags$p(tags$strong("Report issues: "), link(info$bug_url)),
            tags$p(tags$strong("Version: "), paste0("v", info$version))
        )
    )
}


#' Package details shown on the gallery's Overview and navbar
#'
#' @return A list with `title`, `description`, `version`, `repo_url`,
#'   `docs_url` (ending in `/`) and `bug_url`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_gallery_package_info
#' @keywords internal
.sci_gallery_package_info <- function() {
    desc <- utils::packageDescription("sciVizModules")
    field <- function(name) {
        value <- desc[[name]]
        if (is.null(value) || is.na(value) || !nzchar(trimws(value))) NA_character_ else gsub("\\s+", " ", value)
    }

    urls <- trimws(strsplit(if (is.na(field("URL"))) "" else field("URL"), ",")[[1]])
    docs_url <- urls[grepl("github\\.io", urls)][1]
    repo_url <- urls[grepl("github\\.com", urls)][1]
    if (is.na(docs_url)) docs_url <- "https://j-andrews7.github.io/sciVizModules/"
    if (!grepl("/$", docs_url)) docs_url <- paste0(docs_url, "/")

    list(
        title = field("Title"),
        description = field("Description"),
        version = as.character(utils::packageVersion("sciVizModules")),
        docs_url = docs_url,
        repo_url = if (is.na(repo_url)) "https://github.com/j-andrews7/sciVizModules" else repo_url,
        bug_url = if (is.na(field("BugReports"))) {
            "https://github.com/j-andrews7/sciVizModules/issues"
        } else {
            field("BugReports")
        }
    )
}


#' The gallery's header: its stylesheet, script, and navbar links
#'
#' Every CSS rule is anchored on `.scivizmodules-gallery`, the class
#' [.sci_gallery_ui()] wraps the page in, so the gallery restyles nothing
#' outside itself (see the CSS containment notes in AGENTS.md).
#'
#' @param info The list from [.sci_gallery_package_info()].
#'
#' @return A [shiny::tagList()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_gallery_header
#' @keywords internal
.sci_gallery_header <- function(info) {
    external <- function(url, ...) {
        tags$a(href = url, target = "_blank", rel = "noopener noreferrer", ...)
    }

    tagList(
        shinyjs::useShinyjs(),
        tags$head(
            tags$style(HTML(.sci_gallery_css())),
            tags$script(HTML(.sci_gallery_js()))
        ),
        # navbarPage() has no slot for right-aligned items, so they are rendered
        # hidden here and moved into the navbar once it exists.
        tags$div(
            class = "sci-gallery-navbar-extras",
            tags$ul(
                class = "nav navbar-nav navbar-right sci-gallery-navbar-right",
                tags$li(external(info$repo_url, icon("github"), "Repo")),
                tags$li(external(info$docs_url, icon("book"), "Docs")),
                tags$li(tags$span(class = "sci-gallery-version", paste0("v", info$version)))
            )
        )
    )
}


#' The gallery's stylesheet
#'
#' @return A character string of CSS, every rule scoped to `.scivizmodules-gallery`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_gallery_css
#' @keywords internal
.sci_gallery_css <- function() {
    paste(
        ".scivizmodules-gallery .navbar { margin-bottom: 0; }",
        ".scivizmodules-gallery .navbar-nav > li > a { padding-left: 9px; padding-right: 9px; font-size: 13px; }",
        ".scivizmodules-gallery .navbar .navbar-collapse { flex-wrap: nowrap; }",
        ".scivizmodules-gallery .navbar-nav { white-space: nowrap; }",
        ".scivizmodules-gallery .sci-gallery-navbar-extras { display: none; }",
        ".scivizmodules-gallery .sci-gallery-navbar-right > li > a { display: flex; align-items: center; gap: 5px; }",
        ".scivizmodules-gallery .sci-gallery-version { color: #9d9d9d; display: block; padding: 15px 9px; }",
        ".scivizmodules-gallery .sci-gallery-overview { max-width: 1400px; margin: 0 auto; }",
        ".scivizmodules-gallery .sci-gallery-group-title { margin-top: 24px; border-bottom: 1px solid #e5e5e5;",
        "  padding-bottom: 4px; }",
        ".scivizmodules-gallery .sci-gallery-cards { display: grid; gap: 12px;",
        "  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); }",
        ".scivizmodules-gallery .sci-gallery-card { display: flex; flex-direction: column; gap: 6px; min-width: 0;",
        "  padding: 12px 14px; border: 1px solid #ddd; border-radius: 6px; background: #fff; cursor: pointer;",
        "  transition: box-shadow 0.15s, border-color 0.15s; }",
        ".scivizmodules-gallery .sci-gallery-card:hover { border-color: #337ab7;",
        "  box-shadow: 0 2px 8px rgba(0,0,0,0.15); }",
        ".scivizmodules-gallery .sci-gallery-card-unavailable { cursor: default; opacity: 0.6; background: #f7f7f7; }",
        ".scivizmodules-gallery .sci-gallery-card-unavailable:hover { border-color: #ddd; box-shadow: none; }",
        ".scivizmodules-gallery .sci-gallery-card-title { font-weight: 600; font-size: 15px; }",
        ".scivizmodules-gallery .sci-gallery-card-desc { margin: 0; color: #444; font-size: 13px; flex: 1; }",
        ".scivizmodules-gallery .sci-gallery-card-meta { display: flex; justify-content: space-between;",
        "  align-items: center; gap: 8px; color: #777; font-size: 12px; }",
        ".scivizmodules-gallery .sci-gallery-card-missing { margin: 0; color: #a94442; font-size: 12px; }",
        ".scivizmodules-gallery .sci-gallery-tab-header { display: flex; justify-content: space-between;",
        "  align-items: baseline; gap: 12px; margin-bottom: 8px; }",
        ".scivizmodules-gallery .sci-gallery-tab-desc { color: #555; min-width: 0; }",
        ".scivizmodules-gallery .sci-gallery-docs-link { white-space: nowrap; }",
        ".scivizmodules-gallery .sci-gallery-note { color: grey; font-size: 12px; }",
        sep = "\n"
    )
}


#' The gallery's script
#'
#' Moves the navbar links into the navbar, and has a module card set the
#' `gallery_goto` input the server opens that module's tab from.
#'
#' @return A character string of JavaScript.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_gallery_js
#' @keywords internal
.sci_gallery_js <- function() {
    paste(
        "(function() {",
        "  function addNavbarItems() {",
        "    var root = document.querySelector('.scivizmodules-gallery');",
        "    if (!root) return;",
        "    var nav = root.querySelector('.navbar .navbar-collapse') ||",
        "      root.querySelector('.navbar .container-fluid') || root.querySelector('.navbar .container');",
        "    var extras = root.querySelector('.sci-gallery-navbar-extras .sci-gallery-navbar-right');",
        "    if (nav && extras) nav.appendChild(extras);",
        "  }",
        "  if (document.readyState === 'loading') {",
        "    document.addEventListener('DOMContentLoaded', addNavbarItems);",
        "  } else {",
        "    addNavbarItems();",
        "  }",
        "  document.addEventListener('click', function(e) {",
        "    if (e.target.closest('a')) return;",
        "    var card = e.target.closest('.scivizmodules-gallery [data-sci-goto]');",
        "    if (card && window.Shiny) {",
        "      Shiny.setInputValue('gallery_goto', card.getAttribute('data-sci-goto'), {priority: 'event'});",
        "    }",
        "  });",
        "})();",
        sep = "\n"
    )
}


#' The gallery's server
#'
#' Each module's server, data table or preview, and inputs start the first
#' time its tab is opened, as does the Figure Builder. Datasets are read once
#' per app and shared between the tabs, and the sessions, that use them.
#'
#' @param showcase A [.sci_module_showcase()] registry.
#' @param load A function loading a dataset by its catalogue key.
#'
#' @return A Shiny server function.
#'
#' @import shiny
#' @importFrom DT renderDT
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_gallery_server
#' @keywords internal
.sci_gallery_server <- function(showcase, load = .sci_example_dataset) {
    available <- .sci_gallery_available(showcase)
    cache <- new.env(parent = emptyenv())
    dataset <- function(name) {
        if (!exists(name, envir = cache, inherits = FALSE)) {
            assign(name, load(name), envir = cache)
        }
        get(name, envir = cache, inherits = FALSE)
    }

    function(input, output, session) {
        started <- new.env(parent = emptyenv())

        start <- function(id) {
            if (!length(id) || !nzchar(id) || exists(id, envir = started, inherits = FALSE)) {
                return(invisible(FALSE))
            }
            if (identical(id, "figure_builder")) {
                assign(id, TRUE, envir = started)
                VizModules::figureBuilderServer(
                    "figure_builder",
                    data_list = .sci_figure_builder_data(),
                    module_registry = sci_figure_builder_registry()
                )
                return(invisible(TRUE))
            }
            entry <- available[[id]]
            if (is.null(entry)) {
                return(invisible(FALSE))
            }
            assign(id, TRUE, envir = started)
            # A module that fails to start would otherwise end the session, and
            # with it every other tab.
            tryCatch(
                .sci_gallery_start_module(id, entry, dataset(entry$dataset), output),
                error = function(e) {
                    showNotification(
                        paste0("The ", entry$label, " module could not start: ", conditionMessage(e)),
                        type = "error", duration = NULL
                    )
                }
            )
            invisible(TRUE)
        }

        observeEvent(input$active_tab, start(input$active_tab))

        observeEvent(input$gallery_goto, {
            updateNavbarPage(session, "active_tab", selected = input$gallery_goto)
        })
    }
}


#' Start one module in the gallery
#'
#' @param id The module id.
#' @param entry Its [.sci_module_showcase()] entry.
#' @param data Its example dataset.
#' @param output The session's output.
#'
#' @return The module server's return value, invisibly.
#'
#' @import shiny
#' @importFrom DT renderDT
#'
#' @author Jared Andrews
#' @rdname INTERNAL_sci_gallery_start_module
#' @keywords internal
.sci_gallery_start_module <- function(id, entry, data, output) {
    ui_data <- if (is.function(entry$ui_data)) entry$ui_data(data) else data
    defaults <- if (length(entry$defaults)) entry$defaults

    if (identical(entry$kind, "df")) {
        server_data <- VizModules::dataFilterServer(paste0(id, "_filter"), reactive(data))
    } else {
        server_data <- reactive(data)
        output[[paste0(id, "_preview")]] <- DT::renderDT(
            entry$preview(data),
            options = list(scrollX = TRUE, pageLength = 5)
        )
    }

    # Built once, on the full dataset, so filtering the table leaves the
    # settings alone; with the defaults the server gets, so Reset returns to them.
    output[[paste0(id, "_inputs_ui")]] <- renderUI({
        entry$inputs_ui(id, ui_data, defaults = defaults, title = h3(paste(entry$tab_label, "Settings")))
    })

    invisible(do.call(entry$server_fn, .sci_server_args(id, server_data, defaults)))
}
