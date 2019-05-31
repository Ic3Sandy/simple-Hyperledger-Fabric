package main

import (
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)

func (t *WhateverChaincode) getStatePrivate(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error(`Incorect format of arguments. Example {"Args" : ["get", "demo.mkv"]}`)
	}

	return getPrivateData(stub, args, "collectionPrivate")

}

func (t *WhateverChaincode) getStateSuperPrivate(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error(`Incorect format of arguments. Example {"Args" : ["get", "demo.mkv"]}`)
	}

	return getPrivateData(stub, args, "collectionSuperPrivate")

}

func getPrivateData(stub shim.ChaincodeStubInterface, args []string, collection string) peer.Response {

	// Check exist in ledger
	statePrivateBytes, err := stub.GetPrivateData(collection, args[0])
	if err != nil {
		return shim.Error("Failed to get state: " + err.Error())
	} else if statePrivateBytes == nil {
		return shim.Error("This state doesn't exists: " + args[0])
	}

	fmt.Println("[Success Get]", args[0])
	return shim.Success(statePrivateBytes)

}