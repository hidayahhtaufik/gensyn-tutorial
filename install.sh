#!/bin/bash

# Gensyn RL-SWARM Auto Installer
# By @Hidayahhtaufik
# Simple & Reliable

# Colors
BOLD="\e[1m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
NC="\e[0m"

# Variables
SWARM_DIR="$HOME/rl-swarm"
TEMP_DATA_PATH="$SWARM_DIR/modal-login/temp-data"

# Banner
clear
echo -e "${CYAN}${BOLD}"
echo "╔═══════════════════════════════════════════╗"
echo "║   Gensyn RL-SWARM Auto Installer v2.1    ║"
echo "║         By @Hidayahhtaufik               ║"
echo "╚═══════════════════════════════════════════╝"
echo -e "${NC}\n"

# Check if running in screen session
if [ -z "$STY" ]; then
    echo -e "${YELLOW}${BOLD}[!] Creating screen session 'gensyn'...${NC}\n"
    screen -dmS gensyn bash -c "cd $HOME && bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/master/install.sh)"
    sleep 2
    screen -r gensyn
    exit 0
fi

# Function to check and install dependencies
install_dependencies() {
    echo -e "${CYAN}${BOLD}[1/5] Checking dependencies...${NC}"
    
    local deps=("curl" "wget" "git" "python3" "npm")
    local missing_deps=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${YELLOW}Installing: ${missing_deps[*]}${NC}"
        sudo apt update -qq
        sudo apt install -y curl wget git python3 python3-venv python3-pip npm build-essential -qq
    fi
    
    # Install localtunnel
    if ! command -v lt &> /dev/null; then
        echo -e "${YELLOW}Installing localtunnel...${NC}"
        sudo npm install -g localtunnel --silent
    fi
    
    echo -e "${GREEN}${BOLD}[✓] Dependencies ready${NC}\n"
}

# Function to handle existing swarm.pem
handle_existing_swarm() {
    echo -e "${CYAN}${BOLD}[2/5] Identity Management${NC}\n"
    
    if [ -f "$SWARM_DIR/swarm.pem" ]; then
        echo -e "${YELLOW}[!] Found existing swarm.pem${NC}\n"
        echo -e "${BOLD}Choose:${NC}"
        echo -e "${GREEN}1)${NC} Keep existing (recommended)"
        echo -e "${RED}2)${NC} Start fresh"
        
        read -p $'\e[1mChoice (1/2): \e[0m' choice
        
        if [ "$choice" == "1" ]; then
            echo -e "\n${CYAN}Keeping existing identity...${NC}"
            [ -f "$SWARM_DIR/swarm.pem" ] && mv "$SWARM_DIR/swarm.pem" "$HOME/"
            [ -f "$TEMP_DATA_PATH/userData.json" ] && mv "$TEMP_DATA_PATH/userData.json" "$HOME/" 2>/dev/null
            [ -f "$TEMP_DATA_PATH/userApiKey.json" ] && mv "$TEMP_DATA_PATH/userApiKey.json" "$HOME/" 2>/dev/null
            rm -rf "$SWARM_DIR"
            cd $HOME && git clone https://github.com/gensyn-ai/rl-swarm.git -q
            [ -f "$HOME/swarm.pem" ] && mv "$HOME/swarm.pem" "$SWARM_DIR/"
            [ -f "$HOME/userData.json" ] && mv "$HOME/userData.json" "$TEMP_DATA_PATH/" 2>/dev/null
            [ -f "$HOME/userApiKey.json" ] && mv "$HOME/userApiKey.json" "$TEMP_DATA_PATH/" 2>/dev/null
            echo -e "${GREEN}[✓] Identity restored${NC}\n"
        else
            echo -e "\n${CYAN}Starting fresh...${NC}"
            rm -rf "$SWARM_DIR"
            cd $HOME && git clone https://github.com/gensyn-ai/rl-swarm.git -q
            echo -e "${GREEN}[✓] Fresh install${NC}\n"
        fi
    else
        echo -e "${CYAN}No existing identity found${NC}"
        echo -e "${YELLOW}Starting fresh installation...${NC}"
        rm -rf "$SWARM_DIR"
        cd $HOME && git clone https://github.com/gensyn-ai/rl-swarm.git -q
        echo -e "${GREEN}[✓] Fresh install${NC}\n"
    fi
}

