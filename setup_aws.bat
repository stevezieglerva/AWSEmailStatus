echo off
Title AWS
color 2f

if "%ses_email%"=="" goto error


echo *** > stats.txt
echo *** AWS Users >> stats.txt
call aws iam list-users --output text  >> stats.txt

echo ***  >> stats.txt
echo *** S3 Buckets  >> stats.txt
call aws s3 ls  >> stats.txt

echo ***  >> stats.txt
echo *** Running EC2 instance  >> stats.txt
call aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].[ImageId,Tags[*],State[*]]"  --output text  >> stats.txt

echo ***  >> stats.txt
echo *** Elasticsearch Domains  >> stats.txt
call aws es list-domain-names --output text  >> stats.txt


aws ses send-email --from %ses_email% --to %ses_email% --subject "Testing %date% %time%" --text file://stats.txt

goto end

:error
echo Env variable %ses_email% not set to an SES-verified email address

:end