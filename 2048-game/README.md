# Kubernetes End to End project on EKS

Overview: 
- Deploying 2048 game on EKS using Ingress resource
- Enable outside traffic onto the application

Steps:
1.	Installed the required dependencies like kubectl, minikube, eksctl, awscli
2.	Configured AWS cli using access and secret access keys

![image](https://github.com/user-attachments/assets/b206342e-0fd3-4199-85ee-d4f9ecffdbd8)

3. Created EKS cluster

![image](https://github.com/user-attachments/assets/77b17b81-3740-4518-be40-acbe5944aadd)

4.	Updated the kubeconfig (a configuration file which has cluster info, users, namespaces in which pods are deployed etc.) to manage the eks cluster
5.	Created fargate profile, which is a serverless compute to run the containers without managing the underlying infrastructure, under a new namespace

![image](https://github.com/user-attachments/assets/a1256d41-a6ed-4510-bab3-92b5489e1a7f)

- By default, fargate profiles will be created which inturn automatically creates pods and manages clusters under the default namespace

6.	Create deployment, service and ingress
- Under new namespace of fargate, the deployment is created with replica sets. This enables auto-healing i.e. when a pod goes down, another pod will be created matching the count of replica sets. Service under this namespace is created so that, it allocates labels and selectors to match the resources with the pods and avoids mismatch of the IPs when gone down. Ingress resource under this namespace, matches the service which inturn matches with the deployment created. So ingress resource works with the pods created in this namespace 
- Ingress resource is used to expose the application to the outside HTTP traffic
- Pod deployed inside a VPC with service can be exposed on cluster IP, node port or load balancer. In cluster IP mode, either master or slave nodes inside the subnet or VPC can access the pod. In node port, users having the access to the node IP inside that network can access. To enable access from outside, load balancer mode is used but it is more expensive when applications and traffic are increased
- So, ingress resource is used to create an application load balancer (ALB)

![image](https://github.com/user-attachments/assets/a1256d41-a6ed-4510-bab3-92b5489e1a7f)
  
- Here, address is not allocated for the ingress resource because ALB is not created. Ingress resource wont create ALB, but an ingress controller will create

7.	Created IAM OIDC connector. It is like providing role with IAM policies for the ALB(here ingress controller) to access AWS services
8.	Created a service account and set up IAM policies and attached to it to access particular services
- The above two steps are similar to giving IAM role to the EC2 instance to access other AWS services like S3, Lambda, DynamoDB etc.

![image](https://github.com/user-attachments/assets/b8c64e12-73c4-4da4-83da-1c9c65a90b44)

9.	Create the ALB (ingress controller) using Helm charts to allow external access of application for the users. Two will be created in individual availability zones

![image](https://github.com/user-attachments/assets/310d2a6f-dc15-4394-8a58-3c9cbce05baa)

- Helm charts are collection of files or packages that describe the kubernetes resources. It helps in managing kubernetes manifests with templates, variables and dependencies

![image](https://github.com/user-attachments/assets/6411f894-e742-47dc-9e28-18462c6a27d9)

10. The created resources are lined up on Cloud formation stack

![image](https://github.com/user-attachments/assets/ca7eed3b-9066-48f5-9ec0-aacdbb49bd1b)

- Cloud formation stack is the collection of resources which can be created, updated or deleted collectively

11. Checked the created resources via command line

![image](https://github.com/user-attachments/assets/22ea2a93-229b-4786-82dc-b5711865bb89)

12. The ALB created by the ingress controller is provided with a DNS name, through which the application can be accessed externally

![image](https://github.com/user-attachments/assets/1f0e995e-aa9b-4292-a6b2-62ff450250d9)

![image](https://github.com/user-attachments/assets/d3e50f96-cfb5-4d37-a1f9-b82f33bc5d7a)



