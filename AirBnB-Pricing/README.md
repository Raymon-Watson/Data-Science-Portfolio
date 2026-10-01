# AirBnB Regression Analysis

A regression problem for predicting the price of AirBnB listings based on features such as location (longitude/latitude), availability, number of reviews, etc.

This dataset contained significant outliers in pricing, which meant that a lot of effort was spent tuning the fit and engineering features. As such, we give details on the process of model fitting in the **Data Processing & Analysis** section below.

## Project Structure
```text
airbnb/
├── data/
│   └── airbnb_data.csv          # Raw dataset
├── Airbnb_analysis.ipynb        # Complete analysis
└── README.md
```

## Data Structure

The AirBnB data, contained in ```airbnb_data.csv``` possesses the following features:
|column| details|
|-|-|
|id| Unique id for each row|
|name| Listing name|
|host_id| Unique host id|
|host_name| Host name|
|neighbourhood_group| Neighbourhood group name (e.g. Brooklyn, Queens, etc.)|
|neighbourhood| Specific neighbourhood|
|latitude| Location latitude|
|longitude| Location longitude|
|room_type| Type of room available (e.g. Private room, entire home, etc.)|
|price| Daily room price|
|minimum_nights| Minimum number of nights for stay|
|number_of_reviews| Number of reviews for listing|
|reviews_per_month| Number of reviews per month|
|calculated_host_listing_count| Number of listings for given host|
|availability_365| Number of days per year listing is available|


## Data Processing & Analysis
Due to heavy skewing in a number of key variables, including the target variable, the analysis of this dataset was quite involved. For this reason, we give a brief breakdown of the methods utilized in the process towards our final model.

### Exploratory Data Analysis

A number of columns were found to have heavily skewed data, these include:
- minimum_nights
- number_of_reviews
- reviews_per_month
- calculated_host_listings_count

Significantly, the price target variable was heavily skewed, which played into the resulting analysis.

### Basic Modelling
The baseline model was chosen to be simple Linear Regression, which resulted in a fit with an R2 score of ```0.132 ± 0.021```. In an effort to improve this result, we tested:
- Including polynomial features (up to 4th order)
- Transforming skewed variables (log, sqrt, cbrt, robust)
- Regularization (Ridge and Lasso)

**None** of the above tweaks were found to improve the result significantly. Therefore, we moved on to a set of alternative models:
- Decision Tree Regressor
- Random Forest Regressor
- K-Nearest Neighbors
- Support Vector Machine Regression

From this, it was found that the Random Forest model provided the best fit without tuning, returning a cross-validated R2 score of ```0.193 ± 0.028```, which was still quite poor.


### Transforming the Target Variable

After significant exploration in terms of feature engineering and transformation, it was found that logarithmically transforming the target price variable significantly improved the fit. The Random Forest Regression model was then tuned on this transformed data, resulting in a final R2 of ```~0.6```, which represented a significant improvement to the result.


## Key Findings
1. Due to heavy outliers, in particular within the target Price variable, logarithmic scaling provided the best means for fitting.
2. The final Random Forest Regression model on the logarithmically transformed target data achieved an R2 score of ```~0.6``` on the test set.
3. The un-transformed data achieved an R2 score of ```~0.1```, which is significantly worse, which we attribute to the presence of significant outliers in both the training and test sets.
4. Distance from city center, an engineered features, represented the most important feature for predicting listing price.
5. Large differences between the mean absolute error (```~$60.32```) and the median absolute error (```~$23.66```) suggests that extreme outliers greatly reduce the quality of the fit.


**Potential future work:** Removing outliers could greatly improve the fit of the original-scale data.

## How To Run This Project
1. Clone repository into relevant project folder
2. Ensure jupyter notebook is installed, along with all relevant libraries (contained at the top of the jupyter notebook files)
3. Run ```Airbnb_analysis.ipynb``` notebook
