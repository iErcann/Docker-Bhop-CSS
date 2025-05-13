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
# Extract Influx Timer
# ------------------------
echo "[INIT BHOP] Extracting Influx Timer..."
unzip -o /mods/bhoptimer.zip -d /data/serverfiles/cstrike

echo "[INIT BHOP] Done setting up the bhop configuration."
echo "[INIT BHOP] Restarting the server"

./cssserver restart
