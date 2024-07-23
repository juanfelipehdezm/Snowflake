-- create file format json
CREATE OR REPLACE FILE FORMAT MANAGE_BD.FILE_FORMAT.aws_json_s3
    type = 'json';

--stage object for the json file
CREATE OR REPLACE STAGE MANAGE_BD.EXTERNAL_STAGES.aws_json
    URL = 's3://snow-flake-demoproject/json/'
    STORAGE_INTEGRATION = S3_AWS
    FILE_FORMAT = MANAGE_BD.FILE_FORMAT.aws_json_s3;


--decommpresing the json and formating it
SELECT 
    $1:asin::STRING as ASIN,
    $1:helpful as helpful,
    $1:overall as overall,
    $1:reviewText::STRING as reviewtext,
    DATE_FROM_PARTS( 
      RIGHT($1:reviewTime::STRING,4), 
      LEFT($1:reviewTime::STRING,2), 
      CASE WHEN SUBSTRING($1:reviewTime::STRING,5,1)=',' THEN SUBSTRING($1:reviewTime::STRING,4,1) 
           ELSE SUBSTRING($1:reviewTime::STRING,4,2) 
      END),
    $1:reviewerID::STRING,
    $1:reviewTime::STRING,
    $1:reviewerName::STRING,
    $1:summary::STRING,
    DATE($1:unixReviewTime::int) as UnixRevewtime
FROM @MANAGE_BD.EXTERNAL_STAGES.aws_json;

---destination table
CREATE OR REPLACE TABLE MOVIES.PUBLIC.REVIEWS (
    asin STRING,
    helpful STRING,
    overall STRING,
    reviewtext STRING,
    reviewtime DATE,
    reviewerid STRING,
    reviewername STRING,
    summary STRING,
    unixreviewtime DATE
);


// Copy transformed data into destination table
COPY INTO MOVIES.PUBLIC.REVIEWS
    FROM (SELECT 
            $1:asin::STRING as ASIN,
            $1:helpful as helpful,
            $1:overall as overall,
            $1:reviewText::STRING as reviewtext,
            DATE_FROM_PARTS( 
              RIGHT($1:reviewTime::STRING,4), 
              LEFT($1:reviewTime::STRING,2), 
              CASE WHEN SUBSTRING($1:reviewTime::STRING,5,1)=',' 
                    THEN SUBSTRING($1:reviewTime::STRING,4,1) ELSE SUBSTRING($1:reviewTime::STRING,4,2) END),
            $1:reviewerID::STRING,
            $1:reviewerName::STRING,
            $1:summary::STRING,
            DATE($1:unixReviewTime::int) Revewtime
            FROM @MANAGE_BD.EXTERNAL_STAGES.aws_json
);


    
// Validate results
SELECT * FROM MOVIES.PUBLIC.REVIEWS ;