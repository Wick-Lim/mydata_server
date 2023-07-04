// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./MyERC721.sol";

contract MyPhotoNFT is MyERC721 {
    using Strings for uint256;
    using Strings for address;
    using Address for address;
    using Counters for Counters.Counter;
    Counters.Counter private _token_ids;

    // トークンのメタ情報
    struct MyTokenInfo {
        string  name;
        string  path;
        address creator;    // トークン発行者
    }

    MyTokenInfo[] token_list;                   // 発行したトークンのリスト
    mapping(string => uint256) path2tokenid;    // ファイルのパスとトークンIDの対応表
    
    struct Param {
        string name;
        string url;
        string method;
        string user;
        string mode;
        uint256 token_id;
        string account;
    }

    // パラメータを解析
    function parse_param(string[] calldata keys, string[] memory values) private pure returns(Param memory) {
        Param memory param;
        for (uint i = 0; i < keys.length; i++) {
            if (keccak256(bytes(keys[i])) == keccak256(bytes('name'))) {
                param.name = values[i];
            }
            else if (keccak256(bytes(keys[i])) == keccak256(bytes('url'))) {
                param.url = values[i];
            }
            else if (keccak256(bytes(keys[i])) == keccak256(bytes('method'))) {
                param.method = values[i];
            }
            else if (keccak256(bytes(keys[i])) == keccak256(bytes('user'))) {
                param.user = values[i];
            }
            else if (keccak256(bytes(keys[i])) == keccak256(bytes('tokenid'))) {
                param.token_id = toNum(values[i]);
            }
            else if (keccak256(bytes(keys[i])) == keccak256(bytes('account'))) {
                param.account = values[i];
            }
             else if (keccak256(bytes(keys[i])) == keccak256(bytes('mode'))) {
                param.mode = values[i];
            }
        }
        return param;
    }

    // 更新系処理
    function put(address account, string[] calldata keys, string[] memory values) public {
        uint256 new_token_id;
        Param memory p = parse_param(keys, values);

        if (keccak256(bytes(p.method)) == keccak256(bytes('POST'))){
            //トークン発行 
            uint256 token_id = path2tokenid[p.url];
            if (token_id == 0) {
                _token_ids.increment();
                new_token_id = _token_ids.current();
                _safeMint(account, new_token_id);
                if (account != _msgSender()) {
                    _setApprovalForAll(account, _msgSender(), true);
                    _approve(_msgSender(), new_token_id); //リクエスト実行アカウントも操作可能
                }
                MyTokenInfo memory t = MyTokenInfo(p.name, p.url, account);
                path2tokenid[p.url] = new_token_id;
                token_list.push(t);
            }
        }
        else if (keccak256(bytes(p.method)) == keccak256(bytes('DELETE'))) {
            //トークン焼却
            uint256 token_id = path2tokenid[p.url];
            if (token_id > 0) {
                _burn(token_id);
            }            
        }
        else if (keccak256(bytes(p.method)) == keccak256(bytes('GET'))) {
            //トークン取得
            uint256 token_id = path2tokenid[p.url];
            if (token_id > 0) {
                MyTokenInfo memory t = token_list[token_id-1];
                // 貸出処理
                if (keccak256(bytes(ownerOf(token_id).toHexString())) == keccak256(bytes(t.creator.toHexString()))) {
                    // 誰も取得していない
                    _safeTransfer(ownerOf(token_id), account, token_id,"");
                    //safeTransferFrom(ownerOf(token_id), account, token_id);
                    if (account != _msgSender()) {
                        _setApprovalForAll(account, _msgSender(), true);
                        _approve(_msgSender(), token_id); //リクエスト実行アカウントも操作可能
                    }
                }
                else {
                     balanceOf(address(0));   // エラーになる（デバッグよう）                   
                }
            }
            else {
                _mint(address(0), 0);   // エラーになる（デバッグよう）
            }
        }
        else if (keccak256(bytes(p.method)) == keccak256(bytes('OPTIONS'))) {            // トークン返却
            uint256 token_id = path2tokenid[p.url];
            if (token_id == 0) {
                token_id = p.token_id;
            }
            // トークン返却
            if (token_id > 0 && (keccak256(bytes(p.mode)) == keccak256(bytes('release')))) {
                MyTokenInfo memory t = token_list[token_id-1];
                if (keccak256(bytes(ownerOf(token_id).toHexString())) != keccak256(bytes(t.creator.toHexString()))) {
                //if (ownerOf(token_id) != t.creator) {
                    _safeTransfer(ownerOf(token_id), t.creator, token_id, "");
                }
            }           
        }

    }

    struct TokenMeta {
        string name;
        string description;
        string image;
    }
    // 参照系処理
    function get(string[] calldata keys, string[] calldata values) public view returns(string memory){
        string memory res;
        Param memory p = parse_param(keys, values); 

        if (keccak256(bytes(p.mode)) == keccak256(bytes('meta'))) {
            // トークンのメタ情報を返す
            res = "";
            if (p.token_id > 0) {
                MyTokenInfo memory t = token_list[p.token_id-1];
                string memory img = string(abi.encodePacked(_server_url, t.path));
                string memory name = string(abi.encodePacked("Photo No.",p.token_id.toString()));
                string memory desc = string(abi.encodePacked("My Photo Library NFT No.",p.token_id.toString()));
                res = string(abi.encodePacked('{"name": "', name, '","description":"',desc,'","image":"',img,'"}'));
             }
        }
        else if (keccak256(bytes(p.mode)) == keccak256(bytes('tokenid'))) {
            uint256 token_id = path2tokenid[p.url];
            res = token_id.toString();
        }
        else if (keccak256(bytes(p.mode)) == keccak256(bytes('owned'))) {
            // トークンの所有権を持っているか確認
            uint256 token_id = path2tokenid[p.url];
            res = string(abi.encodePacked('{"status": 403,"data":{"RES":"No token of ', p.url, '"}}'));
            if (token_id > 0) {
                res = string(abi.encodePacked('{"status": 403,"data":{"RES":"Not have token of this Photo. ',ownerOf(token_id).toHexString() ,' - ',p.account,'"}}'));
                if (keccak256(bytes(ownerOf(token_id).toHexString())) == keccak256(bytes(p.account))) {
                    res = string(abi.encodePacked('{"status": 0,"data":{"RES":"Owned"}}'));
                }
            }
        }
        else if (keccak256(bytes(p.mode)) == keccak256(bytes('info'))) {
            uint256 token_id = p.token_id;
            if (token_id > 0) {
                MyTokenInfo memory t = token_list[token_id-1];
                res = string(abi.encodePacked(p.token_id.toString(),":",t.creator.toHexString(), ":", t.path, ":", t.name));
            }
        }
        return res;
    }

    /*
    以下のサイトから持ってきた数値変換処理
    https://stackoverflow.com/questions/68976364/solidity-converting-number-strings-to-numbers
    */
    function toNum(string memory num) public pure returns(uint) {
        uint  val=0;
        bytes   memory stringBytes = bytes(num);
        for (uint  i =  0; i<stringBytes.length; i++) {
            uint exp = stringBytes.length - i;
            bytes1 ival = stringBytes[i];
            uint8 uval = uint8(ival);
           uint jval = uval - uint(0x30);
   
           val +=  (uint(jval) * (10**(exp-1))); 
        }
      return val;
    }

}