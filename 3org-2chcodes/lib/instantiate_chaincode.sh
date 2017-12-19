########################################################
# Initiates chaincode on the specified peer and channel
########################################################
# parameters:
# $1 - chaincode
# $2 - channel
# $3 - org on behalf of which the cannel will be created
# $4 - endorsment policy

CHAINCODE=$1
CHANNEL=$2
ORG=$3
POLICY=$4


echo "-----> Initiating chaincode '$CHAINCODE' on channel '$CHANNEL' of $ORG's peer0 with policy: ${POLICY}."
docker exec -e "CORE_PEER_ADDRESS=peer0.${ORG,}.example.com:7051" -e "CORE_PEER_LOCALMSPID=${ORG}MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${ORG,}.example.com/users/Admin@${ORG,}.example.com/msp" cli peer chaincode instantiate -o orderer.example.com:7050 -C $CHANNEL -n $CHAINCODE -v 1.0 -c '{"Args":[""]}' -P "${POLICY}"
echo "-----> Waiting ${FABRIC_START_TIMEOUT} seconds for chaincode container to start."

sleep ${FABRIC_START_TIMEOUT}

