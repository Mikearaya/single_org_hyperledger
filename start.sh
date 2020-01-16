export BYFN_CA1_PRIVATE_KEY=$(cd crypto-config/peerOrganizations/org1.bionic.com/ca && ls *_sk)

docker-compose -f docker-compose-cli.yaml up -d --remove-orphans

#############################
# whe TLS is Disaled       #
#############################

function tlsDisable() {
    echo "TLS disabled!!!"
    sleep 5

    docker exec cli peer channel create -o orderer.bionic.com:7050 -c bionicchannel -f ./channel-artifacts/channel.tx
    docker exec cli peer channel join -b bionicchannel.block
    docker exec cli peer chaincode install -n papercontract -v 0 -p /opt/gopath/src/github.com/chaincode -l node
    # WHEN TLS is Disabled

    CORE_PEER_LOCALMSPID=Org1MSP
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.bionic.com/users/Admin@org1.bionic.com/msp/
    CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.bionic.com/peers/peer1.org1.bionic.com/tls/ca.crt
    CORE_PEER_ADDRESS=peer1.org1.bionic.com:8051

    docker exec -e "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID" \
        -e "CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH" \
        -e "CORE_PEER_TLS_ROOTCERT_FILE=$CORE_PEER_TLS_ROOTCERT_FILE" \
        -e "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS" \
        cli \
        peer channel join -b bionicchannel.block

    docker exec -e "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID" \
        -e "CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH" \
        -e "CORE_PEER_TLS_ROOTCERT_FILE=$CORE_PEER_TLS_ROOTCERT_FILE" \
        -e "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS" \
        cli \
        peer channel update -o orderer.bionic.com:7050 -c bionicchannel -f ./channel-artifacts/Org1MSPanchors.tx

    docker exec -e "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID" \
        -e "CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH" \
        -e "CORE_PEER_TLS_ROOTCERT_FILE=$CORE_PEER_TLS_ROOTCERT_FILE" \
        -e "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS" \
        cli \
        peer chaincode install -n papercontract -v 0 -p /opt/gopath/src/github.com/chaincode -l node

    docker exec cli \
        peer chaincode instantiate -n papercontract -v 0 -l node -c '{"Args":["org.papernet.commercialpaper:instantiate"]}' -C bionicchannel -P "AND ('Org1MSP.member')"
    sleep 5
    docker exec cli peer chaincode invoke -o orderer.bionic.com:7050 -C bionicchannel -n papercontract --peerAddresses peer0.org1.bionic.com:7051 -c '{"Args":["issue","MagnetoCorp","00001","2020-05-31", "2020-11-30", "5000000"]}'
}

#############################
# whe TLS is Enabled       #
#############################

function tlsEnabled() {
    echo "TLS enabled!!!"
    sleep 5

    docker exec cli peer channel create -o orderer.bionic.com:7050 -c bionicchannel -f ./channel-artifacts/channel.tx
    docker exec cli peer channel join -b bionicchannel.block
    docker exec cli peer chaincode install -n papercontract -v 0 -p /opt/gopath/src/github.com/chaincode -l node

    CORE_PEER_LOCALMSPID=Org1MSP
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.bionic.com/users/Admin@org1.bionic.com/msp/
    CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.bionic.com/peers/peer1.org1.bionic.com/tls/ca.crt
    CORE_PEER_ADDRESS=peer1.org1.bionic.com:8051

    docker exec -e "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID" \
        -e "CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH" \
        -e "CORE_PEER_TLS_ROOTCERT_FILE=$CORE_PEER_TLS_ROOTCERT_FILE" \
        -e "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS" \
        cli \
        peer channel join -b bionicchannel.block \ 
    --tls true \
        --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bionic.com/orderers/orderer.bionic.com/msp/tlscacerts/tlsca.bionic.com-cert.pem

    docker exec -e "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID" \
        -e "CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH" \
        -e "CORE_PEER_TLS_ROOTCERT_FILE=$CORE_PEER_TLS_ROOTCERT_FILE" \
        -e "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS" \
        cli \
        peer channel update -o orderer.bionic.com:7050 -c bionicchannel -f ./channel-artifacts/Org1MSPanchors.tx \
        --tls true \
        --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bionic.com/tlsca/tlsca.bionic.com-cert.pem

    docker exec -e "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID" \
        -e "CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH" \
        -e "CORE_PEER_TLS_ROOTCERT_FILE=$CORE_PEER_TLS_ROOTCERT_FILE" \
        -e "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS" \
        cli \
        peer chaincode install -n papercontract -v 0 -p /opt/gopath/src/github.com/chaincode -l node

    docker exec -e "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID" \
        -e "CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH" \
        -e "CORE_PEER_TLS_ROOTCERT_FILE=$CORE_PEER_TLS_ROOTCERT_FILE" \
        -e "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS" \
        cli \
        peer chaincode instantiate -n papercontract -v 0 -l node -c '{"Args":["org.papernet.commercialpaper:instantiate"]}' -C bionicchannel -P "AND ('Org1MSP.member')" \
        --tls true \
        --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bionic.com/orderers/orderer.bionic.com/msp/tlscacerts/tlsca.bionic.com-cert.pem

}

tlsDisable
