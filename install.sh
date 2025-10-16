#!/bin/bash

# Gensyn RL-SWARM Auto Installer v3.0
# By @Hidayahhtaufik
# Fixed flow with proper screen and localtunnel handling

# Colors
BOLD="\e[1m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
MAGENTA="\e[35m"
NC="\e[0m"

# Variables
SWARM_DIR="$HOME/rl-swarm"
TEMP_DATA_PATH="$SWARM_DIR/modal-login/temp-data"

# Banner
show_banner() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "╔═══════════════════════════════════════════╗"
    echo "║   Gensyn RL-SWARM Auto Installer v3.0    ║"
    echo "║         By @Hidayahhtaufik               ║"
    echo "╚═══════════════════════════════════════════╝"
    echo -e "${NC}\n"
}

# Function to check and install dependencies
install_dependencies() {
    echo -e "${CYAN}${BOLD}[1/5] Installing Dependencies...${NC}"
    
    local deps=("curl" "wget" "git" "python3" "npm" "screen")
    local missing_deps=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${YELLOW}Installing: ${missing_deps[*]}${NC}"
        sudo apt update -qq
        sudo apt install -y curl wget git python3 python3-venv python3-pip npm build-essential screen -qq 2>&1 | grep -v "debconf"
    fi
    
    if ! command -v lt &> /dev/null; then
        echo -e "${YELLOW}Installing localtunnel...${NC}"
        sudo npm install -g localtunnel --silent 2>&1 | grep -v "npm WARN"
    fi
    
    echo -e "${GREEN}${BOLD}[✓] Dependencies installed${NC}\n"
    sleep 1
}

# Function to handle existing installation
handle_existing_swarm() {
    echo -e "${CYAN}${BOLD}[2/5] Identity Management${NC}\n"
    
    if [ -f "$SWARM_DIR/swarm.pem" ]; then
        echo -e "${YELLOW}[!] Existing installation found${NC}\n"
        echo -e "${BOLD}Options:${NC}"
        echo -e "${GREEN}1)${NC} Keep existing identity (recommended)"
        echo -e "${BLUE}2)${NC} Restore from backup folder"
        echo -e "${RED}3)${NC} Start fresh (new identity)"
        
        read -p $'\e[1m\nChoice [1/2/3]: \e[0m' choice
        
        case $choice in
            1)
                echo -e "\n${CYAN}Keeping existing identity...${NC}"
                ;;
            2)
                restore_from_backup
                ;;
            3)
                start_fresh
                ;;
            *)
                echo -e "\n${YELLOW}Using existing identity...${NC}"
                ;;
        esac
    else
        if [ -d "$SWARM_DIR" ]; then
            echo -e "${YELLOW}[!] Folder exists but no swarm.pem found${NC}\n"
        else
            echo -e "${CYAN}No existing installation found${NC}\n"
        fi
        
        echo -e "${BOLD}Do you have a backup?${NC}"
        echo -e "${GREEN}1)${NC} Yes, restore from backup"
        echo -e "${YELLOW}2)${NC} No, start fresh"
        
        read -p $'\e[1m\nChoice [1/2]: \e[0m' backup_choice
        
        if [ "$backup_choice" == "1" ]; then
            restore_from_backup
        else
            start_fresh
        fi
    fi
    
    echo ""
}

restore_from_backup() {
    echo -e "\n${CYAN}${BOLD}━━━ Restore from Backup ━━━${NC}"
    echo -e "${YELLOW}Instructions:${NC}"
    echo -e "  1. Prepare a backup folder (example: ~/backup/)"
    echo -e "  2. Place ${BOLD}swarm.pem${NC} inside that folder"
    echo -e "  3. Optional: userData.json and userApiKey.json\n"
    
    read -p $'\e[1mBackup folder path: \e[0m' backup_folder
    backup_folder="${backup_folder/#\~/$HOME}"
    
    if [ -f "$backup_folder/swarm.pem" ]; then
        if [ ! -d "$SWARM_DIR" ]; then
            echo -e "\n${CYAN}Cloning repository...${NC}"
            cd "$HOME" && git clone https://github.com/gensyn-ai/rl-swarm.git -q
        fi
        
        mkdir -p "$TEMP_DATA_PATH"
        cp "$backup_folder/swarm.pem" "$SWARM_DIR/"
        [ -f "$backup_folder/userData.json" ] && cp "$backup_folder/userData.json" "$TEMP_DATA_PATH/"
        [ -f "$backup_folder/userApiKey.json" ] && cp "$backup_folder/userApiKey.json" "$TEMP_DATA_PATH/"
        
        echo -e "${GREEN}[✓] Identity restored from backup${NC}"
    else
        echo -e "${RED}[✗] swarm.pem not found in: $backup_folder${NC}"
        echo -e "${YELLOW}Starting fresh installation instead...${NC}"
        start_fresh
    fi
}

