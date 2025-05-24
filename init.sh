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
info "📦 Installing MetaMod:Source..."
tar -xvzf /mods/mmsource-1.12.0-git1219-linux.tar.gz -C /data/serverfiles/cstrike || error_exit "Failed to extract MetaMod"

# ------------------------
# Install SourceMod
# ------------------------
info "📦 Installing SourceMod..."
tar -xvzf /mods/sourcemod-1.12.0-git7201-linux.tar.gz -C /data/serverfiles/cstrike || error_exit "Failed to extract SourceMod"

# ------------------------
# Install Shavit Timer
# ------------------------
info "⏱️ Installing Shavit Timer..."
unzip -o /mods/bhoptimer-master-sm1.12-321cdb2.zip -d /data/serverfiles/cstrike || error_exit "Failed to extract Shavit Timer"

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

# # ------------------------
# # Install Kid AutoStrafe
# # ------------------------
# info "🏃 Installing Kid AutoStrafe plugin...
# unzip -o /mods/kid-autostrafe.zip -d /data/serverfiles/cstrike/addons/sourcemod/plugins/ || error_exit "Failed to extract Kid AutoStrafe"

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
# Install show triggers plugin !showtriggers
# ------------------------
info "Installing show triggers plugin..."
# unzip -o /mods/showtriggers.zip -d /data/serverfiles/cstrike/addons/sourcemod/plugins/ || error_exit "Failed to extract show triggers plugin"
unzip -o /mods/extra-improved-showtriggers.zip -d /data/serverfiles/cstrike/addons/sourcemod/plugins/ || error_exit "Failed to extract extra-improved-showtriggers"

# ------------------------
# Install show player clips plugin !showclips
# ------------------------
info "Installing show player clips plugin..."
unzip -o /mods/showplayersclips.zip -d /data/serverfiles/cstrike/addons/sourcemod/|| error_exit "Failed to extract show player clips plugin"

# ------------------------
# NOTE: No need to apply SQL (sql/*.sql)
# we already have the premade database (sql/shavit.sq3) that I provide
# ------------------------
 
# ------------------------
# Install !gap
# ------------------------
info "Installing !gap plugin..."
unzip -o /mods/gap.zip -d /data/serverfiles/cstrike/addons/sourcemod/plugins/ || error_exit "Failed to extract gap"


# ------------------------
# Install Event Queue Fixer (2025 recompilation)
# ------------------------
info "Installing Event Queue Fixer..."
unzip -o /mods/event-queue-fixer-recompiled-2025.zip -d /data/serverfiles/cstrike/|| error_exit "Failed to extract Event Queue Fixer"

# ------------------------
# Install sm_closestpos
# ------------------------
info "Installing sm_closestpos plugin..."
unzip -o /mods/sm_closestpos-sm1.10-ubuntu-22.04-f848dfc.zip -d /data/serverfiles/cstrike/ || error_exit "Failed to extract sm_closestpos plugin"

# ------------------------
# Install PushFix Definition Edition [1.1.0] (see https://github.com/shavitush/bhoptimer/issues/1227)
# ------------------------
info "Installing PushFix Definition Edition..."
unzip -o /mods/pushfix_de_1.1.0.zip -d /data/serverfiles/cstrike || error_exit "Failed to extract PushFix Definition Edition"


# ------------------------
# Done
# ------------------------
info "✅ All plugins and fixes installed successfully."
info "🔁 Restarting the server..."

./cssserver restart