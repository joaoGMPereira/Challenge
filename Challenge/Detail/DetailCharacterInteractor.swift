//
//  DetailCharacterInteractor.swift
//  Challenge
//
//  Created by Joao Gabriel Pereira on 07/05/20.
//

protocol DetailCharacterInteractorInterface {
    var character: Character? { get set }
}

class DetailCharacterInteractor: DetailCharacterInteractorInterface {
    
    //MARK: Properties
    var character: Character?
    var presenter: DetailCharacterPresenterInterface?
    var worker: DetailCharacterWorkerInterface?
    
}
