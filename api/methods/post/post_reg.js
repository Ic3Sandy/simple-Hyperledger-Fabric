'use strict';
import jwt from 'jsonwebtoken';
import { getRegisteredUser } from '../../app/auth';
import hfc from 'fabric-client';
import { app } from '../../server';

const post_reg = async (req, res) => {

    console.log('[/reg]');
    console.log(req.body);

    if (!req.body.username) {
        res.status(400).json({ "msg": "Not found username in request" });
        return;
    };
    if (!req.body.orgName) {
        res.status(400).json({ "msg": "Not found orgName in request" });
        return;
    };

    let username = req.body.username;
    let orgName = req.body.orgName;

    let token = jwt.sign({
        exp: Math.floor(Date.now() / 1000) + parseInt(hfc.getConfigSetting('jwt_expiretime')), // 1 hours
        username: username,
        orgName: orgName
    }, app.get('secret'));

    let results = await getRegisteredUser(username, orgName);
    results.token = token;
    console.log(results);
    console.log('\n');

    if (!results.success) {
        res.status(400).json(results);
    }
    else {
        res.status(200).json(results);
    };

};

export { post_reg };