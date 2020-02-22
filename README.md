# TechTestApp

This repository holds the code and instructions to deploy the TechTestApp using AWS cloudformation.

The overall deployment steps are:
1. Ensure the application is built well on local machine using the dev team instructions.  
2. Ensure the built package uploaded to an S3 bucket.  
3. Ensure that the Auto scaling group that will spin up  new instances should have a role (with the appropriate S3  bucket policy) to pickup the package from S3 and deploy the same.  

Contents of the repository:  
1. AWS_CF.yml --> Cloudformation  
2. images/AWS_Architecture.png --> Architecture of the AWS infrastructure.
3. images/AWS_CF_architecture.png --> Architecture as built in AWS Cloudformation.
4. TechTestApp.tar --> The complete source code with compiled package.
4. Readme.md --> Information about the solution.

There are two stages involved in setting up TechTestApp on AWS :  
1. Building the application locally using go (instructions for the same are located here : https://github.com/servian/TechTestApp/blob/master/doc/readme.md)  
2. Deploying the same via AWS cloudformation.  

We can use the below CLI command through a local Jenkins setup in the below way:  

1. Setup a local jenkins server to be able to pull out the AWS_CF.yml from the github repository. 
2. Create an IAM user and attach the appropriate IAM policy to allow the user to create/update stacks in the AWS account.
3. Ensure to create a programmatic access for this user and note down the access key and secret access key in a safe location(do not upload it to the git repository).
3. Setup a jenkins job to run the below AWS CLI command from the same location where you will pull the code.

aws cloudformation create-stack --template-body file://AWS_CF.yml --stack-name TestTechApp --parameters ParameterKey=VPCName,ParameterValue=TechTest ParameterKey=KeyName,ParameterValue=TechTest ParameterKey=VPCCidr, ParameterValue=192.180.0.0/16 ParameterKey=PubSubnetACidr,ParameterValue=192.180.10.0/24 ParameterKey=PubSubnetBCidr,ParameterValue=192.180.20.0/24 ParameterKey=WebSubnetACidr,ParameterValue=192.180.11.0/24 ParameterKey=WebSubnetBCidr,ParameterValue=192.180.21.0/24 ParameterKey=DBName,ParameterValue=app ParameterKey=DBUser,ParameterValue=postgres ParameterKey=DBPassword,ParameterValue=changeme ParameterKey=MultiAZ,ParameterValue=true ParameterKey=DBAllocatedStorage,ParameterValue=5 ParameterKey=DBInstanceClass,ParameterValue=db.t2.micro ParameterKey=InstanceType,ParameterValue=t2.micro         

*Note : Due to security reasons , better to pass the values for these parameters as Jenkins parameters.



            
    # AWS Architecture


     ![](images/Application_Architecture.png)
                                                  
                                                    
                                                      
                                                        

               


