CREATE OR REPLACE TABLE ORDERS_DB.PUBLIC.ORDERS_COPY_OPTIONS(
    ORDER_ID VARCHAR(30),
    AMOUNT VARCHAR(30),
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
);

CREATE OR REPLACE STAGE MANAGE_BD.EXTERNAL_STAGES.aws_atage_copy_options
    url = 's3://snowflakebucket-copyoption/returnfailed/';
------------------------------------------------------------------------
--VALIDATION MODE
-- return_errors = will provide the errors in find on the files
-- return_n_rows = will validate the first n rows

COPY INTO ORDERS_DB.PUBLIC.ORDERS_COPY_OPTIONS
    FROM @MANAGE_BD.EXTERNAL_STAGES.aws_atage_copy_options
    file_format = (type=csv field_delimiter=',' skip_header=1)
    pattern= '.*Order.*'
    VALIDATION_MODE = return_errors;

COPY INTO ORDERS_DB.PUBLIC.ORDERS_COPY_OPTIONS
    FROM @MANAGE_BD.EXTERNAL_STAGES.aws_atage_copy_options
    file_format = (type=csv field_delimiter=',' skip_header=1)
    pattern= '.*Order.*'
    VALIDATION_MODE = return_20_rows;
-------------------------------------------------------------------------
--SIZE_LIMIT
CREATE OR REPLACE STAGE MANAGE_BD.EXTERNAL_STAGES.aws_atage_copy_options
    url = 's3://snowflakebucket-copyoption/size/';

--the size of the file are 54600 bytes each
--the size we choose means all of the files combines.
COPY INTO ORDERS_DB.PUBLIC.ORDERS_COPY_OPTIONS
    FROM @MANAGE_BD.EXTERNAL_STAGES.aws_atage_copy_options
    file_format = (type = csv field_delimiter = ',' skip_header = 1)
    pattern = '.*Order.*'
    SIZE_LIMIT = 20000;