delete [
    SELECT Id
    FROM PermissionSetAssignment
    WHERE PermissionSet.Name='Field_Tracking_Administrator'
];