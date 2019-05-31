'use strict';
import { updateChannel } from '../../app/channel';

const put_updateChannel = async (req, res) => {

    console.log('[PUT /channels/:channelName]');
    console.log(req.body);

    let data = req.body;
    data.channelName = req.params.channelName;

    if (!data.channelName) {
        res.status(400).json({ "msg": "Not found channelName in path" });
        return;
    };
    if (!data.channelConfigPath) {
        res.status(400).json({ "msg": "Not found channelConfigPath in request body" });
        return;
    };

    let results = await updateChannel(data);
    console.log('\n');

    if (!results.success) {
        res.status(400).json(results);
    }
    else {
        res.status(200).json(results);
    };

};

export { put_updateChannel };