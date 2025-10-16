# 🎯 Gensyn RL-SWARM Quick Commands

## 📥 Installation

```bash
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

---

## 🔄 Understanding The Flow

### What Happens During Installation

```
Step 1: Install dependencies
   ↓
Step 2: Handle identity (keep/restore/fresh)
   ↓
Step 3: Configure training settings
   ↓
Step 4: Detect hardware (GPU/CPU)
   ↓
Step 5: Start RL-SWARM in screen 'gensyn' (background)
   ↓
Step 6: Script exits screen to main terminal
   ↓
Step 7: Show IPv4 password
   ↓
Step 8: Start localtunnel (OUTSIDE screen)
   ↓
Step 9: User opens URL & login with IPv4
   ↓
Step 10: User presses Ctrl+C (stop localtunnel)
   ↓
Step 11: Option to reattach to screen for manual config
```

### Terminal State After Installation

**Screen 'gensyn':** RL-SWARM running (stays alive forever)
**Main Terminal:** You're here, localtunnel stopped
**Next Step:** Optionally reattach to screen with `screen -r gensyn`

---

## 🖥️ Screen Management

### Basic Screen Commands
```bash
# Reattach to screen
screen -r gensyn

# Detach from screen (while inside)
Ctrl+A then D

# List all screens
screen -ls

# Kill screen session (from outside)
screen -X -S gensyn quit

# Check if gensyn screen exists
screen -ls | grep gensyn
```

### Advanced Screen Commands
```bash
# Create new screen window (inside screen)
Ctrl+A then C

# Switch between windows (inside screen)
Ctrl+A then N  # Next
Ctrl+A then P  # Previous

# List all windows (inside screen)
Ctrl+A then "

# Rename screen session
Ctrl+A then :sessionname new-name

# Force detach (if stuck)
Ctrl+A then D then D
```

---

## 💾 Backup & Restore

### Create Backup Folder (Before Installation)
```bash
# If you have existing swarm.pem
mkdir -p ~/backup
cp /path/to/swarm.pem ~/backup/

# Folder structure
~/backup/
├── swarm.pem       # Required!
├── userData.json   # Optional
└── userApiKey.json # Optional
```

### Auto Backup (After Installation)
```bash
# Run backup script (created by installer)
~/backup-swarm.sh

# Output: ~/gensyn-backup-YYYYMMDD-HHMMSS/
```

### Manual Backup
```bash
# Backup all important files
mkdir -p ~/backup
cp ~/rl-swarm/swarm.pem ~/backup/
cp ~/rl-swarm/modal-login/temp-data/userData.json ~/backup/
cp ~/rl-swarm/modal-login/temp-data/userApiKey.json ~/backup/

# Verify backup
ls -la ~/backup/
```

### Restore from Backup
```bash
# During installation:
# Choose option 2: "Restore from backup folder"
# Enter: ~/backup

# Manual restore (if needed)
cp ~/backup/swarm.pem ~/rl-swarm/
cp ~/backup/userData.json ~/rl-swarm/modal-login/temp-data/
cp ~/backup/userApiKey.json ~/rl-swarm/modal-login/temp-data/
```

### List All Backups
```bash
# Find all backup directories
ls -ld ~/gensyn-backup-* 2>/dev/null
ls -ld ~/backup/ 2>/dev/null

# Check backup contents
ls -la ~/gensyn-backup-*/
```

---

## 📊 Monitoring

### View Logs (Real-time)
```bash
# Reattach to screen first
screen -r gensyn

# Then view logs
tail -f ~/rl-swarm/logs/swarm.log

# Detach: Ctrl+A then D
```

### View Logs (Without Screen)
```bash
# Last 50 lines
tail -50 ~/rl-swarm/logs/swarm.log

# Last 100 lines
tail -100 ~/rl-swarm/logs/swarm.log

# Real-time (outside screen)
tail -f ~/rl-swarm/logs/swarm.log

# Search in logs
grep "error" ~/rl-swarm/logs/swarm.log
grep "training" ~/rl-swarm/logs/swarm.log
```

### Dashboard & Stats
```bash
# Main dashboard
https://dashboard.gensyn.ai

# Node stats (enter your peer ID)
https://gensyn-node.vercel.app

# Explorer
https://gensyn-testnet.explorer.alchemy.com

# Check peer ID
cat ~/rl-swarm/swarm.pem | grep -oP 'peer_id.*'
```

### Check Node Status
```bash
# Is screen running?
screen -ls | grep gensyn && echo "✓ Running" || echo "✗ Not running"

# Is port 3000 open?
netstat -tlnp | grep 3000
lsof -i:3000

