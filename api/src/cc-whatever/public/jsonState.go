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
	stateBytes, err := stub.GetState(args[0])
	if err != nil {
		jsonResp := `{"Error" : "Failed to get state for ` + args[0] + ` "}`
		return shim.Error(jsonResp)
	}
	if stateBytes != nil {
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
