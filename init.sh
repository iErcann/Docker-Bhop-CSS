#!/bin/bash

GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

info() {
    echo -e "${GREEN}[BHOP INIT]${RESET} $1"
}

error_exit() {
    echo -e "${RED}[ERROR]${RESET} $1"
    exit 1
}

info "🚀 Starting server setup..."

# ------------------------
# Install MetaMod:Source
# ------------------------
info "📦 Installing MetaMod:Source (v1.12)..."
metamodsourceversion="1.12"
metamodsourcedownloadurl="https://www.metamodsource.net/latest.php?os=linux&version=${metamodsourceversion}"

wget -qO /tmp/mmsource.tar.gz "${metamodsourcedownloadurl}" || error_exit "Failed to download MetaMod:Source"
tar -xvzf /tmp/mmsource.tar.gz -C /data/serverfiles/cstrike || error_exit "Failed to extract MetaMod"

# ------------------------
# Install SourceMod
# ------------------------
info "📦 Installing SourceMod (v1.12)..."
sourcemodversion="1.12"
sourcemoddownloadurl="https://www.sourcemod.net/latest.php?os=linux&version=${sourcemodversion}"

wget -qO /tmp/sourcemod.tar.gz "${sourcemoddownloadurl}" || error_exit "Failed to download SourceMod"
tar -xvzf /tmp/sourcemod.tar.gz -C /data/serverfiles/cstrike || error_exit "Failed to extract SourceMod"

# ------------------------
# Install Shavit Timer
# ------------------------
info "⏱️ Installing Shavit Timer..."
unzip -o /mods/bhoptimer.zip -d /data/serverfiles/cstrike || error_exit "Failed to extract Shavit Timer"

# ------------------------
# Install bhop-get-stats
# ------------------------
info "📊 Installing bhop-get-stats (SSJ plugin)..."
unzip -o /mods/ssj.zip -d /data/serverfiles/cstrike/addons/sourcemod/plugins/ || error_exit "Failed to extract SSJ plugin"

# ------------------------
# Install Tickrate Enabler
# ------------------------
info "⚙️ Installing Tickrate Enabler..."
unzip -o /mods/TickrateEnabler-linux-tick100-15ada04.zip -d /data/serverfiles/cstrike/ || error_exit "Failed to extract Tickrate Enabler"

# ------------------------
# Install RNG Fixer
# ------------------------
info "🎲 Installing RNG Fixer..."
unzip -o /mods/rngfixer.zip -d /data/serverfiles/cstrike/addons/sourcemod/ || error_exit "Failed to extract RNG Fixer"

# ------------------------
# Install LandFix
# ------------------------
info "🛬 Installing LandFix plugin..."
unzip -o /mods/landfix_wHudAndCookies.zip -d /data/serverfiles/cstrike/addons/sourcemod/plugins/ || error_exit "Failed to extract LandFix"

# ------------------------
# Apply 260 Velocity Weapon Fix
# ------------------------
info "🏃 Applying 260 Velocity Weapon Scripts..."
unzip -o /mods/260VelWeaponScripts.zip -d /data/serverfiles/cstrike || error_exit "Failed to extract 260VelWeaponScripts"

# ------------------------
# Install SteamWorks (needed for bash2)
# ------------------------
info "🎮 Installing SteamWorks..."
unzip -o /mods/SteamWorks.zip -d /data/serverfiles/cstrike/ || error_exit "Failed to extract SteamWorks"

# ------------------------
# Install Bash2
# ------------------------
info "🎮 Installing Bash2..."
unzip -o /mods/bash2.zip -d /data/serverfiles/cstrike/addons/sourcemod/plugins/ || error_exit "Failed to extract Bash2"

# ------------------------
# Done
# ------------------------
info "✅ All plugins and fixes installed successfully."
info "🔁 Restarting the server..."

./cssserver restart
