//
//  TestMerqueoTests.swift
//  TestMerqueoTests
//
//  Created by Juan Esteban Monsalve Echeverry on 5/01/21.
//

@testable import TestMerqueo
import XCTest
import RxSwift
import RxCocoa
import RxTest

class MovieViewModelTest: XCTestCase {
    
    var movieViewModel : MovieViewModel!
    var scheduler = TestScheduler(initialClock: 0)
    var disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSuccessGetPopularMovies(){
        self.movieViewModel = MovieViewModel(movieBL: successMovieBL())
        let observer = scheduler.createObserver(PopularMoviesResponse?.self)
        self.movieViewModel.output.popularMovies.asDriver().drive(observer).disposed(by : disposeBag)
        scheduler.start()
        
        movieViewModel.getPopularMovies(1)
        
        let expectedResult1 : PopularMoviesResponse? = nil
        let expectedResult2 : PopularMoviesResponse? = createMockPopularMovies()
        let expectedEvents = [
            Recorded.next(0,expectedResult1),
            Recorded.next(0, expectedResult2)
        ]
        
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func testFailureGetPopularMovies(){
        self.movieViewModel = MovieViewModel(movieBL: failureMovieBL())
        let observer = scheduler.createObserver(String?.self)
        self.movieViewModel.output.errorMessage.asDriver().drive(observer).disposed(by : disposeBag)
        scheduler.start()
        
        movieViewModel.getPopularMovies(1)
        
        let expectedResult1 : String? = nil
        let expectedResult2 : String? = "Error desconocido al tratar de realizar la petición."
        let expectedEvents = [
            Recorded.next(0,expectedResult1),
            Recorded.next(0, expectedResult2)
        ]
        
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func testSuccessGetMovieDetail(){
        self.movieViewModel = MovieViewModel(movieBL: successMovieBL())
        let observer = scheduler.createObserver(MovieDetailResponse?.self)
        self.movieViewModel.output.movieDetail.asDriver().drive(observer).disposed(by : disposeBag)
        scheduler.start()
        
        movieViewModel.getMovieDetail(1)
        
        let expectedResult1 : MovieDetailResponse? = nil
        let expectedResult2 : MovieDetailResponse? = createMockMovieDetail()
        let expectedEvents = [
            Recorded.next(0,expectedResult1),
            Recorded.next(0, expectedResult2)
        ]
        
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func testFailureGetMovieDetail(){
        self.movieViewModel = MovieViewModel(movieBL: failureMovieBL())
        let observer = scheduler.createObserver(String?.self)
        self.movieViewModel.output.errorMessageDetail.asDriver().drive(observer).disposed(by : disposeBag)
        scheduler.start()
        
        movieViewModel.getMovieDetail(1)
        
        let expectedResult1 : String? = nil
        let expectedResult2 : String? = "Error desconocido al tratar de realizar la petición."
        let expectedEvents = [
            Recorded.next(0,expectedResult1),
            Recorded.next(0, expectedResult2)
        ]
        
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func testSuccessGetMovieCredits(){
        self.movieViewModel = MovieViewModel(movieBL: successMovieBL())
        let observer = scheduler.createObserver(MovieCreditsResponse?.self)
        self.movieViewModel.output.movieCredits.asDriver().drive(observer).disposed(by : disposeBag)
        scheduler.start()
        
        movieViewModel.getMovieCredits(1)
        
        let expectedResult1 : MovieCreditsResponse? = nil
        let expectedResult2 : MovieCreditsResponse? = createMockMovieCredits()
        let expectedEvents = [
            Recorded.next(0,expectedResult1),
            Recorded.next(0, expectedResult2)
        ]
        
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func testFailureGetMovieCredits(){
        self.movieViewModel = MovieViewModel(movieBL: failureMovieBL())
        let observer = scheduler.createObserver(String?.self)
        self.movieViewModel.output.errorMessageCredits.asDriver().drive(observer).disposed(by : disposeBag)
        scheduler.start()
        
        movieViewModel.getMovieCredits(1)
        
        let expectedResult1 : String? = nil
        let expectedResult2 : String? = "Error desconocido al tratar de realizar la petición."
        let expectedEvents = [
            Recorded.next(0,expectedResult1),
            Recorded.next(0, expectedResult2)
        ]
        
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func testSuccessGetMovieByWords(){
        self.movieViewModel = MovieViewModel(movieBL: successMovieBL())
        let observer = scheduler.createObserver([Movie]?.self)
        self.movieViewModel.output.movies.asDriver().drive(observer).disposed(by : disposeBag)
        scheduler.start()
        
        movieViewModel.getMovieByWord("Test")
        
        let expectedResult1 : [Movie]? = nil
        let expectedResult2 : [Movie]? = createMockPopularMovies().results
        let expectedEvents = [
            Recorded.next(0,expectedResult1),
            Recorded.next(0, expectedResult2)
        ]
        
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func testFailureGetMovieByWord(){
        self.movieViewModel = MovieViewModel(movieBL: failureMovieBL())
        let observer = scheduler.createObserver(String?.self)
        self.movieViewModel.output.errorMessage.asDriver().drive(observer).disposed(by : disposeBag)
        scheduler.start()
        
        movieViewModel.getMovieByWord("Test")
        
        let expectedResult1 : String? = nil
        let expectedResult2 : String? = "Error desconocido al tratar de realizar la petición."
        let expectedEvents = [
            Recorded.next(0,expectedResult1),
            Recorded.next(0, expectedResult2)
        ]
        
        XCTAssertEqual(observer.events, expectedEvents)
    }

}

fileprivate class successMovieBL : MovieBL {
    func getPopularMovies(_ page: Int) throws -> Observable<PopularMoviesResponse> {
        return Observable.just(createMockPopularMovies())
    }
    
    func getMovieDetail(_ movieId: Int) throws -> Observable<MovieDetailResponse> {
        return Observable.just(createMockMovieDetail())
        
    }
    
    func getMovieCredits(_ movieId: Int) throws -> Observable<MovieCreditsResponse> {
        return Observable.just(createMockMovieCredits())
    }
    
    func getMovieByWord(_ word: String) throws -> Observable<PopularMoviesResponse> {
        return Observable.just(createMockPopularMovies())
    }
    

}

enum errorBL :  Error {
    case errorResponse
}

fileprivate class failureMovieBL : MovieBL {
    func getPopularMovies(_ page: Int) throws -> Observable<PopularMoviesResponse> {
        return Observable.error(errorBL.errorResponse)
    }
    
    func getMovieDetail(_ movieId: Int) throws -> Observable<MovieDetailResponse> {
        return Observable.error(errorBL.errorResponse)
    }
    
    func getMovieCredits(_ movieId: Int) throws -> Observable<MovieCreditsResponse> {
        return Observable.error(errorBL.errorResponse)
    }
    
    func getMovieByWord(_ word: String) throws -> Observable<PopularMoviesResponse> {
        return Observable.error(errorBL.errorResponse)
    }
    
}

private func createMockPopularMovies() -> PopularMoviesResponse {
    
    return PopularMoviesResponse(page: 1, results: [Movie(adult: false, backdropPath: "/image.jpg", genreIDS: nil, id: 1, originalLanguage: "US", originalTitle: "TestMerqueo", overview: "Aplicación de prueba", popularity: 1000.0, posterPath: "/image.jpg", releaseDate: "7/1/2021", title: "Merqueo", video: false, voteAverage: 10.0, voteCount: 10)], totalPages: 1, totalResults: 1)
}

private func createMockMovieDetail() -> MovieDetailResponse {
    
    return MovieDetailResponse(adult: false, backdropPath: "/image.jpg", belongsToCollection: nil, budget: 100000000, genres: nil, homepage: "wwww.merqueo.com", id: 1, imdbID: "1", originalLanguage: "Us", originalTitle: "TestMerqueo", overview: "Aplicación de prueba", popularity: 1000.0, posterPath: "/image.jpg", productionCompanies: nil, productionCountries: nil, releaseDate: "7/1/2021", revenue: 1000000000, runtime: 1, spokenLanguages: nil, status: "Released", tagline: "Aplicación de prueba", title: "Merqueo", video: false, voteAverage: 10.0, voteCount: 10)
}

private func createMockMovieCredits() -> MovieCreditsResponse {
    
    return MovieCreditsResponse(id: 1, cast: [Cast(adult: false, gender: 0, id: 1, knownForDepartment: "Development", name: "Juan Esteban Monsalve", originalName: "Juan Esteban Monsalve", popularity: 10.0, profilePath: "/image.jpg", castID: 1, character: "Development Enginner", creditID: nil, order: 1, department: "Development", job: "Development Enginner")], crew: [])
}
