create database Retail_data_analysis

select * from [dbo].[Transactions]

select * from [dbo].[prod_cat_info]

select * from [dbo].[Customer]


--DATA PREPARATION AND UNDERSTANDING

--01 What is the total number of rows in each of the 3 tables in the database?

--begin
select (select count(*) from [dbo].[Customer]) as total_number_of_rows_in_customer,
(select count(*) from [dbo].[prod_cat_info]) as total_number_of_rows_in_prod_cat_info,
(select count(*) from [dbo].[Transactions]) as total_number_of_rows_in_Transactions
--end

--02. What is the total number of transactions that have a return?

--begin
select count (total_amt) as no_of_transactions_returned  from [dbo].[Transactions] where total_amt like '-%'
--end


/* 03. As you would have noticed, the dates provided across the datasets are not in a
correct format. As first steps, pls convert the date variables into valid date formats
before proceeding ahead.*/

--begin
select FORMAT([tran_date],'dd-MM-yyyy') as formatted_date from [dbo].[Transactions]
select FORMAT([DOB],'dd-MM-yyyy') as formatted_date from [dbo].[Customer]
--end


/*  04. What is the time range of the transaction data available for analysis? Show the
output in number of days, months and years simultaneously in different columns.  */

--begin
select DATEDIFF(day, min([tran_date]),max([tran_date])) as Day,
 DATEDIFF(MONTH, min([tran_date]),max([tran_date])) as Month,
 DATEDIFF(YEAR, min([tran_date]),max([tran_date])) as Year
from [dbo].[Transactions]
--end


--05. Which product category does the sub-category “DIY” belong to?

--begin
select [prod_cat],[prod_subcat] from [dbo].[prod_cat_info] where [prod_subcat] = 'DIY'
--end


--DATA ANALYSIS


--01. Which channel is most frequently used for transactions?

--begin
select top 1 [Store_type],
count([Store_type] )as channel from [dbo].[Transactions]
group by [Store_type]
order by channel desc
--end


--02. What is the count of Male and Female customers in the database?

--begin
select  (select count([Gender]) from [dbo].[Customer] where [Gender] like 'm%')as male
,(select  count([Gender]) from [dbo].[Customer] where [Gender] like 'f%') as female

--OR

select [Gender],count([Gender]) as count from [dbo].[Customer]
where [Gender] in ('m','f')
group by Gender
--end


--03. From which city do we have the maximum number of customers and how many?

--begin
select top 1[city_code], 
count(customer_Id) as No_customers from [dbo].[Customer]
group by [city_code] 
order by No_customers desc
--end


--04. How many sub-categories are there under the Books category?

--begin
select [prod_cat], count([prod_subcat])as no_subcat from [dbo].[prod_cat_info]
where [prod_cat] like 'Books'
group by [prod_cat]
--end


--05. What is the maximum quantity of products ever ordered?

--begin
select [prod_cat],max([Qty]) as Oty 
from [dbo].[prod_cat_info] p
inner join [dbo].[Transactions] t on t.[prod_cat_code]=p.[prod_cat_code]
group by [prod_cat]
--end


--06. What is the net total revenue generated in categories Electronics and Books?

--begin
select prod_cat,sum([total_amt]) as amount from [dbo].[prod_cat_info] p
inner join [dbo].[Transactions] t on t.[prod_cat_code]=p.[prod_cat_code] 
and t .[prod_subcat_code]=p.[prod_sub_cat_code]
where prod_cat in  ('Books','Electronics') group by prod_cat
--end


--07. How many customers have >10 transactions with us, excluding returns?

--begin

SELECT COUNT(*) AS Number_of_customers
FROM (
    SELECT cust_id
    FROM Transactions
    WHERE total_amt > 0
    GROUP BY cust_id
    HAVING COUNT(transaction_id) > 10
) AS subquery;


 --end


/*08. What is the combined revenue earned from the “Electronics” & “Clothing”
categories, from “Flagship stores”?*/

--begin
select sum([total_amt]) as ComboRevenue 
from [dbo].[Transactions] t
inner join [dbo].[prod_cat_info] p on t.[prod_cat_code]=p.[prod_cat_code]
and t .[prod_subcat_code]=p.[prod_sub_cat_code]
where [prod_cat] in  ('Clothing','Electronics')
and [Store_type] = 'Flagship store'

--end

/*9. What is the total revenue generated from “Male” customers in “Electronics”
category? Output should display total revenue by prod sub-cat.*/

