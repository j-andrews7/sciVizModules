# Nominal sampling times for averaging across subjects

Sampling times often differ slightly between subjects (0.25 h nominal
taken at 0.27 h). Each subject's k-th sample is assigned the median time
of all subjects' k-th samples, which recovers the nominal schedule when
subjects share one.

## Usage

``` r
.pk_nominal_time(time, subject)
```

## Arguments

- time:

  Sampling times.

- subject:

  Subject ids.

## Value

Nominal times, aligned with `time`.

## Author

Jared Andrews
