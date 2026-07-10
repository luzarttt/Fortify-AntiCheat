# Fortify Anti-Cheat

Advanced Anti-Cheat System for FiveM servers. Version 2.0.0

---

## Overview

Fortify is a comprehensive client-server anti-cheat resource designed for FiveM (GTA V multiplayer). It detects and responds to common cheating methods in real time, logs incidents to Discord via webhooks, and provides server administrators with moderation tools such as ban, kick, warn, and spectate commands.

---

## Features

**Detection Modules**

- God Mode detection (health and armor threshold checks)
- Speed hack detection (vehicle speed monitoring)
- Teleport detection (position delta tracking)
- NoClip detection (collision disabled check)
- Invisibility hack detection
- Super Jump detection
- Illegal weapon detection and removal
- Illegal vehicle detection and removal
- Vehicle god mode and engine power multiplier detection
- Illegal explosion event blocking
- Spectate system for admin oversight

**Administration**

- In-game ban, unban, kick, and warn commands
- Persistent ban storage in a JSON file
- Ban check on player connect (license, Steam, and IP cross-check)
- Warning counter with configurable auto-ban threshold
- Player info command showing identifiers and warning count
- Online player listing command

**Discord Logging**

- Ban, kick, warn, and detection logs sent to separate configurable webhooks
- Player connect and disconnect logs
- Explosion event logs
- Spectate session logs
- Embed format with player identifiers, timestamps, and server name

---

## File Structure

```
Fortify/
├── fxmanifest.lua          # Resource manifest
├── config.lua              # All configuration settings
├── FortifyLoader.bat       # Windows console loader / info screen
├── client/
│   ├── main.lua            # Client entry point, HUD, weapon limiter
│   ├── detections.lua      # All cheat detection logic
│   └── spectate.lua        # Spectate camera system
├── server/
│   ├── main.lua            # Server event handlers, admin commands
│   ├── ban.lua             # Ban system and player connect checks
│   └── discord.lua         # Discord webhook logging
└── shared/
    └── utils.lua           # Shared utility functions
```

---

## Requirements

- FiveM server (Artifact build supporting `cerulean` fx_version)
- Lua 5.4 enabled (`lua54 'yes'` in manifest)
- A Discord server with webhook URLs for logging (optional but recommended)

---

## Installation

1. Copy the `Fortify` folder into your server's `resources` directory.
2. Add `ensure Fortify` to your `server.cfg`.
3. Open `config.lua` and fill in your webhook URLs and server name.
4. Configure ace permissions for admin ranks (see Permissions section below).
5. Start or restart the server.

---

## Configuration

All settings are in `config.lua`. Key options:

| Setting | Default | Description |
|---|---|---|
| `DiscordWebhook` | `YOUR_WEBHOOK_URL_HERE` | Main detection log webhook |
| `BanWebhook` | `YOUR_BAN_WEBHOOK_URL_HERE` | Ban event webhook |
| `UyariWebhook` | `YOUR_WARNING_WEBHOOK_URL_HERE` | Warning event webhook |
| `SpectateWebhook` | `YOUR_SPECTATE_WEBHOOK_URL_HERE` | Spectate session webhook |
| `SunucuAdi` | `My FiveM Server` | Server name shown in Discord embeds |
| `MaxSaglik` | `200` | Maximum allowed player health |
| `MaxZirh` | `100` | Maximum allowed player armor |
| `MaxHiz` | `250.0` | Maximum allowed vehicle speed (km/h) |
| `TeleportMesafe` | `500.0` | Maximum position delta per tick (units) |
| `MaxUyari` | `3` | Warnings before automatic permanent ban |
| `KontrolAraligi` | `2000` | Detection loop interval (ms) |
| `HizKontrolAraligi` | `500` | Speed/teleport check interval (ms) |

**Toggling individual detections:**

Each detection module can be enabled or disabled independently in `config.lua`:

```lua
Fortify.Ayarlar.GodModeKontrol     = true
Fortify.Ayarlar.HizKontrol         = true
Fortify.Ayarlar.SilahKontrol       = true
Fortify.Ayarlar.TeleportKontrol    = true
Fortify.Ayarlar.AracKontrol        = true
Fortify.Ayarlar.NoclipKontrol      = true
Fortify.Ayarlar.ExplosionKontrol   = true
Fortify.Ayarlar.MenuKontrol        = true
Fortify.Ayarlar.InvisibleKontrol   = true
Fortify.Ayarlar.SuperJumpKontrol   = true
```

**Blacklisted weapons and vehicles** can be customized in the corresponding tables in `config.lua`.

---

## Permissions

Fortify uses FiveM's ace permission system. Grant access to admin ranks in `server.cfg`:

```
add_ace group.admin fortify.admin allow
add_ace group.superadmin fortify.superadmin allow
add_ace group.moderator fortify.moderator allow
```

Configured ranks are checked via `IsPlayerAceAllowed` at command execution time. The default rank list is `admin`, `superadmin`, and `moderator`.

---

## Commands

All command names are configurable in `config.lua`.

| Command | Permission | Description |
|---|---|---|
| `/ban [id] [reason]` | Admin | Permanently ban a player |
| `/unban [license]` | Admin | Remove a ban by license identifier |
| `/kick [id] [reason]` | Admin | Kick a player from the server |
| `/warn [id] [reason]` | Admin | Issue a warning to a player |
| `/spectate [id]` | Admin | Spectate a player (run again to stop) |
| `/fortifyinfo [id]` | Admin | Show player identifiers and warning count |
| `/fortifyonline` | Admin | List all connected players |
| `/fortifyhud` | Client | Toggle the Fortify status HUD overlay |

---

## Ban System

Bans are stored in a JSON file named `yasakli_oyuncular.json` in the resource directory. The file is created automatically on first run.

When a player connects, Fortify checks their license, Steam ID, and IP against all stored ban records. A match on any identifier will deny the connection with the ban reason and date displayed.

The auto-ban system permanently bans a player when:
- A hard cheat (god mode, noclip, invisible) is detected directly, or
- The player accumulates warnings equal to `MaxUyari`.

---

## Notes

- The spectate system moves the admin camera to the target player without revealing the admin's presence. The admin's ped is hidden and frozen during spectate.
- Detections include a 10-second cooldown per detection type per player to reduce spam.
- The `FortifyLoader.bat` file is a standalone Windows batch script for displaying resource information in a console window. It is not required for server operation.
