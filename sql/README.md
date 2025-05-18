# Premade Zones & Tiers

## Option 1: Use Pre-configured Database
> No need to do this if you're running it with docker compose up, already binded !
Simply copy the `shavit.sq3` file to your server's data directory:

```bash
cp shavit.sq3 /path/to/your/server/cstrike/addons/sourcemod/data/sqlite/
```

## Option 2: Import SQL Manually (Not Recommended for WSL)

> ⚠️ **Important**: SQL imports don't work well with WSL on Windows due to file locking issues. Use the pre-made .sq3 file instead.

If you're not using WSL, you can import the SQL files manually:

```bash
sqlite3 shavit.sq3 < zones.sql
sqlite3 shavit.sq3 < tiers.sql
```

### Permissions

Make sure the SQLite database has the correct permissions:

```bash
chmod 666 shavit.sq3
```
