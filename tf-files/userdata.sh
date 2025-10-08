#! /bin/bash
dnf update -y
dnf install pip -y  
pip3 install flask==2.3.3
pip3 install flask_mysql
dnf install git -y
TOKEN=${user-data-git-token}
USER=${user-data-git-name}
cd /home/ec2-user && git clone https://$TOKEN@github.com/$USER/phonebook.git

# Export all database credentials as environment variables for security
export MYSQL_DATABASE_HOST=${db-endpoint}
export MYSQL_DATABASE_USER=${db-user}
export MYSQL_DATABASE_PASSWORD=${db-password}
export MYSQL_DATABASE_DB=${db-name}
export MYSQL_DATABASE_PORT=3306

python3 /home/ec2-user/phonebook/phonebook-app.py