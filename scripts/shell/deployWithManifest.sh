# ****Nebula Logger Unlocked Package****
sf package install --wait 20 --security-type AdminsOnly --package 04tKe0000011N4KIAU --no-prompt

# ****Assign Nebula Logger Admin Permission Set to Current User****
sf org assign permset --name "LoggerAdmin"

# ****Set Remove Global Value Sets From Picklist Fields Flag****
export REMOVE_GLOBAL_VALUE_SETS=false

# ****Deploy Source to Org Using Manifest****
sf project deploy start --manifest manifest/package.xml --ignore-conflicts

# ****Assign Field Change Tracking Admin Permission Set to Current User****
sf org assign permset --name "Field_Tracking_Administrator"