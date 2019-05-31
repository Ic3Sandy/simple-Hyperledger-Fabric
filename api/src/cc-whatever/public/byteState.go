package main

import (
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)


func (t *WhateverChaincode) postState(stub shim.ChaincodeStubInterface, args [][]byte) peer.Response {

	if len(args) != 3 {
		return shim.Error(`Incorect format of arguments.`)
	}

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

	fmt.Println("Post State", key)
	value := args[2]
	fmt.Println("ValueByte:", len(value))

	err = stub.PutState(key, value)
	if err != nil {
		return shim.Error(err.Error())
	}

	fmt.Println("[Success Post]", key)
	return shim.Success(nil)

}

func (t *WhateverChaincode) getState(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error(`Incorect format of arguments. Example {"Args" : ["deletefile", "work.pdf"]}`)
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

	fmt.Println("[Success Get]", args[0])
	return shim.Success(stateBytes)

}

func (t *WhateverChaincode) putState(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 2 {
		return shim.Error(`Incorect format of arguments.`)
	}

	// Check doesn't exist in ledger
	stateBytes, err := stub.GetState(args[0])
	if err != nil {
		jsonResp := `{"Error" : "Failed to get state for ` + args[0] + ` "}`
		return shim.Error(jsonResp)
	}
	if stateBytes == nil {
		jsonResp := `{"Error": "Dosen't exist ` + args[0] + ` in ledger."}`
		return shim.Error(jsonResp)
	}

	fmt.Println("Put State", args[0])
	value := args[1]
	fmt.Println("Value", value)

	err = stub.PutState(args[0], []byte(value))
	if err != nil {
		return shim.Error(err.Error())
	}

	fmt.Println("[Success Put]", args[0])
	return shim.Success(nil)

}

func (t *WhateverChaincode) delState(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error(`Incorect format of arguments.`)
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

	fmt.Println("[Success Del]", args[0])
	return shim.Success(nil)

}
