-- ------------------------------------------------------------------
-- Common MySQL encryption/decryption commands
-- ------------------------------------------------------------------
SELECT AES_ENCRYPT(1234567890, 'foo') AS 'Result';
/*
--------------
Result
--------------
BLOB
--------------
*/

SELECT HEX(AES_ENCRYPT(1234567890, 'foo')) AS 'Result';
/*
--------------
Result
--------------
'948C6E1C547FE22D2E93B2D4181324BE'
--------------
*/

SELECT AES_DECRYPT(UNHEX('948C6E1C547FE22D2E93B2D4181324BE'),'foo') AS 'Result';

SELECT MD5(NOW()) AS 'Result';

SELECT LEFT(MD5(NOW()), 4) AS 'Result';
