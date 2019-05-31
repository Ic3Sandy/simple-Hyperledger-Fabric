'use strict';
import { queryBlock } from '../../app/query';

const get_queryBlockNumber = async (req, res) => {

    console.log('[GET /channels/:channelName/blocknumber]');
    console.log(req.body);

    let data = req.body;
    data.channelName = req.params.channelName;

    if (!data.channelName) {
        res.status(400).json({ "msg": "Not found channelName in path" });
        return;
    };
    if (!data.blockNumber) {
        res.status(400).json({ "msg": "Not found blockNumber in request body" });
        return;
    };

    let results = await queryBlock(data);
    res.status(200).json(results);

};

export { get_queryBlockNumber };