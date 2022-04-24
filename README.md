# Exploratory Spatial Data Analysis


Repository for [my talk on April 28th, 2022](https://www.meetup.com/nyhackr/events/285372282/) at the [New York Open Statistical Programming Meetup Group](https://www.meetup.com/nyhackr).

## About the talk

Geospatial data is becoming increasingly common across domains and industries. Spatial data is no longer only in the hands of soil scientists, meteorologists, and criminologists, but in marketing, retail, finance, etc. It is common for spatial data to be treated as any other tabular data set. However, there is information to be drawn from our data's relation to space. The standard exploratory data analysis toolkit will not always suffice. In this talk I introduce the basics of exploratory spatial data analysis (ESDA) and the [{sfdep}](https://sfdep.josiahparry.com/?utm_source=nyhackr) package. [{sfdep}](https://sfdep.josiahparry.com/?utm_source=nyhackr) builds on the shoulders of [{spdep}](https://cran.r-project.org/web/packages/spdep/index.html?utm_source=nyhackr) for spatial dependence, emphasizes the use of simple features and the [{sf}](https://cran.r-project.org/web/packages/sf/index.html?utm_source=nyhackr) package, and integrates within your tidyverse-centric workflow. By the end of this talk users will understand the basics of ESDA and know how to start incorporating these skills in their own work.

## About me

Josiah Parry is a Research Analyst in the Research Science division at The NPD Group focusing on modernization and methodology. Formerly he worked at RStudio, PBC on the customer success team enabling public sector adoption of data science tools. Josiah received his master's degree in Urban Informatics from Northeastern University. Prior to that, he earned his bachelor's degree in sociology with focuses in geographic information systems and general mathematics from Plymouth State University.



## Exploratory Data Analysis

> 	The EDA approach is precisely that--an approach--not a set of techniques, but an attitude/philosophy about how a data analysis should be carried out. - NIST

https://www.itl.nist.gov/div898/handbook/eda/section1/eda11.htm

> "EDA is not a formal process with a strict set of rules. More than anything, EDA is a state of mind." - R4DS

https://r4ds.had.co.nz/exploratory-data-analysis.html

Typical tools in the EDA toolkit: 

- summary statistics: 
  - frequencies and proportions
  - central tendency (mean, median, modes)
  - spread (variance, sd)
- visualization:
  - histogram
  - scatterplot
  - boxplot
- outlier exploration


## Tobler's First Law of Geography

For this talk, I want you to try and relate everything we discuss to night to this quote. 

> Everything is related to everything else, but near things are more related than distant things.

When one gets a social science degree there are many moments in their education where they go "wow, that's so true. How come I've never thought of that?" This is how I felt when I heard this sentence from Dr. Pat May (shout out!) in my human geography class. 


There's a theory of cities that they change like gradients. However, when you're in one spot, most things around it are rather similar. I think of my time in the financial district of boston. There's a starbucks, an au bon pain, and an intelligentsia coffee all within a block or so of eachother. However, a few blocks north you'll find a restaurants, coffeeshops, and bars, on one side of the street, then on the other, a Macys, Urban Outfitter, and other clothing stores. But in between these places the neighborhood felt very similar. As we move along a city, the things near us are all generally very similar, but the further we go we tend to find ourselves in drastically different neighborhoods. Things near eachother are similar, but if we keep a reference point from where we started, we're often likely to find that the further we venture away from our starting point, the more different our environment becomes. 




ESDA is all about trying to identify these spatial clusters where things enar themselves are similar or where things are _not_ like the other things near them. 

s

---- 
Notes

- Toblers First Law 
- What is Exploratory data analysis, what is objective
- How is exploratory spatial analysis different 
- Nature of spatial data
  - most phenomena occur somewhere on the earth, or in space...
- The premise of ESDA
 -   rather than compare the part to the whole, compare the part to the parts surrounding it
- Basics of GIS data: two types
  -   vector and raster
  - raster is a grid of cells (pixels) which contain a value for that grid
  - vector data can be remembered as "points, lines, and polygons" 
  - vector data is often also referred to as geometry
- Vector data and simple features 
  - the basic unit for vector data is the point. 
  - multiple points are connected to create lines
  - 4 or more points that close is a polygon


(https://onlinelibrary.wiley.com/doi/abs/10.1002/adts.202100486)