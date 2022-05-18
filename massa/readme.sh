# Massa Node

## Минимальный системные требования 

4 core CPU, 4GB RAM 100 GB

## Update system and services to the last version

```
sudo apt update && sudo apt upgrade -y
```

```
sudo apt install curl
```


## Install node
```
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/massa/install.sh | bash
```

## Backup system files after node installed

Using winSCP client copy file from this directories to local PC

/root/massa/massa-node/config/node_privkey.key
/root/massa/massa-client/wallet.dat
