testSystem() {

    export username='Alice'
    export orgName='OrgA'
    registerMemberOfOrg
    printf "\n"

    export username='Bob'
    export orgName='OrgB'
    registerMemberOfOrg
    printf "\n"

    export username='Carol'
    export orgName='OrgC'
    registerMemberOfOrg
    printf "\n"

    export channelName='channel'
    export chaincodeId='cc'
    export fcn='create'
    export args='"Alice", "id", "123", "email", "alice@email.com", "username", "Alice007"'
    export Token=$TokenOrgA
    invokeChaincode
    sleep 3
    printf "\n\n#########################################\n"

    export channelName='channel'
    export chaincodeId='cc'
    export fcn='read'
    export args='Alice'
    export Token=$TokenOrgA
    queryChaincode
    printf "\n\n#########################################\n"

    export channelName='channel'
    export chaincodeId='cc'
    export fcn='read'
    export args='Alice'
    export Token=$TokenOrgB
    queryChaincode
    printf "\n\n#########################################\n"

    export channelName='channel'
    export chaincodeId='cc'
    export fcn='read'
    export args='Alice'
    export Token=$TokenOrgC
    queryChaincode
    printf "\n\n#########################################\n"

    export channelName='channel'
    export chaincodeId='cc'
    export fcn='create'
    export args='"Bob", "id", "456", "email", "bob@email.com", "username", "Bobby"'
    export Token=$TokenOrgB
    invokeChaincode
    sleep 3
    printf "\n\n#########################################\n"

    export channelName='channel'
    export chaincodeId='cc'
    export fcn='read'
    export args='Bob'
    export Token=$TokenOrgA
    queryChaincode
    printf "\n\n#########################################\n"

    export channelName='channel'
    export chaincodeId='cc'
    export fcn='read'
    export args='Bob'
    export Token=$TokenOrgB
    queryChaincode
    printf "\n\n#########################################\n"

    export channelName='channel'
    export chaincodeId='cc'
    export fcn='read'
    export args='Bob'
    export Token=$TokenOrgC
    queryChaincode
    printf "\n\n#########################################\n"

    export channelName='channel'
    export chaincodeId='cc'
    export fcn='create'
    export args='"Carol", "id", "789", "email", "carol@email.com", "username", "Caroline"'
    export Token=$TokenOrgC
    invokeChaincode
    sleep 3
    printf "\n\n#########################################\n"

    export channelName='channel'
    export chaincodeId='cc'
    export fcn='read'
    export args='Carol'
    export Token=$TokenOrgA
    queryChaincode
    printf "\n\n#########################################\n"

    export channelName='channel'
    export chaincodeId='cc'
    export fcn='read'
    export args='Carol'
    export Token=$TokenOrgB
    queryChaincode
    printf "\n\n#########################################\n"

    export channelName='channel'
    export chaincodeId='cc'
    export fcn='read'
    export args='Carol'
    export Token=$TokenOrgC
    queryChaincode
    printf "\n\n#########################################\n"

    export chaincodeId='cc'
    export targetPeer='"peer1.orga.example.com", "peer2.orga.example.com"'
    export chaincodePath='cc-whatever/private'
    export chaincodeType='golang'
    export chaincodeVersion='v1'
    export Token=$TokenOrgA
    installChaincode
    printf "\n\n#########################################\n"
    
    export chaincodeId='cc'
    export targetPeer='"peer1.orgb.example.com", "peer2.orgb.example.com"'
    export chaincodePath='cc-whatever/private'
    export chaincodeType='golang'
    export chaincodeVersion='v1'
    export Token=$TokenOrgB
    installChaincode
    printf "\n\n#########################################\n"

    export chaincodeId='cc'
    export targetPeer='"peer1.orgc.example.com", "peer2.orgc.example.com"'
    export chaincodePath='cc-whatever/private'
    export chaincodeType='golang'
    export chaincodeVersion='v1'
    export Token=$TokenOrgC
    installChaincode
    printf "\n\n#########################################\n"

    export channelName='channel'
    export chaincodeId='cc'
    export chaincodeVersion='v1'
    export chaincodeType='golang'
    export endorsementPolicy='./config/policy4.json'
    export Token=$TokenOrgA
    export collectionsConfig='./src/cc-whatever/private/config/collections_config1.json'
    upgradeChaincode
    sleep 3
    printf "\n\n#########################################\n"

    export channelName='channel-0'
    export chaincodeId='cc'
    export chaincodeVersion='v1'
    export chaincodeType='golang'
    export endorsementPolicy='./config/policy4.json'
    export Token=$TokenOrgB
    export collectionsConfig='./src/cc-whatever/private/config/collections_config1.json'
    upgradeChaincode
    sleep 3
    printf "\n\n#########################################\n"

    export channelName='channel-1'
    export chaincodeId='cc'
    export chaincodeVersion='v1'
    export chaincodeType='golang'
    export endorsementPolicy='./config/policy4.json'
    export Token=$TokenOrgC
    export collectionsConfig='./src/cc-whatever/private/config/collections_config1.json'
    upgradeChaincode
    sleep 3
    printf "\n\n#########################################\n"

    export channelName='channel'
    export chaincodeId='cc'
    export fcn='createprivate'
    export args='"Alice", "status", "Private", "email", "alice@private.com"'
    export Token=$TokenOrgA
    invokeChaincode
    sleep 3
    printf "\n\n#########################################\n"

    export channelName='channel'
    export chaincodeId='cc'
    export fcn='readprivate'
    export args='Alice'
    export Token=$TokenOrgA
    queryChaincode
    printf "\n\n#########################################\n"

    export channelName='channel'
    export chaincodeId='cc'
    export fcn='readprivate'
    export args='Alice'
    export Token=$TokenOrgB
    queryChaincode
    printf "\n\n#########################################\n"

    export channelName='channel'
    export chaincodeId='cc'
    export fcn='readprivate'
    export args='Alice'
    export Token=$TokenOrgC
    queryChaincode
    printf "\n\n#########################################\n"

    export channelName='channel'
    export chaincodeId='cc'
    export fcn='createsuperprivate'
    export args='"Alice", "status", "SuperPrivate", "email", "alice@superprivate.com"'
    export Token=$TokenOrgA
    invokeChaincode
    sleep 3
    printf "\n\n#########################################\n"

    export channelName='channel'
    export chaincodeId='cc'
    export fcn='readsuperprivate'
    export args='Alice'
    export Token=$TokenOrgA
    queryChaincode
    printf "\n\n#########################################\n"

    export channelName='channel'
    export chaincodeId='cc'
    export fcn='readsuperprivate'
    export args='Alice'
    export Token=$TokenOrgB
    queryChaincode
    printf "\n\n#########################################\n"

    export channelName='channel'
    export chaincodeId='cc'
    export fcn='readsuperprivate'
    export args='Alice'
    export Token=$TokenOrgC
    queryChaincode
    printf "\n\n#########################################\n"

}
