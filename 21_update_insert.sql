USE ROLE ACCOUNTADMIN; 
USE WAREHOUSE COMPUTE_WH;
USE DATABASE CERTIFICATION_TEST_DB;
USE SCHEMA TEST;

--refreesh the table
CREATE OR REPLACE TABLE ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
);

--inserting a sigle record
INSERT INTO ORDERS
VALUES (1,0,0,0,'None','None');


SELECT * FROM ORDERS;

--multiple records
INSERT INTO ORDERS
VALUES 
(2,12,4,1, 'Garden','Flowers'),
(3,15,6,2, 'House','Kitchen'),
(4,11,2,1, 'House','Sleeping');


--INSERT OVEWRITE - it truncates the table first and then put the records
INSERT OVERWRITE INTO ORDERS (ORDER_ID, SUBCATEGORY)
VALUES 
(20,'Flowers'),
(30,'Kitchen'),
(40,'Sleeping');


--UPDATE a record
UPDATE ORDERS
SET ORDER_ID = 1
WHERE ORDER_ID = 20;

