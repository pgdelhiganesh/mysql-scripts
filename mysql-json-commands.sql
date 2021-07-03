SELECT JSON_TYPE('hello');
SELECT JSON_OBJECT('key1', 1, 'key2', 'abc');
SELECT JSON_TYPE('["a", "b", 1]');SET @j = JSON_OBJECT('key', 'value'); SELECT @j;
SELECT JSON_EXTRACT('{"a": 1, "b": 2, "c": [3, 4, 5]}', '$.*');
SELECT JSON_EXTRACT('{"id": 14, "name": "Aztalssan", "name": "Aztassssssslan"}', '$.name');

DROP PROCEDURE IF EXISTS `pr_get_test`;
DELIMITER $$
CREATE PROCEDURE `pr_get_test`()
BEGIN
  DECLARE var varchar(150) DEFAULT 'hi,hello,good';
  DECLARE element varchar(150);
  
DECLARE json, products, product VARCHAR(4000);
-- SELECT '{"billNo":16,"date":"2017-13-11 09:05:01","customerName":"Vikas","total":350.0,"fixedCharges":100,"taxAmount":25.78,"status":"paid","product":[{"productId":"MRR11","categoryId":72,"categoryName":"Parker Pen","cost":200,"quantity":2,"log":{"supplierId":"725","supplierName":"Rihant General Stores"}},{"productId":"MRR12","categoryId":56,"categoryName":"Drawing Books","cost":150,"quantity":3,"log":{"supplierId":"725","supplierName":"Rihant General Stores"}}]}' INTO json;
SELECT '{"billNo":16,"date":"2017-13-11","customerName":"Vikas"}' INTO json;
SELECT json INTO products;
    SELECT (JSON_KEYS(products));
    SET product = (SELECT JSON_KEYS(products));
    WHILE product != '' DO
	SET element = SUBSTRING_INDEX(product, ',', 1);      
   SET element = REPLACE(element, '"', '');      
   SET element = REPLACE(element, '[', '');      
   SET element = REPLACE(element, ']', '');      
   SELECT element as 'key';
   SELECT JSON_EXTRACT(products,CONCAT('$.',element)) as 'val';
    IF LOCATE(',', product) > 0 THEN
      SET product = SUBSTRING(product, LOCATE(',', product) + 1);
    ELSE
      SET product = '';
    END IF;
  END WHILE;
END$$
DELIMITER ;
CALL `pr_get_test`();

