# 🐝 Gensyn RL-SWARM One-Click Installer

**Simplest way to run Gensyn nodes**

By [@Hidayahhtaufik](https://twitter.com/Hidayahhtaufik)

---

## 🚀 Quick Start

```bash
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

That's it! One command, everything automated.

---

## 📋 What It Does

1. ✅ Installs all dependencies automatically
2. ✅ Handles your identity (keep/restore/new)
3. ✅ Configures training settings
4. ✅ Starts RL-SWARM in screen session
5. ✅ Sets up localtunnel for browser login
6. ✅ Creates auto-backup script

---

## 💾 Backup Your Identity

### Before Installation (If You Have swarm.pem)

```bash
# Create backup folder
mkdir -p ~/backup

# Put your swarm.pem inside
cp /path/to/swarm.pem ~/backup/

# Run installer, choose option 2: "Restore from backup"
```

### After Installation

```bash
# Auto backup (created by installer)
~/backup-swarm.sh

# Manual backup
cp ~/rl-swarm/swarm.pem ~/my-backup/
```

---

## 🔄 The Flow Explained

### What Happens During Installation:

```
1. Install dependencies (auto)
   ↓
2. Choose identity:
   • Keep existing
   • Restore from backup folder
   • Start fresh
   ↓
3. Configure training (GPU/CPU)
   ↓
4. RL-SWARM starts in screen 'gensyn'
   ↓
5. Localtunnel starts for browser access
   ↓
6. You open URL, login with IPv4 password
   ↓
7. After login, press Ctrl+C
   ↓
8. Done! Node runs in background
```

### Why This Way?

**The Problem:**
- RL-SWARM needs you to open `http://localhost:3000`
- You're on a VPS, can't access localhost directly

**The Solution:**
- RL-SWARM runs in screen (background)
- Localtunnel forwards port 3000 to public URL
- You login via browser
- RL-SWARM continues running
- Localtunnel no longer needed

**Key Points:**
- RL-SWARM runs in screen session 'gensyn'
- Localtunnel runs OUTSIDE screen (main terminal)
- After login, RL-SWARM continues automatically
- You can close localtunnel after login

---

## 🛠️ Common Commands

```bash
# Reattach to node
screen -r gensyn

# Detach from node (inside screen)
Ctrl+A then D

# View logs
tail -f ~/rl-swarm/logs/swarm.log

# Backup identity
~/backup-swarm.sh

# Stop node
screen -S gensyn -X quit

# Restart node
bash install.sh
# Choose option 1: "Keep existing identity"

# List all screens
screen -ls

# Get IPv4 (for localtunnel)
curl -4 ifconfig.me
```

---

## 🆘 Troubleshooting

### Node.js Version Error

```bash
# Error: "Expected version >=14. Got 12.x.x"
# This happens if you have old Node.js from apt

# Quick Fix (if already in screen):
screen -r gensyn
Ctrl+C  # Stop current run

# Load NVM
export NVM_DIR="$HOME/.nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install latest Node.js
nvm install node
nvm use node
node -v  # Should be v18+

# Restart RL-SWARM
cd ~/rl-swarm
source .venv/bin/activate
./run_rl_swarm.sh

# OR just rerun installer (easier):
Ctrl+C  # Exit screen
screen -S gensyn -X quit  # Kill screen
bash install.sh  # Rerun (will auto-fix Node.js)
```

### Screen Won't Create

```bash
# Manual start:
screen -S gensyn
cd ~/rl-swarm
source .venv/bin/activate
./run_rl_swarm.sh

# Wait for "localhost:3000" message
# Detach: Ctrl+A then D

# Then in NEW terminal:
curl -4 ifconfig.me
lt --port 3000
```

### Port 3000 Not Opening

**Cause:** Dependencies still installing (first run takes 2-5 min)

```bash
# Check progress:
screen -r gensyn

# Look for pip install messages
# Detach: Ctrl+A then D
```

### Localtunnel Password Wrong

```bash
# MUST use IPv4, not IPv6!
curl -4 ifconfig.me    # ✓ Correct
curl ifconfig.me       # ✗ Wrong (may return IPv6)
```

### Lost in Screen

```bash
# Detach from screen
Ctrl+A then D

# Or from outside:
screen -d gensyn

# Reattach:
screen -r gensyn
```

### Node Crashed

```bash
# Check logs
tail -50 ~/rl-swarm/logs/swarm.log

# Common fix: Reduce memory usage
cd ~/rl-swarm
sed -i -E 's/(num_train_samples:\s*)2/\11/' rgym_exp/config/rg-swarm.yaml

# Restart
screen -S gensyn -X quit
bash install.sh
```

---

## 📊 Monitor Your Node

### Dashboards
- Main: https://dashboard.gensyn.ai
- Stats: https://gensyn-node.vercel.app (enter your peer ID)
- Explorer: https://gensyn-testnet.explorer.alchemy.com

### View Logs
```bash
# Inside screen
screen -r gensyn
tail -f logs/swarm.log

# Outside screen
tail -f ~/rl-swarm/logs/swarm.log

# Last 100 lines
tail -100 ~/rl-swarm/logs/swarm.log
```

### Check Status
```bash
# Is screen running?
screen -ls | grep gensyn

# Is port 3000 open?
netstat -tlnp | grep 3000

# View live output
screen -r gensyn
```

---

## 🔄 Update Node

```bash
# 1. Backup first
~/backup-swarm.sh

# 2. Stop current
screen -S gensyn -X quit

# 3. Reinstall
bash install.sh

# 4. Choose "Keep existing identity"
```

---

## 📁 Important Files

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

# Auto backup script
~/backup-swarm.sh
```

---

## 💡 Pro Tips

### Add Aliases
```bash
echo 'alias gensyn="screen -r gensyn"' >> ~/.bashrc
echo 'alias gensyn-logs="tail -f ~/rl-swarm/logs/swarm.log"' >> ~/.bashrc
echo 'alias gensyn-backup="~/backup-swarm.sh"' >> ~/.bashrc
source ~/.bashrc

# Now just type:
gensyn
gensyn-logs
gensyn-backup
```

### Multiple Nodes
- Same email = same wallet
- Different swarm.pem = different peer IDs
- All rewards go to same wallet

### Auto Backup
```bash
# Daily backup at midnight
crontab -e
# Add:
0 0 * * * ~/backup-swarm.sh
```

### Reduce Memory Usage
```bash
cd ~/rl-swarm
sed -i -E 's/(num_train_samples:\s*)2/\11/' rgym_exp/config/rg-swarm.yaml
# Restart node
```

---

## 🖥️ System Requirements

### Minimum
- Ubuntu 20.04+
- 32GB RAM
- 50GB disk space
- Internet connection
- Node.js >= v14 (auto-installed by script)

### Recommended
- GPU (RTX 3090/4090, A100, H100)
- 64GB RAM
- 100GB SSD
- Stable connection
- Node.js v18+ (auto-installed by script)

---

## 🔐 Security

```bash
# Protect your identity
chmod 600 ~/rl-swarm/swarm.pem

# Never share publicly
# Never commit to git
# Always keep backups
```

---

## ❓ FAQ

**Q: How long does first run take?**
A: 2-5 minutes for dependency installation

**Q: Can I run without GPU?**
A: Yes! Choose "Low memory (CPU)" during setup

**Q: Where are my rewards?**
A: Same email = same wallet address

**Q: Lost my swarm.pem?**
A: Check backups: `ls ~/gensyn-backup-*`

**Q: Node keeps crashing?**
A: Reduce memory: See "Reduce Memory Usage" above

**Q: How to check if running?**
A: `screen -ls | grep gensyn`

---

## 📞 Support

- **GitHub**: [Report Issues](https://github.com/hidayahhtaufik/gensyn-tutorial/issues)
- **Twitter**: [@Hidayahhtaufik](https://twitter.com/Hidayahhtaufik)
- **Discord**: [Gensyn Official](https://discord.gg/AdnyWNzXh5)

---

## 📜 Quick Reference

See [COMMANDS.md](COMMANDS.md) for comprehensive command list.

```bash
# Install
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)

# Reattach
screen -r gensyn

# Backup
~/backup-swarm.sh

# Logs
tail -f ~/rl-swarm/logs/swarm.log

# Stop
screen -S gensyn -X quit
```

---

## ⚠️ Disclaimer

Experimental testnet software. Use at your own risk. Always backup your identity!

---

## 🙏 Credits

- Gensyn team for the amazing project
- Community for testing and feedback

---

<p align="center">
<b>Made with ❤️ by <a href="https://twitter.com/Hidayahhtaufik">@Hidayahhtaufik</a></b>
</p>

<p align="center">
⭐ Star this repo if it helped you!
</p>