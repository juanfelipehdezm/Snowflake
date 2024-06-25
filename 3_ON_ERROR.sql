-- Create new stage
 CREATE OR REPLACE STAGE MANAGE_BD.external_stages.aws_stage_errorex
    url='s3:--bucketsnowflakes4';
 
 -- List files in stage
 LIST @MANAGE_BD.external_stages.aws_stage_errorex;
 
 
 -- Create example table
 CREATE OR REPLACE TABLE ORDERS_DB.PUBLIC.ORDERS_ERRORS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));
 
 -- Demonstrating error message
COPY INTO ORDERS_DB.PUBLIC.ORDERS_ERRORS
    FROM @MANAGE_BD.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv');
    
    

  -- Error handling using the ON_ERROR option
  -- CONTINUE will skip the rows where the error is present and load the othersones
COPY INTO ORDERS_DB.PUBLIC.ORDERS_ERRORS
    FROM @MANAGE_BD.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'CONTINUE';
    
  -- Validating results and truncating table 
SELECT * FROM ORDERS_DB.PUBLIC.ORDERS_ERRORS;

TRUNCATE TABLE ORDERS_DB.PUBLIC.ORDERS_ERRORS;

-- Error handling using the ON_ERROR option = ABORT_STATEMENT (default)
COPY INTO ORDERS_DB.PUBLIC.ORDERS_ERRORS
    FROM MANAGE_BD.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv','OrderDetails_error2.csv')
    ON_ERROR = 'ABORT_STATEMENT';


  -- Validating results and truncating table 
SELECT * FROM ORDERS_DB.PUBLIC.ORDERS_ERRORS;

TRUNCATE TABLE ORDERS_DB.PUBLIC.ORDERS_ERRORS;

-- Error handling using the ON_ERROR option = SKIP_FILE
-- SKIP_FILE will load only the file where NOT error is found
COPY INTO ORDERS_DB.PUBLIC.ORDERS_ERRORS
    FROM @MANAGE_BD.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv','OrderDetails_error2.csv')
    ON_ERROR = 'SKIP_FILE';
    
    
  -- Validating results and truncating table 
SELECT * FROM ORDERS_DB.PUBLIC.ORDERS_ERRORS;

TRUNCATE TABLE ORDERS_DB.PUBLIC.ORDERS_ERRORS;    


