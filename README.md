# AWS-Case-Study-HDX
https://aws.amazon.com/solutions/case-studies/DC-HBX/?did=cr_card&amp;trk=cr_card 





CASE STUDY 1 - HDX
https://aws.amazon.com/solutions/case-studies/DC-HBX/?did=cr_card&trk=cr_card 

COMPANY
DC Health Link, a PPP established by the DC Health Benefit Exchange Authority (HDX)

PROBLEM

1. Commercial off the shelf Software (COTS) annual licensing fees was very high
2. Change Request (modification) costs from $100k to $Millions due to the complexity of the hard-coded software 
3. Product Development takes 6 to 12 months or longer
4. Code upgrade or modification required the entire code to be redeployed
5. During code change or redeployment, marketplace would be offline
6. Customers cannot access the marketplace due to the downtime
7. System capacity was low, resulting in time outs (system was not scalable)

SOLUTION

1. Server migration (on-premise to cloud) - Scalability and High Availability is achieved
2. Switch from COTS (customized softwares) to Open-Source softwares - Millions of $$ saved
3. Leveraged AWS ability to develop softwares and new features rapidly - Time spent is saved and channeled towards productivity
4. AWS meets and exceeds Federal Security & Compliance Standards - $$ spent on government compliance is saved
5. Save costs by leveraging resources on-demand - Challenges of dealing with redundant bare metal components eliminated. Time outs resulting from low system capacity eliminated. $$ saved.
6. Use AWS Marketplace for 3rd party software. - $$ saved
7. Use AWS Partner Network for engaging & retaining qualified software developers - Higher code quality and better software outcome achieved

STRATEGY

1. Adopt Open-Source software standards and Agile Development techniques
2. Shift from capital intensive on-premise model to cloud model
3. Build a platform conducive for shared service model operation

AWS Services/Resources Deployed in the following order:

1. VPC
2. RDS
3. IAM
4. EC2
5. S3
6. MACIE
7. Route 53



VPC and Other NEWORK Resources
We created a Virtual Private Cloud from where we will host the infrastructure to be migrated

CREATING OUR VPC
1. Go to the VPC console and click create VPC
2. Create your subnet
3. Select your subnet, select edit subnet settings from the Actions tab and enable auto-assign public ipv4 address
4. Create your Internet gateway and attach your VPC
5. Create your route table and associate your subnets to your route table
6. Update your routes in your route table
7. Create your security group, allowing ssh on port 22, http on port 80 and MySQL on port 3306

Amazon RDS
We provisioned MySQL RDS to serve as our database collection resource for customers
This database will be enabled for backup to S3

CREATING OUR MySQL RDS
1. Go to the RDS console and click create database
2. Select MySQL and leave the current version as default
3. Choose a template as the case may be:  free tier, production, dev/test
4. Select your deployment options (multi-az etc)
5. Name your DB instance and create a master username and password or leave the default master username “admin” 
6. Select your instance compute spec and storage spec in the Instance configuration and storage section
7. Enable autoscaling (if you want to achieve scalability and performance)
8. In the Connectivity section, select your newly created VPC
9. Select the subnet you created earlier
10. Do not grant public access to your database
11. Select the security group you created earlier
12. Leave the Database port at the default 3306
13. In the Additional configuration section, give your initial database name
14. Enable encryption
15. Create Database and wait for about 5-10mins for it to become active


Amazon IAM
We created an inline policy and a Role so EC2 can access S3

CREATING OUR ROLE FOR EC2 ACCESS TO S3
1. Navigate to IAM console and click Role
2. Search for AmazonS3FullAccess and attach to EC2 resource
3. Save and go to your user tab and click the required user
4. Click security credentials to generate the Security Access keys
5. Download the .csv file to your local machine

Amazon S3
We will deploy S3 as a secure file storage resource.
S3 will be a secure location resource for customer document and RDS MySQL database backup

CREATING OUR S3 BUCKET
1. Navigate to the S3 dashboard, click create bucket  and name your bucket
2. Enable Access Control Lists
3. Disable Block all public access
4. Create bucket

Amazon EC2
We leveraged on the low cost 3rd Party Softwares on Amazon Marketplace (you can also deploy a Wordpress application in your server manually).

