import os
import os.path
import subprocess
import time
import json
import tarfile
import shutil
from threading import Timer
import shlex
import traceback
import io
import signal

import boto3

from settings import student_bucket, object_key_prefix, server_timeout, local_job_dir, region, sqs_awsrun_queue_url, sqs_awsrun8_queue_url, perf_file_name, sqs_awsrun_test_queue_url


def run_timed(cwd, cmd, timeout, *, should_taskset):
    # TODO run process in group with no network access
    for i in range(len(cmd) - 1):
        if cmd[i] == "perf" and cmd[i+1] == "record":
            # when run through a subprocess, perf record goes to stdout
            # need to manually force it to a file
            cmd = cmd[:i+2] + ["-o", perf_file_name] + cmd[i+2:]
            break
    cores = "0" if should_taskset else "0-7"
    cmd = ["taskset", "-c", cores, "/bin/bash", "-c"] + [" ".join(cmd)]
    print("Running command: {cmd}".format(cmd=cmd))
    try:
        proc = subprocess.Popen(
            cmd,
            stdout=subprocess.PIPE,
            cwd=cwd,
            shell=False,
            stderr=subprocess.PIPE,
            env={
                "AWSRUNNER": "1"  # setting this variable so scripts can detect whether they are being run on awsrun
            },
            start_new_session=True,
            universal_newlines=True)
    except OSError as e:
        # OSErrors are raised if there is an issue calling the subprocess
        stdout = ""
        stderr = "Error calling process: " + str(e)
    else:
        try:
            stdout, stderr = proc.communicate(timeout=timeout)
        except subprocess.TimeoutExpired:
            stdout = ""
            stderr = "Process timed out after {timeout} seconds".format(timeout=timeout)
        finally:
            try:
                os.killpg(proc.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass
    return stdout, stderr

def str_to_io(string):
    data = string.encode('utf-8')
    stdout_io = io.BytesIO(data)
    stdout_io.seek(0)
    return stdout_io


def process_message(job_info, timeout, *, should_taskset):
    # Extract parameters from message.
    job = job_info["job"]
    job_folder = job_info["job_folder"]
    # Create job folder, change directories into it.
    mount_dir = os.path.normpath(os.path.join(local_job_dir, job_folder))
    os.makedirs(mount_dir, exist_ok=True)

    # Derive input tarball names and key.
    tarball_in_name = os.path.join(local_job_dir, job_folder) + "_in.tar"
    tarball_in_key = object_key_prefix + "/" + job_folder + "/" + job_folder + "_in.tar"

    # Download input tarball from S3 Student Bucket.
    s3_client = boto3.client('s3', region_name=region)
    print("Downloading s3://{student_bucket}/{tarball_in_key} to {tarball_in_name}".format(
        student_bucket=student_bucket,
        tarball_in_key=tarball_in_key,
        tarball_in_name=tarball_in_name))
    s3_client.download_file(
        student_bucket,
        tarball_in_key,
        tarball_in_name)

    # Extract input tarball into current directory.
    with tarfile.open(tarball_in_name, "r") as tarball:
        # this would normally be a security issue, but when run as the "nobody"
        # user and group, files cannot be overwritten
        tarball.extractall(mount_dir)

    print("Extracted tar file")
    # Remove the input tarball.
    os.remove(tarball_in_name)

    print("Running job")
    stdout, stderr = run_timed(mount_dir, job, timeout, should_taskset=should_taskset)

    print("Finished job")
    # Derive output tarball name and key.
    tarball_out_name = job_folder + "_out.tar"
    tarball_out_key = object_key_prefix + "/" + job_folder + "/" + tarball_out_name

    # Create tarball for upload.
    tarball_out_path = os.path.normpath(
        os.path.join(local_job_dir, tarball_out_name))
    with tarfile.open(tarball_out_path, "w") as tarball:
        stdout_io = str_to_io(stdout)
        stdout_info = tarfile.TarInfo("stdout")
        stdout_info.size = len(stdout)
        tarball.addfile(tarinfo=stdout_info, fileobj=stdout_io)

        stderr_io = str_to_io(stderr)
        stderr_info = tarfile.TarInfo("stderr")
        stderr_info.size = len(stderr)
        tarball.addfile(tarinfo=stderr_info, fileobj=stderr_io)

        perf_path = os.path.join(mount_dir, perf_file_name)
        if os.path.exists(perf_path):
            perf_data_info = tarball.gettarinfo(perf_path, arcname=perf_file_name)
            with open(perf_path, "rb") as f:
                tarball.addfile(tarinfo=perf_data_info, fileobj=f)

    # Upload output tarball to S3 Student Bucket.
    s3_client.upload_file(
        tarball_out_path,
        student_bucket,
        tarball_out_key,
        ExtraArgs={
            "ACL": "public-read"
        }
    )

    # Remove the output tarball.
    os.remove(tarball_out_path)

    # Remove the job folder.
    shutil.rmtree(mount_dir)

    print("Job {job_folder} finished!".format(job_folder=job_folder))


def loop(queue):
    # Request message from queue.
    response = queue.receive_messages(MaxNumberOfMessages=1)

    # for the single worker, we want to taskset. For the 8 core, no tasksetting
    should_taskset = queue == sqs_awsrun_queue_url
    if len(response) > 0:
        # Echo message information.
        message = response[0]
        print("Message Raw: " + str(message))
        print("Message Body: " + str(message.body))
        print("Message Attributes: " + str(message.attributes))

        try:
            # Parse message.
            job_info = json.loads(message.body)
            print("Message Parse: " + str(job_info))
            process_message(job_info, server_timeout, should_taskset=should_taskset)
        except Exception as e:
            print("Exception processing message: " + str(e))
        else:
            # Delete message if successful
            print("Successful!")
            message.delete()
    else:
        print("No message yet...")


def run_loop(queue_url):
    # Setup job submission queue.
    sqs = boto3.resource('sqs', region)
    queue = sqs.Queue(url=queue_url)

    # Wait for message to be received.
    while True:
        loop(queue)
        time.sleep(1)


def awsrunner():
    run_loop(sqs_awsrun_queue_url)


def awsrunner8():
    run_loop(sqs_awsrun8_queue_url)

if __name__ == "__main__":
    print("WARNING: USING TEST QUEUE")
    run_loop(sqs_awsrun_test_queue_url)
