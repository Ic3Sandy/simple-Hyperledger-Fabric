# Simple Hyperledger Fabric

## Sprint5

- [x] Test Orderer Kafka
- [x] Three Org with multiple channel
- [x] Test change api to es6
- [x] Reflector script.sh

## Sprint4

- [x] Test partition data for 5 peer of Org
- [x] Add channel to system
- [x] Change permission for folder fileUpload and fileDownload
- [x] Script pull images (hyperledger/fabric-ccenv, hyperledger/fabric-baseos)
- [x] Modify api for query chaincode in case some peer down

### Sprint3

- [x] Api for private data and script for test private data
- [x] Modify script for install library of server (npm install)
- [x] Add step of add OrgC in hand-script
- [x] Modify script for start each org for test partition vm
- [x] Simple partition data each peer in org
- [x] Add feature QueryTransaction and QueryBlockNumber from chaincode
- [x] Rename path of api for simple read

### Test

- Require docker and docker-compose.

- Run script file script.sh for test system.

- Checkout solo or kafka.

- Step:

  - Linux use `sudo` for run script

  - Change file env.sh for environment of you

  - Setup Server

    1. `./script.sh install` install package for server
    2. `./script.sh pull` pull images docker

  - Start System

    1. `./script.sh up` for start docker
    2. `./script.sh server up` for run server and dubug
    3. `./script.sh start` for create join install and instantiate
    4. `./script.sh test` for test system
    5. `./script.sh down` for down docker and `./script.sh server down` down server
  