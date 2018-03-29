#!/bin/sh
#Version 0.0.0.1
#Info: Installs Chaincoind daemon
#Chaincoin Testnet Version 0.16.x 
#Testing OS: Ubuntu 16.04 
#TODO: everything
#TODO: 


message() {

	echo "╒════════════════════════════════════════════════════════>>>"
	echo "| $1"
	echo "╘════════════════════════════════════════════════════════<<<"
}


createfirewall() {

	sudo ufw allow 21994
	
	sudo ufw allow 21995
	
	sudo ufw default deny incoming
	
	sudo ufw default allow outgoing
	
	sudo ufw enable 
	
	#sudo reboot
}


createswap() { #TODO: add error detection

	message "Creating 2GB permament swap file...this may take a few minutes..."
	
	sudo dd if=/dev/zero of=/swapfile bs=1M count=2000	

	sudo mkswap /swapfile

	sudo chown root:root /swapfile

	sudo chmod 0600 /swapfile

	sudo swapon /swapfile

	sudo chmod 0600 /swapfile

	sudo chown root:root /swapfile

	sudo echo "/swapfile none swap sw 0 0" >> /etc/fstab
}









prepdependencies() { #TODO: add error detection


	message "Installing dependencies..."
	
	
	
	apt-get install libtool autotools-dev autoconf automake -y
	
	
	# General
	sudo apt update
	sudo apt-get install build-essential -y
	sudo apt-get install autotools-dev -y           
	
	
	###not sure which one here
	#sudo apt-get install automake pkg-config -y
	sudo apt-get install automake -y
	
	
	sudo apt-get install libssl-dev -y
	sudo apt-get install libevent-dev -y
	sudo apt-get install bsdmainutils -y
	sudo apt-get install  git -y

	# Boost C macros - Bitcoin core trying to remove this	
	
	sudo apt-get install libboost-system-dev -y
	sudo apt-get install libboost-filesystem-dev -y
	sudo apt-get install libboost-chrono-dev -y
	sudo apt-get install libboost-program-options-dev -y
	sudo apt-get install libboost-test-dev -y
	sudo apt-get install libboost-thread-dev -y	

#	# Berkeley Db - Some duplication - script is used later
#	sudo apt-get install software-properties-common 
#	sudo add-apt-repository ppa:bitcoin/bitcoin
#	sudo apt-get update
#	sudo apt-get install libdb4.8-dev libdb4.8++-dev
	
	
####### may want to comple my own berkly dB
#----------------------------------
#Build Berkly Database 
#----------------------------------
cd ~
mkdir bitcoin
cd bitcoin
mkdir db4
cd ~
wget 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
tar -xzvf db-4.8.30.NC.tar.gz
cd db-4.8.30.NC/build_unix/
../dist/configure --enable-cxx --disable-shared --with-pic --prefix=/root/bitcoin/db4/
make install

	
##############stuff for qt wallet
# upnc - Optional (see --with-miniupnpc and --enable-upnp-default):
#sudo apt-get install libminiupnpc-dev
# zero message queue
#sudo apt-get install libzmq3-dev


#sudo ./contrib/install_db4.sh berkeley48
#export BDB_PREFIX='/db4'
# ./configure CPPFLAGS="-fPIC" --disable-tests --without-gui

#--------------------------------------------------
Build Chaincoin
git clone https://github.com/ChainCoin/ChainCoin.git -b Chaincoin_0.16-dev
cd ChainCoin
./autogen.sh
./configure CPPFLAGS="-fPIC" --disable-tests --without-gui
make
sudo make install


#--------------------------------------------------





 
#########################additional stuf for QT wallet#######
# QT5 - QT Wallet
#sudo apt-get install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler
# QR
#sudo apt-get install libqrencode-dev
#############################################################

#########################Chaos install#######################
#	sudo apt-get update
#	sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
#	sudo apt-get install automake libdb++-dev build-essential libtool autotools-dev autoconf pkg-config libssl-dev libboost-all-dev libminiupnpc-dev git software-properties-common python-software-properties g++ bsdmainutils libevent-dev -y
#	sudo add-apt-repository ppa:bitcoin/bitcoin -y
#	sudo apt-get update
#	sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
#############################################################
}


