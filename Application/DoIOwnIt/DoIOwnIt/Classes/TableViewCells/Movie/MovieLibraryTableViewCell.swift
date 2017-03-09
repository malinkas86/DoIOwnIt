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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
