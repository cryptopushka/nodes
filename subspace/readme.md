# Subspace Node

## Минимальные системные требования 

2 CPU, 2 GB RAM, 50 GB SSD


## Install Soft
```
sudo apt install curl -y
```


## Install Node
```
wget -O subspace.sh https://raw.githubusercontent.com/cryptopushka/nodes/main/subspace/install.sh && chmod +x subspace.sh && ./subspace.sh
```

## Additional commands
Check node logs:
```
journalctl -u subspaced -f -o cat
```

Check farmer logs:
```
journalctl -u subspaced-farmer -f -o cat
```

Restart node:
```
sudo systemctl restart subspaced
```

Restart farmer:
```
sudo systemctl restart subspaced-farmer
```

Delete node:
```
sudo systemctl stop subspaced subspaced-farmer
sudo systemctl disable subspaced subspaced-farmer
rm -rf ~/.local/share/subspace*
rm -rf /etc/systemd/system/subspaced*
rm -rf /usr/local/bin/subspace*
```