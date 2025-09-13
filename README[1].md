# Bastion Host Setup – Secure Access to Private Infrastructure

## Project Objective
The purpose of this project is to implement a Bastion Host that acts as a secure gateway between external users and internal servers.  
This ensures that sensitive infrastructure remains isolated from the public internet while still being accessible to authorized users.

---

## Architecture Overview
The setup consists of two servers hosted on a cloud provider (AWS used here):

1. Bastion Host – A public-facing instance with SSH access.  
2. Private Server – No public IP, accessible only through the Bastion Host.  

### Connection Flow
```
[ My Laptop ] ---> [ Bastion Host (Public IP) ] ---> [ Private Server (Private IP) ]
```

---

## Implementation Steps

### 1. Infrastructure Setup
- Launched two EC2 instances on AWS (Ubuntu 22.04 LTS).
- Configured networking:
  - Bastion Host → Public Subnet (with Internet Gateway).
  - Private Server → Private Subnet (no direct internet access).

---

### 2. Security Groups / Firewall
- Bastion Host Security Group
  - Inbound: SSH (22) allowed only from my laptop’s IP.
- Private Server Security Group
  - Inbound: SSH (22) allowed only from Bastion Host’s private IP.

This approach minimizes the attack surface while enabling controlled access.

---

### 3. SSH Key Management
- Generated SSH key pair locally:
  ```bash
  ssh-keygen -t rsa -b 4096
  ```
- Deployed the public key to both servers (`~/.ssh/authorized_keys`).
- Stored private key securely on my laptop.

---

### 4. SSH Client Configuration
File: `~/.ssh/config`

```ssh
Host bastion
    HostName <bastion-public-ip>
    User ubuntu
    IdentityFile ~/.ssh/bastion.pem

Host private-server
    HostName <private-server-private-ip>
    User ubuntu
    ProxyJump bastion
    IdentityFile ~/.ssh/private.pem
```

---

### 5. Connection Workflow
- Connect to Bastion Host:
  ```bash
  ssh bastion
  ```
- From Bastion Host → Private Server:
  ```bash
  ssh private-server
  ```
- Or connect directly (ProxyJump):
  ```bash
  ssh private-server
  ```

---

## Security Hardening (Beyond Basics)
- Installed Fail2Ban on Bastion Host to block brute force attempts:
  ```bash
  sudo apt update && sudo apt install fail2ban -y
  ```
- Configured iptables rules to restrict access further.
- Enabled MFA (Google Authenticator) for SSH login.
- Centralized logging to monitor SSH attempts.

---

## Future Improvements
- Automation: Provision bastion + private server using Terraform/Ansible.  
- Scaling: Replace single Bastion Host with an Auto Scaling group and Elastic IP.  
- Auditing: Integrate with CloudWatch for real-time monitoring.  

---

## Key Takeaways
- A Bastion Host acts as the single, well-secured entry point into private infrastructure.  
- It reduces exposure of internal resources by enforcing controlled and auditable access.  
- This setup is portable across AWS, GCP, Azure, and other cloud providers.

---

Authored by Laxmipriya  
*(This README excludes sensitive details such as actual IPs and private keys as per best practices.)*
