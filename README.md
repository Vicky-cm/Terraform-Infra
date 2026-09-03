# 🚀 Building an AWS EC2 Web Server with Terraform

Infrastructure provisioning is often the first place where DevOps engineers start moving away from manual work and towards automation. For this project, I built a simple AWS web server environment using **Terraform** to understand how Infrastructure as Code works in a practical scenario.

The objective was straightforward: create the required AWS infrastructure, launch an EC2 instance, install Nginx automatically, and make the application accessible through the internet — all without manually creating the infrastructure through the AWS Console.

I started by configuring the **AWS provider** in `provider.tf`. This tells Terraform which cloud platform it needs to communicate with and which AWS region should be used for the deployment.

Next, I created `variables.tf` to define the configurable values required by the infrastructure, such as the AWS region, EC2 instance type, and AMI ID. Instead of hardcoding these values throughout the configuration, I supplied them through `terraform.tfvars`. This makes the configuration cleaner and easier to modify.

Once the basic Terraform configuration was ready, I moved on to building the AWS networking layer. I created a **VPC** to provide an isolated network environment for the application. Inside the VPC, I created a **public subnet** where the EC2 instance would be deployed.

To provide internet connectivity to the VPC, I created an **Internet Gateway** and connected it to the VPC. I then configured a **route table** with a default route pointing internet-bound traffic towards the Internet Gateway and associated the route table with the public subnet.

With the networking layer in place, the next step was to control access to the EC2 instance. I created a **Security Group** and configured inbound rules for HTTP traffic on port 80 and SSH traffic on port 22. This allowed web traffic to reach the Nginx server while also providing SSH access for administration during the learning process.

After preparing the network and security configuration, I created the **EC2 instance** using the selected AMI and instance type. The instance was placed inside the public subnet and associated with the security group.

One of the most useful parts of this project was automating the server configuration. Instead of manually connecting to the EC2 instance and installing Nginx, I used **EC2 user data**. During instance startup, the script installs Nginx, enables the service, starts it, and creates a simple HTML page.

This means the server goes from a fresh EC2 instance to a functioning web server automatically as part of the Terraform deployment.

I also added Terraform **outputs** to display useful information after deployment, such as the EC2 instance ID and public IP address. The public IP can then be used to access the Nginx web server from a browser.

Before deploying the infrastructure, I followed the standard Terraform workflow:

`terraform init` to initialize the project and download the required provider, followed by `terraform fmt` to format the configuration and `terraform validate` to check that the configuration was valid.

I then used `terraform plan` to review what Terraform was going to create before making any changes to AWS. Once everything looked correct, I ran `terraform apply` and allowed Terraform to provision the infrastructure.

After the deployment completed, I accessed the EC2 public IP through a browser and verified that the Nginx page was running successfully.

Finally, after completing the testing, I used `terraform destroy` to remove the infrastructure created by Terraform. This is particularly useful when working with AWS during practice because it prevents unnecessary resources from continuing to run.

This project gave me practical experience with Terraform's core concepts — providers, resources, variables, outputs, state, dependencies, and the Terraform workflow — while also helping me understand how AWS networking and EC2 provisioning fit together.

The biggest takeaway from this project was understanding the difference between manually creating infrastructure and defining infrastructure as code. Instead of repeatedly clicking through the AWS Console, the entire environment can now be recreated from Terraform configuration.

**This is a small project, but it provided a solid foundation for understanding how Terraform can be used to automate cloud infrastructure.**
