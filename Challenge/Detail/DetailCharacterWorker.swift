//
//  DetailCharacterWorker.swift
//  Challenge
//
//  Created by Joao Gabriel Pereira on 07/05/20.
//
import JewFeatures

protocol DetailCharacterWorkerInterface {
    func fetchComics(with characterID: Int, successCompletion: @escaping ((ComicsResult) -> ()), errorCompletion: @escaping ((ConnectorError) -> ()))
    func fetchSeries(with characterID: Int, successCompletion: @escaping ((SeriesResult) -> ()), errorCompletion: @escaping ((ConnectorError) -> ()))
}

class DetailCharacterWorker: DetailCharacterWorkerInterface {
    func fetchComics(with characterID: Int, successCompletion: @escaping ((ComicsResult) -> ()), errorCompletion: @escaping ((ConnectorError) -> ())) {
        JEWConnector.connector.request(withRoute: MarvelRequests.fetchComics(characterID: characterID).createRequestURL(), successCompletion: { (comics: ComicsResult) in
            successCompletion(comics)
        }) { (connectorError) in
            errorCompletion(connectorError)
        }
    }
    
    func fetchSeries(with characterID: Int, successCompletion: @escaping ((SeriesResult) -> ()), errorCompletion: @escaping ((ConnectorError) -> ())) {
        JEWConnector.connector.request(withRoute: MarvelRequests.fetchSeries(characterID: characterID).createRequestURL(), successCompletion: { (series: SeriesResult) in
            successCompletion(series)
        }) { (connectorError) in
            errorCompletion(connectorError)
        }
    }
}
