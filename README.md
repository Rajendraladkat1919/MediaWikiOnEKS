# MediaWikiOnEKS
This repo describe how to create EKS cluster and Deploy media wiki on EKS using helm3

# Introduction

This repo give detailed information and instruction to people who want to deploy or run MediaWiki on EKS cluster using helm3.

# Prerequisites:

In order to create EKS cluster using workastation your workstation need to install bdelow software and tools on yor local workstation.

1. Terraform
    We need terraform version > 0.12.0. Please follow below link to install terraform on local machine.
    This required to provision the EKS cluster using tf files.
    
    `https://www.terraform.io/downloads.html`
    
    version > `0.12.0`

2. AWS-vault:

    Configure the AWS credentials to inetract with aws resoucres using CLI.
    
    `https://github.com/99designs/aws-vault`


3. Helm3
    Deploy the application on EKS cluster using helm deployment
    
    `https://helm.sh/docs/helm/helm_install/`

4. kubectl:

    To connect with EKS cluster. Please follow below steps to install kubectl on your workstation.
    
    `https://kubernetes.io/docs/tasks/tools/install-kubectl/`


5. IAM authenticator 
    
    To give access to the EKS cluster.

    `https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html`

# How we create EKS cluster using terraform.

    1. We are using VPC module
    2. We are using  EKS module.
    3. various provider including terraform and kubernetes with its version mentioned in `version.tf file`.

# Step 1: create EKS cluster

    1. clone the git repo using below command.
        ```
        https://github.com/Rajendraladkat1919/MediaWikiOnEKS.git
        ```
    2. cd MediaWikiOnEKS/eks-infra
       Once you are in this location make sure below things are setup on your local workstation.
       You create your aws profile using aws access key and secret key. You need to pass the aws-profile and aws-region in the `vpc.tf` file.
       Once you modified below section with your profile and region in `vpc.tf` we good to go.
       
       For example.
       ```
        provider "aws" {
        version = ">= 2.28.1"
        region  = "us-east-2"
        profile= "demo"
        }
       ```
       Note: Profile using here is just for example it will not work if you try to run the terraform code. You need to replace the region and profile as per your configuration. :)
    
    3. Note we can create one `variable.tf` file here and add all required variable in that file so user can give values for the runtime. This code is just for the development and testing purpose.

# Step 2: Run the terraform code.
   
    1. Once above step done please perform below command in your eks-infra folder.

        terraform init
        ```
        $  terraform init
        Initializing modules...

        Initializing the backend...

        Initializing provider plugins...
        - Checking for available provider plugins...
        - Downloading plugin for provider "local" (hashicorp/local) 1.4.0...
        - Downloading plugin for provider "null" (hashicorp/null) 2.1.2...
        - Downloading plugin for provider "template" (hashicorp/template) 2.1.2...
        - Downloading plugin for provider "random" (hashicorp/random) 2.3.0...
        - Downloading plugin for provider "kubernetes" (hashicorp/kubernetes) 1.11.3...

        Terraform has been successfully initialized!

        You may now begin working with Terraform. Try running "terraform plan" to see
        any changes that are required for your infrastructure. All Terraform commands
        should now work.

        If you ever set or change modules or backend configuration for Terraform,
        rerun this command to reinitialize your working directory. If you forget, other
        commands will detect it and remind you to do so if necessary.
        ```
    2. If you want to see what it will be creating the in your AWS account. Perform below command.

       ```
       terraform plan
       ```

    3. Perform the terraform apply to create actual cluster.

       ```
       terraform apply
       ```
       Note: This command need user approval to create the resources in aws account using terraform. We can do this automated way also.
       Once you perform this command it will create EKS cluster with one master and 3 worker nodes and show output as below once command is complete.

       ```
       Apply complete! Resources: 54 added, 0 changed, 0 destroyed.

        Outputs:

        cluster_endpoint = "https://136E29CC7xxxxxx.gr7.xxxx.eks.amazonaws.com"
        cluster_id = "mediawiki-eks-xxxxa"
        cluster_name = "mediawiki-eks-bxxxx"
        cluster_security_group_id = "sg-xxxxx"
      
    4. Now we have EKS cluster ready after 15 minutes and kube configfile is created in the same folder. 
        We can update the local `~/.kube/config`   using         eksctl command. Please follow below link for the same.
      `https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html`

      or
        Please copy the kubeconfig manullay and create one test.yaml and paste kubeconfig content in it.
        For example below is the content of your eks kubeconfig.
        test.yaml
        ```
        apiVersion: v1
        clusters:
        - cluster:
            server: <endpoint-url>
            certificate-authority-data: <base64-encoded-ca-cert>
        name: kubernetes
        contexts:
        - context:
            cluster: kubernetes
            user: aws
        name: aws
        current-context: aws
        kind: Config
        preferences: {}
        users:
        - name: aws
        user:
            exec:
            apiVersion: client.authentication.k8s.io/v1alpha1
            command: aws
            args:
                - "eks"
                - "get-token"
                - "--cluster-name"
                - "<cluster-name>"
                # - "--role"
                # - "<role-arn>"
            # env:
                # - name: AWS_PROFILE
                #   value: "<aws-profile>"
        ```
    5. Now in order to connect with EKS cluster we are using the kubectl utility.
        please export the kubeconfig file locally using below command.

        `export KUBECONFIG= test.yaml`

        This will allows kubectl to connect with EKS cluster.
    
    6. After this you can find your cluster info using various kubectl command.

      1. Kubectl get cluster-info
        Give cluster details.

      2. Kubectl get nodes

        list cluster worker node.

        Once cluster worker node is ready we can good to deploy the Media wiki helm chart.

# Step 3: Deploy Media wiki using Helm3 on EKS cluster.

    Note: We can automate the deployment of mediawiki but I am following here helm insteruction.
    Noe we have cluster up and running and all worker node are in ready state and your workstation installed with helm3. Please follow the below steps.

    1. We are using below helm chart for installing media release.

    `https://charts.bitnami.com/bitnami`

    To deploy the same please follow below steps.
    Add the helm chart repo locally.
    ```
    helm repo add bitnami https://charts.bitnami.com/bitnami

    2. Install the mediawiki with below command. 
    helm install my-release bitnami/mediawiki
    # Read more about the installation in the Bitnami MediaWiki Stack Chart Github repository
    
    Note:
    Above command will install the media wiki on your eks cluster and you need to perform all the task in order to make it up and running.
    It will create LoadBalancer service in aws and using the url you will be able to access the Meidawiki.
    All the username and passowrd need to configure along with host and secrets, pv, pvc with dynamic provision.

# Destroy release and EKS cluster.

  1. destroy release using
     `helm delete <release-name>`

  2. destroy EKS cluster using below command.

    `terraform destroy`
    type Yes and it will destroy the EKS cluster.

    Please make sure after this delete you should verify all the resorces delete proper and no resource is pending in your account which lead to cost.

# Conclusion + Future

1. We can automate helm deployment using terraform
2. create IAM role with required permission to setup EKS cluster.
3. secure way of mamagment of kubeconfig file.
4. Add autoscaler to increase worker node based on the workload.
5. tf state managemnet with s3 backend.
6. Providing access to application.
7. Please read the Mediawiki helm chart which will tell what resources we need in order to deploy the media wiki. You need secrets, pv, pvc , clusterIp svc etc..
8. We can perform blue-green deployment using helm deployment with the help of Jenkins. 
9. For production grade deployment we can make sure we are using Replicaset of deployment and serices from the aws like route53, ssl certoficate and do deployment using ingress and nodeport service.


Work Snippet

Please check the folder 
```
Project-snippet
```
