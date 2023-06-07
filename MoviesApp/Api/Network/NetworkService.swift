//
//  NetworkService.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 5.6.23.
//

import Foundation
import Combine
import Alamofire
import AlamofireImage

protocol NetworkServiceType {
    func request<T: Decodable>(resource: APIResource, for type: T.Type) -> AnyPublisher<T, Error>
    func requestImage(resource: APIResource) -> AnyPublisher<Image, Error>
}

struct NetworkService: NetworkServiceType {
    
    let session: Session
    
    public init(session: Session = .default) {
        self.session = session
    }
    
    func request<T: Decodable>(resource: APIResource, for type: T.Type) -> AnyPublisher<T, Error> {
        
        return Just(resource)
            .map { resource -> DataRequest in
                return session
                    .request(APIRequest(resource: resource))
                    .validate()
            }
            .flatMap { dataRequest -> AnyPublisher<DataResponse<T, AFError>, Never> in
                return dataRequest.publishDecodable(type: T.self)
                    .eraseToAnyPublisher()
            }
            .tryMap { (dataResponse) -> T in
                switch dataResponse.result {
                    case .success(let value):
                        return value
                    case .failure(let error):
                        print(error)
                        throw error
                }
            }.eraseToAnyPublisher()
    }
    
    func requestImage(resource: APIResource) -> AnyPublisher<Image, Error> {
        
        return Future { promise in
            session.request(resource.requestURLString).responseImage { imageResponse in
                switch imageResponse.result {
                case .success(let image):
                    promise(.success(image))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}



