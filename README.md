# MediaWikiOnEKS
This repo describe how to create EKS cluster and Deploy media wiki on EKS using helm3

# Introduction

This repo give detailed information and instruction to people who want to deploy or run MediaWiki on EKS cluster using helm3.

# Prerequisites:

In order to create EKS cluster using workastation your workstation need to install bdelow software and tools on yor local workstation.

1. Terraform
   We need terraform version > 0.12.0. Please follow below link to install terraform on local machine.
   This required to provision the EKS cluster using tf files.

2. AWS-vault
Configure the AWS credentials to inetract with aws resoucres using CLI.


3. Helm3
  Deploy the application on EKS cluster using helm deployment


4. kubectl
   To intract with EKS cluster.


5. IAM authenticator 
    
    To access the EKS cluster.

