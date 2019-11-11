//
//  Pokemon.swift
//  webservicesexample
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 11/6/19.
//  Copyright © 2019 aldoBonilla. All rights reserved.
//

import Foundation

/// Type for tableview controller
typealias PokemonTupple = (name: String, id: Int)

struct Pokemon: CustomStringConvertible, Decodable {
    
    let name: String
    let id: Int
    let weight: Int
    let height: Int
    let moves: [PokemonMove]
    let types: [PokemonType]
    let sprites: PokemonSprite
    
    var description: String {
        return "\(name) with id: \(id)"
    }
}

struct PokemonSprite: CustomStringConvertible, Decodable {
    
    let backDefault: String
    let backFemale: String?
    let backShiny: String
    let backShinyFemale: String?
    let frontDefault: String
    let frontFemale: String?
    let frontShiny: String
    let frontShinyFemale: String?
    
    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
    }
    
    var description: String {
        return "A lot of sprites"
    }
    
    var createArrayOfSprites: [String] {
        var allNonNullSprites = [backDefault, backShiny, frontDefault, frontShiny]
        if let backF = self.backFemale { allNonNullSprites.append(backF) }
        if let backSF = self.backShinyFemale { allNonNullSprites.append(backSF) }
        if let frontF = self.frontFemale { allNonNullSprites.append(frontF) }
        if let frontSF = self.frontShinyFemale { allNonNullSprites.append(frontSF) }
        return allNonNullSprites
    }
}
