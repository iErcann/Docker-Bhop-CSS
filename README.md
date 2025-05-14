# 🕹 Counter-Strike: Source Bhop Server Setup with Docker

## 🚀 Setup Instructions

### 1️⃣ Start the Server

Launch the Docker container to initialize your Counter-Strike: Source server:

```bash
docker-compose up -d
```

Wait for all services to start. The server will run in the background.

---

### 2️⃣ Configure as a Bhop Server

#### 🔍 Verify Server Status

Check the server's current status and details:

```bash
docker exec -it --user linuxgsm css-server ./cssserver details
```

---

#### 🧰 Install Bhop Plugins

Set up the server with essential plugins like Metamod, Sourcemod, and a Bhop Timer:

```bash
docker exec -it --user linuxgsm css-server bash /init.sh
```

This script will:

- Install **Metamod** and **Sourcemod**
- Deploy the **Bhop Timer plugin** from `/mods` ([shavitush/bhoptimer](https://github.com/shavitush/bhoptimer))
- Place all files in the correct directories

---

#### 🔍 Verify Plugin Installation

Access the game server console:

```bash
docker exec -it --user linuxgsm css-server ./cssserver console
```

Run the following command to confirm Metamod and Sourcemod are loaded:

```
meta list
```

You should see a list of active plugins.

---

### 3️⃣ Locate the Server IP (For WSL Users)

If you're using Docker with **WSL**, find the server's IP address:

```bash
ifconfig
```

Look for the `inet` address under your network interface (commonly `eth0`).

---

### 4️⃣ Customize Server Settings

Edit the server configuration file to personalize your setup:

**File Path:** `/css-data/serverfiles/cstrike/cfg/cssserver.cfg`

Example configuration:

```plaintext
hostname "Bhop Server"                # Server name
rcon_password ""                      # Secure RCON password or disable
sv_setsteamaccount "your_token_here"  # Steam Game Server Login Token
```

> **Tip:** Generate a Steam Game Server Login Token (GSLT) at [Steam Game Server Account Management](https://steamcommunity.com/dev/managegameservers).

---

### 5️⃣ Add Admin Privileges

Grant yourself admin access by editing the following file:

**File Path:** `/css-data/serverfiles/cstrike/addons/sourcemod/configs/admins.cfg`

Add your Steam ID in the specified format. Example:

```plaintext
"YourSteamID"
{
    "auth"        "steam"
    "identity"    "STEAM_0:1:12345678"
    "flags"       "z"  // Full admin access
    "immunity"    "99" // Highest immunity level
}
```

> **Note:** Replace `STEAM_0:1:12345678` with your actual Steam ID. Use tools like [SteamID Finder](https://steamid.io/) to find your Steam ID.

---

### 📜 Credits

- [LinuxGSM Sourcemod Guide](https://docs.linuxgsm.com/guides/sourcemod-csgo-server)
- [Bhop Stats by enimmy](https://github.com/enimmy/bhop-get-stats)
- [Bhop Timer by shavitush](https://github.com/shavitush/bhoptimer)