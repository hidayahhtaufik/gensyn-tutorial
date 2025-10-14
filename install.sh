#!/bin/bash

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
echo "║     Gensyn RL-SWARM Auto Installer       ║"
echo "║         By @Hidayahhtaufik               ║"
echo "╚═══════════════════════════════════════════╝"
echo -e "${NC}\n"

# Check if running in screen session
if [ -z "$STY" ]; then
    echo -e "${YELLOW}${BOLD}[!] Not running in a screen session${NC}"
    echo -e "${YELLOW}Creating screen session 'gensyn'...${NC}\n"
    screen -dmS gensyn bash -c "cd $HOME && bash <(curl -s https://raw.githubusercontent.com/hidayahhtaufik/gensyn-tutorial/main/install.sh)"
    screen -r gensyn
    exit 0
fi

# Function to check and install dependencies
install_dependencies() {
    echo -e "${CYAN}${BOLD}[1/5] Checking dependencies...${NC}"
    
    # Check for required tools
    local deps=("curl" "wget" "git" "python3" "npm")
    local missing_deps=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${YELLOW}Installing missing dependencies: ${missing_deps[*]}${NC}"
        sudo apt update -qq
        sudo apt install -y curl wget git python3 python3-venv python3-pip npm build-essential -qq
    fi
    
    # Install localtunnel globally
    if ! command -v lt &> /dev/null; then
        echo -e "${YELLOW}Installing localtunnel...${NC}"
        sudo npm install -g localtunnel --silent
    fi
    
    echo -e "${GREEN}${BOLD}[✓] Dependencies installed${NC}\n"
}

# Function to handle existing swarm.pem
handle_existing_swarm() {
    if [ -f "$SWARM_DIR/swarm.pem" ]; then
        echo -e "${BOLD}${YELLOW}[!] Existing swarm.pem found${NC}\n"
        echo -e "${BOLD}Choose an option:${NC}"
        echo -e "${GREEN}1)${NC} Use existing swarm.pem (keep your identity)"
        echo -e "${RED}2)${NC} Delete and start fresh (new identity)"
        
        while true; do
            read -p $'\e[1mEnter your choice (1 or 2): \e[0m' choice
            
            if [ "$choice" == "1" ]; then
                echo -e "\n${CYAN}${BOLD}[2/5] Using existing swarm.pem...${NC}"
                
                # Backup existing files
                [ -f "$SWARM_DIR/swarm.pem" ] && mv "$SWARM_DIR/swarm.pem" "$HOME_DIR/" 
                [ -f "$TEMP_DATA_PATH/userData.json" ] && mv "$TEMP_DATA_PATH/userData.json" "$HOME_DIR/" 2>/dev/null
                [ -f "$TEMP_DATA_PATH/userApiKey.json" ] && mv "$TEMP_DATA_PATH/userApiKey.json" "$HOME_DIR/" 2>/dev/null
                
                # Remove old directory
                rm -rf "$SWARM_DIR"
                
                # Clone fresh
                cd $HOME && git clone https://github.com/gensyn-ai/rl-swarm.git -q
                
                # Restore files
                [ -f "$HOME_DIR/swarm.pem" ] && mv "$HOME_DIR/swarm.pem" "$SWARM_DIR/"
                [ -f "$HOME_DIR/userData.json" ] && mv "$HOME_DIR/userData.json" "$TEMP_DATA_PATH/" 2>/dev/null
                [ -f "$HOME_DIR/userApiKey.json" ] && mv "$HOME_DIR/userApiKey.json" "$TEMP_DATA_PATH/" 2>/dev/null
                
                echo -e "${GREEN}${BOLD}[✓] Restored existing identity${NC}\n"
                break
                
            elif [ "$choice" == "2" ]; then
                echo -e "\n${CYAN}${BOLD}[2/5] Starting fresh...${NC}"
                rm -rf "$SWARM_DIR"
                cd $HOME && git clone https://github.com/gensyn-ai/rl-swarm.git -q
                echo -e "${GREEN}${BOLD}[✓] Fresh installation ready${NC}\n"
                break
            else
                echo -e "${RED}[✗] Invalid choice. Please enter 1 or 2.${NC}"
            fi
        done
    else
        echo -e "${CYAN}${BOLD}[2/5] No existing swarm.pem found${NC}"
        echo -e "${YELLOW}Cloning fresh repository...${NC}"
        [ -d "$SWARM_DIR" ] && rm -rf "$SWARM_DIR"
        cd $HOME && git clone https://github.com/gensyn-ai/rl-swarm.git -q
        echo -e "${GREEN}${BOLD}[✓] Repository cloned${NC}\n"
    fi
}

# Function to setup localtunnel
setup_localtunnel() {
    echo -e "${CYAN}${BOLD}[3/5] Setting up localtunnel...${NC}"
    
    # Start localtunnel in background
    lt --port $LOCALTUNNEL_PORT > /tmp/localtunnel.log 2>&1 &
    TUNNEL_PID=$!
    
    # Wait for tunnel to establish
    sleep 5
    
    # Get tunnel URL
    TUNNEL_URL=$(grep -o 'https://[^ ]*\.loca\.lt' /tmp/localtunnel.log | head -1)
    
    if [ -n "$TUNNEL_URL" ]; then
        echo -e "${GREEN}${BOLD}[✓] Localtunnel active!${NC}"
        echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${BOLD}Tunnel URL: ${GREEN}$TUNNEL_URL${NC}"
        echo -e "${BOLD}Password: ${YELLOW}$(curl -s https://loca.lt/mytunnelpassword)${NC}"
        echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
        
        # Save tunnel info
        echo "$TUNNEL_URL" > /tmp/tunnel_url.txt
    else
        echo -e "${YELLOW}[!] Localtunnel not established yet${NC}"
        echo -e "${YELLOW}You can manually access: http://localhost:3000${NC}\n"
    fi
}

# Function to install CUDA (optional)
install_cuda() {
    echo -e "${CYAN}${BOLD}[4/5] Checking GPU...${NC}"
    
    if command -v nvidia-smi &> /dev/null; then
        echo -e "${GREEN}[✓] NVIDIA GPU detected${NC}"
        nvidia-smi --query-gpu=name,driver_version --format=csv,noheader | head -1
        echo ""
    else
        echo -e "${YELLOW}[!] No NVIDIA GPU detected - CPU mode${NC}\n"
    fi
}

# Function to start RL-SWARM
start_swarm() {
    echo -e "${CYAN}${BOLD}[5/5] Starting RL-SWARM...${NC}\n"
    
    cd "$SWARM_DIR" || { 
        echo -e "${RED}[✗] Failed to enter swarm directory${NC}"
        exit 1
    }
    
    # Create virtual environment
    python3 -m venv .venv
    source .venv/bin/activate
    
    # Show instructions
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${GREEN}Setup Complete!${NC}"
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if [ -f /tmp/tunnel_url.txt ]; then
        TUNNEL_URL=$(cat /tmp/tunnel_url.txt)
        echo -e "${BOLD}1. Open this URL: ${GREEN}$TUNNEL_URL${NC}"
        echo -e "${BOLD}2. Enter password shown above${NC}"
        echo -e "${BOLD}3. Login and follow setup${NC}"
    else
        echo -e "${BOLD}Open: ${GREEN}http://localhost:3000${NC}"
    fi
    
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    
    # Run RL-SWARM
    ./run_rl_swarm.sh
}

# Main execution
main() {
    install_dependencies
    handle_existing_swarm
    setup_localtunnel
    install_cuda
    start_swarm
}

# Run main function
main