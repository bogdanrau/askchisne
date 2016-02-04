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
</tbody>
</table>

> `getMetadata()` function obtains all of the metadata available in AskCHIS NE. This function has only one simple call:

``` r
getMetadata(apiKey = 'YOUR API KEY')
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
geoSearch(search = 'YOUR SEARCH TERM', apiKey = 'YOUR API KEY'>)
```

The resulting data frame will contain:

-   `geoId`: the geoId for each resulting location. This geoId will be required when searching for estimates.

-   `name`: the location name.

-   `geoType`: the type of location. This can be a zip code (ZCTA), a city (CITIES), a county (COUNTIES, a legislative district (ASSEMBLY, CONGRESS, SENATE), or the state (STATE).
