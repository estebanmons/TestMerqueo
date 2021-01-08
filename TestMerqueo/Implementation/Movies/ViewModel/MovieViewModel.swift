//
//  MovieViewModel.swift
//  TestMerqueo
//
//  Created by Juan Esteban Monsalve Echeverry on 6/01/21.
//

import Foundation
import RxCocoa
import RxSwift

class MovieViewModel {
    
    private let disposeBag = DisposeBag()
    private var movieBL : MovieBL
    
    struct Input {
        var wordToSearch = BehaviorRelay<String?>(value: nil)
        var eventSearch = PublishSubject<Void>()
    }
    
    struct Output {
        
        var isLoading = BehaviorRelay(value: false)
        var popularMovies = BehaviorRelay<PopularMoviesResponse?>(value: nil)
        var movies = BehaviorRelay<[Movie]?>(value: nil)
        var movieDetail = BehaviorRelay<MovieDetailResponse?>(value: nil)
        var movieCredits = BehaviorRelay<MovieCreditsResponse?>(value: nil)
        var errorMessage = BehaviorRelay<String?>(value: nil)
        var errorMessageDetail = BehaviorRelay<String?>(value: nil)
        var errorMessageCredits = BehaviorRelay<String?>(value: nil)
        
    }
    
    let input: Input
    let output: Output
    
    init() {
        input = Input()
        output = Output()
        self.movieBL = MovieBLImplementation(movieRepository: MovieRepository())
    }
    
    init(movieBL : MovieBL) {
        input = Input()
        output = Output()
        self.movieBL = movieBL
    }
    
    func getPopularMovies(_ page: Int) {
        
        do{
            self.output.isLoading.accept(true)
            
            try self.movieBL.getPopularMovies(page).asObservable().retry(4).subscribe(onNext: { popularMoviesResponse in
                self.output.isLoading.accept(false)
    
                self.output.popularMovies.accept(popularMoviesResponse)
                
            }, onError: { error in
                self.output.isLoading.accept(false)
                self.output.errorMessage.accept(self.getErrorValue(error))
            }).disposed(by: disposeBag)
        }catch {
            self.output.isLoading.accept(false)
        }
        
    }
    
    func getMovieDetail(_ movieId: Int) {
        
        do{
            self.output.isLoading.accept(true)
            
            try self.movieBL.getMovieDetail(movieId).asObservable().retry(4).subscribe(onNext: { movieDetailResponse in
                self.output.isLoading.accept(false)
                
                self.output.movieDetail.accept(movieDetailResponse)
                self.getMovieCredits(movieId)
                
            }, onError: { error in
                self.output.isLoading.accept(false)
                self.output.errorMessageDetail.accept(self.getErrorValue(error))
            }).disposed(by: disposeBag)
        }catch let errorCatch {
            self.output.isLoading.accept(false)
            self.output.errorMessageDetail.accept(self.getErrorValue(errorCatch))
        }
        
    }
    
    func getMovieCredits(_ movieId: Int) {
        
        do{
            self.output.isLoading.accept(true)
            
            try self.movieBL.getMovieCredits(movieId).asObservable().retry(4).subscribe(onNext: { movieCreditsResponse in
                
                self.output.isLoading.accept(false)
                self.output.movieCredits.accept(movieCreditsResponse)
                
            }, onError: { error in
                self.output.isLoading.accept(false)
                self.output.errorMessageCredits.accept(self.getErrorValue(error))
            }).disposed(by: disposeBag)
        }catch let errorCatch {
            self.output.isLoading.accept(false)
            self.output.errorMessageCredits.accept(self.getErrorValue(errorCatch))
        }
        
    }
    
    func getMovieByWord(_ word: String) {
        do{
            try self.movieBL.getMovieByWord(word).asObservable().retry(4).subscribe(
                onNext: { responseSearchMovies in
                    self.output.isLoading.accept(false)
                    
                    self.output.movies.accept(responseSearchMovies.results)
                    
            }, onError: { error in
                self.output.isLoading.accept(false)
                self.output.errorMessage.accept(self.getErrorValue(error))
                
                
            }).disposed(by: self.disposeBag)
        }catch {
            self.output.isLoading.accept(false)
            self.output.errorMessage.accept(error.localizedDescription)
        }
    }

    
    func getErrorValue(_ error: Error) -> String {
        
        if let errorSafe = error as? RequestError {
            
            switch errorSafe {
            
            case .authorizationError:
                return "Error de autorización al tratar de realizar la petición."
                
            case .connectionError:
                return "Error de conexión a internet al tratar de realizar la petición."
                
            case .serverError:
                return "Error del servidor al tratar de realizar la petición."
                
            case .unknownError:
                return "Error desconocido al tratar de realizar la petición."
            }
            
        }
        
        return "Error desconocido al tratar de realizar la petición."
        
    }
    
}
