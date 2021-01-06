//
//  MovieRepository.swift
//  TestMerqueo
//
//  Created by Juan Esteban Monsalve Echeverry on 6/01/21.
//

import Foundation
import RxSwift
import RxCocoa

class MovieRepository {
    
  lazy var requestObservable = ApiManagerObservable(config: .default)
    
    func getPopularMovies() throws -> Observable<PopularMoviesResponse> {
        
        var request = URLRequest(url: URL(string:"\(Constants.baseUrl)/movie/popular?api_key=\(Constants.apiKey)&language=en-US&page=1")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return requestObservable.requestAPI(request: request)
    }
    
}
