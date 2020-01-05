cryptogen generate --config=config/crypto-config.yaml

./ccp-generate.sh

cp templates/docker-compose-e2e-template.yaml docker-compose-e2e.yaml

# The next steps will replace the template's contents with the
# actual values of the private key file names for the two CAs.
export FABRIC_CFG_PATH=$PWD/config
CURRENT_DIR=$PWD
cd crypto-config/peerOrganizations/org1.bionic.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed -i "s/CA1_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-e2e.yaml

configtxgen -profile OneOrgOrdererGenesis -channelID bionic-sys-channel -outputBlock ./channel-artifacts/genesis.block

configtxgen -profile OneOrgChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID bionicchannel

configtxgen -profile OneOrgChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID bionicchannel

export BYFN_CA1_PRIVATE_KEY=$(cd crypto-config/peerOrganizations/org1.bionic.com/ca && ls *_sk)

docker-compose -f docker-compose-cli.yaml up -d --remove-orphans

docker exec -it cli bash

export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.bionic.com/peers/peer0.org1.bionic.com/tls/ca.crt
export CORE_PEER_ADDRESS=peer0.org1.bionic.com:7051
