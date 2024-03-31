# Update and upgrade system packages
echo -e "\n====== Updating and upgrading packages ======\n"
sudo apt update -y
sudo apt upgrade -y

# Install Ollama and its models
echo -e "\n====== Installing Ollama ======\n"
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

screen -S llaminator -m -d  python3 main.py
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
