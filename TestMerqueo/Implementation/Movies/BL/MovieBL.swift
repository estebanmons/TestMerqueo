//
//  MovieBL.swift
//  TestMerqueo
//
//  Created by Juan Esteban Monsalve Echeverry on 6/01/21.
//

import Foundation
import RxSwift

protocol MovieBL {
    func getPopularMovies()  throws -> Observable<PopularMoviesResponse>
    func getMovieDetail(_ movieId: Int) throws -> Observable<MovieDetailResponse>
    func getMovieCredits(_ movieId: Int) throws -> Observable<MovieCreditsResponse>
}
