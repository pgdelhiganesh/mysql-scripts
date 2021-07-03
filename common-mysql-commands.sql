-- ------------------------------------------------------------------
-- Common MySQL Commands
-- ------------------------------------------------------------------
SHOW DATABASES;
/*
--------------
Database
--------------
sys
test_db
....
....
....
--------------
*/
-- ------------------------------------------------------------------
DROP SCHEMA IF EXISTS `test_db`;
CREATE SCHEMA IF NOT EXISTS `test_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `test_db`;
-- ------------------------------------------------------------------
-- Select all store procedures
SELECT * FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA = 'test_db' AND ROUTINE_TYPE = 'PROCEDURE';
/*
--------------
SPECIFIC_NAME, ROUTINE_CATALOG, ROUTINE_SCHEMA, ROUTINE_NAME, ROUTINE_TYPE, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, CHARACTER_OCTET_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE, DATETIME_PRECISION, CHARACTER_SET_NAME, COLLATION_NAME, DTD_IDENTIFIER, ROUTINE_BODY, ROUTINE_DEFINITION, EXTERNAL_NAME, EXTERNAL_LANGUAGE, PARAMETER_STYLE, IS_DETERMINISTIC, SQL_DATA_ACCESS, SQL_PATH, SECURITY_TYPE, CREATED, LAST_ALTERED, SQL_MODE, ROUTINE_COMMENT, DEFINER, CHARACTER_SET_CLIENT, COLLATION_CONNECTION, DATABASE_COLLATION
--------------
'pr_get_Customer_Master_List', 'def', 'allpos_wposresl_db', 'pr_get_Customer_Master_List', 'PROCEDURE', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SQL', 'BEGIN\n	SELECT\n	`Customer_Master`.`Customer_Code`, `Customer_Master`.`Customer_Name`,\n	`Customer_Master`.`Phone`, `Customer_Master`.`Email`, `Customer_Master`.`City`,\n	`Customer_Master`.`Credit_Payment`, `Customer_Master`.`Advance_Payment`,\n	`Customer_Master`.`Loyalty_Point`,\n	(CASE WHEN `Customer_Master`.`Is_Active` = \'1\' THEN \'Active\' ELSE \'Inactive\' END) AS \'Active_Status\'\n	FROM `Customer_Master` WHERE `Customer_Master`.`Is_Deleted` = \'0\';\nEND', NULL, 'SQL', 'SQL', 'NO', 'CONTAINS SQL', NULL, 'DEFINER', '2021-06-26 19:23:57', '2021-06-26 19:23:57', 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION', '', 'root@localhost', 'utf8mb4', 'utf8mb4_0900_ai_ci', 'utf8mb4_unicode_ci'
'pr_get_Employee_Master', 'def', 'allpos_wposresl_db', 'pr_get_Employee_Master', 'PROCEDURE', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SQL', 'BEGIN\n	SELECT\n	`Employee_Master`.`Employee_Code`,\n	`Employee_Master`.`Employee_Name`,\n	`Employee_Master`.`Phone`,\n	`Employee_Master`.`Email`,\n    HEX(AES_ENCRYPT(`Employee_Master`.`PIN`, \'PIN\')) AS \'PIN\',\n    HEX(AES_ENCRYPT(`Employee_Master`.`Swipe_Card_Number`, \'Card\')) AS \'Swipe_Card_Number\',\n    `Employee_Master`.`User_Name`,\n    HEX(AES_ENCRYPT(`Employee_Master`.`Password`, \'Password\')) AS \'Password\',\n	`Employee_Master`.`Software_Rights_Group`,\n	CONVERT(`Employee_Master`.`Employee_Image` USING UTF8MB4) AS \'Employee_Image\',\n	(CASE WHEN `Employee_Master`.`Is_Captain` = \'1\' THEN \'Yes\' ELSE \'No\' END) AS \'Captain\',\n	(CASE WHEN `Employee_Master`.`Is_Active` = \'1\' THEN \'Active\' ELSE \'Inactive\' END) AS \'Active_Status\',\n	DATE_FORMAT(`Employee_Master`.`Created_Date`,\'%d-%m-%Y %H:%i:%S\') AS \'Created_Date\',\n	DATE_FORMAT(`Employee_Master`.`Modified_Date`,\'%d-%m-%Y %H:%i:%S\') AS \'Modified_Date\'\n	FROM `Employee_Master`\n	WHERE `Employee_Master`.`Is_Deleted` = \'0\';\nEND', NULL, 'SQL', 'SQL', 'NO', 'CONTAINS SQL', NULL, 'DEFINER', '2021-06-26 19:22:21', '2021-06-26 19:22:21', 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION', '', 'root@localhost', 'utf8mb4', 'utf8mb4_0900_ai_ci', 'utf8mb4_unicode_ci'
--------------
*/

SELECT CONCAT('SELECT ','PROCEDURE',' `','allpos_wposresl_db','`.`',ROUTINE_NAME,'`;') as stmt FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'allpos_wposresl_db' AND ROUTINE_TYPE = 'PROCEDURE';
/*
--------------
stmt
--------------
'SELECT PROCEDURE `allpos_wposresl_db`.`pr_cancel_Sale_Invoice`;'
'SELECT PROCEDURE `allpos_wposresl_db`.`pr_cancel_Sale_Order`;'
'SELECT PROCEDURE `allpos_wposresl_db`.`pr_change_login_password`;'
--------------
*/
-- ------------------------------------------------------------------
-- SQL Exception Handling
/*
DECLARE errno INT;
DECLARE errmsg TEXT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
BEGIN
	GET CURRENT DIAGNOSTICS CONDITION 1
	errno = MYSQL_ERRNO,  errmsg = MESSAGE_TEXT;
	ROLLBACK;  -- rollback any changes made in the transaction
    -- RESIGNAL SET MESSAGE_TEXT = 'An error has occurred, operation rollbacked and the stored procedure was terminated';
    -- SELECT CONCAT('{"Status":"Success","Message":"',errmsg,'","ErrorCode":"',errno,'"}') as Result;
    SELECT 'Fail' AS 'Status', errmsg AS 'Message', errno AS 'Error_Code';
END;
START TRANSACTION;
	-- 
COMMIT;
*/
-- ------------------------------------------------------------------------------------------------------
-- New Table Creation
/*
-- DROP TABLE IF EXISTS `Branch_Master`;
CREATE TABLE IF NOT EXISTS `Branch_Master` (
    `Branch_Master_Id` INT NOT NULL AUTO_INCREMENT,
    `Organization_Code` VARCHAR(10) NOT NULL,
    `Branch_Code` VARCHAR(30) NOT NULL,
    `Branch_Name` VARCHAR(100) NOT NULL,
    `GST_UID_Number` VARCHAR(30) NOT NULL,
    `Active_Status` VARCHAR(10) NOT NULL DEFAULT 'Active',
    `Is_Deleted` VARCHAR(1) NOT NULL DEFAULT '0',
    `Created_Date` DATETIME NULL DEFAULT NOW(),
    `Modified_Date` DATETIME NULL DEFAULT NULL ON UPDATE NOW(),
    PRIMARY KEY (`Branch_Master_Id`),
    CONSTRAINT `uk_Branch_Code` UNIQUE KEY (`Branch_Code`),
    CONSTRAINT `fk_Branch_Master-Organization_Code` FOREIGN KEY (`Organization_Code`)
        REFERENCES `Organization_Master` (`Organization_Code`)
        ON UPDATE CASCADE -- ON DELETE CASCADE ON UPDATE CASCADE
)  ENGINE=INNODB CHARSET=UTF8MB4 COLLATE = UTF8MB4_UNICODE_CI;
*/
-- ------------------------------------------------------------------------------------------------------
-- C# JSON Handling
/*
JObject json = JObject.Parse(ret_tracking_no);
if (json["status"] != null && json["status"].ToString() == "success")
{
	PrintLabel();
}
else
{
	if (json["message"] != null)
	{
		MessageBox.Show(json["message"].ToString(), "Error!", MessageBoxButtons.OK, MessageBoxIcon.Error);
	}
	else
	{
		MessageBox.Show("Something went wrong.", "Error!", MessageBoxButtons.OK, MessageBoxIcon.Error);
	}
}

JObject json = JObject.Parse(str_tmp_query);
if (json["status"] != null && json["status"].ToString() == "success")
{
	ClsControlStyles.DataAdded();
	MessageBox.Show(json["message"].ToString(), "Add Successful.", MessageBoxButtons.OK, MessageBoxIcon.Information);
	LoadDisplay();
}
else
{
	ClsControlStyles.DataInvalid();
	if (json["message"] != null)
	{
		MessageBox.Show(json["message"].ToString(), "Error!", MessageBoxButtons.OK, MessageBoxIcon.Error);
	}
	else
	{
		MessageBox.Show("Something went wrong.", "Error!", MessageBoxButtons.OK, MessageBoxIcon.Error);
	}
}
*/
-- ------------------------------------------------------------------------------------------------------

-- C# JSON Handling
/*
JObject jObject = ClsUtility.DataTableToJObject(dt);
            if (jObject["Organization_Name"] != null)
            {
                TbOrganizationName.Text = jObject["Organization_Name"]?.ToString();
                TbContactNumber.Text = jObject["Contact_Number"]?.ToString();
                TbEmail.Text = jObject["Email"]?.ToString();
                TbWebsite.Text = jObject["Website"]?.ToString();
                TbRemarks.Text = jObject["Remarks"]?.ToString();
                if (jObject["Active_Status"].ToString().Equals("Active", StringComparison.OrdinalIgnoreCase))
                {
                    RbtnActive.Checked = true;
                }
                else
                {
                    RbtnInactive.Checked = true;
                }
                if (jObject["Organization_Image"]?.ToString() == "")
                {
                    PicBoxOrganization.Image = WinFrmApp.Properties.Resources.organization;
                }
                else
                {
                    PicBoxOrganization.Image = ClsUtility.Base64ToImage(jObject["Organization_Image"]?.ToString());
                    ImageBase64String = jObject["Organization_Image"]?.ToString();
                }
            }
            else
            {
                MessageBox.Show("Record Not Found.", "Unknown!", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
*/
-- ------------------------------------------------------------------------------------------------------

-- Store Procedure Example
/*
DROP PROCEDURE IF EXISTS `pr_read_Employee_Master`;
DELIMITER $$
CREATE PROCEDURE `pr_read_Employee_Master` 
(
IN `Organization_Code` VARCHAR(10)
)
BEGIN
SELECT * FROM `Employee_Master` WHERE `Employee_Master`.`Organization_Code` = `Organization_Code`;
END$$
DELIMITER ;
-- CALL `pr_read_Employee_Master`('OC20001');
*/
-- ------------------------------------------------------------------------------------------------------

-- Function Example
/*
DROP FUNCTION IF EXISTS `fn_DateFormat`;
DELIMITER $$
CREATE FUNCTION `fn_DateFormat` 
(
`DateTime` DATETIME
)
RETURNS VARCHAR(25) DETERMINISTIC
BEGIN
DECLARE Ret_DateTime VARCHAR(25) DEFAULT '';
-- SET Ret_DateTime = (SELECT DATE_FORMAT(`DateTime`,'%d-%m-%Y %H:%i:%s') AS 'Date_Time');
RETURN DATE_FORMAT(`DateTime`,'%d-%m-%Y %H:%i:%s');
RETURN Ret_DateTime;
END$$
DELIMITER ;
-- SELECT `fn_DateFormat`('2020-02-01 23:05:00');
*/
-- ------------------------------------------------------------------------------------------------------
-- Trigger Example
/*
DROP TRIGGER IF EXISTS downloads_BI;
DELIMITER //
CREATE TRIGGER downloads_BI
BEFORE INSERT ON downloads FOR EACH ROW
BEGIN
    IF (NEW.date IS NULL) THEN -- change the isnull check for the default used
        SET NEW.date = now();
    END IF;
END//
DELIMITER ;
*/
-- ------------------------------------------------------------------------------------------------------
