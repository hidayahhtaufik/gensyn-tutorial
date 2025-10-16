# 🎯 Gensyn Installation Flow Guide

## The Proper Way

### 📋 Overview

```
┌─────────────────────────────────────┐
│  Terminal 1: Screen "gensyn"        │
│  → Installer runs here              │
│  → RL-SWARM runs here              │
│  → STAYS RUNNING FOREVER!           │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  Terminal 2: Regular (NO SCREEN)    │
│  → Run localtunnel here             │
│  → Login in browser                 │
│  → Ctrl+C to exit after login       │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  Terminal 1 again (if needed)       │
│  → screen -r gensyn                 │
│  → Manual config                    │
│  → Check logs                       │
│  → Ctrl+A D to detach               │
└─────────────────────────────────────┘
```

---

## 🔄 Step-by-Step Visual

### Step 1: Run Installer

```bash
# In Terminal 1
bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)

# Installer creates screen "gensyn"
# You're now INSIDE the screen
```

**What happens:**
```
[Screen: gensyn] Terminal 1
├── Install dependencies
├── Handle swarm.pem
├── Configure training
├── Detect GPU/CPU
└── Start rl-swarm
    └── Running... (localhost:3000 available)
```

---

### Step 2: Open NEW Terminal

**IMPORTANT:** Open a **completely new terminal/tab**

This terminal is **OUTSIDE** the screen session!

```bash
# In Terminal 2 (NEW, outside screen)

# Get password
curl -4 ifconfig.me
# Output: 46.4.156.234

# Start localtunnel
lt --port 3000
# Output: https://true-things-cry.loca.lt
```

**Visual:**
```
[Screen: gensyn] Terminal 1
└── rl-swarm running ✓

[Regular Terminal] Terminal 2
└── localtunnel running
    └── URL: https://true-things-cry.loca.lt
    └── Password: 46.4.156.234
```

---

### Step 3: Login in Browser

1. Open `https://true-things-cry.loca.lt`
2. Enter password `46.4.156.234`
3. Login with email/Google
4. Enter OTP
5. ✅ Login successful!

**Visual:**
```
Browser
└── Localtunnel URL
    └── Enter password: 46.4.156.234
    └── Login form
    └── OTP verification
    └── ✓ Success!

[Screen: gensyn] Terminal 1
└── rl-swarm sees login ✓
    └── Starts training

[Regular Terminal] Terminal 2
└── localtunnel shows: Connection established
```

---

### Step 4: Exit Localtunnel

After successful login, you don't need localtunnel anymore!

```bash
# In Terminal 2
# Press: Ctrl+C

^C
Localtunnel stopped

# You can close this terminal now
```

**Visual:**
```
[Screen: gensyn] Terminal 1
└── rl-swarm STILL RUNNING ✓
    └── Training continues

[Regular Terminal] Terminal 2
└── localtunnel STOPPED
    └── Can close this terminal
```

---

### Step 5: Reattach to Screen (If Needed)

For manual config or checking logs:

```bash
# In any terminal
screen -r gensyn

# You're now back in Terminal 1 (screen)
```

**Visual:**
```
[Screen: gensyn] Terminal 1 (reattached)
├── rl-swarm running
├── View logs: tail -f logs/swarm.log
├── Edit config: nano rgym_exp/config/rg-swarm.yaml
└── Detach: Ctrl+A then D
```

---

## 🔑 Key Points

### ✅ DO:
- Run installer in Terminal 1
- Open NEW terminal for localtunnel
- Use `screen -r gensyn` to reattach
- Use `Ctrl+A D` to detach from screen
- Exit localtunnel with `Ctrl+C` after login

### ❌ DON'T:
- Don't run localtunnel inside screen
- Don't close Terminal 1 while rl-swarm is running
- Don't keep localtunnel running after login
- Don't confuse screen session with regular terminal

---

## 📝 Command Reference

### Screen Commands
```bash
# Create screen
screen -S gensyn

# List screens
screen -ls

# Reattach
screen -r gensyn

# Detach (inside screen)
Ctrl+A then D

# Kill screen
screen -X -S gensyn quit
```

### Localtunnel Commands
```bash
# Get password (IPv4)
curl -4 ifconfig.me

# Start localtunnel
lt --port 3000

# Stop localtunnel
Ctrl+C
```

### RL-SWARM Commands
```bash
# Inside screen
cd ~/rl-swarm
. .venv/bin/activate
./run_rl_swarm.sh

# View logs
tail -f logs/swarm.log

# Edit config
nano rgym_exp/config/rg-swarm.yaml
```

---

## 🎬 Example Session

```bash
# === Terminal 1 ===
$ bash <(curl -s https://raw.githubusercontent.com/.../install.sh)
[Installer runs...]
[rl-swarm starts...]
# Press Ctrl+A then D to detach

# === Terminal 2 (NEW) ===
$ curl -4 ifconfig.me
46.4.156.234

$ lt --port 3000
your url is: https://true-things-cry.loca.lt

# Open browser, login
# After success, press Ctrl+C

^C

# === Terminal 1 again (if needed) ===
$ screen -r gensyn
# Check logs, configure
# Press Ctrl+A then D to detach
```

---

## ⚠️ Common Mistakes

### Mistake 1: Running localtunnel inside screen
```bash
# ❌ WRONG
screen -S gensyn
lt --port 3000  # Don't do this!

# ✅ CORRECT
# Terminal 1: screen with rl-swarm
# Terminal 2: regular terminal with localtunnel
```

### Mistake 2: Closing terminal while screen is running
```bash
# ❌ WRONG
# Close terminal where screen is running
# This kills the screen!

# ✅ CORRECT
# Detach first: Ctrl+A then D
# Then close terminal
```

### Mistake 3: Using IPv6 as password
```bash
# ❌ WRONG
curl ifconfig.me  # Returns IPv6: 2a01:4f8:...

# ✅ CORRECT
curl -4 ifconfig.me  # Returns IPv4: 46.4.156.234
```

---

## 🎓 Summary

1. **Installer** → runs in screen "gensyn" (Terminal 1)
2. **RL-SWARM** → runs in screen, stays running
3. **Localtunnel** → runs OUTSIDE screen (Terminal 2)
4. **After login** → exit localtunnel, keep rl-swarm running
5. **Manual config** → reattach to screen when needed

**Remember:** Screen "gensyn" = RL-SWARM running forever!

---

Made with ❤️ by [@Hidayahhtaufik](https://twitter.com/Hidayahhtaufik)