'use strict';
import { invokeChaincode } from '../../app/chaincode';

const post_invokeChaincode = async (req, res) => {

    console.log('[POST /channels/:channelName/chaincodes/:chaincodeId]');
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
    if (!data.args) {
        res.status(400).json({ "msg": "Not found args in request body" });
        return;
    };

    let results = await invokeChaincode(data);

    if (!results.success) {
        res.status(400).json(results);
    }
    else {
        res.status(200).json(results);
    };

};

export { post_invokeChaincode };