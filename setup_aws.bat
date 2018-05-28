echo off
Title AWS
color 2f

REM Check if the ses_email variable is set (Ex: first.last@email.com)
if "%ses_email%"=="" goto error

REM Create the HTML of the email
echo ^<h1^>AWS Users^</h1^> > stats.html
echo ^<pre^> >> stats.html
call aws iam list-users --output text  >> stats.html
echo ^</pre^> >> stats.html

echo ^<h1^>S3 Buckets^</h1^> >> stats.html
echo ^<pre^> >> stats.html
call aws s3 ls  >> stats.html
echo ^</pre^> >> stats.html

echo ^<h1^>Running EC2 Instances^</h1^> >> stats.html
echo ^<pre^> >> stats.html
call aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].[ImageId,Tags[*],State[*]]"  --output text  >> stats.html
echo ^</pre^> >> stats.html

echo ^<h1^>Elasticsearch Domains^</h1^> >> stats.html
echo ^<pre^> >> stats.html
call aws es list-domain-names --output text  >> stats.html
echo ^</pre^> >> stats.html

echo ^<h1^>SQS^</h1^> >> stats.html
echo ^<pre^> >> stats.html
call aws sqs list-queues >> stats.html
echo ^</pre^> >> stats.html

echo ^<h1^>Lambda^</h1^> >> stats.html
echo ^<pre^> >> stats.html
call aws lambda list-functions >> stats.html
echo ^</pre^> >> stats.html


REM Send the email via AWS SES
aws ses send-email --from %ses_email% --to %ses_email% --subject "AWS Setup %date% %time%" --html file://stats.html

goto end

:error
echo Env variable %ses_email% not set to an SES-verified email address

:end