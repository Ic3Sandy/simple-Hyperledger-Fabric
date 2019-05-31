registerMemberOfOrg() {
    
    if [ $host == 'ubuntu' ]
    then
        jq='linux64'

    elif [ $host == 'win' ]
    then
        jq='win64'
    
    else
        echo "Chose win or ubuntu"
        exit 1
    fi

    if [ $orgName == 'OrgA' ]
    then

        export TokenOrgA=$( \
            curl -s -X POST http://localhost:4000/reg \
            -H "content-type: application/json" \
            -d '{"username": "'"$username"'", "orgName": "OrgA"}' | \
            ./jq/jq-$jq .token | sed -e 's/^"//' -e 's/"$//' \
        )
        printf "export TokenOrgA=$TokenOrgA\n"

    elif [ $orgName == 'OrgB' ]
    then

        export TokenOrgB=$( \
            curl -s -X POST http://localhost:4000/reg \
            -H "content-type: application/json" \
            -d '{"username": "'"$username"'", "orgName": "OrgB"}' | \
            ./jq/jq-$jq .token | sed -e 's/^"//' -e 's/"$//' \
        )
        printf "export TokenOrgB=$TokenOrgB\n"

    elif [ $orgName == 'OrgC' ]
    then

        export TokenOrgC=$( \
            curl -s -X POST http://localhost:4000/reg \
            -H "content-type: application/json" \
            -d '{"username": "'"$username"'", "orgName": "OrgC"}' | \
            ./jq/jq-$jq .token | sed -e 's/^"//' -e 's/"$//' \
        )
        printf "export TokenOrgC=$TokenOrgC\n"

    fi

}