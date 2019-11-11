//
//  MovieWebServices.swift
//  webservicesexample
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 11/8/19.
//  Copyright © 2019 aldoBonilla. All rights reserved.
//

import Foundation

let movieServerURL = "https://api.themoviedb.org/3"
let imdbResourcesURL = "https://image.tmdb.org/t/p/original"
let imdbKey = "1f54bd990f1cdfb230adb312546d765d"
let deviceLang = Locale.current.languageCode ?? "en-US"

enum MovieWebServices: WebServiceConfiguration {
    
    case nowPlaying(lang: String, page: Int)
    case detail(id: Int, lang: String)
    case requestToken
    case validateTokenWithLogin(user: String, password: String, token: String)
    case createSession(validatedToken: String)
    case likeMovie(id: Int)
    
    var serverURL: String { return movieServerURL }
    
    var path: String {
        switch self {
        case .nowPlaying: return "/movie/now_playing"
        case .detail(let id, _): return "/movie/\(id)"
        case .requestToken: return "/authentication/token/new"
        case .validateTokenWithLogin: return "/authentication/token/validate_with_login"
        case .createSession: return "/authentication/session/new"
        case .likeMovie: return "/account/favorite"
        }
    }
    
    var fullPath: String { return "\(serverURL)\(path)?\(api_key)=\(imdbKey)"}
    
    var method: WebMethod {
        switch self {
        case .nowPlaying, .detail, .requestToken: return .get
        case .validateTokenWithLogin, .createSession, .likeMovie: return .post
        }
        
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .validateTokenWithLogin(let user, let password, let token):
            return [
                "username": user,
                "password": password,
                "request_token": token
            ]
        case .createSession(let validatedToken): return ["request_token": validatedToken]
        case .likeMovie(let id): return ["media_type": "movie", "media_id": id, "favorite": true]
        default: return nil
        }
    }
    
    var headers: [String : String]? { return nil }
}

struct MovieRequests {
    
    static func getNowPlaying(page: Int = 1, completion: @escaping((_ response: MoviesResponse?, _ error: Error?) -> Void)) {
        
        let nowPlayingRequest = MovieWebServices.nowPlaying(lang: deviceLang, page: page)
        
        WSWrapper.shared.callService(url: nowPlayingRequest.fullPath, method: nowPlayingRequest.method, parameters: nowPlayingRequest.parameters) { data, error in
            if let errorWeb = error {
                completion(nil, errorWeb)
            } else {
                do {
                    let moviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: data!)
                    completion(moviesResponse, nil)
                } catch {
                    completion(nil, NetworkingError.unredeableData)
                }
            }
        }
    }
    
    private static func requestToken(completion: @escaping((_ token: Token?,_ error: Error?) -> Void)) {
        
        let requestToken = MovieWebServices.requestToken
        WSWrapper.shared.callService(url: requestToken.fullPath, method: requestToken.method, parameters: requestToken.parameters) { data, error in
            if let errorWeb = error {
                completion(nil, errorWeb)
            } else {
                do {
                    let tokenResponse = try JSONDecoder().decode(Token.self, from: data!)
                    completion(tokenResponse, nil)
                } catch {
                    completion(nil, NetworkingError.unredeableData)
                }
            }
        }
    }
    
    private static func validateLogin(user: String, password: String, token: String, completion: @escaping((_ token: ValidationTokenResponse?,_ error: Error?) -> Void)) {
        
        let validateLogin = MovieWebServices.validateTokenWithLogin(user: user, password: password, token:
        token)
        
        WSWrapper.shared.callService(url: validateLogin.fullPath, method: validateLogin.method, parameters: validateLogin.parameters) { data, error in
            if let errorWeb = error {
                completion(nil, errorWeb)
            } else if let dataWS = data {
                do {
                    let validationResponse = try JSONDecoder().decode(ValidationTokenResponse.self, from: dataWS)
                    completion(validationResponse, nil)
                } catch {
                    completion(nil, NetworkingError.unredeableData)
                }
            }
        }
    }
    
    private static func createSession(validatedToken: String, completion: @escaping((_ token: Session?,_ error: Error?) -> Void)) {
        
        let createSession = MovieWebServices.createSession(validatedToken: validatedToken)
        
        WSWrapper.shared.callService(url: createSession.fullPath, method: createSession.method, parameters: createSession.parameters) { data, error in
            if let errorWeb = error {
                completion(nil, errorWeb)
            } else if let dataWS = data  {
                do {
                    let sessionResponse = try JSONDecoder().decode(Session.self, from:dataWS)
                    completion(sessionResponse, nil)
                } catch {
                    completion(nil, NetworkingError.unredeableData)
                }
            }
        }
    }
}
