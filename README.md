# 📊 SQL Data Analysis Portfolio

This repository showcases SQL projects focused on **data cleaning and exploratory data analysis (EDA)** using a real-world layoffs dataset.

---

## 📁 Dataset

* File: `0.layoffs_data.csv`
* Contains company layoffs data across industries, locations, and time.

---

## 🧹 Data Cleaning (`1. SQL Project- Data Cleaning.sql`)

Performed step-by-step data preparation:

* Created staging table
* Removed duplicates using `ROW_NUMBER()`
* Standardized company, industry, and country fields
* Converted date column into proper format
* Handled null and missing values
* Filtered irrelevant records

👉 Output: Clean, analysis-ready dataset

---

## 📈 Exploratory Data Analysis (`2. SQL _Exploratory Data Analysis Project.sql`)

Key analysis performed:

* Company-wise layoffs ranking
* Industry & country trends
* Yearly and monthly layoffs analysis
* Rolling totals for trend detection
* Stage-wise layoffs breakdown

---

## 🔍 Key Insights

* Layoffs peaked during specific time periods
* Certain industries faced significantly higher layoffs
* Some companies showed repeated layoffs patterns

---

## 🛠 Tools & Concepts Used

* SQL (MySQL)
* Window Functions (`ROW_NUMBER`, `DENSE_RANK`)
* Aggregations (`SUM`, `AVG`)
* Date functions
* Data cleaning techniques

---

## 🚀 How to Run

1. Import CSV file into your SQL database
2. Run `1. SQL Project- Data Cleaning.sql`
3. Run `2. SQL _Exploratory Data Analysis Project.sql`

---

## 👤 Author

Utkarsh Pandey
Aspiring Data Analyst | SQL | Power BI | Excel

---
