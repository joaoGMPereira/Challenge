//
//  CharactersRouter.swift
//  Challenge
//
//  Created by Joao Gabriel Pereira on 06/05/20.
//

import UIKit

protocol CharactersRouterInterface {
    func goToDetail(index: Int)
}

class CharactersRouter: CharactersRouterInterface {
    
    //MARK: Properties
    weak var viewController: CharactersViewController?
    
    static func createModule() -> CharactersViewController {
        let view = CharactersViewController()
        let presenter = CharactersPresenter()
        presenter.viewController = view
        let interactor = CharactersInteractor()
        view.interactor = interactor
        interactor.presenter = presenter
        let router = CharactersRouter()
        view.router = router
        router.viewController = view
        
        return view
    }
    
    func goToDetail(index: Int) {
        if let interactor = viewController?.interactor, interactor.characters.count > index {
            let character = interactor.characters[index]
            let detailViewController = DetailCharacterRouter.createModule(character: character)
            viewController?.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
}
