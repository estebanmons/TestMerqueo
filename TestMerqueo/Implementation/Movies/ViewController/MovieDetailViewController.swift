//
//  MovieDetailViewController.swift
//  TestMerqueo
//
//  Created by Juan Esteban Monsalve Echeverry on 6/01/21.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

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
    @IBOutlet weak var noCastLabel: UILabel!
    
    
    
    let movieViewModel = MovieViewModel()
    private let disposeBag = DisposeBag()
    var idMovie = 0
    var movieDetail : MovieDetailResponse?
    var movieCredits : MovieCreditsResponse?
    var cast = [Cast]()
    
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
                    self.setMovieCredits(movieCreditsSafe)
                }
                
            }).disposed(by: disposeBag)
        
        movieViewModel.output.errorMessageDetail.asObservable()
            .subscribe(onNext: { errorMessage in
                
                if let errorMessageSafe = errorMessage {
                    self.alertWithHandler(title: Constants.warning, message: errorMessageSafe) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
            }).disposed(by: disposeBag)
        
        movieViewModel.output.errorMessageCredits.asObservable()
            .subscribe(onNext: { errorMessage in
                
                if let errorMessageSafe = errorMessage {
                    self.alertWithHandler(title: Constants.warning, message: errorMessageSafe) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
            }).disposed(by: disposeBag)
        
    }
    
    func setMovieData() {
        
        if let imageUrlString = movieDetail?.backdropPath ,let imageUrl = URL(string: "\(Constants.baseImageUrl)\(imageUrlString)") {
            backDropImageView.sd_setImage(with: imageUrl, completed: nil)
        } else {
            DispatchQueue.main.async {
                self.backDropImageView.image = #imageLiteral(resourceName: "ic_no_image")
                self.backDropImageView.contentMode = .scaleAspectFit
            }
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
    
    func setCollectionView() {
        
        castCollectionView.register(UINib(nibName: "CastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "castCell")
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize.height = 150.0
        flowLayout.itemSize.width = 100.0
        flowLayout.minimumLineSpacing = 10.0
        
        castCollectionView.collectionViewLayout = flowLayout
        castCollectionView.translatesAutoresizingMaskIntoConstraints = false
        castCollectionView.showsVerticalScrollIndicator = false
        
    }
    
    func setMovieCredits(_ movieCredits : MovieCreditsResponse) {
        
        if let castSafe = movieCredits.cast, castSafe.count > 0 {
            
            if castSafe.count > 20 {
                self.cast = Array(castSafe.prefix(20))
            } else {
                self.cast = castSafe
            }
            
            DispatchQueue.main.async {
                self.setCollectionView()
            }
        } else {
            DispatchQueue.main.async {
                self.noCastLabel.isHidden = false
            }
        }
        
        if let crewSafe = movieCredits.crew {
            
            let director =  crewSafe.filter{ $0.job == "Director" }.first
            
            if let imageUrlString = director?.profilePath , let imageUrl = URL(string: "\(Constants.baseImageUrl)\(imageUrlString)") {
                self.directorImageView.sd_setImage(with: imageUrl, completed: nil)
            } else {
                DispatchQueue.main.async {
                    self.directorImageView.image = #imageLiteral(resourceName: "ic_no_image")
                }
            }
            
            DispatchQueue.main.async {
                self.directorLabel.text = director?.name
            }
            
        }
        
    }
    
    
    
    @IBAction func goToWebAction(_ sender: UIButton) {
        
        if let urlString = movieDetail?.homepage, let url = URL(string: urlString) {
            
            let vc = SFSafariViewController(url: url)
            
            vc.modalPresentationStyle = .overCurrentContext
            
            self.present(vc, animated: true)
        } else {
            self.alertWithHandler(title: Constants.warning, message: Constants.notHomePage) {
            }
            
        }
        
    }
    
    @IBAction func closeViewAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}

extension MovieDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "castCell", for: indexPath)

        guard let cell = collectionViewCell as? CastCollectionViewCell else { return collectionViewCell }
        
        cell.setCast(cast[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100.0, height: 150.0)
    }
    
}
