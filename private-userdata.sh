#!/bin/bash
apt-get update -y
apt-get install -y htop
useradd -m -s /bin/bash assessor || true
mkdir -p /home/assessor/.ssh
chown -R assessor:assessor /home/assessor/.ssh
