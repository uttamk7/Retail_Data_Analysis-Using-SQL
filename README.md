# Retail Data Analysis
This project provides a comprehensive analysis of retail data stored in a SQL database. The SQL file contains queries that focus on data preparation, understanding, and analysis of three key tables: Transactions, prod_cat_info, and Customer.

## Introduction
This SQL script is designed to analyze and manipulate retail transaction data. The primary goals are to:

-- `Extract key insights from the data.`
-- `Perform necessary data preparations, such as formatting dates.`
-- `Analyze customer transactions, product categories, and related data.`

## Database Schema
The database used in this analysis includes the following tables:

-- **Transactions**
Contains records of all transactions.
Key columns: tran_id, cust_id, prod_id, total_amt, tran_date, etc.

-- **prod_cat_info**
Holds information about product categories.
Key columns: prod_cat_code, prod_cat, prod_sub_cat_code, prod_subcat, etc.

-- **Customer**
Contains customer details.
Key columns: cust_id, cust_name, DOB, Gender, Location, etc.

## SQL Queries
-- **1. Data Preparation and Understanding**

-- **Total Number of Rows in Each Table**
This query calculates the total number of rows in each of the three tables.

-- **Total Number of Transactions with a Return**
This query identifies transactions where products were returned.

-- **Formatting Transaction Dates**
This query converts the tran_date field into a valid date format.

-- **2. Further Data Analysis**
This section would include descriptions and examples of each analysis query in the SQL file.

-- **Usage**
To use this SQL script:

Ensure you have a SQL Server or a compatible database environment set up.
Import the SQL file into your SQL management tool (e.g., SSMS).
Execute the queries to perform the data analysis.

## Note:
Make sure the database and tables are already created and populated with the relevant data before running these queries.

## Contributing
If you want to contribute to this project:

Fork the repository.
Create a new branch.
Commit your changes.
Push to the branch.
Create a new Pull Request.
