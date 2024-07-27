---we have this table
SELECT *
FROM EMPLOYEE_DB.PUBLIC.EMPLOYEES;

--accidentally update a column without using the filter WHERE
-- then all of the names will be juan
UPDATE EMPLOYEE_DB.PUBLIC.EMPLOYEES
SET FIRST_NAME = 'Juan';

----TIME TRAVEL .. GOING 10 MINUTES BACK
SELECT *
FROM EMPLOYEE_DB.PUBLIC.EMPLOYEES AT (OFFSET => -60*10); 

---TIME TRAVEL -- TIMESTAMP
SELECT *
FROM EMPLOYEE_DB.PUBLIC.EMPLOYEES BEFORE (timestamp => '2024-07-27 2:30:00.32'::timestamp);

----TIME TRAVEL -- QUERY_ID
SELECT *
FROM EMPLOYEE_DB.PUBLIC.EMPLOYEES BEFORE (STATEMENT => '01b5f4a3-0306-bf69-0006-d47700054f72');

---------------------------------------------------------------------------------------
------------------RECOVER DATA USING TIME TRAVEL---------------------------------------
---------------------------------------------------------------------------------------
CREATE OR REPLACE TEMP TABLE EMPLOYEE_DB.PUBLIC.back_up_employee AS 
    SELECT *
    FROM EMPLOYEE_DB.PUBLIC.EMPLOYEES BEFORE (STATEMENT => '01b5f4a3-0306-bf69-0006-d47700054f72');

SELECT *
FROM EMPLOYEE_DB.PUBLIC.back_up_employee;

--truncate table on which we updated wrong
TRUNCATE EMPLOYEE_DB.PUBLIC.EMPLOYEES;

--insert into table from temp back up table
INSERT INTO EMPLOYEE_DB.PUBLIC.EMPLOYEES
SELECT * FROM EMPLOYEE_DB.PUBLIC.back_up_employee;



SELECT * FROM EMPLOYEE_DB.PUBLIC.EMPLOYEES;


--drop temp table
DROP TABLE EMPLOYEE_DB.PUBLIC.back_up_employee;

--------------------------------------------------------------------------------------------
--------------------------UNDROP OBJECTS ---------------------------------------------------
--------------------------------------------------------------------------------------------

DROP TABLE EMPLOYEE_DB.PUBLIC.EMPLOYEES;

UNDROP TABLE EMPLOYEE_DB.PUBLIC.EMPLOYEES;



