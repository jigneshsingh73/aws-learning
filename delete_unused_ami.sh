#!/bin/bash
##
#Shell script to delete unused AMI and snapshots older than a specified date
#./scriptname region date
#./delete_unused_ami ap-southeast-1 2014-10-19T09:26:06.000Z

# Give your aws path
aws=/usr/local/bin/aws

# For e.g.: ap-southeast-1
REGION=$1

# For e.g.: 2014-10-19T09:26:06.000Z
START_TIME=$2

# Get AMI's used by launch configuration
AMI_used=( $($aws autoscaling describe-launch-configurations --output json | grep "ImageId" | awk '{print $2}' | tr -d '"' | tr -d ','))

# Get AMI's older than specific date
#START_TIME="2014-10-19T09:26:06.000Z"
AMI_all=( $($aws ec2 describe-images --region "$REGION" --output text --owners self --query 'Images[?CreationDate<=`'"$START_TIME"'`].{ID:ImageId}'))

# Unused AMI
AMI_unused=()
for i in "${AMI_all[@]}"; do
     skip=
     for j in "${AMI_used[@]}"; do
         [[ $i == $j ]] && { skip=1; break; }
     done
     [[ -n $skip ]] || AMI_unused+=("$i")
 done

echo "UNUSED AMI"
echo "Deregister the AMI and snapshot using the below commands"
# Loop to deregister unused AMI
for i in "${AMI_unused[@]}"
do
    #unused snapshot
    snapshot_unused=($($aws ec2 describe-images --region "$REGION" --output text --image-ids $i --query 'Images[*].BlockDeviceMappings[*].Ebs.SnapshotId'))

    echo "aws ec2 deregister-image --image-id $i --region $REGION"
    # Deregister AMI
    #$aws ec2 deregister-image --image-id $i --region "$REGION"

    for j in "${snapshot_unused[@]}"
    do
        echo "aws ec2 delete-snapshot --snapshot-id $j --region $REGION"
        # Delete Snapshot
           #$aws ec2 delete-snapshot --snapshot-id $j --region "$REGION"
    done
done
