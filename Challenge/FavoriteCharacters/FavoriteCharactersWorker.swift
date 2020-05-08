//
//  FavoriteCharactersWorker.swift
//  Challenge
//
//  Created by Joao Gabriel Pereira on 06/05/20.
//

import JewFeatures
protocol FavoriteCharactersWorkerInterface {
    func fetchCharacters(searchText: String?, successCompletion: @escaping (([Character]) -> ()), errorCompletion: @escaping ((String) -> ()))
}

class FavoriteCharactersWorker: FavoriteCharactersWorkerInterface {
    
    func fetchCharacters(searchText: String?, successCompletion: @escaping (([Character]) -> ()), errorCompletion: @escaping ((String) -> ())) {
        CharactersConstants.favoritesKeyUserDefaults.getInDefaults() { (favorites: [Character]?) in
            guard let favorites = favorites, favorites.count > 0 else {
                errorCompletion(FavoriteCharactersConstants.noFavorites)
                return
            }
            if let searchText = searchText, searchText.isEmpty == false {
                let filteredCharactes = favorites.filter { ($0.name?.contains(searchText) ?? false) }
                if filteredCharactes.count > 0 {
                    successCompletion(filteredCharactes)
                    return
                }
                errorCompletion(FavoriteCharactersConstants.noFilteredFavorites)
                return
            }
            successCompletion(favorites)
        }
    }
}
