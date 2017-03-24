//
//  MovieLibraryTableViewCell.swift
//  DoIOwnIt
//
//  Created by Malinka S on 3/9/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class MovieLibraryTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    var movieId : Int?
    var indexPath : IndexPath?
    weak var tableView : UITableView?
    weak var userMovieLibraryViewModel : UserMovieLibraryViewModel?
        override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func didTapRemove(_ sender: UIButton) {
        
        userMovieLibraryViewModel?.removeMovie(movieId: movieId!, completionHandler: { response in
            self.userMovieLibraryViewModel?.movies.remove(at: (self.indexPath?.row)!)
            
            DispatchQueue.main.async {
                self.tableView?.deleteRows(at: [self.indexPath!], with: UITableViewRowAnimation.fade)
                self.tableView?.reloadData()
            }
        })
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
