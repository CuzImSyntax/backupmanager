ALTER TABLE routine_backups ADD COLUMN success INTEGER NOT NULL DEFAULT 0;
UPDATE routine_backups SET success = 1;