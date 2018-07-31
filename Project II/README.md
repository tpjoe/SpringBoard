# Project II: Early Prediction of U.S. Corn Yields Using Satellite Imagery

## To see the code in action, please click into notebooks. There are 3 notebooks for this project

1. API and Preprocessing: contains codes for querying data from Google Earth Engine and all preprocessing steps
2. train and evaluate: contains codes for selection and optimization of neural network models
3. Model Result Analysis: contains codes for analysis of model performace and other statistics

## Brief Description of the Project 

Growing up in a family whose business is primarily distribution of agricultural produce, it is always a challenge deciding when we will sell the product, and for how much as these ultimately depend on how much of the produce will be harvested at the end of the season. If there is a way to predict how much will be obtained at the end of the season, we would be able to make decision much easier. Previous studies were able to show that satellite images can be used to predict the area where each type of crop is planted. This leaves the question of knowing the yields in those planted areas. To this end, this project aims to use data from several satellite images to predict the yields of a crop. We chose corn as an example crop in this study. The implication for this project is much more than just my family business of course, big businesses can use this model to optimize their price and inventory, government can prepare for food shortage, even farmers can be informed of appropriate selling price if they know the regional yields.

### This project aims to tackle this data using a data-driven approach, particularly we hope to:

●	Identify correlations between satellites images and crop yields.
●	Build a regression models to predict yields from these images using data from year 2010-2015 as a training and yields in 2016 as a test set.
●	Determine how early can we accurately predict the yields.

### Data Sources

Solutions to all problems start with gathering data and seeing the big picture through big data analytics lens, here I queried images by 4 satellites for each time point from Google Earth Engine including 1) MODIS Terra Surface Reflectance, 2) MODIS Surface Temperature, 3) USDA-FAS Surface and Subsurface Moisture, and 4) USDA-NASS for masking **(total of 146 GB)**. The ground truth annual yields were collected in a county-level from USDA QuickStats. 

### Topics that will be covered using these datasets include

1.	Exploration of value distribution in each satellites in the area that is corn fields
2.	Exploration of the correlation between these values to the corn yields
3.	Feature engineering and image processing
4.	Selection of deep regression models


