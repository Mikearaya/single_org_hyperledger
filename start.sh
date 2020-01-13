export BYFN_CA1_PRIVATE_KEY=$(cd crypto-config/peerOrganizations/org1.bionic.com/ca && ls *_sk)

docker-compose -f docker-compose-cli.yaml up -d --remove-orphans

##########################
#       start cli        #
##########################

docker exec -it cli bash

#############################
# run inside peer container #
#############################

# export CORE_PEER_LOCALMSPID="Org1MSP"
# export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.bionic.com/peers/peer0.org1.bionic.com/tls/ca.crt
# export CORE_PEER_ADDRESS=peer0.org1.bionic.com:7051
# export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.bionic.com/peers/peer0.org1.bionic.com/msp/

# peer channel create -o orderer.bionic.com:7050 -c bionicchannel -f ./channel-artifacts/channel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bionic.com/orderers/orderer.bionic.com/msp/tlscacerts/tlsca.bionic.com-cert.pem

#when TLS is disabled
# peer channel create -o orderer.bionic.com:7050 -c bionicchannel -f ./channel-artifacts/channel.tx

# peer channel join -b bionicchannel.block

# export CORE_PEER_LOCALMSPID="Org1MSP"
# export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.bionic.com/peers/peer1.org1.bionic.com/tls/ca.crt
# export CORE_PEER_ADDRESS=peer1.org1.bionic.com:8051
# export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.bionic.com/users/Admin\@org1.bionic.com/msp/

# peer channel join -b bionicchannel.block

# peer channel update -o orderer.bionic.com:7050 -c bionicchannel -f ./channel-artifacts/Org1MSPanchors.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bionic.com/tlsca/tlsca.bionic.com-cert.pem

# When TLS is disabled
# peer channel update -o orderer.bionic.com:7050 -c bionicchannel -f ./channel-artifacts/Org1MSPanchors.tx

# peer chaincode install -n papercontract -v 0 -p /opt/gopath/src/github.com/chaincode -l node
# peer chaincode instantiate -n papercontract -v 0 -l node -c '{"Args":["org.papernet.commercialpaper:instantiate"]}' -C bionicchannel -P "AND ('Org1MSP.member')" --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bionic.com/orderers/orderer.bionic.com/msp/tlscacerts/tlsca.bionic.com-cert.pem

# When TLS is disabled
#peer chaincode instantiate -n papercontract -v 0 -l node -c '{"Args":["org.papernet.commercialpaper:instantiate"]}' -C bionicchannel -P "AND ('Org1MSP.member')"

# peer chaincode invoke -o orderer.bionic.com:7050 -C bionicchannel -n papercontract  --peerAddresses peer1.org1.bionic.com:8051 -c '{"Args":["issue","MagnetoCorp","00001","2020-05-31", "2020-11-30", "5000000"]}'

# run addToWallet.js
