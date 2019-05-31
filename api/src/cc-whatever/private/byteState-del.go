package main

import (
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)

func (t *WhateverChaincode) delStatePrivate(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error(`Incorect format of arguments.`)
	}

	return delPrivateData(stub, args, "collectionPrivate")

}

func (t *WhateverChaincode) delStateSuperPrivate(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error(`Incorect format of arguments.`)
	}

	return delPrivateData(stub, args, "collectionSuperPrivate")

}

func delPrivateData(stub shim.ChaincodeStubInterface, args []string, collection string) peer.Response {

	// Check exist in ledger
	err := stub.DelPrivateData(collection, args[0])
	if err != nil {
		return shim.Error("Failed to delete state:" + err.Error())
	}

	fmt.Println("[Success Del]", args[0])
	return shim.Success(nil)

}