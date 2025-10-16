#!/bin/bash

# Gensyn RL-SWARM Auto Installer v2.1
# By @Hidayahhtaufik
# One powerful script with proper flow

# Colors
BOLD="\e[1m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
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
        echo -e "${BLUE}2)${NC} Restore from backup folder"
        echo -e "${RED}3)${NC} Start fresh"
        
        read -p $'\e[1mChoice (1/2/3): \e[0m' choice
        
        case $choice in
            1)
                echo -e "\n${CYAN}Keeping existing identity...${NC}"
                mv "$SWARM_DIR/swarm.pem" "$HOME/" 2>/dev/null
                mv "$TEMP_DATA_PATH/userData.json" "$HOME/" 2>/dev/null
                mv "$TEMP_DATA_PATH/userApiKey.json" "$HOME/" 2>/dev/null
                rm -rf "$SWARM_DIR"
                cd $HOME && git clone https://github.com/gensyn-ai/rl-swarm.git -q
                mv "$HOME/swarm.pem" "$SWARM_DIR/" 2>/dev/null
                mv "$HOME/userData.json" "$TEMP_DATA_PATH/" 2>/dev/null
                mv "$HOME/userApiKey.json" "$TEMP_DATA_PATH/" 2>/dev/null
                echo -e "${GREEN}[✓] Identity restored${NC}\n"
                ;;
            2)
                restore_from_backup
                ;;
            3)
                start_fresh
                ;;
            *)
                echo -e "${YELLOW}Using existing${NC}"
                ;;
        esac
    else
        echo -e "${CYAN}No existing identity found${NC}"
        echo -e "${BOLD}Check for backup?${NC}"
        echo -e "${GREEN}1)${NC} Yes, restore from backup folder"
        echo -e "${YELLOW}2)${NC} No, start fresh"
        
        read -p $'\e[1mChoice (1/2): \e[0m' backup_choice
        
        if [ "$backup_choice" == "1" ]; then
            restore_from_backup
        else
            start_fresh
        fi
    fi
}

restore_from_backup() {
    echo -e "\n${CYAN}${BOLD}Restore from backup folder${NC}"
    echo -e "${YELLOW}Instructions:${NC}"
    echo -e "1. Create a backup folder (e.g., ~/backup/)"
    echo -e "2. Put swarm.pem inside that folder"
    echo -e "3. Enter the backup folder path\n"
    
    read -p $'\e[1mBackup folder path: \e[0m' backup_folder
    
    if [ -f "$backup_folder/swarm.pem" ]; then
        rm -rf "$SWARM_DIR"
        cd $HOME && git clone https://github.com/gensyn-ai/rl-swarm.git -q
        cp "$backup_folder/swarm.pem" "$SWARM_DIR/"
        [ -f "$backup_folder/userData.json" ] && cp "$backup_folder/userData.json" "$TEMP_DATA_PATH/" 2>/dev/null
        [ -f "$backup_folder/userApiKey.json" ] && cp "$backup_folder/userApiKey.json" "$TEMP_DATA_PATH/" 2>/dev/null
        echo -e "${GREEN}[✓] Restored from backup${NC}\n"
    else
        echo -e "${RED}swarm.pem not found in folder!${NC}"
        echo -e "${YELLOW}Starting fresh instead...${NC}"
        start_fresh
    fi
}

start_fresh() {
    echo -e "\n${CYAN}Starting fresh...${NC}"
    rm -rf "$SWARM_DIR"
    cd $HOME && git clone https://github.com/gensyn-ai/rl-swarm.git -q
    echo -e "${GREEN}[✓] Fresh install${NC}\n"
}

# Function to configure training
configure_training() {
    echo -e "${CYAN}${BOLD}[3/5] Training Configuration${NC}\n"
    
    echo -e "${BOLD}Optimize for:${NC}"
    echo -e "${GREEN}1)${NC} Default (GPU)"
    echo -e "${BLUE}2)${NC} Low memory (CPU/limited RAM)"
    echo -e "${YELLOW}3)${NC} Custom"
    
    read -p $'\e[1mChoice (1/2/3) [default: 1]: \e[0m' config_choice
    config_choice=${config_choice:-1}
    
    if [ "$config_choice" == "2" ]; then
        echo -e "\n${CYAN}Reducing memory usage...${NC}"
        if [ -f "$SWARM_DIR/rgym_exp/config/rg-swarm.yaml" ]; then
            sed -i -E 's/(num_train_samples:\s*)2/\11/' "$SWARM_DIR/rgym_exp/config/rg-swarm.yaml"
            echo -e "${GREEN}[✓] Training samples: 1${NC}\n"
        fi
    elif [ "$config_choice" == "3" ]; then
        echo -e "\n${CYAN}Custom configuration:${NC}"
        read -p "Training samples (1-2) [2]: " samples
        samples=${samples:-2}
        if [ -f "$SWARM_DIR/rgym_exp/config/rg-swarm.yaml" ]; then
            sed -i -E "s/(num_train_samples:\s*)[0-9]+/\1$samples/" "$SWARM_DIR/rgym_exp/config/rg-swarm.yaml"
            echo -e "${GREEN}[✓] Training samples: $samples${NC}\n"
        fi
    else
        echo -e "\n${GREEN}[✓] Default config${NC}\n"
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
echo "✓ Backup saved to: $BACKUP_DIR"
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
    
    echo -e "${BOLD}${CYAN}IMPORTANT: Localtunnel Setup${NC}"
    echo -e "${YELLOW}After rl-swarm starts:${NC}"
    echo -e "  ${BOLD}1.${NC} Open a ${BOLD}NEW terminal${NC} (outside this screen)"
    echo -e "  ${BOLD}2.${NC} Get password: ${GREEN}curl -4 ifconfig.me${NC}"
    echo -e "  ${BOLD}3.${NC} Start tunnel: ${GREEN}lt --port 3000${NC}"
    echo -e "  ${BOLD}4.${NC} Login in browser with IPv4 password"
    echo -e "  ${BOLD}5.${NC} After login, press ${BOLD}Ctrl+C${NC} to exit localtunnel"
    echo -e "  ${BOLD}6.${NC} Reattach to screen: ${GREEN}screen -r gensyn${NC}"
    echo -e "  ${BOLD}7.${NC} Configure manually if needed\n"
    
    echo -e "${BOLD}Quick Commands:${NC}"
    echo -e "  ${CYAN}Backup:${NC} ~/backup-swarm.sh"
    echo -e "  ${CYAN}Logs:${NC} tail -f ~/rl-swarm/logs/swarm.log"
    echo -e "  ${CYAN}Reattach:${NC} screen -r gensyn"
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