genCryptoConfigOrderer() {
    
    echo "Generate crypto-config for Orderer"
    ./docker-compose/bin/cryptogen generate \
    --config=./docker-compose/channel/crypto-config-orderer.yaml \
    --output=./docker-compose/channel/crypto-config-orderer

}

genCryptoConfigOrgA() {

    echo "Generate crypto-config for OrgA"
    ./docker-compose/bin/cryptogen generate \
    --config=./docker-compose/channel/crypto-config-orga.yaml \
    --output=./docker-compose/channel/crypto-config-orga

}

genCryptoConfigOrgB() {

    echo "Generate crypto-config for OrgB"
    ./docker-compose/bin/cryptogen generate \
    --config=./docker-compose/channel/crypto-config-orgb.yaml \
    --output=./docker-compose/channel/crypto-config-orgb

}

genCryptoConfigOrgC() {

    echo "Generate crypto-config for OrgC"
    ./docker-compose/bin/cryptogen generate \
    --config=./docker-compose/channel/crypto-config-orgc.yaml \
    --output=./docker-compose/channel/crypto-config-orgc

}

createConfigGenesis() {

    echo "Create configuration file for Genesis block"
    ./docker-compose/bin/configtxgen \
    -configPath ./docker-compose/channel/ \
    -profile OrdererGenesis \
    -outputBlock ./docker-compose/channel/genesis.block

}

createConfigThreeChannel() {

    echo "Create configuration file for channel"
    export CHANNEL_NAME=channel
    ./docker-compose/bin/configtxgen \
    -configPath ./docker-compose/channel/ \
    -profile OrgsChannel \
    -outputCreateChannelTx ./docker-compose/channel/channel.tx \
    -channelID $CHANNEL_NAME

    #Create config file channel0
    export CHANNEL_NAME=channel-0
    ./docker-compose/bin/configtxgen \
    -configPath ./docker-compose/channel/ \
    -profile OrgsChannel \
    -outputCreateChannelTx ./docker-compose/channel/channel-0.tx \
    -channelID $CHANNEL_NAME 

    #Create config file channel1
    export CHANNEL_NAME=channel-1
    ./docker-compose/bin/configtxgen \
    -configPath ./docker-compose/channel/ \
    -profile OrgsChannel \
    -outputCreateChannelTx ./docker-compose/channel/channel-1.tx \
    -channelID $CHANNEL_NAME 

}
