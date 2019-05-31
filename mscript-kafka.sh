
# Generate crypto-config for orderer
./docker-compose/bin/cryptogen generate \
--config=./docker-compose/channel/crypto-config-orderers.yaml \
--output=./docker-compose/channel/crypto-config-orderers

# Generate crypto-config for orga
./docker-compose/bin/cryptogen generate \
--config=./docker-compose/channel/crypto-config-orga.yaml \
--output=./docker-compose/channel/crypto-config-orga

# Generate crypto-config for orgb
./docker-compose/bin/cryptogen generate \
--config=./docker-compose/channel/crypto-config-orgb.yaml \
--output=./docker-compose/channel/crypto-config-orgb

# Generate crypto-config for orgb
./docker-compose/bin/cryptogen generate \
--config=./docker-compose/channel/crypto-config-orgc.yaml \
--output=./docker-compose/channel/crypto-config-orgc


#Create config file Genesis block
./docker-compose/bin/configtxgen \
-configPath ./docker-compose/channel/ \
-profile OrdererGenesis \
-outputBlock ./docker-compose/channel/genesis.block

#Create config file channel
export CHANNEL_NAME=channel
./docker-compose/bin/configtxgen \
-configPath ./docker-compose/channel/ \
-profile OrgsChannel \
-outputCreateChannelTx ./docker-compose/channel/channel.tx \
-channelID $CHANNEL_NAME 


# Docker Command
docker exec -it server bash
npm start

docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"


# Start Command for connect API (linux)
export TokenOrgA=$( curl -s -X POST http://localhost:4000/reg \
-H "content-type: application/json" \
-d '{"username": "Alice", "orgName": "OrgA"}' | \
./jq/jq-linux64 .token | sed -e 's/^"//' -e 's/"$//')
echo "TokenOrgA = $TokenOrgA"

export TokenOrgB=$( curl -s -X POST http://localhost:4000/reg \
-H "content-type: application/json" \
-d '{"username": "Bob", "orgName": "OrgB"}' | \
./jq/jq-linux64 .token | sed -e 's/^"//' -e 's/"$//')
echo "TokenOrgB = $TokenOrgB"


# Start Command for connect API (windows)
export TokenOrgA=$( curl -s -X POST http://localhost:4000/reg \
-H "content-type: application/json" \
-d '{"username": "Alice", "orgName": "OrgA"}' | \
./jq/jq-win64 .token | sed -e 's/^"//' -e 's/"$//')
echo "TokenOrgA = $TokenOrgA"

export TokenOrgB=$( curl -s -X POST http://localhost:4000/reg \
-H "content-type: application/json" \
-d '{"username": "Bob", "orgName": "OrgB"}' | \
./jq/jq-win64 .token | sed -e 's/^"//' -e 's/"$//')
echo "TokenOrgB = $TokenOrgB"

export TokenOrgC=$( curl -s -X POST http://localhost:4000/reg \
-H "content-type: application/json" \
-d '{"username": "Carol", "orgName": "OrgC"}' | \
./jq/jq-win64 .token | sed -e 's/^"//' -e 's/"$//')
echo "TokenOrgC = $TokenOrgC"


# Create channel
curl -s -X POST \
    http://localhost:4000/channels/channel \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
	    "channelConfigPath":"../channel/channel.tx"
    }'

# Join channel
curl -s -X POST \
    http://localhost:4000/joinchannels/channel \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
	    "targets": ["peer1.orga.example.com", "peer2.orga.example.com"]
    }'

curl -s -X POST \
    http://localhost:4000/joinchannels/channel \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
	    "targets": ["peer1.orgb.example.com", "peer2.orgb.example.com"]
    }'

curl -s -X POST \
    http://localhost:4000/joinchannels/channel \
    -H "authorization: Bearer $TokenOrgC" \
    -H "content-type: application/json" \
    -d '{
	    "targets": ["peer1.orgc.example.com", "peer2.orgc.example.com"]
    }'

