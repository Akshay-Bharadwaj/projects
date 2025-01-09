#!/bin/bash

# Initializing the variables
JENKINS_HOME="/var/lib/jenkins"  # Mention the jenkins home directory
S3_BUCKET="s3://cost-opt-akshay"  # Mention the S3 bucket name
DATE=$(date +%Y-%m-%d)  # Get the today's data

# Check if AWS CLI is installed or not. If not, print the message
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it to proceed."
    exit 1
fi

# Iterate through the job directories created in jenkins
for job_dir in "$JENKINS_HOME/jobs/"*/; do
    job_name=$(basename "$job_dir")
    
    # Iterate through build directories i.e build projects in each job
    for build_dir in "$job_dir/builds/"*/; do
        # Get the build number or name
        build_number=$(basename "$build_dir")
        # Create a log file for each build
        log_file="$build_dir/log"

        # Check if the log file is of today's date. If yes, then upload the file to the S3 bucket with the build number as filename
        if [ -f "$log_file" ] && [ "$(date -r "$log_file" +%Y-%m-%d)" == "$DATE" ]; then
            aws s3 cp "$log_file" "$S3_BUCKET/$job_name-$build_number.log" --only-show-errors
            # Check if the upload task is success or not. If not, print a message
            if [ $? -eq 0 ]; then # $? means exit status. 0 is success and 1 is fail
                echo "Uploaded: $job_name/$build_number to $S3_BUCKET/$job_name-$build_number.log"
            else
                echo "Failed to upload: $job_name/$build_number"
            fi
        fi
    done
done