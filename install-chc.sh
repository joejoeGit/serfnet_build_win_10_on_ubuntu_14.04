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




installgeneraldependencies(){

	message "installing dependencies"
	sudo apt-get update
	sudo apt-get upgrade
	sudo apt install build-essential libtool autotools-dev automake pkg-config bsdmainutils curl git -y
}


installcrosscompilationtoolchain()
{
	message "installing the tool chain"
	sudo apt install g++-mingw-w64-x86-64 -y
}
	

installmoreqtstuff() {	
	message "installing more qt stuff"
	# upnc - Optional (see --with-miniupnpc and --enable-upnp-default):
	sudo apt-get install libminiupnpc-dev -y
	# zero message queue
	sudo apt-get install libzmq3-dev -y
	# QT5 - QT Wallet
	sudo apt-get install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler -
	# QR
	sudo apt-get install libqrencode-dev -y	
}

makechaincoin() {
	message "preparing the the chaincoin..."
	git clone https://github.com/ChainCoin/ChainCoin.git -b Chaincoin_0.16-dev
	sudo chmod -R a+rw ChainCoin
	cd ChainCoin
	PATH=$(echo "$PATH" | sed -e 's/:\/mnt.*//g') # strip out problematic Windows %PATH% imported var
	cd depends
	make HOST=x86_64-w64-mingw32
	cd ..
	./autogen.sh
	CONFIG_SITE=$PWD/depends/x86_64-w64-mingw32/share/config.site ./configure --prefix=/
	message "sweet baby chain!!!"
} 


success() {

	message "SUCCESS you ran some code, feel safe, be happy"
}


install() {
        cd ~
	installgeneraldependencies
	installcrosscompilationtoolchain
	installmoreqtstuff
	installmingw-w64
	makechaincoin
	success
}

#main
install
