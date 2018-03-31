#!/bin/sh
#Version 0.0.0.1
#Info: Installs Chaincoind daemon
#Chaincoin Testnet Version 0.16.x 
#Testing OS: Ubuntu 16.04 
#TODO: everything
#TODO: 


message() {

	echo "╒════════════════════════════════════════════════════════>>>"
	echo "| $1" BAAAHHH!!!
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
	message "Creating 2GB permament swap file...wati a minutes.."
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
	# Extras
	sudo apt-get git
		
	#Linux Distrobution specific intallation (Unbuntu Debinan)
	
	sudo apt-get install build-essential 
	sudo apt-get install libtool 
	sudo apt-get install autotools-dev
	sudo apt-get install automake 
        sudo apt-get install pkg-config 
	sudo apt-get install libssl-dev
	sudo apt-get install libevent-dev 
	sudo apt-get install bsdmainutils 
	sudo apt-get install python3 
        
	#Chao's extras
	#DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
	#sudo apt-get install autoconf -y #not in bitcoin or dash instructions
	#sudo apt-get install libdb++-dev
	#sudo apt-get install libboost-all-dev
	#sudo apt-get install libminiupnpc-dev 
	#sudo apt-get install g++

}
	
makefish() {

message "Making the fish ..."
sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev libminiupnpc-dev zip unzip cpulimit ufw git libzmq3-dev -y


}


makeboost() {
	#Linux Distrobution specific (Ubuntu 14.04+ Debinan 7+)
	sudo apt-get install 
	sudo apt-get libboost-system-dev 
	sudo apt-get libboost-filesystem-dev 
	sudo apt-get libboost-chrono-dev
	sudo apt-get libboost-program-options-dev
	sudo apt-get libboost-test-dev
	sudo apt-get libboost-thread-dev
	#option 2. if install all boost development packages with
	#sudo apt-get intall libboost-al-dev
	#option 3.  build boost yourself
	#sudo su
	#./bootrap.sh
	#./bjam intall
}



makeberklydb() {
        message "making the berkly..."
	# Linux (Ubuntu Only) BerkeleyDb Install
	sudo apt-get install software-properties-common -y #on bitcoin instructions not dash?
	sudo add-apt-repository ppa:bitcoin/bitcoin -y
	sudo apt-get update
	sudo apt-get install libdb4.8-dev libdb4.8++-dev -y

}

makeberklydb2() {

message "Compiling BerklyDB..."
	cd ~
	mkdir /db4/
	wget 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
	tar -xzvf db-4.8.30.NC.tar.gz
	cd db-4.8.30.NC/build_unix/
	../dist/configure --enable-cxx --disable-shared --with-pic --prefix=/root/db4/
	make install
	cd ~
}




makechaincoin() {

	message "preparing the the chaincoin..."
	git clone https://github.com/ChainCoin/ChainCoin.git -b Chaincoin_0.16-dev
	cd ChainCoin
	./autogen.sh
	#sudo ./contrib/install_db4.sh berkeley48
	#export BDB_PREFIX='/db4'ls
	./configure CPPFLAGS="-fPIC" --disable-tests --without-gui
	message "making the chaincoin..."
	make clean
	make install
}


success() {

	message "SUCCESS you ran some code, feel safe, be happy"
}


install() {
	#createfirewall
	createswap
	#prepdependencies
	makefish
	#makeboost
	makeberklydb
	#makeberklydb2
	makechaincoin
	success
}

#main
#default to --without-gui
#install --without-gui
install
