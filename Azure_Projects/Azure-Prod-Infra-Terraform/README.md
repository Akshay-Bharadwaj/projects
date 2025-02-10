# Creating Azure Infrastructure for Production environment using Terraform

![image](https://github.com/user-attachments/assets/537480e7-a6bb-4c63-94bc-154d6d5a7ee8)


- A Resource Group is created to manage the underlying resources
- Virtual network provides a secure boundary for the application
- Virtual machines are deployed into the subnet within the VNet
- VMs are deployed with VMSS (Virtual Machine Scale Set) for the auto scaling policy
- Subnet is created with the Network Security Group (NSG) to allow/deny the specific traffic
- NAT (Network Address Translation) gateway is for routing the traffic from the virtual machines to the internet. It can also be configured in a way to provide SSH access into the VMs from internet on port 22
- The main goal is to route the traffic from internet equally to the VMs using the load balancer
- Since LB is having a private IP within the VNet, it cannot be exposed directly. So, a public IP address is mapped to the LB and exposed to the internet for access on port 80/443

Additional configuration:
- Setting up the auto scaling capacity as,
  default = 2
  minimum = 1
  maximum = 5
- If CPU utilization is > 80%, then add new VMs based on the scale capacity threshold (scale out)
- If CPU utilization is < 10%, then delete VMs (scale in)