# Check process
ps aux | grep rl-swarm
ps aux | grep python | grep swarm
```

---

## 🔧 Configuration

### View Current Config
```bash
# Main config file
cat ~/rl-swarm/rgym_exp/config/rg-swarm.yaml

# Check specific setting
cat ~/rl-swarm/rgym_exp/config/rg-swarm.yaml | grep num_train_samples
```

### Edit Config (Inside Screen)
```bash
# Reattach to screen
screen -r gensyn

# Edit config
cd ~/rl-swarm
nano rgym_exp/config/rg-swarm.yaml

# Save: Ctrl+X, Y, Enter

# Restart rl-swarm
Ctrl+C
./run_rl_swarm.sh
```

### Quick Config Changes

#### Reduce Memory Usage
```bash
# Inside screen
screen -r gensyn
cd ~/rl-swarm
sed -i -E 's/(num_train_samples:\s*)2/\11/' rgym_exp/config/rg-swarm.yaml

# Restart
Ctrl+C
./run_rl_swarm.sh
```

#### Increase Memory Usage
```bash
# Inside screen
screen -r gensyn
cd ~/rl-swarm
sed -i -E 's/(num_train_samples:\s*)1/\12/' rgym_exp/config/rg-swarm.yaml

# Restart
Ctrl+C
./run_rl_swarm.sh
```

---

## 🚀 Start/Stop/Restart

### Start Node (First Time)
```bash
# Run installer
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

### Restart Node
```bash
# Method 1: Inside screen
screen -r gensyn
Ctrl+C  # Stop
./run_rl_swarm.sh  # Start

# Method 2: Kill and reinstall
screen -X -S gensyn quit
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

### Stop Node
```bash
# Method 1: Graceful stop
screen -r gensyn
Ctrl+C

# Method 2: Kill screen
screen -X -S gensyn quit

# Method 3: Kill process
pkill -f rl-swarm
```

### Auto-Restart on Crash
```bash
# Inside screen
screen -r gensyn
cd ~/rl-swarm
. .venv/bin/activate

# Run with loop
while true; do
    ./run_rl_swarm.sh
    echo "Restarting in 10 seconds..."
    sleep 10
done
```

---

## 🌐 Localtunnel

### Get IPv4 Password
```bash
# Method 1 (recommended)
curl -4 ifconfig.me

# Method 2
curl -4 icanhazip.com

# Method 3
curl -4 ipinfo.io/ip

# Method 4
wget -qO- ifconfig.me
```

### Start Localtunnel (Manual)
```bash
# Start (in NEW terminal, OUTSIDE screen)
lt --port 3000

# You'll get URL like: https://xxx-yyy-zzz.loca.lt
# Open in browser, enter IPv4 as password

# Stop after login
Ctrl+C
```

### Troubleshoot Localtunnel
```bash
# Reinstall localtunnel
sudo npm uninstall -g localtunnel
sudo npm cache clean --force
sudo npm install -g localtunnel

# Check version
lt --version

# Test connection
lt --port 3000 --subdomain mytestnode
```

### Alternative: Cloudflared
```bash
# Install
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb

# Start (no password needed!)
cloudflared tunnel --url http://localhost:3000

# Stop
Ctrl+C
```

---

## 🔍 Debugging

### Check System Resources
```bash
# RAM usage
free -h

# Disk usage
df -h

# CPU usage
top
# Or
htop

# Live monitoring
watch -n 1 free -h
```

### Check GPU
```bash
# GPU info
nvidia-smi

# Live GPU monitoring
watch -n 1 nvidia-smi

# Check CUDA
nvcc --version

# Check if PyTorch sees GPU
python3 -c "import torch; print(torch.cuda.is_available())"
```

### Debug Installation Issues
```bash
# Check Python version
python3 --version

# Check npm/node version
npm --version
node --version

# Check git
git --version

# Check localtunnel
lt --version

# Check screen
screen --version
```

### Find Issues in Logs
```bash
# Search for errors
grep -i "error" ~/rl-swarm/logs/swarm.log

# Search for warnings
grep -i "warning" ~/rl-swarm/logs/swarm.log

# Search for OOM
grep -i "memory" ~/rl-swarm/logs/swarm.log
grep -i "oom" ~/rl-swarm/logs/swarm.log

# Last errors
tail -100 ~/rl-swarm/logs/swarm.log | grep -i error
```

---

## 📁 File Management

### Important Files
```bash
# Identity (CRITICAL - BACKUP THIS!)
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

### Check File Existence
```bash
# Check if swarm.pem exists
ls -la ~/rl-swarm/swarm.pem

# Check all important files
ls -la ~/rl-swarm/swarm.pem
ls -la ~/rl-swarm/modal-login/temp-data/userData.json
ls -la ~/rl-swarm/modal-login/temp-data/userApiKey.json

# Check directory structure
tree ~/rl-swarm -L 2
# Or
ls -R ~/rl-swarm
```

