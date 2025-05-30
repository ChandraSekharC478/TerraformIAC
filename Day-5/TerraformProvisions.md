# Terraform VPC Infrastructure with Flask App Deployment

This project provisions a basic AWS infrastructure using **Terraform** and deploys a sample **Python Flask application** on an EC2 instance using **provisioners**.

---

## 🔧 Purpose

This setup is a **common DevOps workflow**, typically triggered automatically via a **CI/CD pipeline** once the developer pushes code to the repository. The pipeline executes Terraform, provisions the AWS resources, and deploys the application.

In this example:
- We **manually provision** the infrastructure using Terraform.
- We **use provisioners** to copy a Python Flask file and run it on an EC2 instance.
- You can access the Flask app using the **public IP** of the EC2 instance on **port 80**.

---

## 🛠️ AWS Resources Created

| Resource Type            | Name                  | Purpose |
|--------------------------|-----------------------|---------|
| `aws_vpc`                | `myvpc`               | Creates a Virtual Private Cloud |
| `aws_subnet`             | `mysubnet`            | Subnet inside the VPC for EC2 |
| `aws_internet_gateway`   | `myigw`               | Enables internet access |
| `aws_route_table`        | `myroute`             | Routing for outbound traffic to IGW |
| `aws_route_table_association` | `rta1`          | Associates subnet with route table |
| `aws_security_group`     | `mysecgroup`          | Opens port 22 (SSH) and 80 (HTTP) |
| `aws_instance`           | `terraformProviders`  | Ubuntu EC2 instance running Flask |

---

## 🔗 Flowchart of Resource Dependencies

```markdown
VPC
│
├──> Subnet
│    └── uses → VPC ID
│
├──> Internet Gateway
│    └── attaches to → VPC
│
├──> Route Table
│    └── connected to → Internet Gateway
│
└──> Route Table Association
     └── connects → Subnet ↔ Route Table

Subnet
│
└──> EC2 Instance
     ├── uses → Subnet ID
     ├── uses → Security Group
     └── connects → public via IGW

Security Group
└── allows:
    ├── SSH (port 22)
    └── HTTP (port 80)

EC2 Provisioners
├── File Provisioner: Copies `app.py`
└── Remote Exec: Installs Python, Flask and starts the app
```

---

## 🚀 Flask App Deployment (via Provisioners)

Terraform uses **provisioners** to:
1. SSH into the EC2 instance
2. Copy the `app.py` file
3. Install Python dependencies
4. Run the Flask app in the background

Example `app.py`:
```python
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello from Flask on EC2!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
```

---

## 📦 How to Deploy

1. **Ensure pre-requisites**:
   - Terraform installed
   - AWS CLI configured
   - `webserverforawsdemo.pem` key in project folder
   - `app.py` in same directory

2. **Run Terraform**:
```bash
terraform init
terraform apply -auto-approve
```

3. **Access the App**:
   - Copy the output `public_ip` from Terraform.
   - Open your browser: `http://<public_ip>`

---

## 🔐 Security Notes

- Only allow SSH from your public IP in `Security Group`
- Never expose `.pem` keys publicly
- Ensure `app.py` listens on `0.0.0.0` and port `80`

---

## ✅ Real-World Use Case

In production, the same process is automated via CI/CD pipelines (e.g., GitHub Actions, GitLab, Jenkins):

```text
Code Push → CI/CD Pipeline Trigger → Terraform Apply → EC2 Instance Provisioned → App Deployed via Provisioners
```

---

## 🧹 Cleanup

To destroy resources:
```bash
terraform destroy -auto-approve
```

---

## 📁 Folder Structure

```
.
├── app.py
├── main.tf
├── variables.tf (optional)
├── webserverforawsdemo.pem
└── README.md
```

---

## 📘 Summary

This project gives a practical example of using Terraform to:
- Provision VPC and EC2 infrastructure
- Deploy a Python app with no manual SSH
- Simulate CI/CD deployment via provisioners

Perfect for interviews, demos, and real-world DevOps learning!