# Function to configure training
configure_training() {
    echo -e "${CYAN}${BOLD}[3/5] Training Configuration${NC}\n"
    
    echo -e "${BOLD}Optimize for:${NC}"
    echo -e "${GREEN}1)${NC} Default (recommended)"
    echo -e "${YELLOW}2)${NC} Low memory (CPU/limited RAM)"
    
    read -p $'\e[1mChoice (1/2) [default: 1]: \e[0m' config_choice
    config_choice=${config_choice:-1}
    
    if [ "$config_choice" == "2" ]; then
        echo -e "\n${CYAN}Optimizing for low memory...${NC}"
        if [ -f "$SWARM_DIR/rgym_exp/config/rg-swarm.yaml" ]; then
            sed -i -E 's/(num_train_samples:\s*)2/\11/' "$SWARM_DIR/rgym_exp/config/rg-swarm.yaml"
            echo -e "${GREEN}[✓] Reduced training samples${NC}\n"
        fi
    else
        echo -e "\n${GREEN}[✓] Using default config${NC}\n"
    fi
}

# Function to check GPU
check_gpu() {
    echo -e "${CYAN}${BOLD}[4/5] Hardware Detection${NC}"
    
    if command -v nvidia-smi &> /dev/null; then
        echo -e "${GREEN}[✓] GPU detected${NC}"
        nvidia-smi --query-gpu=name --format=csv,noheader | head -1
        echo ""
    else
        echo -e "${YELLOW}[!] CPU mode${NC}\n"
    fi
}

# Function to create backup script
create_backup_script() {
    cat > "$HOME/backup-swarm.sh" << 'EOF'
#!/bin/bash
BACKUP_DIR="$HOME/gensyn-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
[ -f "$HOME/rl-swarm/swarm.pem" ] && cp "$HOME/rl-swarm/swarm.pem" "$BACKUP_DIR/" && echo "✓ swarm.pem"
[ -f "$HOME/rl-swarm/modal-login/temp-data/userData.json" ] && cp "$HOME/rl-swarm/modal-login/temp-data/userData.json" "$BACKUP_DIR/" && echo "✓ userData.json"
[ -f "$HOME/rl-swarm/modal-login/temp-data/userApiKey.json" ] && cp "$HOME/rl-swarm/modal-login/temp-data/userApiKey.json" "$BACKUP_DIR/" && echo "✓ userApiKey.json"
echo "✓ Saved to: $BACKUP_DIR"
EOF
    chmod +x "$HOME/backup-swarm.sh"
}

# Function to start RL-SWARM
start_swarm() {
    echo -e "${CYAN}${BOLD}[5/5] Starting RL-SWARM${NC}\n"
    
    cd "$SWARM_DIR" || exit 1
    
    python3 -m venv .venv
    source .venv/bin/activate
    
    create_backup_script
    
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${GREEN}✓ Setup Complete!${NC}"
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    
    echo -e "${BOLD}${CYAN}Next Steps:${NC}"
    echo -e "${BOLD}1. This terminal will start rl-swarm${NC}"
    echo -e "${BOLD}2. Open a NEW terminal/tab for localtunnel${NC}\n"
    
    echo -e "${YELLOW}Commands for the NEW terminal:${NC}"
    echo -e "${GREEN}# Get your IPv4 password${NC}"
    echo -e "curl -4 ifconfig.me"
    echo -e ""
    echo -e "${GREEN}# Start localtunnel${NC}"
    echo -e "lt --port 3000"
    echo -e ""
    echo -e "${GREEN}# Then access the URL with IPv4 as password${NC}\n"
    
    echo -e "${BOLD}Quick Commands:${NC}"
    echo -e "  ${CYAN}Backup:${NC} ~/backup-swarm.sh"
    echo -e "  ${CYAN}Logs:${NC} tail -f ~/rl-swarm/logs/swarm.log"
    echo -e "  ${CYAN}Detach:${NC} Ctrl+A then D"
    
    echo -e "\n${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    
    read -p $'\e[1mPress ENTER to start rl-swarm...\e[0m'
    
    ./run_rl_swarm.sh
}

# Main execution
main() {
    install_dependencies
    handle_existing_swarm
    configure_training
    check_gpu
    start_swarm
}

main