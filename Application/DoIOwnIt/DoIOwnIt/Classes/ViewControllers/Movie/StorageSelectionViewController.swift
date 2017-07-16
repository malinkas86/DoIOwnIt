//
//  StorageSelectionViewController.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/28/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class StorageSelectionViewController: UIViewController {
    
    struct StorageTypeCell {
        var title : StorageType
        var placeHolder : String?
    }

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    let storageTypeCells : [StorageTypeCell] = [StorageTypeCell(title : .cloud, placeHolder : "Cloud"), StorageTypeCell(title : .disk, placeHolder : "Bluray"), StorageTypeCell(title : .digital, placeHolder : "Digital")]
    
    var movieId : Int?
    var movieTitle : String?
    var posterPath : String?
    var releasedDate : String?
    var storageMethods : [String : String]?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        analyticsManager.logEvent("view_screen", parameters: ["screen_name": "storage_methods",
                                                       "movie_id": movieId!])
        showAnimate()
        mainView.clipsToBounds = true
        KeyboardAvoiding.avoidingView = self.view
        
    }
    
    @IBAction func closeAction(_ sender: Any) {
        analyticsManager.logEvent("close_storage_preferences", parameters: nil)
        NotificationCenterUtil.postNotification(name: "StorageMethodsCancelled", value: [:])
        removeAnimate()
    }
    
    func showAnimate(){
//        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut],
            animations: {
                //self.view.center.y -= self.view.bounds.width
        },
        completion: nil
        )
    }
    
    func removeAnimate(){
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0.0
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.center.y += self.view.bounds.width
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
        var storageMethods : [StorageType : String] = [:]
        for row in 0 ..< tableView.numberOfRows(inSection: 0) {
            let cell:StorageDetailTableViewCell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! StorageDetailTableViewCell
            print(cell.storageDescriptionField.text!)
            if cell.isOwned.isChecked {
                storageMethods[cell.storageType] = cell.storageDescriptionField.text!
            }
        }
        
        if storageMethods.isEmpty {
            let alert = UIAlertController(title: "Error", message: "No storage method is selected \nor filled in", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        } else {
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
}

extension StorageSelectionViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StorageCell", for: indexPath) as! StorageDetailTableViewCell
        let storageTypeCell = storageTypeCells[indexPath.row]
        //            cell.storageTypeLabel.text = storageTypeCell.title.rawValue
        cell.storageDescriptionField.placeholder = storageTypeCell.placeHolder
        cell.storageType = storageTypeCell.title
        cell.storageDescriptionField.delegate = self
        
        if let storageMethod = storageMethods?[storageTypeCell.title.rawValue] {
            cell.storageDescriptionField.text = storageMethod
            cell.isOwned.isChecked = true
        }
        
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("indexpath \(indexPath)")
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storageTypeCells.count
    }
}

extension StorageSelectionViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}
