//
//  Token.swift
//  webservicesexample
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 11/8/19.
//  Copyright © 2019 aldoBonilla. All rights reserved.
//

import Foundation

struct Token: Decodable {
    
    let success: Bool
    let expires: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expires = "expires_at"
        case token = "request_token"
    }
}

struct ValidationTokenResponse: Decodable {
    
    let success: Bool
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case token = "request_token"
    }
}

struct Session: Decodable {
    
    let success: Bool
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case id = "session_id"
    }
}

