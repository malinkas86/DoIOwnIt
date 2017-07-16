//
//  MovieListTableViewController.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/20/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit
import SDWebImage

class MovieListTableViewController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var searchTutorialContentView: UIView!
    @IBOutlet fileprivate weak var noResultsFoundView: UIView!
    
    fileprivate let movieListViewModel = MovieListViewModel()
    fileprivate var isFetchingData = false
    fileprivate var isCancelled = false
    fileprivate var searchQuery = ""
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate let showMovieSegueIdentifier = "showMovieFromSearch"
    fileprivate var selectedIndex : IndexPath?
    fileprivate var userMovies: [Int : String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        analyticsManager.logEvent("view_screen", parameters: ["screen_name": "search_movies"])
        getMovies(bySearchQuery: searchQuery)
    }
    
    private func configure() {
        let nc = NotificationCenter.default // Note that default is now a property, not a method call
        nc.addObserver(forName:Notification.Name(rawValue:"StorageMethodsSaved"),object:nil, queue:nil) {
            notification in
            // Handle notification
            self.getMovies(bySearchQuery: self.searchQuery)
        }
        searchTutorialContentView.isHidden = false
        noResultsFoundView.isHidden = true
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.13, alpha: 1.0)
        
        for view in searchController.searchBar.subviews {
            for subview in view.subviews {
                if let textField: UITextField = subview as? UITextField {
                    textField.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.03, alpha: 1.0)
                    textField.textColor = themeColor
                } else{
                    subview.backgroundColor = navbarColor
                }
            }
        }
        
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    
    func getMovies(bySearchQuery query : String){
        if query.characters.count != 0 {
            isFetchingData = true
            movieListViewModel.searchMovies(query: query, completionHandler: {response in
                self.searchTutorialContentView.isHidden = true
                switch response {
                case .success(_) :
                    if self.movieListViewModel.movies.isEmpty {
                        self.noResultsFoundView.isHidden = false
                    } else {
                        self.noResultsFoundView.isHidden = true
                    }
                    
                    self.userMovies = self.movieListViewModel.localUserMovies
                    self.tableView.reloadData()
                case let .error(error) :
                    log.error(error)
                }
                self.isFetchingData = false
                self.isCancelled = false
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == showMovieSegueIdentifier {
            print(movieListViewModel.movies[(selectedIndex?.row)!].isOwned ?? "")
            let movieDetailsViewController = segue.destination as! MovieDetailsViewController
            movieDetailsViewController.isOwned = movieListViewModel.movies[(selectedIndex?.row)!].isOwned!
            movieDetailsViewController.id = movieListViewModel.movies[(selectedIndex?.row)!].id
            movieDetailsViewController.fromViewController = String(describing: MovieListTableViewController.self)
        }
        
    }
    
}

extension MovieListTableViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        log.debug("did scroll")
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        log.debug("deltaoffset \(deltaOffset)")
        
        if deltaOffset <= 0 && !isFetchingData {
            getMovies(bySearchQuery: searchQuery)
        }
    }
}

extension MovieListTableViewController : UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movieListViewModel.movies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movie = movieListViewModel.movies[indexPath.row]
        
        if self.userMovies[movie.id!] != nil {
            movie.isOwned = true
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as? MovieListTableViewCell {
            cell.configure(movie: movie)
            cell.movieListViewController = self
            return cell
        }
        
        return UITableViewCell()
    }
}

extension MovieListTableViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        performSegue(withIdentifier: showMovieSegueIdentifier, sender: self)
    }
}

// Handles search actions
extension MovieListTableViewController : UISearchBarDelegate {
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        //retrieve all the books of the user hits on cancel.
        isCancelled = true
        analyticsManager.logEvent("cancel_movie_search", parameters: nil)
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        if let text = searchBar.text {
            searchQuery = text
        }
        movieListViewModel.movies = []
        movieListViewModel.currentPage = 1
        movieListViewModel.totalPages = 0
        getMovies(bySearchQuery: searchQuery)
    }
    
}
