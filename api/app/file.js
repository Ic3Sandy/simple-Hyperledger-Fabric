'use strict';
import { getClientForOrg } from './auth';
import sizeof from 'object-sizeof';
import { readFileStream, writeFileStream } from './fileStream';
import { invokeChaincode } from './chaincode';

const sleep = (ms) => {
    return new Promise(resolve => setTimeout(resolve, ms));
};

const uploadFile = async (data) => {

    console.log('[uploadFile]');

    try {

        let filename = data.args[0];
        let pathfile = data.args[1];
        let chunks = await readFileStream(pathfile);
        let channelName = data.channelName;
        let metadata = {};

        let client = await getClientForOrg(data.username, data.orgName);
        let allChannel = client._network_config._network_config.channels
        let numOfMetaChannels = 1;
        let chunkChannel = Object.keys(allChannel).length - numOfMetaChannels;

        for (let i = 0; i < chunks.length; i++) {

            let subfilename = filename + '_' + i;
            data.args[0] = subfilename;
            data.args[1] = chunks[i];

            let numChannel = i % chunkChannel;
            data.channelName = channelName + '-' + numChannel;

            console.log("ChunksLength:", chunks.length, "SubFileName", subfilename);
            console.log("Sizeof Data:", (sizeof(data) / (1024 * 1024)).toFixed(2), "MB");
            console.log("Sizeof Chunk:", (sizeof(chunks[i]) / (1024 * 1024)).toFixed(2), "MB");
            metadata[subfilename] = data.channelName;

            let results = await invokeChaincode(data);
            console.log(results);

            if (!results.success) {
                throw new Error(results.toString());
            };

        };

        data.args[0] = filename;
        data.args[1] = JSON.stringify(metadata);
        data.channelName = channelName;

        let results = await invokeChaincode(data);
        console.log(results);

        if (!results.success) {
            throw new Error(results.toString());
        };

        return results;

    } catch (error) {
        console.log(error);
        return { success: false, msg: error.toString() };
    };

};

const checkQuery = (query) => {

    return new Promise((resolve) => {

        for (let i in query)
            if (query[i].connectFailed || query[0].status === 500)
                query.splice(i, 1);

        console.log("query:", query);
        if (query.length === 0)
            throw new Error("Result of query is empty!");
        // if (query[0].status === 500)
        //     throw new Error(query[0]);
        // if (query[0].connectFailed)
        //     throw new Error(query[0]);

        resolve(query);
    });

};

const downloadFile = async (data) => {

    console.log('[downloadFile]');

    try {

        let client = await getClientForOrg(data.username, data.orgName);
        let channel = client.getChannel(data.channelName);
        let filename = data.args[0];
        let filepath = data.args[1];
        let chunks = [];

        if (!channel) {
            throw new Error("Channel was not defined");
        };

        data.args = [filename];
        let query = await channel.queryByChaincode(data);
        query = await checkQuery(query);

        let metadata = JSON.parse(query[0].toString());
        // console.log("MetaData:", metadata);

        for (let subfilename in metadata) {

            data.args = [subfilename];
            channel = client.getChannel(metadata[subfilename]);
            query = await channel.queryByChaincode(data);
            query = await checkQuery(query);

            chunks.push(query[0]);
            console.log("NumberSubfile:", Object.keys(metadata).length, "Download:", subfilename);

        };

        let status = await writeFileStream(filepath, chunks);
        console.log(status);

        return { success: true, msg: status };

    } catch (error) {
        console.log(error);
        return { success: false, msg: error.toString() };
    };

};

const deleteFile = async (data) => {

    console.log('[deleteFile]');

    try {

        let client = await getClientForOrg(data.username, data.orgName);
        let channel = client.getChannel(data.channelName);
        let filename = data.args[0]
        let channelName = data.channelName;

        if (!channel) {
            throw new Error("Channel was not defined");
        };

        let chaincodeQueryRequest = {
            chaincodeId: data.chaincodeId,
            fcn: "get",
            args: [filename],
        };
        let query = await channel.queryByChaincode(chaincodeQueryRequest);
        console.log(query);

        query = await checkQuery(query);
        let metadata = JSON.parse(query[0].toString());
        console.log("MetaData:", metadata);

        for (let subfilename in metadata) {

            data.args = [subfilename];
            data.channelName = metadata[subfilename];

            query = await invokeChaincode(data);
            console.log(query);

            if (!query.success) {
                throw new Error(query.toString());
            };
            console.log("NumberSubfile:", Object.keys(metadata).length, "Deleted:", subfilename);

        };

        data.args = [filename];
        data.channelName = channelName;
        let results = await invokeChaincode(data);
        console.log(results);

        if (!results.success) {
            throw new Error(results.toString());
        };
        console.log("Deleted", filename);

        return results;

    } catch (error) {
        console.log(error);
        return { success: false, msg: error.toString() };
    };

};

const updateFile = async (data) => {

    console.log('[updateFile]');

    try {

        let filename = data.args[0];
        let filepath = data.args[1];

        data.fcn = "del";
        data.args = [filename];

        let results = await deleteFile(data);
        if (!results.success) {
            throw new Error(results.toString());
        };

        data.fcn = "post";
        data.args = [filename, filepath];

        results = await uploadFile(data);
        if (!results.success) {
            throw new Error(results.toString());
        };

        return results;

    } catch (error) {
        console.log(error);
        return { success: false, msg: error.toString() };
    };

};

const uploadBinary = async (data) => {

    console.log('[uploadBinary]');

    try {

        // data.args[1] = new Buffer.from(data.args[1], 'hex');
        if (data.args[0] === 'hex') {
            data.args[1] = new Buffer.from(data.args[1], 'hex');
        }
        else
            data.args[1] = new Buffer.from(data.args[1]);
        console.log("Size of", data.args[1] + ":", sizeof(data.args[1]), "byte");

        let results = await invokeChaincode(data);
        console.log(results);

        if (!results.success) {
            throw new Error(results.toString());
        };

        return results;

    } catch (error) {
        console.log(error);
        return { success: false, msg: error.toString() };
    };

};

export { uploadFile, downloadFile, deleteFile, updateFile, uploadBinary };