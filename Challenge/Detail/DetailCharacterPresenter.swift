//
//  DetailCharacterPresenter.swift
//  Challenge
//
//  Created by Joao Gabriel Pereira on 07/05/20.
//
import JewFeatures

protocol DetailCharacterPresenterInterface {
    func present(series: [Series])
    func present(comics: [Comics])
    func presentSeries(error: String)
    func presentComics(error: String)
}

class DetailCharacterPresenter: DetailCharacterPresenterInterface {
    
    //MARK: Properties
    weak var viewController: DetailCharacterViewControllerInterface?
    
    func present(series: [Series]) {
        viewController?.display(series: ReloadableSectionSeriesItem.init(series: series, errorTitle: DetailCharacterConstants.noSeries))
    }
    
    func present(comics: [Comics]) {
        viewController?.display(comics: ReloadableSectionComicsItem.init(comics: comics, errorTitle: DetailCharacterConstants.noComics))
        
    }
    func presentSeries(error: String) {
        viewController?.displaySeries(error: error)
    }
    
    func presentComics(error: String) {
        viewController?.displayComics(error: error)
    }
    
}
