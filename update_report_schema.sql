-- =====================================================
-- Visitor Report Feature - Database Updates
-- =====================================================
-- This script adds the checkout_time column to support
-- the visitor report feature.
-- Run this script on your existing visitor_db database.
-- =====================================================

USE visitor_db;

-- Add checkout_time column if it doesn't exist
-- This allows tracking when visitors leave
ALTER TABLE visitors
ADD COLUMN IF NOT EXISTS checkout_time TIMESTAMP NULL DEFAULT NULL AFTER entry_time;

-- Create an index on entry_time for faster date-range queries
-- This improves performance of the report generation
CREATE INDEX IF NOT EXISTS idx_visitors_entry_time ON visitors (entry_time);

-- Create a composite index for admin reports
-- This optimizes queries that filter by admin_id and date range
CREATE INDEX IF NOT EXISTS idx_visitors_admin_entry ON visitors (admin_id, entry_time);

-- Display confirmation
SELECT 'Database updated for Visitor Report feature!' as Status;

SELECT 'Added: checkout_time column' as Change1;

SELECT 'Added: idx_visitors_entry_time index' as Change2;

SELECT 'Added: idx_visitors_admin_entry index' as Change3;