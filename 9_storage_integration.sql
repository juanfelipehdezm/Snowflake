--create storage integratin object
CREATE OR REPLACE STORAGE INTEGRATION S3_AWS
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = S3
    ENABLED = TRUE
    STORAGE_AWS_ROLE_ARN = ''
    STORAGE_ALLOWED_LOCATIONS = ('s3://snow-flake-demoproject/csv/','s3://snow-flake-demoproject/json/')
        COMMENT = 'Storage integration for s3 path';

---see storege integration
DESC INTEGRATION S3_AWS;