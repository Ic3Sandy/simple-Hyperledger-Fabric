'use strict';
import jwt from 'jsonwebtoken';
import { app } from '../server';

const authorization = (req, res, next) => {

    console.log('[authorization]');
    if (req.originalUrl === '/reg') {
        return next();
    };

    if (!req.token) {
        res.status(400).json({ "msg": "Not Found Token!" });
        return;
    };

    jwt.verify(req.token, app.get('secret'), (err, decoded) => {

        if (err) {
            res.status(400).json({ msg: 'Failed to authenticate token' });
            return;
        }
        else {
            req.body.username = decoded.username;
            req.body.orgName = decoded.orgName;
        };

    })
    console.log('\n');
    next();

};

export { authorization };