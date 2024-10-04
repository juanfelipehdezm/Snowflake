USE ROLE ACCOUNTADMIN; 
USE WAREHOUSE COMPUTE_WH;
USE DATABASE CERTIFICATION_TEST_DB;
USE SCHEMA TEST;

--
-- before creating we must first create a role on s3 and grant permission to s3 bucket
-- and use the arn as part of the creating ot the storage integration object
--
--create storage integratin object
CREATE OR REPLACE STORAGE INTEGRATION S3_AWS
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = S3
    ENABLED = TRUE
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::083527689950:role/juanhernandezm'
    STORAGE_ALLOWED_LOCATIONS = ('s3://snow-flake-demoproject/csv/','s3://snow-flake-demoproject/json/')
        COMMENT = 'Storage integration for s3 path';


DESC INTEGRATION S3_AWS;
-- as result of the DESC we copy the information from STORAGE_AWS_IAM_USER_ARN and
-- add it to a trusted relathionship


--now we create the stage
CREATE OR REPLACE stage S3_MOVIE
    URL = 's3://snow-flake-demoproject/csv/'
    STORAGE_INTEGRATION = S3_AWS
    FILE_FORMAT = CSV_FILE_FORMAT;


--- and we can see the file inside the s3 bucket
LIST @S3_MOVIE;