### File Permissions
```bash
# Set correct permissions for swarm.pem
chmod 600 ~/rl-swarm/swarm.pem

# Check permissions
ls -la ~/rl-swarm/swarm.pem
```

---

## 🔄 Update & Maintenance

### Update Node
```bash
# 1. Backup first!
~/backup-swarm.sh

# 2. Stop current node
screen -X -S gensyn quit

# 3. Remove old installation (optional)
rm -rf ~/rl-swarm

# 4. Run installer
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)

# 5. Choose: Restore from backup (option 2)
```

### Update System
```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Update npm packages
sudo npm update -g

# Update specific package
sudo npm update -g localtunnel

# Clean package cache
sudo apt clean
sudo apt autoremove
sudo npm cache clean --force
```

### Update Python Packages
```bash
# Inside screen
screen -r gensyn
cd ~/rl-swarm
. .venv/bin/activate

# Update pip
pip install --upgrade pip

# Update specific package
pip install --upgrade torch
```

---

## 🆘 Emergency Commands

### OOM (Out of Memory)
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
sudo lsof -ti:3000 | xargs kill -9

# Or
sudo fuser -k 3000/tcp

# Verify port is free
netstat -tlnp | grep 3000
```

### Screen Issues
```bash
# Screen won't detach
Ctrl+A then D then D

# Can't attach (already attached)
screen -d gensyn
screen -r gensyn

# Multiple screens with same name
screen -ls
screen -S gensyn.12345 -X quit  # Use specific ID
```

### Lost Identity
```bash
# Check all backups
ls ~/gensyn-backup-*/
ls ~/backup/

# If found
cp ~/backup/swarm.pem ~/rl-swarm/

# If not found - must start fresh
screen -X -S gensyn quit
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
# Choose option 3: Start fresh
```

### Complete Reset
```bash
# Stop everything
screen -X -S gensyn quit
pkill -f rl-swarm

# Backup first (if needed)
~/backup-swarm.sh

# Remove installation
rm -rf ~/rl-swarm

# Reinstall
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

---

## 💡 Pro Tips & Tricks

### Useful Aliases
```bash
# Add to ~/.bashrc
cat >> ~/.bashrc << 'EOF'
alias gensyn='screen -r gensyn'
alias gensyn-logs='tail -f ~/rl-swarm/logs/swarm.log'
alias gensyn-backup='~/backup-swarm.sh'
alias gensyn-restart='screen -X -S gensyn quit && bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)'
EOF

source ~/.bashrc

# Now use:
gensyn          # Attach to screen
gensyn-logs     # View logs
gensyn-backup   # Backup identity
```

### Quick Status Check
```bash
# One-liner
screen -ls | grep gensyn && echo "✓ Node running" || echo "✗ Node not running"

# With port check
screen -ls | grep gensyn && netstat -tlnp | grep 3000 && echo "✓ All good" || echo "✗ Issues detected"
```

### Auto Backup Cron
```bash
# Edit crontab
crontab -e

# Add daily backup at midnight
0 0 * * * ~/backup-swarm.sh

# Add weekly backup on Sunday
0 0 * * 0 ~/backup-swarm.sh

# Save and exit
```

### Multiple Nodes
```bash
# Node 1
screen -S gensyn1 bash -c "cd ~/rl-swarm1 && ./run_rl_swarm.sh"

# Node 2
screen -S gensyn2 bash -c "cd ~/rl-swarm2 && ./run_rl_swarm.sh"

# List all
screen -ls

# Attach to specific
screen -r gensyn1
screen -r gensyn2
```

### Monitor While Detached
```bash
# Watch logs in real-time (outside screen)
tail -f ~/rl-swarm/logs/swarm.log

# Watch with highlighting
tail -f ~/rl-swarm/logs/swarm.log | grep --color=auto "training\|error\|warning"

# Watch multiple logs
tail -f ~/rl-swarm/logs/*.log
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

# Twitter
https://twitter.com/Hidayahhtaufik
```

---

## 📝 Quick Copy-Paste Commands

### Full Setup
```bash
# One-time installation
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

### Daily Use
```bash
# Attach to node
screen -r gensyn

# View logs
tail -f ~/rl-swarm/logs/swarm.log

# Backup
~/backup-swarm.sh

# Get IPv4
curl -4 ifconfig.me
```

### Troubleshooting
```bash
# Check status
screen -ls | grep gensyn

# Restart node
screen -X -S gensyn quit
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)

# Check resources
free -h && df -h
```

---

Made with ❤️ by [@Hidayahhtaufik](https://twitter.com/Hidayahhtaufik)

⭐ Star the repo if this helps you!