start_fresh() {
    echo -e "\n${CYAN}Starting fresh installation...${NC}"
    
    if [ -d "$SWARM_DIR" ]; then
        echo -e "${YELLOW}Removing old installation...${NC}"
        rm -rf "$SWARM_DIR"
    fi
    
    cd "$HOME" && git clone https://github.com/gensyn-ai/rl-swarm.git -q
    echo -e "${GREEN}[✓] Repository cloned${NC}"
}

# Function to configure training
configure_training() {
    echo -e "${CYAN}${BOLD}[3/5] Training Configuration${NC}\n"
    
    echo -e "${BOLD}Optimize for:${NC}"
    echo -e "${GREEN}1)${NC} Default (recommended for GPU)"
    echo -e "${BLUE}2)${NC} Low memory (for CPU/limited RAM)"
    echo -e "${YELLOW}3)${NC} Custom configuration"
    
    read -p $'\e[1m\nChoice [1/2/3]: \e[0m' config_choice
    config_choice=${config_choice:-1}
    
    echo ""
    
    if [ "$config_choice" == "2" ]; then
        echo -e "${CYAN}Optimizing for low memory...${NC}"
        if [ -f "$SWARM_DIR/rgym_exp/config/rg-swarm.yaml" ]; then
            sed -i -E 's/(num_train_samples:\s*)2/\11/' "$SWARM_DIR/rgym_exp/config/rg-swarm.yaml"
            echo -e "${GREEN}[✓] Training samples: 1${NC}"
        fi
    elif [ "$config_choice" == "3" ]; then
        read -p $'\e[1mTraining samples (1-2) [default: 2]: \e[0m' samples
        samples=${samples:-2}
        if [ -f "$SWARM_DIR/rgym_exp/config/rg-swarm.yaml" ]; then
            sed -i -E "s/(num_train_samples:\s*)[0-9]+/\1$samples/" "$SWARM_DIR/rgym_exp/config/rg-swarm.yaml"
            echo -e "${GREEN}[✓] Training samples: $samples${NC}"
        fi
    else
        echo -e "${GREEN}[✓] Using default configuration${NC}"
    fi
    
    echo ""
}

# Function to check GPU
check_gpu() {
    echo -e "${CYAN}${BOLD}[4/5] Hardware Detection${NC}\n"
    
    if command -v nvidia-smi &> /dev/null; then
        local gpu_name=$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -1)
        echo -e "${GREEN}[✓] GPU detected: ${BOLD}$gpu_name${NC}"
    else
        echo -e "${YELLOW}[!] No GPU detected - running in CPU mode${NC}"
    fi
    
    echo ""
}

# Function to create backup script
create_backup_script() {
    cat > "$HOME/backup-swarm.sh" << 'BACKUP_EOF'
#!/bin/bash
BACKUP_DIR="$HOME/gensyn-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Creating backup..."
[ -f "$HOME/rl-swarm/swarm.pem" ] && cp "$HOME/rl-swarm/swarm.pem" "$BACKUP_DIR/" && echo "✓ swarm.pem"
[ -f "$HOME/rl-swarm/modal-login/temp-data/userData.json" ] && cp "$HOME/rl-swarm/modal-login/temp-data/userData.json" "$BACKUP_DIR/" && echo "✓ userData.json"
[ -f "$HOME/rl-swarm/modal-login/temp-data/userApiKey.json" ] && cp "$HOME/rl-swarm/modal-login/temp-data/userApiKey.json" "$BACKUP_DIR/" && echo "✓ userApiKey.json"

echo ""
echo "✓ Backup completed!"
echo "Location: $BACKUP_DIR"
BACKUP_EOF
    
    chmod +x "$HOME/backup-swarm.sh"
}

