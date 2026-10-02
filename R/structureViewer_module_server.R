#' Server logic for the structureViewer module
#'
#' Renders the structure once per structure, then applies every style change -
#' representation, colours, highlighted residues, background, spin - through
#' the viewer's proxy, so the structure is restyled in place and the view is
#' kept.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` returning an object from [read_structure()].
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @param defaults A named list of default values used when resetting the inputs.
#'   Typically the same list passed to [structureViewerInputsUI()].
#' @return A `reactive` returning the structure.
#'
#' @import shiny
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom colourpicker updateColourInput
#' @importFrom NGLVieweR renderNGLVieweR NGLVieweR_proxy addSelection removeSelection updateStage
#'   updateSpin snapShot
#'
#' @seealso [structureViewer()], [read_structure()], [sciVizModules::structureViewerInputsUI()],
#' [sciVizModules::structureViewerOutputUI()], [sciVizModules::structureViewerApp()]
#' @examples
#' library(sciVizModules)
#' if (interactive()) structureViewerApp()
#' @export
#' @author Jared Andrews
structureViewerServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))

    moduleServer(id, function(input, output, session) {
        hide_input(session, hide.inputs)
        for (tab.name in hide.tabs) hideTab(inputId = "structureViewerTabsetPanel", target = tab.name)

        structure <- reactive({
            x <- data()
            req(x)
            .assert_structure(x)
        })

        # Free text; debounced so typing "245-250" does not restyle at every key.
        highlight_text <- .sci_debounced_input(input, "highlight.residues")

        style <- reactive({
            list(
                representation = input$representation %||% "cartoon",
                color.by = input$color.by,
                highlight = highlight_text(),
                highlight.color = input$highlight.color %||% "#E7298A",
                highlight.representation = input$highlight.representation %||% "ball+stick",
                show.ligands = !isFALSE(input$show.ligands)
            )
        })

        # Names of the representations currently drawn, so a restyle can remove
        # exactly those before adding the new ones.
        drawn <- reactiveVal(character(0))

        output$structureViewer <- renderNGLVieweR({
            x <- structure()
            s <- isolate(style())
            drawn(vapply(do.call(.structure_selections, c(list(x), s)), function(z) z$param$name, character(1)))
            do.call(structureViewer, c(list(x), s, list(
                background = isolate(input$background) %||% "#FFFFFF",
                spin = isTRUE(isolate(input$spin)),
                quality = isolate(input$quality) %||% "medium"
            )))
        })

        observeEvent(style(), {
            selections <- do.call(.structure_selections, c(list(structure()), style()))
            proxy <- NGLVieweR_proxy("structureViewer", session = session)
            for (name in drawn()) removeSelection(proxy, name)
            for (s in selections) addSelection(proxy, s$type, param = s$param)
            drawn(vapply(selections, function(z) z$param$name, character(1)))
        }, ignoreInit = TRUE)

        observeEvent(input$background, {
            updateStage(NGLVieweR_proxy("structureViewer", session = session),
                param = list(backgroundColor = input$background))
        }, ignoreInit = TRUE)

        observeEvent(input$quality, {
            updateStage(NGLVieweR_proxy("structureViewer", session = session), param = list(quality = input$quality))
        }, ignoreInit = TRUE)

        observeEvent(input$spin, {
            updateSpin(NGLVieweR_proxy("structureViewer", session = session), spin = isTRUE(input$spin))
        }, ignoreInit = TRUE)

        observeEvent(input$snapshot, {
            snapShot(NGLVieweR_proxy("structureViewer", session = session),
                fileName = paste0("structure_", format(Sys.Date())),
                param = list(antialias = TRUE, trim = TRUE, transparent = FALSE, scale = 2))
        })

        output$download.structure <- downloadHandler(
            filename = function() {
                x <- structure()
                stem <- sub("[.](pdb|ent|cif|mmcif)([.]gz)?$", "", basename(x$file %||% "structure"), ignore.case = TRUE)
                paste0(stem, ".", x$format)
            },
            content = function(file) writeLines(structure()$text, file)
        )

        observeEvent(input$reset, {
            d <- .structure_defaults(structure(), defaults)
            for (k in c("representation", "color.by", "quality", "highlight.representation")) {
                update_viz_select(session, k, selected = d[[k]])
            }
            updateColourInput(session, "background", value = d$background)
            updateColourInput(session, "highlight.color", value = d$highlight.color)
            updateTextInput(session, "highlight.residues", value = d$highlight.residues)
            updateMaterialSwitch(session, "show.ligands", value = isTRUE(d$show.ligands))
            updateMaterialSwitch(session, "spin", value = isTRUE(d$spin))
        })

        structure
    })
}
