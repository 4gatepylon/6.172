# Amazon S3 bucket name for student jobs.
student_bucket = "6172-students"

# Key prefix for jobs folder in bucket.
object_key_prefix = "jobs"

# Directory name for location to place output tarballs.
log_base = "log.awsrun"

# File name for staging area for tarball extraction.
staging_area = ".tmp_staging_area"

# Job queue
region = "us-east-1"
sqs_awsrun_queue_url = "https://sqs.us-east-1.amazonaws.com/414052861168/6172-f20-awsrun"
sqs_awsrun8_queue_url = "https://sqs.us-east-1.amazonaws.com/414052861168/6172-f20-awsrun8"

# WARNING: The test queue is shared among all developers testing concurrently.
sqs_awsrun_test_queue_url = "https://sqs.us-east-1.amazonaws.com/414052861168/6172-f20-awsrun-test-queue"

# Job runner
MAX_MESSAGE_RETRY = 10
MESSAGE_RETRY_DELAY = 1

# Folder for local job directory.
local_job_dir = "/tmp/6172-student-jobs"

# Timeout
server_timeout = 60

# allowing additional time for network overhead, instance availability
client_timeout = server_timeout + 60  

perf_file_name = "awsrun-perf.data"

# Config file name that specifies which additional files should be included and uploaded
config_file_name = "config.awsrun"
