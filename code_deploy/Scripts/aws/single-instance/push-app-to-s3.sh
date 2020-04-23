#!/bin/bash
export code_deploy_application_name=HelloWorld_App
export s3_location=s3://hb-deploy/HelloWorld_App.zip

#cd to the folder where the application zip resides
cd ~/Documents/_courses/win/code/HelloWorldApp

# register a new application named HelloWorld_App with CodeDeploy

aws deploy create-application --application-name $code_deploy_application_name


#push  the application to s3

aws deploy push --application-name $code_deploy_application_name --s3-location $s3_location --ignore-hidden-files
