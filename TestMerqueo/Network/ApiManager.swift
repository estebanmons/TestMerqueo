//
//  ApiManager.swift
//  TestMerqueo
//
//  Created by Juan Esteban Monsalve Echeverry on 6/01/21.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: ManagerObservable class
public class ApiManagerObservable {
    
    private lazy var jsonDecoder = JSONDecoder()
    
    private var urlSession: URLSession
    
    public init(config: URLSessionConfiguration) {
        urlSession = URLSession(configuration: .default)
    }
    
    
    public func requestAPI<Model: Decodable>(request: URLRequest)-> Observable<Model> {
        
        
        return Observable.create { observer in
            
            
            let task = self.urlSession.dataTask(with: request) { (data, response, error) in
                
                if error != nil {
                    observer.onError(RequestError.connectionError)
                    
                } else if let data = data, let responseCode = response as? HTTPURLResponse {
                    
                    switch responseCode.statusCode {
                    
                    case 200:
                        do {
                            let objs = try self.jsonDecoder.decode(Model.self, from: data)
                            observer.onNext(objs)
                        } catch {
                            observer.onError(error)
                        }
                        
                    case 400...499:
                        observer.onError(RequestError.authorizationError)
                        
                    case 500...599:
                        observer.onError(RequestError.serverError)
                        
                    default:
                        observer.onError(RequestError.unknownError)
                        break
                        
                    }
                    
                }
                
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
            
        }
    }
}
