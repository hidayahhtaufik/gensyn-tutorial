#!/bin/bash

# Gensyn RL-SWARM One-Click Installer
# By @Hidayahhtaufik
# Everything you need in one script!

set -e

BOLD="\e[1m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
MAGENTA="\e[35m"
NC="\e[0m"

SWARM_DIR="$HOME/rl-swarm"

# Banner
clear
echo -e "${CYAN}${BOLD}"
echo "╔═══════════════════════════════════════════╗"
echo "║   Gensyn RL-SWARM One-Click Installer    ║"
echo "║         By @Hidayahhtaufik               ║"
echo "╚═══════════════════════════════════════════╝"
echo -e "${NC}\n"

# Step 1: Dependencies
echo -e "${CYAN}${BOLD}[1/5] Installing Dependencies...${NC}"
deps=("curl" "wget" "git" "python3" "npm" "screen")
missing=()
for dep in "${deps[@]}"; do
    command -v "$dep" &>/dev/null || missing+=("$dep")
done

if [ ${#missing[@]} -gt 0 ]; then
    echo -e "${YELLOW}Installing: ${missing[*]}${NC}"
    sudo apt update -qq
    sudo apt install -y curl wget git python3 python3-venv python3-pip npm build-essential screen -qq 2>&1 | grep -v "debconf"
fi

if ! command -v lt &>/dev/null; then
    echo -e "${YELLOW}Installing localtunnel...${NC}"
    sudo npm install -g localtunnel --silent 2>&1 | grep -v "npm WARN"
fi
echo -e "${GREEN}[✓] Dependencies ready${NC}\n"

# Step 2: Identity Management
echo -e "${CYAN}${BOLD}[2/5] Identity Management${NC}\n"
if [ -f "$SWARM_DIR/swarm.pem" ]; then
    echo -e "${YELLOW}[!] Existing installation found${NC}\n"
    echo -e "${BOLD}Options:${NC}"
    echo -e "${GREEN}1)${NC} Keep existing identity"
    echo -e "${BLUE}2)${NC} Restore from backup folder"
    echo -e "${RED}3)${NC} Start fresh"
    read -p $'\e[1m\nChoice [1/2/3]: \e[0m' choice
    
    case $choice in
        2)
            echo -e "\n${CYAN}Enter backup folder path (e.g., ~/backup):${NC}"
            read -p "Path: " backup_folder
            backup_folder="${backup_folder/#\~/$HOME}"
            if [ -f "$backup_folder/swarm.pem" ]; then
                cp "$backup_folder/swarm.pem" "$SWARM_DIR/"
                [ -f "$backup_folder/userData.json" ] && cp "$backup_folder/userData.json" "$SWARM_DIR/modal-login/temp-data/" 2>/dev/null
                echo -e "${GREEN}[✓] Restored from backup${NC}"
            else
                echo -e "${RED}swarm.pem not found! Starting fresh...${NC}"
                rm -rf "$SWARM_DIR"
                git clone https://github.com/gensyn-ai/rl-swarm.git "$SWARM_DIR" -q
            fi
            ;;
        3)
            echo -e "\n${CYAN}Starting fresh...${NC}"
            rm -rf "$SWARM_DIR"
            git clone https://github.com/gensyn-ai/rl-swarm.git "$SWARM_DIR" -q
            echo -e "${GREEN}[✓] Fresh install${NC}"
            ;;
        *)
            echo -e "\n${GREEN}[✓] Keeping existing${NC}"
            ;;
    esac
else
    echo -e "${CYAN}No existing installation${NC}\n"
    echo -e "${BOLD}Have a backup?${NC}"
    echo -e "${GREEN}1)${NC} Yes, restore"
    echo -e "${YELLOW}2)${NC} No, start fresh"
    read -p $'\e[1m\nChoice [1/2]: \e[0m' backup_choice
    
    if [ "$backup_choice" == "1" ]; then
        read -p "Backup folder: " backup_folder
        backup_folder="${backup_folder/#\~/$HOME}"
        if [ -f "$backup_folder/swarm.pem" ]; then
            [ ! -d "$SWARM_DIR" ] && git clone https://github.com/gensyn-ai/rl-swarm.git "$SWARM_DIR" -q
            mkdir -p "$SWARM_DIR/modal-login/temp-data"
            cp "$backup_folder/swarm.pem" "$SWARM_DIR/"
            [ -f "$backup_folder/userData.json" ] && cp "$backup_folder/userData.json" "$SWARM_DIR/modal-login/temp-data/"
            echo -e "${GREEN}[✓] Restored${NC}"
        else
            echo -e "${RED}Not found! Starting fresh...${NC}"
            git clone https://github.com/gensyn-ai/rl-swarm.git "$SWARM_DIR" -q
        fi
    else
        git clone https://github.com/gensyn-ai/rl-swarm.git "$SWARM_DIR" -q
        echo -e "${GREEN}[✓] Fresh install${NC}"
    fi
