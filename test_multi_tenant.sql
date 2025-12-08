-- Multi-Tenant Testing Script
-- This script helps you verify that admins can only see their own data

-- Step 1: Create test admins (if not already exist)
INSERT INTO
    admins (username, email, password)
VALUES (
        'testadmin1',
        'testadmin1@test.com',
        'test123'
    ),
    (
        'testadmin2',
        'testadmin2@test.com',
        'test456'
    )
ON DUPLICATE KEY UPDATE
    username = username;

-- Step 2: Get admin IDs for reference
SELECT id, username FROM admins WHERE username LIKE 'testadmin%';

-- Step 3: Add test visitors for Admin 1 (replace ID with actual admin1 ID)
-- Example: If testadmin1 has id=2, use that
INSERT INTO
    visitors (
        name,
        phone,
        purpose,
        admin_id
    )
VALUES (
        'John Doe',
        '555-0001',
        'Meeting with Admin 1',
        2
    ),
    (
        'Jane Smith',
        '555-0002',
        'Interview with Admin 1',
        2
    ),
    (
        'Bob Wilson',
        '555-0003',
        'Delivery for Admin 1',
        2
    );

-- Step 4: Add test visitors for Admin 2 (replace ID with actual admin2 ID)
-- Example: If testadmin2 has id=3, use that
INSERT INTO
    visitors (
        name,
        phone,
        purpose,
        admin_id
    )
VALUES (
        'Alice Johnson',
        '555-0004',
        'Meeting with Admin 2',
        3
    ),
    (
        'Charlie Brown',
        '555-0005',
        'Consultation with Admin 2',
        3
    );

-- Step 5: Verify isolation - Check Admin 1's visitors only
SELECT v.*, a.username as admin_name
FROM visitors v
    JOIN admins a ON v.admin_id = a.id
WHERE
    v.admin_id = 2;
-- Replace with testadmin1 ID

-- Step 6: Verify isolation - Check Admin 2's visitors only
SELECT v.*, a.username as admin_name
FROM visitors v
    JOIN admins a ON v.admin_id = a.id
WHERE
    v.admin_id = 3;
-- Replace with testadmin2 ID

-- Step 7: View all data with admin names (for debugging only)
SELECT
    v.id,
    v.name as visitor_name,
    v.phone,
    v.purpose,
    v.entry_time,
    a.username as admin_name,
    v.admin_id
FROM visitors v
    JOIN admins a ON v.admin_id = a.id
ORDER BY v.admin_id, v.entry_time DESC;

-- Step 8: Count visitors per admin
SELECT a.id, a.username, COUNT(v.id) as visitor_count
FROM admins a
    LEFT JOIN visitors v ON a.id = v.admin_id
GROUP BY
    a.id,
    a.username
ORDER BY a.username;

-- Step 9: Test delete isolation (delete only admin 1's old visitors)
-- First, make some visitors old (for testing)
UPDATE visitors
SET
    entry_time = DATE_SUB(NOW(), INTERVAL 40 DAY)
WHERE
    admin_id = 2
    AND name = 'Bob Wilson';

-- Now delete visitors older than 30 days for admin 1 only
DELETE FROM visitors
WHERE
    admin_id = 2
    AND entry_time < DATE_SUB(NOW(), INTERVAL 30 DAY);

-- Verify admin 1 lost Bob but admin 2 still has all visitors
SELECT a.username, COUNT(v.id) as remaining_visitors
FROM admins a
    LEFT JOIN visitors v ON a.id = v.admin_id
WHERE
    a.username LIKE 'testadmin%'
GROUP BY
    a.username;

-- Step 10: Test cascade delete (delete admin deletes their visitors)
-- WARNING: This will delete testadmin2 and all their visitors!
-- Uncomment only if you want to test cascade delete
-- DELETE FROM admins WHERE username = 'testadmin2';
-- SELECT * FROM visitors WHERE admin_id = 3;  -- Should return 0 rows

-- Step 11: Cleanup (remove test data)
-- Uncomment these lines when you're done testing
-- DELETE FROM visitors WHERE admin_id IN (SELECT id FROM admins WHERE username LIKE 'testadmin%');
-- DELETE FROM admins WHERE username LIKE 'testadmin%';

-- Step 12: Verify indexes are being used (performance check)
EXPLAIN
SELECT *
FROM visitors
WHERE
    admin_id = 2
ORDER BY entry_time DESC;
-- Look for "Using index" in the Extra column

-- Expected Results:
-- ✅ Admin 1 should see only John, Jane, Bob (or John, Jane after delete test)
-- ✅ Admin 2 should see only Alice, Charlie
-- ✅ No admin can see other admin's visitors
-- ✅ Deleting admin 2 removes Alice and Charlie automatically (cascade)
-- ✅ Queries use idx_visitor_admin index for fast filtering