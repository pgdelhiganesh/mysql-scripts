-- ------------------------------------------------------------------
-- Common MySQL Error & Solutions
-- ------------------------------------------------------------------
-- 1. Error occured while restoring large backup files ?
select @@max_allowed_packet;
set global max_allowed_packet=104857600;
-- set global max_allowed_packet=1*1024*1024*1024;
-- ------------------------------------------------------------------
-- 2. Need to overcome the default(1024 characters) string length if group_concat command ?
select @@group_concat_max_len;
set session group_concat_max_len=10000;
-- ------------------------------------------------------------------
-- 3. Enable/Disable MySQL Safe Update Command
SELECT @@sql_safe_updates;
SET SQL_SAFE_UPDATES = 0; -- To Disable
SET SQL_SAFE_UPDATES = 1; -- To Enable
-- ------------------------------------------------------------------
