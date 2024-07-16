--create the stage
CREATE OR REPLACE STAGE MANAGE_BD.EXTERNAL_STAGES.jsonStage
    url = 's3://bucketsnowflake-jsondemo';

--create the table
CREATE OR REPLACE TABLE ORDERS_DB.PUBLIC.JSON_RAW(

    raw_file VARIANT
 
);

--copy into the table
COPY INTO ORDERS_DB.PUBLIC.JSON_RAW
    FROM @MANAGE_BD.EXTERNAL_STAGES.jsonStage 
    file_format = (type='json')
    files = ('HR_data.json');

--check the data
SELECT *
FROM ORDERS_DB.PUBLIC.JSON_RAW;

----PARSING THE DATA
--with the help of our only column, we select the date

--selection attribute/column 
SELECT RAW_FILE:city FROM ORDERS_DB.PUBLIC.JSON_RAW; 

--selection attribute/column - formatted
SELECT 
    RAW_FILE:id::int as id,
    RAW_FILE:first_name::string as first_name,
    RAW_FILE:last_name::string as last_name,
    RAW_FILE:gender::string as gender
FROM ORDERS_DB.PUBLIC.JSON_RAW;


--nested data
-- with the (.) I can access nested information

SELECT 
    RAW_FILE:first_name::STRING as first_name,
    RAW_FILE:job.salary::int as salary,
    RAW_FILE:job.title::string as title
FROM ORDERS_DB.PUBLIC.JSON_RAW; 

--arrays with in nested data
SELECT
    RAW_FILE:first_name::STRING as first_name,
    array_size(RAW_FILE:spoken_languages)::int as number_of_languages,
    RAW_FILE:spoken_languages  as spoken_languages
FROM ORDERS_DB.PUBLIC.JSON_RAW;



