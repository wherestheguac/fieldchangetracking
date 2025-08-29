# ****Assign Field Change Tracking Admin Permission Set to Current User****
username=$(sfdx force:org:display --json | jq -r '.result.username')
sfdx org:assign:permset --name "Field_Tracking_Administrator" --target-org $username