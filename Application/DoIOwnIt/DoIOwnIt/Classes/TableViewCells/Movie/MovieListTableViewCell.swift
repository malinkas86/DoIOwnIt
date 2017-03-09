//
//  MovieListTableViewCell.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/21/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var isOwnedButton: RadioButton!
    var movieListViewController : MovieListTableViewController!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func didTapIsOwned(_ sender: RadioButton) {
        print("did tap is owned")
        let popoverVc = UIStoryboard(name: "Movie", bundle: nil).instantiateViewController(withIdentifier: "sbStorageSelection") as! StorageSelectionViewController
        movieListViewController.addChildViewController(popoverVc)
        popoverVc.view.frame = movieListViewController.view.frame
        movieListViewController.view.addSubview(popoverVc.view)
        popoverVc.didMove(toParentViewController: movieListViewController)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
