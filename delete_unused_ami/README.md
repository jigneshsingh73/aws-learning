# Shell script to delete unused AMI and snapshots older than a specified date

## Requirements:
-	AWS CLI installed and configured with appropriate permissions to delete AMI and snapshots
-   AWS_REGION : where you need to execute
-   DATE : After which AMI needs to be retained

## Example:
```
./SCRIPT.sh AWS_REGION DATE
```

## Usage:
1. Specify the AWS_REGION and DATE 
2. When you run the script, it will:
	- Get AMI's used by launch configuration
	- Get AMI's older than specific date
	- Find out the unused AMI
	- Deregister the AMI and its associated snapshot

## Notes:
- The script should work in single run. If not, run it again as it is safe to do.
- `DATE` Example = 2014-10-19T09:26:06.000Z
