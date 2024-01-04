/* 
Name: Mohammad Khan
Dataset: Airbnb

Why chose this dataset? : Airbnb dataset seemed the most challeneging with many columns that could be data wrangled 
compared to the other two datasets. There are many missing/Null data in multiple columns, extraneous data in neighbourhood_group, 
and price and service_fee columns data could be cleaner by updating to integer data without dollar amount.

*/


CREATE TABLE airbnb(
	airbnb_id int,	
	airbnb_name text,
	host_id bigint,	
	host_identity_verified varchar(25),	
	host_name varchar(50),	
	neighbourhood_group varchar(25),	
	neighbourhood text,	
	lat	decimal,
	long decimal,	
	country varchar(25),
	country_code varchar(25),	
	instant_bookable bool,	
	cancellation_policy	varchar(25),
	room_type varchar(25),
	Construction_year smallint,	
	price text,	
	service_fee	text, 
	minimum_nights smallint,
	number_of_reviews int,	
	last_review date,	
	reviews_per_month decimal,	
	review_rate_number smallint,	
	calculated_host_listings_count smallint,	
	availability_365_days smallint,	
	house_rules	text,
	license text
);

 COPY airbnb
 FROM 'C:\Users\Public\airbnb.csv'
 WITH (FORMAT CSV, HEADER);





/*
Question 1
*/

CREATE TABLE airbnb_backup AS
SELECT *
FROM airbnb;


/*
Question 2
*/

ALTER TABLE airbnb ADD COLUMN duplicate_country_code varchar(25);
UPDATE airbnb SET duplicate_country_code = country_code;



/* 
Some queries used for data explorations below */

ROLLBACK;
COMMIT;

SELECT * FROM airbnb;

SELECT neighbourhood, neighbourhood_group, country, country_code FROM airbnb
WHERE country IS NULL AND neighbourhood_group IS NULL;


SELECT neighbourhood, neighbourhood_group, country, country_code FROM airbnb
WHERE country_code IS NULL;

SELECT count(*),neighbourhood_group FROM airbnb
GROUP BY neighbourhood_group;

SELECT neighbourhood, neighbourhood_group FROM airbnb
WHERE neighbourhood_group IS NULL;


SELECT country FROM airbnb
WHERE country = 'United States';

SELECT country_code FROM airbnb
WHERE country_code = 'US';

/*
Question 3

There are inconsistencies with location-based columns(neighbourhood, neighbourhood_group, country, and country_code) 
 missing values(NULL), but comparing columns side by side helped me determine missing values for country and country_code.
 
 So I chose option b."Change their values to another value that accurately represents or reflects the data 
 (such as substituting the mean of the column for the value)".
 
 All missing values for country were changed to 'United States' based off piecing together location information in neighbourhood and 
 neighbourhood_group and confirming with google maps.

*/

UPDATE airbnb 
SET country = 'United States'
WHERE country IS NULL;

/*
Question 4

Continuation from Question 3 and choosing option b, since all missing country values were updated to 'United States', 
then all country_code must also be updated to 'US'
*/

UPDATE airbnb 
SET country_code = 'US'
WHERE country_code IS NULL;

/*
Question 5
After exploring columns, the neighbourhood_group column had Brooklyn and Manhattan missplled one instance each and 29 Null values.

For this question, I corrected only 'brookln' to correct 'Brooklyn' entry using REPLACE.

Code used for exploring column :

SELECT COUNT(*), neighbourhood_group FROM airbnb
GROUP BY neighbourhood_group;

*/


UPDATE airbnb
SET neighbourhood_group = REPLACE(neighbourhood_group, 'brookln', 'Brooklyn');

/*

Question 6

Intitially creating the airbnb table, I noticed entering neighbourhood data into the column resulted in error with varchar(25)
because some entries had both neighbourhood and neighbourhood_group('Bay Terrace, Staten Island' and 'Chelsea, Staten Island') 
seperated by comma and  exceeding the 25 Varchar characters alloted. So I had to change datatype to text incase there were other long inconsistent entries.

So for this question, I used REPLACE  ', Staten Island' with '' (empty value) for filtering every instances of '%, Staten Island' 
To confirm query worked, Count function showed Chelsea and Bay Terrace were accounted for in correct group.

Exploratory query: 
SELECT neighbourhood FROM airbnb
WHERE neighbourhood ILIKE '%_,_%';

*/

UPDATE airbnb
SET neighbourhood = REPLACE(neighbourhood, ', Staten Island', '')
WHERE neighbourhood LIKE '%, Staten Island';

/*

Question  7

SUBSTRING method was used to exclude dollar symbol, '$' from first position by specifying 2nd position. 
This was done for all rows without NULL values and the updated column is returned with RETURNING.

The commas and $ symbols could have been replaced with REPLACE all in one query but for the purpose of using 
different method(SUBSTRING) is demonstrated.

Further queries can replace commas and also change text datatype to integer datatype for useful aggregate methods.


Exploratory code: 
SELECT price, service_fee FROM airbnb
WHERE service_fee IS NULL
ORDER BY price;
*/


UPDATE airbnb
SET price = SUBSTRING(price, 2)
WHERE price IS NOT NULL
RETURN price;







