'use strict';
import { getClientForOrg } from './auth';
import hfc from 'fabric-client';
import path from 'path';

const installChaincode = async (data) => {

    console.log('[installChaincode]');

    try {

        process.env.GOPATH = path.join(__dirname, hfc.getConfigSetting('CC_SRC_PATH'));

        let client = await getClientForOrg(data.username, data.orgName);

        let request = {
            targets: data.targets,		                // ["peer0.org1.example.com","peer1.org1.example.com"]
            chaincodePath: data.chaincodePath, 	        // "github.com/example_cc/go"
            chaincodeId: data.chaincodeId,		        // "mycc"
            chaincodeVersion: data.chaincodeVersion,	// "v0"
            chaincodeType: data.chaincodeType,		    // "golang"
        };

        let installed = (await client.installChaincode(request))[0];
        console.log(installed);

        let results = {};
        for (let i in installed) {

            if (installed[i].status && installed[i].status === 500) {
                results.success = false;
                results[installed[i].peer.name] = installed[i].toString();
            }
            else if (installed[i].response && installed[i].response.status === 200) {
                results.success = true;
                results[installed[i].peer.name] = "Install Success!";
            };

        };

        return results;

    } catch (error) {
        console.log(error);
        return { success: false, msg: error.toString() };
    }

};

const instantiateChaincode = async (data) => {

    console.log('[instantiateChaincode]');

    try {

        let client = await getClientForOrg(data.username, data.orgName);
        let channel = client.getChannel(data.channelName);

        if (!channel) {
            throw new Error("Channel was not defined");
        };

        let txId = client.newTransactionID(true);

        data.txId = txId;
        let instantiated = null;

        if (data.upgrade)
            instantiated = await channel.sendUpgradeProposal(data, 180000);
        else
            instantiated = await channel.sendInstantiateProposal(data, 180000);

        let proposalResponses = instantiated[0];
        let proposal = instantiated[1];
        let results = {};
        // console.log(proposalResponses);
        // console.log(proposal);

        for (let pr in proposalResponses) {
            if (!proposalResponses || !proposalResponses[pr].response || proposalResponses[pr].response.status !== 200) {
                return { success: false, msg: proposalResponses[pr].toString() };
            }
            else {
                results[proposalResponses[pr].peer.name] = "Instantiate Chaincode Success!"
            };
        };

        let orderer_request = {
            // must include the transaction id so that the outbound
            // transaction to the orderer will be signed by the admin
            // id as was the proposal above, notice that transactionID
            // generated above was based on the admin id not the current
            // user assigned to the 'client' instance.
            proposalResponses: proposalResponses,
            proposal: proposal,
            txId: txId,
        };
        let broadcastResponse = await channel.sendTransaction(orderer_request, 10000);

        if (broadcastResponse.status !== 'SUCCESS') {
            return { success: false, msg: broadcastResponse.toString() };
        };

        let event_hubs = channel.getChannelEventHubsForOrg();
        let txid = txId.getTransactionID();
        results.TransactionID = txid;

        return new Promise((resolve, reject) => {

            let events = [];

            event_hubs.forEach((eh) => {

                let onEvent = (txid, txStatus, blockNum) => {

                    console.log(eh.getPeerAddr());
                    console.log('txid:', txid);
                    console.log('txStatus:', txStatus);
                    console.log('blockNum:', blockNum);
                    events.push({
                        'peer': eh.getPeerAddr(),
                        'txid': txid,
                        'txStatus': txStatus,
                        'blockNum': blockNum,
                    });
                    console.log("events:", events.length, "event_hubs:", event_hubs.length)

                    if (txStatus !== 'VALID') {
                        reject({ success: false, msg: 'txStatus Invalid!' });
                    };

                    if (events.length === event_hubs.length) {
                        results.events = events;
                        resolve({ success: true, msg: results });
                    };

                };

                let onError = (err) => {
                    console.log(err);
                    reject({ success: false, msg: err.toString() });
                };

                let registrationOpts = { unregister: true, disconnect: true };

                eh.registerTxEvent(txid, onEvent, onError, registrationOpts);
                eh.connect();

            });

        });

    } catch (error) {
        console.log(error);
        return { success: false, msg: error.toString() };
    };

};

const invokeChaincode = async (data) => {

    console.log('\n[invokeChaincode]');

    try {

        let client = await getClientForOrg(data.username, data.orgName);
        let channel = client.getChannel(data.channelName);

        if (!channel) {
            throw new Error("Channel was not defined");
        };

        let txId = client.newTransactionID();

        let chaincodeInvokeRequest = {
            targets: data.targets,
            chaincodeId: data.chaincodeId,
            txId: txId,
            fcn: data.fcn,
            args: data.args,
        };

        let invoked = await channel.sendTransactionProposal(chaincodeInvokeRequest, 180000); //180000 -> 3 min

        let proposalResponses = invoked[0];
        let proposal = invoked[1];
        let results = {};
        // console.log(proposalResponses);
        // console.log(proposal);

        for (let pr in proposalResponses) {
            if (!proposalResponses || !proposalResponses[pr].response || proposalResponses[pr].response.status !== 200) {
                return { success: false, msg: proposalResponses[pr].toString() };
            }
            else {
                results[proposalResponses[pr].peer.name] = "Invoke Chaincode Success!"
            };
        };

        let orderer_request = {
            proposalResponses: proposalResponses,
            proposal: proposal,
            txId: txId,
        };
        let broadcastResponse = await channel.sendTransaction(orderer_request, 180000);

        if (broadcastResponse.status !== 'SUCCESS') {
            return { success: false, msg: broadcastResponse.toString() };
        };

        let event_hubs = channel.getChannelEventHubsForOrg();
        let txid = txId.getTransactionID();
        results.TransactionID = txid;

        return new Promise((resolve, reject) => {

            let events = [];

            event_hubs.forEach((eh) => {

                let onEvent = (txid, txStatus, blockNum) => {

                    console.log(eh.getPeerAddr());
                    console.log('txid:', txid);
                    console.log('txStatus:', txStatus);
                    console.log('blockNum:', blockNum);
                    events.push({
                        'peer': eh.getPeerAddr(),
                        'txid': txid,
                        'txStatus': txStatus,
                        'blockNum': blockNum,
                    });

                    if (txStatus !== 'VALID') {
                        reject({ success: false, msg: 'txStatus Invalid!' });
                    };

                    if (events.length === event_hubs.length) {
                        results.events = events;
                        resolve({ success: true, msg: results });
                    };

                };

                let onError = (err) => {
                    console.log(err);
                    reject({ success: false, msg: err.toString() });
                };

                let registrationOpts = { unregister: true, disconnect: true };

                eh.registerTxEvent(txid, onEvent, onError, registrationOpts);
                eh.connect();

            });

        });

    } catch (error) {
        console.log(error);
        return { success: false, msg: error.toString() };
    };

};

export { installChaincode, instantiateChaincode, invokeChaincode };