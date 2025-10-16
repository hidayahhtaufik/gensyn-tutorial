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

---

## 📖 Complete Installation Guide

### Step 1: Run the Installer

```bash
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

The installer will:
1. Install dependencies
2. Handle swarm.pem (keep/restore/fresh)
3. Configure training
4. Start rl-swarm in screen session

### Step 2: Setup Localtunnel (IMPORTANT!)

**The installer will run rl-swarm in screen 'gensyn'**

Now you need to setup localtunnel **in a NEW terminal (outside the screen)**:

#### Open NEW Terminal/Tab

```bash
# 1. Get your IPv4 password
curl -4 ifconfig.me
# Example output: 46.4.156.234

# 2. Start localtunnel
lt --port 3000
# Example output: https://true-things-cry.loca.lt
```

#### Login in Browser

1. Open the localtunnel URL
2. Enter your IPv4 address as password
3. Login with email/Google
4. Wait for OTP and complete login

#### Exit Localtunnel

After successful login:
```bash
# Press Ctrl+C to stop localtunnel
# You don't need it running anymore!
```

### Step 3: Reattach to Screen (If Needed)

If you need to manually configure or check logs:

```bash
# Reattach to screen
screen -r gensyn

# View logs
tail -f logs/swarm.log

# Detach from screen
# Press: Ctrl+A then D
```

---

## 💾 Backup Your Identity

### Create Backup

```bash
# Auto backup script
~/backup-swarm.sh

# Manual backup
mkdir -p ~/backup
cp ~/rl-swarm/swarm.pem ~/backup/
```

### Restore from Backup

**When running installer:**
1. Choose option 2: "Restore from backup folder"
2. Enter backup folder path (e.g., `~/backup`)
3. Installer will find swarm.pem inside

**Backup folder structure:**
```
~/backup/
├── swarm.pem              # Required!
├── userData.json          # Optional
└── userApiKey.json        # Optional
```

---

## 📊 Monitor Your Node

### Dashboard
- Main: https://dashboard.gensyn.ai
- Stats: https://gensyn-node.vercel.app (enter your peer ID)

### Check Logs
```bash
# Reattach to screen first
screen -r gensyn

# View logs
tail -f ~/rl-swarm/logs/swarm.log

# Detach
Ctrl+A then D
```

---

## 🛠️ Common Commands

```bash
# Backup identity
~/backup-swarm.sh

# View logs
screen -r gensyn
tail -f ~/rl-swarm/logs/swarm.log

# Reattach screen
screen -r gensyn

# Detach from screen
Ctrl+A then D

# Get IPv4 for localtunnel
curl -4 ifconfig.me

# Start localtunnel (in separate terminal, OUTSIDE screen)
lt --port 3000

# Reduce memory usage
cd ~/rl-swarm
sed -i -E 's/(num_train_samples:\s*)2/\11/' rgym_exp/config/rg-swarm.yaml
```

---

## 🎯 Understanding the Flow

### Terminal Management

**Terminal 1 (Screen "gensyn"):**
- Installer runs here
- RL-SWARM runs here
- **Stays running forever!**
- Access: `screen -r gensyn`

**Terminal 2 (Regular terminal, OUTSIDE screen):**
- Run localtunnel here
- Login in browser
- Exit localtunnel (Ctrl+C) after login
- Can close this terminal after

**Terminal 1 again (If needed):**
- Reattach: `screen -r gensyn`
- Manual config
- Check logs
- Detach: `Ctrl+A then D`

---

## 🆘 Troubleshooting

### OOM (Out of Memory)
```bash
# Reduce training samples
screen -r gensyn
cd ~/rl-swarm
sed -i -E 's/(num_train_samples:\s*)2/\11/' rgym_exp/config/rg-swarm.yaml
# Restart rl-swarm
```

### Localtunnel Password Error
```bash
# MUST use IPv4, not IPv6!
curl -4 ifconfig.me    # Correct! (46.4.156.234)
curl ifconfig.me       # Wrong! Might return IPv6
```

### Lost swarm.pem
```bash
# Check backups
ls ~/gensyn-backup-*/
ls ~/backup/

# If lost, run installer and start fresh
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

---

## 🔄 Update Node

```bash
# 1. Backup first!
~/backup-swarm.sh

# 2. Run installer again
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)

# 3. Choose: Keep existing OR restore from backup
```

---

## 📁 Important Files

```bash
~/rl-swarm/swarm.pem                           # Your identity (BACKUP!)
~/rl-swarm/modal-login/temp-data/*.json        # User data
~/rl-swarm/logs/swarm.log                      # Training logs
~/rl-swarm/rgym_exp/config/rg-swarm.yaml       # Configuration
~/backup-swarm.sh                              # Auto-created backup script
```

---

## 💡 Pro Tips

### Multiple Nodes
- Use same email = same wallet
- Different swarm.pem = different peer IDs
- All rewards → same wallet

### Backup Schedule
```bash
# Daily backup (add to crontab)
0 0 * * * ~/backup-swarm.sh
```

### Quick Reattach
```bash
# Add alias to ~/.bashrc
alias gensyn='screen -r gensyn'

# Then just type:
gensyn
```

### Manual Configuration
After login, you can manually configure:
```bash
screen -r gensyn
cd ~/rl-swarm
nano rgym_exp/config/rg-swarm.yaml
# Edit settings
# Ctrl+X, Y, Enter to save
# Restart rl-swarm
```

---

## 🖥️ System Requirements

### Minimum (CPU)
- **RAM**: 32GB
- **CPU**: arm64 or x86
- **Python**: >= 3.10

### Recommended (GPU)
- **GPU**: RTX 3090/4090, A100, H100
- **RAM**: 24GB+
- **Python**: >= 3.10

---

## 🤝 Contributing

Found a bug? Improvement?

1. Fork repo
2. Create feature branch
3. Commit changes
4. Push
5. Open Pull Request

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/hidayahhtaufik/gensyn-tutorial/issues)
- **Twitter**: [@Hidayahhtaufik](https://twitter.com/Hidayahhtaufik)
- **Discord**: [Gensyn Official](https://discord.gg/AdnyWNzXh5)

---

## ⚠️ Disclaimer

Experimental testnet software. Use at your own risk.

---

## 📜 License

MIT License

---

<p align="center">
<b>Made with ❤️ by <a href="https://twitter.com/Hidayahhtaufik">@Hidayahhtaufik</a></b>
</p>

<p align="center">
⭐ Star this repo if it helped you!
</p>