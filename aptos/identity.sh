#!/bin/bash
echo "=================================================="
echo -e "\033[0;35m"
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/cp.sh | bash
echo -e "\e[0m"
echo "=================================================="

echo -e "\e[1m\e[32mExtracting node identity details \e[0m"

if [ -f $HOME/aptos/identity/private-key.txt ]
then
    ID=$(sed -n 5p $HOME/aptos/identity/peer-info.yaml | sed 's/    - \(.*\)./\1/')
    PRIVATE_KEY=$(cat $HOME/aptos/identity/private-key.txt)
    echo -en "\n"
    if [ ! -f $HOME/aptos/identity/peer-info.yaml ]
    then
        echo "---
"$ID":
  addresses: []
  keys:
    - "$ID"
  role: Downstream" > $HOME/aptos/identity/peer-info.yaml
    fi
    echo "=================================================="
    echo -e "\e[1m\e[32m1. peer-info.yaml file content \e[0m"
    echo -en "\n"
    cat $HOME/aptos/identity/peer-info.yaml
    echo -en "\n"
    echo "=================================================="
    echo -e "\e[1m\e[32m2. Your upstream peer details. You can share your peer info with other users \e[0m"
    echo -e '
'$ID':
    addresses:
    - "/ip4/'$(ip route get 8.8.8.8 | sed -n "/src/{s/.*src *\([^ ]*\).*/\1/p;q}")'/tcp/6180/ln-noise-ik/'$ID'/ln-handshake/0"
    role: "Upstream"'
    echo -en "\n"
    echo "=================================================="
    echo -e "\e[1m\e[32m3. Your identity details \e[0m"
    echo -en "\n"
    echo -e "\e[1m\e[32mPeer Id: \e[0m" $ID
    echo -e "\e[1m\e[32mPublic Key: \e[0m" $ID
    echo -e "\e[1m\e[32mPrivate Key:  \e[0m" $PRIVATE_KEY
    echo -en "\n"
else
    echo -e "\e[1m\e[32mCan't find required identity files: "$HOME/aptos/identity"  \e[0m"
fi