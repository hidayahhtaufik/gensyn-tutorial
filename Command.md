# 🎯 Gensyn RL-SWARM Quick Commands

## 📥 Installation

```bash
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

---

## 🔄 The Proper Flow

### Terminal 1: Screen Session
```bash
# Run installer (creates screen "gensyn")
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)

# Detach from screen
Ctrl+A then D

# Reattach to screen
screen -r gensyn

# Kill screen session
screen -X -S gensyn quit
```

### Terminal 2: Localtunnel (OUTSIDE Screen)
```bash
# Get IPv4 password
curl -4 ifconfig.me

# Start localtunnel
lt --port 3000

# Exit localtunnel (after login)
Ctrl+C
```

---

## 💾 Backup & Restore

### Create Backup
```bash
# Auto backup
~/backup-swarm.sh

# Manual backup
mkdir -p ~/backup
cp ~/rl-swarm/swarm.pem ~/backup/
cp ~/rl-swarm/modal-login/temp-data/*.json ~/backup/
```

### Restore Backup
```bash
# During installer:
# Choose option 2: "Restore from backup folder"
# Enter: ~/backup

# Or manual restore:
cp ~/backup/swarm.pem ~/rl-swarm/
```

---

## 📊 Monitoring

### View Logs
```bash
# Reattach to screen first
screen -r gensyn

# View logs
tail -f ~/rl-swarm/logs/swarm.log

# Last 50 lines
tail -50 ~/rl-swarm/logs/swarm.log

# Detach
Ctrl+A then D
```

### Dashboard
```bash
# Main dashboard
https://dashboard.gensyn.ai

# Node stats (enter your peer ID)
https://gensyn-node.vercel.app
```

### Check Screen Sessions
```bash
# List all screens
screen -ls

# Check if gensyn is running
screen -ls | grep gensyn
```

---

## 🔧 Configuration

### Edit Training Config
```bash
# Reattach to screen
screen -r gensyn

# Edit config
cd ~/rl-swarm
nano rgym_exp/config/rg-swarm.yaml

# Save: Ctrl+X, Y, Enter
# Restart rl-swarm if needed
```

### Reduce Memory Usage
```bash
# Inside screen
cd ~/rl-swarm
sed -i -E 's/(num_train_samples:\s*)2/\11/' rgym_exp/config/rg-swarm.yaml

# Restart
./run_rl_swarm.sh
```

### View Current Config
```bash
cat ~/rl-swarm/rgym_exp/config/rg-swarm.yaml | grep num_train_samples
```

---

## 🚀 Start/Stop/Restart

### Start (First Time)
```bash
# Run installer
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

### Restart RL-SWARM
```bash
# Reattach to screen
screen -r gensyn

# Stop current
Ctrl+C

# Restart
cd ~/rl-swarm
. .venv/bin/activate
./run_rl_swarm.sh

# Detach
Ctrl+A then D
```

### Stop Node
```bash
# Reattach to screen
screen -r gensyn

# Stop
Ctrl+C

# Kill screen
screen -X -S gensyn quit
```

---

## 🌐 Network/Localtunnel

### Get IPv4 Password
```bash
# Method 1 (recommended)
curl -4 ifconfig.me

# Method 2
curl -4 ipinfo.io/ip

# Method 3
ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127.0.0.1
```

### Start Localtunnel (NEW Terminal, OUTSIDE Screen)
```bash
# Start
lt --port 3000

# Stop (after login)
Ctrl+C

# Reinstall if needed
npm uninstall -g localtunnel
npm install -g localtunnel
```

### Alternative: Cloudflared
```bash
# Install
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb

# Start (no password needed!)
cloudflared tunnel --url http://localhost:3000
```

---

## 🔍 Debugging

### Check if Running
```bash
# Check screen
screen -ls

# Check process
ps aux | grep rl-swarm
ps aux | grep python

# Check port
netstat -tlnp | grep 3000
lsof -i:3000
```

### View All Logs
```bash
# Inside screen
screen -r gensyn

# List logs
ls ~/rl-swarm/logs/

# View specific log
tail -f ~/rl-swarm/logs/swarm.log
tail -f ~/rl-swarm/logs/yarn.log
```

### Check GPU
```bash
# GPU info
nvidia-smi

# Live monitoring
watch -n 1 nvidia-smi

# Check CUDA
nvcc --version
```

### Check Memory
```bash
# RAM usage
free -h

# Detailed
htop

# Or
top
```

---

## 📁 File Locations

### Important Files
```bash
# Identity (BACKUP THIS!)
~/rl-swarm/swarm.pem

# User data
~/rl-swarm/modal-login/temp-data/userData.json
~/rl-swarm/modal-login/temp-data/userApiKey.json

# Logs
~/rl-swarm/logs/swarm.log
~/rl-swarm/logs/yarn.log

# Config
~/rl-swarm/rgym_exp/config/rg-swarm.yaml

# Backup script
~/backup-swarm.sh
```

### View Files
```bash
# List rl-swarm directory
ls -la ~/rl-swarm/

# Check if swarm.pem exists
ls -la ~/rl-swarm/swarm.pem

# View peer ID (from swarm.pem)
cat ~/rl-swarm/swarm.pem
```

---

## 🔄 Update

### Update Node
```bash
# 1. Backup first!
~/backup-swarm.sh

# 2. Stop current node
screen -r gensyn
Ctrl+C
screen -X -S gensyn quit

# 3. Run installer again
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)

# 4. Choose: Keep existing or restore from backup
```

### Update Dependencies
```bash
# Update npm
npm update -g

# Update localtunnel
npm update -g localtunnel

# Update system packages
sudo apt update && sudo apt upgrade -y
```

---

## 🆘 Emergency Commands

### OOM Error
```bash
screen -r gensyn
Ctrl+C
cd ~/rl-swarm
sed -i -E 's/(num_train_samples:\s*)2/\11/' rgym_exp/config/rg-swarm.yaml
./run_rl_swarm.sh
```

### Port Already in Use
```bash
# Kill process on port 3000
lsof -ti:3000 | xargs kill -9

# Or
fuser -k 3000/tcp
```

### Screen Won't Detach
```bash
# Force detach
Ctrl+A then D then D

# Or kill from outside
screen -X -S gensyn quit
```

### Lost in Screen
```bash
# See all windows
Ctrl+A then "

# Create new window
Ctrl+A then C

# Next window
Ctrl+A then N

# Previous window
Ctrl+A then P
```

---

## 💡 Pro Tips

### Aliases
```bash
# Add to ~/.bashrc
echo 'alias gensyn="screen -r gensyn"' >> ~/.bashrc
echo 'alias gensyn-logs="tail -f ~/rl-swarm/logs/swarm.log"' >> ~/.bashrc
echo 'alias gensyn-backup="~/backup-swarm.sh"' >> ~/.bashrc
source ~/.bashrc

# Now use:
gensyn
gensyn-logs
gensyn-backup
```

### Auto-Restart on Crash
```bash
# Inside screen
cd ~/rl-swarm
. .venv/bin/activate
while true; do
    ./run_rl_swarm.sh
    echo "Restarting in 10 seconds..."
    sleep 10
done
```

### Monitor Multiple Nodes
```bash
# List all screens
screen -ls

# Attach to specific
screen -r node1
screen -r node2
```

---

## 📊 Quick Status Check

```bash
# One-liner status check
screen -ls | grep gensyn && echo "✓ Running" || echo "✗ Not running"

# With logs
screen -r gensyn -X hardcopy /tmp/screen.log && tail -5 /tmp/screen.log
```

---

## 🔗 Useful Links

```bash
# Dashboard
https://dashboard.gensyn.ai

# Explorer
https://gensyn-testnet.explorer.alchemy.com

# Node Stats
https://gensyn-node.vercel.app

# Discord
https://discord.gg/AdnyWNzXh5

# GitHub
https://github.com/hidayahhtaufik/gensyn-tutorial
```

---

## 📝 Quick Copy-Paste

```bash
# Full setup (one-time)
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)

# Localtunnel (new terminal)
curl -4 ifconfig.me && lt --port 3000

# Reattach
screen -r gensyn

# Backup
~/backup-swarm.sh

# Logs
tail -f ~/rl-swarm/logs/swarm.log
```

---

Made with ❤️ by [@Hidayahhtaufik](https://twitter.com/Hidayahhtaufik)