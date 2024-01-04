/* 

Sales Queries

1. Write a query that returns the types of status that a sales order can have.

2. Write a query that only returns Motorcycle orders. Include order number, price, and sales amount. 

3. Create a list of Customers and their address information. Phone numbers are not required.

4. Create a list of orders whose sales amount was greater than $1,500. Include the order number, customer, sales amount, and quarter

5. (Intentionally vague) The Product Manager has asked you to create a 2nd quarter sales report with information relevant to the products group. 

*/


select * from sales;

--1)
select order_num, customer, order_line_num, sales, order_date, status from sales;

--2)
select order_num, price, sales from sales
where product_line = 'Motorcycles'
order by sales;

--3)
select distinct customer, address_l1, address_l2, city, state, postal_code, country from sales
order by customer;

--4)
select order_num, customer, sales, qtr from sales
where sales > '$1,500'
order by sales, qtr;

--5)
select product_line, product_code, sales from sales
where qtr = 2
group by product_line, product_code, sales
order by product_line;


/*

1. Write a query that returns all sales from the Japan, EMEA, and APAC territories. Include customer, date, product code, and deal size.

2. Write a query that shows sales in November through December. Include month, sales amount, and customer.

3. Write a query that returns all sales whose amount was between $2,000 and $3,000.

4. The sales department suspects that certain customers tend to regularly place small orders instead of medium or large orders. 
They have asked for a list of sales in the third and fourth quarter that have a small deal size. Include order number, quarter, 
customer, and deal size. 

5. After further inspecting your previous query, the sales manager has asked you to provide a list of all 
sales orders that occurred in quarters 1 or 2 or that were made by the customers Mini Classics, Herkku Gifts, or Tekni Collectables Inc. 

*/
select * from sales;

--1)
select customer, product_code, order_date, deal_size, sales from sales
where territory in ('Japan','EMEA', 'APAC')
order by order_date, deal_size, sales;

--2)
select customer, month_id, sales from sales
where month_id = 11 or month_id = 12
order by month_id, sales;

--3)
select order_num, order_line_num, customer, order_date, sales from sales
where sales between '$2,000' AND '$3,0000'
order by sales, order_date;


--4)
select order_num, customer, qtr, deal_size from sales
where qtr in (3,4) AND deal_size = 'Small'
order by qtr, customer;

--5)
select order_num, qtr, customer from sales
where customer in ('Mini classics', 'Herkku Gifts', 'Tekni Collectables Inc')
order by qtr;



/*

1. Write a query that returns a list of customers that starts with T.

2. Write a query that returns a list of customers and their phone numbers if their phone number has a 55 in it. 

3. Write a query that provides a list of customers and their states if the state starts with a C.

4. Write a query that returns a list of product codes that have a 46 in them. 

5. Write a query that returns a list of customers whose name has the WORD of in it. 

*/
select * from sales;

--1)
select customer from sales
where customer like 'T%';

--2)
select distinct customer, phone from sales
where phone like '%55%'
order by customer;

--3) 
select distinct customer, state from sales
where state like 'C%'
order by customer;

--4)
select product_code from sales
where product_code like '%46%';

--5)
select distinct customer from sales
where 
customer like '%of%' OR
customer like '%in%' OR
customer like '%it%'
order by customer;s


/* EXPLORATORY QUERIES FROM PRODUCT MANAGER */

select * from sales;

-- List all products that cost more than $50. Include product code, product line, price from most to least expensive

select distinct product_code, product_line, price from sales
where price > '$50.00'
order by price desc;

-- Return list of all sales in 1st Quarter that have quanity greater than 25. Include product code, order date, quantity, and quarter

select product_code, order_date, quantity, qtr from sales
where quantity > 25 AND qtr = 1
order by quantity, order_date;

-- Return list of all sales from 1st and 3rd quarters. Include product line, price, and quantity.

select product_line, price, quantity, sales from sales
where qtr in (1,3)
order by product_line;

-- Return a list all sales that the order line number is 5 through 10. Include the order number, order line number, quantity. Organize the list by order number smallest to largest.

select order_num, order_line_num, quantity from sales
where order_line_num between 5 AND 10
order by order_line_num;

-- Return a list of all sales of Land of Toys inc, Auto Canal Petit, Gift Depot Inc. Include the company, order number, and quantity organized alphabetically by company name.

select order_num, customer, quantity from sales
where customer in ('Land of Toys Inc.', 'Auto Canal Petit', 'Gift Depot Inc.')
order by customer;



-- Return a list of customers that start with A and organize them alphabetically

select distinct customer from sales
where customer like 'A%'
order by customer;

-- Return a list of products whose product code starts with S10

select distinct product_code from sales
where product_code like 'S10%';

-- Return a list of Customers whose city stars with an H. Include customer,city, and country. organize the list by city Z to A.

select distinct customer, city, country from sales
where city like 'H%'
order by customer desc;

-- Return a list fo customers whose city has bri anywhere in the name. Include customer and city and organize by city alphabetically.

select customer, city from sales
where city ilike '%bri%'
order by city;







