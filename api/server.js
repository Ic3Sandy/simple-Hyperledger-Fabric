'use strict';
// const express = require('express');
import express from 'express';

const app = express();
const PORT = 4000;

// For req and res
app.use(express.json());
app.set('json spaces', 4);

// For Authentication
// const expressJWT = require('express-jwt');
import expressJWT from 'express-jwt';
// const bearerToken = require('express-bearer-token');
import bearerToken from 'express-bearer-token';
// const jwt = require('jsonwebtoken');

app.set('secret', 'thisismysecret');
app.use(expressJWT({ secret: 'thisismysecret' }).unless({ path: ['/reg'] }));
app.use(bearerToken());

import './config';

// Middleware function
import { authorization } from './methods/authorization';
app.use(authorization);

// Register and enroll user
import { post_reg } from './methods/post/post_reg';
app.post('/reg', post_reg);

// Create Channel
import { post_createChennel } from './methods/post/post_createChennel';
app.post('/channels/:channelName', post_createChennel);

// Update Channel
import { put_updateChannel } from './methods/put/put_updateChannel';
app.put('/channels/:channelName', put_updateChannel);

// Join Channel
import { post_joinChannel } from './methods/post/post_joinChannel';
app.post('/joinchannels/:channelName', post_joinChannel);

// Install chaincode
import { post_installChaincode } from './methods/post/post_installChaincode';
app.post('/installchaincodes/:chaincodeId', post_installChaincode);

// Instantiate Chaincode
import { post_instantiateChaincode } from './methods/post/post_instantiateChaincode';
app.post('/channels/:channelName/instantiate', post_instantiateChaincode);

// Upgrade Chaincode
import { put_upgradeChaincode } from './methods/put/put_upgradeChaincode';
app.put('/channels/:channelName/instantiate', put_upgradeChaincode);

// Invoke Chaincode
import { post_invokeChaincode } from './methods/post/post_invokeChaincode';
app.post('/channels/:channelName/chaincodes/:chaincodeId', post_invokeChaincode);

// Invoke Chaincode for Uploadfile
import { post_uploadFile } from './methods/post/post_uploadFile';
app.post('/channels/:channelName/chaincodes/:chaincodeId/file', post_uploadFile);

// Invoke Chaincode for Updatefile
import { put_updateFile } from './methods/put/put_updateFile';
app.put('/channels/:channelName/chaincodes/:chaincodeId/file', put_updateFile);

// Invoke Chaincode for Deletefile
import { delete_deleteFile } from './methods/delete/delete_deleteFile';
app.delete('/channels/:channelName/chaincodes/:chaincodeId/file', delete_deleteFile);

// Query Chaincode for Downloadfile
import { get_downloadFile } from './methods/get/get_downloadFile';
app.get('/channels/:channelName/chaincodes/:chaincodeId/file', get_downloadFile);

// Query Chaincode
import { get_queryChaincode } from './methods/get/get_queryChaincode';
app.get('/channels/:channelName/chaincodes/:chaincodeId', get_queryChaincode);

// Query Chaincode by Transaction
import { get_queryTransaction } from './methods/get/get_queryTransaction';
app.get('/channels/:channelName/transactions', get_queryTransaction);

// Query Chaincode by blocknumber
import { get_queryBlockNumber } from './methods/get/get_queryBlockNumber';
app.get('/channels/:channelName/blocknumber', get_queryBlockNumber);


app.listen(PORT, () => { console.log(`Server app listening on port ${PORT}!`); });

export { app };