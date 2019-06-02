installPackage() {

    echo "Install package.json"
    docker-compose -f api/docker-compose-server.yaml up -d
    docker exec -it server sh -c "npm install"
    docker exec -it server sh -c "npm rebuild"
    docker exec -it server sh -c "npm install"

}

pullImages() {

    echo "Pull images docker"
    docker pull hyperledger/fabric-baseos
    docker pull hyperledger/fabric-ccenv
    docker pull hyperledger/fabric-peer
    docker pull hyperledger/fabric-orderer
    docker pull hyperledger/fabric-ca

}
