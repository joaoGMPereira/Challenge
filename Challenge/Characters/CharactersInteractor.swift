//
//  CharactersInteractor.swift
//  Challenge
//
//  Created by Joao Gabriel Pereira on 06/05/20.
//

import UIKit
import JewFeatures

protocol CharactersInteractorInterface {
    
    var characters: [Character] { get set }
    var searchName: String { get set }
    func fetchCharacters(searchName: String)
    func fetchCharacters()
    func updateFavoriteCharacters()
    func refreshCharacters()
    
    func addFavorite(with id: Int, and image: UIImage?)
    func removeFavorite(with id: Int)
    
}

class CharactersInteractor: CharactersInteractorInterface {
    
    //MARK: Properties
    var characters = [Character]()
    var searchName = String()
    var presenter: CharactersPresenterInterface?
    var worker: CharactersWorkerInterface = CharactersWorker()
    
    private var offset = 0
    private var hasMore = true
    private var isLoading = false
    private let pageSize = 20
    
    func fetchCharacters() {
        checkGetCharacters(searchName: self.searchName, hasChangedSearch: false)
    }
    
    func fetchCharacters(searchName: String) {
        let hasChangeSearch = self.searchName != searchName
        self.searchName = searchName 
        checkGetCharacters(searchName: searchName, hasChangedSearch: hasChangeSearch)
    }
    
    func refreshCharacters() {
        self.offset = 0
        hasMore = true
        characters = [Character]()
        checkGetCharacters(searchName: self.searchName, hasChangedSearch: false)
    }
    
    func checkGetCharacters(searchName: String?, hasChangedSearch: Bool) {
        if JEWReachability.recheability.check() {
            let enableToGetCharacters = (hasMore && !isLoading) || hasChangedSearch
            if enableToGetCharacters {
                getCharacters(searchName: searchName, hasChangedSearch: hasChangedSearch)
            }
            return
        }
        presenter?.presentDisconnected()
    }
    
    private func getCharacters(searchName: String?, hasChangedSearch: Bool) {
        if hasChangedSearch {
            self.offset = 0
        }
        self.isLoading = true
        worker.fetchCharacters(offset: offset, limit: pageSize, searchName: searchName, successCompletion: { (charactersResult) in
            self.successCompletion(charactersResult: charactersResult, hasChangedSearch: hasChangedSearch)
        }) { (connectorError) in
            self.isLoading = false
            self.presenter?.present(connectorError: connectorError)
        }
        
    }
    
    private func successCompletion(charactersResult: CharactersResult, hasChangedSearch: Bool) {
        self.isLoading = false
        self.offset += self.pageSize
        self.hasMore = self.offset < (charactersResult.data?.total ?? 0) && (charactersResult.data?.results?.count ?? 0) == self.pageSize
        if let newCharacters = charactersResult.data?.results {
            if hasChangedSearch {
                self.characters = newCharacters
            } else {
                self.characters.append(contentsOf: newCharacters)
            }
        }
        updateFavorites()
        self.presenter?.present(characters: characters)
    }
    
    private func updateFavorites() {
        CharactersConstants.favoritesKeyUserDefaults.getInDefaults() { (favoriteCharacters: [Character]?) in
            self.updateRemovedFavorites(favoriteCharacters: favoriteCharacters)
            self.updateAddedFavorites(favoriteCharacters: favoriteCharacters)
            
        }
    }
    
    private func updateAddedFavorites(favoriteCharacters: [Character]?) {
        favoriteCharacters?.forEach({ (favorited) in
            if let index = self.characters.firstIndex(where: {$0.id == favorited.id}), self.characters.count > index {
                self.characters[index] = favorited
            }
        })
    }
    
    private func updateRemovedFavorites(favoriteCharacters: [Character]?) {
        self.characters.forEach { (character) in
            if let index = self.characters.firstIndex(where: {$0.id == character.id}), self.characters.count > index {
                let updateNotFavoriteCharacter = Character.init(with: character, isFavorited: false, imagePath: nil)
                self.characters[index] = updateNotFavoriteCharacter
            }
        }
    }
    
    func updateFavoriteCharacters() {
        updateFavorites()
        self.presenter?.present(characters: characters)
    }
    
    func addFavorite(with id: Int, and image: UIImage?) {
        CharactersConstants.favoritesKeyUserDefaults.getInDefaults() { (favoriteCharacters: [Character]?) in
            var updatedFavorites = [Character]()
            if let favorites = favoriteCharacters {
                updatedFavorites = favorites
            }
            
            if let favorited = self.characters.filter({$0.id == id}).first {
                let urlImage = image?.addImageToFileManager(id: "\(favorited.id ?? 0)")
                let updatedFavorited = Character(with: favorited, isFavorited: true, imagePath: urlImage?.absoluteString)
                updatedFavorites.append(updatedFavorited)
            }
            
            updatedFavorites = updatedFavorites.filterDuplicates()
            updatedFavorites.saveInDefaults(in: CharactersConstants.favoritesKeyUserDefaults)
        }
        updateFavorites()
    }
    
    func removeFavorite(with id: Int) {
        CharactersConstants.favoritesKeyUserDefaults.getInDefaults() { (favoriteCharacters: [Character]?) in
            var updatedFavorites = [Character]()
            if let favorites = favoriteCharacters {
                updatedFavorites = favorites
            }
            if let favoritedToBeRemoved = self.characters.filter({$0.id == id}).first, let index = updatedFavorites.firstIndex(where: { $0.id == favoritedToBeRemoved.id}) {
                updatedFavorites.remove(at: index)
            }
            
            updatedFavorites.saveInDefaults(in: CharactersConstants.favoritesKeyUserDefaults)
        }
        updateFavorites()
    }
}
