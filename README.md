
# Single organization hyperledger network configuration
1. ### Introduction
This is a test for single organization hyperledger network. the nework was built on hyperledger fabric v1.4, it consistes
- one orderer
- on certeficate authority (fabric-ca)
- two peers (one anchor)
- one test chain code

2. ### Getting Started
before starting this network make sure you have all the [prerequesits](https://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html) and ensure you have the necessary dependencies installed on your machine. once you have installed all the dependencies of a hyperledger faric network follow this steps:
- clone this repository to your favorite location using `git clone https://github.com/Mikearaya/single_org_hyperledger`
- after the cloning process complete enter the folder
- once you are in the root directory of the repository generate all the configuration files required for a the network such as **orderer genesis block**, **channel genesis block**, **anchor peer update file** by running the shell script `./generate.sh`.
- next start the network by running the **docker-compose** file to start the network by executing shell script `./start`. *note when running this if the required docker images don't already exist in your system it will take a few minutes to complete while dowloading the docker images*. 
- After all the required images are pulled the network will automatically start with all the components ready including *one system channel **bionic-sys-channel**, one organization channel **bionicchannel**, two peers with smart contract installed and instantiated on the channel* and ready to accept `invoke` & `query` requests.
- To be able to call the chaincode installed on the peers from the client go to **crypto-config/peerOrganizations/org1.bionic.com/users/User1@org1.bionic.com/msp/keystore** and copy the *_sk* file name. after coping the file name navigate back to **application/addToWallet.js** and change the old keystore value by the new one you just copied example if the *_sk* file you just copied id **c0e8c3086d60a13d8f5939c154140de750cc4b573866ddea05b5957d81896c62_sk**  find the line that reads the user key  
                 
`const key = fs.readFileSync( path.join(credPath,'/msp/keystore/08c777eb48abed92fa2fce336153382e5f695382113b4cc30b54c39b68ea5b9b_sk')).toString();`

 and change it to 
 
`const key = fs.readFileSync( path.join(credPath, '/msp/keystore/`**c0e8c3086d60a13d8f5939c154140de750cc4b573866ddea05b5957d81896c62_sk**`')).toString();`

save the new change and go to your terminal and navigate to the **application/** folder from the root directory.

- finally generate the user credetials by running the script `node addToWallet.js` if all goes well you should see out put saying **done.**, next issue your first `invokation` by running `node issue.js`

congratulation!!!! you just runed and executed a chaincode on my single organization network. 
