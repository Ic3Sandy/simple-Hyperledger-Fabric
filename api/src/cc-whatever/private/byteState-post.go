package main

import (
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)

func (t *WhateverChaincode) postStatePrivate(stub shim.ChaincodeStubInterface, args [][]byte) peer.Response {

	if len(args) != 3 {
		return shim.Error(`Incorect format of arguments.`)
	}

	return postPrivateData(stub, args, "collectionPrivate")

}

func (t *WhateverChaincode) postStateSuperPrivate(stub shim.ChaincodeStubInterface, args [][]byte) peer.Response {

	if len(args) != 3 {
		return shim.Error(`Incorect format of arguments.`)
	}

	return postPrivateData(stub, args, "collectionSuperPrivate")

}

func postPrivateData(stub shim.ChaincodeStubInterface, args [][]byte, collection string) peer.Response {

	key := string(args[1])

	// Check doesn't exist in ledger
	_, err := stub.GetState(key)
	if err != nil {
		jsonResp := `{"Error" : "Failed to get state for ` + key + ` "}`
		return shim.Error(jsonResp)
	}
	// if stateBytes != nil {
	// 	jsonResp := `{"Error": "Exist ` + key + ` in ledger."}`
	// 	return shim.Error(jsonResp)
	// }

	fmt.Println("Post Private State", key)
	value := args[2]
	fmt.Println("ValueByte:", len(value))

	err = stub.PutPrivateData(collection, key, value)
	if err != nil {
		return shim.Error(err.Error())
	}

	fmt.Println("[Success Post]", key)
	return shim.Success(nil)

}