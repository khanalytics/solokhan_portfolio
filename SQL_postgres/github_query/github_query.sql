/*

Name: Mohammad Khan
DTSC 660
Github Query


*/


--Question 1 (Put your answer below)

SELECT DISTINCT * FROM github;

--Question 2

SELECT DISTINCT topic FROM github;

--Question 3

SELECT DISTINCT repo_name, star_count FROM github
ORDER BY star_count DESC;

--Question 4

SELECT DISTINCT topic FROM github
ORDER BY topic;

--Question 5

SELECT DISTINCT repo_name, star_count FROM github
WHERE star_count > 2000;

--Question 6

SELECT DISTINCT repo_name, star_count FROM github
WHERE repo_name ILIKE '%3d%' AND star_count > 3000;

--Question 7

SELECT DISTINCT repo_name, topic, star_count FROM github
WHERE topic IN ('aws', 'azure', 'chrome') AND star_count < 1000 ;

--Question 8

SELECT DISTINCT repo_link, user_name, repo_name FROM github
WHERE repo_link ILIKE '%ext%';

--Question 9

SELECT DISTINCT topic, star_count FROM github
WHERE topic = 'chrome' AND star_count > 5000;

--Question 10

SELECT DISTINCT user_name, repo_name, star_count FROM github
WHERE star_count > 1000 AND star_count < 15000;


--Question 11

SELECT DISTINCT user_name, star_count FROM github
WHERE star_count > 15000;

--Question 12

SELECT DISTINCT user_name FROM github
WHERE user_name LIKE 'And_%' OR user_name LIKE '%_on';


--Question 13

SELECT DISTINCT topic FROM github
WHERE star_count > 100000 
ORDER BY topic;

--Question 14

SELECT topic, star_count FROM github
WHERE star_count IS NULL;

--Question 15

SELECT topic, user_name, star_count FROM github
WHERE star_count BETWEEN 100000 AND 200000
AND topic LIKE 'a_%';

