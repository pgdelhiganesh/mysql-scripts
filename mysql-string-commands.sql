-- ------------------------------------------------------------------
-- Common MySQL string commands
-- ------------------------------------------------------------------
SELECT SUBSTRING_INDEX("ABCDEFGHIJ", "/", -1);
/*
--------------
New_Date
--------------
'2020-02-29'
--------------
*/
-- ------------------------------------------------------------------
DROP FUNCTION IF EXISTS `fn_SPLIT_STR`;
DELIMITER $$
CREATE FUNCTION `fn_SPLIT_STR` 
(
  x VARCHAR(255),
  delim VARCHAR(12),
  pos INT
)
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),
       LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1),
       delim, '');
END$$
DELIMITER ;
-- SELECT `fn_SPLIT_STR`('axxx,bxxx,cxxx,dxxxx',',','3');
-- ------------------------------------------------------------------
