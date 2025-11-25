# Create an EC2 instance on AWS

- couple of Security Groups (http only and http+ssh);
- EC2 instance with SSH access, and http server via User Data;
- EBS volume attached to the instance;

## Prerequisites

- an SSH key-pair named `main` should already exist (created upfront);

## Authentication

**Option 1**: credentials file (`~/.aws/credentials`) in AWS CLI.

- install AWS CLI if not already;
- authenticate with AWS CLI: `aws configure` and follow the prompts.
  This will create the credentials file (`~/.aws/credentials`) with `default` profile.

## Deploy, check and clean

Deploy:

```bash
terraform init
terraform plan -out=main.tfplan
terraform apply "main.tfplan"
...
Outputs:

public_ip = "A.B.C.D"
public_nds = "ec2-XXX.eu-west-1.compute.amazonaws.com"
```

Connect:

```bash
ssh ec2-user@A.B.C.D -i linuxvm
# or
curl http://A.B.C.D
```

Destroy:

```bash
terraform destroy
```

## Format EBS volume

By default the newly created volume doesn't have a filesystem,
so can't be mounted and used.
[The volume should be formatted first](https://docs.aws.amazon.com/ebs/latest/userguide/ebs-using-volumes.html):

```bash
$ lsblk
NAME          MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
nvme0n1       259:0    0   8G  0 disk
├─nvme0n1p1   259:1    0   8G  0 part /
├─nvme0n1p127 259:2    0   1M  0 part
└─nvme0n1p128 259:3    0  10M  0 part /boot/efi
nvme1n1       259:4    0   4G  0 disk  # <--- attached volume
$ sudo file -s /dev/sdh
/dev/sdh: symbolic link to nvme1n1  # <--- confirmation
$ sudo mkfs -t xfs /dev/sdh
# the FS is being created
$ sudo file -s /dev/nvme1n1
/dev/nvme1n1: SGI XFS filesystem data (blksz 4096, inosz 512, v2 dirs)  # FS is created
$ sudo mkdir /media/data  # create a mount point
$ sudo mount /dev/nvme1n1 /media/data  # mount the volume
# cd /media/data and work with files
```
