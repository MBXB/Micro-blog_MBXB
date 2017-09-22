CREATE TABLE IF NOT EXISTS "T_Status" (
    "statusid" INTEGER NOT NULL,
    "status" TEXT,
    "uid" INTEGER NOT NULL,
    "createDate" TEXT DEFAULT (datetime('now','localtime')),
    PRIMARY KEY("statusid","uid")
)
