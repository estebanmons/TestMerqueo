//
//  SearchMovieViewController.swift
//  TestMerqueo
//
//  Created by Juan Esteban Monsalve Echeverry on 7/01/21.
//

import UIKit
import RxSwift
import RxCocoa

class SearchMovieViewController: UITableViewController {
    
    let searchCellIdentifier = "searchCell"
    
    let movieViewModel = MovieViewModel()
    private let disposeBag = DisposeBag()
    
    var searchController: UISearchController!
    
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setNavigationItem()
        self.setSearchController()
        self.bindViewModel()
        
    }
    
    /// Init view controller
    static func storyboardInstance() -> SearchMovieViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "SearchMovieViewController") as! SearchMovieViewController
    }
    
    func setNavigationItem() {
        self.navigationItem.title = "Search Movies"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchController.isActive = true
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {[weak self] in
            self?.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    func bindViewModel() {
        
        movieViewModel.output.movies.asObservable()
            .subscribe(onNext: { movies in
                if let moviesSafe = movies, moviesSafe.count > 0 {
                    self.movies = moviesSafe
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            }).disposed(by: disposeBag)
        
        movieViewModel.output.errorMessage.asObservable()
            .subscribe(onNext: { errorMessage in
                
                if let errorMessageSafe = errorMessage {
                    self.showAlert(title: Constants.warning, message: errorMessageSafe)
                }
                
            }).disposed(by: disposeBag)
        
        
    }
    
    func showAlert(title: String, message : String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let acceptAction = UIAlertAction(title: Constants.accept, style: .default, handler: nil)
            alert.addAction(acceptAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCellIdentifier, for: indexPath)
        cell.textLabel?.text = self.movies[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let idMovie = movies[indexPath.row].id {
            self.goToMovieDetailView(idMovie)
        }
    }
    
    func goToMovieDetailView(_ idMovie: Int) {
        
        let movieDetailView = MovieDetailViewController.storyboardInstance()
        movieDetailView.idMovie = idMovie
        self.present(movieDetailView, animated: true, completion: nil)
        
    }

}

extension SearchMovieViewController :  UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text, searchText.count > 2 {
            
            if searchText.rangeOfCharacter(from: .whitespacesAndNewlines) != nil {
                let stringSafe = searchText.replacingOccurrences(of: " ", with: "%20")
                self.movieViewModel.getMovieByWord(stringSafe)
            } else {
                self.movieViewModel.getMovieByWord(searchText)
            }
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
