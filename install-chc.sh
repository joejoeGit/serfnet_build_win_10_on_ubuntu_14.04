#!/bin/sh
#Version 0.0.0.1
#Info: Installs Chaincoind daemon
#Chaincoin Testnet Version 0.16.x 
#Testing OS: Ubuntu 14.04 
#TODO: everything
#TODO: 


message() {

	echo "╒════════════════════════════════════════════════════════>>>"
	echo "| $1" BAAAHHH!!!
	echo "╘════════════════════════════════════════════════════════<<<"
}


	
makefish() {

message "Making the fish ..."

# swoardfish

sudo apt-get install nano -y
sudo apt-get install tmux -y
sudo apt-get install build-essential -y
sudo apt-get install libtool -y
sudo apt-get install autotools-dev -y
sudo apt-get install automake -y
sudo apt-get install autoconf -y
sudo apt-get install pkg-config -y
sudo apt-get install libssl-dev -y
sudo apt-get install libevent-dev -y
sudo apt-get install bsdmainutils -y
sudo apt-get install libboost-system-dev -y
sudo apt-get install libboost-filesystem-dev -y
sudo apt-get install libboost-chrono-dev -y
sudo apt-get install libboost-program-options-dev -y
sudo apt-get install libboost-test-dev -y
sudo apt-get install libboost-thread-dev -y
sudo apt-get install libminiupnpc-dev -y
sudo apt-get install zip -y
sudo apt-get install unzip -y
sudo apt-get install cpulimit -y
sudo apt-get install ufw -y

# upnc - Optional (see --with-miniupnpc and --enable-upnp-default):
sudo apt-get install libminiupnpc-dev -y

# zero message queue
sudo apt-get install libzmq3-dev -y

# QT5 - QT Wallet
sudo apt-get install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler -y

# QR
sudo apt-get install libqrencode-dev -y

message "Fish tastes good!!!"

}


makeberklydb() {

        message "making the berkly..."
	
	# Linux (Ubuntu Only) BerkeleyDb Install
	
	sudo apt-get install software-properties-common -y 
	sudo add-apt-repository ppa:bitcoin/bitcoin -y
	sudo apt-get update
	sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
	
	message "Berlkly done!!!"

}



makechaincoin() {

	message "preparing the the chaincoin..."
	git clone https://github.com/ChainCoin/ChainCoin.git -b Chaincoin_0.16-dev
	cd ChainCoin
	./autogen.sh
	./configure CPPFLAGS="-02 -fPIC" --disable-tests --without-gui
	message "making the chaincoin..."
	make clean
	make install
} 



success() {

	message "SUCCESS you ran some code, feel safe, be happy"
}


install() {
	makefish
	makeberklydb
	makechaincoin
	success
}

#main
#default to --without-gui
#install --without-gui
install
