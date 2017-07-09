//
//  UserMovieLibraryViewController.swift
//  DoIOwnIt
//
//  Created by Malinka S on 3/9/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit
import Firebase

class UserMovieLibraryViewController: UIViewController {
    
    let showMovieSegueIdentifier = "showMovieFromLibrary"
    var selectedIndex : IndexPath?
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0) // cell padding
    fileprivate let itemsPerRow: CGFloat = 2
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tutorialContentView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isInitialLoad = false
    
    
    let userMovieLibraryViewModel = UserMovieLibraryViewModel()
    var movies : [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        searchController.searchResultsUpdater = self
        searchBar.delegate = self
        isInitialLoad = true
        
        searchBar.barTintColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.13, alpha: 1.0)
        
        for view in searchBar.subviews {
            for subview in view.subviews {
                if subview is UITextField {
                    let textField: UITextField = subview as! UITextField
                    textField.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.03, alpha: 1.0)
                    textField.textColor = themeColor
                } else if subview is UIButton {
                    let cancelButton: UIButton = subview as! UIButton
                    cancelButton.setTitleColor(themeColor, for: .normal)
                } else{
                    subview.backgroundColor = navbarColor
                }
            }
        }
        
        definesPresentationContext = true
//        collectionView = searchController.searchBar
       
    }
    
    @IBAction func unwindToUserLibraryViewController(segue: UIStoryboardSegue) { }
    
    override func viewDidAppear(_ animated: Bool) {
        tutorialContentView.isHidden = true
        Analytics.logEvent("view_screen", parameters: ["screen_name": "user_movies"])
        if isInitialLoad {
            isInitialLoad = false
            getUserMovies()
        } else {
            if let serachQuery = searchBar.text {
                getUserMovies(byQuery: serachQuery)
            }
        }
        
    }
    
    internal func getUserMovies() {
        userMovieLibraryViewModel.getUserMovies(completionHandler: { response in
            switch response {
            case .success(_):
                self.movies = userMovies
                if !self.movies.isEmpty {
                    self.tutorialContentView.isHidden = true
                } else {
                   self.tutorialContentView.isHidden = false
                }
                self.collectionView.reloadData()
                for movie in self.movies {
                    log.debug(movie.title)
                    log.debug(movie.posterPath)
                    
                    let storageMethods = movie.storageMethods
                    for (key, value) in storageMethods! {
                        log.debug("key \(key) methods \(String(describing: value.methods))")
                    }
                }
            default : break
            }
        })
    }
    
    internal func getUserMovies(byQuery query: String) {
        userMovieLibraryViewModel.getUserMovies(byQuery: query, completionHandler: { response in
            switch response {
            case .success(_):
                self.movies = self.userMovieLibraryViewModel.searchMovies
                if !self.movies.isEmpty {
                    self.tutorialContentView.isHidden = true
                } else {
                    self.tutorialContentView.isHidden = false
                }
                self.collectionView.reloadData()
                for movie in self.movies {
                    log.debug(movie.title)
                    log.debug(movie.posterPath)
                    
                    let storageMethods = movie.storageMethods
                    for (key, value) in storageMethods! {
                        log.debug("key \(key) methods \(String(describing: value.methods))")
                    }
                }
            default : break
            }
        })
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
        if segue.identifier == "showMovieFromLibrary" {
            let movieDetailsViewController = segue.destination as! MovieDetailsViewController
            movieDetailsViewController.id = self.movies[(selectedIndex?.row)!].id
            movieDetailsViewController.fromViewController = String(describing: UserMovieLibraryViewController.self)
        }
    }

}

extension UserMovieLibraryViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieLibraryCollectionViewCell
        
        let movie = movies[indexPath.row]
        cell.movieImageView.sd_setImage(with: URL(string: String(format : "%@%@", ConfigUtil.sharedInstance.movieDBImageBaseURL!, movie.posterPath!)))
        
        cell.backgroundColor = UIColor.black
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
        
    }
    
//    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        searchController.searchBar.sizeToFit()
//    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
}

extension UserMovieLibraryViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
        performSegue(withIdentifier: showMovieSegueIdentifier, sender: self)
    }
}

extension UserMovieLibraryViewController : UICollectionViewDelegateFlowLayout {
    //1. is responsible for telling the layout the size of a given cell
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2. Here, you work out the total amount of space taken up by padding.
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: (widthPerItem * 1.5)) // 3:2 Movie Poster Aspect Ratio
    }
    
    //3. returns the spacing between the cells, headers, and footers. A constant is used to store the value.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4. This method controls the spacing between each line in the layout. You want this to match the padding at the left and right.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension UserMovieLibraryViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieLibraryTableViewCell
        
        let movie = userMovies[indexPath.row]
        
        cell.titleLabel.text = movie.title
        cell.movieId = movie.id
        cell.indexPath = indexPath
        cell.tableView = tableView
        cell.userMovieLibraryViewModel = userMovieLibraryViewModel
        cell.posterImageView.sd_setImage(with: URL(string: String(format : "%@%@", ConfigUtil.sharedInstance.movieDBImageBaseURL!, movie.posterPath!)))
    
        return cell
        
    }
}

extension UserMovieLibraryViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        performSegue(withIdentifier: showMovieSegueIdentifier, sender: self)
    }
}

// Handles search actions
extension UserMovieLibraryViewController : UISearchBarDelegate {
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        //retrieve all the books of the user hits on cancel.
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        Analytics.logEvent("cancel_library_movie_search", parameters: nil)
        
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        let searchQuery = searchBar.text!
        searchBar.resignFirstResponder()
        getUserMovies(byQuery: searchQuery)
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            getUserMovies()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    
    
    
}