# Function to setup and start RL-SWARM in screen
setup_swarm() {
    echo -e "${CYAN}${BOLD}[5/5] Starting RL-SWARM${NC}\n"
    
    # Kill existing screen session if exists
    screen -S gensyn -X quit 2>/dev/null
    
    # Create setup script for screen
    cat > "$SWARM_DIR/start_in_screen.sh" << 'SCREEN_EOF'
#!/bin/bash
cd "$HOME/rl-swarm"
python3 -m venv .venv
source .venv/bin/activate
./run_rl_swarm.sh
SCREEN_EOF
    
    chmod +x "$SWARM_DIR/start_in_screen.sh"
    
    create_backup_script
    
    echo -e "${YELLOW}Starting RL-SWARM in screen session 'gensyn'...${NC}"
    echo -e "${CYAN}Please wait...${NC}\n"
    
    # Start screen session with rl-swarm
    screen -dmS gensyn bash -c "$SWARM_DIR/start_in_screen.sh"
    
    sleep 3
    
    # Wait for port 3000 message
    echo -e "${CYAN}Waiting for RL-SWARM to initialize...${NC}"
    
    local max_wait=60
    local waited=0
    while [ $waited -lt $max_wait ]; do
        if screen -S gensyn -X hardcopy /tmp/screen_check.txt 2>/dev/null; then
            if grep -q "port 3000\|localhost:3000" /tmp/screen_check.txt 2>/dev/null; then
                echo -e "${GREEN}[✓] RL-SWARM is running in screen 'gensyn'${NC}\n"
                rm -f /tmp/screen_check.txt
                break
            fi
        fi
        sleep 2
        waited=$((waited + 2))
        echo -ne "${YELLOW}Initializing... ${waited}s${NC}\r"
    done
    
    echo -e "\n${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${GREEN}✓ RL-SWARM is running in background (screen: gensyn)${NC}"
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Function to start localtunnel
start_localtunnel() {
    echo -e "${CYAN}${BOLD}━━━ Localtunnel Setup ━━━${NC}\n"
    
    # Get IPv4 address
    echo -e "${YELLOW}Getting your IPv4 address...${NC}"
    local ipv4=$(curl -4 -s ifconfig.me 2>/dev/null || curl -4 -s icanhazip.com 2>/dev/null || echo "Unable to fetch")
    
    echo -e "${BOLD}Your IPv4 address (password): ${GREEN}$ipv4${NC}\n"
    
    echo -e "${CYAN}${BOLD}IMPORTANT INSTRUCTIONS:${NC}"
    echo -e "${YELLOW}1.${NC} Localtunnel will start now"
    echo -e "${YELLOW}2.${NC} Copy the URL that appears"
    echo -e "${YELLOW}3.${NC} Open it in your browser"
    echo -e "${YELLOW}4.${NC} Enter password: ${GREEN}${BOLD}$ipv4${NC}"
    echo -e "${YELLOW}5.${NC} After successful login, come back here"
    echo -e "${YELLOW}6.${NC} Press ${BOLD}Ctrl+C${NC} to stop localtunnel"
    echo -e "${YELLOW}7.${NC} Type ${GREEN}${BOLD}done${NC} when finished\n"
    
    read -p $'\e[1mPress ENTER to start localtunnel...\e[0m'
    
    echo -e "\n${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${BOLD}Starting localtunnel on port 3000...${NC}"
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    echo -e "${MAGENTA}${BOLD}→ Copy the URL below and open in browser${NC}"
    echo -e "${MAGENTA}${BOLD}→ Password: $ipv4${NC}\n"
    
    # Start localtunnel (this will block until user presses Ctrl+C)
    lt --port 3000
    
    echo -e "\n\n${YELLOW}Localtunnel stopped.${NC}"
}

# Function to show final instructions
show_final_instructions() {
    echo -e "\n${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${BOLD}✓ Setup Complete!${NC}"
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    
    echo -e "${CYAN}${BOLD}NEXT STEPS:${NC}"
    echo -e "${YELLOW}1.${NC} Reattach to screen for manual configuration:"
    echo -e "   ${GREEN}${BOLD}screen -r gensyn${NC}\n"
    
    echo -e "${YELLOW}2.${NC} Complete the manual setup in the screen session\n"
    
    echo -e "${CYAN}${BOLD}USEFUL COMMANDS:${NC}"
    echo -e "${BLUE}Reattach to screen:${NC} screen -r gensyn"
    echo -e "${BLUE}Detach from screen:${NC} Ctrl+A then D"
    echo -e "${BLUE}View logs:${NC} tail -f ~/rl-swarm/logs/swarm.log"
    echo -e "${BLUE}Backup identity:${NC} ~/backup-swarm.sh"
    echo -e "${BLUE}Stop RL-SWARM:${NC} screen -S gensyn -X quit\n"
    
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    
    read -p $'\e[1mReady to enter screen session? [Y/n]: \e[0m' enter_screen
    
    if [[ "$enter_screen" =~ ^[Yy]$ ]] || [ -z "$enter_screen" ]; then
        echo -e "\n${GREEN}Entering screen session 'gensyn'...${NC}"
        echo -e "${YELLOW}Remember: Ctrl+A then D to detach${NC}\n"
        sleep 2
        screen -r gensyn
    else
        echo -e "\n${CYAN}You can enter the screen session later with:${NC}"
        echo -e "${GREEN}${BOLD}screen -r gensyn${NC}\n"
    fi
}

# Main execution
main() {
    show_banner
    install_dependencies
    handle_existing_swarm
    configure_training
    check_gpu
    setup_swarm
    start_localtunnel
    show_final_instructions
}

# Run main
main