--DATABSE to host our data
CREATE OR REPLACE DATABASE MOVIES;

--table
CREATE OR REPLACE TABLE MOVIES.PUBLIC.movie_titles(
    show_id STRING,
    type STRING,
    title STRING,
    director STRING,
    cast STRING,
    country STRING,
    date_added STRING,
    release_year STRING,
    rating STRING,
    duration STRING,
    listed_in STRING,
    description STRING
);

---file_formar_schema
CREATE OR REPLACE SCHEMA MANAGE_BD.FILE_FORMAT;

---file format
CREATE OR REPLACE FILE FORMAT MANAGE_BD.FILE_FORMAT.CSV_FILEFORMAT
    type = csv
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL', 'null')
    empty_field_as_null = TRUE,
    FIELD_OPTIONALLY_ENCLOSED_BY = '"';

 // Create stage object with integration object & file format object
CREATE OR REPLACE stage MANAGE_BD.EXTERNAL_STAGES.S3_MOVIE
    URL = 's3://snow-flake-demoproject/csv/'
    STORAGE_INTEGRATION = S3_AWS
    FILE_FORMAT = MANAGE_BD.FILE_FORMAT.CSV_FILEFORMAT;


// Use Copy command       
COPY INTO MOVIES.PUBLIC.movie_titles
    FROM @MANAGE_BD.EXTERNAL_STAGES.S3_MOVIE;

SELECT *
FROM MOVIES.PUBLIC.movie_titles;
    