#This powershell is used in the userdata section of ec2 
#to install code deploy agent
<powershell>
Set-ExecutionPolicy RemoteSigned -Force 
 Import-Module AWSPowerShell
 New-Item -Path "c:\temp" -ItemType "directory" -Force
 powershell.exe -Command Read-S3Object -BucketName aws-codedeploy-us-east-1 -Key latest/codedeploy-agent.msi -File c:\temp\codedeploy-agent.msi
 c:\temp\codedeploy-agent.msi /quiet /l c:\temp\host-agent-install-log.txt
</powershell>
