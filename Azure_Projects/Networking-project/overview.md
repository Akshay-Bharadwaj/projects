# Project Overview
![image](https://github.com/user-attachments/assets/9727ccf6-6f6a-42cc-b62d-101a5dd5b138)


- A critical static website is deployed and hosted in a virtual machine
- Virtual machine is securely deployed inside a subnet in a Virtual network
- Virtual network is backed by the Azure firewall for securely allowing/denying certain users into the subnet for accessing VM
- A Firewall policy is created with a firewall rule to allow specific IPs on specific port from outside to access
- Since VM is inside a private subnet, a SSH connection cannot be made directly
- For this, a bastion host is created and a secure SSH connection on port 22 is made


# Documentation

![image](https://github.com/user-attachments/assets/d333c06e-6e0f-4d71-85df-1dd5b8d461a2)

![image](https://github.com/user-attachments/assets/51ea5995-e25b-4fb0-87b5-aeab789b373d)

![image](https://github.com/user-attachments/assets/33621f6f-2c08-4436-ad90-40067b029a44)

![image](https://github.com/user-attachments/assets/24f4e5eb-3b56-46fd-9eff-e7cf010db12f)

![image](https://github.com/user-attachments/assets/294030dd-cb18-4d06-b767-c1c6f45e6adb)

![image](https://github.com/user-attachments/assets/963d9019-71ff-41ad-a5d2-d67c6ec9cdcf)




