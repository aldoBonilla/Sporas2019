//
//  PokemonMove.swift
//  webservicesexample
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 11/6/19.
//  Copyright © 2019 aldoBonilla. All rights reserved.
//

import Foundation

struct PokemonMove: Decodable {
    let move: NameUrl
    let versionDetails: [MoveVersionDetails]
    
    enum CodingKeys: String, CodingKey {
        case move
        case versionDetails = "version_group_details"
    }
}

struct MoveVersionDetails: Decodable {
    let levelLearnedAt: Int
    let learnedMethod: NameUrl
    let versionGroup: NameUrl
    
    enum CodingKeys: String, CodingKey {
        case levelLearnedAt = "level_learned_at"
        case learnedMethod = "move_learn_method"
        case versionGroup = "version_group"
    }
}
