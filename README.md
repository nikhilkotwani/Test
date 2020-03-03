# TechTestApp

This repository holds the code and instructions to deploy the TechTestApp using AWS cloudformation.

 
Contents of the repository:  
1. AWS_CF.yaml --> Cloudformation  
2. images/AWS_Architecture.png --> Architecture of the AWS infrastructure.
3. images/AWS_CF_architecture.png --> Architecture as built in AWS Cloudformation.
4. TechTestApp.tar --> The complete source code with compiled package.
5. Readme.md --> Information about the solution.

There are two stages involved in setting up TechTestApp on AWS :  
1. Building the application locally using go (instructions for the same are located here : https://github.com/servian/TechTestApp/blob/master/doc/readme.md)  
2. Deploying the same via AWS cloudformation.  

# Prerequisites  

Ensure the below prerequisites are met on the buildserver before building and deploying the application:  

1.  Golang is installed.  
2.  Dep is installed.  
3. AWS CLI is installed and configured with an IAM user that has appropriate permissions to spin up a complete VPC using cloudformation templates and also upload package to s3 bucket in the AWS account.  
4.  OS is updated with the latest patches.    



# Building the application  

We can use the below method to build the application using go:  

1.  Prepare a shell script that contains all the build steps ( as kept in bin/appbuild.sh).  
2. Schedule a jenkins job on the local build server that will trigger this script as soon as it observes a code change in the repository https://github.com/servian/TechTestApp  
3. Trigger the jenkins job mentioned below to spin up a new AWS environment.  



# Deploy the AWS infrastructure with the newly built app 

1. Setup a jenkins job on the build server that will pull the AWS_CF.yaml and run the cloudformation create-stack CLI command to spin up a Private VPC in the AWS account.  

eg:
<i>aws cloudformation create-stack --template-body <location_of_template> --stack-name <<name_of_stack> --parameters ParameterKey=<Parameter_1>,ParameterValue=<Value_1> --region <<AWS_region>> --capabilities CAPABILITY_NAMED_IAM</i>   

The script bin/spinupAWS.sh contains the actual script used to spinup the AWS environment.

*Note : Due to security reasons , better to pass the values for these parameters as Jenkins parameters.

# Advantages  

Below are advantages of this architecture:

1.  <b><i>Better fault tolerance</b></u> - Auto Scaling can detect when an instance is unhealthy, terminate it, and launch an instance to replace it. You can also configure Amazon EC2 Auto Scaling to use multiple Availability Zones. If one Availability Zone becomes unavailable, Amazon EC2 Auto Scaling can launch instances in another one to compensate.

2.  <b><i>Better availability</b></u> -  Auto Scaling helps ensure that your application always has the right amount of capacity to handle the current traffic demand.

3.  <b><i>Better cost management</b></u> -  Auto Scaling can dynamically increase and decrease capacity as needed. Because you pay for the EC2 instances you use, you save money by launching instances when they are needed and terminating them when they aren't.

4. <b><i>Logical isolation</b></u> - Isolating resources in AWS using VPC helps you build and maintain a secure environment like your own managed data center.

5. <b><i>Secure access</b></u> - Having a private VPC helps you control the level of access resources require . You can choose to enable/disable internet access.It provides advanced security features, such as security groups and network access control lists, to enable inbound and outbound filtering at the instance and subnet level.  

6. <b><i>Customizable</b></u> - Control your virtual networking environment, including selection of your own IP address range, creation of subnets, and configuration of route tables and network gateways. Customize the network configuration, such as by creating a public-facing subnet for your webservers that has access to the internet, and placing your backend systems such as databases or application servers in a private-facing subnet with no internet access.  

7. <b><i>Environment on-demand</b></u> - Use of cloudformation template helps us to quickly build and scrap environments build for demonstration purpose . This enables us to focus on the architecting the infrastructure while emphasizing more on using feature rich AWS resources while spending less time on managing it.  

8. <b><i>Vertical and horizontal scalability</b></u> - Combination of EC2 and Auto scaling with Cloudformation enables us to quickly scale servers horizontally ( by adding/deleting servers to meet demand) as well as vertically ( upgrade/downgrade EC2 instance types). Also RDS is an excellent option for keeping up with the increasing demands of your application or applications. To scale your RDS instance vertically, you can resize your instance type and apply the change immediately. And for scaling your database horizontally, you can use read replicas and add a load balancer between your application and database servers, both of which improve the performance of a read-heavy database.  

9. <b><i>Simplicity</b></u> - As a web service running “in the cloud”, RDS lets you simplify the setup, operation, and scaling of a relational database for use in applications.  


    
# AWS Architecture


![](images/Application_Architecture.png)
                                                  
                                                    
                                                      


               


