username=$(sfdx force:org:display --json | jq -r '.result.username')
sf project deploy start --manifest manifest/empty.xml --pre-destructive-changes manifest/destructiveChanges1.xml --target-org $username --ignore-conflicts
sf project deploy start --manifest manifest/empty.xml --pre-destructive-changes manifest/destructiveChanges2.xml --target-org $username --ignore-conflicts