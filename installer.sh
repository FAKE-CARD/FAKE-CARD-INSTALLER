#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "Installer must be initiated with sudo privileges!"
    exit 1
fi

WHITE='\033[1;37m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m'
clear
echo -e "${WHITE}"
echo "CHUT CLIENT"
echo -e "${NC}"
echo -e "#################################################"
echo -e "# Chut Client Installation script @ v1.0"
echo -e "# "
echo -e "# https://julihost.cloud/"
echo -e "# https://github.com/FAKE-CARD"
echo -e "# https://pornhub.com"
echo -e "# "
echo -e "# Running $(lsb_release -is) version $(lsb_release -rs)"
echo -e "#################################################"
echo -e "${NC}"
echo "What would you like to do?"
echo "• [0] Install Chut Client and configure Nginx with SSL"
echo "• [1] Install Chut Client"
echo "• [2] Update Chut Client"
echo "• [3] Install Dependencies"
echo "• [4] Configure Nginx with SSL"
echo "• [5] Uninstall Client"

read -p "Enter your choice (0-5): " choice
echo -e "${NC}"
if [[ $choice == "0" ]]; then
    if [[ -d "/var/www/HolaClient" ]]; then
        echo "HolaClient is already installed! Please select option 5 to reinstall it."
        exit 1
    fi
    
    read -p "Chut Konsi Vali Chahiye Bato (latest): " version
    version=${version:-latest}
    read -p "Land Dalo (client.example.com): " domain
    read -p "Condom Dalo(2000): " port
    port=${port:-2000}
    read -p "Hat Dalo Gand Ke Under (admin@example.com): " email
    email=${email:-support@holaclient.tech}
    
    cd /var/www/
    echo ""
    echo "Updating system..."
    sudo apt -y update > /dev/null 2>&1 && sudo apt -y upgrade > /dev/null 2>&1
    echo "Installing Git..."
    sudo apt -y install git > /dev/null 2>&1
    echo "Installing NodeJS..."
    sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash > /dev/null 2>&1
    source ~/.nvm/nvm.sh > /dev/null 2>&1
    nvm install 20 && nvm use 20 > /dev/null 2>&1
    sudo apt-get install tee -y > /dev/null 2>&1
    echo "Installing dependencies..."
    sudo apt-get install -y gcc g++ make > /dev/null 2>&1
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - > /dev/null 2>&1
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list > /dev/null 2>&1
    sudo apt-get update > /dev/null 2>&1 && sudo apt-get install yarn -y > /dev/null 2>&1
    echo "Downloading Chut Client files..."
    git clone --quiet --single-branch --branch "$version" https://github.com/HolaClient/HolaClient
    cd HolaClient
    echo "Installing Packages..."
    npm i > /dev/null 2>&1
    npm i -g pm2 > /dev/null 2>&1
    pm2 start index.js --name "Chut Client" > /dev/null 2>&1
    echo "Chut Client installation completed successfully."
    echo "Configuring Nginx..."
    sudo apt install -y python3-certbot-nginx nginx > /dev/null 2>&1
    ufw allow 80 > /dev/null && ufw allow 443 > /dev/null
    certbot certonly --nginx -d "$domain" -m "$email"
    sudo tee /etc/nginx/sites-enabled/holaclient.conf > /dev/null << EOL
server {
  listen 80;
  server_name $domain;
  return 301 https://\$server_name\$request_uri;
}

