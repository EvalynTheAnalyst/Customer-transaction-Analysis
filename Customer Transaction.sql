#CREATE DATABASE CustomerTransaction;
SELECT * 
FROM customertransaction.`customer (1)`;

SELECT * 
FROM customertransaction.transactions;

SELECT * 
FROM customertransaction.prod_cat_info;

#What is the total revenue and tax collected across all transactions?
SELECT 
	round(sum(Tax),2) as Tax,
    round(sum(total_amt),2) as Revenue
FROM customertransaction.transactions;

#Which product subcategory generates the highest sales?
SELECT 
	prod_subcat,
    round(sum(total_amt),2) as revenue
FROM customertransaction.prod_cat_info as prod
INNER JOIN customertransaction.transactions as trans
on prod.prod_sub_cat_code= trans.prod_subcat_code
GROUP BY prod_subcat
ORDER BY revenue desc;

#What is the average spending per customer by city and gender?
SELECT 
	city_code,
    Gender,
    round(sum(total_amt)) as Expenditure
FROM customertransaction.`customer (1)` AS cust
INNER JOIN customertransaction.transactions AS trans
ON cust.customer_Id = trans.cust_id
GROUP BY city_code,Gender
ORDER BY Expenditure DESC;

#How do sales vary across different store types?
SELECT 
	Store_type,
    round(sum(total_amt))as Sales
FROM  customertransaction.transactions
group by Store_type
order by Sales DESC;

#Which product category has the highest profit margin?
with calculation AS(
SELECT 
	prod_cat,
	Round(SUM(Qty * Rate),2)As profit,
    ROUND(SUM(total_amt),2) AS Sales
FROM customertransaction.prod_cat_info as prod
INNER JOIN customertransaction.transactions as trans
on prod.prod_cat_code= trans.prod_cat_code 
GROUP BY prod_cat) 
SELECT 
	prod_cat,
    (profit/Sales) AS profit_margin
FROM
	calculation
ORDER BY profit_margin DESC;

#describe customertransaction.transactions;

#SET SQL_SAFE_UPDATES = 1;

"""UPDATE customertransaction.transactions
SET  tran_date = CASE 
        WHEN tran_date LIKE '%-%-%' THEN STR_TO_DATE(tran_date, '%d-%m-%Y')
        WHEN tran_date LIKE '%/%/%' THEN STR_TO_DATE(tran_date, '%d/%m/%Y')
        ELSE NULL END
WHERE  tran_date IS NOT NULL;"""

#ALTER TABLE customertransaction.transactions
#MODIFY tran_date date;

describe customertransaction.transactions;


# Date with the highest sales
SELECT 
	CASE 
           WHEN DAYOFWEEK(tran_date) = 1 THEN 'Sunday'
           WHEN DAYOFWEEK(tran_date) = 2 THEN 'Monday'
           WHEN DAYOFWEEK(tran_date) = 3 THEN 'Tuesday'
           WHEN DAYOFWEEK(tran_date) = 4 THEN 'Wednesday'
           WHEN DAYOFWEEK(tran_date) = 5 THEN 'Thursday'
           WHEN DAYOFWEEK(tran_date) = 6 THEN 'Friday'
           WHEN DAYOFWEEK(tran_date) = 7 THEN 'Saturday'
       END AS Day_Name,
    round(sum(total_amt)) as sales
FROM customertransaction.transactions
GROUP BY Day_Name;

#Compare the most profitable product categories.
SELECT 
	prod_cat,
    ROUND(SUM(total_amt),2) AS Sales
FROM customertransaction.prod_cat_info as prod
INNER JOIN customertransaction.transactions as trans
on prod.prod_cat_code= trans.prod_cat_code 
GROUP BY prod_cat
ORDER BY Sales DESC;

#Analyze customer retention based on repeat purchases.
SELECT 
    customer_Id,
    count(cust_id) AS repeat_purchase
FROM customertransaction.`customer (1)` as cust
INNER JOIN customertransaction.transactions as trans
ON cust.customer_Id = trans.cust_id
GROUP BY customer_Id;


    


