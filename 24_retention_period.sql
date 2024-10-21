
USE ROLE ACCOUNTADMIN; 
USE WAREHOUSE COMPUTE_WH;
USE DATABASE CERTIFICATION_TEST_DB;
USE SCHEMA TEST;

SHOW TABLES LIKE '%ORDERS%';

--change retention period
ALTER TABLE ORDERS
SET data_retention_time_in_days = 2;

--we can define the retention time on the table definition

CREATE OR REPLACE TABLE CUSTOMERS(

    ID int,
    first_name string, 
    lasta_name string,
    email string, 
    gender string,
    job string,
    phone string
) data_retention_time_in_days = 3;
--
--check the retention period
SHOW TABLES LIKE '%CUSTOMERS%';



---set the retention period at the account level
ALTER ACCOUNT SET data_retention_time_in_days = 10;
