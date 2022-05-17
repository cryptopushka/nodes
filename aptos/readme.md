# Aptos Node
## Minimal system requrments 

2 CPU, 4GB RAM

## Prepare system before node installation
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl
```

## Auto install docker version
```
bash <(curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/aptos/install.sh)
```

## Check node sync status
```
curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version
```

Should be looks like:

```
aptos_state_sync_version{type="applied_transaction_outputs"} 0
aptos_state_sync_version{type="executed_transactions"} 356757
aptos_state_sync_version{type="synced"} 356757
```

## Check full-node logs

```
docker logs -f aptos_testnet-fullnode-1 --tail 100
```

## Check validator logs

```
docker logs -f aptos_testnet-validator-1 --tail 100
```