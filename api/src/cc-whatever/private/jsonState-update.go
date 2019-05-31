package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)


func (t *WhateverChaincode) updateState(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) <= 1 || len(args)%2 == 0 {
		return shim.Error(`Incorect format of arguments. Example: {"Args" : ["update", "Alice", "age", "29", "email", "alice@gmail.com"]}`)
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

	var dataMap = map[string]string{}
	err = json.Unmarshal(stateBytes, &dataMap)
	if err != nil {
		return shim.Error(err.Error())
	}

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

	fmt.Println("[Success Update]")
	return shim.Success(nil)

}

func (t *WhateverChaincode) updateStatePrivate(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) <= 1 || len(args)%2 == 0 {
		return shim.Error(`Incorect format of arguments. Example: {"Args" : ["updateprivate", "Alice", "age", "29", "email", "alice@gmail.com", "balance", "5000"]}`)
	}

	return updataPrivate(stub, args, "collectionPrivate")

}

func (t *WhateverChaincode) updateStateSuperPrivate(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) <= 1 || len(args)%2 == 0 {
		return shim.Error(`Incorect format of arguments. Example: {"Args" : ["updatesuperprivate", "Alice", "age", "29", "email", "alice@gmail.com", "balance", "5000", "passwd", "pass123"]}`)
	}

	return updataPrivate(stub, args, "collectionSuperPrivate")

}

func updataPrivate(stub shim.ChaincodeStubInterface, args []string, collection string) peer.Response {

	// Check exist in state
	stateBytes, err := stub.GetPrivateData(collection, args[0])
	if err != nil {
		jsonResp := `{"Error" : "Failed to get state for ` + args[0] + ` "}`
		return shim.Error(jsonResp)
	}
	if stateBytes == nil {
		jsonResp := `{"Error": "Dosen't exist ` + args[0] + ` in state."}`
		return shim.Error(jsonResp)
	}

	var dataMap = map[string]string{}
	err = json.Unmarshal(stateBytes, &dataMap)
	if err != nil {
		return shim.Error(err.Error())
	}

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