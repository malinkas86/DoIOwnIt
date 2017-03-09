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
    let movieDetailsViewModel = MovieDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovie()

        // Do any additional setup after loading the view.
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
                
            default : break
            }
        })
    }
    

    @IBAction func addToLibraryAction(_ sender: Any) {
        let popoverVc = UIStoryboard(name: "Movie", bundle: nil).instantiateViewController(withIdentifier: "sbStorageSelection") as! StorageSelectionViewController
        popoverVc.movieId = self.movieDetailsViewModel.id
        popoverVc.movieTitle = self.movieDetailsViewModel.title
        popoverVc.posterPath = self.movieDetailsViewModel.posterPath
        popoverVc.releasedDate = self.movieDetailsViewModel.releasedDate
        print("releasedDate \(self.movieDetailsViewModel.releasedDate)")
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

}
