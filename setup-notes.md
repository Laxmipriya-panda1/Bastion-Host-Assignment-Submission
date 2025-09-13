Setup Notes:

1. Create or import an EC2 keypair in AWS (named in terraform.tfvars key_name).
2. Update terraform/terraform.tfvars with your admin_cidr and key_name.
3. From terraform/ directory:
   terraform init
   terraform plan -out tfplan
   terraform apply tfplan

4. After apply, get outputs:
   terraform output bastion_public_ip
   terraform output private_ip

5. Update ~/.ssh/config using ssh-config-example and replace placeholders.
6. Connect:
   ssh bastion
   ssh private-server

7. When done, destroy infrastructure:
   terraform destroy
