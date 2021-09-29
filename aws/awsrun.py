import sys
import os
import errno
import subprocess
import time
import datetime
import pathlib
import json
import shutil
import tarfile
import uuid
import configparser

import boto3
import botocore

from settings import student_bucket, object_key_prefix, sqs_awsrun_queue_url, sqs_awsrun8_queue_url, region, client_timeout, sqs_awsrun_test_queue_url, local_job_dir, perf_file_name, config_file_name


# Sleep for three seconds, displaying message on the same line every second.
def print_pending(message):
    sys.stdout.write("\r"+message+"   ")
    sys.stdout.flush()
    time.sleep(1)
    sys.stdout.write("\r"+message+".  ")
    sys.stdout.flush()
    time.sleep(1)
    sys.stdout.write("\r"+message+".. ")
    sys.stdout.flush()
    time.sleep(1)
    sys.stdout.write("\r"+message+"...")
    sys.stdout.flush()


# Create a directory if it doesn't already exist.
def create_dir(path):
    os.makedirs(path, exist_ok=True)

# Get current working directory.


def get_cwd():
    return os.path.normpath(os.getcwd())

# Determine which paths in the list are descendants of the given ancestor, and
# return those paths relative to the ancestor.
def find_descendants(ancestor, paths):
    descendants = []
    for p in paths:
        rel_path = os.path.normpath(os.path.relpath(p, ancestor))
        if rel_path.startswith(os.pardir + os.sep) or rel_path == os.pardir:
            raise ValueError(
                "awsrun does NOT support arguments with a path in a parent directory. Please cd into a higher-level directory and call awsrun from there.")
        else:
            descendants.append(rel_path)
    return descendants

def dependencies_from_config_file(filename):
    try:
        with open(filename, "r") as f:
            extra_files = list(f.readlines())
    except FileNotFoundError:
        return []
    else:
        cleaned_extra_files = []
        for extra_file in extra_files:
            stripped_extra_file = extra_file.strip()
            if len(stripped_extra_file) > 0:
                for x in pathlib.Path(".").glob(stripped_extra_file):
                    cleaned_extra_files.append(str(x))
        return cleaned_extra_files 


def main(queue_name, argv):
    # entrypoint for single core execution
    # Give basic calling convention if requested.
    if len(argv) < 2 or argv[1] == "-h" or argv[1] == "--help":
        print("Usage: {0} COMMAND [OPTION]...\n".format(
            os.path.basename(__file__)))
        raise ValueError()

    # Read args/environment.
    job = argv[1:]
    cwd = get_cwd()

    dependencies = []
    config_file_dependencies = dependencies_from_config_file(config_file_name)

    dependencies.extend(find_descendants(cwd, job))
    dependencies.extend(find_descendants(cwd, config_file_dependencies))

    # Generate job folder name.
    timestamp = datetime.datetime.now().strftime("%Y%m%dT%H%M%S")
    job_folder = "job" + "_" + timestamp + "_" + str(uuid.uuid4())

    tarball_in_name = job_folder + "_in.tar"
    
    # Create tarball for upload.
    with tarfile.open(tarball_in_name, "w") as tarball:
        # Ensure that symbolic links are dereferenced.
        tarball.dereference = True

        # Add files to the tarball.
        for rel_path in dependencies:
            try:
                tarball.add(rel_path)
            except FileNotFoundError:
                pass  # ignore since all cli args are treated as file paths

    # Upload the file to the student bucket.
    s3_client = boto3.client('s3')
    tarball_in_key = object_key_prefix + "/" + job_folder + "/" + tarball_in_name
    s3_client.upload_file(
        tarball_in_name,
        student_bucket,
        tarball_in_key,
        ExtraArgs={
            "ACL": "bucket-owner-full-control"
        }
    )

    # Echo status back to user.
    print("")
    print("Submitting Job: " + " ".join(job))

    # NOTE(TFK): This sleep actually helps to reduce latency.
    time.sleep(1)

    # Setup job submission queue
    sqs = boto3.resource('sqs', region)
    queue = sqs.Queue(url=queue_name)

    # Setup message to submit to queue
    job_info = dict()
    job_info["job"] = job
    job_info["job_folder"] = job_folder

    # Stringify and send message
    message_body = json.dumps(job_info)
    queue.send_message(MessageBody=message_body)
    # Wait for response tarball
    tarball_out_name = job_folder + "_out.tar"
    tarball_out_key = object_key_prefix + "/" + job_folder + "/" + tarball_out_name

    end_time = datetime.datetime.now() + datetime.timedelta(seconds=client_timeout)
    while True:
        try:
            s3_client.download_file(
                student_bucket,
                tarball_out_key,
                tarball_out_name
            )
        except botocore.exceptions.ClientError as e:
            error_code = int(e.response["Error"]["Code"])
            if error_code != 404 and error_code != 403:
                raise e
            print_pending("Waiting for job to finish")
            time.sleep(1)
            if datetime.datetime.now() > end_time:
                raise RuntimeError("Job timed out. Please resubmit.")
        else:
            break

    print("")
    perf_recorded = False
    with tarfile.open(tarball_out_name, "r") as tar:
        stdout = tar.extractfile('stdout').read()
        print("==== Standard Output ====")
        print(stdout.decode('utf-8'))
        print("")

        stderr = tar.extractfile('stderr').read()
        print("==== Standard Error ====")
        print(stderr.decode('utf-8'))
        print("")

        # extract the perf data file to the current directory
        try:
            tar.getmember(perf_file_name)
        except KeyError:
            # no perf data; that's fine :)
            pass
        else:
            # extract the data to the current directory
            perf_recorded = True
            tar.extract(perf_file_name)

    if perf_recorded:
        # We need the paths to match the server for the perf report to work properly
        # So, we are going to extract the "in" tarball in the same place that it ran
        # on the awsrun server
        mount_dir = os.path.normpath(os.path.join(local_job_dir, job_folder))
        os.makedirs(mount_dir, exist_ok=True)
        with tarfile.open(tarball_in_name, "r") as tarball:
            # user and group, files cannot be overwritten
            tarball.extractall(mount_dir)

    os.remove(tarball_in_name)
    os.remove(tarball_out_name)


def awsrun():
    # entrypoint for 1 core execution
    main(sqs_awsrun_queue_url, sys.argv)


def awsrun8():
    # entrypoint for 8 core execution
    main(sqs_awsrun8_queue_url, sys.argv)

if __name__ == "__main__":
  print("WARNING: USING TEST QUEUE")
  main(sqs_awsrun_test_queue_url, sys.argv)
