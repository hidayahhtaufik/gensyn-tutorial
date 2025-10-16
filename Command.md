# 🎯 Gensyn RL-SWARM Quick Commands

Quick reference for daily operations.

---

## 📥 Installation

```bash
# One-click install
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

---

## 🖥️ Screen Commands

```bash
# Reattach to node
screen -r gensyn

# Detach from node (inside screen)
Ctrl+A then D

# List all screens
screen -ls

# Kill screen
screen -S gensyn -X quit

# Force detach (if stuck)
screen -d gensyn
```

---

## 📊 Monitoring

```bash
# View logs (real-time)
tail -f ~/rl-swarm/logs/swarm.log

# View logs (last 50 lines)
tail -50 ~/rl-swarm/logs/swarm.log

# View logs (inside screen)
screen -r gensyn
tail -f logs/swarm.log

# Check if running
screen -ls | grep gensyn

# Check port 3000
netstat -tlnp | grep 3000
lsof -i:3000

# Check processes
ps aux | grep rl-swarm
```

---

## 💾 Backup & Restore

```bash
# Auto backup (created by installer)
~/backup-swarm.sh

# Manual backup
mkdir -p ~/backup
cp ~/rl-swarm/swarm.pem ~/backup/
cp ~/rl-swarm/modal-login/temp-data/*.json ~/backup/

# Restore during install
# Choose option 2, enter: ~/backup

# Check backups
ls -la ~/gensyn-backup-*
ls -la ~/backup/
```

---

## 🚀 Start/Stop/Restart

```bash
# Start (first time)
bash install.sh

# Restart node
screen -S gensyn -X quit
bash install.sh
# Choose option 1: "Keep existing"

# Stop node
screen -S gensyn -X quit

# Manual start
screen -S gensyn
cd ~/rl-swarm
source .venv/bin/activate
./run_rl_swarm.sh
```

---

## 🌐 Localtunnel

```bash
# Get IPv4 (password)
curl -4 ifconfig.me

# Start localtunnel (in NEW terminal, OUTSIDE screen)
lt --port 3000

# Stop localtunnel
Ctrl+C

# Alternative tunnel
cloudflared tunnel --url http://localhost:3000
```

---

## 🔧 Configuration

```bash
# View config
cat ~/rl-swarm/rgym_exp/config/rg-swarm.yaml

# Edit config
nano ~/rl-swarm/rgym_exp/config/rg-swarm.yaml

# Reduce memory (set to 1 sample)
sed -i -E 's/(num_train_samples:\s*)2/\11/' ~/rl-swarm/rgym_exp/config/rg-swarm.yaml

# Increase memory (set to 2 samples)
sed -i -E 's/(num_train_samples:\s*)1/\12/' ~/rl-swarm/rgym_exp/config/rg-swarm.yaml
```

---

## 🔍 Debugging

```bash
# Check Node.js version (need >= v14)
node -v

# Update Node.js if too old
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install node
nvm use node

# Check if files exist
ls -la ~/rl-swarm/swarm.pem
ls -la ~/rl-swarm/run_rl_swarm.sh
ls -la ~/rl-swarm/.venv

# Make run script executable
chmod +x ~/rl-swarm/run_rl_swarm.sh

# Check Python
python3 --version

# Check screen
screen --version

# Check localtunnel
lt --version

# Check GPU
nvidia-smi

# Check RAM
free -h

# Check disk
df -h

# Search logs for errors
grep -i "error" ~/rl-swarm/logs/swarm.log
grep -i "oom" ~/rl-swarm/logs/swarm.log
```

---

## 📁 File Locations

```bash
# Identity (BACKUP!)
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

---

## 🔄 Update

```bash
# Full update
~/backup-swarm.sh  # Backup first
screen -S gensyn -X quit  # Stop
rm -rf ~/rl-swarm  # Remove
bash install.sh  # Reinstall
# Choose option 2: "Restore from backup"

# Quick update (keep identity)
screen -S gensyn -X quit
bash install.sh
# Choose option 1: "Keep existing"
```

---

## 🆘 Emergency

```bash
# OOM Error
screen -r gensyn
Ctrl+C
cd ~/rl-swarm
sed -i -E 's/(num_train_samples:\s*)2/\11/' rgym_exp/config/rg-swarm.yaml
./run_rl_swarm.sh

# Port 3000 stuck
sudo lsof -ti:3000 | xargs kill -9
sudo fuser -k 3000/tcp

# Screen stuck
screen -S gensyn -X quit
bash install.sh

# Complete reset
~/backup-swarm.sh  # Backup first!
rm -rf ~/rl-swarm
bash install.sh
```

---

## 💡 Useful Aliases

```bash
# Add to ~/.bashrc
echo 'alias gensyn="screen -r gensyn"' >> ~/.bashrc
echo 'alias gensyn-logs="tail -f ~/rl-swarm/logs/swarm.log"' >> ~/.bashrc
echo 'alias gensyn-backup="~/backup-swarm.sh"' >> ~/.bashrc
echo 'alias gensyn-stop="screen -S gensyn -X quit"' >> ~/.bashrc
echo 'alias gensyn-status="screen -ls | grep gensyn"' >> ~/.bashrc
source ~/.bashrc

# Usage:
gensyn          # Attach to node
gensyn-logs     # View logs
gensyn-backup   # Backup identity
gensyn-stop     # Stop node
gensyn-status   # Check status
```

---

## 📊 Dashboards

```bash
# Main dashboard
https://dashboard.gensyn.ai

# Node stats (enter peer ID)
https://gensyn-node.vercel.app

# Explorer
https://gensyn-testnet.explorer.alchemy.com
```

---

## 📝 Quick Copy-Paste

### Full Setup
```bash
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

### Daily Use
```bash
screen -r gensyn                          # Attach
tail -f ~/rl-swarm/logs/swarm.log        # Logs
~/backup-swarm.sh                         # Backup
```

### Troubleshooting
```bash
screen -ls | grep gensyn                  # Check status
tail -50 ~/rl-swarm/logs/swarm.log       # Check logs
netstat -tlnp | grep 3000                 # Check port
```

### Restart
```bash
screen -S gensyn -X quit                  # Stop
bash install.sh                           # Start (keep existing)
```

---

## 🎓 Screen Shortcuts

While inside screen session:

```bash
# Detach (leave running)
Ctrl+A then D

# Kill current window
Ctrl+A then K

# Clear screen
Ctrl+L

# Scroll up (enter scroll mode)
Ctrl+A then [
# Arrow keys to scroll
# Q to exit scroll mode
```

---

## 🔐 Security

```bash
# Set proper permissions
chmod 600 ~/rl-swarm/swarm.pem

# Never share these:
~/rl-swarm/swarm.pem
~/rl-swarm/modal-login/temp-data/userData.json

# Always backup before changes
~/backup-swarm.sh
```

---

## 📞 Get Help

- **Issues**: Check logs first: `tail -50 ~/rl-swarm/logs/swarm.log`
- **GitHub**: https://github.com/hidayahhtaufik/gensyn-tutorial/issues
- **Twitter**: [@Hidayahhtaufik](https://twitter.com/Hidayahhtaufik)
- **Discord**: https://discord.gg/AdnyWNzXh5

---

Made with ❤️ by [@Hidayahhtaufik](https://twitter.com/Hidayahhtaufik)

⭐ Star the repo if this helps!