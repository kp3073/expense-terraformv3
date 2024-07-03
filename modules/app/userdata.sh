#!/bin/bash

dnf install python3.11-pip ansible -y
pip3.11 install boto3 botocore
ansible-pull -i localhost, -U https://github.com/kp3073/Expense-ansible main.yml -e role_name=${role_name}