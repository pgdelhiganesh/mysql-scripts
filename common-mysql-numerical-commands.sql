-- ------------------------------------------------------------------
-- Common MySQL string commands
-- ------------------------------------------------------------------
SELECT FLOOR(RAND() * 90000 + 10000) AS 'Result';
/*
--------------
Result
--------------
'59165'
--------------
*/

SELECT CONCAT(FLOOR(RAND() * 900 + 100), DATE_FORMAT(NOW(),'%d%m') , FLOOR(RAND() * 90000 + 10000)) AS 'Result';
/*
--------------
Result
--------------
'761030713194'
--------------
*/
-- ------------------------------------------------------------------
