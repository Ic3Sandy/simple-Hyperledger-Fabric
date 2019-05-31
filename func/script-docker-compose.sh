showDocker() {
    docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
}

startDocker() {

    if [ $node == 'orderer' ] && [ $Orderer == 'solo' ]
    then
        docker-compose -f docker-compose/docker-compose-orderer.yaml up -d
        echo "Start Orderer Solo"

    elif [ $node == 'orderer' ] && [ $Orderer == 'kafka' ]
    then
        docker-compose -f docker-compose/docker-compose-kafka.yaml up -d
        echo "Start Orderer Kafka"
    
    elif [ $node == 'orga' ]
    then
        docker-compose -f docker-compose/docker-compose-orga.yaml up -d
        echo "Start OrgA"
    
    elif [ $node == 'orgb' ]
    then
        docker-compose -f docker-compose/docker-compose-orgb.yaml up -d
        printf "Start OrgB\n"

    elif [ $node == 'orgc' ]
    then
        docker-compose -f docker-compose/docker-compose-orgc.yaml up -d
        printf "Start OrgC\n"

    fi

}

downDocker() {
    
    if [ $node == 'orderer' ] && [ $Orderer == 'solo' ]
    then
        docker-compose -f docker-compose/docker-compose-orderer.yaml down --volumes --remove-orphans
        echo "Down Orderer Solo"
    
    elif [ $node == 'orderer' ] && [ $Orderer == 'kafka' ]
    then
        docker-compose -f docker-compose/docker-compose-kafka.yaml down --volumes --remove-orphans
        echo "Down Orderer Kafka"
    
    elif [ $node == 'orga' ]
    then
        docker-compose -f docker-compose/docker-compose-orga.yaml down --volumes --remove-orphans
        echo "Down OrgA"
    
    elif [ $node == 'orgb' ]
    then
        docker-compose -f docker-compose/docker-compose-orgb.yaml down --volumes --remove-orphans
        echo "Down OrgB"

    elif [ $node == 'orgc' ]
    then
        docker-compose -f docker-compose/docker-compose-orgc.yaml down --volumes --remove-orphans
        echo "Down OrgC"
        rm -f ./docker-compose/channel/orgc/*.json ./docker-compose/channel/orgc/*.pb 

    fi

}

downSystem() {

    containerId=$(docker ps -aq)
    if [ -n "$containerId" ] 
    then
        echo "Delete Container"
        docker rm $(docker ps -aq)
    fi

    imagesChaincode=$(docker images | awk '$1 ~ "dev-*" {print $3;}')
    if [ -n "$imagesChaincode" ] 
    then
        echo "Delete Images Chaincode"
        docker rmi $(docker images | awk '$1 ~ "dev-*" {print $3;}')
    fi

    echo "Remove all unused local volumes"
    echo "y" | docker volume prune

}
