package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)

func (t *WhateverChaincode) createState(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) <= 1 || len(args)%2 == 0 {
		return shim.Error(`Incorect format of arguments. Example: {"Args" : ["crete", "Alice", "id", "123", "age", "22", "email", "alice@outlook.com"]}`)
	}

	// Check doesn't exist in ledger
	valueBytes, err := stub.GetState(args[0])
	if err != nil {
		jsonResp := `{"Error" : "Failed to get state for ` + args[0] + ` "}`
		return shim.Error(jsonResp)
	}
	if valueBytes != nil {
		jsonResp := `{"Error": "Exist ` + args[0] + ` in ledger."}`
		return shim.Error(jsonResp)
	}

	fmt.Println("Creating for", args[0])
	var dataMap = map[string]string{}

	for i, arg := range args {
		if i%2 == 1 {
			dataMap[arg] = args[i+1]
		}
	}

	jsonStringBytes, err := json.Marshal(dataMap)
	if err != nil {
		return shim.Error(err.Error())
	}

	err = stub.PutState(args[0], jsonStringBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	fmt.Println("[Success Create]")
	return shim.Success(nil)

}

func (t *WhateverChaincode) createStatePrivate(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) <= 1 || len(args)%2 == 0 {
		return shim.Error(`Incorect format of arguments. Example: {"Args" : ["createprivate", "Alice", "age", "29", "email", "alice@gmail.com", "balance", "2000"]}`)
	}

	return createPrivate(stub, args, "collectionPrivate")

}

func (t *WhateverChaincode) createStateSuperPrivate(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) <= 1 || len(args)%2 == 0 {
		return shim.Error(`Incorect format of arguments. Example: {"Args" : ["createsuperprivate", "Alice", "age", "29", "email", "alice@gmail.com", "balance", "2000", "passwd", "password123"]}`)
	}

	return createPrivate(stub, args, "collectionSuperPrivate")

}

// PrivateData
func createPrivate(stub shim.ChaincodeStubInterface, args []string, collection string) peer.Response {

	// ==== Check private already exists ====
	statePrivateBytes, err := stub.GetPrivateData(collection, args[0])
	if err != nil {
		return shim.Error("Failed to get state: " + err.Error())
	} else if statePrivateBytes != nil {
		return shim.Error("This state already exists: " + args[0])
	}

	var dataMap = map[string]string{}
	for i, arg := range args {
		if i%2 == 1 {
			dataMap[arg] = args[i+1]
		}
	}

	jsonStringBytes, err := json.Marshal(dataMap)
	if err != nil {
		return shim.Error(err.Error())
	}

	err = stub.PutPrivateData(collection, args[0], jsonStringBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)

}

