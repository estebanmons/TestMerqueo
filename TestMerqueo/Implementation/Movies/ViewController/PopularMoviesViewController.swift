//
//  ViewController.swift
//  TestMerqueo
//
//  Created by Juan Esteban Monsalve Echeverry on 5/01/21.
//

import UIKit
import RxCocoa
import RxSwift

class PopularMoviesViewController: UIViewController {
    
    let movieViewModel = MovieViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        movieViewModel.getPopularNovies()
        
    }
    
    func bindViewModel() {
        
        movieViewModel.output.isLoading.asObservable()
            .subscribe(onNext: { isloading in
                if isloading{
                    print(isloading)
                }else{
                    print(isloading)
                }
            }).disposed(by: disposeBag)
        
    }


}

