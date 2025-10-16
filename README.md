# 🐝 Gensyn RL-SWARM Auto Installer

**Simple, reliable one-command installer for Gensyn RL-SWARM nodes**

[![Twitter](https://img.shields.io/twitter/follow/Hidayahhtaufik?style=social)](https://twitter.com/Hidayahhtaufik)
[![GitHub](https://img.shields.io/github/stars/hidayahhtaufik/gensyn-tutorial?style=social)](https://github.com/hidayahhtaufik/gensyn-tutorial)

## 🚀 Quick Start

```bash
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

---

## 💪 Features

- ✅ **Auto-install dependencies** - Everything automatically
- ✅ **Smart identity management** - Keep or start fresh
- ✅ **Training optimization** - Default or low memory mode
- ✅ **Auto backup script** - Creates ~/backup-swarm.sh
- ✅ **GPU/CPU detection** - Works on any hardware
- ✅ **Simple & reliable** - No complex automation

---

## 🖥️ System Requirements

### Minimum (CPU Mode)
- **RAM**: 32GB
- **CPU**: arm64 or x86
- **Python**: >= 3.10

### Recommended (GPU Mode)
- **GPU**: RTX 3090/4090, A100, H100
- **RAM**: 24GB+
- **Python**: >= 3.10

---

## 📖 Installation Guide

### Step 1: Run the Installer

```bash
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

The installer will:
1. Install dependencies
2. Handle swarm.pem (keep or fresh)
3. Configure training (default or low memory)
4. Start rl-swarm

### Step 2: Setup Localtunnel (In NEW Terminal)

**Open a new terminal/tab** and run:

```bash
# Get your IPv4 address (this is the password)
curl -4 ifconfig.me
# Example output: 46.4.156.234

# Start localtunnel
lt --port 3000
# Example output: https://true-things-cry.loca.lt
```

### Step 3: Access and Login

1. Open the localtunnel URL in browser
2. Enter your IPv4 address as password
3. Login with email/Google
4. Done! 🎉

---

## 💾 Backup Your Identity

### Auto Backup
```bash
~/backup-swarm.sh
```

### Manual Backup
```bash
cp ~/rl-swarm/swarm.pem ~/swarm_backup.pem
```

**⚠️ Important:** Always backup `swarm.pem` before updates!

---

## 📊 Monitor Your Node

### Dashboard
- Main: https://dashboard.gensyn.ai
- Stats: https://gensyn-node.vercel.app

### Check Logs
```bash
tail -f ~/rl-swarm/logs/swarm.log
```

### Reattach Screen
```bash
screen -r gensyn
# Ctrl+A then D to detach
```

---

## 🛠️ Common Commands

```bash
# Backup identity
~/backup-swarm.sh

# View logs
tail -f ~/rl-swarm/logs/swarm.log

# Reattach screen
screen -r gensyn

# Get IPv4 for localtunnel password
curl -4 ifconfig.me

# Start localtunnel (in separate terminal)
lt --port 3000

# Reduce memory usage
cd ~/rl-swarm
sed -i -E 's/(num_train_samples:\s*)2/\11/' rgym_exp/config/rg-swarm.yaml
```

---

## 🆘 Troubleshooting

### OOM (Out of Memory) Error
```bash
# Reduce training samples
cd ~/rl-swarm
sed -i -E 's/(num_train_samples:\s*)2/\11/' rgym_exp/config/rg-swarm.yaml

# For MacBook
export PYTORCH_MPS_HIGH_WATERMARK_RATIO=0.0
```

### Localtunnel Password Error
```bash
# Make sure to use IPv4, not IPv6!
curl -4 ifconfig.me    # Use this! (Example: 46.4.156.234)

# NOT this:
curl ifconfig.me       # Might return IPv6 (Example: 2a01:4f8:...)
```

### Localtunnel Not Starting
```bash
# Reinstall
npm uninstall -g localtunnel
npm install -g localtunnel

# Start
lt --port 3000
```

### Lost swarm.pem
```bash
# Check backups
ls ~/gensyn-backup*/
ls ~/swarm_backup.pem

# Or start fresh and run installer again
```

### Node Not Training
```bash
# Check logs
tail -50 ~/rl-swarm/logs/swarm.log

# Restart
screen -r gensyn
# Press Ctrl+C, then restart
```

---

## 🔄 Update Node

```bash
# Backup first!
~/backup-swarm.sh

# Run installer again
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)

# Choose: Keep existing identity
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

### Running Multiple Terminals

**Terminal 1 (rl-swarm):**
```bash
screen -r gensyn
# rl-swarm runs here
```

**Terminal 2 (localtunnel):**
```bash
lt --port 3000
# Get URL and password
```

### Multiple Nodes
- Use same email = linked to same wallet
- Different swarm.pem = different peer IDs
- All rewards go to same wallet

### Backup Schedule
```bash
# Add to cron for daily backup
0 0 * * * ~/backup-swarm.sh
```

---

## 🤝 Contributing

Found a bug? Have an improvement?

1. Fork this repo
2. Create feature branch
3. Commit changes
4. Push to branch
5. Open Pull Request

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/hidayahhtaufik/gensyn-tutorial/issues)
- **Twitter**: [@Hidayahhtaufik](https://twitter.com/Hidayahhtaufik)
- **Discord**: [Gensyn Official](https://discord.gg/AdnyWNzXh5)

---

## ⚠️ Disclaimer

This is experimental testnet software. Provided "as-is" for users interested in helping develop the Gensyn Protocol.

---

## 📜 License

MIT License - Free to use, modify, and distribute!

---

<p align="center">
<b>Made with ❤️ by <a href="https://twitter.com/Hidayahhtaufik">@Hidayahhtaufik</a></b>
</p>

<p align="center">
⭐ Star this repo if it helped you!
</p>