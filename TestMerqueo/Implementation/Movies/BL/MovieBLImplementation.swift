//
//  MovieBLImplementation.swift
//  TestMerqueo
//
//  Created by Juan Esteban Monsalve Echeverry on 6/01/21.
//

import Foundation
import RxSwift

class MovieBLImplementation : MovieBL {

    var movieRepository : MovieRepository
    
    init(movieRepository : MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func getPopularMovies() throws -> Observable<PopularMoviesResponse> {
        return try movieRepository.getPopularMovies().asObservable().flatMap({
            response -> Observable<PopularMoviesResponse> in
            return Observable.just(response)
        })
    }
    
    func getMovieDetail(_ movieId: Int) throws -> Observable<MovieDetailResponse> {
        return try movieRepository.getMovieDetail(movieId).asObservable().flatMap({
            response -> Observable<MovieDetailResponse> in
            return Observable.just(response)
        })
    }
    
    func getMovieCredits(_ movieId: Int) throws -> Observable<MovieCreditsResponse> {
        return try movieRepository.getMovieCredits(movieId).asObservable().flatMap({
            response -> Observable<MovieCreditsResponse> in
            return Observable.just(response)
        })
    }
    
    func getMovieByWord(_ word: String) throws -> Observable<PopularMoviesResponse> {
        return try movieRepository.getMovieByWord(word).asObservable().flatMap({
            response -> Observable<PopularMoviesResponse> in
            return Observable.just(response)
        })
    }

}
