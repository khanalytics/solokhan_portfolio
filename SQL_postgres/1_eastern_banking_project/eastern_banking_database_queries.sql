/*
	Mohammad Khan
    DTSC660: Data and Database Managment with SQL
	Eastern Banking Database Project






	DATABASE SCHEMA:

branch ( branch_name, branch_city, assets )
customer ( cust_ID, customer_name, customer_street, customer_city )
loan ( loan_number, branch_name, amount )
borrower ( cust_ID, loan_number )
account ( account_number, branch_name, balance )
depositor ( cust_ID, account_number )


    
*/

--------------------------------------------------------------------------------
/*				                 Question 1: Banking DDL

Consider the bank database schema given below, where the primary keys are underlined. 
Write the SQL DDL corresponding to this schema (i.e. the CREATE TABLE statements)

*/
--------------------------------------------------------------------------------
CREATE TABLE branch(
	branch_name varchar(40) PRIMARY KEY, 
	branch_city varchar(40) CHECK(branch_city IN('Brooklyn', 'Bronx', 'Manhattan', 'Yonkers')), 
	assets money NOT NULL
	
);

CREATE TABLE customer( 
	cust_ID bigint PRIMARY KEY, 
	customer_name varchar(40) NOT NULL,
	customer_street varchar(40), 
	customer_city varchar(40) 
);

