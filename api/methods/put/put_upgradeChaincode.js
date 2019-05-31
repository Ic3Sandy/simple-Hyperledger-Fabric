'use strict';
import { instantiateChaincode } from '../../app/chaincode';
import { readFileSync } from 'fs';

const put_upgradeChaincode = async (req, res) => {

    console.log('[PUT /channels/:channelName/instantiate]');
    console.log(req.body);

    let data = req.body;
    data.channelName = req.params.channelName;

    if (!data.channelName) {
        res.status(400).json({ "msg": "Not found channelName in path" });
        return;
    };
    if (!data.chaincodeId) {
        res.status(400).json({ "msg": "Not found chaincodeId in request body" });
        return;
    };
    if (!data.chaincodeVersion) {
        res.status(400).json({ "msg": "Not found chaincodeVersion in request body" });
        return;
    };
    if (!data.chaincodeType) {
        res.status(400).json({ "msg": "Not found chaincodeType in request body" });
        return;
    };
    if (!data.endorsementPolicy) {
        res.status(400).json({ "msg": "Not found endorsementPolicy in request body" });
        return;
    }

    data.endorsementPolicy = JSON.parse(readFileSync(data.endorsementPolicy, 'utf8'));
    data.upgrade = true;

    let results = await instantiateChaincode(data);

    if (!results.success) {
        res.status(400).json(results);
    }
    else {
        res.status(200).json(results);
    };

};

export { put_upgradeChaincode };