# Install chaincode
curl -s -X POST \
    http://localhost:4000/installchaincodes/cc \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "targets": ["peer1.orga.example.com", "peer2.orga.example.com"],
        "chaincodePath":"cc-whatever",
        "chaincodeType": "golang",
        "chaincodeVersion":"v0"
    }'

curl -s -X POST \
    http://localhost:4000/installchaincodes/cc \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
        "targets": ["peer1.orgb.example.com", "peer2.orgb.example.com"],
        "chaincodePath":"cc-whatever",
        "chaincodeType": "golang",
        "chaincodeVersion":"v0"
    }'

curl -s -X POST \
    http://localhost:4000/installchaincodes/cc \
    -H "authorization: Bearer $TokenOrgC" \
    -H "content-type: application/json" \
    -d '{
        "targets": ["peer1.orgc.example.com", "peer2.orgc.example.com"],
        "chaincodePath":"cc-whatever",
        "chaincodeType": "golang",
        "chaincodeVersion":"v0"
    }'


# Instantiate chaincode
curl -s -X POST \
    http://localhost:4000/channels/channel/instantiate \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "chaincodeId":"cc",
        "chaincodeVersion":"v0",
        "chaincodeType": "golang",
        "endorsementPolicy": "./config/policy4.json"
    }'


"targets": ["peer1.orga.example.com"],
# Invoke request
curl -s -X POST \
    http://localhost:4000/channels/channel/chaincodes/cc \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "create",
        "args": ["Alice", "id", "123", "email", "alice@email.com", "username", "Alice007"]
    }'

curl -s -X POST \
    http://localhost:4000/channels/channel/chaincodes/cc \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "create",
        "args": ["Bob", "id", "456", "email", "bob@email.com", "username", "Bobby"]
    }'

curl -s -X POST \
    http://localhost:4000/channels/channel/chaincodes/cc \
    -H "authorization: Bearer $TokenOrgC" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "create",
        "args": ["Carol", "id", "789", "email", "carol@email.com", "username", "Caroline"]
    }'


"targets": ["peer1.orga.example.com"],
# Query chaincode
curl -s -X GET \
    http://localhost:4000/channels/channel/chaincodes/cc \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "read",
        "args": ["Alice"]
    }'  

curl -s -X GET \
    http://localhost:4000/channels/channel/chaincodes/cc \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "read",
        "args": ["Bob"]
    }'  

curl -s -X GET \
    http://localhost:4000/channels/channel/chaincodes/cc \
    -H "authorization: Bearer $TokenOrgC" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "read",
        "args": ["Carol"]
    }' 

# Query chaincode by transaction
curl -s -X GET \
    http://localhost:4000/channels/channel/transactions \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "targets": ["peer1.orga.example.com"],
        "tx_id": "3223af386480275d47cca8ed06fc33108d4d548b9cd307b4cc7c6cd15fd45885"
    }'

# Query chaincode by blocknumber
curl -s -X GET \
    http://localhost:4000/channels/channel/blocknumber \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "targets": ["peer1.orga.example.com"],
        "blockNumber": 3
    }'

# Install chaincode new version
curl -s -X POST \
    http://localhost:4000/installchaincodes/cc \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "targets": ["peer1.orga.example.com"],
        "chaincodePath":"cc-whatever",
        "chaincodeType": "golang",
        "chaincodeVersion":"v1"
    }'

curl -s -X POST \
    http://localhost:4000/installchaincodes/cc \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
        "targets": ["peer1.orgb.example.com"],
        "chaincodePath":"cc-whatever",
        "chaincodeType": "golang",
        "chaincodeVersion":"v1"
    }'


# Instantiate chaincode new version
curl -s -X PUT \
    http://localhost:4000/channels/mychannel/instantiate \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "chaincodeId":"cc",
        "chaincodeVersion":"v1",
        "chaincodeType": "golang",
        "args":[],
        "endorsementPolicy": "./config/policy3.json"
    }'

