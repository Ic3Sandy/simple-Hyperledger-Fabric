'use strict';
import { joinChannel } from '../../app/channel';

const post_joinChannel = async (req, res) => {

    console.log('[POST /joinchannels/:channelName]');
    console.log(req.body);

    let data = req.body;
    data.channelName = req.params.channelName;

    if (!data.channelName) {
        res.status(400).json({ "msg": "Not found channelName in path" });
        return;
    };
    if (!data.targets || data.targets.length == 0) {
        res.status(400).json({ "msg": "Not found peers in request body" });
        return;
    };

    let results = await joinChannel(data);
    console.log('\n');

    if (!results.success) {
        res.status(400).json(results);
    }
    else {
        res.status(200).json(results);
    };

};

export { post_joinChannel };