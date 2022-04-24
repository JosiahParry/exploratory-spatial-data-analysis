# ESDA lecture Luc Anselin notes

https://www.youtube.com/watch?v=a7XyyeqIgy4&ab_channel=GeoDaSoftware⁄

## EDA 

- EDA created by John Tukey
- Spatial analysis lacks locational invariance 
- EDA is non-scientific it relies on interaction and judgement on the side of the analyst to "discover potentially explicable patterns" (Good, 1983)
  - the explanation of the patterns is not part of the EDA process.
  - The EDA process is about identfying those observations or groups of observations, or patterns that may have a good question behind it and can be answered
- EDA is about designing new views of the data that suggest interesting patterns or elicit interesting questions 
- eda explores distributions of data 

## ESDA 

- EDA + spatially specific topics
- most noteably the spatial distribution 
  - are things randomly distributed 
  - or are they sytematically located on place more than another 
- an outlier in space is not the same as that of the traditional concept. 
  - a spatial outlier is different from its neighbors, not from the entirety of the dataset 
- spatial autocorrelation: how similar things are in similar locations
- spatial heterogeneity: identify spatial differences perhaps identifying multiple distributions
  - spatial regimes: spatial subsets of the data where different models or statistics may have to be applied
  
  
https://www.sciencedirect.com/topics/earth-and-planetary-sciences/exploratory-spatial-data-analysis#:~:text=ESDA%20is%20a%20step%2Dby,Encyclopedia%20of%20Human%20Geography%2C%202009

"Exploratory spatial data analysis (ESDA) is an extension of exploratory data analysis as it explicitly focuses on the particular characteristics of geographical data. "

"spatial distributions, identify atypical locations or spatial outliers, discover patterns of spatial association, clusters or hot spots, and suggest spatial regimes or other forms of spatial heterogeneity."





---- 

# potential outline

- me very briefly
- brief review of EDA
  - goal
  - techniques
- ESDA is an extension of EDA looking at spatial patterns
- first need to understand what spatial data might mean
  - you might have an intuition and its likely correct
  - spatial data is any data that is tied or can be tied to a physical location
    - on the globe, in space, or in some other plane
  - lets think of the data generation proces
    - satellite imagery
    - transit (bus routes, road networks)
    - regions e.g. census tracts
    - locations of trees
    - building locations
  - most data that is generated in the era of big data is actually spatial in nature
    - sales transactions
    - 311 & 911 calls 
    - mobile data (ever wonder why so many apps need your location)
    - map routing
    - vehicles
- types of spatial data
  - spatial data generally falls into two separate buckets
    1. vector (the focus of this talk and most ESDA) 
    2. raster
  - vector:
    - the basic unit of vector data is the point determined by an X, Y (and sometimes Z) coordinate
    - lines are the connections to two or more points
    - polygons are the connections of 4 points or more (3 verticies or more)
      - polygons are closed so thus the last point lands on the first point to close it  - examples:
      - traffic incident locations
      - road networks
      - census tracts, or zoning regions
  - raster data
    - represented by a grid where each cell (pixel) contains a value 
    - examples:
      - sattelite imagery
      - land cover
      - remote sensing data (LiDAR)
        - autonoumous vehicles, face id 
      - weather patterns
      - much much more
- for the purpose of this talk we'll focus on vector data and specifically points and polygons
- ESDA cont. 
  - ESDA, rather than EDA, rather than comparing a part to the whole compares a part its neighbors
    - outliers in the case of ESDA aren't extreme values compared to the entire dataset or groups in the data set, but outliers in comparison to one's spatial neighbors
  - Goals:
    - the same as EDA: discover potentially explicable patterns
      - identifying hotspots
      - identifying potential spatial regimes
  - techniques:
    - spatial autocorrelation
    - local indicators of spatial association
- Understanding spatial neighbors
  - Goal: identify the neighbors for each region in our dataset
  - For polygons, neighbors are defined by the other polygons that it touches (or are contiguous with)
  - Two primary types of contiguity:
    - Edge (rook)
    - Vertices (queen)
- Understanding Spatial Weights
- Understanding the spatial lag
  - warning! We're going to get a LITTLE mathy here but i'm sure you all got it 
    - only going to be adding, subtracting, and taking averages! 
  - if you're familiar with time-series, the idea is similar
    - with time-series the lag compares an obverserved value compared to the same observed value at an earlier point in time
  - with spatial analysis, we compare an observed point with the observed point of its neighbors
  - the spatial lag is simply the expected value (average) of a variable in a neighborhood excluding the observed regions value 
  - with the computed spatial lag, we can visually compare an observed regions value to the average value of its neighbors (the spatial lag) using a scatter plot
  - x: the observed value
  - y: the spatial lag
  - we use this plot to explore whether or not 
- Understanding Spatial autocorrelation
  - spatial randomness
  - negative autocorrelation
  - positive spatial autocorrelation
  - generally bounded between [-1, 1] though in some cases can exceed. 
- Hypothesis testing in space
  - null: spatial randomness
  - alternative: not-spatially random
  - most variables do not fall under our assumption of normality so normal t-tests do not suffice
  - we use permutation based hypothesis testing to create _simulated_ p-values
- The Global Moran
- The Local Moran
- Introduction to sfdep
  - background: grad school learning these topics with Geoff Boeing using Pysal--the most common open-source tool for ESDA. The whole time was a little miffed I couldn't easily do this in R
    - show his chart of average street network direction
  - extension of the library `spdep` 
  - motivation: make spdep tidyverse compatible, work exclusively with sf objects, and make ESDA as accessible, if not more accessible than pysal
  - outputs are meant to be tidyverse compatible as possible:
    - vectors, lists, and data frames
      - vectors as columns
      - lists as list columns
      - data frames that can be unnested or unpacked as new columns
      
- Making neighbors
- Making spatial weights
- Making the spatial lag
- Making a moran plot
- The Global Moran's I
- Making Moran's I local
  - intuition
  - example visualization
-
  

    

      