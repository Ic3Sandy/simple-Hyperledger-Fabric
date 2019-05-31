'use strict';
import { getClientForOrg } from './auth';
import { readFileSync } from 'fs';
import path from 'path';

const createChannel = async (data) => {

    console.log('[createChannel]');

    try {

        let client = await getClientForOrg(data.username, data.orgName);
        let envelope = readFileSync(path.join(__dirname, data.channelConfigPath));
        let channelConfig = client.extractChannelConfig(envelope);
        let signature = client.signChannelConfig(channelConfig);

        let request = {
            name: data.channelName,
            config: channelConfig,
            signatures: [signature],
            txId: client.newTransactionID(true) // get an admin based transactionID
        };
        console.log(request.signatures);

        let results = await client.createChannel(request);
        console.log(results);

        if (results && results.status === 'SUCCESS')
            return { success: true, msg: 'Create Channel Complete!' };
        else
            return { success: false, msg: results.info };

    } catch (error) {
        console.log(error);
        return { success: false, msg: error.toString() };
    };

};

const joinChannel = async (data) => {

    console.log('[joinChannel]');

    try {
        let client = await getClientForOrg(data.username, data.orgName);
        let channel = client.getChannel(data.channelName);

        if (!channel) {
            throw new Error("Channel was not defined");
        };

        let request = { txId: client.newTransactionID(true) };
        let genesis_block = await channel.getGenesisBlock(request);

        let join_request = {
            targets: data.targets,
            txId: client.newTransactionID(true),
            block: genesis_block,
        };

        let join = await channel.joinChannel(join_request, 10000); // 10 sec
        console.log(join);

        let results = {};
        for (let i in join) {

            if (join[i].status && join[i].status === 500) {
                results.success = false;
                results[join[i].peer.name] = join[i].toString();
            }
            else if (join[i].response && join[i].response.status === 200) {
                results.success = true;
                results[join[i].peer.name] = "Join Success!";
            };

        };

        return results;

    } catch (error) {
        console.log(error);
        return { success: false, msg: error.toString() };
    };

};

const updateChannel = async (data) => {

    console.log('[updateChannel]');

    try {

        let client = await getClientForOrg(data.username, data.orgName);
        let envelope = readFileSync(path.join(__dirname, data.channelConfigPath));
        let channelConfig = client.extractChannelConfig(envelope);
        let signature1 = client.signChannelConfig(channelConfig);

        if (data.orgName === "OrgA") client = await getClientForOrg("Bob", "OrgB");
        else if (data.orgName === "OrgB") client = await getClientForOrg("Alice", "OrgA");
        let signature2 = client.signChannelConfig(channelConfig);

        let request = {
            name: data.channelName,
            config: channelConfig,
            signatures: [signature1, signature2],
            txId: client.newTransactionID(true),
        };

        let results = await client.updateChannel(request);
        console.log(results);

        if (results && results.status === 'SUCCESS')
            return { success: true, msg: 'Updated Channel Complete!' };
        else
            return { success: false, msg: results.info };

    } catch (error) {
        console.log(error);
        return { success: false, msg: error.toString() };
    };

};

export { createChannel, joinChannel, updateChannel };