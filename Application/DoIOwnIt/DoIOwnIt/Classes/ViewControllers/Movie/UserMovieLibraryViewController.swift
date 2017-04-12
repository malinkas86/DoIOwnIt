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
    
    @IBOutlet weak var tableView: UITableView!
    let userMovieLibraryViewModel = UserMovieLibraryViewModel()
    var movies : [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToUserLibraryViewController(segue: UIStoryboardSegue) { }
    
    override func viewDidAppear(_ animated: Bool) {
        userMovieLibraryViewModel.getUserMovies(completionHandler: { response in
            switch response {
            case .success(_):
                self.movies = self.userMovieLibraryViewModel.movies
                self.tableView.reloadData()
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
            movieDetailsViewController.id = userMovieLibraryViewModel.movies[(selectedIndex?.row)!].id
            movieDetailsViewController.fromViewController = String(describing: UserMovieLibraryViewController.self)
        }
        
    }
    

}

extension UserMovieLibraryViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userMovieLibraryViewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieLibraryTableViewCell
        
        let movie = userMovieLibraryViewModel.movies[indexPath.row]
        
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
