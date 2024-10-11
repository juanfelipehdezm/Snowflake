USE ROLE ACCOUNTADMIN; 
USE WAREHOUSE COMPUTE_WH;
USE DATABASE CERTIFICATION_TEST_DB;
USE SCHEMA TEST;

CREATE OR REPLACE PROCEDURE update_table(new_value int, table_name varchar)
returns varchar
language sql
as
  BEGIN 
    UPDATE IDENTIFIER(:table_name) --IDENTIFIER() is to refer an objedt
    SET AMOUNT = :new_value
    WHERE ORDER_ID = 1;

    RETURN 'Succesfullt updated table';

  END;

CALL update_table(20, 'ORDERS');

SELECT * FROM ORDERS;