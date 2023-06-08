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
    
    // MARK: - Properties
    let session: Session
    
    // MARK: - Construct
    public init(session: Session = .default) {
        self.session = session
    }
    
    /// Performs REST Api Request
    /// - Parameters:
    ///   - resource: resource to request
    ///   - type: Decodable entity to parse the json
    /// - Returns: Will return a publisher with either the decoded response or an error.
    func request<T: Decodable>(resource: APIResource, for type: T.Type) -> AnyPublisher<T, Error> {
        
        return Just(resource)
            .map { resource -> DataRequest in
                return session
                    .request(APIRequest(resource: resource))
                    .validate()
            }
            .flatMap { dataRequest -> AnyPublisher<DataResponse<T, AFError>, Never> in
                return dataRequest.publishDecodable(type: T.self, queue: .global())
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
    
    /// Performs request to fetch the image
    /// - Parameter resource: resource image to request
    /// - Returns: Will return a publisher with either the image downloaded or an error.
    func requestImage(resource: APIResource) -> AnyPublisher<Image, Error> {
        
        return Future { promise in
            session.request(APIRequest(resource: resource)).responseImage(queue: .global()) { imageResponse in
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



