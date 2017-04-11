//
//  StorageDetailTableViewCell.swift
//  DoIOwnIt
//
//  Created by Malinka S on 3/5/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class StorageDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var isOwned: RadioButton!
    @IBOutlet weak var storageDescriptionField: UITextField!
    
    @IBOutlet weak var collectionTypeIconView: UIImageView!
    private var storedStorageType : StorageType!
    var storageType : StorageType {
        set(storageType) {
            self.storedStorageType = storageType
            switch (storageType) {
            case .cloud : collectionTypeIconView.image = UIImage(named: "cloud")
            case .digital : collectionTypeIconView.image = UIImage(named: "drive")
            case .disk : collectionTypeIconView.image = UIImage(named: "disc")
            }
        }
        get {
            return self.storedStorageType
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func storageDescriptionEndEditingAction(_ sender: UITextField) {
        if (sender.text?.characters.count)! > 0 {
            self.isOwned.isChecked = true
            self.isOwned.isHidden = false
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