CREATING OUR APPLICATION SERVER
1. Go to the EC2 console and click launch instance
2. Name your instance and navigate to Amazon Marketplace under the AMI section
3. Search for your desired AMI under the 3rd Party tab
4. Select your desired application and click the price tab to select your desired compute configuration e.g t2.micro
5. Select your key pair or create one
6. Click edit in your Network settings section and select your provisioned VPC
7. Select your internet facing subnet
8. Select your provisioned security group
9. Select your storage type and size
10. Click Advanced details and select the S3 access role in the IAM instance profile section
11. Scroll to the end and click launch instance
12. SSH into the instance and apply the webapp.sh script to set up our web application.

13. Go to your EC2 console and select your application server
14. SSH into your server and create a directory in your home directory (e.g mkdir /mybucket)
15. CD into the directory and create files e.g touch test1.txt test2.txt test3.txt
16. DONE
17. Any file generated in your listed directory will now be stored in S3.
18. Create an AMI from this server
19. Create a launch template with the AMI
20. Create an auto-scaling group with the launch template
21. Test the newly launched servers


CONFIGURE S3 AS OUR NETWORK FILE STORAGE
1. Go to your EC2 console and select your application server
2. SSH into your server and create a directory in your home directory (e.g mkdir /mybucket)
3. CD into the directory and create files e.g touch test1.txt test2.txt test3.txt
4. sudo amazon-linux-extras install epel
5. sudo yum install s3fs-fuse 
6. echo ACCESS_KEY_ID:SECRET_ACCESS_KEY > ${HOME}/.passwd_s3fs
7. chmod 600 ${HOME}/.passwd_s3fs
8. Apply this command ‘aws configure’ and enter your downloaded Access key and Secret Access Key and hit enter each time.
9. Enter your region when prompted e.g us-east-1
10. Synchronize your S3 bucket with your server with this command: aws s3 sync /path/to/your/file s3://yourbucket e.g aws s3 sync /mybucket s3://hbx-migration
11. Go to your S3 console to confirm the files have been uploaded on S3
12. Apply this command to create a credential file for s3fs: echo $AWS_ACCESS_KEY_ID:$AWS_SECRET_KEY_ID  > $HOME/.passwd_s3fs
13. Apply this command to mount the S3 bucket to your server as a network storage drive:  s3fs YOURBUCKETNAME /THEDIRECTORYYOUCREATED -o passwd_file=${HOME}/.passwd_s3fs -o nonempty
14. DONE
15. Any file generated in your listed directory will now be stored in S3.

Amazon Macie
Here, we will use Amazon Macie as a data security service that discovers sensitive data by using machine learning and pattern matching, provides visibility into data security risks, and enables automated protection against those risks.
This is necessary because of the sensitivity of health records.

STEPS TO SETUP Amazon Macie
1. Create an S3 bucket and upload your data file into your bucket
2. Go to Amazon Macie and click create job
3. Select your S3 bucket and click next
4. Select either a scheduled job or one time job and scroll to the bottom
5. In additional settings, select file extensions and in the big dialogue box below, enter your file extension (e.g .pdf, .csv, .docx,) and click next
6. Click on manage custom identifier tab and create a custom identifier and input a name for your custom identifier
7. In the regular expression section, enter the expression that suits your data set - [a-z]{2}-[0-9]{4}
8. Go back to your previous window tab and refresh to see the newly created custom identifier. Select it and click next
9. Name your job and click submit
10. Wait for about 10mins for the job to be completed
11. The job searches your data based on the custom identifier you set.
12. You can view the summary of all your buckets on the Macie dashboard

Amazon Route 53
1. Click create a hosted zone in route 53
2. Enter your domain name and select public hosted zone type
3. Click create hosted zone
4. Enter your hosted zone and click create record
5. Choose simple routing policy option and hit next
6. Click define simple record
7. Leave the subdomain record name section blank and select A in the record type
8. Choose IP address from the drop down menu in the value/traffic to section
9. Click define simple record.
10. Wait until it is active.

Done!  - enter your domain name on your browser to confirm the website is up and accessible.

Terminate Your Resources

1. Delete your Route 53 record
2. Delete your files first and then the folders before deleting the S3 bucket
3. Terminate your instance
4. Delete your Database
5. Delete your Macie records
6. Dissociate your subnets from your route table
7. Delete IGW from your route table
8. Detach your IGW from your VPC
9. Delete your subnets
10. Delete your security groups
11. Delete your VPC
12. Done 
