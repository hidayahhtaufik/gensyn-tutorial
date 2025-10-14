# 🎯 Gensyn RL-SWARM Quick Commands

## 📥 Installation

### Basic Installer
```bash
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

### Enhanced Installer (Recommended)
```bash
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install-enhanced.sh)
```

---

## 💾 Backup Commands

### Create Backup
```bash
~/backup-swarm.sh
```

### Manual Backup
```bash
cp ~/rl-swarm/swarm.pem ~/swarm_backup.pem
cp ~/rl-swarm/modal-login/temp-data/*.json ~/
```

### Restore Backup
```bash
# During install, choose option 2
# Or manually:
cp ~/swarm_backup.pem ~/rl-swarm/swarm.pem
```

---

## 📊 Monitoring

### View Logs (Live)
```bash
tail -f ~/rl-swarm/logs/swarm.log
```

### Check Screen Session
```bash
screen -ls                  # List all sessions
screen -r gensyn           # Reattach to gensyn
# Ctrl+A then D to detach
```

### Check Dashboard
```bash
# Visit: https://dashboard.gensyn.ai
# Or: https://gensyn-node.vercel.app
```

---

## 🔧 Configuration

### Edit Training Config
```bash
nano ~/rl-swarm/rgym_exp/config/rg-swarm.yaml
```

### Reduce Memory Usage
```bash
cd ~/rl-swarm
sed -i -E 's/(num_train_samples:\s*)2/\11/' rgym_exp/config/rg-swarm.yaml
```

### Check Current Config
```bash
cat ~/rl-swarm/rgym_exp/config/rg-swarm.yaml | grep num_train_samples
```

---

## 🚀 Start/Stop

### Start Node
```bash
cd ~/rl-swarm
source .venv/bin/activate
./run_rl_swarm.sh
```

### Stop Node
```bash
# Inside screen session
Ctrl + C

# Or kill screen
screen -X -S gensyn quit
```

### Restart Node
```bash
screen -X -S gensyn quit
screen -dmS gensyn bash -c "cd ~/rl-swarm && source .venv/bin/activate && ./run_rl_swarm.sh"
```

---

## 🔍 Debugging

### Check if Running
```bash
ps aux | grep rl-swarm
screen -ls
```

### View All Logs
```bash
ls ~/rl-swarm/logs/
tail -n 100 ~/rl-swarm/logs/swarm.log
tail -n 100 ~/rl-swarm/logs/yarn.log
```

### Check GPU
```bash
nvidia-smi
watch -n 1 nvidia-smi  # Live monitoring
```

### Check Memory
```bash
free -h
htop  # or top
```

---

## 🌐 Localtunnel

### Start Localtunnel
```bash
lt --port 3000
```

### Get Password
```bash
curl https://loca.lt/mytunnelpassword
# Or use your server IP
```

### Check Tunnel Status
```bash
ps aux | grep localtunnel
```

---

## 📁 File Locations

### Important Files
```bash
~/rl-swarm/swarm.pem                              # Your identity
~/rl-swarm/modal-login/temp-data/userData.json   # User data
~/rl-swarm/modal-login/temp-data/userApiKey.json # API keys
~/rl-swarm/logs/swarm.log                        # Training logs
```

### Configuration
```bash
~/rl-swarm/rgym_exp/config/rg-swarm.yaml  # Training config
```

---

## 🔄 Update Node

### Update to Latest Version
```bash
# Backup first!
~/backup-swarm.sh

# Method 1: Use installer
bash <(curl -s .../install-enhanced.sh)
# Choose option 1: Use existing

# Method 2: Manual
cd ~/rl-swarm
git pull origin main
```

---

## 🆘 Troubleshooting

### OOM (Out of Memory) Error
```bash
# Reduce training samples
cd ~/rl-swarm
sed -i -E 's/(num_train_samples:\s*)[0-9]+/\11/' rgym_exp/config/rg-swarm.yaml

# For MacBook
export PYTORCH_MPS_HIGH_WATERMARK_RATIO=0.0
```

### Port 3000 Already in Use
```bash
# Kill process using port 3000
lsof -ti:3000 | xargs kill -9
```

### Localtunnel Not Working
```bash
# Reinstall
npm uninstall -g localtunnel
npm install -g localtunnel

# Alternative: Use ngrok or cloudflared
```

### Lost swarm.pem
```bash
# Check backups
ls ~/gensyn-backup*/
ls ~/swarm_backup.pem

# If lost, start fresh:
rm ~/rl-swarm/swarm.pem
# Run installer again
```

---

## 📱 Screen Session Commands

```bash
screen -S gensyn           # Create session
screen -r gensyn           # Reattach
screen -ls                 # List sessions
screen -X -S gensyn quit   # Kill session

# Inside screen:
Ctrl + A, then D           # Detach
Ctrl + A, then K           # Kill
Ctrl + A, then C           # New window
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

# Official Repo
https://github.com/gensyn-ai/rl-swarm

# Your Tutorial Repo
https://github.com/hidayahhtaufik/gensyn-tutorial

# Discord
https://discord.gg/AdnyWNzXh5
```

---

## 💡 Pro Tips

### 1. Auto-restart on Crash
```bash
# Create systemd service (advanced)
# Or use this simple loop:
while true; do
    cd ~/rl-swarm
    source .venv/bin/activate
    ./run_rl_swarm.sh
    sleep 10
done
```

### 2. Multiple Nodes
```bash
# Same email = linked to same wallet
# Different swarm.pem = different peer IDs
# All rewards go to same wallet
```

### 3. Quick Status Check
```bash
alias gensyn-status='screen -r gensyn'
alias gensyn-logs='tail -f ~/rl-swarm/logs/swarm.log'
alias gensyn-backup='~/backup-swarm.sh'

# Add to ~/.bashrc for persistence
```

---

**Quick Copy-Paste Commands:**

```bash
# Install Enhanced
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install-enhanced.sh)

# Backup
~/backup-swarm.sh

# Logs
tail -f ~/rl-swarm/logs/swarm.log

# Reattach
screen -r gensyn

# Reduce Memory
cd ~/rl-swarm && sed -i -E 's/(num_train_samples:\s*)2/\11/' rgym_exp/config/rg-swarm.yaml
```

---

Made with ❤️ by [@Hidayahhtaufik](https://twitter.com/Hidayahhtaufik)