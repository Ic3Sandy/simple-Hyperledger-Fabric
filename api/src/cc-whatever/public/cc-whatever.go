package main

import (
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)

// WhateverChaincode Chaincode implementation for example NOSQL
type WhateverChaincode struct {
}

func main() {
	err := shim.Start(new(WhateverChaincode))
	if err != nil {
		fmt.Println("Error starting cc-whatever chaincode:", err)
	}
}

// Init is Instaniate Whatever chaincode.
func (t *WhateverChaincode) Init(stub shim.ChaincodeStubInterface) peer.Response {

	fmt.Println("Whatever chaincode Init!!!")
	_, args := stub.GetFunctionAndParameters()

	if len(args) == 0 {
		return shim.Success(nil)
	} else if len(args) == 1 || len(args)%2 == 0 {
		return shim.Error(`Incorect format of arguments. Example: {"Args" : ["init", "Alice", "id", "123", "age", "22", "email", "alice@outlook.com"]}`)
	}

	fmt.Println("Init for", args[0])
	return t.createState(stub, args)

}

// Invoke is function to CRUD
func (t *WhateverChaincode) Invoke(stub shim.ChaincodeStubInterface) peer.Response {

	function, args := stub.GetFunctionAndParameters()
	fmt.Println("invoke is running " + function)

	argbyte2d := stub.GetArgs()

	switch function {

	case "create":
		return t.createState(stub, args)
	case "read":
		return t.readState(stub, args)
	case "update":
		return t.updateState(stub, args)
	case "delete":
		return t.deleteState(stub, args)

	case "post":
		return t.postState(stub, argbyte2d)
	case "get":
		return t.getState(stub, args)
	case "put":
		return t.putState(stub, args)
	case "del":
		return t.delState(stub, args)

	default:
		fmt.Println("Invoke without a function:", function)
		return shim.Error("Unknown function invocation")
	}

}

