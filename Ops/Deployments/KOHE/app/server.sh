#!/bin/bash -ex
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Install HTTP, GIT
yum -y install httpd git rubygems
/etc/init.d/httpd start

# Install Ruby AWS SDK
gem install aws_sdk --no-ri --no-rdoc

# Create web user and depoy app via git
useradd webapps
cd ~webapps
git clone git://github.com/writeameer/moodle.git
