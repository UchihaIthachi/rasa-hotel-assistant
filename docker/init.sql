-- Create a table for Rasa Tracker Store
CREATE TABLE tracker_store (
    sender_id TEXT PRIMARY KEY,
    slots JSONB,
    latest_message JSONB,
    events JSONB,
    paused BOOLEAN,
    CONSTRAINT sender_id_unique UNIQUE (sender_id)
);
