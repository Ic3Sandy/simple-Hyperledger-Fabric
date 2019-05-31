#!/bin/bash

info() {

    echo "This is script for Test System!"
    echo "You need to put argument for this script and change env.sh for you."
    echo "Example: \"./script.sh up\" or \"./scipt.sh down\""
    echo "If you use Ubuntu, you must use sudo for run script."
    echo "Example: \"sudo -E ./script.sh up\" or \"sudo -E ./scipt.sh down\""

}

getIP() {

    if [ $host == 'ubuntu' ]
    then
        export IP_Orderer=$(ifconfig $(route | grep 'default' | awk '{print $8}') | grep 'inet ' | awk '{print $2}' | head -1)
        export IP_OrgA=$(ifconfig $(route | grep 'default' | awk '{print $8}') | grep 'inet ' | awk '{print $2}' | head -1)
        export IP_OrgB=$(ifconfig $(route | grep 'default' | awk '{print $8}') | grep 'inet ' | awk '{print $2}' | head -1)
        export IP_OrgC=$(ifconfig $(route | grep 'default' | awk '{print $8}') | grep 'inet ' | awk '{print $2}' | head -1)

    elif [ $host == 'win' ]
    then
        export IP_Orderer=$(route PRINT -4 | awk '$2 == "0.0.0.0" {print $4}' | head -1)
        export IP_OrgA=$(route PRINT -4 | awk '$2 == "0.0.0.0" {print $4}' | head -1)
        export IP_OrgB=$(route PRINT -4 | awk '$2 == "0.0.0.0" {print $4}' | head -1)
        export IP_OrgC=$(route PRINT -4 | awk '$2 == "0.0.0.0" {print $4}' | head -1)
    
    else
        echo "Chose win or ubuntu"
        exit 1
    fi

}

# installPackage pullImages
source ./func/script-install-pull.sh

# showDocker startDocker downDocker downSystem
source ./func/script-docker-compose.sh

# genCryptoConfigOrderer genCryptoConfigOrgA,B,C createConfigGenesis createConfigThreeChannel
source ./func/script-init.sh

# registerMemberOfOrg
source ./func/script-reg.sh

# createChannel joinChannel installChaincode instantiateChaincode 
# upgradeChaincode invokeChaincode queryChaincode queryBlock updateChannel
source ./func/script-api.sh

# startSystem
source ./func/script-startSystem.sh

# testSystem
source ./func/script-testSystem.sh

# serverUp serverDown
source ./func/script-server.sh

# Set env and IP
source ./env.sh

# -z STRING => The lengh of STRING is zero (ie it is empty).
if [ -z "$1" ]
then

    info
    exit 1

# -n STRING => The length of STRING is greater than zero.
elif [ $1 == 'up' ] && [ -n $system ] && [ -n $host ]
then

    if [ $system == 'all' ]
    then

        export node='orderer'
        startDocker

        export IP_Orderer1=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' orderer1.example.com)
        export IP_Orderer2=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' orderer2.example.com)
        export IP_Orderer3=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' orderer3.example.com)
        export node='orga'
        startDocker
        export node='orgb'
        startDocker
        export node='orgc'
        startDocker

    else

        export node=$system
        startDocker

    fi


    echo "##################################"
    echo "##### Start Docker Success!! #####"
    echo "##################################"
    showDocker
    exit 1


elif [ $1 == 'down' ] && [ -n $system ] && [ -n $host ]
then

    if [ $system == 'all' ]
    then

        export IP_Orderer1=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' orderer1.example.com)
        export IP_Orderer2=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' orderer2.example.com)
        export IP_Orderer3=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' orderer3.example.com)
        export node='orderer'
        downDocker
        export node='orga'
        downDocker 
        export node='orgb'
        downDocker
        export node='orgc'
        downDocker
        downSystem

    else

        export node=$system
        downDocker
        downSystem

    fi

    echo "#################################"
    echo "##### Down Docker Success!! #####"
    echo "#################################"
    showDocker
    exit 1

elif [ $1 == 'install' ] && [ -n $host ]
then

    # getIP
    echo "############################"
    echo "##### Install Library ######"
    echo "############################"
    installPackage
    exit 1

elif [ $1 == 'pull' ] && [ -n $host ]
then

    # getIP
    echo "############################"
    echo "##### Pull Images ##########"
    echo "############################"
    pullImages
    exit 1

elif [ $1 == 'test' ] && [ -n "$host" ]
then

    echo "########################"
    echo "##### Test System ######"
    echo "########################"
    testSystem
    exit 1
    
elif [ $1 == 'start' ]  && [ -n $host ]
then

    echo "#########################"
    echo "##### Start System ######"
    echo "#########################"
    startSystem
    exit 1

elif [ $1 == 'ip' ]
then

    if [ $host == 'ubuntu' ]
    then
        IPv4=$(ifconfig $(route | grep 'default' | awk '{print $8}') | grep 'inet ' | awk '{print $2}' | head -1)
        echo "Ip: $IPv4"

    elif [ $host == 'win' ]
    then
        IPv4=$(route PRINT -4 | awk '$2 == "0.0.0.0" {print $4}' | head -1)
        echo "Ip: $IPv4"

    else
        echo "Chose win or ubuntu"
        exit 1
    fi


elif [ $1 == 'server' ] && [ -n $2 ]
then

    if [ $2 == 'up' ]
    then
        
        # export IP_Orderer1=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' orderer1.example.com)
        # export IP_Orderer2=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' orderer2.example.com)
        # export IP_Orderer3=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' orderer3.example.com)
        serverUp
    
    elif [ $2 == 'down' ]
    then

        # export IP_Orderer1=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' orderer1.example.com)
        # export IP_Orderer2=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' orderer2.example.com)
        # export IP_Orderer3=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' orderer3.example.com)
        serverDown
    
    else
        printf "Choose server up or server down\n"

    fi


elif [ $1 == 'show' ]
then

    showDocker


else

    printf "\nYou put \"$1\", It Incorrect argument!\n"
    info
    exit 1

fi
