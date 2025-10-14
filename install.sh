#!/bin/bash

# Gensyn RL-SWARM Auto Installer
# By @Hidayahhtaufik
# One powerful script with all features

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
HOME_DIR="$HOME"
LOCALTUNNEL_PORT=3000

# Banner
clear
echo -e "${CYAN}${BOLD}"
echo "╔═══════════════════════════════════════════╗"
echo "║   Gensyn RL-SWARM Auto Installer v2.0    ║"
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
    echo -e "${CYAN}${BOLD}[1/6] Checking dependencies...${NC}"
    
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
    echo -e "${CYAN}${BOLD}[2/6] Identity Management${NC}\n"
    
    # Check for existing swarm.pem in multiple locations
    local found_in_swarm=false
    local found_backup=""
    
    if [ -f "$SWARM_DIR/swarm.pem" ]; then
        found_in_swarm=true
    fi
    
    # Check common backup locations
    local backup_locations=(
        "$HOME/swarm_backup.pem"
        "$HOME/gensyn-backup/swarm.pem"
        "$HOME/backup/swarm.pem"
    )
    
    for loc in "${backup_locations[@]}"; do
        if [ -f "$loc" ]; then
            found_backup="$loc"
            break
        fi
    done
    
    # Show options based on what's found
    if [ "$found_in_swarm" = true ]; then
        echo -e "${YELLOW}[!] Found existing swarm.pem${NC}\n"
        echo -e "${BOLD}Choose:${NC}"
        echo -e "${GREEN}1)${NC} Keep existing identity (recommended)"
        echo -e "${BLUE}2)${NC} Restore from backup"
        echo -e "${RED}3)${NC} Start fresh"
        
        read -p $'\e[1mChoice (1/2/3): \e[0m' choice
        
        case $choice in
            1)
                echo -e "\n${CYAN}Keeping existing identity...${NC}"
                [ -f "$SWARM_DIR/swarm.pem" ] && mv "$SWARM_DIR/swarm.pem" "$HOME_DIR/"
                [ -f "$TEMP_DATA_PATH/userData.json" ] && mv "$TEMP_DATA_PATH/userData.json" "$HOME_DIR/" 2>/dev/null
                [ -f "$TEMP_DATA_PATH/userApiKey.json" ] && mv "$TEMP_DATA_PATH/userApiKey.json" "$HOME_DIR/" 2>/dev/null
                rm -rf "$SWARM_DIR"
                cd $HOME && git clone https://github.com/gensyn-ai/rl-swarm.git -q
                [ -f "$HOME_DIR/swarm.pem" ] && mv "$HOME_DIR/swarm.pem" "$SWARM_DIR/"
                [ -f "$HOME_DIR/userData.json" ] && mv "$HOME_DIR/userData.json" "$TEMP_DATA_PATH/" 2>/dev/null
                [ -f "$HOME_DIR/userApiKey.json" ] && mv "$HOME_DIR/userApiKey.json" "$TEMP_DATA_PATH/" 2>/dev/null
                echo -e "${GREEN}[✓] Identity restored${NC}\n"
                ;;
            2)
                restore_from_backup
                ;;
            3)
                start_fresh
                ;;
            *)
                echo -e "${RED}Invalid choice, keeping existing${NC}"
                ;;
        esac
    elif [ -n "$found_backup" ]; then
        echo -e "${GREEN}[✓] Found backup: $found_backup${NC}"
        read -p $'\e[1mRestore backup? (y/n): \e[0m' restore
        if [[ "$restore" =~ ^[Yy]$ ]]; then
            rm -rf "$SWARM_DIR"
            cd $HOME && git clone https://github.com/gensyn-ai/rl-swarm.git -q
            cp "$found_backup" "$SWARM_DIR/swarm.pem"
            echo -e "${GREEN}[✓] Backup restored${NC}\n"
        else
            start_fresh
        fi
    else
        start_fresh
    fi
}

