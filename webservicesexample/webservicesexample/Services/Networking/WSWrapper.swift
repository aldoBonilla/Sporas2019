//
//  WSWrapper.swift
//  webservicesexample
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 11/6/19.
//  Copyright © 2019 aldoBonilla. All rights reserved.
//

import Foundation

enum WebMethod: String {
    case options, get, head, post, put, patch, delete, trace, connect
}

///Common Dictionary the value cannot be nil, used for parameters in web services
typealias BasicDictionary = Dictionary<String, Any>

///Common Dictionary for encoding decoding service entities
typealias EntityDictionary = Dictionary<String, Any?>

class WSWrapper {
    
    static let shared = WSWrapper()
    
    /**
     It calls a remote endpoint executing a code block with data or error depending on the response
     Parameters:
     -url: Remote endpoint url
     -method: the verb for the endpoint from the webMethod enum
     -parameters: the parameters for the webservice
     -param_encoding: if it is url encoded or as a json, if nil is assumed to be url encoded
     -headers: web services headers can be nil
     */
    
    func callService(url: String, method: WebMethod, parameters: BasicDictionary?, headers: [String: String]? = nil, onCompletion: @escaping((_ response: Data?, _ error: Error?) -> Void )) {
        
        guard let urlRequest = URL(string: url) else {
            onCompletion(nil, NetworkingError.unredeableData)
            return
        }
        
        let request = NSMutableURLRequest(url: urlRequest)
        
        request.httpMethod = method.rawValue.uppercased()
        request.allHTTPHeaderFields = headers
        
        if let parametersBody = parameters {
            guard let postData = try? JSONSerialization.data(withJSONObject: parametersBody, options: []) else {
                onCompletion(nil, NetworkingError.unredeableData)
                return
            }
            request.httpBody = postData
        }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            if let errorWS = error {
                onCompletion(nil, NetworkingError.failed(because: errorWS.localizedDescription))
            } else {
                guard let jsonData = data else {
                    onCompletion(nil, NetworkingError.unredeableData)
                    return
                }
                onCompletion(jsonData, nil)
            }
        })
        dataTask.resume()
    }
    
    func downloadImage(from url: String, completion: @escaping ((Data?, URLResponse?, Error?) -> Void)) {
        guard let urlRequest = URL(string: url) else {
            completion(nil, nil, NetworkingError.unredeableData)
            return
        }
        URLSession.shared.dataTask(with: urlRequest, completionHandler: completion).resume()
    }
}
