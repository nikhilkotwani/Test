#!/bin/bash -xe
cd /home/ec2-user/
go get -d github.com/servian/TechTestApp
cd /home/ec2-user/go/src/github.com/servian/TechTestApp
./build.sh
tar -cvf TechTestApp.tar /home/ec2-user/go/src/github.com/servian/TechTestApp

aws s3 cp TechTestApp.tar s3://testtechpackage/TechTestApp1.tar