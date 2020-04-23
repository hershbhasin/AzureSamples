
#!/bin/bash

export service_role_name=hb-service-role-for-codedeploy-toread-ec2tags
export code_deploy_application_name=HelloWorld_App
export tag_value=CodeDeployDemo

#deployment group
export deployment_group_name=HelloWorld_DepGroup
export deployment_config_name=CodeDeployDefault.OneAtATime

#deployment
export s3_bucket_name=hb-deploy
export zip_name=HelloWorld_App.zip


#get service role arn
export service_role_arn=$(aws iam get-role --role-name $service_role_name --query "Role.Arn" --output text)

echo $service_role_arn

#create deployment group
aws deploy create-deployment-group --application-name $code_deploy_application_name --deployment-group-name $deployment_group_name --deployment-config-name $deployment_config_name --ec2-tag-filters Key=Name,Value=$tag_value,Type=KEY_AND_VALUE --service-role-arn $service_role_arn

# Create a deployment
aws deploy create-deployment --application-name $code_deploy_application_name --deployment-config-name $deployment_config_name --deployment-group-name $deployment_group_name --s3-location bucket=$s3_bucket_name,bundleType=zip,key=$zip_name
