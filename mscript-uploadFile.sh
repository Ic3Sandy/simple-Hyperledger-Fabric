
#Create config file Genesis block
./docker-compose/bin/configtxgen \
-configPath ./docker-compose/channel/ \
-profile TwoOrgsOrdererGenesis \
-outputBlock ./docker-compose/channel/genesis.block

#Create config file channel
export CHANNEL_NAME=mychannel
./docker-compose/bin/configtxgen \
-configPath ./docker-compose/channel/ \
-profile TwoOrgsChannel \
-outputCreateChannelTx ./docker-compose/channel/mychannel.tx \
-channelID $CHANNEL_NAME 

export CHANNEL_NAME=mychannel1
./docker-compose/bin/configtxgen \
-configPath ./docker-compose/channel/ \
-profile TwoOrgsChannel \
-outputCreateChannelTx ./docker-compose/channel/mychannel1.tx \
-channelID $CHANNEL_NAME 

export CHANNEL_NAME=mychannel2
./docker-compose/bin/configtxgen \
-configPath ./docker-compose/channel/ \
-profile TwoOrgsChannel \
-outputCreateChannelTx ./docker-compose/channel/mychannel2.tx \
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


# Create channel
curl -s -X POST \
    http://localhost:4000/channels/mychannel \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
	    "channelConfigPath":"../channel/mychannel.tx"
    }'

curl -s -X POST \
    http://localhost:4000/channels/mychannel1 \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
	    "channelConfigPath":"../channel/mychannel1.tx"
    }'

curl -s -X POST \
    http://localhost:4000/channels/mychannel2 \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
	    "channelConfigPath":"../channel/mychannel2.tx"
    }'


# Join channel
curl -s -X POST \
    http://localhost:4000/joinchannels/mychannel \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
	    "targets": ["peer1.orga.example.com"]
    }'

curl -s -X POST \
    http://localhost:4000/joinchannels/mychannel \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
	    "targets": ["peer1.orgb.example.com"]
    }'


curl -s -X POST \
    http://localhost:4000/joinchannels/mychannel1 \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
	    "targets": ["peer1.orga.example.com"]
    }'

curl -s -X POST \
    http://localhost:4000/joinchannels/mychannel1 \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
	    "targets": ["peer1.orgb.example.com"]
    }'

curl -s -X POST \
    http://localhost:4000/joinchannels/mychannel2 \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
	    "targets": ["peer2.orga.example.com"]
    }'

curl -s -X POST \
    http://localhost:4000/joinchannels/mychannel2 \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
	    "targets": ["peer2.orgb.example.com"]
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


# Instantiate chaincode
curl -s -X POST \
    http://localhost:4000/channels/mychannel/instantiate \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "chaincodeId":"cc",
        "chaincodeVersion":"v0",
        "chaincodeType": "golang",
        "endorsementPolicy": "./config/policy2.json"
    }'

curl -s -X POST \
    http://localhost:4000/channels/mychannel1/instantiate \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "chaincodeId":"cc",
        "chaincodeVersion":"v0",
        "chaincodeType": "golang",
        "endorsementPolicy": "./config/policy2.json"
    }'

curl -s -X POST \
    http://localhost:4000/channels/mychannel2/instantiate \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
        "chaincodeId":"cc",
        "chaincodeVersion":"v0",
        "chaincodeType": "golang",
        "endorsementPolicy": "./config/policy2.json"
    }'


# Invoke request
curl -s -X POST \
    http://localhost:4000/channels/mychannel/chaincodes/cc \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "create",
        "args": ["Alice", "id", "123", "email", "alice@email.com", "username", "Alice007"]
    }'

# Query chaincode
curl -s -X GET \
    http://localhost:4000/channels/mychannel1/chaincodes/cc \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "targets": ["peer1.orga.example.com"],
        "fcn": "read",
        "args": ["Alice"]
    }'  

