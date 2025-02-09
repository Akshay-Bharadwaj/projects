# Project Overview
![image](https://github.com/user-attachments/assets/9727ccf6-6f6a-42cc-b62d-101a5dd5b138)


- A critical static website is deployed and hosted in a virtual machine
- Virtual machine is securely deployed inside a subnet in a Virtual network
- Virtual network is backed by the Azure firewall for securely allowing/denying certain users into the subnet for accessing VM
- A Firewall policy is created with a firewall rule to allow specific IPs on specific port from outside to access
- Since VM is inside a private subnet, a SSH connection cannot be made directly
- For this, a bastion host is created and a secure SSH connection on port 22 is made
