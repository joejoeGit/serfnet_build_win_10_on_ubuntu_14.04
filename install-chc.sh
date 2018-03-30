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
	# General
	sudo apt update
	sudo apt-get git
	sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 
	# Boost C macros - Bitcoin core trying to remove this
	sudo apt-get install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
	# Berkeley Db - Some duplication - script is used later
	sudo apt-get install software-properties-common
	sudo apt-get update
	sudo apt-get install libdb4.8-dev libdb4.8++-dev
	# upnc - Optional (see --with-miniupnpc and --enable-upnp-default):
	#sudo apt-get install libminiupnpc-dev
	# zero message queue
	#sudo apt-get install libzmq3-dev
	# QT5 - QT Wallet
	#sudo apt-get install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler
	# QR
	#sudo apt-get install libqrencode-dev

	git clone https://github.com/ChainCoin/ChainCoin.git -b Chaincoin_0.16-dev
	cd ChainCoin
	./autogen.sh
	sudo ./contrib/install_db4.sh berkeley48
	export BDB_PREFIX='/db4'ls
	./configure CPPFLAGS="-fPIC" --disable-tests --without-gui
	make
	make install

}
	


#------------------------------------------------

#--------------------------------------------------




success() {

	message "SUCCESS you ran some code, feel safe, be happy"
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
