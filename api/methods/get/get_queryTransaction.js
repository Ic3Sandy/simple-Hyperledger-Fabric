'use strict';
import { queryTransaction } from '../../app/query';

const get_queryTransaction = async (req, res) => {

    console.log('[GET /channels/:channelName/transactions]');
    console.log(req.body);

    let data = req.body;
    data.channelName = req.params.channelName;

    if (!data.channelName) {
        res.status(400).json({ "msg": "Not found channelName in path" });
        return;
    };
    if (!data.tx_id) {
        res.status(400).json({ "msg": "Not found tx_id in request body" });
        return;
    };

    let results = await queryTransaction(data);
    res.status(200).json(results);

};

export { get_queryTransaction };