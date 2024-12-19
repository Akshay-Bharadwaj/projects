# Automating AWS Infrastructure with Terraform

Overview:
- The goal is to deploy instances inside subnets in a VPC and route the traffic from outside to them using a load balancer
- Instead of manually creating the resources, an IaC tool, Terraform is used

![image](https://github.com/user-attachments/assets/36b75afa-b16b-4b47-803f-8bdf43561093)

1. Created IAM user and access keys
2. Configured AWS in terminal and installed terraform
3. Created providers.tf file to declare the cloud providers required for managing infrastructure
4. Initialized directory for working with terraform by running terraform init
5. Created main.tf which holds the infrastucture configuration with module imports and variables
6. Created variables.tf file to configure the variables used inside main.tf file. This reduces the hard-coded values which are mentioned multiple times
7. In main.tf, created,
   - VPC network
   - Two public subnets with EC2 instance deployed in each subnet
   - Userdata.sh is a shell based html file deployed inside instances which are exposed to the 
     public
   - S3 bucket connected to the instances to store the files as objects
   - Internet Gateway with specific route table and instances are target group to route the 
     traffic from outside
   - Security group to configure inbound and outbound rules of the traffic
   - Application load balancer to route the traffic to both instances
   - ALB listener to make a connection between load balancer and the target group so that load 
     balancer knows where it is routing the traffic
   - Output field to display the DNS created for the load balancer. Through this DNS namme, 
     the application (userdata.sh) can be accessed
   - For every hit on the browser, the load balancer routes the traffic to different servers
8. Checked the configuration and debugged the errors
9. Planned the required resources to be created for the given configuration
10. Created the resources and checked in console


![image](https://github.com/user-attachments/assets/3ae766ee-b4f1-4256-b514-ce3ba162a629)

![image](https://github.com/user-attachments/assets/4f60c263-b8b6-4b27-bf0e-924476e3f62a)

![image](https://github.com/user-attachments/assets/8acc84be-0375-408c-bfb3-b7fc01811674)

![image](https://github.com/user-attachments/assets/278d5b03-323c-48c4-8bbd-a5796ca9167f)

![image](https://github.com/user-attachments/assets/9cd00558-d5fe-4e50-b530-e3d609a8db65)

![image](https://github.com/user-attachments/assets/e84c8dd0-583b-4ef6-8eb3-9aa91c09480e)

![image](https://github.com/user-attachments/assets/2f904780-769c-4102-b500-06c2a1abbcab)

![image](https://github.com/user-attachments/assets/dcfe0702-869a-4468-b10e-70c4c84539de)

![image](https://github.com/user-attachments/assets/bfe6ed30-63d7-4aa3-9421-6842b4b4c3a5)

![image](https://github.com/user-attachments/assets/7b39404e-5199-4c2e-9c09-510585fcb23f)

![image](https://github.com/user-attachments/assets/c6eb5a13-0fea-4a22-af22-eaf00b18e938)

![image](https://github.com/user-attachments/assets/e600cdaa-002b-4edf-baea-7032923925d2)

![image](https://github.com/user-attachments/assets/773bd212-530b-4442-a54e-2bf40550aa41)

![image](https://github.com/user-attachments/assets/df8fc413-32e0-4457-b71e-a2772d8d6b09)

![image](https://github.com/user-attachments/assets/848b7648-dbab-4a32-a607-c23f879e7912)

