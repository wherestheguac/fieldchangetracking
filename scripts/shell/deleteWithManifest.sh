# ****Unassign Field Change Tracking Admin Permission Set****
sf apex run --file scripts/apex/unassignFieldTrackingPermissionSet.apex

# ****Run Full Package Delete****
sf project deploy start --manifest manifest/empty.xml --pre-destructive-changes manifest/package.xml --purge-on-delete --ignore-conflicts --ignore-warnings --ignore-errors

# ****Unassign Nebula Logger Permission Set****
sf apex run --file scripts/apex/unassignNebulaLoggerPermissionSet.apex

# ****Uninstall Nebula Logger Package****
sf package uninstall --package 04tKe0000011N4KIAU