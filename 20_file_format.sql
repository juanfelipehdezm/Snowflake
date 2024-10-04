USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE CERTIFICATION_TEST_DB;
USE SCHEMA TEST;

DESC STAGE AWS_STAGE;

--creating a file format object
CREATE OR REPLACE FILE FORMAT csv_file_format
  TYPE = CSV
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1;

--properties of file formatobject 
DESC FILE FORMAT csv_file_format;

--using file format on the stage
CREATE OR REPLACE STAGE AWS_STAGE
    URL = 's3://bucketsnowflakes3'
    FILE_FORMAT = (FORMAT_NAME = csv_file_format);

--
CREATE OR REPLACE TABLE ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
);
--loadinng data but the file_format already is being set on the stage
COPY INTO ORDERS
    FROM @AWS_STAGE
     files = ('OrderDetails.csv');