server {
  listen 443 ssl http2;

  location /afkwspath {
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_pass "http://$domain:$port/afkwspath";
  }

  server_name $domain;
  ssl_certificate /etc/letsencrypt/live/$domain/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem;
  ssl_session_cache shared:SSL:10m;
  ssl_protocols SSLv3 TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers HIGH:!aNULL:!MD5;
  ssl_prefer_server_ciphers on;

  location / {
    proxy_pass http://$domain:$port/;
    proxy_buffering off;
    proxy_set_header X-Real-IP \$remote_addr;
  }
}
EOL
    sudo systemctl restart nginx
    echo "Nginx configuration with SSL completed successfully."
    
    elif [[ $choice == "1" ]]; then
    if [[ -d "/var/www/HolaClient" ]]; then
        echo "Chut Client Pele Se Hai Behanchod 5 Number Dal Hatne Ke Liye Nhi To Teri Gand Marduga"
        exit 1
    fi
    
    read -p " Chut Konsi Vali Chahiye Bato (latest): " version
    version=${version:-latest}
    
    cd /var/www/
    echo ""
    echo "Updating system..."
    sudo apt -y update > /dev/null 2>&1 && sudo apt -y upgrade > /dev/null 2>&1
    echo "Installing Git..."
    sudo apt -y install git > /dev/null 2>&1
    echo "Installing NodeJS..."
    sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash > /dev/null 2>&1
    source ~/.nvm/nvm.sh > /dev/null 2>&1
    nvm install 20 && nvm use 20 > /dev/null 2>&1
    sudo apt-get install tee -y > /dev/null 2>&1
    echo "Installing dependencies..."
    sudo apt-get install -y gcc g++ make > /dev/null 2>&1
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - > /dev/null 2>&1
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list > /dev/null 2>&1
    sudo apt-get update > /dev/null 2>&1 && sudo apt-get install yarn -y > /dev/null 2>&1
    echo "Downloading Chuts files..."
    git clone --quiet --single-branch --branch "$version" https://github.com/HolaClient/HolaClient
    cd HolaClient
    echo "Installing Packages..."
    npm i > /dev/null 2>&1
    npm i -g pm2 > /dev/null 2>&1
    pm2 start index.js --name "Chut Client" > /dev/null 2>&1
    echo "Chut Client installation completed successfully."
    
    elif [[ $choice == "2" ]]; then
    if [ ! -d "/var/www/HolaClient" ]; then
        echo "HolaClient is not installed, please Install it first!"
        exit 1
    fi
    
    echo "Checking for updates in Chut Client..."
    cd /var/www/HolaClient
    latest_commit_github=$(git ls-remote https://github.com/HolaClient/HolaClient.git HEAD | cut -f 1)
    current_commit_local=$(git rev-parse HEAD)
    if [[ $latest_commit_github != $current_commit_local ]]; then
        backup_dir="/var/www/HolaClient_backup_$(date +'%Y%m%d%H%M%S')"
        echo "Updates found! Taking a backup of the current directory to $backup_dir..."
        cp -r /var/www/HolaClient "$backup_dir"
        echo "Updating Chut..."
        git fetch origin
        git pull origin latest
        echo "Chut update completed successfully."
    else
        echo "Chut Ready Hai Gand Marne Ke Liye"
    fi
    
    elif [[ $choice == "3" ]]; then
    echo "Installing dependencies..."
    cd /var/www/HolaClient
    echo "Updating system..."
    sudo apt -y update > /dev/null 2>&1 && sudo apt -y upgrade > /dev/null 2>&1
    echo "Installing Git..."
    sudo apt -y install git > /dev/null 2>&1
    echo "Installing NodeJS..."
    sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash > /dev/null 2>&1
    source ~/.nvm/nvm.sh > /dev/null 2>&1
    nvm install 20 && nvm use 20 > /dev/null 2>&1
    sudo apt-get install tee -y > /dev/null 2>&1
    echo "Installing dependencies..."
    sudo apt-get install -y gcc g++ make > /dev/null 2>&1
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - > /dev/null 2>&1
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list > /dev/null 2>&1
    sudo apt-get update > /dev/null 2>&1 && sudo apt-get install yarn -y > /dev/null 2>&1
    echo "Dependencies installation completed successfully."
    
    elif [[ $choice == "4" ]]; then
    read -p "Chut Konsi Vali Chahiye Bato (client.example.com): " domain
    read -p "Land Dalo (2000): " port
    port=${port:-2000}
    read -p "Hat Dalo Chut Ke Under(admin@example.com): " email
    email=${email:-support@holaclient.tech}
    sudo apt install -y python3-certbot-nginx nginx > /dev/null 2>&1
    ufw allow 80 > /dev/null && ufw allow 443 > /dev/null
    certbot certonly --nginx -d "$domain" -m "$email"
    sudo tee /etc/nginx/sites-enabled/holaclient.conf > /dev/null << EOL
server {
  listen 80;
  server_name $domain;
  return 301 https://\$server_name\$request_uri;
}

server {
  listen 443 ssl http2;

  location /afkwspath {
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_pass "http://$domain:$port/afkwspath";
  }

  server_name $domain;
  ssl_certificate /etc/letsencrypt/live/$domain/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem;
  ssl_session_cache shared:SSL:10m;
  ssl_protocols SSLv3 TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers HIGH:!aNULL:!MD5;
  ssl_prefer_server_ciphers on;

  location / {
    proxy_pass http://$domain:$port/;
    proxy_buffering off;
    proxy_set_header X-Real-IP \$remote_addr;
  }
}
EOL
    sudo systemctl restart nginx
    echo "Nginx configuration with SSL completed successfully."
    
    elif [[ $choice == "5" ]]; then
    if [ ! -d "/var/www/HolaClient" ]; then
        echo "Chut Client Ki Maa Ki"
        exit 1
    fi
    read -p "Are you sure you want to uninstall chut client? This will delete all chut client files and configurations. (y/n): " confirm
    if [[ $confirm == "y" ]]; then
        echo "Uninstalling Chut Client..."
        rm -r /var/www/HolaClient/node_modules
        if [ ! -d "/etc/HolaClientBackups" ]; then
            mkdir /etc/HolaClientBackups
        fi
        mkdir /etc/HolaClientBackups/$(date +'%Y%m%d%H%M')
        mv /var/www/HolaClient /etc/HolaClientBackups/$(date +'%Y%m%d%H%M')
        rm /etc/nginx/sites-enabled/holaclient.conf
        pm2 delete holaclient > /dev/null
        echo "Chut Client Hat Gaya Hai Bosrke."
    else
        echo "Uninstallation canceled."
    fi
else
    echo "Invalid choice. Exiting..."
    exit 1
fi
