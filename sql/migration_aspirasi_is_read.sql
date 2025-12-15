-- Migration: Add is_read column to aspirasi table
-- This allows tracking which messages have been read by users

-- Add is_read column if it doesn't exist
ALTER TABLE aspirasi
ADD COLUMN IF NOT EXISTS is_read BOOLEAN DEFAULT false;

-- Update existing records to mark them as unread by default
UPDATE aspirasi
SET is_read = false
WHERE is_read IS NULL;

-- Add index for faster queries when filtering by is_read status
CREATE INDEX IF NOT EXISTS idx_aspirasi_is_read ON aspirasi(is_read);

-- Add index for queries that filter by is_read and created_at
CREATE INDEX IF NOT EXISTS idx_aspirasi_is_read_created_at ON aspirasi(is_read, created_at DESC);
