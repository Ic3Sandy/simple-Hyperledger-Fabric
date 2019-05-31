'use strict';
import hfc from 'fabric-client';
import path from 'path';

hfc.setConfigSetting('Org-network-connection-profile-path', path.join(__dirname, 'config', 'org-network-config.yaml'));
hfc.setConfigSetting('OrgA-network-connection-profile-path', path.join(__dirname, 'config', 'orga-network-config.yaml'));
hfc.setConfigSetting('OrgB-network-connection-profile-path', path.join(__dirname, 'config', 'orgb-network-config.yaml'));
hfc.setConfigSetting('OrgC-network-connection-profile-path', path.join(__dirname, 'config', 'orgc-network-config.yaml'));

hfc.setConfigSetting('Org-connection-profile-path', path.join(__dirname, 'config', 'org.yaml'));
hfc.setConfigSetting('OrgA-connection-profile-path', path.join(__dirname, 'config', 'orga.yaml'));
hfc.setConfigSetting('OrgB-connection-profile-path', path.join(__dirname, 'config', 'orgb.yaml'));
hfc.setConfigSetting('OrgC-connection-profile-path', path.join(__dirname, 'config', 'orgc.yaml'));

hfc.addConfigFile(path.join(__dirname, 'config', 'config.json'));