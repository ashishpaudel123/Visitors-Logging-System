-- Add organization_type column to admins table
ALTER TABLE admins 
ADD COLUMN organization_type VARCHAR(50) NULL 
AFTER email;

-- Add comment for clarity
ALTER TABLE admins 
MODIFY COLUMN organization_type VARCHAR(50) NULL 
COMMENT 'Organization type: Bank, School, College, Office, IT Company, Government Office';
