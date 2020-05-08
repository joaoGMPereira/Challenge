//
//  DetailCharacterRouter.swift
//  Challenge
//
//  Created by Joao Gabriel Pereira on 07/05/20.
//

import UIKit

protocol DetailCharacterRouterInterface {
    
}

class DetailCharacterRouter: DetailCharacterRouterInterface {
    
    //MARK: Properties
    weak var viewController: DetailCharacterViewController?
    
    static func createModule(character: Character) -> DetailCharacterViewController {
        let view = DetailCharacterViewController()
        let presenter = DetailCharacterPresenter()
        presenter.viewController = view
        let interactor = DetailCharacterInteractor()
        interactor.character = character
        view.interactor = interactor
        interactor.presenter = presenter
        let router = DetailCharacterRouter()
        view.router = router
        router.viewController = view
        
        return view
    }
    
}
