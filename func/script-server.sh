serverUp() {

    docker-compose -f api/docker-compose-server.yaml up -d
    echo "Start API Server"
    # docker exec -itd server sh -c "npm start"
    # sleep 3
    chmod o+w api/fileUpload
    chmod o+w api/fileDownload
    docker exec -it server sh -c "npm start"

}

serverDown() {

    docker-compose -f api/docker-compose-server.yaml down -v
    echo "Down API Server"

    rm -rf api/fabric-client-kv-org*
    printf "Delete file fabric-client-kv-org*\n"

}