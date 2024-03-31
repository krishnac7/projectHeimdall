# Update and upgrade system packages
echo -e "\n====== Updating and upgrading packages ======\n"
sudo apt update -y
sudo apt upgrade -y

# Install Ollama and its models
echo -e "\n====== Installing pre-requisites ======\n"
curl -fsSL https://ollama.com/install.sh | sh
echo "waiting for ollama to start..."
sleep 10
echo -e "\n====== Fetching Models ======\n"
ollama pull llava

# Install python3-pip
echo -e "\n====== Installing python3-pip ======\n"
sudo apt install python3-pip -y

# Install Flask Python packages
echo -e "\n====== Installing Python packages ======\n"
pip install flask requests

#configure network
echo -e "\n====== configuring firewall ====== \n"
sudo ufw allow 80/tcp
sudo ufw allow ssh
yes | sudo ufw enable
sudo ufw reload

#setup ports
echo -e "\n====== Setting up variables ====== \n"
export PORT=80

#setup startup scripts
echo -e "\n====== Setting up startup scripts ====== \n"
#remove old service
if systemctl --quiet is-active myScreenStartup.service; then
    sudo systemctl stop myScreenStartup.service >/dev/null 2>&1
    sudo systemctl disable myScreenStartup.service >/dev/null 2>&1
    echo "Service stopped and disabled."
else
    echo "Service does not exist or is not running."
fi
if [ -f /etc/systemd/system/myScreenStartup.service ]; then
    sudo rm /etc/systemd/system/myScreenStartup.service >/dev/null 2>&1
    sudo systemctl daemon-reload >/dev/null 2>&1
    sudo systemctl reset-failed >/dev/null 2>&1
    echo "Service file removed and systemd reloaded."
else
    echo "Service file does not exist."
fi

#create new
echo -e "[Unit]\nDescription=Start My Screen Session\nAfter=network.target\n\n[Service]\nType=forking\nEnvironment=\"PORT=80\"\nExecStart=/usr/bin/screen -dmS heimdall python3 /root/projectHeimdall/main.py\n\n[Install]\nWantedBy=multi-user.target" | sudo tee /etc/systemd/system/myScreenStartup.service > /dev/null
sudo systemctl daemon-reload
sudo systemctl enable myScreenStartup.service
sudo systemctl start myScreenStartup.service


echo -e "\n====== now running ======> \n"
echo ' 
project
__    __   _______  __  .___  ___.  _______       ___       __       __      
|  |  |  | |   ____||  | |   \/   | |       \     /   \     |  |     |  |     
|  |__|  | |  |__   |  | |  \  /  | |  .--.  |   /  ^  \    |  |     |  |     
|   __   | |   __|  |  | |  |\/|  | |  |  |  |  /  /_\  \   |  |     |  |     
|  |  |  | |  |____ |  | |  |  |  | |  '--'  | /  _____  \  |  `----.|  `----.
|__|  |__| |_______||__| |__|  |__| |_______/ /__/     \__\ |_______||_______|'
echo -e "\nYou can access the ui on http://<FloatingIP> \n"
echo -e "\n**** If you are using a GPU Instance, you need to Reboot after first install ****\n"