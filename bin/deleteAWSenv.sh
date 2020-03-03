#!/bin/bash -xe
aws cloudformation delete-stack --stack-name TestTechApp --region ap-southeast-2
echo "Deleting the Stack , waiting for it to complete.."
aws cloudformation wait stack-delete-complete --stack-name TestTechApp --region ap-southeast-2
echo "Stack is deleted , please check the AWS console"