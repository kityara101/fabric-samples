#####################################################
# Deploy chaincode to the specified peer and channel
#####################################################
# parameters:
# $1 - chaincode
# $2 - org on behalf of which the cannel will be created

CHAINCODE=$1
ORG=$2

echo "--> Deploying chaincode '$CHAINCODE' to $ORG's peer0."
docker exec -e "CORE_PEER_ADDRESS=peer0.${ORG,}.example.com:7051" -e "CORE_PEER_LOCALMSPID=${ORG}MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${ORG,}.example.com/users/Admin@${ORG,}.example.com/msp" cli peer chaincode install -n $CHAINCODE -v 1.0 -p github.com/$CHAINCODE

