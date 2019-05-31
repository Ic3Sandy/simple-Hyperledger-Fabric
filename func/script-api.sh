createChannel() {

    echo ""
    echo "Create Channel \"$channelName\""
    echo "Path File: \"$pathFile\""

    curl -s -X POST \
    http://localhost:4000/channels/$channelName \
    -H "authorization: Bearer $Token" \
    -H "content-type: application/json" \
    -d '{
	    "channelConfigPath": "'"$pathFile"'"
    }'

}

joinChannel() {

    echo ""
    echo "Join Channel $channelName for $targetPeer"

    curl -s -X POST \
    http://localhost:4000/joinchannels/$channelName \
    -H "authorization: Bearer $Token" \
    -H "content-type: application/json" \
    -d '{
	    "targets": ['"$targetPeer"']
    }'

}

installChaincode() {

    echo ""
    echo "Install Chaincode for $targetPeer"

    curl -s -X POST \
    http://localhost:4000/installchaincodes/$chaincodeId \
    -H "authorization: Bearer $Token" \
    -H "content-type: application/json" \
    -d '{
        "targets": ['"$targetPeer"'],
        "chaincodePath": "'"$chaincodePath"'",
        "chaincodeType": "'"$chaincodeType"'",
        "chaincodeVersion": "'"$chaincodeVersion"'"
    }'

}

instantiateChaincode() {

    echo ""
    echo "Instantiate Chaincode for Channel $channelName"

    curl -s -X POST \
    http://localhost:4000/channels/$channelName/instantiate \
    -H "authorization: Bearer $Token" \
    -H "content-type: application/json" \
    -d '{
        "chaincodeId": "'"$chaincodeId"'",
        "chaincodeVersion": "'"$chaincodeVersion"'",
        "chaincodeType": "'"$chaincodeType"'",
        "endorsementPolicy": "'"$endorsementPolicy"'",
        "collections-config": "'"$collectionsConfig"'"
    }'

}

upgradeChaincode() {

    echo ""
    echo "Upgrade Chaincode for Channel $channelName"

    curl -s -X PUT \
    http://localhost:4000/channels/$channelName/instantiate \
    -H "authorization: Bearer $Token" \
    -H "content-type: application/json" \
    -d '{
        "chaincodeId": "'"$chaincodeId"'",
        "chaincodeVersion": "'"$chaincodeVersion"'",
        "chaincodeType": "'"$chaincodeType"'",
        "endorsementPolicy": "'"$endorsementPolicy"'",
        "collections-config": "'"$collectionsConfig"'"
    }'

}

invokeChaincode() {

    echo ""
    echo "Invoke Chaincode for $fcn"

    curl -s -X POST \
    http://localhost:4000/channels/$channelName/chaincodes/$chaincodeId \
    -H "authorization: Bearer $Token" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "'"$fcn"'",
        "args": ['"$args"']
    }'

}

queryChaincode() {

    echo ""
    echo "Query Chaincode for $args"

    curl -s -X GET \
    http://localhost:4000/channels/$channelName/chaincodes/$chaincodeId \
    -H "authorization: Bearer $Token" \
    -H "content-type: application/json" \
    -d '{
        "fcn": "'"$fcn"'",
        "args": ["'"$args"'"]
    }'  

}

queryBlock() {

    channelName=$1
    targets=$2
    blockNumber=$3
    Token=$4
    echo ""
    echo "Query blockNumber of $blockNumber"

    curl -s -X GET \
    http://localhost:4000/channels/$channelName/blocknumber \
    -H "authorization: Bearer $Token" \
    -H "content-type: application/json" \
    -d '{
        "targets": ['"$targets"'],
        "blockNumber": '"$blockNumber"'
    }'

}

updateChannel() {

    channelName=$1
    channelConfigPath=$2
    Token=$3

    curl -s -X PUT \
    http://localhost:4000/channels/$channelName \
    -H "authorization: Bearer $Token" \
    -H "content-type: application/json" \
    -d '{
	    "channelConfigPath": '"$channelConfigPath"'
    }'

}