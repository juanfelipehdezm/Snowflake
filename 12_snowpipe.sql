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
CREATE OR REPLACE STAGE MANAGE_BD.EXTERNAL_STAGES.SNOW_PIPE_S3
    URL = 's3://snow-flake-demoproject/snowpipe/'
    STORAGE_INTEGRATION = S3_AWS
    FILE_FORMAT = MANAGE_BD.FILE_FORMAT.CSV_FILEFORMAT;

LIST @MANAGE_BD.EXTERNAL_STAGES.SNOW_PIPE_S3;


-- Define pipe
CREATE OR REPLACE pipe EMPLOYEE_DB.PUBLIC.employee_pipe
auto_ingest = TRUE
    AS
    COPY INTO EMPLOYEE_DB.PUBLIC.employees
    FROM @MANAGE_BD.EXTERNAL_STAGES.SNOW_PIPE_S3;

--Describe pipe as the result of this, we will use the notification_channel to allow evento notifitacions from s3 to snowflake
DESC pipe employee_pipe;


--see results
SELECT COUNT(*) FROM EMPLOYEE_DB.PUBLIC.employees;