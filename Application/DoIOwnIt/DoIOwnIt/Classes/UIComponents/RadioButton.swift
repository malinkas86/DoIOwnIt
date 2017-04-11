//
//  RadioButton.swift
//  DoIOwnIt
//
//  Created by Malinka S on 3/6/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class RadioButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    // Images
    let checkedImage = UIImage(named: "checkmark")! as UIImage!
    let uncheckedImage = UIImage(named: "plus-sign")! as UIImage!
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonClicked), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
        print("checked \(isChecked)")
    }
}
