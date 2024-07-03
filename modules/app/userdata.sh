#!/bin/bash

dnf install python3.11 -y
pip3 install boto3 botocore -y
ansible-pull -i localhost -U https://github.com/kp3073/Expense-ansible main.yml -e role_name=${role_name}