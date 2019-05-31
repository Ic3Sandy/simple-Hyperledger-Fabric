package main

import (
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)

func (t *WhateverChaincode) readState(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error(`Incorect format of arguments. Example {"Args" : ["read", "Alice"]}`)
	}

	// Check exist in ledger
	stateBytes, err := stub.GetState(args[0])
	if err != nil {
		jsonResp := `{"Error" : "Failed to get state for ` + args[0] + ` "}`
		return shim.Error(jsonResp)
	}
	if stateBytes == nil {
		jsonResp := `{"Error": "Dosen't exist ` + args[0] + ` in ledger."}`
		return shim.Error(jsonResp)
	}

	fmt.Println("[Success Read]")
	return shim.Success(stateBytes)

}

func (t *WhateverChaincode) readStatePrivate(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error(`Incorect format of arguments. Example {"Args" : ["readprivate", "Alice"]}`)
	}

	statePrivateBytes, err := stub.GetPrivateData("collectionPrivate", args[0])
	if err != nil {
		return shim.Error("Failed to get state: " + err.Error())
	} else if statePrivateBytes == nil {
		return shim.Error("This state doesn't exists: " + args[0])
	}

	return shim.Success(statePrivateBytes)

}

func (t *WhateverChaincode) readStateSuperPrivate(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error(`Incorect format of arguments. Example {"Args" : ["readsuperprivate", "Alice"]}`)
	}

	statePrivateBytes, err := stub.GetPrivateData("collectionSuperPrivate", args[0])
	if err != nil {
		return shim.Error("Failed to get state: " + err.Error())
	} else if statePrivateBytes == nil {
		return shim.Error("This state doesn't exists: " + args[0])
	}

	return shim.Success(statePrivateBytes)

}