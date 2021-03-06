# TechTestApp

This repository holds the code and instructions to automate the build and deploy TechTestApp using AWS cloudformation.

Contents of the repository: 

1. AWS_CF.yaml --> Cloudformation  
2. images/AWS_Architecture.png --> Architecture of the AWS infrastructure.
3. images/AWS_CF_architecture.png --> Architecture as built in AWS Cloudformation.
4. TechTestApp.tar --> The complete source code with compiled package.
5. Readme.md --> Information about the solution.
6. bin/appbuild.sh --> Shell script to build the go application.
7. bin/spinupAWS.sh --> Shell script to spin up the AWS infrastructure and deploy the applicaton.
8. bin/deleteAWSenv.sh --> Shell script to delete the created AWS infrastructure.

There are two stages involved in setting up TechTestApp on AWS :  
1. Building the application using go (instructions for the same are located here : https://github.com/servian/TechTestApp/blob/master/doc/readme.md)  
2. Deploying the same via AWS cloudformation. 


# Overview of the Cloudformation Template

1. Spin up a Private VPC with :
    - A VPC in the default selected region , this can be changed by passing region name as a parameter.
    - Two public subnets in each Availibility Zone.  
    - Two Private subnets in each Availibility Zone.  
    - Two DB subnets in each Availibility Zone. 
    - Two public route tables to be associated with the public subnets.
    - Two private route tables to be associated with the private subnets.
    - An internet gateway for both the public subnets.
    - Attaching the internet gateway to the  public route tables.
    - Two NAT gateways in each of the public subnets in each of the Availibility zone.  
    - Attaching each of the private subnets to the above two NAT gateways 
    - TWo jump servers/RDGW in each of the public subnets.  
    - Two Elastic IPs to attach to each of the  NAT gateways.  
    - A launch configuration mentioning the instance types , AMI to be used , subnet association , security group association , the user data that will execute the application deployment etc.
    - An autoscaling group of EC2 instances in the private subnets that will spin up instances using the above mentioned launch configuration.  
    - A target group wherein the above created instances in the auto scaling group will be registered on port 3000.  
    - An application load balancer bound to the target group.  
    - A listener listening on port 80 on the application load balancer.  
    - An IAM policy to allow access to the specific s3 bucket to download the application package.  
    - An EC2 role having the above policy attached along with an instance profile to attach to the instances launched in the auto scaling group using the launch configuration.  
    - an RDS instance with MultiAZ enabled having postgreSQL engine.  
    - A key for the jumpservers to be able to login.  
    - A security group for jump servers in the public subnets.  
    - A security group for the EC2 instances launched in an auto scaling group in the private subnets.
    - A security group for the RDS service. 
    - A security group for the Application load balancer.
    - Ingress rules for : 
        - Allowing all HTTP traffic from the internet to the load balcner security group on port 80. 
        - Allowing selective traffic from the internet  to the public subnet security group on ports 22.  
        - Allowing traffic from the public subnet security group to the private security group on ports 22,3000.  
        - Allowing traffic from the private subnet security group to the DB security group on ports 5432.  
        - Allowing traffic from the public subnet security group to the DB security group on ports 5432. 

2. The below parameters need to be passed to the template , if any/all parameters are not passed , Cloudformation will select the default values mentioned in the template:

    - VPCName
    - KeyName
    - VPCCidr
    - PubSubnetACidr
    - PubSubnetBCidr
    - WebSubnetACidr
    - WebSubnetBCidr
    - DBName
    - DBUser
    - DBPassword
    - MultiAZ
    - DBAllocatedStorage
    - DBInstanceClass
    - InstanceType


# Prerequisites  

Ensure the below prerequisites are met on the buildserver before building and deploying the application:  

1.  Golang is installed.  
2.  Dep is installed.  
3. AWS CLI is installed and configured with an IAM user that has appropriate permissions to spin up a complete VPC using cloudformation templates and also upload package to s3 bucket in the AWS account.  
4. OS is updated with the latest patches. 
5. A prebaked AMI with password based authentication enabled.
6. A key to allow passwordless authentication to the jump servers.  



# Building the application  

We can use the below method to build the application using go:  

1.  Use the shell script kept in bin/appbuild.sh that contains all the build steps.

2. Schedule a jenkins job on the local build server that will trigger this script as soon as it observes a code change in the repository https://github.com/servian/TechTestApp  

3. Trigger the jenkins job mentioned below to spin up a new AWS environment.  



# Deploy the AWS infrastructure with the newly built app 

1. Setup a jenkins job on the build server that will pull the AWS_CF.yaml and run the cloudformation create-stack CLI command to spin up a Private VPC in the AWS account.The script bin/spinupAWS.sh contains the actual script used to spinup the AWS environment. 

    <b>*Note</b> : Due to security reasons , better to pass the values for these parameters as Jenkins parameters.


eg:
<i>aws cloudformation create-stack --template-body <location_of_template> --stack-name <name_of_stack> --parameters ParameterKey=<Parameter_1>,ParameterValue=<Value_1> --region <AWS_region> --capabilities CAPABILITY_NAMED_IAM</i>   



# Delete the AWS infrastructure once the objective is fulfilled.

1. Setup another jenkins job on the build server that will delete the AWS infrastructure using the bin\deleteAWSenv.sh once the objective of the environment is fulfilled.It will use the cloudformation delete-stack CLI command similar to the one mentioned below.

eg:
aws cloudformation delete-stack --stack-name <name_of_stack> --region <AWS_region>

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

10. <b><i>Automatic Management</b></u> - For RDS , we don’t have to worry about patching the database software, backing up databases, replication, or enabling point-in-time recovery. All these tasks are managed automatically — and with a single API call.

11. <b><i>Minimal Downtime</b></u> - Importing Data to an Amazon RDS MySQL instance is easy to do without significant downtime. You can move data in and out of Amazon RDS using backup files, Amazon S3 .  So whether you’re transferring a copy of your database to an EC2 instance, replication is straightforward and lightweight, with little downtime.

12. <b><i>Affordability</b></u> - Hosting data on AWS helps organizations to move faster and scale at lower costs. Compared to other solutions, RDS is highly affordable. You can pay for your database by the hour with no long-term commitments or upfront fees, which means you don’t have to buy database capacity ahead of time. This pay-as-you-go model is ideal for development, test and other short-lived workloads.

13. <b><i>Speed & Performance</b></u> - We can monitor DB performance using cloudwatch and setup notifications / triggers based on the performance. This will ensure we handle issues proactively rather than being reactive to issues.

14. <b><i>Automated Backup</b></u> -  This functionality automatically performs a full daily snapshot of a database’s data (during a preferred window of time set up by the user). It also captures your transaction logs as well as any updates to your RDS database.



# Enhancements

The below enhancements are advised in the existing deployment process.

1. Request a Domain for the web application (through Route53 or other provider) and issue a self signed certificate for this domain  through ACM , this will allow traffic over https.
2. Open port 443  to allow HTTPS traffic over the load balancer.
3. In case of heavy read traffic , create read-replicas for the RDS and redirect read requests to the read replicas. This can be achieved by creating another DB endpoint in the web application that will only be used for read requests.
4. Setup cloudwatch alerts to trigger actions like : 
    -   Send an email/SNS notification in case of CPU utilization exceeds 90% for 30 minutes .
    -   Send an email/SNS notification in case of low disk space observed.
    -   Trigger email/SNS notification if Auto scaling group is scaling up/down.
    -   Setup scaling policies to scale up if  CPU utilization reaches 90% and remains there for 15 minutes.
    -   Setup scaling policies to scale down if CPU utilization goes below 90% after 15 minutes.
5. Setup cloudtrail logs to track API calls made to the AWS resources in the account : EC2 , VPC , ELB , S3. 
6. Setup Network ACLs across the public subnets to restrict outgoing traffic.
7. Setup backup strategy for backing up application logs in case EC2 instance destroys as part of replacement / scale down.
8. Schedule volume backups/AMI creation to ensure point in time restore in case of Disaster recovery.

    
# AWS Architecture


![](images/Application_Architecture.png)
                                                  
                                                    
                                                      


               


