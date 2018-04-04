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

sudo apt-get install build-essential -y
sudo apt-get install libtool -y
sudo apt-get install autotools-dev -y
sudo apt-get install automake
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
sudo apt-get install ufw git -y
sudo apt-get install libzmq3-dev -y

message "Fish tastes good!!!"

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
	
	message "Berlkly done!!!"

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


configurechaincoin() {

	message "Creating chaincoin.conf..."

	MNPRIVKEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
	CONFDIR=~/.chaincoincore
	CONFILE=$CONFDIR/chaincoin2.conf
	if [ ! -d "$CONFDIR" ]; then mkdir $CONFDIR; fi
	if [ $? -ne 0 ]; then error; fi
	
	mnip=$(curl -s https://api.ipify.org)

 	printf "%s\n"  
       	       "daemon=1"
	       "testnet=1"
	       "debug=1"
	       "prematurewitness=1"
	       "rpcuser=tCHC123"
	       "rpcpassword=tCHC123" 
	       "rpcport=21995" 
	       "rpcallowip=127.0.0.1" 
	       "listen=1" 
	       "server=1" 
	
	       
	       "externalip=$mnip" 
	       "bind=$mnip" 
	       "masternode=1" 
	       "masternodeprivkey=$MNPRIVKEY" 
	       "masternodeaddr=$mnip:11994" 
	       > $CONFILE

       #chaincoind
       #message "Wait 10 seconds for daemon to load..."
       #sleep 20s
       #MNPRIVKEY=$(chaincoin-cli masternode genkey)
#	chaincoin-cli stop
#	message "wait 10 seconds for deamon to stop..."
#       sleep 10s
#	sudo rm $CONFILE
#	message "Updating chaincoin.conf..."
#       printf "%s\n" "rpcuser=$rpcuser" "rpcpassword=$rpcpass" "rpcallowip=127.0.0.1" "listen=1" "server=1" "daemon=1" "maxconnections=256" "rpcport=11995" "externalip=$mnip" "bind=$mnip" "masternode=1" "masternodeprivkey=$MNPRIVKEY" "masternodeaddr=$mnip:11994" > $CONFILE





#rpcuser=123
#rpcpassword=123
#rpcport=21995
#addnode=207.246.88.75


}


makesentinel() {
	message "Makingin the crashy thing..." 
	sudo apt-get update
	sudo apt-get -y install python-virtualenv -y
	sudo apt install virtualenv -y
	cd ChainCoin
	git clone https://github.com/chaincoin/sentinel.git && cd sentinel
	virtualenv ./venv
	./venv/bin/pip install -r requirements.txt
	#sudo echo "* * * * * cd /root/ChainCoin/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1" >> /tmp/crontab.SWy3wG/crontab

	
	
	#* * * * * cd /root/ChainCoin/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1
	###verify the test
	#/root/ChainCoin/sentinel/venv/bin/py.test ./test
	###configure the sentinels
	##chaincoin_conf=/path/to/chaincoin.conf
	###run the debug
	#SENTINEL_DEBUG=1 ./venv/bin/python bin/sentinel.py

}

success() {

	message "SUCCESS you ran some code, feel safe, be happy"
}


install() {
	#createfirewall
	#createswap
	#prepdependencies
	#makefish
	#makeboost
	#makeberklydb
	#makeberklydb2
	#makechaincoin
	makesentinel
	#configurechaincoin
	success
}

#main
#default to --without-gui
#install --without-gui
install
