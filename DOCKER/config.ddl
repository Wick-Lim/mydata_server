use mydataserver;

INSERT into ds_influxdb (id,name,address,port,token,organization) values ("InfluxDB","My InfluxDB","influxdb",8086,"jG99-jU4YqMZixUN3IGoBCdQ7iAbekCXPkaM2SEvHXt0lXEQKMDkJppaiXYn66bnsOuaEDZ323k1p3EYIHw-zg==","MyDataServer");
INSERT into ds_storage (id,name,address,port,access_key_id,secret_access_key) values ("MinIO","Storage(MinIO)","minio",9000,"minioadmin","minioadmin");
INSERT into ds_ethereum (id,name,address,port,account,password,private_key) values ("Ethereum","Etherem private net","ethereum",8545,"0x6015375f653d7b6b95ef36b0068f7425849256b8","dataprovider","66e069d992f1be7653cb375dc33adb2dc6df47e358e3254a91cf3e9b0d963a13");

