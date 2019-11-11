//
//  PokemonType.swift
//  webservicesexample
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 11/6/19.
//  Copyright © 2019 aldoBonilla. All rights reserved.
//

import Foundation

struct PokemonType: Decodable {
    
    let slot: Int
    let type: NameUrl
}