fi
echo ""

# Step 3: Configuration
echo -e "${CYAN}${BOLD}[3/5] Training Configuration${NC}\n"
echo -e "${GREEN}1)${NC} Default (GPU)"
echo -e "${BLUE}2)${NC} Low memory (CPU)"
read -p $'\e[1m\nChoice [1/2]: \e[0m' config_choice
if [ "$config_choice" == "2" ] && [ -f "$SWARM_DIR/rgym_exp/config/rg-swarm.yaml" ]; then
    sed -i -E 's/(num_train_samples:\s*)2/\11/' "$SWARM_DIR/rgym_exp/config/rg-swarm.yaml"
    echo -e "\n${GREEN}[✓] Low memory mode${NC}\n"
else
    echo -e "\n${GREEN}[✓] Default config${NC}\n"
fi

# Step 4: Hardware
echo -e "${CYAN}${BOLD}[4/5] Hardware Detection${NC}"
if command -v nvidia-smi &>/dev/null; then
    gpu=$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -1)
    echo -e "${GREEN}[✓] GPU: $gpu${NC}\n"
else
    echo -e "${YELLOW}[!] CPU mode${NC}\n"
fi

# Step 5: Start RL-SWARM
echo -e "${CYAN}${BOLD}[5/5] Starting RL-SWARM${NC}\n"

cd "$SWARM_DIR" || exit 1

# Verify & prepare
[ ! -f "run_rl_swarm.sh" ] && { echo -e "${RED}run_rl_swarm.sh not found!${NC}"; exit 1; }
chmod +x run_rl_swarm.sh
[ ! -d ".venv" ] && { echo -e "${CYAN}Creating venv...${NC}"; python3 -m venv .venv; }

# Create backup script
cat > "$HOME/backup-swarm.sh" << 'EOF'
#!/bin/bash
DIR="$HOME/gensyn-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$DIR"
[ -f "$HOME/rl-swarm/swarm.pem" ] && cp "$HOME/rl-swarm/swarm.pem" "$DIR/" && echo "✓ swarm.pem"
[ -f "$HOME/rl-swarm/modal-login/temp-data/userData.json" ] && cp "$HOME/rl-swarm/modal-login/temp-data/userData.json" "$DIR/" && echo "✓ userData.json"
echo -e "\n✓ Backup: $DIR"
EOF
chmod +x "$HOME/backup-swarm.sh"

# Kill old screen
screen -S gensyn -X quit 2>/dev/null || true
sleep 1

# Start screen
echo -e "${YELLOW}Starting screen 'gensyn'...${NC}"
cat > /tmp/gensyn_start.sh << 'SCRIPT'
#!/bin/bash
cd ~/rl-swarm
source .venv/bin/activate
./run_rl_swarm.sh
SCRIPT
chmod +x /tmp/gensyn_start.sh

screen -dmS gensyn bash /tmp/gensyn_start.sh
sleep 3

# Verify
if ! screen -ls | grep -q "gensyn"; then
    echo -e "${YELLOW}Trying alternative method...${NC}"
    screen -dmS gensyn bash
    sleep 1
    screen -S gensyn -X stuff "cd $SWARM_DIR"$'\n'
    sleep 0.5
    screen -S gensyn -X stuff "source .venv/bin/activate"$'\n'
    sleep 0.5
    screen -S gensyn -X stuff "./run_rl_swarm.sh"$'\n'
    sleep 2
fi

