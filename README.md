# Windmill Hass.io Add-on

Wraps upstream `ghcr.io/windmill-labs/windmill` with s6-overlay for HA supervision.

## Requirements
- Home Assistant Supervisor
- Postgres addon running (provide `database_url` in config)
- ~1-2 GB RAM available

## Install
Add repository: `https://github.com/WickM/windmill-hassio-addon`
Install addon "Windmill", configure `database_url`, start.