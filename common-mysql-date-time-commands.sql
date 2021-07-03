-- ------------------------------------------------------------------
-- Common MySQL Date & Time commands
-- ------------------------------------------------------------------
SELECT DATE_ADD('2020-03-30', INTERVAL -1 MONTH) AS 'New_Date';
/*
--------------
New_Date
--------------
'2020-02-29'
--------------
*/
-- ------------------------------------------------------------------
-- DATE_FORMAT(`Main_Master`.`Created_Date`,'%d-%m-%Y %H:%i:%s') AS 'Created_Date';
SELECT DATE_FORMAT(NOW(),'%d-%m-%Y %H:%i:%s') AS 'Created_Date';
/*
--------------
Created_Date
--------------
'03-07-2021 22:18:15'
--------------
*/
-- ------------------------------------------------------------------
SELECT NOW();

SELECT @@GLOBAL.time_zone, @@SESSION.time_zone;
-- ------------------------------------------------------------------
DROP FUNCTION IF EXISTS `fn_GetDateTime`;
DELIMITER $$
CREATE FUNCTION `fn_GetDateTime` 
(
`ToTimeZone` VARCHAR(10)
)
RETURNS DATETIME DETERMINISTIC
BEGIN
DECLARE Ret_DateTime DATETIME DEFAULT NOW();
-- CONVERT_TZ (dt, from_tz,to_tz)
-- SELECT CONVERT_TZ(NOW(),'+05:30',ToTimeZone);
SET Ret_DateTime = (SELECT CONVERT_TZ(NOW(),@@GLOBAL.time_zone,ToTimeZone));
RETURN Ret_DateTime;
END$$
DELIMITER ;
-- SELECT `fn_GetDateTime`('+05:00');
-- ------------------------------------------------------------------
-- Timing Calculations
/*
SELECT  CONCAT( ((TIMESTAMPDIFF(SECOND,'2000-01-01 5:10:10','2001-02-01 10:10:10')) DIV 86400 ) , ' Day '
        , ( ( (TIMESTAMPDIFF(SECOND,'2000-01-01 5:10:10','2001-02-01 10:10:10')) MOD 86400 ) DIV 3600 ) , ' Hr '
        , ( ( ( (TIMESTAMPDIFF(SECOND,'2000-01-01 5:10:10','2001-02-01 10:10:10')) MOD 86400 ) MOD 3600 ) DIV 60 ), ' Min ' 
        , ( ( ( (TIMESTAMPDIFF(SECOND,'2000-01-01 5:10:10','2001-02-01 10:10:10')) MOD 86400 ) MOD 3600 ) MOD 60 ), ' Sec'
        ) as Time_Difference;

CONCAT((SUM(((TIMESTAMPDIFF(DAY,'2019-12-30','2019-12-30') + 1)*1440)-(TIMESTAMPDIFF(MINUTE,`Assembly_Empty_List`.`Assembly_Filled_Time`,`Assembly_Empty_List`.`Assembly_Empty_Time`))) DIV 60),' Hr : ', SUM(((TIMESTAMPDIFF(DAY,'2019-12-30','2019-12-30') + 1)*1440)-(TIMESTAMPDIFF(MINUTE,`Assembly_Empty_List`.`Assembly_Filled_Time`,`Assembly_Empty_List`.`Assembly_Empty_Time`))) MOD 60,' Min') as 'Empty_Duration'

CONCAT((
(
((TIMESTAMPDIFF(DAY,'2019-12-30','2019-12-30') + 1)*1440)-
(SUM(TIMESTAMPDIFF(MINUTE,`Assembly_Empty_List`.`Assembly_Filled_Time`,`Assembly_Empty_List`.`Assembly_Empty_Time`)))
) DIV 60),' Hr : ',
(
(
((TIMESTAMPDIFF(DAY,'2019-12-30','2019-12-30') + 1)*1440)-
SUM(TIMESTAMPDIFF(MINUTE,`Assembly_Empty_List`.`Assembly_Filled_Time`,`Assembly_Empty_List`.`Assembly_Empty_Time`))
) MOD 60,' Min')) as 'Empty_Duration'

(TIMESTAMPDIFF(MINUTE,FromDate,ToDate))-(TIMESTAMPDIFF(MINUTE,`Assembly_Empty_List`.`Assembly_Filled_Time`,`Assembly_Empty_List`.`Assembly_Empty_Time`))
*/
-- ------------------------------------------------------------------
-- Alldate between two date
/*
CREATE DEFINER=`root`@`localhost` PROCEDURE `pr_generate_custom_qc_reason_report`(
IN FromDate DATE,
IN ToDate DATE,
IN QC_Status varchar(10),
IN QC_Reason varchar(100)
)
BEGIN
DROP TEMPORARY TABLE IF EXISTS finaltable;
    IF(QC_Status='Pass') THEN
		CREATE TEMPORARY TABLE finaltable
		(SELECT  DATE(qc_zone.Scan_DateTime) as QC_Date , COUNT(qc_zone.QC_Zone_Id) as Qty
		FROM qc_zone WHERE DATE(qc_zone.Scan_DateTime) BETWEEN FromDate AND ToDate
		AND qc_zone.QC_Status = QC_Status GROUP BY QC_Date) union all
		(select * from (select adddate(FromDate,t4*10000 + t3*1000 + t2*100 + t1*10 + t0) QC_Date,  '0' as Qty from
		 (select 0 t0 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t0,
		 (select 0 t1 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t1,
		 (select 0 t2 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t2,
		 (select 0 t3 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t3,
		 (select 0 t4 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t4) v
		where QC_Date between FromDate AND ToDate GROUP BY QC_Date);
        -- select QC_Date, sum(Qty) as Qty from finaltable GROUP BY QC_Date;
        select DATE_FORMAT(QC_Date,'%d-%m-%Y') as 'QC_Date', sum(Qty) as Qty from finaltable GROUP BY QC_Date;
    ELSE
		CREATE TEMPORARY TABLE finaltable
		(SELECT  DATE(qc_zone.Scan_DateTime) as QC_Date , COUNT(qc_zone.QC_Zone_Id) as Qty
		FROM qc_zone WHERE DATE(qc_zone.Scan_DateTime) BETWEEN FromDate AND ToDate
		AND qc_zone.QC_Status = 'Rework' AND qc_zone.Rework_Reject_Reason LIKE CONCAT('%',QC_Reason,'%') GROUP BY QC_Date) union all
		(select * from (select adddate(FromDate,t4*10000 + t3*1000 + t2*100 + t1*10 + t0) QC_Date,  '0' as Qty from
		 (select 0 t0 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t0,
		 (select 0 t1 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t1,
		 (select 0 t2 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t2,
		 (select 0 t3 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t3,
		 (select 0 t4 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t4) v
		where QC_Date between FromDate AND ToDate GROUP BY QC_Date);
        -- select QC_Date, sum(Qty) as Qty from finaltable GROUP BY QC_Date;
        select DATE_FORMAT(QC_Date,'%d-%m-%Y') as 'QC_Date', sum(Qty) as Qty from finaltable GROUP BY QC_Date;
    END IF;
END
*/
-- ------------------------------------------------------------------
