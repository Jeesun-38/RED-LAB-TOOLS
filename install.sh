#!/bin/bash

BOLD="\e[1m"
DEEP_GREEN="\e[38;5;28m"
LIGHT_GREEN="\e[38;5;154m"  
DEEP_RED="\e[38;5;196m"
MID_YELLOW="\e[38;5;220m"
ORANGE="\e[38;5;203m"    
RESET="\e[0m"

# Banner
echo -e "\e[38;5;196m"
cat << "EOF"


   __    __   ___          __    _      ___        _____   ___   ___   __  __    
  /__\  /__\ /   \        / /   /_\    / __\      /__   \ /___\ /___\ / / / _\   
 / \// /_\  / /\ /_____  / /   //_\\  /__\// _____  / /\///  ////  /// /  \ \    
/ _  \//__ / /_//|_____|/ /___/  _  \/ \/  \|_____|/ /  / \_/// \_/// /____\ \   
\/ \_/\__//___,'        \____/\_/ \_/\_____/       \/   \___/ \___/ \____/\__/   
                                                                                 


Coded by TEAM ZX3RR
EOF
echo -e "\e[0m"

echo -e "\e[31;40;1m
\t\e[31;4mCTRL+C:\e[0m exit          \e[33;4mAuthor:\e[0m zetsu-X-3rr\t\e[33;4mGithub: https://github.com/Jeesun-38
\e[0m"

echo -e "\e[37m\e[36mLAB-Requirement:${DEEP_GREEN}[1]\e[36m System Update \e[0m" "\e[37m|\e[0m" "\e[37m\e[36m LAB-TOOLS:${DEEP_GREEN}[2]\e[36m Go Based Tools \e[0m"
echo -e "\n \e[0m"
echo -e "\e[37m\e[36m PYTHON-TOOLS:${DEEP_GREEN}[3]\e[36m Python Based Tools \e[0m" "\e[37m|\e[0m" "\e[37m\e[36m PYTHON-FIX:${DEEP_GREEN}[4]\e[36m Python Install Error Fix \e[0m"
echo -e "\n"
# Function to check if a tool is installed
check_install() {
    if command -v "$1" &> /dev/null; then
        echo -e "${LIGHT_GREEN}$1 is already installed.${RESET}"
        return 0
    else
        return 1
    fi
}

# Choosing the Option
read -p "Input Number: " lab1_number
if [[ "$lab1_number" == "1" ]]; then
    clear
    echo -e "\e[38;5;213m Installing the update and dependencies...\e[0m"
    sleep 3
    apt update
    apt upgrade -y
    clear
    echo -e "\e[38;5;154m Full updated...Done\e[0m"
    sleep 3

elif [[ $lab1_number == 2 || $lab1_number == 02 ]]; then
    clear
    echo -e "\e[38;5;220m Installing Go Based Tools...\e[0m"
    sleep 3
    
    USER_SHELL=$(basename "$SHELL")
    if [ "$USER_SHELL" == "bash" ]; then
        PROFILE_FILE="$HOME/.bashrc"
    elif [ "$USER_SHELL" == "zsh" ]; then
        PROFILE_FILE="$HOME/.zshrc"
    else
        echo -e "${DEEP_RED}Unsupported shell: $USER_SHELL. Exiting...${RESET}"
        exit 1
    fi

    INSTALL_DIR="/usr/local/go"
    GO_ENV_FILE="$HOME/.go_env"
    LATEST_GO_VERSION=$(curl -L -s https://golang.org/VERSION?m=text | head -1)

    if command -v go &> /dev/null; then
        INSTALLED_GO_VERSION=$(go version | awk '{print $3}')
    else
        INSTALLED_GO_VERSION="none"
    fi

    if [ "$INSTALLED_GO_VERSION" != "$LATEST_GO_VERSION" ]; then
        echo -e "${DEEP_RED}Updating Go to the latest version (${LATEST_GO_VERSION})...${RESET}"
        sudo rm -rf $INSTALL_DIR
        wget -q "https://dl.google.com/go/${LATEST_GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
        sudo tar -C /usr/local -xzf /tmp/go.tar.gz
        rm -f /tmp/go.tar.gz
        
        cat <<EOF > $GO_ENV_FILE
export GOROOT=/usr/local/go
export GOPATH=${HOME}/go
export PATH=$GOPATH/bin:$GOROOT/bin:${HOME}/.local/bin:$PATH
EOF
        
        if ! grep -q "source $GO_ENV_FILE" "$PROFILE_FILE"; then
            echo "source $GO_ENV_FILE" >> "$PROFILE_FILE"
        fi
        
        source $PROFILE_FILE
        INSTALLED_GO_VERSION=$LATEST_GO_VERSION
    else
        echo -e "${DEEP_GREEN}Go (${INSTALLED_GO_VERSION}) is already up-to-date.${RESET}"
    fi
    
    # Install ProjectDiscovery Tools
    TOOLS=(
        "github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest"
        "github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
        "github.com/projectdiscovery/cdncheck/cmd/cdncheck@latest"
        "github.com/projectdiscovery/wappalyzergo/cmd/update-fingerprints@latest"
        "github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest"
        "github.com/projectdiscovery/dnsx/cmd/dnsx@latest"
        "github.com/projectdiscovery/notify/cmd/notify@latest"
        "github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest"
        "github.com/projectdiscovery/useragent/cmd/ua@latest"
        "github.com/projectdiscovery/asnmap/cmd/asnmap@latest"
        "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
        "github.com/projectdiscovery/pdtm/cmd/pdtm@latest"
        "github.com/projectdiscovery/katana/cmd/katana@latest"
        "github.com/projectdiscovery/chaos-client/cmd/chaos@latest"
        "github.com/projectdiscovery/cvemap/cmd/cvemap@latest"
        "github.com/projectdiscovery/httpx/cmd/httpx@latest"
        "github.com/projectdiscovery/proxify/cmd/proxify@latest"
        "github.com/projectdiscovery/alterx/cmd/alterx@latest"
        "github.com/projectdiscovery/cloudlist/cmd/cloudlist@latest"
        "github.com/projectdiscovery/interactsh/cmd/interactsh-server@latest"
        "github.com/projectdiscovery/simplehttpserver/cmd/simplehttpserver@latest"
        "github.com/projectdiscovery/tldfinder/cmd/tldfinder@latest"
        "github.com/projectdiscovery/tlsx/cmd/tlsx@latest"
        "github.com/projectdiscovery/uncover/cmd/uncover@latest"
        "github.com/projectdiscovery/urlfinder/cmd/urlfinder@latest"
        "github.com/tomnomnom/waybackurls@latest"
        "github.com/ffuf/ffuf/v2@latest"
        "github.com/tomnomnom/waybackurls@latest"
        "github.com/lc/gau/v2/cmd/gau@latest"
        "github.com/hakluke/hakrawler@latest"
        "github.com/projectdiscovery/httpx/cmd/httpx@latest"
        "github.com/tomnomnom/httprobe@latest"
    )

    echo -e "\n${BOLD}${ORANGE}Installing ProjectDiscovery Tools...${RESET}"
    for TOOL in "${TOOLS[@]}"; do
        echo -e "${DEEP_GREEN}Installing $TOOL...${RESET}"
        go install -v "$TOOL"
        if [ $? -eq 0 ]; then
            echo -e "${DEEP_GREEN}$TOOL installed successfully.${RESET}"
        else
            echo -e "${DEEP_RED}Failed to install $TOOL.${RESET}"
        fi
    done

    echo -e "\n${BOLD}${LIGHT_GREEN}ALL THE TOOLS ARE INSTALLED!! ENJOY!!${RESET}"

elif [[ $lab1_number == 3 || $lab1_number == 03 ]]; then
    clear
    echo -e "\e[38;5;220m Installing Python Based Tools...\e[0m"
    sleep 2
    
    check_install git || sudo apt update && sudo apt install git -y
    check_install python3 || sudo apt update && sudo apt install python3 python3-pip -y
    
    check_install wafw00f || {
        echo -e "\e[38;5;220m Installing WafW00f...\e[0m"
        git clone https://github.com/enablesecurity/wafw00f.git
        cd wafw00f/
        python3 -m pip install .
        cd ..
        echo -e "${LIGHT_GREEN}WafW00f installed successfully!${RESET}"
    }
    
    check_install dirsearch || sudo apt-get install dirsearch -y && echo -e "${LIGHT_GREEN}Dirsearch installed successfully!${RESET}"
    
        
     echo -e "\n${BOLD}${DEEP_GREEN}ALL THE PYTHON TOOLS ARE INSTALLED!! ENJOY!!${RESET}"
        
     echo -e "\n${BOLD}${ORANGE}IF THERE IS ANY ERROR PLEASE PRESS [4]!!${RESET}"

elif [[ $lab1_number == 4 || $lab1_number == 04 ]]; then
    clear
    echo -e "\e[38;5;220m Fixing Python Install Errors...\e[0m"
    sleep 3
    python3 -V
    sudo rm -rf /usr/lib/python3.12/EXTERNALLY-MANAGED
    sudo rm -rf /usr/lib/python3.13/EXTERNALLY-MANAGED
    echo -e "${LIGHT_GREEN}Python install errors fixed!${RESET}"
    
else
    echo -e "\n${BOLD}${DEEP_RED}PLEASE Check The Input Number AGAIN!! THANKS!!${RESET}"
    
fi

# Restart the script
exec "$(command -v bash)" "$0"
