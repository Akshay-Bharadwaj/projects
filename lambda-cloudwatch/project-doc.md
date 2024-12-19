1. Tested the default lambda function and generated a test event

![image](https://github.com/user-attachments/assets/2fc0a651-9ad4-4bd6-9c0f-a56409e51431)

2. Created event rule to integrate with CloudWatch

![image](https://github.com/user-attachments/assets/c2765836-152e-4ca1-a536-e9daef18eef4)

3. Wrote a lambda function to modify the volume type

![image](https://github.com/user-attachments/assets/6abb8643-294f-4bae-afc9-087dc2d65569)

4. Created a volume of type gp2 to make event rule to trigger the lambda function

![image](https://github.com/user-attachments/assets/81f376c0-de8e-4fbd-97d2-fa43199b14c8)

5. IAM policy is added to modify the EBS volume type

6. Logs are recorded in the CloudWatch event log groups

![image](https://github.com/user-attachments/assets/a7d0bcc9-cd51-4262-9891-11ab9e9887d2)

7. Lambda function changes the volume type to gp3

![image](https://github.com/user-attachments/assets/c63012b6-b9c7-4d59-a2bb-a5203aded07f)

































