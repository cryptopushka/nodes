# Masa Node
## Минимальный системные требования 

4 core CPU, 4GB RAM 60 GB


## Update system and services to the last version

```
sudo apt update && sudo apt upgrade -y
```

```
sudo apt install curl
```


## Install node
```
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/Masa/install.sh > Masa_install.sh && chmod +x Masa_install.sh && ./Masa_install.sh
```


## Заполняем форму регистрации
```
https://docs.google.com/forms/d/e/1FAIpQLSfHGtGZN-sowOzDUMI7OQe0izxFk2QCRtkZVpRIXN2DDU-GtQ/viewform
```

Чтоб узнать ваш Node enode ID * Необходимо выполнить команду:

```
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc
```
А затем внутри там же выполнить еще одну команду:
```
admin.nodeInfo.enode
```
скопировать значение (в формате как показанно ниже) и вставить в форму .

```
enode://aaf136ec1d53d0980294c838deb4492414e220f0cc60bb62b54bdb6eade1d314afbcbd7257d88e73135e63c07413e8fb538f64e047bea9e9b8ae394d84fc345d@49.161.210.223:30300
```


## После установки проверяем статус и логи.

После установки ноды нужно будет ее проверить через консоль

```
geth attach ipc:$HOME/masa-node-v1.0/data/geth.ipc
```

после того как зашли в консоль вводим команды:

Проверяем синхронизацию

```
eth.syncing
```

Проверяем количество подключенных пиров

```
net.peerCount
```

Если у вас после команды eth.syncing не показывает цифры(высоту блоков) и просто пишет false ничего страшного

У нашей ноды должен быть хотя бы 1 пир для синхронизации, если он есть то все нормально.

## Если у нет пиров.

Внимание!!! прежде чем выполнять следующие команды нужно выйти из консоли ctrl+d

Запускаем скрипт

```
. <(wget -qO- https://raw.githubusercontent.com/usrbad/masa-node-v1.0/main/addbootnode.sh)
```

1.Пишем имя своей ноды (выцепить имя ноды можно командой):

```
cat /etc/systemd/system/masad.service
```

2.Вставляем Бутноду( enode ID другой ноды). К примеру (использовать в реальности этот линк на бутноду не нужно так ссылка уже может устареть)

```
enode://0079da6cb83125552c117d850f32e834eab7ebf77b2c6bf58de99da713c657aa206127258edc483584c935d442f148a8bcf2c376f99bcf5ac7ffc24a0c@127.0.0.1:30300
```

К одной Бутноде могут подключиться 50 нод из за этого нужно искать актуальную бутноду( enode ID) к которому можно подключиться 
Актуальную бутноду( enode ID)можно поискать в чатах в дискорд Masa и собрать несколько и пробовать подключаться.


Команды для управления нодой:

Статус ноды:

```
sudo systemctl status masad
```

Логи ноды:

```
journalctl -n 100 -f -u masad
```

Рестарт ноды:

```
sudo systemctl restart masad
```

Удаление ноды с сервера:

```
systemctl stop masad
```

```
systemctl disable masad
```

```
rm -rf $HOME/masa-node-v1.0
```
