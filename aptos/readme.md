# Aptos Node
## Минимальный системные требования 

2 CPU, 4GB RAM

## Install use docker
```
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/aptos/install.sh > aptos_install.sh && chmod +x aptos_install.sh && ./aptos_install.sh
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/aptos/install_full.sh > aptos_install_full.sh && chmod +x aptos_install_full.sh && ./aptos_install_full.sh
```

## update
```
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/aptos/update2.sh > aptos_update.sh && chmod +x aptos_update.sh && ./aptos_update.sh
```



## Install use systemd
```
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/aptos/install_systemd.sh > aptos_install_full.sh && chmod +x aptos_install_full.sh && ./aptos_install_full.sh
```

## update use systemd
```
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/aptos/update_systemd.sh > aptos_update.sh && chmod +x aptos_update.sh && ./aptos_update.sh
```




## Проверяем статус синхронизации
```
curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type
```

Должно выглядеть примерно так:

```
aptos_state_sync_version{type="committed"} 210245
aptos_state_sync_version{type="highest"} 210245
aptos_state_sync_version{type="synced"} 210245
aptos_state_sync_version{type="target"} 210246
```

## Посмотреть логи

```
docker logs -f aptos-fullnode-1 --tail 5000
```
