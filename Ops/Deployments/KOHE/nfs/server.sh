#!/bin/bash -ex

# -----------------------------------------------------------------------------
# Variable Declarations
# -----------------------------------------------------------------------------

export AWS_ACCESS_KEY=#AWS_ACCESS_KEY#
export AWS_SECRET_KEY=#AWS_SECRET_KEY#
export EC2_URL=ec2.ap-southeast-2.amazonaws.com
export INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
export PATH=$PATH:/opt/aws/bin

export VOLUME_ID=vol-c4c352f7
export DEVICE_ID=/dev/sdf

 . /etc/bashrc
 
# -----------------------------------------------------------------------------
# Include the following line to log userdata 
# output to the Amazon EC2 Console output 
# -----------------------------------------------------------------------------
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Attach volume and wait for attachment to complete
ec2-attach-volume $VOLUME_ID -i $INSTANCE_ID -d $DEVICE_ID

export ATTACHMENT_STATUS=''
while [ "$ATTACHMENT_STATUS" != "attached" ]
do
	# Attach volume using EC2 API Tools
	export ATTACHMENT_STATUS=$(ec2-describe-volumes vol-c4c352f7 | grep "ATTACHMENT" | awk {'print $5'})
	echo "Status=$ATTACHMENT_STATUS"
	
	# Sleep and wait for attanment to complete
	echo "Waiting for attachment to complete...Sleep 5 seconds"
	sleep 5
done

# Format volume
#mkfs.ext3 /dev/sdf 

#Mount Volume
mkdir -p /mnt/myvol
mount /dev/sdf /mnt/myvol
df -kh

# Install NFS server
yum -y install nfs-utils nfs-utils-lib
chkconfig --levels 235 nfs on /etc/init.d/nfs start

