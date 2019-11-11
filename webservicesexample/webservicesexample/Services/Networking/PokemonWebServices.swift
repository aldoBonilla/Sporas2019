//
//  PokemonWebServices.swift
//  webservicesexample
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 11/6/19.
//  Copyright © 2019 aldoBonilla. All rights reserved.
//

import Foundation

let pokemonApiUrl = "https://pokeapi.co/api/v2/"

enum PokemonWebServices: WebServiceConfiguration {
    
    case pokemonList(page: Int)
    case pokemonBy(name: String)
    case typeBy(name: String)
    
    var serverURL: String { return pokemonApiUrl }
    
    var path: String {
        switch self {
        case .pokemonList(let page): return "pokemon/?offset=\(page)"
        case .pokemonBy(let name): return "pokemon/\(name)"
        case .typeBy(let name): return "type/\(name)"
        }
    }
    
    var fullPath: String { return "\(serverURL)\(path)" }
    
    var method: WebMethod { return .get }
    
    var parameters: [String : Any]? { return nil }
    
    var headers: [String : String]? { return nil }
    
}

struct PokemonRequests {
    
    static func getPokemonList(page: Int, completion: @escaping((_ pokemons: [NameUrl]?, _ error: Error?) -> Void )) {
        
        /// This parameter cannot be sent in service so it stays as a constant
        let elementsPerPage = 20
        
        let pokemonList = PokemonWebServices.pokemonList(page: page * elementsPerPage)
        
        WSWrapper.shared.callService(url: pokemonList.fullPath, method: pokemonList.method, parameters: pokemonList.parameters) { data, error in

            if let errorWS = error {
                print(errorWS.localizedDescription)
                completion(nil, errorWS)
            }
            
            if let jsonData = data {
                do {
                    let pokemonsListResponse = try JSONDecoder().decode(PokemonListResponse.self, from: jsonData)
                    completion(pokemonsListResponse.results, nil)
                } catch {
                    completion(nil, NetworkingError.cantCreateEntity(reason: "Data was unreadable"))
                }
            } else {
                completion(nil, NetworkingError.cantCreateEntity(reason: "Data was unreadable"))
                print("Cannot Serialize JSON")
            }
        }
    }
    
    static func getPokemonBy(name: String, completion: @escaping((_ pokemon: Pokemon?, _ error: Error?) -> Void)) {
        
        let getPokemon = PokemonWebServices.pokemonBy(name: name)
        
        WSWrapper.shared.callService(url: getPokemon.fullPath, method: getPokemon.method, parameters: getPokemon.parameters) { data, error in
            if let errorWS = error {
                print(errorWS.localizedDescription)
                completion(nil, errorWS)
            }
            
            if let jsonData = data {
                do {
                    let pokemonByIdResult = try JSONDecoder().decode(Pokemon.self, from: jsonData)
                    completion(pokemonByIdResult, nil)
                } catch {
                    completion(nil, NetworkingError.cantCreateEntity(reason: "Data was unreadable"))
                }
            } else {
                completion(nil, NetworkingError.cantCreateEntity(reason: "Data was unreadable"))
                print("Cannot Serialize JSON")
            }
        }
    }
    
    static func getTypeBy(name: String, completion: @escaping((_ type: PokemonType?, _ error: Error?) -> Void)) {
        
        let getType = PokemonWebServices.typeBy(name: name)
        
        WSWrapper.shared.callService(url: getType.fullPath, method: getType.method, parameters: getType.parameters) { data, error in
            if let errorWS = error {
                print(errorWS.localizedDescription)
                completion(nil, errorWS)
            }
            
            if let jsonData = data {
                do {
                    let typeByNameResult = try JSONDecoder().decode(PokemonType.self, from: jsonData)
                    completion(typeByNameResult, nil)
                } catch {
                    completion(nil, NetworkingError.cantCreateEntity(reason: "Data was unreadable"))
                }
            } else {
                completion(nil, NetworkingError.cantCreateEntity(reason: "Data was unreadable"))
                print("Cannot Serialize JSON")
            }
        }
    }
}

