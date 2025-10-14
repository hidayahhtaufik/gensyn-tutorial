# 🐝 Gensyn RL-SWARM Auto Installer

**One powerful command to run Gensyn RL-SWARM nodes**

[![Twitter](https://img.shields.io/twitter/follow/Hidayahhtaufik?style=social)](https://twitter.com/Hidayahhtaufik)
[![GitHub](https://img.shields.io/github/stars/hidayahhtaufik/gensyn-tutorial?style=social)](https://github.com/hidayahhtaufik/gensyn-tutorial)

## 🚀 Quick Start

```bash
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

**That's it!** The installer handles everything automatically.

---

## 💪 Features

- ✅ **Auto-install dependencies** - Everything you need, automatically
- ✅ **Smart identity management** - Keep, restore, or create new
- ✅ **Training optimization** - Default, low memory, or custom
- ✅ **Auto backup script** - Creates ~/backup-swarm.sh
- ✅ **Remote access** - Optional localtunnel for VPS/VM
- ✅ **GPU/CPU detection** - Works on any hardware

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

### 1. Run the Installer

```bash
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

### 2. Choose Your Options

**Identity:**
- Keep existing (if found)
- Restore from backup
- Start fresh

**Training:**
- Default (for GPU)
- Low memory (for CPU)
- Custom

**Network:**
- Remote access (VPS/VM)
- Localhost only

### 3. Login and Start

```
Access: https://xxxx.loca.lt
Password: shown-in-terminal
```

1. Open URL
2. Enter password
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

# Check GPU
nvidia-smi

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

### Localtunnel Not Working
```bash
npm install -g localtunnel
lt --port 3000
```

### Lost swarm.pem
```bash
# Check backups
ls ~/gensyn-backup*/
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
```

---

## 💡 Pro Tips

1. **Multiple Nodes**: Use same email = linked to same wallet
2. **Backup Often**: Run `~/backup-swarm.sh` regularly
3. **Check Dashboard Daily**: Track progress and rewards
4. **Join Discord**: https://discord.gg/AdnyWNzXh5

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