//
//  DetailCharacterWorker.swift
//  Challenge
//
//  Created by Joao Gabriel Pereira on 07/05/20.
//
import JewFeatures

protocol DetailCharacterWorkerInterface {
    func fetchComics(with characterID: Int)
    func fetchSeries(with characterID: Int)
}

class DetailCharacterWorker: DetailCharacterWorkerInterface {
    func fetchComics(with characterID: Int) {
        JEWConnector.connector.request(withRoute: MarvelRequests.fetchComics(characterID: characterID).createRequestURL(), successCompletion: { (comics: ComicsResult) in
           // successCompletion(charactersResult)
        }) { (connectorError) in
            //errorCompletion(connectorError)
        }
    }
    
    func fetchSeries(with characterID: Int) {
        JEWConnector.connector.request(withRoute: MarvelRequests.fetchSeries(characterID: characterID).createRequestURL(), successCompletion: { (series: SeriesResult) in
            //successCompletion(charactersResult)
        }) { (connectorError) in
            //errorCompletion(connectorError)
        }
    }
}
