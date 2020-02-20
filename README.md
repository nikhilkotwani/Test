# TechTestApp

This repository holds the code and instructions to deploy the TechTestApp(..) using AWS cloudformation.

The overall deployment steps are:
1. Ensure the application is built well on local machine using the dev team instructions.  
2. Ensure the built package uploaded to an S3 bucket.  
3. Ensure that the Auto scaling group that will spin up  new instances should have a role (with the appropriate S3  bucket policy) to pickup the package from S3 and deploy the same.  

Contents of the repo:  
1. AWS_CF.yml --> Cloudformation  
2. AWS Architecture.png --> Architecture of the AWS infrastructure.
3. ..... --> Application Architecture.


