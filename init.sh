#!/bin/bash

echo "[INIT BHOP] Starting server setup..."

# ------------------------
# Install MetaMod:Source
# ------------------------
echo "[INIT BHOP] Installing MetaMod:Source..."
metamodsourceversion="1.11"
metamodsourcedownloadurl="https://www.metamodsource.net/latest.php?os=linux&version=${metamodsourceversion}"

wget -qO /tmp/mmsource.tar.gz "${metamodsourcedownloadurl}"
if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to download MetaMod:Source"
    exit 1
fi

tar -xvzf /tmp/mmsource.tar.gz -C /data/serverfiles/cstrike || { echo "[ERROR] Failed to extract MetaMod"; exit 1; }

# ------------------------
# Install SourceMod
# ------------------------
echo "[INIT BHOP] Installing SourceMod..."
sourcemodversion="1.12"
sourcemoddownloadurl="https://www.sourcemod.net/latest.php?os=linux&version=${sourcemodversion}"

wget -qO /tmp/sourcemod.tar.gz "${sourcemoddownloadurl}"
if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to download SourceMod"
    exit 1
fi

tar -xvzf /tmp/sourcemod.tar.gz -C /data/serverfiles/cstrike || { echo "[ERROR] Failed to extract SourceMod"; exit 1; }

# ------------------------
# Extract Shavit Timer https://github.com/shavitush/bhoptimer
# ------------------------ 
echo "[INIT BHOP] Extracting Shavit Timer..."
unzip -o /mods/bhoptimer.zip -d /data/serverfiles/cstrike

# ------------------------
# Extract bhop-get-stats https://github.com/enimmy/bhop-get-stats
# ------------------------
echo "[INIT BHOP] Extracting bhop-get-stats..."
unzip -o /mods/ssj.zip -d /data/serverfiles/cstrike || { echo "[ERROR] Failed to extract bhop-get-stats SSJ"; exit 1; }

# Move .smx files to the correct SourceMod plugins directory
echo "[INIT BHOP] Moving .smx files to the plugins folder..."
mkdir -p /data/serverfiles/cstrike/addons/sourcemod/plugins
mv /data/serverfiles/cstrike/*.smx /data/serverfiles/cstrike/addons/sourcemod/plugins/ || { echo "[ERROR] Failed to move .smx files"; exit 1; }

echo "[INIT BHOP] Done setting up bhop-get-stats."


# ------------------------
# Set Tickrate enabler   https://github.com/idk1703/TickrateEnabler (fork, because broken)
# ------------------------
echo "[INIT TICKRATE Enabler]"
unzip -o /mods/TickrateEnabler-linux-tick100-15ada04.zip -d /data/serverfiles/cstrike || { echo "[ERROR] Failed to extract TickrateEnabler"; exit 1; }


# ------------------------
# Set RNG Fixer https://github.com/jason-e/rngfix
# ------------------------
echo "[INIT RNG FIXER]"
unzip -o /mods/rngfixer.zip -d /data/serverfiles/cstrike/addons/sourcemod/ || { echo "[ERROR] Failed to extract rngfixer"; exit 1; }

# ------------------------ 
## For the issue of weapon affecting pre-speeds: https://forums.alliedmods.net/showthread.php?t=166468
# Set vel to 260 for all weapons  
# ------------------------
echo "[FIX VEL WEAPONS] Extracting 260 Vel Weapon Scripts..."
unzip -o /mods/260VelWeaponScripts.zip -d /data/serverfiles/cstrike || { echo "[ERROR] Failed to extract 260VelWeaponScripts"; exit 1; }

echo "[INIT BHOP] Done setting up the bhop configuration."
echo "[INIT BHOP] Restarting the server"


./cssserver restart
