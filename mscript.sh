
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

# Create channel-0
curl -s -X POST \
    http://localhost:4000/channels/channel-0 \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
	    "channelConfigPath":"../channel/channel-0.tx"
    }'

# Create channel-1
curl -s -X POST \
    http://localhost:4000/channels/channel-1 \
    -H "authorization: Bearer $TokenOrgC" \
    -H "content-type: application/json" \
    -d '{
	    "channelConfigPath":"../channel/channel-1.tx"
    }'

# Join channel
curl -s -X POST \
    http://localhost:4000/joinchannels/channel \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
	    "targets": ["peer1.orga.example.com"]
    }'

curl -s -X POST \
    http://localhost:4000/joinchannels/channel \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
	    "targets": ["peer1.orgb.example.com"]
    }'

curl -s -X POST \
    http://localhost:4000/joinchannels/channel \
    -H "authorization: Bearer $TokenOrgC" \
    -H "content-type: application/json" \
    -d '{
	    "targets": ["peer1.orgc.example.com"]
    }'


# Join channel-0
curl -s -X POST \
    http://localhost:4000/joinchannels/channel-0 \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
	    "targets": ["peer1.orga.example.com"]
    }'

curl -s -X POST \
    http://localhost:4000/joinchannels/channel-0 \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
	    "targets": ["peer1.orgb.example.com"]
    }'

curl -s -X POST \
    http://localhost:4000/joinchannels/channel-0 \
    -H "authorization: Bearer $TokenOrgC" \
    -H "content-type: application/json" \
    -d '{
	    "targets": ["peer1.orgc.example.com"]
    }'


# Join channel-1
curl -s -X POST \
    http://localhost:4000/joinchannels/channel-1 \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
	    "targets": ["peer2.orga.example.com"]
    }'

curl -s -X POST \
    http://localhost:4000/joinchannels/channel-1 \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
	    "targets": ["peer2.orgb.example.com"]
    }'

curl -s -X POST \
    http://localhost:4000/joinchannels/channel-1 \
    -H "authorization: Bearer $TokenOrgC" \
    -H "content-type: application/json" \
    -d '{
	    "targets": ["peer2.orgc.example.com"]
    }'

# Install chaincode
curl -s -X POST \
    http://localhost:4000/installchaincodes/cc \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "targets": ["peer1.orga.example.com", "peer2.orga.example.com"],
        "chaincodePath":"cc-whatever/public",
        "chaincodeType": "golang",
        "chaincodeVersion":"v0"
    }'

curl -s -X POST \
    http://localhost:4000/installchaincodes/cc \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
        "targets": ["peer1.orgb.example.com", "peer2.orgb.example.com"],
        "chaincodePath":"cc-whatever/public",
        "chaincodeType": "golang",
        "chaincodeVersion":"v0"
    }'

curl -s -X POST \
    http://localhost:4000/installchaincodes/cc \
    -H "authorization: Bearer $TokenOrgC" \
    -H "content-type: application/json" \
    -d '{
        "targets": ["peer1.orgc.example.com", "peer2.orgc.example.com"],
        "chaincodePath":"cc-whatever/public",
        "chaincodeType": "golang",
        "chaincodeVersion":"v0"
    }'


# Instantiate chaincode at channel
curl -s -X POST \
    http://localhost:4000/channels/channel/instantiate \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "chaincodeId":"cc",
        "chaincodeVersion":"v0",
        "chaincodeType": "golang",
        "args":[],
        "endorsementPolicy": "./config/policy4.json"
    }'

# Instantiate chaincode at channel-0
curl -s -X POST \
    http://localhost:4000/channels/channel-0/instantiate \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
        "chaincodeId":"cc",
        "chaincodeVersion":"v0",
        "chaincodeType": "golang",
        "args":[],
        "endorsementPolicy": "./config/policy4.json"
    }'

# Instantiate chaincode at channel-1
curl -s -X POST \
    http://localhost:4000/channels/channel-1/instantiate \
    -H "authorization: Bearer $TokenOrgC" \
    -H "content-type: application/json" \
    -d '{
        "chaincodeId":"cc",
        "chaincodeVersion":"v0",
        "chaincodeType": "golang",
        "args":[],
        "endorsementPolicy": "./config/policy4.json"
    }'


docker exec -it server bash
npm start


# Upload file
curl -s -X POST \
    http://localhost:4000/channels/channel/chaincodes/cc/file \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "postsuperprivate",
        "args": ["demo.mkv", "./fileUpload/demo.mkv"]
    }' 

# Download file
curl -s -X GET \
    http://localhost:4000/channels/channel/chaincodes/cc/file \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "getprivate",
        "args": ["demo.mkv", "./fileDownload/demo.mkv"]
    }' 



# Invoke request
curl -s -X POST \
    http://localhost:4000/channels/channel/chaincodes/cc \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "create",
        "args": ["Alice", "id", "123", "email", "alice@email.com", "username", "Alicezaa"]
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


# Query chaincode
curl -s -X GET \
    http://localhost:4000/channels/channel-1/chaincodes/cc \
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "readprivate",
        "args": ["demo.mkv_3"]
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
    -H "authorization: Bearer $TokenOrgB" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "readsuperprivate",
        "args": ["Alice"]
    }'  


# Query chaincode by transaction
curl -s -X GET \
    http://localhost:4000/channels/channel/transactions \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "targets": ["peer1.orga.example.com"],
        "tx_id": "373b9fa4b5b03235faf74ec1eda7c1ef180f084e966047b0c80a70635a218d86"
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

# Upload binary 
curl -s -X POST \
    http://localhost:4000/channels/channel/chaincodes/cc/binary \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "post",
        "args": ["hex", "4142434445464748494a4b4c"]
    }' 

curl -s -X POST \
    http://localhost:4000/channels/channel/chaincodes/cc/binary \
    -H "authorization: Bearer $TokenOrgA" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "post",
        "args": ["a", "testing"]
    }'
