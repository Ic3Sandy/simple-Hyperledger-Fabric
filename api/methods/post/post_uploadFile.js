'use strict';
import { uploadFile, uploadBinary } from '../../app/file';

const post_uploadFile = async (req, res) => {

    console.log('[POST /channels/:channelName/chaincodes/:chaincodeId/file]');
    console.log(req.body);

    let data = req.body;
    data.channelName = req.params.channelName;
    data.chaincodeId = req.params.chaincodeId;

    if (!data.channelName) {
        res.status(400).json({ "msg": "Not found channelName in path" });
        return;
    };
    if (!data.chaincodeId) {
        res.status(400).json({ "msg": "Not found chaincodeId in path" });
        return;
    };
    if (!data.fcn) {
        res.status(400).json({ "msg": "Not found fcn in request body" });
        return;
    };
    if (!data.args || data.args.length != 2) {
        res.status(400).json({ "msg": "Not found args in request body" });
        return;
    };

    let results = await uploadFile(data);

    if (!results.success) {
        res.status(400).json(results);
    }
    else {
        res.status(200).json(results);
    };

};

const post_uploadBinary = async (req, res) => {

    console.log('[POST /channels/:channelName/chaincodes/:chaincodeId/binary]');
    console.log(req.body);

    let data = req.body;
    data.channelName = req.params.channelName;
    data.chaincodeId = req.params.chaincodeId;

    if (!data.channelName) {
        res.status(400).json({ "msg": "Not found channelName in path" });
        return;
    };
    if (!data.chaincodeId) {
        res.status(400).json({ "msg": "Not found chaincodeId in path" });
        return;
    };
    if (!data.fcn) {
        res.status(400).json({ "msg": "Not found fcn in request body" });
        return;
    };
    if (!data.args || data.args.length != 2) {
        res.status(400).json({ "msg": "Not found args in request body" });
        return;
    };

    let results = await uploadBinary(data);

    if (!results.success) {
        res.status(400).json(results);
    }
    else {
        res.status(200).json(results);
    };

};

export { post_uploadFile, post_uploadBinary };