--begin
select [prod_subcat] ,sum([total_amt]) as total_revenue
from [dbo].[Customer] c
inner join [dbo].[Transactions] t on t.[cust_id]=c.[customer_Id]
inner join [dbo].[prod_cat_info] p on p.[prod_cat_code]=t.[prod_cat_code] 
and [prod_sub_cat_code]=[prod_subcat_code]
where [Gender]  like 'M%' and [prod_cat]='Electronics'
group by [prod_subcat]
 
--end


/*10. What is percentage of sales and returns by product sub category; display only top
5 sub categories in terms of sales?*/

--begin
SELECT TOP 5 
[prod_subcat], (SUM([total_amt])/(SELECT SUM([total_amt]) FROM [dbo].[Transactions]))*100 AS PERCANTAGE_OF_SALES, 
(COUNT(CASE WHEN [total_amt]< 0 THEN [total_amt] ELSE NULL END)/SUM([total_amt]))*100 AS PERCENTAGE_OF_RETURN
FROM [dbo].[Transactions] t
INNER JOIN [dbo].[prod_cat_info] p ON p.[prod_cat_code]=t.[prod_cat_code] and [prod_subcat_code]=[prod_sub_cat_code]
GROUP BY [prod_subcat]
ORDER BY SUM([total_amt]) DESC
--end


/*11. For all customers aged between 25 to 35 years find what is the net total revenue
generated by these consumers in last 30 days of transactions from max transaction
date available in the data?*/

--begin
select [cust_id],sum([total_amt]) as total_revenue  from [dbo].[Transactions] 
where [cust_id]  in 
(select  [customer_Id]  from [dbo].[Customer]
where DATEDIFF(year,convert(date,[DOB],103),GETDATE()) between 25 and 35)
AND convert(date,[tran_date],103) between dateadd(day,-30,
(select max(convert(date,[tran_date],103)) from [dbo].[Transactions]))
AND (select max(convert(date,[tran_date],103)) from [dbo].[Transactions])
group by [cust_id]
--end


/*12. Which product category has seen the max value of returns in the last 3 months of
transactions?*/

--begin
select top 1 [prod_cat],sum([total_amt]) as total_amount
from [dbo].[prod_cat_info] p
inner join [dbo].[Transactions] t on t.[prod_cat_code]=p.[prod_cat_code] and [prod_sub_cat_code]=[prod_sub_cat_code]
where [total_amt] < 0
 and convert(date,[tran_date],103) between dateadd(month,-3,
(select max(convert(date,[tran_date],103)) from [dbo].[Transactions]))
and (select max(convert(date,[tran_date],103)) from [dbo].[Transactions])
group by [prod_cat]
order by total_amount desc
--end


/*13. Which store-type sells the maximum products; by value of sales amount and by
quantity sold?*/

--begin
SELECT [Store_type], SUM([total_amt]) TOT_SALES, SUM([Qty]) TOT_QUAN
FROM [dbo].[Transactions]
GROUP BY [Store_type]
HAVING SUM([total_amt]) >=ALL (SELECT SUM([total_amt]) FROM [dbo].[Transactions] GROUP BY [Store_type])
AND SUM([Qty]) >=ALL (SELECT SUM([Qty]) FROM [dbo].[Transactions] GROUP BY [Store_type])
--end


--14. What are the categories for which average revenue is above the overall average.

--begin
select [prod_cat],avg([total_amt]) as average from [dbo].[prod_cat_info] p
inner join [dbo].[Transactions] t on t.prod_cat_code=p.prod_cat_code 
group by [prod_cat]
having avg([total_amt])>(select avg([total_amt]) from [dbo].[Transactions])
--end

/*15. Find the average and total revenue by each subcategory for the categories which
are among top 5 categories in terms of quantity sold.*/

--begin
select top 5 [prod_cat],[prod_subcat],avg(total_amt) as Average_revenue,sum(total_amt) as Total_revenue
	from [dbo].[Transactions] t
	join [dbo].[prod_cat_info] p on p.prod_cat_code=t.prod_cat_code 
	and [prod_sub_cat_code]=[prod_subcat_code]
	where [prod_cat] in
	(select top 5  [prod_cat] from [dbo].[Transactions] t
	join [dbo].[prod_cat_info] p on p.prod_cat_code=t.prod_cat_code 
	and [prod_sub_cat_code]=[prod_subcat_code]
	group by [prod_cat]
	order by sum(Qty) desc)
	group by [prod_cat],[prod_subcat]
--end


