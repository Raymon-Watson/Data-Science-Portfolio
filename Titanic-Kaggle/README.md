# Titanic Survival - Machine Learning Project

Dataset from: https://www.kaggle.com/competitions/titanic/overview

A binary classification problem for predicting whether a passenger survived the Titanic disaster using machine learning.

## Project Structure
```text
Titanic-Kaggle/
├── data/
│   └── titanic.csv              # Raw dataset
│   └── titanic_cleaned.csv      # Cleaned dataset
├── 01_eda.ipynb                 # Exploratory Data Analysis
├── 02_data_cleaning.ipynb       # Data Cleaning & Feature Engineering
├── 03_model_building.ipynb      # Model Training & Evaluation
└── README.md
```

## Notebooks
|Number| Notebook|Details|
|-|-|-|
|01|01_eda.ipynb|Initial data exploration, missing value analysis, univariate and bivariate analysis, correlation|
|02|02_data_cleaning.ipynb| Handled missing values (various imputation methods), feature engineering, category encoding (including OneHot encoding)|
|03|03_model_building.ipynb| Train/Test split of data, feature scaling, 6 classification models, cross validation, ROC curves, model comparison, fine-tuning with GridSearchCV|


## Results
6 classification models were trained and compared, with the three best performing model (Random Forest, Logistic Regression, and K-Nearest Neighbors) chosen for further tuning.

The best model after tuning was found to be the **Random Forest** model, which achieved a final performance on the test set data of:
- Accuracy: 0.860
- Precision: 0.806
- Recall: 0.841
- F1: 0.823
- AUC 0.899

Best GridSearchCv parameters: {'max_depth': 10, 'min_samples_leaf': 2, 'min_samples_split': 7, 'n_estimators': 40}


## Key Findings
1. **Random Forest was the best performing model** with a tuned accuracy of 0.86 and F1 score of 0.82
2. **Sex** was by far the most important feature for predicting survival (~74% female survival, ~19% male survival)
3. **Overall survival rate** was only ~38%
4. **Lower fare reduced survival rate**, those with the lowest fare had a significantly lower chance of survival
5. **Larger family size improved survival rate**
6. **Passenger class** significantly impacted survival rate, with upper class having a survival percentage of ~63%, and lower class of ~24%


## How To Run This Project
1. Clone repository into relevant project folder
2. Ensure jupyter notebook is installed, along with all relevant libraries (contained at the top of the jupyter notebook files)
3. Start with 01_eda.ipynb for data exploration
4. Move to 02_data_cleaning.ipynb for data preparation
5. Finally, run 03_model_building.ipynb to train and evaluate models (Note: you can skip directly to this one and use the prepared data instead of running the first two notebooks)
