# Trade war impact on US labor market coding sample
## Introduction
This file is modified from the import analysis part of my current work in progress.\
The Python file [Import Analysis](https://github.com/2xu2/Coding-sample/blob/main/Import%20analysis.ipynb) is the main file for data processing and [Plots_for_import_analysis](https://github.com/2xu2/Coding-sample/blob/main/Plots_for_import_analysis.ipynb) makes industry and county level plots. The Stata files performs panel regression and adopts an event study structure to analyze the import tariff at industry and county level. The R file (to be added in the next update) estimates the counterfactual import value supposing there was no trade war using machine learning methods. The Matlab file (to be added in the next update) performs Monte-Carlo testing with simulated data.

## Data processing
In [Import Analysis](https://github.com/2xu2/Coding-sample/blob/main/Import%20analysis.ipynb), I adopt the US import data from China from U.S. Census Bureau via API and combine it with the industry employment data from QCEW and the import tariff data from Bown (2021). Many subtleties when merging are discussed in the notebook. One point to mention is that since tariff data is at the 10-digit Harmonized System Code (HS10) level and the employment data is at the 4-digit North American Industry Classification System (NAICS4) level, I use the concordance table from Census Bureau and calculated the total import value and the weighted average tariff rate at NAICS4 level. 

### Employment data
The employment data used is the Quarterly Census of Employment and Wages (QCEW) by the U.S. Bureau of Labor Statistics surveying more than 95 percent of U.S. jobs by detailed industry. It is based on the 4-digit North American Industry Classification System (NAICS4) code and aggregated at different industrial and geographical levels. For example, manufacturing industries are coded from 31 to 33 at the NAICS2 level. If you want to look for a sub-industry like for rubber product manufacturing, it is coded 3262 at the 4-digit NAICS level. The Harmonized System discussed later works in a similar way, but it is designed for classifying trade commodities, with a different criteria. This paper specifically uses the employment and wage data from 2016 to the first quarter of 2020 at the county and the NAICS4 level. The employed population and unemployment rate are available monthly, while wages are only available quarterly.

### Import data
The paper mainly focuses on US trade data from 2016 to February, 2020. The import data used is from the U.S. Census Bureau international trade section data is based on HS10 commodities and we sum it up to NAICS4 industry level with the concordance table from Census Bureau and combine with the NAICS4 import tariff rate.

### Import tariff data
The tariff data is adopted from Bown (2021). Bown kept a careful log of the bilateral tariff change during the trade war at HS10 level for import tariff. The Harmonized System code is administrated by the World Customs Organization (WCO) to monitor international trade and the lowest level with 10-digit code (HS10) can be interpreted as commodities.

First, I use a weighted average of tariff rate by US total import value in 2017 to calculate the import tariff rates at the NAICS4 industry level. The next step is to project the tariff rates to US counties by estimating the county level exposures to tariff changes. Following Waugh(2019), I use the relative industry employment level to estimate each counties' exposures to the tariffs. 

Formally, the county level exposure to US import tariff on China is defined as:\
![\phi_{c,t} =  \sum_{i\in I} \frac{E_{c,i, 2017}}{E_{c, 2017}} * \tau^{import}_{i, t}](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cphi_%7Bc%2Ct%7D+%3D++%5Csum_%7Bi%5Cin+I%7D+%5Cfrac%7BE_%7Bc%2Ci%2C+2017%7D%7D%7BE_%7Bc%2C+2017%7D%7D+%2A+%5Ctau%5E%7Bimport%7D_%7Bi%2C+t%7D%0A)\
Where ![\phi](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cphi%0A) is the exposure, E is the 2017 base level county and industry level employment, ![\tau](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Ctau%0A) is the US tariff to China imports.

## Plotting
In [Plots_for_import_analysis](https://github.com/2xu2/Coding-sample/blob/main/Plots_for_import_analysis.ipynb), I make two plots, one on the change in import tariffs for industries and one on the exposure change to import tariffs of counties. 
The industry level plot shows the US subindustry groups' import tariff change. The size of the markers indicate the relative employment level of the industry subgroups in the NAICS2 industries.\
![plot1](output_graph/US_industry_import_tariff_change.svg)\
The county level plot shows the geographic impact of the import tariff. We can see a clear geographic distribution of the policy impact. People in the east and central are much more affected by the policy in general.\
![plot2](output_graph/County_import_tariff_exposure.svg)\

## Panel regression and event study
