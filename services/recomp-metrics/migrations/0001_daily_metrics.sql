CREATE TABLE IF NOT EXISTS daily_metrics (
  date TEXT PRIMARY KEY,
  requests INTEGER NOT NULL CHECK (requests >= 0),
  visits INTEGER NOT NULL CHECK (visits >= 0),
  collected_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS metrics_meta (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