# Invoke create Bob
curl -s -X POST \
    http://localhost:4000/channels/mychannel/chaincodes/cc \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
        "targets": ["peer1.orgb.example.com"],
        "fcn": "create",
        "args": ["Bob", "id", "456", "email", "bob@email.com", "username", "Bobby"]
    }'

# Query Bob
curl -s -X GET \
    http://localhost:4000/channels/mychannel/chaincodes/cc \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
        "targets": ["peer1.orgb.example.com"],
        "fcn": "read",
        "args": ["Bob"]
    }'  

# Query chaincode by transaction
curl -s -X GET \
    http://localhost:4000/channels/mychannel/transactions \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
        "targets": ["peer1.orgb.example.com"],
        "tx_id": "0a6e89f996d012a02ca0ab746f67ebe14af344662a5feec0077d845bef707d8f"
    }'


####################################################################
######################## Add OrgC ##################################
####################################################################

# Fetch Configuration
export CHANNEL_NAME=mychannel
docker exec -it peer1.orga.example.com sh -c \
"peer channel fetch config config_block.pb -c '$(echo $CHANNEL_NAME)'" && \
docker cp peer1.orga.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer/config_block.pb \
./docker-compose/channel/orgc/

./docker-compose/bin/configtxgen \
-configPath ./docker-compose/channel/orgc \
-printOrg OrgCMSP > ./docker-compose/channel/orgc/orgc.json


# Windows
./docker-compose/bin/configtxlator proto_decode \
--input=./docker-compose/channel/orgc/config_block.pb --type common.Block \
--output=./docker-compose/channel/orgc/config_block.json
cat ./docker-compose/channel/orgc/config_block.json | \
./jq/jq-win64 .data.data[0].payload.data.config > ./docker-compose/channel/orgc/config_block.json

./jq/jq-win64 -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"OrgCMSP":.[1]}}}}}' \
./docker-compose/channel/orgc/config_block.json \
./docker-compose/channel/orgc/orgc.json > ./docker-compose/channel/orgc/modified_config.json

./docker-compose/bin/configtxlator proto_encode \
--input=./docker-compose/channel/orgc/config_block.json --type common.Config \
--output=./docker-compose/channel/orgc/config.pb

./docker-compose/bin/configtxlator proto_encode \
--input=./docker-compose/channel/orgc/modified_config.json --type common.Config \
--output=./docker-compose/channel/orgc/modified_config.pb

./docker-compose/bin/configtxlator compute_update \
--channel_id=$CHANNEL_NAME \
--original=./docker-compose/channel/orgc/config.pb \
--updated=./docker-compose/channel/orgc/modified_config.pb \
--output=./docker-compose/channel/orgc/config_update.pb

./docker-compose/bin/configtxlator proto_decode \
--input=./docker-compose/channel/orgc/config_update.pb --type common.ConfigUpdate \
--output=./docker-compose/channel/orgc/config_update.json

echo '{"payload":{"header":{"channel_header":{"channel_id":"'$(echo $CHANNEL_NAME)'", "type":2}},"data":{"config_update":'$(cat ./docker-compose/channel/orgc/config_update.json)'}}}' | \
./jq/jq-win64 . > ./docker-compose/channel/orgc/add_orgc.json

./docker-compose/bin/configtxlator proto_encode \
--input=./docker-compose/channel/orgc/add_orgc.json --type common.Envelope \
--output=./docker-compose/channel/orgc/add_orgc.pb


# Linux
./docker-compose/bin/configtxlator proto_decode \
--input=./docker-compose/channel/orgc/config_block.pb --type common.Block \
--output=./docker-compose/channel/orgc/config_block.json

./jq/jq-linux64 .data.data[0].payload.data.config \
./docker-compose/channel/orgc/config_block.json > \
./docker-compose/channel/orgc/config_block.json

./jq/jq-linux64 -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"OrgCMSP":.[1]}}}}}' \
./docker-compose/channel/orgc/config_block.json \
./docker-compose/channel/orgc/orgc.json > ./docker-compose/channel/orgc/modified_config.json

