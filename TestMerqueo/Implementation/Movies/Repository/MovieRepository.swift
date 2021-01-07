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
        
        var request = URLRequest(url: URL(string:"\(Constants.baseUrl)movie/popular?api_key=\(Constants.apiKey)&language=en-US&page=1")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return requestObservable.requestAPI(request: request)
    }
    
    func getMovieDetail(_ movieId: Int) throws -> Observable<MovieDetailResponse> {
        
        var request = URLRequest(url: URL(string:"\(Constants.baseUrl)movie/\(movieId)?api_key=\(Constants.apiKey)&language=en-US")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return requestObservable.requestAPI(request: request)
    }
    
    func getMovieCredits(_ movieId: Int) throws -> Observable<MovieCreditsResponse> {
        
        var request = URLRequest(url: URL(string:"\(Constants.baseUrl)movie/\(movieId)/credits?api_key=\(Constants.apiKey)&language=en-US")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return requestObservable.requestAPI(request: request)
    }
    
    func getMovieByWord(_ word: String) throws -> Observable<PopularMoviesResponse> {
        
        var request = URLRequest(url: URL(string:"\(Constants.baseUrl)search/movie?api_key=\(Constants.apiKey)&language=en-US&query=\(word)&page=1&include_adult=false")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return requestObservable.requestAPI(request: request)
    }
    
}
