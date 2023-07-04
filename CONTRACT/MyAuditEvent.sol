// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


contract MyAuditEvent {

    struct Audit {
       string url;
       string method;
       string user;
       uint timestamp;
       address  account;
    }

    struct AuditInfo {
        string name;
        Audit[] ad_list;
    }

    mapping(string => AuditInfo) audit_list;

    function put(address account, string[] calldata keys, string[] calldata values) public {
        string memory name;
        string memory url;
        string memory method;
        string memory user;
        for (uint i = 0; i < keys.length; i++) {
            if (keccak256(bytes(keys[i])) == keccak256(bytes('name'))) {
                name = values[i];
            }
            else if (keccak256(bytes(keys[i])) == keccak256(bytes('url'))) {
                url = values[i];
            }
            else if (keccak256(bytes(keys[i])) == keccak256(bytes('method'))) {
                method = values[i];
            }
            else if (keccak256(bytes(keys[i])) == keccak256(bytes('user'))) {
                user = values[i];
            }
        }

        AuditInfo storage ad_info = audit_list[name];
        ad_info.name = name;
        Audit memory ad = Audit(url, method, user, block.timestamp, account); 
        ad_info.ad_list.push(ad);
    }

    function get(string[] calldata keys, string[] calldata values) public view returns(AuditInfo memory){
        // 今回は、取得範囲の指定などはオミット
        string memory name;
        for (uint i = 0; i < keys.length; i++) {
            if (keccak256(bytes(keys[i])) == keccak256(bytes('name'))) {
                name = values[i];
            }
        }
        return audit_list[name];
    }

}