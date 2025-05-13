 

# 🕹 Counter-Strike: Source Bhop Server Setup with Docker

## 🚀 Setup

1. **Start the Docker container:**

```bash
docker-compose up -d
```

Wait until all services are up and running. This will start your CSS server in the background.

---

## 🎮 Make it a Bhop Server

### 🔍 Check Server Details 

To get information about the running server:

```bash
docker exec -it --user linuxgsm css-server ./cssserver details
```

---

### 🧰 Initialize Bhop Setup (Metamod, Sourcemod, Bhop Timer, SSJ)

To configure the server with Sourcemod, Metamod\:Source, and Influx Timer, run:

```bash
docker exec -it --user linuxgsm css-server bash /init.sh
```

This script should:

* Install Metamod and Sourcemod
* Extract the Timer Bhop plugin from `/mods`
* Place everything in the correct directory

---

### 🔍 Check if Metamod Loaded

Access the game server console:

```bash
docker exec -it --user linuxgsm css-server ./cssserver console
```

Then, type:

```
meta list
```

You should see a list of loaded plugins including Metamod and Sourcemod.

---

## 🌐 Finding the IP Address (WSL Users)

If you are running Docker via **WSL**, find the IP address by running:

```bash
ifconfig
```

Look for your network interface (usually `eth0`) and note the `inet` address.

 