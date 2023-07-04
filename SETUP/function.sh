#　ファンクション登録

TOP=$HOME/Desktop/tsuyo/CQ/mydata_server/
TOOL=$TOP/LIB

export PYTHONPATH=$TOP/LIB:$TOP/APP:$PYTHONPATH
export MYDATASERVER_APP_CONFIG_PATH=$TOP/APP
export MYDATASERVER_LIB_CONFIG_PATH=$TOP/LIB


### アドレスとABIの定義 ###
# MyDataStore
MyDataStore_ADDR='0x61031415293772674Cabc0435e8981C3e8C7e800'
MyDataStore_ABI='[
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "channel",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "measurement",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "timestamp",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "data",
				"type": "string"
			}
		],
		"name": "put_data",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "channel",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "measurement",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "start",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "stop",
				"type": "uint256"
			}
		],
		"name": "get_data",
		"outputs": [
			{
				"components": [
					{
						"internalType": "string[]",
						"name": "data",
						"type": "string[]"
					},
					{
						"internalType": "string[]",
						"name": "timestamp",
						"type": "string[]"
					}
				],
				"internalType": "struct MyDataStore.Measurement",
				"name": "",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "channel",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "measurement",
				"type": "string"
			}
		],
		"name": "get_data_num",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]'


# MyAuditEvent
MyAuditEvent_ADDR='0x2821Accb896e6170EA1ee292243Ee8B8EA53C2d6'
MyAuditEvent_ABI='[
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "account",
				"type": "address"
			},
			{
				"internalType": "string[]",
				"name": "keys",
				"type": "string[]"
			},
			{
				"internalType": "string[]",
				"name": "values",
				"type": "string[]"
			}
		],
		"name": "put",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string[]",
				"name": "keys",
				"type": "string[]"
			},
			{
				"internalType": "string[]",
				"name": "values",
				"type": "string[]"
			}
		],
		"name": "get",
		"outputs": [
			{
				"components": [
					{
						"internalType": "string",
						"name": "name",
						"type": "string"
					},
					{
						"components": [
							{
								"internalType": "string",
								"name": "url",
								"type": "string"
							},
							{
								"internalType": "string",
								"name": "method",
								"type": "string"
							},
							{
								"internalType": "string",
								"name": "user",
								"type": "string"
							},
							{
								"internalType": "uint256",
								"name": "timestamp",
								"type": "uint256"
							},
							{
								"internalType": "address",
								"name": "account",
								"type": "address"
							}
						],
						"internalType": "struct MyAuditEvent.Audit[]",
						"name": "ad_list",
						"type": "tuple[]"
					}
				],
				"internalType": "struct MyAuditEvent.AuditInfo",
				"name": "",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]'


# MyPhotoNFT
MyPhotoNFT_ADDR=''
MyPhotoNFT_ABI=''



### DB登録処理 ###
$TOOL/setfunc.py --id MyDataStore --name "data store contract" --address $MyDataStore_ADDR --abi "$MyDataStore_ABI"
$TOOL/setfunc.py --id MyAuditEvent --name "audit event contract" --address $MyAuditEvent_ADDR --abi "$MyAuditEvent_ABI"
#$TOOL/setfunc.py --id MyPhotoNFT --name "NFT contract" --address $MyPhotoNFT_ADDR --abi "$MyPhotoNFT_ABI"
