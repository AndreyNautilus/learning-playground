# Create an EC2 instance on AWS

- couple of Security Groups (http only and http+ssh);
- EC2 instance with SSH access, and http server via User Data;

## Prerequisites

- an SSH key-pair named `main` should already exist (created upfront);

## Authentication

**Option 1**: credentials file (`~/.aws/credentials`) in AWS CLI.

- install AWS CLI if not already;
- authenticate with AWS CLI: `aws configure` and follow the prompts.
  This will create the credentials file (`~/.aws/credentials`) with `default` profile.