./docker-compose/bin/configtxlator proto_encode \
 --input=./docker-compose/channel/orgc/config_block.json --type common.Config \
 --output=./docker-compose/channel/orgc/config.pb

 ./docker-compose/bin/configtxlator proto_encode \
 --input=./docker-compose/channel/orgc/modified_config.json --type common.Config \
 --output=./docker-compose/channel/orgc/modified_config.pb

./docker-compose/bin/configtxlator compute_update \
--channel_id=$CHANNEL_NAME \
--original=./docker-compose/channel/orgc/config.pb \
--updated=./docker-compose/channel/orgc/modified_config.pb \
--output=./docker-compose/channel/orgc/config_update.pb

./docker-compose/bin/configtxlator proto_decode \
--input=./docker-compose/channel/orgc/config_update.pb --type common.ConfigUpdate \
--output=./docker-compose/channel/orgc/config_update.json

echo '{"payload":{"header":{"channel_header":{"channel_id":"'$(echo $CHANNEL_NAME)'", "type":2}},"data":{"config_update":'$(cat ./docker-compose/channel/orgc/config_update.json)'}}}' | \
./jq/jq-linux64 . > ./docker-compose/channel/orgc/add_orgc.json

./docker-compose/bin/configtxlator proto_encode \
--input=./docker-compose/channel/orgc/add_orgc.json --type common.Envelope \
--output=./docker-compose/channel/orgc/add_orgc.pb

#############################
##### SignConfiguration #####
#############################
docker cp ./docker-compose/channel/orgc/add_orgc.pb \
peer1.orgb.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer/

docker exec -it peer1.orgb.example.com sh -c \
"peer channel signconfigtx -f add_orgc.pb"

docker cp peer1.orgb.example.com:/opt/gopath/src/github.com/hyperledger/fabric/peer/add_orgc.pb \
./docker-compose/channel/orgc/


# Update Channel
curl -s -X PUT \
    http://localhost:4000/channels/mychannel \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
	    "channelConfigPath": 
    }'

# Start orgc
docker-compose -f docker-compose/docker-compose-orgc.yaml up -d

export TokenOrgC=$( curl -s -X POST http://localhost:4000/reg \
-H "content-type: application/json" \
-d '{"username": "Charlie", "orgName": "OrgC"}' | \
./jq/jq-win64 .token | sed -e 's/^"//' -e 's/"$//')
echo "TokenOrgC = $TokenOrgC"

curl -s -X POST \
    http://localhost:4000/joinchannels/mychannel \
    -H "authorization: Bearer $TokenOrgC" \
    -H "content-type: application/json" \
    -d '{
	    "targets": ["peer1.orgc.example.com"]
    }'

curl -s -X POST \
    http://localhost:4000/installchaincodes/cc \
    -H "authorization: Bearer $TokenOrgC" \
    -H "content-type: application/json" \
    -d '{
        "targets": ["peer1.orgc.example.com"],
        "chaincodePath":"cc-whatever/private",
        "chaincodeType": "golang",
        "chaincodeVersion":"v1"
    }'

curl -s -X GET \
    http://localhost:4000/channels/mychannel/chaincodes/cc \
    -H "authorization: Bearer $TokenOrgC" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "read",
        "args": ["Alice"]
    }'  

curl -s -X POST \
    http://localhost:4000/channels/mychannel/chaincodes/cc \
    -H "authorization: Bearer $TokenOrgC" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "create",
        "args": ["Charlie", "id", "789", "email", "charlie@email.com", "username", "Charlie777"]
    }'

curl -s -X GET \
    http://localhost:4000/channels/mychannel/chaincodes/cc \
    -H "authorization: Bearer $TokenOrgC" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "read",
        "args": ["Charlie"]
    }'  


# Delete file when Update Channel complete
rm -f ./docker-compose/channel/orgc/*.json ./docker-compose/channel/orgc/*.pb 