restore_from_backup() {
    echo -e "\n${CYAN}Restore from backup...${NC}"
    read -p $'\e[1mEnter backup path: \e[0m' backup_path
    if [ -f "$backup_path" ]; then
        rm -rf "$SWARM_DIR"
        cd $HOME && git clone https://github.com/gensyn-ai/rl-swarm.git -q
        cp "$backup_path" "$SWARM_DIR/swarm.pem"
        echo -e "${GREEN}[✓] Restored${NC}\n"
    else
        echo -e "${RED}File not found!${NC}"
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
    echo -e "${CYAN}${BOLD}[3/6] Training Configuration${NC}\n"
    
    echo -e "${BOLD}Optimize for:${NC}"
    echo -e "${GREEN}1)${NC} Default (recommended for GPU)"
    echo -e "${BLUE}2)${NC} Low memory (for CPU/limited RAM)"
    echo -e "${YELLOW}3)${NC} Custom"
    
    read -p $'\e[1mChoice (1/2/3) [default: 1]: \e[0m' config_choice
    config_choice=${config_choice:-1}
    
    if [ "$config_choice" == "2" ]; then
        echo -e "\n${CYAN}Optimizing for low memory...${NC}"
        if [ -f "$SWARM_DIR/rgym_exp/config/rg-swarm.yaml" ]; then
            sed -i -E 's/(num_train_samples:\s*)2/\11/' "$SWARM_DIR/rgym_exp/config/rg-swarm.yaml"
            echo -e "${GREEN}[✓] Reduced training samples${NC}"
            echo -e "${YELLOW}Note: Lower memory usage, may affect speed${NC}\n"
        fi
    elif [ "$config_choice" == "3" ]; then
        echo -e "\n${CYAN}Custom configuration:${NC}"
        read -p "Training samples (1-2) [default: 2]: " samples
        samples=${samples:-2}
        if [ -f "$SWARM_DIR/rgym_exp/config/rg-swarm.yaml" ]; then
            sed -i -E "s/(num_train_samples:\s*)[0-9]+/\1$samples/" "$SWARM_DIR/rgym_exp/config/rg-swarm.yaml"
            echo -e "${GREEN}[✓] Set to: $samples${NC}\n"
        fi
    else
        echo -e "\n${GREEN}[✓] Using default config${NC}\n"
    fi
}

# Function to setup localtunnel
setup_localtunnel() {
    echo -e "${CYAN}${BOLD}[4/6] Network Setup${NC}\n"
    
    echo -e "${BOLD}Enable remote access?${NC}"
    echo -e "${GREEN}1)${NC} Yes (for VPS/VM)"
    echo -e "${YELLOW}2)${NC} No (localhost only)"
    
    read -p $'\e[1mChoice (1/2) [default: 1]: \e[0m' tunnel_choice
    tunnel_choice=${tunnel_choice:-1}
    
    if [ "$tunnel_choice" == "1" ]; then
        lt --port $LOCALTUNNEL_PORT > /tmp/localtunnel.log 2>&1 &
        TUNNEL_PID=$!
        sleep 5
        
        TUNNEL_URL=$(grep -o 'https://[^ ]*\.loca\.lt' /tmp/localtunnel.log | head -1)
        
        if [ -n "$TUNNEL_URL" ]; then
            echo -e "${GREEN}[✓] Remote access enabled${NC}"
            echo -e "${BOLD}URL: ${GREEN}$TUNNEL_URL${NC}"
            PASSWORD=$(curl -s https://loca.lt/mytunnelpassword 2>/dev/null)
            [ -z "$PASSWORD" ] && PASSWORD=$(hostname -I | awk '{print $1}')
            echo -e "${BOLD}Password: ${YELLOW}$PASSWORD${NC}\n"
            echo "$TUNNEL_URL" > /tmp/tunnel_url.txt
            echo "$PASSWORD" > /tmp/tunnel_pass.txt
        else
            echo -e "${YELLOW}[!] Using localhost:3000${NC}\n"
        fi
    else
        echo -e "${GREEN}[✓] Localhost only${NC}\n"
    fi
}

# Function to check GPU
check_gpu() {
    echo -e "${CYAN}${BOLD}[5/6] Hardware Detection${NC}"
    
    if command -v nvidia-smi &> /dev/null; then
        echo -e "${GREEN}[✓] GPU detected${NC}"
        nvidia-smi --query-gpu=name,memory.total --format=csv,noheader | head -1
        echo ""
    else
        echo -e "${YELLOW}[!] CPU mode (training will be slower)${NC}\n"
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
    echo -e "${CYAN}${BOLD}[6/6] Starting RL-SWARM${NC}\n"
    
    cd "$SWARM_DIR" || exit 1
    
    python3 -m venv .venv
    source .venv/bin/activate
    
    create_backup_script
    
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${GREEN}✓ Setup Complete!${NC}"
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    
    # Show access info
    if [ -f /tmp/tunnel_url.txt ]; then
        echo -e "${BOLD}Access:${NC} $(cat /tmp/tunnel_url.txt)"
        echo -e "${BOLD}Password:${NC} $(cat /tmp/tunnel_pass.txt)"
    else
        echo -e "${BOLD}Access:${NC} http://localhost:3000"
    fi
    
    echo -e "\n${BOLD}Quick Commands:${NC}"
    echo -e "  ${CYAN}Backup:${NC} ~/backup-swarm.sh"
    echo -e "  ${CYAN}Logs:${NC} tail -f ~/rl-swarm/logs/swarm.log"
    echo -e "  ${CYAN}Dashboard:${NC} https://dashboard.gensyn.ai"
    echo -e "  ${CYAN}Detach:${NC} Ctrl+A then D"
    
    echo -e "\n${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    
    read -p $'\e[1mPress ENTER to start training...\e[0m'
    
    ./run_rl_swarm.sh
}

# Main execution
main() {
    install_dependencies
    handle_existing_swarm
    configure_training
    setup_localtunnel
    check_gpu
    start_swarm
}

main