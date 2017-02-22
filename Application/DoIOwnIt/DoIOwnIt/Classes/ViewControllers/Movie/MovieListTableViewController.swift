//
//  MovieListTableViewController.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/20/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit
import SDWebImage

class MovieListTableViewController: UITableViewController {
    
    
    let movieListViewModel = MovieListViewModel()
    var isFetchingData = false
    var isCancelled = false
    var searchQuery = ""
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        //getMovies(bySearchQuery: "titanic")
        
    }
    
    func getMovies(bySearchQuery query : String){
        if query.characters.count != 0 {
            isFetchingData = true
            movieListViewModel.searchBooks(query: query, completionHandler: {response in
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movieListViewModel.movies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as! MovieListTableViewCell
        
        let movie = movieListViewModel.movies[indexPath.row]
        
        cell.titleLabel.text = movie.title
        cell.posterImageView.sd_setImage(with: URL(string: String(format : "%@%@", ConfigUtil.sharedInstance.movieDBImageBaseURL!, movie.posterPath!)))

        // Configure the cell...

        return cell
    }
    
    
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("did scroll")
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        print("deltaoffset \(deltaOffset)")
        
        if deltaOffset <= 0 && !isFetchingData {
            getMovies(bySearchQuery: searchQuery)
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
