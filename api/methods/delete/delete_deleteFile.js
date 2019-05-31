'use strict';
import { deleteFile } from '../../app/file';

const delete_deleteFile = async (req, res) => {

    console.log('[DELETE /channels/:channelName/chaincodes/:chaincodeId/file]');
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
    if (!data.args || data.args.length != 1) {
        res.status(400).json({ "msg": "Not found args in request body" });
        return;
    };

    let results = await deleteFile(data);

    if (!results.success) {
        res.status(400).json(results);
    }
    else {
        res.status(200).json(results);
    };

};

export { delete_deleteFile };