//
//  StorageSelectionViewController.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/28/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class StorageSelectionViewController: UIViewController {
    
    struct StorageTypeCell {
        var title : StorageType
        var placeHolder : String?
    }

    @IBOutlet weak var tableView: UITableView!
    let storageTypeCells : [StorageTypeCell] = [StorageTypeCell(title : .cloud, placeHolder : "ex : iCloud"), StorageTypeCell(title : .disk, placeHolder : "ex : DVD, Bluray"), StorageTypeCell(title : .digital, placeHolder : "ex : Hard drive")]
    
    var movieId : Int?
    var movieTitle : String?
    var posterPath : String?
    var releasedDate : String?
    var storageMethods : [String : String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimate()
        print("releasedDate \(releasedDate)")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeAction(_ sender: Any) {
        removeAnimate()
    }
    func showAnimate(){
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 0.0
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: { finished in
            if finished {
                self.view.removeFromSuperview()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func saveAction(_ sender: Any) {
        print("hit on save button")
        var storageMethods : [StorageType : String] = [:]
        for row in 0 ..< tableView.numberOfRows(inSection: 0) {
            let cell:StorageDetailTableViewCell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! StorageDetailTableViewCell
            print(cell.storageDescriptionField.text!)
            if cell.isOwned.isChecked {
                storageMethods[cell.storageType!] = cell.storageDescriptionField.text!
            }
        }
        
        let storageSelectionViewModel = StorageSelectionViewModel()
        storageSelectionViewModel.saveStoragePreference(movieId: movieId!, title: movieTitle!, posterPath: posterPath!, releasedDate: releasedDate!, storageMethods: storageMethods, completionHandler: { response in
            switch response {
            case .success(_):
                DispatchQueue.main.async {
                    self.removeAnimate()
                    NotificationCenterUtil.postNotification(name: "StorageMethodsSaved", value: [:])
                }
                
            case .error(_):
                print("Error ocurred")
            }
        })
    }
}

extension StorageSelectionViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StorageCell", for: indexPath) as! StorageDetailTableViewCell
            let storageTypeCell = storageTypeCells[indexPath.row]
            cell.storageTypeLabel.text = storageTypeCell.title.rawValue
            cell.storageDescriptionField.placeholder = storageTypeCell.placeHolder
            cell.storageType = storageTypeCell.title
            
            if let storageMethod = storageMethods?[storageTypeCell.title.rawValue] {
                cell.storageDescriptionField.text = storageMethod
                cell.isOwned.isChecked = true
            }
            
            return cell
        }
        return tableView.dequeueReusableCell(withIdentifier: "SaveButtonCell")!
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return storageTypeCells.count
        }
        return 1
    }
}
