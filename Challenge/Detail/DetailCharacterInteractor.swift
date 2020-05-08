//
//  DetailCharacterInteractor.swift
//  Challenge
//
//  Created by Joao Gabriel Pereira on 07/05/20.
//

protocol DetailCharacterInteractorInterface {
    var character: Character? { get set }
    
    func fetchSeries()
    func fetchComics()
}

class DetailCharacterInteractor: DetailCharacterInteractorInterface {
    
    //MARK: Properties
    var character: Character?
    var presenter: DetailCharacterPresenterInterface?
    var worker: DetailCharacterWorkerInterface? = DetailCharacterWorker()
    
    
    func fetchComics() {
        guard let characterID = character?.id else {
            return
        }
        worker?.fetchComics(with: characterID, successCompletion: { (comicsResult) in
            guard let comics = comicsResult.data?.results else {
                self.presenter?.presentComics(error: DetailCharacterConstants.noComics)
                return
            }
            self.presenter?.present(comics: comics)
        }, errorCompletion: { (connectorError) in
            self.presenter?.presentComics(error: DetailCharacterConstants.noComics)
        })
    }
    
    func fetchSeries() {
        guard let characterID = character?.id else {
            return
        }
        worker?.fetchSeries(with: characterID, successCompletion: { (comicsResult) in
            guard let series = comicsResult.data?.results else {
                self.presenter?.presentComics(error: DetailCharacterConstants.noSeries)
                return
            }
            self.presenter?.present(series: series)
        }, errorCompletion: { (connectorError) in
            self.presenter?.presentComics(error: DetailCharacterConstants.noSeries)
        })
    }
    
}