# Query chaincode by transaction
curl -s -X GET \
    http://localhost:4000/channels/mychannel/transactions \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "targets": ["peer1.orga.example.com"],
        "tx_id": "7516904abc1de8f61581313fdffff0897bd3304e3a991f091e5a07351bd130f2"
    }'

# Query chaincode by blocknumber
curl -s -X GET \
    http://localhost:4000/channels/mychannel/blocknumber \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "targets": ["peer1.orga.example.com"],
        "blockNumber": 2
    }'

# Install chaincode new version
curl -s -X POST \
    http://localhost:4000/installchaincodes/cc \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "targets": ["peer1.orga.example.com"],
        "chaincodePath":"cc-whatever/private",
        "chaincodeType": "golang",
        "chaincodeVersion":"v1"
    }'

curl -s -X POST \
    http://localhost:4000/installchaincodes/cc \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
        "targets": ["peer1.orgb.example.com"],
        "chaincodePath":"cc-whatever/private",
        "chaincodeType": "golang",
        "chaincodeVersion":"v1"
    }'


# Instantiate chaincode new version
curl -s -X PUT \
    http://localhost:4000/channels/channel/instantiate \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "chaincodeId":"cc",
        "chaincodeVersion":"v1",
        "chaincodeType": "golang",
        "endorsementPolicy": "./config/policy3.json",
        "collections-config": "./src/cc-whatever/private/config/collections_config1.json"
    }'

# Invoke create Alice private
curl -s -X POST \
    http://localhost:4000/channels/mychannel/chaincodes/cc \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "createprivate",
	    "args": ["Alice", "status", "private"]
    }'

# Query Alice private
curl -s -X GET \
    http://localhost:4000/channels/mychannel/chaincodes/cc \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "readprivate",
        "args": ["Alice"]
    }'  

curl -s -X GET \
    http://localhost:4000/channels/mychannel/chaincodes/cc \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "readprivate",
        "args": ["Alice"]
    }'  

# Invoke create Alice super private
curl -s -X POST \
    http://localhost:4000/channels/mychannel/chaincodes/cc \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "createsuperprivate",
	    "args": ["Alice", "status", "SuperPrivate"]
    }'

# Query Alice Super private
curl -s -X GET \
    http://localhost:4000/channels/mychannel/chaincodes/cc \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "readsuperprivate",
        "args": ["Alice"]
    }'  

curl -s -X GET \
    http://localhost:4000/channels/mychannel/chaincodes/cc \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "readsuperprivate",
        "args": ["Bob"]
    }'  

###################################################################
#######################  File   ###################################
###################################################################

docker restart server
docker exec -it server bash
npm start

# Start Command for connect API (linux)
export TokenOrgA=$( curl -s -X POST http://localhost:4000/reg \
-H "content-type: application/json" \
-d '{"username": "Alice", "orgName": "OrgA"}' | \
./jq/jq-linux64 .token | sed -e 's/^"//' -e 's/"$//')
echo "TokenOrgA = $TokenOrgA"

export TokenOrgB=$( curl -s -X POST http://localhost:4000/reg \
-H "content-type: application/json" \
-d '{"username": "Bob2", "orgName": "OrgB"}' | \
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


# Upload file
curl -s -X POST \
    http://localhost:4000/channels/mychannel/chaincodes/cc/file \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "post",
        "args": ["test3.MOV", "./fileUpload/test3.MOV"]
    }' 

# Download file
curl -s -X GET \
    http://localhost:4000/channels/mychannel/chaincodes/cc/file \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "get",
        "args": ["test3.MOV", "./fileDownload/test3.MOV"]
    }' 

# Update file
curl -s -X PUT \
    http://localhost:4000/channels/mychannel/chaincodes/cc/file \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "put",
        "args": ["test3.MOV", "./fileUpload/test3.MOV"]
    }' 

# Delete file
curl -s -X DELETE \
    http://localhost:4000/channels/mychannel/chaincodes/cc/file \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "del",
        "args": ["test3.MOV"]
    }' 
