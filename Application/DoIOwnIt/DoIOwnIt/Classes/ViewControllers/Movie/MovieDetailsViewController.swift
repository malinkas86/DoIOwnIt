//
//  MovieDetailsViewController.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/22/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit
import SDWebImage

class MovieDetailsViewController: UIViewController {
    
    var id : Int?

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ownStatusLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var castLabel: UILabel!
    
    @IBOutlet weak var directorsLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ownLabel: UILabel!
    
    @IBOutlet weak var actionButton: UIButton!
    var fromViewController : String!
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    let movieDetailsViewModel = MovieDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.backBarButtonItem?.title = "Back"
        if fromViewController != nil {
            if fromViewController == String(describing: UserMovieLibraryViewController.self) {
                actionButton.setTitle("Remove from Library",for: .normal)
            }else if fromViewController == String(describing: MovieListTableViewController.self){
                actionButton.setTitle("Add to Library",for: .normal)
                self.navigationItem.rightBarButtonItem = nil
            }
        }
        let nc = NotificationCenter.default // Note that default is now a property, not a method call
        nc.addObserver(forName:Notification.Name(rawValue:"StorageMethodsSaved"),object:nil, queue:nil) {
            notification in
            // Handle notification
            self.getMovie()
        }
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        getMovie()
    }
    
    
    @IBAction func didTapEdit(_ sender: Any) {
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
                
                
                
                // set label Attribute
                
                self.ownLabel.attributedText = self.prepareAttributedString()
                
            default : break
            }
        })
    }
    

    @IBAction func addToLibraryAction(_ sender: Any) {
        
        
        if fromViewController != nil {
            if fromViewController == String(describing: UserMovieLibraryViewController.self) {
                movieDetailsViewModel.removeMovie(movieId: movieDetailsViewModel.id!, completionHandler: { response in
                    switch response {
                    case .success(_) :
                        _ = self.navigationController?.popViewController(animated: true)
                    case let .error(error) :
                        log.error(error)
                    }
                })
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
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func prepareAttributedString() -> NSAttributedString {
        let storageMethods = self.movieDetailsViewModel.storageMethods
        let finalAttrString = NSMutableAttributedString()
        if (storageMethods?.count)! > 0 {
            for (type, methods) in storageMethods! {
                var myMutableString = NSMutableAttributedString()
                myMutableString = NSMutableAttributedString(string: type, attributes: [:])
                myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.purple, range: NSRange(location:0,length:myMutableString.length))
                myMutableString.append(NSMutableAttributedString(string: String(format : " - %@\n",methods), attributes: [:]))
                finalAttrString.append(myMutableString)
            }
        }else{
            finalAttrString.append(NSMutableAttributedString(string: "N/A\n", attributes: [:]))
        }
        
        return finalAttrString
        
    }
}
