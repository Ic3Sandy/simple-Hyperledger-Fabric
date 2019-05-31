'use strict';
import { installChaincode } from '../../app/chaincode';

const post_installChaincode = async (req, res) => {

    console.log('[POST /installchaincodes/:chaincodeId]');
    console.log(req.body);

    let data = req.body;
    data.chaincodeId = req.params.chaincodeId;

    if (!data.targets || data.targets.length == 0) {
        res.status(400).json({ "msg": "Not found peers in request body" });
        return;
    };
    if (!data.chaincodeId) {
        res.status(400).json({ "msg": "Not found chaincodeId in path" });
        return;
    };
    if (!data.chaincodePath) {
        res.status(400).json({ "msg": "Not found chaincodePath in request body" });
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
    if (!data.chaincodeType) {
        res.status(400).json({ "msg": "Not found chaincodeType in request body" });
        return;
    };

    let results = await installChaincode(data);
    if (!results.success) {
        res.status(400).json(results);
    }
    else {
        res.status(200).json(results);
    };

};

export { post_installChaincode };