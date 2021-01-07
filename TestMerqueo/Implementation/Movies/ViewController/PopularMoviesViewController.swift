//
//  ViewController.swift
//  TestMerqueo
//
//  Created by Juan Esteban Monsalve Echeverry on 5/01/21.
//

import UIKit
import RxSwift
import RxCocoa

class PopularMoviesViewController: BaseViewController {
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    var movies = [Movie]()
    let movieViewModel = MovieViewModel()
    private let disposeBag = DisposeBag()
    
    var estimateWidth = 160.0
    var estimatedHeight = 220.0
    var cellMarginSize = 10.0
    
    let movieCell = "movieCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItem()
        setCollectionView()
        bindViewModel()
        movieViewModel.getPopularNovies()
        
    }
    
    /// Init view controller
    static func storyboardInstance() -> PopularMoviesViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "PopularMoviesViewController") as! PopularMoviesViewController
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
        
        movieViewModel.output.movies.asObservable()
            .subscribe(onNext: { movies in
                if let moviesSafe = movies, moviesSafe.count > 0 {
                    self.movies = moviesSafe
                    
                    DispatchQueue.main.async {
                        self.moviesCollectionView.reloadData()
                        self.moviesCollectionView.layoutIfNeeded()
                    }
                    
                }
            }).disposed(by: disposeBag)
        
        movieViewModel.output.errorMessage.asObservable()
            .subscribe(onNext: { errorMessage in
                
                if let errorMessageSafe = errorMessage {
                    self.showAlert(title: "Advertencia", message: errorMessageSafe)
                }
                
            }).disposed(by: disposeBag)
        
        
    }
    
    func setNavigationItem() {
        self.navigationItem.title = "Popular Movies"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setCollectionView() {
        
        moviesCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: movieCell)
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize.height = 170.0
        flowLayout.itemSize.width = (moviesCollectionView.frame.size.width - CGFloat(20)) / CGFloat(3)
        flowLayout.minimumLineSpacing = 10.0
        
        moviesCollectionView.collectionViewLayout = flowLayout
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        moviesCollectionView.showsVerticalScrollIndicator = false
        
    }
    
    func goToMovieDetailView(_ idMovie: Int) {
        
        let movieDetailView = MovieDetailViewController.storyboardInstance()
        movieDetailView.idMovie = idMovie
        self.present(movieDetailView, animated: true, completion: nil)
        
    }


}

extension PopularMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCell, for: indexPath)

        guard let cell = collectionViewCell as? MovieCollectionViewCell else { return collectionViewCell }
        
        if let imageMovie = movies[indexPath.row].posterPath {
            cell.getImageForMovie(imageMovie)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let idMovie = movies[indexPath.row].id {
            self.goToMovieDetailView(idMovie)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (moviesCollectionView.frame.size.width - CGFloat(20)) / CGFloat(3)
        return CGSize(width:size, height: 170.0)
    }
    
}
