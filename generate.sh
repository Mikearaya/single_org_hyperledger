export FABRIC_CA_CLIENT_HOME=$PWD/ca_client
export FABRIC_CA_SERVER_HOME=$PWD/ca_server

rm -rf ./channel-artifacts/* ./crypto-config/* ./identity/*

cryptogen generate --config=config/crypto-config.yaml

fabric-ca-server start -b admin:adminpw -p 7059 &

./ccp-generate.sh
echo $FABRIC_CA_CLIENT_HOME
cp templates/docker-compose-e2e-template.yaml docker-compose-e2e.yaml

# The next steps will replace the template's contents with the
# actual values of the private key file names for the two CAs.
export FABRIC_CFG_PATH=$PWD/config
CURRENT_DIR=$PWD
cd crypto-config/peerOrganizations/org1.bionic.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed -i "s/CA1_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-e2e.yaml

###########################
# Generate system channel #
###########################

configtxgen -profile OneOrgOrdererGenesis -channelID bionic-sys-channel -outputBlock ./channel-artifacts/genesis.block

####################
# Generate channel #
####################

configtxgen -profile OneOrgChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID bionicchannel

##########################################
# Generate channel update configurations #
##########################################

configtxgen -profile OneOrgChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID bionicchannel -asOrg Org1MSP
