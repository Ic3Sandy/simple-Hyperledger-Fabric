package main

import (
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)

func (t *WhateverChaincode) deleteState(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error(`Incorect format of arguments. Example {"Args" : ["delete", "Alice"]}`)
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

	err = stub.DelState(args[0])
	if err != nil {
		return shim.Error("Failed to delete state")
	}

	fmt.Println("[Success Delete]")
	return shim.Success(nil)

}

func (t *WhateverChaincode) deleteStatePrivate(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error(`Incorect format of arguments. Example {"Args" : ["deleteprivate", "Alice"]}`)
	}

	return deletePrivate(stub, args, "collectionPrivate")

}

func (t *WhateverChaincode) deleteStateSuperPrivate(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error(`Incorect format of arguments. Example {"Args" : ["deletesuperprivate", "Alice"]}`)
	}

	return deletePrivate(stub, args, "collectionSuperPrivate")

}

func deletePrivate(stub shim.ChaincodeStubInterface, args []string, collection string) peer.Response {

	statePrivateBytes, err := stub.GetPrivateData(collection, args[0])
	if err != nil {
		return shim.Error("Failed to get state: " + err.Error())
	} else if statePrivateBytes == nil {
		return shim.Error("This state doesn't exists: " + args[0])
	}

	err = stub.DelPrivateData(collection, args[0]) //remove the marble from chaincode state
	if err != nil {
		return shim.Error("Failed to delete state:" + err.Error())
	}

	return shim.Success(nil)

}

