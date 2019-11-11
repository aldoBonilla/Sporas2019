//
//  NameUrl.swift
//  webservicesexample
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 11/6/19.
//  Copyright © 2019 aldoBonilla. All rights reserved.
//

import Foundation

struct NameUrl: CustomStringConvertible, Decodable {
    let name: String
    let url: String
    
    var description: String {
        return "this item name: \(name) with url: \(url)"
    }
}
