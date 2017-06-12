//
//  UserMovieLibraryViewController.swift
//  DoIOwnIt
//
//  Created by Malinka S on 3/9/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class UserMovieLibraryViewController: UIViewController {
    
    let showMovieSegueIdentifier = "showMovieFromLibrary"
    var selectedIndex : IndexPath?
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0) // cell padding
    fileprivate let itemsPerRow: CGFloat = 2
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    let userMovieLibraryViewModel = UserMovieLibraryViewModel()
    var movies : [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBAction func unwindToUserLibraryViewController(segue: UIStoryboardSegue) { }
    
    override func viewDidAppear(_ animated: Bool) {
        userMovieLibraryViewModel.getUserMovies(completionHandler: { response in
            switch response {
            case .success(_):
                self.movies = userMovies
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
            movieDetailsViewController.id = userMovies[(selectedIndex?.row)!].id
            movieDetailsViewController.fromViewController = String(describing: UserMovieLibraryViewController.self)
        }
        
    }
    

}

extension UserMovieLibraryViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieLibraryCollectionViewCell
        
        let movie = userMovies[indexPath.row]
        cell.movieImageView.sd_setImage(with: URL(string: String(format : "%@%@", ConfigUtil.sharedInstance.movieDBImageBaseURL!, movie.posterPath!)))
        
        cell.backgroundColor = UIColor.black
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userMovies.count
    }
}

extension UserMovieLibraryViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
        performSegue(withIdentifier: showMovieSegueIdentifier, sender: self)
    }
}

/*extension UserMovieLibraryViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.size.width-((iphoneRowCount-1)*minimumInteritemSpacing))/iphoneRowCount
        
        
        let height = width*3/2
        return CGSize(width: width, height: CGFloat(height))
    }
}*/

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