clonerepo() { #TODO: add error detection
	message "Cloning from github repository..."
  	cd ~/
	git clone https://github.com/chaincoin-legacy/chaincoin
}

compile() {
	cd chaincoin #TODO: squash relative path
	message "Preparing to build..."
	./autogen.sh
	if [ $? -ne 0 ]; then error; fi
	message "Configuring build options..."
	./configure $1 --disable-tests
	if [ $? -ne 0 ]; then error; fi
	message "Building ChainCoin...this may take a few minutes..."
	make
	if [ $? -ne 0 ]; then error; fi
	message "Installing ChainCoin..."
	sudo make install
	if [ $? -ne 0 ]; then error; fi
}

createconf() {
	#TODO: Can check for flag and skip this
	#TODO: Random generate the user and password

	message "Creating chaincoin.conf..."
	MNPRIVKEY="6FBUPijSGWWDrhbVPDBEoRuJ67WjLDpTEiY1h4wAvexVZH3HnV6"
	CONFDIR=~/.chaincoin
	CONFILE=$CONFDIR/chaincoin.conf
	if [ ! -d "$CONFDIR" ]; then mkdir $CONFDIR; fi
	if [ $? -ne 0 ]; then error; fi
	
	mnip=$(curl -s https://api.ipify.org)
	rpcuser=$(date +%s | sha256sum | base64 | head -c 10 ; echo)
	rpcpass=$(openssl rand -base64 32)
	printf "%s\n" "rpcuser=$rpcuser" "rpcpassword=$rpcpass" "rpcallowip=127.0.0.1" "listen=1" "server=1" "daemon=1" "maxconnections=256" "rpcport=11995" "externalip=$mnip" "bind=$mnip" "masternode=1" "masternodeprivkey=$MNPRIVKEY" "masternodeaddr=$mnip:11994" > $CONFILE

        chaincoind
        message "Wait 10 seconds for daemon to load..."
        sleep 20s
        MNPRIVKEY=$(chaincoin-cli masternode genkey)
	chaincoin-cli stop
	message "wait 10 seconds for deamon to stop..."
        sleep 10s
	sudo rm $CONFILE
	message "Updating chaincoin.conf..."
        printf "%s\n" "rpcuser=$rpcuser" "rpcpassword=$rpcpass" "rpcallowip=127.0.0.1" "listen=1" "server=1" "daemon=1" "maxconnections=256" "rpcport=11995" "externalip=$mnip" "bind=$mnip" "masternode=1" "masternodeprivkey=$MNPRIVKEY" "masternodeaddr=$mnip:11994" > $CONFILE

}

createhttp() {
	cd ~/
	mkdir web
	cd web
	wget https://raw.githubusercontent.com/chaoabunga/chc-scripts/master/index.html
	wget https://raw.githubusercontent.com/chaoabunga/chc-scripts/master/stats.txt
	(crontab -l 2>/dev/null; echo "* * * * * echo MN Count:  > ~/web/stats.txt; /usr/local/bin/chaincoind masternode count >> ~/web/stats.txt; /usr/local/bin/chaincoind getinfo >> ~/web/stats.txt") | crontab -
	mnip=$(curl -s https://api.ipify.org)
	sudo python3 -m http.server 8000 --bind $mnip 2>/dev/null &
	echo "Web Server Started!  You can now access your stats page at http://$mnip:8000"
}

noflags() {
	echo "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄"
    echo "Usage: install-chc"
    echo "Example: install-chc"
    echo "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄"
    exit 1
}



error() {
	message "An error occured, you must fix it to continue!"
	exit 1
}


success() {
#	chaincoind
	message "SUCCESS you ran some code, feel safe, be happy"
#	message "MN $mnip:11994 $MNPRIVKEY TXHASH INDEX"
	exit 0
}


install() {
	#createfirewall
	#createswap
        prepdependencies
	success
}

#main
#default to --without-gui
install --without-gui
