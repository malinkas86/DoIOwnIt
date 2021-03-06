//
//  MovieListTableViewCell.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/21/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {

    @IBOutlet weak var addedLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var isOwnedButton: RadioButton!
    var movieListViewController : MovieListTableViewController!
    var movieId : Int?
    
    @IBOutlet weak var releasedDateLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(movie: Movie) {
        addedLabel.isHidden = true
        isOwnedButton.isHidden = false
        if let isOwned = movie.isOwned, isOwned {
            addedLabel.isHidden = false
            isOwnedButton.isHidden = true
        }
        
        titleLabel.text = movie.title
        movieId = movie.id
        posterImageView.sd_setImage(with: URL(string: String(format : "%@%@", ConfigUtil.sharedInstance.movieDBImageBaseURL!, movie.posterPath!)))
        releasedDateLabel.text = StringUtil.formatReleaseDate(strValue: movie.releasedDate!, offsetBy: 4)
        
    }

    @IBAction func didTapIsOwned(_ sender: RadioButton) {
        print("did tap is owned")
        
        let popoverVc = UIStoryboard(name: "Movie", bundle: nil).instantiateViewController(withIdentifier: "sbStorageSelection") as! StorageSelectionViewController
        
        let movieDetailsViewModel = MovieDetailsViewModel()
        movieDetailsViewModel.getMovie(id: movieId!, completionHandler: { response in
            switch response {
            case .success(_):
                popoverVc.movieId = movieDetailsViewModel.id
                popoverVc.movieTitle = movieDetailsViewModel.title
                popoverVc.posterPath = movieDetailsViewModel.posterPath
                popoverVc.releasedDate = movieDetailsViewModel.releasedDate
                popoverVc.storageMethods = movieDetailsViewModel.storageMethods
            default : break
            }
            self.movieListViewController.addChildViewController(popoverVc)
            popoverVc.view.frame = self.movieListViewController.view.frame
            self.movieListViewController.view.addSubview(popoverVc.view)
            popoverVc.didMove(toParentViewController: self.movieListViewController)
            self.isOwnedButton.isChecked = false
        })
        
        
        
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
