-- Create stocks table with correct data types
-- Mohammad Khan
-- Stocks EDA

CREATE TABLE stocks 
(
   s_index VARCHAR (50),
   s_date DATE,
   s_open numeric(10,2),
   s_high numeric(10,2),
   s_low numeric(10,2),
   s_close numeric(10,2),
    adj_close numeric(10,2),
    volume integer
);

-- import csv data from local source

COPY stocks
FROM 'C:\Users\Public\indexData.csv'
WITH (FORMAT CSV, HEADER, NULL "null");

SELECT * FROM stocks;


--Exploratory Data analysis(EDA)


-- Change in stock prices between closing and opening

SELECT s_index, s_close, s_open, s_close - s_open AS change FROM stocks
ORDER BY change ASC;


SELECT s_index, s_date, s_high - s_low AS diff, 
CAST(((s_high-s_low)/s_close) * 100 AS numeric(10,2)) as percent_delta 
FROM stocks
ORDER BY s_index;


SELECT s_index, CAST(((s_close-s_open)/s_open) *100 AS NUMERIC(10,2)) AS percent_change
FROM stocks
WHERE s_close IS NOT NULL
ORDER BY percent_change DESC;




-- Find the average high stock value organized by stock index and aliased with the name avg value.

SELECT s_index, AVG(s_high) as avg_high FROM stocks
GROUP BY s_index
ORDER BY s_index;

-- Find the sum of the volume for each stock organized by stock index and aliased with the name total volume.

SELECT s_index, SUM(volume) AS total_volume FROM stocks
GROUP BY s_index
ORDER BY s_index;

--Find the average of the difference between the close and adjusted close values organized by the stock index and aliased with the name average difference.

SELECT s_index, AVG(s_close - adj_close) AS avg_diff FROM stocks
GROUP BY s_index
ORDER BY avg_diff;

--Find the total number of days each stock was traded ordered by stock and alias the column with the name stock days.

SELECT s_index, COUNT(s_date) AS stock_days FROM stocks
GROUP BY s_index
ORDER BY stock_days;

