//
//  CharactersPresenter.swift
//  Challenge
//
//  Created by Joao Gabriel Pereira on 06/05/20.
//
import JewFeatures

protocol CharactersPresenterInterface {
    func present(characters: [Character])
    func present(connectorError: ConnectorError)
    func presentDisconnected()
}

class CharactersPresenter: CharactersPresenterInterface {
    
    //MARK: Properties
    weak var viewController: CharactersViewControllerInterface?
    
    func present(characters: [Character]) {
        guard characters.count > 0 else {
            viewController?.display(error: CharactersConstants.notCharactersFoundError, alertType: .custom(messageColor: .white, backgroundColor: .JEWPallete(red: 241, green: 174, blue: 47)))
            return
        }
        viewController?.display(characters: [ReloadableCellCharacterItem(characters: characters)])
    }
    
    func present(connectorError: ConnectorError) {
        viewController?.display(error: CharactersConstants.getCharacterError, alertType: .error)
    }
    
    func presentDisconnected() {
        viewController?.displayDisconnected()
    }
    
}
