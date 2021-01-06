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

}
