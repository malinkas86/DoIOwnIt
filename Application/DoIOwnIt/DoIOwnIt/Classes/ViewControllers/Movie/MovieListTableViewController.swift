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
    
    @IBOutlet var tableView: UITableView!
    
    let movieListViewModel = MovieListViewModel()
    var isFetchingData = false
    var isCancelled = false
    var searchQuery = "batman"
    let searchController = UISearchController(searchResultsController: nil)
    let showMovieSegueIdentifier = "showMovieFromSearch"
    var selectedIndex : IndexPath?
    var searchText : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default // Note that default is now a property, not a method call
        nc.addObserver(forName:Notification.Name(rawValue:"StorageMethodsSaved"),object:nil, queue:nil) {
            notification in
            // Handle notification
            self.getMovies(bySearchQuery: self.searchQuery)
        }
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        getMovies(bySearchQuery: searchQuery)
        
    }
    
    func getMovies(bySearchQuery query : String){
        if query.characters.count != 0 {
            isFetchingData = true
            movieListViewModel.searchMovies(query: query, completionHandler: {response in
                switch response {
                case .success(_) :
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
        let movieDetailsViewController = segue.destination as! MovieDetailsViewController
        movieDetailsViewController.id = movieListViewModel.movies[(selectedIndex?.row)!].id
        movieDetailsViewController.fromViewController = String(describing: MovieListTableViewController.self)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as! MovieListTableViewCell
        
        let movie = movieListViewModel.movies[indexPath.row]
        
        let userMovies = movieListViewModel.userMovies
        
        if userMovies[movie.id!] != nil {
            cell.isOwnedButton.isChecked = true
        }else{
            cell.isOwnedButton.isChecked = false
        }
        
        cell.titleLabel.text = movie.title
        cell.movieId = movie.id
        cell.movieListViewController = self
        cell.posterImageView.sd_setImage(with: URL(string: String(format : "%@%@", ConfigUtil.sharedInstance.movieDBImageBaseURL!, movie.posterPath!)))
        
        return cell
    }
}

extension MovieListTableViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        performSegue(withIdentifier: showMovieSegueIdentifier, sender: self)
    }
}

extension MovieListTableViewController: UISearchResultsUpdating {
    /// Retreives books based on search criteria
    func updateSearchResults(for searchController: UISearchController) {
        
        
        
    }
}

// Handles search actions
extension MovieListTableViewController : UISearchBarDelegate {
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        //retrieve all the books of the user hits on cancel.
        isCancelled = true
        
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar){
        if !isCancelled {
            searchQuery = searchBar.text!
            
            movieListViewModel.movies = []
            movieListViewModel.currentPage = 1
            movieListViewModel.totalPages = 0
            getMovies(bySearchQuery: searchQuery)
        }
        
        
        
    }
}
