# Generate userdata script file
$scriptFileName = "server.sh"
$userDataFile = [IO.Path]::GetTempFileName()
[string]::Join( "`n", (gc $scriptFileName)) -replace "#AWS_ACCESS_KEY#", "$env:AWS_ACCESS_KEY" -replace "#AWS_SECRET_KEY#", "$env:AWS_SECRET_KEY" | sc $userDataFile


# Launch EC2 Instance with userdata script
ec2run ami-b6df4e8c --group "sg-5ee1f332" --subnet "subnet-2272ab4b" --instance-type  "t1.micro" --key "ameer" --user-data-file "$userDataFile"

# Delete User Data file
if (Test-Path($userDataFile)) { rm $userDataFile  }
 
