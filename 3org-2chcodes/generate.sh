#!/bin/sh
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
export PATH=$GOPATH/src/github.com/hyperledger/fabric/build/bin:${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}

. ./.env_base

if [ -f ./.env ]; then
  . ./.env
fi

# remove previous crypto material and config transactions
if [ ! -d ./config ]; then 
  mkdir ./config
fi


echo "===> Generating crypto material"
# generate crypto material
cryptogen generate --config=./crypto-config.yaml
if [ "$?" -ne 0 ]; then
  echo "Failed to generate crypto material..."
  exit 1
fi

echo "===> Generating Fabric configuration."
echo "-----> Generating genesis block."
# generate genesis block for orderer
#configtxgen -profile ThreeOrgOrdererGenesis -outputBlock ./config/genesis.block
. ./lib/generate_genesis.sh
if [ "$?" -ne 0 ]; then
  echo "Failed to generate orderer genesis block..."
  exit 1
fi

echo "-----> Generating channel confiruation for '$CHANNEL_1'."
# generate CHANNEL_1 configuration transaction
configtxgen -profile Channel-1 -outputCreateChannelTx ./config/$CHANNEL_1.tx -channelID $CHANNEL_1
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel configuration transaction..."
  exit 1
fi

echo "-----> Generating anchor peers configuration for '$CHANNEL_1'."
# generate anchor peer transaction
configtxgen -profile Channel-1 -outputAnchorPeersUpdate ./config/Anchors_$CHANNEL_1.tx -channelID $CHANNEL_1 -asOrg TLabel
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org1MSP..."
  exit 1
fi


echo "-----> Generating channel confiruation for '$CHANNEL_2'."
# generate CHANNEL_12 configuration transaction
configtxgen -profile Channel-2 -outputCreateChannelTx ./config/$CHANNEL_2.tx -channelID $CHANNEL_2
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel configuration transaction..."
  exit 1
fi

echo "-----> Generating anchor peers configuration for '$CHANNEL_2'."
# generate anchor peer transaction
configtxgen -profile Channel-2 -outputAnchorPeersUpdate ./config/Anchors_$CHANNEL_2.tx -channelID $CHANNEL_2 -asOrg TLabel
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org1MSP..."
  exit 1
fi

echo "-----> Generating channel confiruation for '$CHANNEL_2'."
# generate CHANNEL_12 configuration transaction
configtxgen -profile Channel-2 -outputCreateChannelTx ./config/$CHANNEL_3.tx -channelID $CHANNEL_3
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel configuration transaction..."
  exit 1
fi

echo "-----> Generating anchor peers configuration for '$CHANNEL_3'."
# generate anchor peer transaction
configtxgen -profile Channel-3 -outputAnchorPeersUpdate ./config/Anchors_$CHANNEL_3.tx -channelID $CHANNEL_3 -asOrg TLabel
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org1MSP..."
  exit 1
fi

echo "-----> Updating docker environment."
CA_TLABEL_PRIVATE_KEY=$(ls -f1 ./crypto-config/peerOrganizations/tracelabel.com/ca | grep _sk)
CA_BRAND_1_PRIVATE_KEY=$(ls -f1 ./crypto-config/peerOrganizations/brand-1.com/ca | grep _sk)
CA_BRAND_2_PRIVATE_KEY=$(ls -f1 ./crypto-config/peerOrganizations/brand-2.com/ca | grep _sk)
CA_BRAND_3_PRIVATE_KEY=$(ls -f1 ./crypto-config/peerOrganizations/brand-3.com/ca | grep _sk)
#CA_ORG4_PRIVATE_KEY=$(ls -f1 ./crypto-config/peerOrganizations/org4.example.com/ca | grep _sk)
#CA_ORG5_PRIVATE_KEY=$(ls -f1 ./crypto-config/peerOrganizations/org5.example.com/ca | grep _sk)

# keep original env file
#if [ ! -e  ./.env_orig ]; then
 # cp .env .env_orig
#fi 

cp ./.env_base ./.env
echo CA_TLABEL_PRIVATE_KEY=${CA_TLABEL_PRIVATE_KEY} >> ./.env
echo CA_BRAND_1_PRIVATE_KEY=${CA_BRAND_1_PRIVATE_KEY} >> ./.env
echo CA_BRAND_2_PRIVATE_KEY=${CA_BRAND_2_PRIVATE_KEY} >> ./.env
echo CA_BRAND_3_PRIVATE_KEY=${CA_BRAND_3_PRIVATE_KEY} >> ./.env
#echo CA_ORG4_PRIVATE_KEY=${CA_ORG4_PRIVATE_KEY} >> ./.env
#echo CA_ORG5_PRIVATE_KEY=${CA_ORG5_PRIVATE_KEY} >> ./.env

echo "===> Fabric configuraiton is genereated."