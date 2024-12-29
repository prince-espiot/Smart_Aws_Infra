# Smart_Aws_Infra

## Description 
The Smart_Aws_Infra project offers a robust and integrated solution for deploying, monitoring, and managing Kubernetes clusters using GitOps principles. This infrastructure setup comes pre-configured with essential tools for seamless deployment, comprehensive monitoring, and efficient GitOps workflows. By leveraging AWS services and popular open-source tools, Smart_Aws_Infra ensures a scalable, reliable, and automated environment for your Kubernetes applications.


<p align="center">

## AWS Services and Tools

</p>

<p align="center">

| AWS Services | Tools Included |
|--------------|----------------|
| EKS          | Prometheus     |
| EC2          | Grafana        |
| VPC          | ArgoCD         |
| ACM          | Helm           |
| Route53      |                |
| S3           |                |
| ALB          |                |

</p>



## Architecture
<p align="center">
  <img src="smartinfra.gif" alt="Architecture Diagram">
</p>

## Steps
### Infrastructure Provision 
1. **Configure Terraform Variables**
  - Edit the `terraform.tfvars` file with custom parameters as needed.

2. **Initialize Terraform**
  - Run the following command to initialize the Terraform configuration:
    ```sh
    terraform init
    ```

3. **Plan the Infrastructure**
  - Generate and review the execution plan for the infrastructure:
    ```sh
    terraform plan
    ```

4. **Apply the Configuration**
  - Apply the Terraform configuration to provision the infrastructure:
    ```sh
    terraform apply -auto-approve
    ```

5. **Access the Bastion Host**
  - After the infrastructure is provisioned, use the output parameters to log in to your bastion host via ssh.

### AWS CLI Configuration
6. **Configure AWS CLI**
  - Run the following command to configure your AWS CLI with your access key and secret access key:
    ```sh
    aws configure
    ```

### Update Kubeconfig for EKS Cluster
7. **Update Kubeconfig**
  - Run the following command to update your kubeconfig file with the EKS cluster details:
    ```sh
    aws eks update-kubeconfig --name <name-of-cluster> --region <region>
    ```

 
 
 ## Note 
**Note:** It doesn't automatically attach to the StorageClass, so you have to edit the respective PV and the default storage class and add `gp2`.

 ## Manual step

