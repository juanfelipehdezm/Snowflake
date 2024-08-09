USE DATABASE STREAMS_DB;
USE SCHEMA PUBLIC;
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;

--automate the changes using tasks

CREATE OR REPLACE TASK all_data_changes
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = '1 MINUTE'
    WHEN SYSTEM$STREAM_HAS_DATA('SALES_STREAM')
    AS
        MERGE INTO SALES_FINAL_TABLE AS F
        USING (
            SELECT SS.*,ST.LOCATION,ST.EPLOYEES
            FROM SALES_STREAM AS SS
            INNER JOIN STORE_TABLE AS ST
            ON SS.STORE_ID = ST.STORE_ID
        ) AS S
        ON F.ID = S.ID
        WHEN MATCHED --delete
            AND S.METADATA$ACTION ='DELETE'
            AND S.METADATA$ISUPDATE = 'FALSE'
        THEN DELETE
        WHEN MATCHED --Update
            AND S.METADATA$ACTION ='INSERT' 
            and S.METADATA$ISUPDATE  = 'TRUE'  
        THEN UPDATE
                SET F.PRODUCT = S.PRODUCT,
                    F.PRICE = S.PRICE,
                    F.AMOUNT = F.AMOUNT,
                    F.STORE_ID = F.STORE_ID
        WHEN NOT MATCHED --INSERT
            AND S.METADATA$ACTION ='INSERT'
            THEN INSERT (id,product,price,store_id,amount,EPLOYEES,location)
                 VALUES (s.id, s.product,s.price,s.store_id,s.amount,s.EPLOYEES,s.location);


--RESUME THE TASK

ALTER TASK all_data_changes RESUME;
SHOW TASKS;

--INSERTO NEW DATA
INSERT INTO SALES_RAW_STAGING VALUES (11,'Milk',1.99,1,2);
INSERT INTO SALES_RAW_STAGING VALUES (12,'Chocolate',4.49,1,2);
INSERT INTO SALES_RAW_STAGING VALUES (13,'Cheese',3.89,1,1);

--update data
UPDATE SALES_RAW_STAGING
SET PRODUCT = 'Chocolate bar'
WHERE PRODUCT ='Chocolate';

--delete data

DELETE FROM SALES_RAW_STAGING
WHERE PRODUCT = 'Mango';  


SELECT * FROM SALES_STREAM;

select *
from table(information_schema.task_history())
order by name asc,scheduled_time desc;

SELECT * FROM sales_final_table;



ALTER TASK all_data_changes SUSPEND;