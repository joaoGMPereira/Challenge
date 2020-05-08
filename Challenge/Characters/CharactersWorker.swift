//
//  CharactersWorker.swift
//  Challenge
//
//  Created by Joao Gabriel Pereira on 06/05/20.
//
import JewFeatures
import CryptoSwift
protocol CharactersWorkerInterface {
    func fetchCharacters(offset: Int, limit: Int, searchName: String?, successCompletion: @escaping ((CharactersResult) -> ()), errorCompletion: @escaping ((ConnectorError) -> ()))
    func fetchCharactersImages(url: String?, name: String?, completion: @escaping ((DownloadedImages) -> ()))
}

class CharactersWorker: CharactersWorkerInterface {
    
    func fetchCharacters(offset: Int, limit: Int, searchName: String?, successCompletion: @escaping ((CharactersResult) -> ()), errorCompletion: @escaping ((ConnectorError) -> ())) {
        JEWConnector.connector.request(withRoute: MarvelRequests.fetchCharacters(offset: offset, limit: limit, searchName: searchName).createRequestURL(), successCompletion: { (charactersResult: CharactersResult) in
            successCompletion(charactersResult)
        }) { (connectorError) in
            errorCompletion(connectorError)
        }
    }
    
    func fetchCharactersImages(url: String?, name: String?, completion: @escaping ((DownloadedImages) -> ())) {
        url?.downloaded { (image, id) in
            completion(DownloadedImages(image: image, id: id, name: name))
        }
    }
}
