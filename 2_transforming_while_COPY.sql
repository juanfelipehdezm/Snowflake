--table with few transformations, using CAST and SUBSTRING as sql functions

CREATE OR REPLACE TABLE ORDERS_DB.PUBLIC.ORDERS_TRANSFORMED(

    ID NUMBER AUTOINCREMENT START 1 INCREMENT 1,
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    PROFITABLE_FLAG VARCHAR(30),
    CATEGORY_SUBSTRING VARCHAR(10)
    
);

-- COPYing and transforming
-- the s.$1 is to simply point to the first columns and so on
-- we can skip the columns from which we do not want to insert data in the COPY command
COPY INTO ORDERS_DB.PUBLIC.ORDERS_TRANSFORMED (ORDER_ID,AMOUNT,PROFIT,PROFITABLE_FLAG,CATEGORY_SUBSTRING)
    FROM (SELECt s.$1,
                 s.$2,
                 s.$3,
                 CASE WHEN CAST(s.$3 as int) <0 THEN 'not profitable'
                      ELSE 'profitable' END,
                 SUBSTRING(s.$5,1,5)
          FROM @MANAGE_BD.EXTERNAL_STAGES.AWS_ATAGE as s
    )
    file_format = (type = csv field_delimiter=',' skip_header=1)
    files= ('OrderDetails.csv');

    
SELECT *
FROM ORDERS_DB.PUBLIC.ORDERS_TRANSFORMED;



