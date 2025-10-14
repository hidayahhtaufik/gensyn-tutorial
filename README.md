# 🐝 Gensyn RL-SWARM Tutorial

**One-click installation script for running Gensyn RL-SWARM nodes**

[![Twitter](https://img.shields.io/twitter/follow/Hidayahhtaufik?style=social)](https://twitter.com/Hidayahhtaufik)
[![GitHub](https://img.shields.io/github/stars/hidayahhtaufik/gensyn-tutorial?style=social)](https://github.com/hidayahhtaufik/gensyn-tutorial)

## 🚀 Quick Start

### One-Line Installation

```bash
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

That's it! The script will:
- ✅ Install all dependencies automatically
- ✅ Setup localtunnel for easy access
- ✅ Handle existing swarm.pem (or create new)
- ✅ Start training immediately

## 📋 What This Script Does

### Features
- **Auto-dependency installation**: curl, wget, git, python3, npm, localtunnel
- **Smart swarm.pem handling**: Keep your identity or start fresh
- **Automatic localtunnel**: No port forwarding needed!
- **GPU detection**: Automatically detects NVIDIA GPUs
- **Screen session management**: Runs in background

### Installation Steps
The script automatically:
1. Checks and installs dependencies
2. Handles existing swarm.pem file
3. Sets up localtunnel for localhost:3000
4. Detects GPU (if available)
5. Starts RL-SWARM training

## 🖥️ System Requirements

### Minimum (CPU Mode)
- **RAM**: 32GB
- **CPU**: arm64 or x86
- **Python**: >= 3.10

### Recommended (GPU Mode)
- **GPU**: RTX 3090/4090, A100, H100
- **RAM**: 24GB+
- **Python**: >= 3.10

## 📖 Detailed Guide

### Step 1: Run Installation

```bash
# One-line install
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

### Step 2: Choose Identity Option

When the script detects existing `swarm.pem`:
- **Option 1**: Use existing (keeps your node identity and rewards)
- **Option 2**: Start fresh (new identity)

### Step 3: Access Login Page

The script will show:
```
Tunnel URL: https://xxxx.loca.lt
Password: your-vps-ip or from https://loca.lt/mytunnelpassword
```

1. Open the tunnel URL in browser
2. Enter the password
3. Login with email/Google
4. Training starts automatically!

### Step 4: Track Progress

- **Dashboard**: https://dashboard.gensyn.ai
- **Explorer**: https://gensyn-testnet.explorer.alchemy.com
- **Your terminal**: Live training logs

## 🔧 Manual Installation (Advanced)

If you prefer manual control:

```bash
# 1. Clone repo
git clone https://github.com/gensyn-ai/rl-swarm
cd rl-swarm

# 2. Create virtual environment
python3 -m venv .venv
source .venv/bin/activate

# 3. Setup localtunnel (in another terminal)
npm install -g localtunnel
lt --port 3000

# 4. Run swarm
./run_rl_swarm.sh
```

## 📊 Monitoring Your Node

### Check Logs
```bash
# Reattach to screen session
screen -r gensyn

# Detach: Ctrl+A then D
```

### Check Stats
Visit these URLs:
- Dashboard: https://dashboard.gensyn.ai
- Your wins: https://gensyn-node.vercel.app (enter your peer ID)

### What to Look For
- ✅ **Participation**: Number of rounds completed
- ✅ **Training Rewards**: Rewards earned
- ✅ **Peer ID**: Your unique animal name (e.g., "eager squinting bee")
- ✅ **Connected EOA**: Your wallet address (should NOT be 0x000...)

## 🛠️ Troubleshooting

### Node Not Training?
```bash
# Check if screen session is running
screen -ls

# Reattach to see logs
screen -r gensyn
```

### Localtunnel Not Working?
```bash
# Install manually
npm install -g localtunnel

# Run in new terminal
lt --port 3000
```

### Want to Use Different Email?
```bash
# Delete existing identity
rm ~/rl-swarm/swarm.pem
rm ~/rl-swarm/modal-login/temp-data/*.json

# Run installation again
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)
```

### OOM Errors (Out of Memory)?
```bash
# For MacBook users
export PYTORCH_MPS_HIGH_WATERMARK_RATIO=0.0

# Then restart swarm
cd ~/rl-swarm
source .venv/bin/activate
./run_rl_swarm.sh
```

## 🔄 Updating Your Node

When Gensyn releases updates:

```bash
# Stop current node
screen -r gensyn
# Press Ctrl+C

# Run installation again (it will backup swarm.pem)
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)

# Choose option 1 to keep your identity
```

## 📁 Important Files

### Your Identity Files
- `~/rl-swarm/swarm.pem` - **BACKUP THIS!** Your node identity
- `~/rl-swarm/modal-login/temp-data/userData.json` - User data
- `~/rl-swarm/modal-login/temp-data/userApiKey.json` - API keys

### Logs
- `~/rl-swarm/logs/swarm.log` - Main training logs
- `~/rl-swarm/logs/yarn.log` - Login server logs

## 🎯 Tips for Better Performance

1. **Keep swarm.pem safe**: Backup to multiple locations
2. **Use same email for multiple nodes**: Link all to one wallet
3. **Check dashboard daily**: Track your progress and rewards
4. **Join community**: [Gensyn Discord](https://discord.gg/AdnyWNzXh5)
5. **Don't worry about skipped rounds**: Normal on slower hardware

## 🐝 Understanding the Swarm

### How It Works
- **Stage 1 (Answering)**: Your model solves reasoning problems
- **Stage 2 (Critiquing)**: Models review each other's answers  
- **Stage 3 (Resolving)**: Collective decision on best answer

### Why It's Fast
- **SAPO Algorithm**: 94% faster learning vs solo training
- **Collective Intelligence**: Learn from thousands of nodes
- **Shared Rollouts**: Breakthroughs propagate across network

## 🤝 Contributing

Found a bug? Have an improvement?

1. Fork this repo
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/hidayahhtaufik/gensyn-tutorial/issues)
- **Twitter**: [@Hidayahhtaufik](https://twitter.com/Hidayahhtaufik)
- **Official**: [Gensyn Discord](https://discord.gg/AdnyWNzXh5)

## ⚠️ Disclaimer

This is an experimental testnet. The software is provided "as-is" for users interested in helping develop the Gensyn Protocol.

## 📜 License

MIT License - feel free to use, modify, and distribute!

---

<p align="center">
Made with ❤️ by <a href="https://twitter.com/Hidayahhtaufik">@Hidayahhtaufik</a>
</p>

<p align="center">
⭐ Star this repo if it helped you!
</p>