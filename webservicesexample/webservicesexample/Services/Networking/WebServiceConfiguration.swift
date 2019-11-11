//
//  WebServiceConfiguration.swift
//  webservicesexample
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 11/6/19.
//  Copyright © 2019 aldoBonilla. All rights reserved.
//

import Foundation

let api_key = "api_key"

protocol WebServiceConfiguration {
    var serverURL: String { get }
    var path: String { get }
    var fullPath: String { get }
    var method: WebMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

enum NetworkingError: Error {
    case unsusccessfulResponse(code: Int?)
    case cantCreateEntity(reason: String)
    case unredeableData
    case failed(because: String)
}
