# E-Commerce Sales, Customer & Profitability Analytics

## Project Overview

This project is an end-to-end **E-Commerce Sales, Customer & Profitability Analytics** project built to demonstrate practical Data Analyst skills using **PostgreSQL, Python, and Power BI**.

The project analyzes sales performance, customer behavior, product and category performance, profitability, marketing performance, and operational metrics to generate actionable business insights.

### Project Workflow

**Raw Data → PostgreSQL → SQL Analysis → Python EDA → Power BI Dashboard → Business Insights**

---

## Business Objectives

The project aims to answer key business questions such as:

- How much revenue and profit is the business generating?
- Which products and categories perform best?
- Who are the highest-value customers?
- Which customers are repeat customers?
- Which categories have the highest profitability?
- Which marketing channels perform best?
- What are the monthly sales and profit trends?
- What percentage of orders are returned or cancelled?
- Which orders or products are loss-making?
- How is the business performing operationally?

---

## Tools & Technologies

- **PostgreSQL** — database management and SQL analysis
- **SQL** — data cleaning, transformation and business analysis
- **Python** — exploratory data analysis
- **Pandas** — data manipulation
- **NumPy** — numerical analysis
- **Matplotlib** — data visualization
- **Google Colab** — Python analysis environment
- **Power BI** — interactive dashboard and business reporting
- **GitHub** — project documentation and version control

---

# Dataset

The project uses five related datasets:

### 1. E-Commerce Sales Transactions

Contains order-level information including:

- Order details
- Customer information
- Sales channel
- Payment information
- Shipping information
- Marketing information
- Discounts
- Revenue
- Product cost
- Profit
- Returns
- Customer reviews

### 2. Order Items

Contains product-level transaction information including:

- Order ID
- Product ID
- Quantity
- Unit price
- Discount
- Revenue
- Product cost
- Profit

### 3. Product Catalog

Contains product master information including:

- Product name
- Category
- Subcategory
- Brand
- Supplier
- Product price
- Product cost
- Product rating

### 4. Customer Master

Contains customer-level information including:

- Customer ID
- Customer name
- Age
- Gender
- Customer segment
- City
- State
- Country
- Region
- Customer acquisition cost

### 5. Dataset Statistics

Contains overall dataset-level statistics used to validate the analysis and calculated KPIs.

---

# SQL Analysis

The SQL analysis was performed in **PostgreSQL** and organized into the following analysis areas.

## 1. Create Table Query

Database tables were created and populated for:

- Customers
- Products
- Orders
- Order Items

The database structure was designed to support analytical queries across customers, orders and products.

---

## 2. Data Quality Checks

Before performing business analysis, the data was checked for:

- Missing values
- Duplicate records
- Duplicate order IDs
- Invalid financial values
- Invalid delivery values
- Data consistency
- Transaction-level anomalies

Data quality checks were performed before using the data for business reporting.

---

## 3. Business Performance

The business performance analysis covers:

### Executive KPIs

- Total Revenue
- Total Profit
- Profit Margin
- Total Orders
- Total Customers
- Average Order Value
- Return Rate
- Cancellation Rate

### Sales Analysis

- Monthly revenue
- Monthly profit
- Order volume
- Yearly performance
- Running revenue
- Growth analysis
- Sales trends

### Profitability Analysis

- Profit by category
- Profit margin
- Loss-making transactions
- Revenue vs profit performance

Window functions and aggregations were also used for ranking and trend analysis.

---

## 4. Customer Analysis

Customer analysis focuses on:

- Top customers by revenue
- Top customers by profit
- Customer order frequency
- Repeat customers
- Average order value
- Customer profitability
- Customer segmentation
- Customer ranking
- High-value customers

SQL techniques used include:

- `JOIN`
- `GROUP BY`
- `HAVING`
- `CTE`
- Aggregate functions
- Window functions
- Ranking
- Conditional logic

---

## 5. Products and Categories

Product-level analysis includes:

- Top products by revenue
- Top products by profit
- Category revenue
- Category profit
- Category profit margin
- Product profitability
- Product rankings
- Top products within categories
- Product performance comparison

The `order_items` and `product_catalog` datasets are used together for detailed product analysis.

---

## 6. Views

Reusable SQL views were created to make the analytical results easier to use in Power BI and other reporting tools.

Key analytical views include:

- `vw_monthly_sales`
- `vw_product_performance`
- `vw_customer_summary`
- `vw_marketing_performance`
- `vw_operations_performance`

These views provide a clean analytical layer between the raw database tables and the reporting/dashboard layer.

---

# Python Exploratory Data Analysis

Python is used for deeper exploratory analysis after the SQL analysis.

The Google Colab notebook covers:

1. Data loading
2. Data validation
3. Missing-value analysis
4. Data type validation
5. KPI calculation
6. Monthly sales trends
7. Product analysis
8. Category analysis
9. Customer analysis
10. Marketing analysis
11. Operations analysis
12. Return analysis
13. Profitability analysis
14. Data visualization
15. Business insight generation

### Python Libraries

```text
Pandas
NumPy
Matplotlib
```

---

# Power BI Dashboard

The final Power BI dashboard is designed around four major business areas.

**[View / Download the Power BI Dashboard (.pbix)](https://drive.google.com/file/d/1KVkaJftfgMi0CJo_bd4CDpsdIeBGUjL2/view?usp=drive_link)**

## Page 1 — Executive Overview

Key metrics:

- Revenue
- Profit
- Profit Margin
- Orders
- Customers
- AOV
- Return Rate
- Cancellation Rate

Visuals:

- Revenue trend
- Profit trend
- KPI cards
- Sales channel performance
- Category performance

---

## Page 2 — Sales & Product Analytics

Analysis includes:

- Category revenue
- Category profit
- Product revenue
- Product profitability
- Top products
- Monthly sales trends

---

## Page 3 — Customer Analytics

Analysis includes:

- Customer segments
- Top customers
- Customer revenue
- Customer profit
- Repeat customers
- Customer order frequency

---

## Page 4 — Marketing & Operations

Analysis includes:

- Marketing channel performance
- Campaign performance
- Returns
- Return reasons
- Delivery performance
- Shipping methods
- Warehouse performance

---

# Key Skills Demonstrated

### SQL

- SELECT
- WHERE
- GROUP BY
- HAVING
- JOINs
- Subqueries
- CTEs
- Aggregate functions
- CASE statements
- Window functions
- `LAG()`
- `RANK()`
- Running totals
- Views
- Data quality validation

### Python

- Pandas
- NumPy
- Data cleaning
- Exploratory Data Analysis
- Aggregation
- Grouping
- Time-series analysis
- Data visualization

### Power BI

- Power Query
- Data modeling
- DAX
- KPI development
- Interactive dashboards
- Business reporting

---

# Business Insights

The project is designed to identify:

- Revenue and profit trends
- Highest-performing products
- Highest-performing categories
- Most valuable customers
- Customer purchasing behavior
- Marketing channel effectiveness
- Return patterns
- Operational performance
- Loss-making transactions

This project demonstrates an end-to-end Data Analyst workflow:

```text
Raw E-Commerce Data
        ↓
PostgreSQL Database
        ↓
Data Quality Checks
        ↓
SQL Business Analysis
        ↓
Python Exploratory Data Analysis
        ↓
Business Insights
        ↓
Power BI Dashboard
```