if screen -ls | grep -q "gensyn"; then
    echo -e "${GREEN}[✓] Screen 'gensyn' running!${NC}\n"
    
    # Wait for port message
    echo -e "${CYAN}Waiting for RL-SWARM to initialize (max 60s)...${NC}"
    for i in {1..30}; do
        if screen -S gensyn -X hardcopy /tmp/sc.txt 2>/dev/null; then
            if grep -q "localhost:3000\|Please open" /tmp/sc.txt 2>/dev/null; then
                echo -e "${GREEN}[✓] Ready for connection!${NC}\n"
                rm -f /tmp/sc.txt /tmp/gensyn_start.sh
                break
            fi
        fi
        sleep 2
        echo -ne "${YELLOW}$((i*2))s...${NC}\r"
    done
    rm -f /tmp/sc.txt /tmp/gensyn_start.sh
    
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${BOLD}✓ RL-SWARM is running in screen 'gensyn'${NC}"
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
else
    echo -e "${RED}[✗] Screen failed${NC}\n"
    echo -e "${YELLOW}Manual start:${NC}"
    echo -e "  ${GREEN}screen -S gensyn${NC}"
    echo -e "  ${GREEN}cd $SWARM_DIR && source .venv/bin/activate && ./run_rl_swarm.sh${NC}\n"
    exit 1
fi

# Localtunnel
echo -e "${CYAN}${BOLD}━━━ Localtunnel Setup ━━━${NC}\n"
echo -e "${YELLOW}RL-SWARM needs you to open localhost:3000${NC}"
echo -e "${YELLOW}Since you're on VPS, we use localtunnel${NC}\n"

IPV4=$(curl -4 -s --max-time 5 ifconfig.me 2>/dev/null || echo "Unable to fetch")
echo -e "${GREEN}Your IPv4 (password): ${BOLD}$IPV4${NC}\n"

echo -e "${CYAN}${BOLD}What happens next:${NC}"
echo -e "${YELLOW}1.${NC} Localtunnel starts, gives you a URL"
echo -e "${YELLOW}2.${NC} Open URL in browser"
echo -e "${YELLOW}3.${NC} Enter password: ${GREEN}$IPV4${NC}"
echo -e "${YELLOW}4.${NC} Complete login in browser"
echo -e "${YELLOW}5.${NC} After login, press ${BOLD}Ctrl+C${NC} here"
echo -e "${YELLOW}6.${NC} Done! RL-SWARM continues in background\n"

read -p $'\e[1m\e[33mPress ENTER to start localtunnel...\e[0m'

echo -e "\n${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}${BOLD}Starting localtunnel...${NC}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
echo -e "${MAGENTA}${BOLD}→ Copy the URL below${NC}"
echo -e "${MAGENTA}${BOLD}→ Password: $IPV4${NC}\n"

lt --port 3000 || {
    echo -e "\n${RED}Localtunnel failed!${NC}"
    echo -e "${YELLOW}Alternative:${NC} ${GREEN}cloudflared tunnel --url http://localhost:3000${NC}\n"
    exit 1
}

echo -e "\n\n${GREEN}[✓] Localtunnel stopped${NC}\n"

# Final instructions
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}${BOLD}✓ Setup Complete!${NC}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

echo -e "${CYAN}${BOLD}Useful Commands:${NC}"
echo -e "${YELLOW}Reattach to node:${NC}   ${GREEN}screen -r gensyn${NC}"
echo -e "${YELLOW}Detach from node:${NC}   ${GREEN}Ctrl+A then D${NC}"
echo -e "${YELLOW}View logs:${NC}          ${GREEN}tail -f ~/rl-swarm/logs/swarm.log${NC}"
echo -e "${YELLOW}Backup identity:${NC}    ${GREEN}~/backup-swarm.sh${NC}"
echo -e "${YELLOW}Stop node:${NC}          ${GREEN}screen -S gensyn -X quit${NC}"
echo -e "${YELLOW}Restart:${NC}            ${GREEN}bash install.sh${NC} (choose keep existing)\n"

read -p $'\e[1mEnter screen now? [Y/n]: \e[0m' enter
if [[ "$enter" =~ ^[Yy]$ ]] || [ -z "$enter" ]; then
    echo -e "\n${GREEN}Entering screen...${NC}"
    echo -e "${YELLOW}Detach: Ctrl+A then D${NC}\n"
    sleep 2
    screen -r gensyn
else
    echo -e "\n${CYAN}Reattach later: ${GREEN}screen -r gensyn${NC}\n"
fi