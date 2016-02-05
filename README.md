[![Build Status](https://travis-ci.org/bogdanrau/askchisne.svg?branch=master)](https://travis-ci.org/bogdanrau/askchisne)

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

The following functions can be used to query the AskCHIS NE API:

<table style="width:112%;">
<colgroup>
<col width="37%" />
<col width="75%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Function</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><code>getMetadata()</code></td>
<td align="left">Obtains all of the metadata from AskCHIS NE.</td>
</tr>
<tr class="even">
<td align="left"><code>geoSearch()</code></td>
<td align="left">Returns available locations for a search term.</td>
</tr>
<tr class="odd">
<td align="left"><code>getEstimate()</code></td>
<td align="left">Returns estimate and attributes for one or more locations in the database.</td>
</tr>
<tr class="even">
<td align="left"><code>poolEstimate()</code></td>
<td align="left">Pools estimates for two or more locations.</td>
</tr>
</tbody>
</table>

------------------------------------------------------------------------

> `getMetadata()` function obtains all of the metadata available in AskCHIS NE. This function has only one simple call:

``` r
getMetadata(apiKey = '<YOUR API KEY>')
```

The resulting data frame will contain:

-   `name`: the indicator name (required in the `getEstimate()` function).

-   `label`: the indicator label.

-   `ageGroup`: the age group for that specific indicator.

-   `year`: the data year for the indicator.

-   `responseLabel`: the response label (can be used if developing Shiny apps).

-   `description`: a description of the indicator and link to additional resources if non-CHIS.

------------------------------------------------------------------------

> `geoSearch()` function searches the API for all available geographic locations matching the search string. The function requires a search string and the API key:

``` r
geoSearch(search = 'YOUR SEARCH TERM', apiKey = '<YOUR API KEY>')
```

The resulting data frame will contain:

-   `geoId`: the geoId for each resulting location. This geoId will be required when searching for estimates.

-   `name`: the location name.

-   `geoType`: the type of location. This can be a zip code (ZCTA), a city (CITIES), a county (COUNTIES, a legislative district (ASSEMBLY, CONGRESS, SENATE), or the state (STATE).

------------------------------------------------------------------------

> `getEstimate()` function retrieves estimates as well as additional statistical attributes for one or more requested locations:

``` r
geoSearch(indicator = 'INDICATOR NAME', attributes = NULL, geoLevel = NULL, locations = NULL, apiKey = '<YOUR API KEY>')
```

<table style="width:56%;">
<colgroup>
<col width="26%" />
<col width="29%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Parameter</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">indicator</td>
<td align="left">The name of the indicator, which can be obtained using the getMetadata function.</td>
</tr>
<tr class="even">
<td align="left">attributes</td>
<td align="left">If not specified, returns all available attributes: estimate, population, SE, CI_LB95, CI_UB95, CV, MSE.</td>
</tr>
<tr class="odd">
<td align="left">geoLevel</td>
<td align="left">The level of geography for the query: zcta, cities, counties, assembly, congress, senate, state.</td>
</tr>
<tr class="even">
<td align="left">locations</td>
<td align="left">A comma separated list of geoIds for each location queried (can use the geoSearch() function to obtain those).</td>
</tr>
</tbody>
</table>

The resulting data frame will contain:

-   `geoId`: the geoIds for all locations returned.

-   `geoName`: the name of all of the locations returned.

-   `geoTypeId`: the type of location returned (zip code, city, etc.).

-   `isSuppressed`: a TRUE/FALSE describing whether the estimate is suppressed.

-   `suppressionReason`: description of reason for suppression.

-   `population`: the population universe for that specific indicator.

-   `estimate`: the estimate for that indicator.

-   `SE`: the Standard Error (SE) for that indicator.

-   `CI_LB95`: the lower bound of the 95% Confidence Interval.

-   `CI_UB95`: the upper bound of the 95% Confidence Interval.

-   `CV`: the Coefficient of Variation.

-   `MSE`: the Mean Square Error.

------------------------------------------------------------------------

> `poolEstimate()` function combines multiple locations and returns the pooled estimate for those locations.

``` r
poolEstimate(indicator = 'INDICATOR NAME', attributes = NULL, locations = 'LIST OF LOCATION geoIds', apyKey = '<YOUR API KEY>')
```

The resulting data frame will contain the same columns as the response from `getEstimate()`. with the difference that `poolEstimate()` returns pooled locations, not individual locations.
