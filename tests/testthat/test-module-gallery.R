# Tests for the module gallery, sciModuleGalleryApp(). The modules themselves
# are tested in their own files; these cover the gallery around them: one tab
# per available module under its menu, cards on the Overview, modules started
# only when their tab is first opened, and a stylesheet that restyles nothing
# outside the gallery.

test_that("sciModuleGalleryApp() builds an app, or its UI and server", {
    expect_s3_class(sciModuleGalleryApp(), "shiny.appobj")

    parts <- sciModuleGalleryApp(return_components = TRUE)
    expect_named(parts, c("ui", "server"))
    expect_true(is.function(parts$server))
})

test_that("the gallery has a tab per available module, the Overview and the Figure Builder", {
    showcase <- .sci_module_showcase()
    available <- .sci_gallery_available(showcase)
    html <- as.character(.sci_gallery_ui(showcase, "Gallery", .sci_gallery_package_info()))

    expect_true(grepl("scivizmodules-gallery", html, fixed = TRUE))
    expect_true(grepl("figure_builder-pb_canvas", html, fixed = TRUE))
    for (id in c(names(available), "overview", "figure_builder")) {
        expect_true(grepl(sprintf('data-value="%s"', id), html, fixed = TRUE), info = id)
    }
    for (group in unique(vapply(available, function(e) e$group, character(1)))) {
        expect_true(grepl(sprintf('data-value="%s"', group), html, fixed = TRUE), info = group)
    }

    # Every module gets a card, and each docs link opens its InputsUI reference page.
    for (id in names(showcase)) {
        expect_true(grepl(paste0("reference/", showcase[[id]]$module, "InputsUI.html"), html, fixed = TRUE), info = id)
    }
    expect_identical(
        lengths(regmatches(html, gregexpr('class="sci-gallery-card[ "]', html))),
        length(showcase)
    )
})

test_that("a module whose packages are missing gets no tab, and its card says why", {
    local_mocked_bindings(.sci_showcase_missing = function(entry) {
        if (identical(entry$module, "volcanoPlot")) "somepkg" else character(0)
    })
    showcase <- .sci_module_showcase()
    expect_false("volcano" %in% names(.sci_gallery_available(showcase)))

    html <- as.character(.sci_gallery_ui(showcase, "Gallery", .sci_gallery_package_info()))
    expect_false(grepl('data-value="volcano"', html, fixed = TRUE))
    expect_false(grepl('data-sci-goto="volcano"', html, fixed = TRUE))
    expect_true(grepl("sci-gallery-card-unavailable", html, fixed = TRUE))
    expect_true(grepl("Install somepkg to use this module.", html, fixed = TRUE))
    expect_true(grepl('data-sci-goto="ma"', html, fixed = TRUE))
})

test_that("the package details point at the package's own site", {
    info <- .sci_gallery_package_info()
    expect_match(info$docs_url, "^https://.+/$")
    expect_match(info$repo_url, "github\\.com")
    expect_identical(info$version, as.character(utils::packageVersion("sciVizModules")))
})

test_that("every gallery CSS rule is scoped to the gallery", {
    css <- .sci_gallery_css()
    selectors <- trimws(sub("\\{.*$", "", strsplit(css, "}", fixed = TRUE)[[1]]))
    selectors <- unlist(strsplit(selectors[nzchar(selectors)], ","))
    expect_gt(length(selectors), 10)
    for (s in trimws(selectors)) {
        expect_match(s, "^\\.scivizmodules-gallery ", info = s)
    }
})


# ---- The server: lazy start ----------------------------------------------------

# A registry of stand-in modules that record in `log` when their server starts.
.fake_showcase <- function(log, fail = NULL) {
    entry <- function(id, kind) {
        list(
            module = "fake", label = id, tab_label = id, group = "Expression", description = id,
            dataset = paste0("data_", id), kind = kind,
            inputs_ui = function(id, data, defaults = NULL, title = NULL) tags$div(id = id),
            output_ui = function(id) tags$div(),
            server_fn = function(id, data, defaults = NULL, ...) {
                if (identical(id, fail)) stop("boom")
                assign("ids", c(get("ids", log), id), envir = log)
                invisible(NULL)
            },
            defaults = list(a = 1), needs = character(0), preview = function(x) x, ui_data = NULL
        )
    }
    list(one = entry("one", "object"), two = entry("two", "df"), bad = entry("bad", "object"))
}

test_that("a module starts the first time its tab is opened, and only then", {
    module_log <- new.env()
    module_log$ids <- character(0)
    loads <- character(0)
    server <- .sci_gallery_server(.fake_showcase(module_log), load = function(name) {
        loads <<- c(loads, name)
        data.frame(x = 1:3)
    })

    shiny::testServer(server, {
        session$setInputs(active_tab = "overview")
        expect_length(module_log$ids, 0)

        session$setInputs(active_tab = "one")
        expect_identical(module_log$ids, "one")
        expect_no_error(output$one_preview)

        session$setInputs(active_tab = "two")
        session$setInputs(active_tab = "one")
        expect_identical(module_log$ids, c("one", "two"))
    })
    expect_identical(loads, c("data_one", "data_two"))

    # Datasets are read once per app, not once per session.
    shiny::testServer(server, {
        session$setInputs(active_tab = "one")
    })
    expect_identical(loads, c("data_one", "data_two"))
})

test_that("a module that fails to start leaves the rest of the gallery running", {
    module_log <- new.env()
    module_log$ids <- character(0)
    server <- .sci_gallery_server(.fake_showcase(module_log, fail = "bad"), load = function(name) data.frame(x = 1))

    shiny::testServer(server, {
        expect_no_error(session$setInputs(active_tab = "bad"))
        session$setInputs(active_tab = "one")
        expect_identical(module_log$ids, "one")
    })
})
