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

            
    # AWS Architecture


     ![](images/Application_Architecture.png)
                                                  
                                                    
                                                      
                                                        

               


