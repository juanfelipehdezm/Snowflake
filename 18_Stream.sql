--- 
CREATE OR REPLACE DATABASE STREAMS_DB;

USE DATABASE STREAMS_DB;
USE SCHEMA PUBLIC;
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;


--- TABLEs------------------------------
CREATE OR REPLACE TABLE Sales_raw_staging(

    id integer, 
    product string,
    price float,
    amount integer,
    store_id integer
);
--insert values
INSERT INTO sales_raw_staging
    VALUES
    (1, 'Banana', 1.99,1,1),
    (2, 'Lemon', 0.99,1,1),
    (3, 'Apple', 1.79,1,2),
    (4, 'Orange Juice', 1.89,1,2),
    (5, 'Cereals', 4.99,2,1);

--store table
CREATE OR REPLACE TABLE STORE_TABLE(

    store_id integer,
    location string, 
    eployees integer

);

INSERT INTO store_table
    VALUES
    (1,'Chicago',33),
    (2,'London',12);


--final table
CREATE OR REPLACE TABLE sales_final_table(

    id integer, 
    product string,
    price float,
    amount integer,
    store_id integer,
    location string, 
    eployees integer

);


--insert into final table
INSERT INTO sales_final_table
    SELECT 
        ss.id,
        ss.product,
        ss.price,
        ss.amount,
        st.store_id,
        st.location,
        st.eployees
    FROM sales_raw_staging AS ss
    INNER JOIN store_table AS st
    ON ss.store_id = st.store_id;


SELECT * FROM sales_final_table;

-----create stream object .-------
--- as the staging is the one changing we are gg create it on top of it---

CREATE OR REPLACE STREAM sales_stream ON TABLE sales_raw_staging;

DESC STREAM sales_stream;

-- AS IT is new, nothing should be inside the stream
SELECT * FROM sales_stream;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
----------------------------INSERT ...----------------------------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------


--inserting new data
INSERT INTO sales_raw_staging
    VALUES
    (6,'Mango',1.99,1,2),
    (7,'Garlic',0.99,1,1);

-- see changes on the stream

SELECT * FROM sales_stream;


--consume the stream object instead of using the source data
INSERT INTO sales_final_table
    SELECT 
        ss.id,
        ss.product,
        ss.price,
        ss.amount,
        st.store_id,
        st.location,
        st.eployees
    FROM sales_stream AS ss
    INNER JOIN store_table AS st
    ON ss.store_id = st.store_id;

---now is empty the stream
SELECT * FROM sales_final_table;
SELECT * FROM sales_stream;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
----------------------------UPDATE ...----------------------------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
UPDATE sales_raw_staging
SET PRODUCT ='Potato' WHERE PRODUCT = 'Banana';

MERGE INTO sales_final_table as sf
USING sales_stream as ss
 ON sf.id = ss.id
WHEN matched
    AND ss.METADATA$ACTION = 'INSERT'
    AND ss.METADATA$ISUPDATE = 'TRUE'
    THEN UPDATE
    SET sf.product = ss.product,
        sf.price = ss.price,
        sf.amount = ss.amount,
        sf.store_id = ss.store_id;


SELECT * FROM sales_final_table;
SELECT * FROM sales_stream;

----parameters and retention time

show parameters in table sales_raw_staging;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
----------------------------DELETE ...----------------------------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
DELETE FROM sales_raw_staging
WHERE PRODUCT = 'Lemon';

--CHECK stream
SELECT * FROM sales_stream;

--deleting
DELETE FROM sales_final_table
WHERE id = (SELECT ID FROM sales_stream
            WHERE METADATA$ACTION = 'DELETE'
            AND METADATA$ISUPDATE = 'FALSE');

SELECT * FROM sales_final_table;


