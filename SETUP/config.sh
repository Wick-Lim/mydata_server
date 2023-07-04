# システム構成情報をMySQLに登録する


## InfluxDB
python ../LIB/setinfluxdb.py --id InfluxDB --name "My InfluxDB" --token "jG99-jU4YqMZixUN3IGoBCdQ7iAbekCXPkaM2SEvHXt0lXEQKMDkJppaiXYn66bnsOuaEDZ323k1p3EYIHw-zg=="

## #thereum
python ../LIB/setethereum.py --id Ethereum --name "Etherem private net" --account 0x70f9e0445a572d62eabf6d6669f69283558d7e2f --password dataprovider --privatekey c2f7b10487844a8d0f708a2397a63e0aa2b2695351775fe5548557bc71280e28 --address 192.168.3.3

## MinIO
python ../LIB/setminio.py --id MinIO --name "Storage(MinIO)" --access_key_id admin  --secret_access_key admin001

