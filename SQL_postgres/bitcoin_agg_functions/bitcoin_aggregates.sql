/*

Mohammad Khan
Bitcoin aggregate functions and queries

*/


-- Create the table with appropriate data types 

CREATE TABLE bitcoin_data(
	trans_date date,	
	priceUSD numeric,	
	code_size int,
	sentbyaddress int,
	transactions bigint,	
	mining_profitability numeric,
	sentinusd bigint,	
	transactionfees numeric,
	median_transaction_fee numeric,
	confirmationtime numeric,	
	marketcap bigint,	
	transactionvalue bigint,
	mediantransactionvalue numeric,	
	tweets bigint,
	google_trends numeric,	
	fee_to_reward numeric,	
	activeaddresses bigint,	
	top100cap numeric
);

-- Write the copy statement to bring the code into the database

COPY bitcoin_data
FROM 'C:\Users\Public\bitcoin_data.csv'
WITH (FORMAT CSV, HEADER, NULL "null");


-- Write a query that returns all the data in the table

SELECT * 
FROM bitcoin_data;

-- Write a query that returns the transaction date and the code size divided by the transactions with the column name difficulty

SELECT trans_date, code_size/transactions AS difficulty 
FROM bitcoin_data;

-- Write a query that returns the transaction date and the product of median transaction fee and transactions with the column name daily cost.

SELECT trans_date, median_transaction_fee * transactions AS daily_cost
FROM bitcoin_data; 

-- Write a query that returns the transaction date and the amount sent in USD divided by the number of transactions with the column name average transaction. Also include the median transaction value.

SELECT trans_date, sentinusd/transactions AS average_transaction, median_transaction_fee
FROM bitcoin_data;

-- Write a query that returns the average price in USD with the column name avg price.

SELECT AVG(priceusd) AS avg_price
FROM bitcoin_data;


-- Write a query that returns the total number of transactions with the column name total transactions.

SELECT SUM(transactions) AS total_transactions
FROM bitcoin_data;

-- Write a query that returns the largest value from the market cap column and call it max cap
SELECT MAX(marketcap) AS max_cap
FROM bitcoin_data;

-- Write a query that returns the mean number of tweets and call it the avg daily tweets.

SELECT AVG(tweets) AS avg_daily_tweets
FROM bitcoin_data;


