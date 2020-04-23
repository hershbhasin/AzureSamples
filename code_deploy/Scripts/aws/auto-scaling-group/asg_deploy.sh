
#!/bin/bash

export service_role_name=hb-service-role-for-codedeploy-toread-ec2tags
export code_deploy_application_name=ASG_HelloWorld_App
export s3_location=s3://hb-deploy/HelloWorld_App.zip

#deployment group
export deployment_group_name=ASG_HelloWorld_DepGroup
export deployment_config_name=CodeDeployDefault.OneAtATime
export asg_name=hb_win_asg

#deployment
export s3_bucket_name=hb-deploy
export zip_name=HelloWorld_App.zip

#cd to the folder where the application zip resides
cd ~/Documents/_courses/win/code/HelloWorldApp

# register a new application  with CodeDeploy
aws deploy create-application --application-name $code_deploy_application_name

#push  the application to s3
aws deploy push --application-name $code_deploy_application_name --s3-location $s3_location --ignore-hidden-files

#get service role arn
export service_role_arn=$(aws iam get-role --role-name $service_role_name --query "Role.Arn" --output text)
echo $service_role_arn

#create deployment group
aws deploy create-deployment-group \
--application-name $code_deploy_application_name \
--auto-scaling-groups $asg_name \
--deployment-group-name $deployment_group_name \
--deployment-config-name $deployment_config_name \
--service-role-arn $service_role_arn

# Create a deployment
aws deploy create-deployment \
--application-name $code_deploy_application_name \
--deployment-config-name $deployment_config_name \
--deployment-group-name $deployment_group_name \
--s3-location bucket=$s3_bucket_name,bundleType=zip,key=$zip_name


