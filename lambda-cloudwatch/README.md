# Integrating cloud watch to trigger lambda function

Overview:
Triggering lambda function when an EBS volume is created. CloudWatch event is created to monitor and respond to the EBS volume created.

Goal:
When an EBS volume of type gp2 (General purpose volume) is created, the CloudWatch event rule should trigger the lambda function to change the volume type to gp3.

