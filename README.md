# Churn_Analysis
📉 Customer Churn Analysis — End-to-End Data Analytics Project

SQL Server · Power BI · Python · Machine Learning
A production-ready pipeline that ingests raw telecom data, builds interactive dashboards, and predicts future churners using a Random Forest classifier.


📌 Project Summary
Customer churn is one of the most expensive problems a subscription business faces. This project delivers a complete, repeatable analytics pipeline — from raw CSV to board-ready dashboard to ML-powered predictions — built for a telecom dataset but transferable to any industry.
LayerToolOutputData EngineeringSQL Server (SSMS)Cleaned production table + viewsBusiness IntelligencePower BI3-page interactive dashboardMachine LearningPython / Scikit-learnPredicted churner CSV

🎯 Business Goals

Understand why customers are leaving (churn category & reason)
Identify who is at risk by demographic, geography, account, and service usage
Surface where to focus marketing campaigns for maximum retention impact
Predict which newly joined customers will churn before they do


📊 Key Metrics
MetricValueTotal Customers7,043Total Churned1,869Churn Rate26.5%New Joiners (to predict)411

🗂️ Project Structure
customer-churn-analysis/
│
├── sql/
│   └── churn_analysis.sql        # Full ETL script (staging → prod → views)
│
├── ml/
│   └── churn_prediction.ipynb    # Jupyter notebook — Random Forest model
│
├── data/
│   └── Prediction_Data.xlsx      # Excel export from SQL views (input to ML)
│   └── Predictions.csv           # ML output — predicted churners only
│
├── dashboard/
│   └── Churn_Dashboard.pbix      # Power BI report file
│
└── README.md

⚙️ Step 1 — ETL Pipeline in SQL Server
Tool: Microsoft SQL Server + SSMS
What it does

Creates a dedicated database (db_Churn)
Ingests the raw CSV into a staging table (stg_Churn) via the Import Wizard
Runs a null audit across all 32 columns
Cleans and loads into a production table (prod_Churn) with null defaults:

Service columns → 'No'
Value Deal / Internet Type → 'None'
Churn Category / Reason → 'Others'


Creates two SQL views for Power BI consumption

sql-- Views created for Power BI
CREATE VIEW vw_ChurnData AS
    SELECT * FROM prod_Churn WHERE Customer_Status IN ('Churned', 'Stayed');

CREATE VIEW vw_JoinData AS
    SELECT * FROM prod_Churn WHERE Customer_Status = 'Joined';
📄 Full script → sql/churn_analysis.sql

📈 Step 2–4 — Power BI Dashboard
Tool: Power BI Desktop
Power Query Transformations

Churn Status — binary flag (Churned = 1, Stayed = 0)
Monthly Charge Range — bucketed: < 20, 20–50, 50–100, > 100
Age Group — < 20, 20–35, 36–50, > 50
Tenure Group — < 6 Months through >= 24 Months
prod_Services — unpivoted services table for heatmap visual

DAX Measures
Total Customers  = COUNT(prod_Churn[Customer_ID])
Total Churn      = SUM(prod_Churn[Churn Status])
Churn Rate       = [Total Churn] / [Total Customers]
New Joiners      = CALCULATE(COUNT(prod_Churn[Customer_ID]), Customer_Status = "Joined")
Dashboard Pages
1 — Executive Summary

KPI cards: Total Customers, New Joiners, Total Churn, Churn Rate
Churn rate by Gender, Age Group, Contract, Payment Method, Tenure
Top 5 states by churn rate
Churn category breakdown with drill-through tooltip by reason
Internet type and services usage heatmap

2 — Churn Reason (Tooltip)

Drill-through page showing detailed churn reason breakdown per category

3 — Churn Prediction

Customer-level grid with Monthly Charge, Revenue, Refunds, Referrals
Predicted churn split by Gender, Age, Marital Status, Contract, State


🤖 Step 5 — Churn Prediction (Random Forest)
Tools: Python, Jupyter Notebook, Scikit-learn
Why Random Forest?
An ensemble of decision trees trained on random data/feature subsets. Majority vote determines the final prediction. Delivers strong accuracy, natural resistance to overfitting, and built-in feature importance — ideal for mixed categorical/numerical churn data.
ML Pipeline
Load Data → Pre-process → Encode → Train/Test Split → Train Model → Evaluate → Predict New Joiners → Export CSV
1. Pre-processing

Drop non-predictive columns: Customer_ID, Churn_Category, Churn_Reason
Label-encode 19 categorical features
Map target: Stayed → 0, Churned → 1

2. Model Training
pythonfrom sklearn.ensemble import RandomForestClassifier

rf_model = RandomForestClassifier(n_estimators=100, random_state=42)
rf_model.fit(X_train, y_train)
3. Evaluation
pythonfrom sklearn.metrics import classification_report, confusion_matrix

print(confusion_matrix(y_test, y_pred))
print(classification_report(y_test, y_pred))
4. Predict New Joiners & Export
pythonnew_predictions = rf_model.predict(new_data)
original_data['Customer_Status_Predicted'] = new_predictions
original_data[original_data['Customer_Status_Predicted'] == 1].to_csv('Predictions.csv', index=False)
📓 Full notebook → ml/churn_prediction.ipynb

💡 Key Insights
DriverFindingContract TypeMonth-to-month customers churn at significantly higher ratesTenureHighest risk is in the first 6 months — critical onboarding windowInternet TypeFiber Optic customers show elevated churn vs DSLPayment MethodElectronic check payers churn more than auto-pay customersAdd-on ServicesCustomers without Security or Support add-ons are more likely to leave

🛠️ Tech Stack
CategoryTechnologyDatabaseMicrosoft SQL Server, SSMSBI & VisualisationPower BI DesktopLanguagePython 3.xML FrameworkScikit-learnData ManipulationPandas, NumPyVisualisationMatplotlib, SeabornEnvironmentAnaconda, Jupyter Notebook

🚀 How to Run
SQL

Install SSMS
Run sql/churn_analysis.sql against your SQL Server instance
Import the source CSV when prompted by the staging step

Python
bash# Install dependencies
pip install pandas numpy matplotlib seaborn scikit-learn joblib openpyxl

# Launch notebook
jupyter notebook ml/churn_prediction.ipynb
Update the file_path variable in the notebook to point to your local Prediction_Data.xlsx.
Power BI

Open dashboard/Churn_Dashboard.pbix in Power BI Desktop
Update the data source to point to your SQL Server instance (server name from SSMS)
Refresh and publish


🌐 Industry Applications
Although built on a telecom dataset, every technique here applies directly to:
Retail  ·  SaaS / Subscriptions  ·  Banking & Finance  ·  Healthcare  ·  Insurance  ·  E-commerce
Any business where customer retention drives revenue can adopt this exact pipeline.

👤 Author
   Laxmi 
   https://www.linkedin.com/in/laxmi-sahithi-ranga-193a23335/
   https://github.com/rlaxmisahithi-wq
If you found this project useful, consider giving it a ⭐
