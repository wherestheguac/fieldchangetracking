delete [
    SELECT Id
    FROM PermissionSetAssignment
    WHERE PermissionSet.Name='LoggerAdmin'
];