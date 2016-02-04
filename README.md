askchisne
=========

An R package that connects to the [AskCHIS NE](http://askchisne.ucla.edu) API and retrieves data into R data frames. NOTE: this package does not come with any warranties.

Installation
============

Install from CRAN: COMING SOON!

Install from GitHub:

``` r
devtools::install_github("bogdanrau/askchisne")
```

Usage
=====

Before using this package, you must obtain an API key from the [California Health Interview Survey (CHIS)](http://chis.ucla.edu). You will use the API key in all functions to connect to the API and get data.

Base Functions
--------------

`getMetadata()` function obtains all of the metadata available in AskCHIS NE. This function has only one simple call:

``` r
getMetadata(apiKey = '<YOUR API KEY>')
```

The resulting data frame will contain: \* `name`: the indicator name (required in the `getEstimate()` function).

-   `label`: the indicator label.

-   `ageGroup`: the age group for that specific indicator.

-   `year`: the data year for the indicator.

-   `responseLabel`: the response label (can be used if developing Shiny apps).

-   `description`: a description of the indicator and link to additional resources if non-CHIS.

------------------------------------------------------------------------
