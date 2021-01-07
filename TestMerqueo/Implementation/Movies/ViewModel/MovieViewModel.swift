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
    
    struct Output {
        
        var isLoading = BehaviorRelay(value: false)
        var movies = BehaviorRelay<[Movie]?>(value: nil)
        var movieDetail = BehaviorRelay<MovieDetailResponse?>(value: nil)
        var movieCredits = BehaviorRelay<MovieCreditsResponse?>(value: nil)
        var errorMessage = BehaviorRelay<String?>(value: nil)
        var errorMessageDetail = BehaviorRelay<String?>(value: nil)
        var errorMessageCredits = BehaviorRelay<String?>(value: nil)
        
    }
    
    let output: Output
    
    init() {
        output = Output()
        self.movieBL = MovieBLImplementation(movieRepository: MovieRepository())
    }
    
    init(movieBL : MovieBL) {
        output = Output()
        self.movieBL = movieBL
    }
    
    func getPopularNovies() {
        
        do{
            self.output.isLoading.accept(true)
            
            try self.movieBL.getPopularMovies().asObservable().retry(4).subscribe(onNext: { popularMoviesResponse in
                self.output.isLoading.accept(false)
                
                if let moviesSafe = popularMoviesResponse.results, moviesSafe.count > 0 {
                    self.output.movies.accept(moviesSafe)
                }
                
                
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
