Project Overview:

Current System Setup:
- The company utilizes the ELK stack (Elasticsearch, Logstash, Kibana) for search, analysis, and visualization of server data and logs.
- Jenkins is used for building projects, and it logs substantial amounts of data into the ELK stack, leading to increased costs.

Challenges Faced:
- Developers primarily use ELK for log storage and backup, but it is not an efficient use of resources.
- The ELK stack is being overloaded with Jenkins log data, contributing to high operational costs.
- Jenkins already sends notifications and emails to developers, making the ELK stack's role redundant for log management.

Optimization Goal:
- To reduce costs associated with storing Jenkins log files on the ELK stack, while still maintaining easy access and long-term backup.

Solution Implemented:
- Jenkins server is integrated directly with an Amazon S3 bucket for storing log files instead of using ELK.
- S3 Glacier Deep Archive is selected for log storage due to its cost-effectiveness and ability to store large volumes of data.

Automation of Log Management:
- A shell script is written within Jenkins to automatically retrieve log files from each build/job.
- The logs are uploaded to the S3 bucket after each build, ensuring they are securely backed up without overloading the ELK system.

Impact and Benefits:
- The cost of storing Jenkins log data is reduced by at least 50%, generating significant savings for the company.
- This solution optimizes the workload, ensuring Jenkins only handles essential tasks while offloading log storage to S3 Glacier.
- The integration simplifies the data lifecycle management and improves overall efficiency.

Final Outcome:
- The company achieves a more cost-effective, scalable, and efficient system for log management, reducing unnecessary resource usage while still maintaining robust log storage and backup solutions.
