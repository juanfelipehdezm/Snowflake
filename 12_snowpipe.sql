--NEW DATABASE
CREATE OR REPLACE DATABASE EMPLOYEE_DB;

--TABLE
-- Create table first
CREATE OR REPLACE TABLE EMPLOYEE_DB.PUBLIC.employees (
  id INT,
  first_name STRING,
  last_name STRING,
  email STRING,
  location STRING,
  department STRING
);

--stage object
--enable = true --Specifies whether Snowflake should enable triggering automatic refreshes of the directory table metadata when new or updated data files are available in the named external stage specified in the URL value.
-- aws_sns_topic = 'arn:----' tell the stage which sns to get the notifications
CREATE OR REPLACE STAGE MANAGE_BD.EXTERNAL_STAGES.SNOW_PIPE_S3
    URL = 's3://snow-flake-demoproject/snowpipe/'
    STORAGE_INTEGRATION = S3_AWS
    FILE_FORMAT = MANAGE_BD.FILE_FORMAT.CSV_FILEFORMAT
    DIRECTORY = (
        ENABLE = true
        AUTO_REFRESH = true 
        AWS_SNS_TOPIC = 'arn:aws:sns:us-east-1:083527689950:snowpipe_topic'
    );

SELECT * FROM directory(@MANAGE_BD.EXTERNAL_STAGES.SNOW_PIPE_S3);

LIST @MANAGE_BD.EXTERNAL_STAGES.SNOW_PIPE_S3;


--policy for sns 
select system$get_aws_sns_iam_policy('arn:aws:sns:us-east-1:083527689950:snowpipe_topic');



-- Define pipe with sns
CREATE OR REPLACE pipe EMPLOYEE_DB.PUBLIC.employee_pipe
auto_ingest = TRUE
AWS_SNS_TOPIC = 'arn:aws:sns:us-east-1:083527689950:snowpipe_topic'
    AS
    COPY INTO EMPLOYEE_DB.PUBLIC.employees
    FROM @MANAGE_BD.EXTERNAL_STAGES.SNOW_PIPE_S3;

-- describe the pipe
DESC pipe employee_pipe;


--see results
SELECT COUNT(*) FROM EMPLOYEE_DB.PUBLIC.employees;


--validate pipe is actually working
SELECT SYSTEM$PIPE_STATUS('EMPLOYEE_DB.PUBLIC.employee_pipe');

---error messages from the snowpipe
SELECT * 
FROM TABLE (VALIDATE_PIPE_LOAD(
    PIPE_NAME => 'EMPLOYEE_DB.PUBLIC.employee_pipe',
    START_TIME => DATEADD(HOUR,-24, CURRENT_TIMESTAMP())
));


--history from the copy command using on the table
SELECT *
FROM TABLE (INFORMATION_SCHEMA.COPY_HISTORY(
    TABLE_NAME => 'EMPLOYEE_DB.PUBLIC.employees',
    START_TIME => DATEADD(HOUR,-24, CURRENT_TIMESTAMP())

));

