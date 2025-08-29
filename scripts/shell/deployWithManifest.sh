# ****Deploy Source to Org Using Manifest****
username=$(sfdx force:org:display --json | jq -r '.result.username')
sf project deploy start --manifest manifest/package.xml --target-org $username