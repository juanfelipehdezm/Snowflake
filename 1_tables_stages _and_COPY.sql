-- Database to manage stage objects, file formats, etc.
CREATE OR REPLACE DATABASE MANAGE_BD;

CREATE OR REPLACE SCHEMA external_stages;

--creating external stage
CREATE OR REPLACE STAGE MANAGE_BD.external_stages.aws_atage
    url='s3:--bucketsnowflakes3'
    credentials = (aws_key_id='ABCD_DUMMY_ID' aws_secret_key='1234abcd_key');

--description of the external stage
DESC STAGE MANAGE_BD.EXTERNAL_STAGES.AWS_ATAGE;

--we can alter stages.
ALTER STAGE MANAGE_BD.EXTERNAL_STAGES.AWS_ATAGE
    SET credentials = (aws_key_id='XYZ_DUMMY_ID' aws_secret_key='987xyz');


--list files in stage
LIST @MANAGE_BD.EXTERNAL_STAGES.AWS_ATAGE;


--let's create a table to load the data from the stage we just created
CREATE OR REPLACE DATABASE ORDERS_DB;

CREATE OR REPLACE TABLE ORDERS_DB.PUBLIC.ORDERS(
    ORDER_ID VARCHAR(30),
    AMOUNT_ID INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)

);

SELECT *
FROM ORDERS_DB.PUBLIC.ORDERS;

--copy command from the stage we created
COPY INTO ORDERS_DB.PUBLIC.ORDERS
    FROM @MANAGE_BD.EXTERNAL_STAGES.AWS_ATAGE
    file_format = (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails.csv');



 -- Copy command with pattern for file names

 COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
     FROM @MANAGE_DB.external_stages.aws_stage
     file_format = (type = csv field_delimiter=',' skip_header=1)
     pattern = '.*Order.*';