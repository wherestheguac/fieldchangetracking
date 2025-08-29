# ****Assign Nebula Logger Admin Permission Set to Current User****
username=$(sfdx force:org:display --json | jq -r '.result.username')
sfdx org:assign:permset --name "LoggerAdmin" --target-org $username