//
//  MovieDetailViewController.swift
//  TestMerqueo
//
//  Created by Juan Esteban Monsalve Echeverry on 6/01/21.
//

import UIKit
import RxSwift
import RxCocoa

class MovieDetailViewController: BaseViewController {
    
    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var directorImageView: UIImageView!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var webMovieButton: UIButton!
    
    
    let movieViewModel = MovieViewModel()
    private let disposeBag = DisposeBag()
    var idMovie = 0
    var movieDetail : MovieDetailResponse?
    var movieCredits : MovieCreditsResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        movieViewModel.getMovieDetail(idMovie)
        
    }
    
    /// Init view controller
    static func storyboardInstance() -> MovieDetailViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
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
        
        movieViewModel.output.movieDetail.asObservable()
            .subscribe(onNext: { movieDetailResponse in
                
                if let movieDetailSafe = movieDetailResponse {
                    self.movieDetail = movieDetailSafe
                    self.setMovieData()
                }
                
            }).disposed(by: disposeBag)
        
        movieViewModel.output.movieCredits.asObservable()
            .subscribe(onNext: { movieCreditsResponse in
                
                if let movieCreditsSafe = movieCreditsResponse {
                    self.movieCredits = movieCreditsSafe
                }
                
            }).disposed(by: disposeBag)
        
        movieViewModel.output.errorMessageDetail.asObservable()
            .subscribe(onNext: { errorMessage in
                
                if let errorMessageSafe = errorMessage {
                    self.showAlert(title: "Advertencia", message: errorMessageSafe)
                }
                
            }).disposed(by: disposeBag)
        
        movieViewModel.output.errorMessageCredits.asObservable()
            .subscribe(onNext: { errorMessage in
                
                if let errorMessageSafe = errorMessage {
                    self.showAlert(title: "Advertencia", message: errorMessageSafe)
                }
                
            }).disposed(by: disposeBag)
        
    }
    
    func setMovieData() {
        
        if let imageUrlString = movieDetail?.backdropPath ,let imageUrl = URL(string: "\(Constants.baseImageUrl)\(imageUrlString)") {
            backDropImageView.sd_setImage(with: imageUrl, completed: nil)
        }
        
        guard let title = movieDetail?.title else {
            return
        }
        
        guard let voteAverage = movieDetail?.voteAverage else {
            return
        }
        
        guard let tagline = movieDetail?.tagline else {
            return
        }
        
        
        
        guard let overview = movieDetail?.overview else {
            return
        }
        
        guard let budget = movieDetail?.budget else {
            return
        }
        
        guard let revenue = movieDetail?.revenue else {
            return
        }
        
        DispatchQueue.main.async {
            self.voteAverageLabel.text = String(voteAverage)
            self.titleLabel.text = title
            self.taglineLabel.text = tagline
            self.overviewLabel.text = overview
            self.budgetLabel.text = String(budget)
            self.revenueLabel.text = String(revenue)
        }
        
    }
    
    
    
    @IBAction func goToWebAction(_ sender: UIButton) {
        
        
        
    }
    
    @IBAction func closeViewAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
