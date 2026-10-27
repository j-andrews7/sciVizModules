library(sciVizModules)

# The gallery's app logic lives in sciVizModules::sciModuleGalleryApp() so it
# can be launched directly with sciModuleGalleryApp(). This file stays as a thin
# wrapper so the gallery can still be deployed (e.g. to shinyapps.io or Posit
# Connect), which needs an app.R ending in a shinyApp() call.
#
# The optional packages some tabs need are named here so rsconnect bundles
# them with a deployment; a tab whose packages are missing is left out.
requireNamespace("ComplexHeatmap", quietly = TRUE)
requireNamespace("InteractiveComplexHeatmap", quietly = TRUE)
requireNamespace("circlize", quietly = TRUE)
requireNamespace("airway", quietly = TRUE)
requireNamespace("DESeq2", quietly = TRUE)
requireNamespace("maftools", quietly = TRUE)
requireNamespace("GOfan", quietly = TRUE)
requireNamespace("org.Hs.eg.db", quietly = TRUE)
requireNamespace("PCAtools", quietly = TRUE)
requireNamespace("drc", quietly = TRUE)
requireNamespace("pROC", quietly = TRUE)

parts <- sciModuleGalleryApp(return_components = TRUE)
shinyApp(parts$ui, parts$server)
