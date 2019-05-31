startSystem() {

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
    export pathFile='../channel/channel.tx'
    export Token=$TokenOrgA
    createChannel
    sleep 3
    printf "\n\n#########################################\n"

    export channelName='channel-0'
    export pathFile='../channel/channel-0.tx'
    export Token=$TokenOrgB
    createChannel
    sleep 3
    printf "\n\n#########################################\n"

    export channelName='channel-1'
    export pathFile='../channel/channel-1.tx'
    export Token=$TokenOrgC
    createChannel
    sleep 3
    printf "\n\n#########################################\n"

    export channelName='channel'
    export targetPeer='"peer1.orga.example.com"'
    export Token=$TokenOrgA
    joinChannel
    printf "\n\n#########################################\n"

    export channelName='channel'
    export targetPeer='"peer1.orgb.example.com"'
    export Token=$TokenOrgB
    joinChannel
    printf "\n\n#########################################\n"

    export channelName='channel'
    export targetPeer='"peer1.orgc.example.com"'
    export Token=$TokenOrgC
    joinChannel
    printf "\n\n#########################################\n"

    export channelName='channel-0'
    export targetPeer='"peer1.orga.example.com"'
    export Token=$TokenOrgA
    joinChannel
    printf "\n\n#########################################\n"

    export channelName='channel-0'
    export targetPeer='"peer1.orgb.example.com"'
    export Token=$TokenOrgB
    joinChannel
    printf "\n\n#########################################\n"

    export channelName='channel-0'
    export targetPeer='"peer1.orgc.example.com"'
    export Token=$TokenOrgC
    joinChannel
    printf "\n\n#########################################\n"

    export channelName='channel-1'
    export targetPeer='"peer2.orga.example.com"'
    export Token=$TokenOrgA
    joinChannel
    printf "\n\n#########################################\n"

    export channelName='channel-1'
    export targetPeer='"peer2.orgb.example.com"'
    export Token=$TokenOrgB
    joinChannel
    printf "\n\n#########################################\n"

    export channelName='channel-1'
    export targetPeer='"peer2.orgc.example.com"'
    export Token=$TokenOrgC
    joinChannel
    printf "\n\n#########################################\n"

    export chaincodeId='cc'
    export targetPeer='"peer1.orga.example.com", "peer2.orga.example.com"'
    export chaincodePath='cc-whatever/public'
    export chaincodeType='golang'
    export chaincodeVersion='v0'
    export Token=$TokenOrgA
    installChaincode
    printf "\n\n#########################################\n"
    
    export chaincodeId='cc'
    export targetPeer='"peer1.orgb.example.com", "peer2.orgb.example.com"'
    export chaincodePath='cc-whatever/public'
    export chaincodeType='golang'
    export chaincodeVersion='v0'
    export Token=$TokenOrgB
    installChaincode
    printf "\n\n#########################################\n"

    export chaincodeId='cc'
    export targetPeer='"peer1.orgc.example.com", "peer2.orgc.example.com"'
    export chaincodePath='cc-whatever/public'
    export chaincodeType='golang'
    export chaincodeVersion='v0'
    export Token=$TokenOrgC
    installChaincode
    printf "\n\n#########################################\n"

    export channelName='channel'
    export chaincodeId='cc'
    export chaincodeVersion='v0' 
    export chaincodeType='golang' 
    export endorsementPolicy='./config/policy4.json'
    export Token=$TokenOrgA
    instantiateChaincode
    sleep 3
    printf "\n\n#########################################\n"

    export channelName='channel-0'
    export chaincodeId='cc'
    export chaincodeVersion='v0' 
    export chaincodeType='golang' 
    export endorsementPolicy='./config/policy4.json'
    export Token=$TokenOrgB
    instantiateChaincode
    sleep 3
    printf "\n\n#########################################\n"

    export channelName='channel-1'
    export chaincodeId='cc'
    export chaincodeVersion='v0' 
    export chaincodeType='golang' 
    export endorsementPolicy='./config/policy4.json'
    export Token=$TokenOrgC
    instantiateChaincode
    sleep 3
    printf "\n\n#########################################\n"

}
