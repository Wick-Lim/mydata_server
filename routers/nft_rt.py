#!/usr/bin/env python
# -*- coding: utf-8 -*-


import sys
import json

from fastapi import APIRouter, File
from fastapi.responses import Response
from pydantic import BaseModel
from typing import Union, List, Optional

from LIB import db
from LIB import ethereum


DEBUG = False # True

router = APIRouter(
    prefix="/MyNFT",
    tags=["mynft"],
)

# Ethereumへのアクセス情報取得
s = db.DB()
eth_rec = s.select(db.DsEthereum, "Ethereum")
if DEBUG : print("eth_rec=",eth_rec)
if eth_rec != None:
    url = "http://" + eth_rec.address + ":" + str(eth_rec.port)
    account = eth_rec.account
    password = eth_rec.password
    private_key = eth_rec.private_key
else:
    url = "http://192.168.3.3:8545"
    account = "0x70f9e0445a572d62eabf6d6669f69283558d7e2f"
    password = "dataprovider"
    private_key = "c2f7b10487844a8d0f708a2397a63e0aa2b2695351775fe5548557bc71280e28"

if DEBUG:
    print("url = ", url)
    print("account = ", account)
    print("password = ", password)
    print("private_key = ", private_key)
    
eth = ethereum.Ethereum(url, account, password, private_key)

# コントラクト設定
func_rec = s.select(db.DsFunction, "MyPhotoNFT")
print("func_rec = ", func_rec)
if func_rec:
    ADDR=func_rec.address
    ABI=func_rec.abi
    # コントラクトの実行準備
    eth.set_event_contract('MyPhotoNFT', ADDR, ABI)
                

@router.get("/token/{token_id}")
async def get_token_meta(token_id: str, account: str = None, user: str = None):
    print("get_token_meta", token_id, account, user)
    # NFTトークンのメタ情報取得
    params = {}
    params['method'] = "GET"
    params['tokenid'] = token_id
    if user:
        params['user'] = user
    params['mode'] = 'meta'
    if account:
        params['account'] = account

    print("get_token_meta: param: ", params)
    r = eth.get_event_contract('MyPhotoNFT', params)
    print("get_token_meta: r: ", r)
    res = json.loads(r)
    return res

@router.options("/token/{token_id}")
async def options_nft(token_id: str, account: str = None, user: str = None, action: str = None):
    print("options_nft", token_id, account, user, action)

    params = {}
    params['method'] = "OPTIONS"
    params['tokenid'] = token_id
    if user:
        params['user'] = user
    if account:
        params['account'] = account
    if action:
        params['mode'] = action

    eth.put_event_contract('MyPhotoNFT', account, params)
    res = {"Status":"OK","Res":""}
    return res

