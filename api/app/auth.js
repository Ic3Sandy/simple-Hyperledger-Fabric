'use strict';
import hfc from 'fabric-client';

const getClientForOrg = async (username, orgName) => {

    let client = hfc.loadFromConfig(hfc.getConfigSetting(orgName + '-network-connection-profile-path'));
    client.loadFromConfig(hfc.getConfigSetting(orgName + '-connection-profile-path'));
    await client.initCredentialStores();

    if (username) {
        let user = await client.getUserContext(username, true);
        if (!user) {
            console.log('User was not found :', username);
            throw new Error('User was not found : ' + username);
        }
    };

    return client;

};

const getRegisteredUser = async (username, orgName) => {

    console.log('[getRegisteredUser]')

    try {

        let client = await getClientForOrg(null, orgName);
        let user = await client.getUserContext(username, true);

        if (user && user.isEnrolled()) {
            console.log('Successfully loaded member', username);
        }
        else {

            let admins = hfc.getConfigSetting('admins');
            let adminUserObj = await client.setUserContext({
                username: admins[0].username,
                password: admins[0].passwd
            });
            let caClient = client.getCertificateAuthority();
            let passwd = await caClient.register({
                enrollmentID: username,
                affiliation: orgName.toLowerCase() + '.department1'
            }, adminUserObj);
            console.log("Password:", passwd);

            user = await client.setUserContext({ username: username, password: passwd });

        }

        if (user.isEnrolled()) {

            let result = {
                success: true,
                msg: username + ' enrolled Successfully',
                mspId: user._mspId,
                // password: passwd,
            };
            return result;
        }
        else {
            return { success: false, msg: 'User was not enrolled' };
        }
    } catch (error) {
        console.log(error);
        return { success: false, msg: error.toString() };
    }

};

export { getRegisteredUser, getClientForOrg };