CREATE TABLE loan( 
	loan_number varchar(40) PRIMARY KEY, 
	branch_name varchar(40), 
	amount money DEFAULT 0.00 NOT NULL,
	FOREIGN KEY(branch_name) REFERENCES branch(branch_name) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE borrower( 
	cust_ID bigint, 
	loan_number varchar(40), 
	PRIMARY KEY(cust_ID, loan_number),
	FOREIGN KEY(cust_ID) REFERENCES customer(cust_ID) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(loan_number) REFERENCES loan(loan_number) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE account( 
	account_number bigint PRIMARY KEY, 
	branch_name varchar(40), 
	balance money DEFAULT 0.00 NOT NULL,
	FOREIGN KEY(branch_name) REFERENCES branch(branch_name) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE depositor( 
	cust_ID bigint, 
	account_number bigint, 
	PRIMARY KEY(cust_ID, account_number),
	FOREIGN KEY(cust_ID) REFERENCES customer(cust_ID) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(account_number) REFERENCES account(account_number) ON UPDATE CASCADE ON DELETE CASCADE
);



---INSERT DATA MANUALLY--

-- Insert Values into branch --

INSERT INTO branch (branch_name, branch_city, assets)
VALUES ('Brooklyn Bank','Brooklyn','2506789.00');

INSERT INTO branch (branch_name, branch_city, assets)
VALUES ('First Bank of Brooklyn','Brooklyn','4738291.00');

INSERT INTO branch (branch_name, branch_city, assets)
VALUES ('Brooklyn Bridge Bank','Brooklyn','3216549.00');

INSERT INTO branch (branch_name, branch_city, assets)
VALUES ('Bronx Federal Credit Union','Bronx','1425365.00');

INSERT INTO branch (branch_name, branch_city, assets)
VALUES ('Big Bronx Bank','Bronx','5632897.00');

INSERT INTO branch (branch_name, branch_city, assets)
VALUES ('Upper East Federal Credit Union','Manhattan','9385274.00');

INSERT INTO branch (branch_name, branch_city, assets)
VALUES ('Yonkahs Bankahs','Yonkers','2356967.00');

SELECT * FROM branch;
-- Insert Values into customer --

INSERT INTO customer (cust_ID, customer_name, customer_street, customer_city)
VALUES ('12345', 'Billy Boi', '123 Easy Street', 'Bronx');

INSERT INTO customer (cust_ID, customer_name, customer_street, customer_city)
VALUES ('54321', 'Teddy Tiger', '56 East Baltimore Road', 'Brooklyn');

INSERT INTO customer (cust_ID, customer_name, customer_street, customer_city)
VALUES ('98524', 'Betty Bench', '123 Easy Street', 'Bronx');

INSERT INTO customer (cust_ID, customer_name, customer_street, customer_city)
VALUES ('24357', 'Walter Halter', '67 Stupid Street', 'Brooklyn');

INSERT INTO customer (cust_ID, customer_name, customer_street, customer_city)
VALUES ('73194', 'Wendy Winks', '78 Gold Street', 'Harrison');

INSERT INTO customer (cust_ID, customer_name, customer_street, customer_city)
VALUES ('74185', 'Lauren Lawn', '3 Gravy Avenue', 'Yonkers');

INSERT INTO customer (cust_ID, customer_name, customer_street, customer_city)
VALUES ('95124', 'Peter Pretender', '85 West Fourth Road', 'Manhattan');

INSERT INTO customer (cust_ID, customer_name, customer_street, customer_city)
VALUES ('86753', 'Susan Sits', '123 Easy Street', 'Bronx');

INSERT INTO customer (cust_ID, customer_name, customer_street, customer_city)
VALUES ('77776', 'Hank Handles', '2 Ford Drive', 'Harrison');

SELECT * FROM customer;

-- Insert Values into loan

INSERT INTO loan (loan_number, branch_name, amount)
VALUES ('462882645', 'Brooklyn Bridge Bank', '7500.00');

INSERT INTO loan (loan_number, branch_name, amount)
VALUES ('888512347', 'Bronx Federal Credit Union', '11500.00');

INSERT INTO loan (loan_number, branch_name, amount)
VALUES ('646469321', 'Upper East Federal Credit Union', '8550.00');

INSERT INTO loan (loan_number, branch_name, amount)
VALUES ('774485962', 'Yonkahs Bankahs', '2000.00');

INSERT INTO loan (loan_number, branch_name, amount)
VALUES ('919137375', 'Brooklyn Bank', '5000.00');

SELECT * FROM loan;

-- Insert Values into borrower

INSERT INTO borrower (cust_ID, loan_number)
VALUES ('54321','888512347');

INSERT INTO borrower (cust_ID, loan_number)
VALUES ('95124','888512347');

INSERT INTO borrower (cust_ID, loan_number)
VALUES ('24357','919137375');

INSERT INTO borrower (cust_ID, loan_number)
VALUES ('77776','462882645');

INSERT INTO borrower (cust_ID, loan_number)
VALUES ('98524','774485962');

SELECT * FROM borrower;
-- Insert Values into account

INSERT INTO account (account_number, branch_name, balance)
VALUES ('142375689', 'First Bank of Brooklyn', '2003.64');

INSERT INTO account (account_number, branch_name, balance)
VALUES ('741852963', 'Yonkahs Bankahs', '5263.23');

INSERT INTO account (account_number, branch_name, balance)
VALUES ('159263487', 'Brooklyn Bank', '1425.98');

INSERT INTO account (account_number, branch_name, balance)
VALUES ('963852741', 'Upper East Federal Credit Union', '2598.36');

INSERT INTO account (account_number, branch_name, balance)
VALUES ('846275315', 'Brooklyn Bridge Bank', '688.12');

INSERT INTO account (account_number, branch_name, balance)
VALUES ('258258963', 'Bronx Federal Credit Union', '3256.21');

INSERT INTO account (account_number, branch_name, balance)
VALUES ('232154689', 'Big Bronx Bank', '4152.87');

INSERT INTO account (account_number, branch_name, balance)
VALUES ('222456197', 'Bronx Federal Credit Union', '1234.56');

INSERT INTO account (account_number, branch_name, balance)
VALUES ('774436581', 'Brooklyn Bank', '8259.34');

SELECT * FROM account;
-- Insert Values into depositor

INSERT INTO depositor (cust_ID, account_number)
VALUES ('77776', '774436581');

INSERT INTO depositor (cust_ID, account_number)
VALUES ('24357', '222456197');

INSERT INTO depositor (cust_ID, account_number)
VALUES ('86753', '232154689');

INSERT INTO depositor (cust_ID, account_number)
VALUES ('74185', '258258963');

INSERT INTO depositor (cust_ID, account_number)
VALUES ('12345', '142375689');

INSERT INTO depositor (cust_ID, account_number)
VALUES ('73194', '741852963');

INSERT INTO depositor (cust_ID, account_number)
VALUES ('12345', '846275315');

INSERT INTO depositor (cust_ID, account_number)
VALUES ('77776', '963852741');

INSERT INTO depositor (cust_ID, account_number)
VALUES ('12345', '159263487');

SELECT * FROM depositor;




--------------------------------------------------------------------------------
/*				                  Question 2 

Write a query to find all customers who are depositors and return their Customer ID, 
Branch Name, Account Number, and Balance

*/
--------------------------------------------------------------------------------

SELECT cust_ID, branch_name, account_number, balance
FROM depositor
INNER JOIN account USING(account_number);

--------------------------------------------------------------------------------
/*				                  Question 3     

Write a query that returns all customers who are both depositors and borrowers. 
Include in your query the customer ID, account number, and loan_number.

*/
--------------------------------------------------------------------------------
SELECT cust_ID, account_number, loan_number
FROM depositor
INNER JOIN borrower USING(cust_ID);
   
--------------------------------------------------------------------------------
/*				                  Question 4   

Write a query that finds the account number of all customers whose deposit 
account is in the city where they live. Include the customer’s city, 
branch city, branch name, and account number. 

*/
--------------------------------------------------------------------------------

SELECT customer.customer_city, branch.branch_city, branch.branch_name, account.account_number
FROM customer 
INNER JOIN depositor USING (cust_ID)
INNER JOIN account USING (account_number)
INNER JOIN branch USING (branch_name)
WHERE customer.customer_city = branch.branch_city;

--------------------------------------------------------------------------------
/*				                  Question 5    

Write a query to generate a unique list of customer IDs that are both depositors 
and borrowers WITHOUT USING JOINS.


*/
--------------------------------------------------------------------------------

SELECT cust_ID FROM borrower
INTERSECT
SELECT cust_ID FROM depositor;
--------------------------------------------------------------------------------
/*				                  Question 6  

Write a SQL query using the university schema to find the ID of each student who 
has never taken a course at the university. Do this using no subqueries and no set 
operations (use an outer join).

*/
--------------------------------------------------------------------------------
SELECT student.id, takes.id, course_id
FROM student
LEFT OUTER JOIN takes ON student.id = takes.id
WHERE takes.course_id IS NULL;



--- ADVANCED QUERIES ---

--------------------------------------------------------------------------------
/*				                 Question 7:  

Write a query to find the cust_ID and customer name of each customer at the bank 
who only has at least one loan at the bank, and no account.

*/
--------------------------------------------------------------------------------
SELECT cust_id, customer_name 
FROM customer
INNER JOIN borrower USING (cust_id)
WHERE cust_ID NOT IN (SELECT cust_id FROM depositor)
GROUP BY cust_id
HAVING COUNT(loan_number) >= 1;




--------------------------------------------------------------------------------
/*				                  Question 8   

Write a query to find the cust_ID and customer name of each customer who lives on 
the same street and in the same city as customer ‘12345’.  Include customer ‘12345’ 
in your query results.

*/
--------------------------------------------------------------------------------


SELECT cust_id, customer_name 
FROM customer
WHERE customer_street = (SELECT customer_street FROM customer WHERE cust_id = '12345') 
	AND customer_city = (SELECT customer_city FROM customer WHERE cust_id = '12345');

	


--------------------------------------------------------------------------------
/*				                  Question 9  

Write a query to find the name of each branch that has at least one customer who
has a deposit  account in the branch and who lives in “Harrison”.

*/
--------------------------------------------------------------------------------
SELECT DISTINCT(branch_name)
FROM account
WHERE account_number IN(SELECT account_number FROM depositor WHERE cust_id IN(
						SELECT cust_id FROM customer WHERE customer_city = 'Harrison'));
   
--------------------------------------------------------------------------------
/*				                  Question 10 

Write a query to find each customer who has a deposit account at every branch
located in “Brooklyn”. 

*/
--------------------------------------------------------------------------------
SELECT customer_name
FROM customer
WHERE cust_id IN(SELECT cust_id FROM depositor WHERE account_number IN(
				SELECT account_number FROM account WHERE branch_name IN(
				SELECT branch_name FROM branch WHERE branch_city = 'Brooklyn')));
--------------------------------------------------------------------------------
/*				                  Question 11  

Write a query that finds the account number of all customers whose deposit 
account is in the citywhere they live. Include the customer’s id, branch city, 
and customer city 

*/
--------------------------------------------------------------------------------

SELECT depositor.cust_id, account.account_number, branch.branch_city, customer.customer_city
FROM depositor 
INNER JOIN account USING(account_number)
INNER JOIN branch USING(branch_name)
INNER JOIN customer USING(cust_id)
WHERE branch.branch_city IN (SELECT customer_city FROM customer WHERE cust_id = depositor.cust_id);
    
--------------------------------------------------------------------------------
/*				                  Question 12 

Write a query that returns every customer that has a loan at Yonkahs Bankahs. 
Include the customer name and branch name for verification. 

*/
--------------------------------------------------------------------------------
SELECT customer_name, branch_name
FROM loan
INNER JOIN borrower USING(loan_number)
INNER JOIN customer USING(cust_id)
WHERE branch_name IN (SELECT branch_name FROM branch WHERE branch_name = 'Yonkahs Bankahs');

    
--------------------------------------------------------------------------------
/*				                  Question 13  
 Write a query that returns the name and loan number of all customers with loan 
 balances higher than $5,000.00.
*/
--------------------------------------------------------------------------------

SELECT customer_name, loan_number
FROM customer
INNER JOIN borrower USING(cust_id)
WHERE loan_number IN (SELECT loan_number FROM loan WHERE amount::numeric > 5000.00)
