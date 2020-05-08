//
//  MarvelRequests.swift
//  Challenge_Example
//
//  Created by Joao Gabriel Pereira on 08/05/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation


public enum MarvelRequests {
    
    case fetchCharacters(offset: Int, limit: Int, searchName: String?),
    fetchCharacter(characterID: Int),
    fetchComics(characterID: Int),
    fetchSeries(characterID: Int)
    
    public static var domain: String { return "https://gateway.marvel.com:443" }
    
    public func createRequestURL() -> String {
        switch self {

        case let .fetchCharacters(offset, limit, searchName):
            var name = String()
            if let search = searchName, search.isEmpty == false {
                name = "nameStartsWith=\(search)&"
            }
            return "/v1/public/characters?\(name)orderBy=name&limit=\(limit)&offset=\(offset)&\(generateAuthentication())"
        
        case let .fetchCharacter(characterID):
            return "/v1/public/characters/\(characterID)?\(generateAuthentication())"
            
        case let .fetchComics(characterID):
            return "/v1/public/comics?characters=\(characterID)&\(generateAuthentication())"
            
        case let .fetchSeries(characterID):
            return "/v1/public/series?characters=\(characterID)&\(generateAuthentication())"

        }
    }
    
    private func generateAuthentication() -> String {
        let timestamp = "1"
        let apiPrivateKey = "12fdc64385ad40054f84c773588ee2e7c9f0d6af"
        let apiPublicKey = "002326cdaa1631d23bfb6ada5a2d7515"
        let md5 = "\(timestamp)\(apiPrivateKey)\(apiPublicKey)".md5()
        return "ts=\(timestamp)&apikey=\(apiPublicKey)&hash=\(md5)"
    }
}
