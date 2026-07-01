# Generate the example `survival_lung` dataset shipped with sciVizModules.
#
# Derived from the NCCTG lung cancer dataset (`survival::lung`), lightly
# cleaned so it is a good, self-explanatory example for the survivalCurve
# module: numeric follow-up time, an event/status indicator, and a couple of
# human-readable grouping variables.

library(survival)

data("lung", package = "survival")

survival_lung <- data.frame(
    time = lung$time, # follow-up time in days
    status = lung$status, # 1 = censored, 2 = dead (survival::Surv convention)
    age = lung$age,
    sex = factor(ifelse(lung$sex == 1, "Male", "Female"), levels = c("Male", "Female")),
    ph.ecog = factor(lung$ph.ecog,
        levels = c(0, 1, 2, 3),
        labels = c("Asymptomatic", "Symptomatic", "In bed <50%", "In bed >50%")
    ),
    stringsAsFactors = FALSE
)

# Drop rows with missing time/status so the fit always succeeds out of the box.
survival_lung <- survival_lung[!is.na(survival_lung$time) & !is.na(survival_lung$status), ]
row.names(survival_lung) <- NULL

save(survival_lung, file = "data/survival_lung.rda", compress = "xz")
