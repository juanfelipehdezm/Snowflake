
USE ROLE ACCOUNTADMIN; 
USE WAREHOUSE COMPUTE_WH;
USE DATABASE CERTIFICATION_TEST_DB;
USE SCHEMA TEST;

SELECT * 
FROM ORDERS;

--create secure  view
CREATE OR REPLACE SECURE VIEW ORDERS_VIEW_SECURE AS
  SELECT order_id, amount, subcategory
  FROM ORDERS
  WHERE subcategory = 'Flowers';


SELECT *
FROM ORDERS_VIEW_SECURE;


--create share
CREATE OR REPLACE SHARE ORDERS_SHARE;

--GRANT USAGE ON DATABASE
GRANT USAGE ON DATABASE CERTIFICATION_TEST_DB TO SHARE ORDERS_SHARE;

-- Grant usage on shcema
GRANT USAGE ON SCHEMA CERTIFICATION_TEST_DB.TEST TO SHARE ORDERS_SHARE;

-- Grant select on view
GRANT SELECT ON VIEW CERTIFICATION_TEST_DB.TEST.ORDERS_VIEW_SECURE TO SHARE ORDERS_SHARE;


---VALIDATE GRANTS
SHOW GRANTS TO SHARE ORDERS_SHARE;



--- create reader account ( on same region and cloud privider)
CREATE MANAGED ACCOUNT reader_account
ADMIN_NAME = read_acc_admin
ADMIN_PASSWORD = 'pebn3##ndndS'
TYPE = READER;

SHOW MANAGED ACCOUNTS; --https:--tmb68774.us-east-1.snowflakecomputing.com


---share data
ALTER SHARE ORDERS_SHARE
ADD ACCOUNT = tmb69774;


SHOW SHARES;


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
----- FROM CONSUMERS ACCOUNT with account admin role ------------------------------------------------
----------------------------------------------------------------------------

DESC SHARE <consumer_account>.ORDERS_SHARE;

-- Create a database in consumer account using the share
CREATE DATABASE DATA_SHARE_DB FROM SHARE <account_producer>.ORDERS_SHARE;

-- Validate table access
SELECT * FROM  DATA_SHARE_DB.PUBLIC.ORDERS;


-- Setup virtual warehouse
CREATE WAREHOUSE READ_WH WITH
WAREHOUSE_SIZE='X-SMALL'
AUTO_SUSPEND = 180
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE;



---- STEP 5: Grant privileges optionally

-- Create and set up users --

-- Create user
CREATE USER MYRIAM PASSWORD = 'difficult_passw@ord=123';

-- Grant usage on warehouse
GRANT USAGE ON WAREHOUSE READ_WH TO ROLE PUBLIC;


-- Grating privileges on a Shared Database for other users
GRANT IMPORTED PRIVILEGES ON DATABASE DATA_SHARE_DB TO REOLE PUBLIC;



