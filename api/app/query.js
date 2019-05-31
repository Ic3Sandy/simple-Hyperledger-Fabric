'use strict';
import { getClientForOrg } from './auth';

const queryByChaincode = async (data) => {

    console.log('[queryByChaincode]');

    try {

        let client = await getClientForOrg(data.username, data.orgName);
        let channel = client.getChannel(data.channelName);

        if (!channel) {
            throw new Error("Channel was not defined");
        };

        let chaincodeQueryRequest = {
            targets: data.targets,
            chaincodeId: data.chaincodeId,
            fcn: data.fcn,
            args: data.args,
        };

        let query = await channel.queryByChaincode(chaincodeQueryRequest);
        console.log(query);

        let results = {};
        if (query.length > 0) {

            for (let i in query) {
                if (query[i] instanceof Error) {
                    query[i] = query[i].toString();
                    results.success = false;
                }
                else {
                    query[i] = JSON.parse(query[i].toString());
                    results.success = true;
                };
            };

            results[data.args[0]] = query;
            return results;
        }
        else {
            return { success: false, msg: "Query is null" };
        };

    } catch (error) {
        console.log(error);
        return { success: false, msg: error.toString() };
    };

};

const queryTransaction = async (data) => {

    console.log('[queryTransaction]');

    try {

        let client = await getClientForOrg(data.username, data.orgName);
        let channel = client.getChannel(data.channelName);

        if (!channel) {
            throw new Error("Channel was not defined");
        };

        let query = await channel.queryTransaction(data.tx_id, data.target);
        console.log(query);

        return query;

    } catch (error) {
        console.log(error);
        return { success: false, msg: error.toString() };
    };

};

const queryBlock = async (data) => {

    console.log('[queryBlock]');

    try {

        let client = await getClientForOrg(data.username, data.orgName);
        let channel = client.getChannel(data.channelName);

        if (!channel) {
            throw new Error("Channel was not defined");
        };
        console.log(typeof data.blockNumber)

        let query = await channel.queryBlock(data.blockNumber, data.target);
        console.log(query);

        return query;

    } catch (error) {
        console.log(error);
        return { success: false, msg: error.toString() };
    };

};

export { queryByChaincode, queryTransaction, queryBlock };