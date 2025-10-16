# 🐝 Gensyn RL-SWARM Auto Installer

**One powerful command for Gensyn RL-SWARM nodes**

[![Twitter](https://img.shields.io/twitter/follow/Hidayahhtaufik?style=social)](https://twitter.com/Hidayahhtaufik)
[![GitHub](https://img.shields.io/github/stars/hidayahhtaufik/gensyn-tutorial?style=social)](https://github.com/hidayahhtaufik/gensyn-tutorial)

## 🚀 Quick Start

```bash
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

---

## 💪 Features

- ✅ **Auto-install dependencies** - Everything automatically
- ✅ **Smart identity management** - Keep, restore, or start fresh
- ✅ **Training optimization** - Default, low memory, or custom
- ✅ **Auto backup script** - Creates ~/backup-swarm.sh
- ✅ **GPU/CPU detection** - Works on any hardware
- ✅ **Proper screen management** - RL-SWARM stays running
- ✅ **Smart localtunnel setup** - Auto IPv4 detection

---

## 📖 Complete Installation Guide

### Step 1: Run the Installer

```bash
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

The installer will:
1. Install dependencies (curl, wget, git, python3, npm, screen, localtunnel)
2. Handle identity management (keep/restore/fresh)
3. Configure training settings
4. Detect hardware (GPU/CPU)
5. Start RL-SWARM in screen session 'gensyn'

### Step 2: Localtunnel Setup (AUTOMATED!)

**The installer automatically handles localtunnel!**

What happens:
1. RL-SWARM starts in screen 'gensyn' (background)
2. Script exits screen and shows localtunnel setup
3. Your IPv4 address displayed as password
4. Localtunnel starts (in main terminal, OUTSIDE screen)
5. Copy the URL and open in browser
6. Login with your IPv4 as password
7. Press Ctrl+C after successful login
8. Script asks if you want to enter screen for manual config

**Flow:**
```
Terminal (Main) → Screen 'gensyn' (RL-SWARM running) 
→ Exit to Main Terminal → Localtunnel (outside screen)
→ Login → Stop localtunnel → Reattach to screen (optional)
```

### Step 3: Manual Configuration (If Needed)

After localtunnel login, you can reattach to screen:

```bash
# Reattach to screen
screen -r gensyn

# View logs
tail -f logs/swarm.log

# Edit config if needed
nano rgym_exp/config/rg-swarm.yaml

# Detach from screen
# Press: Ctrl+A then D
```

---

## 💾 Backup Your Identity

### Prepare Backup Folder (Before Installation)

If you have existing swarm.pem:

```bash
# Create backup folder
mkdir -p ~/backup

# Place your swarm.pem inside
cp /path/to/your/swarm.pem ~/backup/

# Optional: include other files
cp /path/to/userData.json ~/backup/
cp /path/to/userApiKey.json ~/backup/
```

**Backup folder structure:**
```
~/backup/
├── swarm.pem              # Required!
├── userData.json          # Optional
└── userApiKey.json        # Optional
```

### During Installation

When installer runs:
1. It detects existing installation
2. Choose option 2: "Restore from backup folder"
3. Enter backup path: `~/backup`
4. Installer copies swarm.pem to rl-swarm directory

### Create Backup After Installation

```bash
# Auto backup script (created by installer)
~/backup-swarm.sh

# Manual backup
mkdir -p ~/backup
cp ~/rl-swarm/swarm.pem ~/backup/
cp ~/rl-swarm/modal-login/temp-data/*.json ~/backup/
```

---

## 📊 Monitor Your Node

### Dashboard
- Main: https://dashboard.gensyn.ai
- Stats: https://gensyn-node.vercel.app (enter your peer ID)
- Explorer: https://gensyn-testnet.explorer.alchemy.com

### Check Logs
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

---

## 🛠️ Common Commands

```bash
# Reattach to screen
screen -r gensyn

# Detach from screen
Ctrl+A then D

# Backup identity
~/backup-swarm.sh

# View logs (inside screen)
tail -f ~/rl-swarm/logs/swarm.log

# Get IPv4 for localtunnel
curl -4 ifconfig.me

# Restart node (inside screen)
cd ~/rl-swarm
. .venv/bin/activate
./run_rl_swarm.sh

# Kill screen session
screen -X -S gensyn quit

# List all screens
screen -ls
```

---

## 🎯 Understanding the Flow

### Why This Flow?

**RL-SWARM MUST stay running** while you setup localtunnel. Here's why:

1. RL-SWARM creates port 3000
2. Localtunnel connects to port 3000
3. You login via browser
4. After login, you can stop localtunnel
5. RL-SWARM continues running for training

### Terminal Management

**During Installation:**
```
Terminal → Installer runs
         → Screen 'gensyn' created (RL-SWARM starts)
         → Exit to main terminal
         → Localtunnel starts (OUTSIDE screen)
         → User opens URL & login
         → User presses Ctrl+C (stop localtunnel)
         → Option to reattach to screen
```

**After Installation:**
- RL-SWARM: Running in screen 'gensyn'
- Access: `screen -r gensyn`
- Localtunnel: No longer needed (can close)

---

## 🆘 Troubleshooting

### OOM (Out of Memory)
```bash
screen -r gensyn
cd ~/rl-swarm
sed -i -E 's/(num_train_samples:\s*)2/\11/' rgym_exp/config/rg-swarm.yaml
# Press Ctrl+C to stop
./run_rl_swarm.sh
```

### Localtunnel Password Error
```bash
# MUST use IPv4, not IPv6!
curl -4 ifconfig.me    # ✓ Correct! (46.4.156.234)
curl ifconfig.me       # ✗ Wrong! Might return IPv6
```

### Lost swarm.pem
```bash
# Check backups
ls ~/gensyn-backup-*/
ls ~/backup/

# If lost, run installer and start fresh (option 3)
```

### Node Not Training
```bash
# Check logs
screen -r gensyn
tail -50 logs/swarm.log

# Restart
Ctrl+C
./run_rl_swarm.sh
```

### Screen Session Issues
```bash
# List all screens
screen -ls

# Kill old session
screen -X -S gensyn quit

# Start fresh
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

### Localtunnel Won't Start
```bash
# Reinstall localtunnel
sudo npm uninstall -g localtunnel
sudo npm install -g localtunnel

# Try alternative tunnel
sudo npm install -g cloudflared
cloudflared tunnel --url http://localhost:3000
```

---

## 🔄 Update Node

```bash
# 1. Backup first!
~/backup-swarm.sh

# 2. Stop current
screen -X -S gensyn quit

# 3. Run installer again
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)

# 4. Choose: Keep existing (option 1) OR restore from backup (option 2)
```

---

## 📁 Important Files

```bash
~/rl-swarm/swarm.pem                           # Your identity (BACKUP THIS!)
~/rl-swarm/modal-login/temp-data/*.json        # User data
~/rl-swarm/logs/swarm.log                      # Training logs
~/rl-swarm/rgym_exp/config/rg-swarm.yaml       # Configuration
~/backup-swarm.sh                              # Auto-created backup script
```

---

## 💡 Pro Tips

### Quick Aliases
```bash
# Add to ~/.bashrc
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
- Use same email = same wallet
- Different swarm.pem = different peer IDs
- All rewards → same wallet

### Daily Backup
```bash
# Add to crontab
crontab -e
# Add this line:
0 0 * * * ~/backup-swarm.sh
```

### Auto-Restart on Crash
```bash
# Inside screen
screen -r gensyn
cd ~/rl-swarm
. .venv/bin/activate

# Run with auto-restart
while true; do
    ./run_rl_swarm.sh
    echo "Crashed! Restarting in 10 seconds..."
    sleep 10
done
```

---

## 🖥️ System Requirements

### Minimum (CPU)
- **RAM**: 32GB
- **CPU**: arm64 or x86
- **Disk**: 50GB free space
- **Python**: >= 3.10
- **OS**: Ubuntu 20.04+

### Recommended (GPU)
- **GPU**: RTX 3090/4090, A100, H100
- **RAM**: 32GB+
- **Disk**: 100GB+ SSD
- **Python**: >= 3.10
- **CUDA**: 11.8+

---

## 🔐 Security Notes

### Protect Your swarm.pem
```bash
# Set proper permissions
chmod 600 ~/rl-swarm/swarm.pem

# Never share publicly
# Never commit to git
# Always backup securely
```

### Firewall (Optional)
```bash
# Allow only necessary ports
sudo ufw allow 3000/tcp  # For localtunnel
sudo ufw enable
```

---

## 🤝 Contributing

Found a bug? Have an improvement?

1. Fork the repo
2. Create feature branch: `git checkout -b feature-name`
3. Commit changes: `git commit -am 'Add feature'`
4. Push to branch: `git push origin feature-name`
5. Open Pull Request

---

## 📞 Support

- **GitHub Issues**: [Report bugs](https://github.com/hidayahhtaufik/gensyn-tutorial/issues)
- **Twitter**: [@Hidayahhtaufik](https://twitter.com/Hidayahhtaufik)
- **Discord**: [Gensyn Official](https://discord.gg/AdnyWNzXh5)

---

## ⚠️ Disclaimer

This is experimental testnet software. Use at your own risk. Always backup your swarm.pem!

---

## 📜 License

MIT License

---

## 🙏 Acknowledgments

- Gensyn team for the amazing project
- Community for testing and feedback
- Contributors for improvements

---

<p align="center">
<b>Made with ❤️ by <a href="https://twitter.com/Hidayahhtaufik">@Hidayahhtaufik</a></b>
</p>

<p align="center">
⭐ Star this repo if it helped you!
</p>