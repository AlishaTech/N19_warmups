-- Get a list of the 3 long-standing customers for each country

-- Return the same list as before, but with only the top 3 customers in each country.


WITH order_info AS 

SELECT *, c.customer_id as c_customer_id, o.customer_id as o_customer_id, od.unit_price*od.quantity*(1-od.discount) as total

FROM orders as o 

    JOIN order_details as od ON o.order_id = od.order_id
    
    JOIN products as p ON od.product_id = p.product_id
    
    JOIN customers as c ON o.customer_id = c.customer_id,
    
customer_totals AS

SELECT c_customer_id, country, sum(total) as total

FROM order_info

GROUP BY c_customer_id, country,

top_customers AS  

SELECT *, RANK() OVER(PARTITION BY country ORDER BY total DESC)

FROM customer_totals

SELECT *

FROM top_customers

WHERE rank <= 3; 
    
 3 newest customers in each each country.


-- Get the 3 most frequently ordered products in each city

product_totals AS

SELECT p.product_id, country, sum(total) as total

FROM order_details

GROUP BY p.product_id, country,

top_products AS

SELECT *, RANK() OVER(PARTITION BY country ORDER BY total DESC)

FROM product_totals

SELECT *

FROM top_products

WHERE rank <= 3;

-- FOR SIMPLICITY, we're interpreting "most frequent" as 
-- "highest number of total units ordered within a country"
-- hint: do something with the quanity column