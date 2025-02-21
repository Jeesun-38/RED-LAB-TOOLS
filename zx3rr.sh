#!/bin/bash

BOLD="\e[1m"
DEEP_GREEN="\e[38;5;28m"  
DEEP_RED="\e[38;5;196m"
MID_YELLOW="\e[38;5;220m"    
RESET="\e[0m"

# Banner
echo -e "\e[0;91m"
cat << "EOF"
██████╗ ███████╗██████╗       ██╗      █████╗ ██████╗    ████████╗ ██████╗  ██████╗ ██╗     ███████╗
██╔══██╗██╔════╝██╔══██╗      ██║     ██╔══██╗██╔══██╗   ╚══██╔══╝██╔═══██╗██╔═══██╗██║     ██╔════╝
██████╔╝█████╗  ██║  ██║█████╗██║     ███████║██████╔╝█████╗██║   ██║   ██║██║   ██║██║     ███████╗
██╔══██╗██╔══╝  ██║  ██║╚════╝██║     ██╔══██║██╔══██╗╚════╝██║   ██║   ██║██║   ██║██║     ╚════██║
██║  ██║███████╗██████╔╝      ███████╗██║  ██║██████╔╝      ██║   ╚██████╔╝╚██████╔╝███████╗███████║
╚═╝  ╚═╝╚══════╝╚═════╝       ╚══════╝╚═╝  ╚═╝╚═════╝       ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝╚══════╝
EOF
echo -e "\e[0m"

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
export GOPATH=\${HOME}/go
export PATH=\$GOPATH/bin:\$GOROOT/bin:\${HOME}/.local/bin:\$PATH
EOF
    
    if ! grep -q "source $GO_ENV_FILE" "$PROFILE_FILE"; then
        echo "source $GO_ENV_FILE" >> "$PROFILE_FILE"
    fi
    
    source $PROFILE_FILE
    INSTALLED_GO_VERSION=$LATEST_GO_VERSION
else
    echo -e "${DEEP_GREEN}Go (${INSTALLED_GO_VERSION}) is already up-to-date.${RESET}"
fi

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

echo -e "\n${BOLD}${DEEP_GREEN}Installing ProjectDiscovery Tools...${RESET}"
for TOOL in "${TOOLS[@]}"; do
    echo -e "${DEEP_GREEN}Installing $TOOL...${RESET}"
    go install -v "$TOOL"
    if [ $? -eq 0 ]; then
        echo -e "${DEEP_GREEN}$TOOL installed successfully.${RESET}"
    else
        echo -e "${DEEP_RED}Failed to install $TOOL.${RESET}"
    fi

done

echo -e "\n${BOLD}${DEEP_GREEN}ALL THE TOOLS ARE INSTALLED!! DONE 🎉${RESET}"
echo -e "\n${BOLD}${MID_YELLOW}Scipt Created By TEAM ZX3RR(ZETSU-MR.X-MR.ERROR)${RESET}"
