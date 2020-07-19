# Architecture Image

![alt text](https://github.com/ankushvijay/Solutions/blob/EKS_solutions/eks-architecture.png)


# Module: Demo Platform

Creates an EKS Digital AWS hosting platform.

* Infrastructure as Code using terraform (VPC,Subnets,route tables, nat gateway , internet gw , EKS cluster & node pool , security groups/rules)
* Deployment using helm charts , kubectl CLI . Spinnaker/Jenkins.
* Monitoring can be enabled by deploying metrics server , helm charts of prometheus and grafana in cluster.

## Modules

* networking - it is responsible for creation of networking stack (VPC,Subnets,route tables, nat gateway , internet gw)

## Pre Requisites

* kubectl 
* AWS IAM Authenticator
* Helm2 version 

## Requirements
* Git 
* Terraform Version : ">= 0.12.10"
* AWS provider Version : ">= 2.38.0"
* http provider

## Usage

Step1 ) git clone https://github.com/ankushvijay/Solutions.git

Step2 ) terraform init (To initialise plugins and backend)

Step3 ) terraform plan

Step4 ) terraform apply  

Calling Using Module:

module "platform" {
  source = "https://github.com/ankushvijay/Solutions.git"
  ... 
}



## Parameters
### Required
* vpc_cidr (str): Desired CIDR of the VPC
* aws_region (str): Region to create infrastructure
* environment_name (str): Name of the environment ( NON-PROD , STG , PROD )
* no_of_public_subnet (number): Number of public subnets
* no_of_private_subnet (number): Number of private subnets
* cluster-name (str): Name of the Cluster
* external_ip_addr_cidrs (list): Ips to be whitelisted on Nginx Ingress 


## Optional

## Outputs
* vpc_id (str): The platform VPC ID
* vpc_cidr (str): The platform VPC CIDR block
* public_subnet_ids (list): The public subnet IDs
* private_subnet_ids (list): The private subnet IDs
* cluster_security_group_id (str): Cluster Master security group for accessing from workstations
* vpc_route_table_ids (list): Cluster route tables ids
* config_map_aws_auth (str): Configmap for authentication of worker nodes
* kubeconfig (str): Kubeconfig file to connect via kubectl to EKS cluster

## Deployment of application

1) Approach using terraform

* First we created Dockerfile and build an image 
* Pushed image to registry
* Deployed Nginx-Ingress using helm charts.
* Deployed application yaml  ( deploy , service and ingress rule ) in app namespace

2) This can be done using spinnaker/Jenkins CI/CD tool as well.  


## Application url can be registered for any domain and can be accessed

* This can be tested by accessing url of ELB/ALB

NOTE: This full configuration utilizes the [Terraform http provider](https://www.terraform.io/docs/providers/http/index.html) to call out to icanhazip.com to determine your local workstation external IP for easily configuring EC2 Security Group access to the Kubernetes servers. Feel free to replace this as necessary.
