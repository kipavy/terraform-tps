LAB 4: Remote State and Workspaces
Setup Remote terraform s3 state
Migrate your state to S3
Now, rework your code from LAB 3 to use an AutoScaling Group for your ec2.
Make the min and max of your ASG variable
Set your variables in a fr.tfvars file, define min 1 and max 2 for your value
Create a terraform workspace and call it france
Migrate your state to this workspace
Create a terraform workspace called germany
Create a new .tfvars called de.tfvars and set min to 2 and max to 3 
Deploy a new asg with these values
Config for s3 backend: 
bucket = "terraform-state-agvq0"
key = "global/s3/student_XX/terraform.tfstate"
region = "eu-west-3"
dynamodb_table = "terraform-up-and-running-locks"
encrypt = true



# Solution

## 0. Prerequisites
Fill in terraform.tfvars with your values, then set AWS credentials as env vars:
```
export AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
```

## 1. Initialize with S3 backend
terraform init

## 2. Create & select the "france" workspace
terraform workspace new france

## 3. Deploy with France values
terraform apply -var-file=fr.tfvars

## 4. Create & select the "germany" workspace
terraform workspace new germany

## 5. Deploy with Germany values
terraform apply -var-file=de.tfvars