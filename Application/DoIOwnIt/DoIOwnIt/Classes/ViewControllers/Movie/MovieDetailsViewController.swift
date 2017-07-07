//
//  MovieDetailsViewController.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/22/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ownStatusLabel: UILabel!
    @IBOutlet weak var plotTitle: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var castTitle: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var directorTitle: UILabel!
    @IBOutlet weak var directorsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ownLabel: UILabel!
    @IBOutlet weak var ownTitle: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var yearLabel: UILabel!
    
    let labelFont = UIFont(name: "DINCond-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
    
    var fromViewController : String!
    var id : Int?
    var isOwned: Bool = false
    let movieDetailsViewModel = MovieDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.backBarButtonItem?.title = "Back"
        self.editBarButton.isEnabled = false
        
        let nc = NotificationCenter.default // Note that default is now a property, not a method call
        nc.addObserver(forName:Notification.Name(rawValue:"StorageMethodsSaved"),object:nil, queue:nil) {
            notification in
            // Handle notification
            if let editBarButton = self.editBarButton {
                editBarButton.isEnabled = true
            }
            self.getMovie()
        }
        
        nc.addObserver(forName:Notification.Name(rawValue:"StorageMethodsCancelled"),object:nil, queue:nil) {
            notification in
            // Handle notification
            if let editBarButton = self.editBarButton {
                editBarButton.isEnabled = true
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        Analytics.logEvent("view_screen", parameters: ["screen_name": "movie_details"])

        self.overviewLabel.text = ""
        self.overviewLabel.sizeToFit()
        self.castLabel.text = ""
        self.castLabel.sizeToFit()
        self.directorsLabel.text = ""
        self.directorsLabel.sizeToFit()
        self.titleLabel.text = ""
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getMovie()
        titleLabel.font = UIFont(name: "DINCond-Light", size: 36) ?? UIFont.systemFont(ofSize: 36)
        ownTitle.font = labelFont
        plotTitle.font = labelFont
        castTitle.font = labelFont
        directorTitle.font = labelFont
    }
    
    @IBAction func didTapEdit(_ sender: Any) {
        Analytics.logEvent("edit_storage_methods", parameters: ["movie_id": self.id!])
        showStoragePopUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMovie(){
        movieDetailsViewModel.getMovie(id: self.id!, completionHandler: { response in
            switch response {
            case .success(_) :
                self.posterImageView.sd_setImage(with: URL(string: String(format : "%@%@", ConfigUtil.sharedInstance.movieDBImageBaseURL!, self.movieDetailsViewModel.posterPath!)))
                self.overviewLabel.text = self.movieDetailsViewModel.overview
                self.overviewLabel.sizeToFit()
                self.castLabel.text = self.movieDetailsViewModel.formattedCastString
                self.castLabel.sizeToFit()
                self.directorsLabel.text = self.movieDetailsViewModel.formattedDirectorsString
                self.directorsLabel.sizeToFit()
                self.titleLabel.text = self.movieDetailsViewModel.title
                
                self.yearLabel.text = StringUtil.formatReleaseDate(strValue: self.movieDetailsViewModel.releasedDate!, offsetBy: 4)
            
                // set label Attribute
                self.ownLabel.attributedText = self.prepareAttributedString()
                
                if self.fromViewController != nil {
                    if self.fromViewController == String(describing: MovieListTableViewController.self){
                        self.actionButton.setTitle("Add to Library",for: .normal)
                    }
                }
                
                if let storageMethods =  self.movieDetailsViewModel.storageMethods {
                    if !storageMethods.isEmpty {
                        self.isOwned = true
                        self.editBarButton.isEnabled = true
                        self.actionButton.setTitle("Remove from Library",for: .normal)
                    } else {
                        self.editBarButton.isEnabled = false
                    }
                    
                }
                
                
                
            case .error(_):
                let alert = UIAlertController(title: "Error", message: "Having problems retreiving information\nPlease check your network connectivity", preferredStyle: UIAlertControllerStyle.alert)
                self.present(alert, animated: true, completion: nil)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        _ = self.navigationController?.popViewController(animated: true)
                        
                    default:
                        break
                    }
                }))
            }
        })
    }
    

    @IBAction func addToLibraryAction(_ sender: Any) {
        
        if fromViewController != nil {
            if fromViewController == String(describing: UserMovieLibraryViewController.self) || isOwned {
                
                let alert = UIAlertController(title: "Confirm removal", message: "Do you want to remove movie\nfrom library?", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default
                    , handler: { action in
                    switch action.style {
                    case .default:
                        self.movieDetailsViewModel.removeMovie(movieId: self.movieDetailsViewModel.id!, completionHandler: { response in
                            switch response {
                            case .success(_) :
                                _ = self.navigationController?.popViewController(animated: true)
                            case let .error(error) :
                                log.error(error)
                            }
                        })
                        
                    case .cancel:
                        break
                    default:
                        break
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }else if fromViewController == String(describing: MovieListTableViewController.self){
                showStoragePopUp()
            }
        }
        
    }
    
    func showStoragePopUp(){
        let popoverVc = UIStoryboard(name: "Movie", bundle: nil).instantiateViewController(withIdentifier: "sbStorageSelection") as! StorageSelectionViewController
        popoverVc.movieId = self.movieDetailsViewModel.id
        popoverVc.movieTitle = self.movieDetailsViewModel.title
        popoverVc.posterPath = self.movieDetailsViewModel.posterPath
        popoverVc.releasedDate = self.movieDetailsViewModel.releasedDate
        popoverVc.storageMethods = self.movieDetailsViewModel.storageMethods
        self.addChildViewController(popoverVc)
        popoverVc.view.frame = self.view.frame
        self.view.addSubview(popoverVc.view)
        popoverVc.didMove(toParentViewController: self)
        if let editBarButton = editBarButton {
            editBarButton.isEnabled = false
        }
        
    }

    func prepareAttributedString() -> NSAttributedString {
        let storageMethods = self.movieDetailsViewModel.storageMethods
        let finalAttrString = NSMutableAttributedString()
        if (storageMethods?.count)! > 0 {
            for (type, methods) in storageMethods! {
                var myMutableString = NSMutableAttributedString()
                myMutableString = NSMutableAttributedString(string: type, attributes: [:])
                myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 235/255, green: 186/255, blue: 9/255, alpha: 1), range: NSRange(location:0,length:myMutableString.length))
                myMutableString.append(NSMutableAttributedString(string: String(format : " - %@\n",methods), attributes: [:]))
                finalAttrString.append(myMutableString)
            }
        }else{
            finalAttrString.append(NSMutableAttributedString(string: "N/A\n", attributes: [:]))
        }
        
        return finalAttrString
    }
    
}
