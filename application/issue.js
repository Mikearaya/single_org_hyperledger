/*
SPDX-License-Identifier: Apache-2.0
*/

/*
 * This application has 6 basic steps:
 * 1. Select an identity from a wallet
 * 2. Connect to network gateway
 * 3. Access PaperNet network
 * 4. Construct request to issue commercial paper
 * 5. Submit transaction
 * 6. Process response
 */

'use strict';

// Bring key classes into scope, most importantly Fabric SDK network class
const fs = require('fs');
var path = require('path');
const yaml = require('js-yaml');

// brings two key Hyperledger Fabric SDK classes into scope – Wallet and Gatewa
const { FileSystemWallet, Gateway } = require('fabric-network');
const CommercialPaper = require('../chaincode/lib/paper');

// A wallet stores a collection of identities for use
//const wallet = new FileSystemWallet('../user/isabella/wallet');
const wallet = new FileSystemWallet('../identity/user/isabella/wallet');

// Main program function
async function main() {
  // A gateway defines the peers used to access Fabric networks
  const gateway = new Gateway();

  // Main try/catch block
  try {
    // Specify userName for network access
    // const userName = 'isabella.issuer@magnetocorp.com';
    const userName = 'User1@org1.bionic.com';

    // Load connection profile; will be used to locate a gateway
    let connectionProfile = yaml.safeLoad(
      fs.readFileSync('../gateway/networkConnection.yaml', 'utf8')
    );
    /* 
    const clientCert = fs.readFileSync(
      __dirname,
      path.join(
        '../crypto-config/peerOrganizations/org1.bionic.com/users/User1@org1.bionic.com/tls/client.crt'
      )
    );

    const clientKey = fs.readFileSync(
      __dirname,
      path.join(
        '../crypto-config/peerOrganizations/org1.bionic.com/users/User1@org1.bionic.com/tls/client.key'
      ),
      'utf8'
    ); */
    // Set connection options; identity and wallet
    let connectionOptions = {
      identity: userName,
      wallet: wallet,
      discovery: { enabled: false, asLocalhost: true }
    };

    // Connect to gateway using application specified parameters
    console.log('Connect to Fabric gateway.');

    await gateway.connect(connectionProfile, connectionOptions);
    console.log(await gateway.getClient().getMspid());

    /* 
    const client = gateway.getClient();

    client.setTlsClientCertAndKey(
      Buffer.from(clientCert).toString(),
      Buffer.from(clientKey).toString()
    ); */

    // Access PaperNet network
    console.log('Use network channel: bionicchannel.');

    const network = await gateway.getNetwork('bionicchannel');

    console.error('error occured');

    // Get addressability to commercial paper contract
    console.log('Use org.papernet.commercialpaper smart contract.');

    const contract = await network.getContract('papercontract');

    // issue commercial paper
    console.log('Submit commercial paper issue transaction.');

    const issueResponse = await contract.submitTransaction(
      'issue',
      'MagnetoCorp',
      '00002',
      '2020-05-31',
      '2020-11-30',
      '5000000'
    );

    // process response
    console.log('Process issue transaction response.' + issueResponse);

    let paper = CommercialPaper.fromBuffer(issueResponse);

    console.log(
      `${paper.issuer} commercial paper : ${paper.paperNumber} successfully issued for value ${paper.faceValue}`
    );
    console.log('Transaction complete.');
  } catch (error) {
    console.log(`Error processing transaction. ${error}`);
    console.log(error.stack);
  } finally {
    // Disconnect from the gateway
    console.log('Disconnect from Fabric gateway.');
    gateway.disconnect();
  }
}
main()
  .then(() => {
    console.log('Issue program complete.');
  })
  .catch(e => {
    console.log('Issue program exception.');
    console.log(e);
    console.log(e.stack);
    process.exit(-1);
  });
