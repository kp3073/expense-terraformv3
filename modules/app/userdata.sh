#!/bin/bash

dnf install ansible python3.11-pip.noarch -y | tee -a /opt/userdata.log
pip3.11 install botocore boto3 | tee -a /opt/userdata.log
ansible-pull -i localhost, -U https://github.com/kp3073/Expense-ansible main.yml -e role_name=${role_name} | tee -a /opt/userdata.log