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
        var errorMessage = BehaviorRelay<String?>(value: nil)
        var notTokenMessage = BehaviorRelay<String?>(value: nil)

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
                
                
                
            }, onError: { error in
                self.output.isLoading.accept(false)
                self.output.errorMessage.accept(self.getErrorValue(error))
            }).disposed(by: disposeBag)
        }catch {
            self.output.isLoading.accept(false)
        }

        
    }
    
    func getErrorValue(_ error: Error) -> String {
        
        if let errorSafe = error as? RequestError {
            
            switch errorSafe {
            
            case .authorizationError:
                return "authorizationError"
                
            case .connectionError:
                return "connectionError"
                
            case .serverError:
                return "serverError"
                
            case .unknownError:
                return "unknownError"
            }
            
        }
        
        return "unknownError"
        
    }
    
}
