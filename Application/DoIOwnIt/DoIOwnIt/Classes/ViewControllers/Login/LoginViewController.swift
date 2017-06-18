//
//  LoginViewController.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/16/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet weak var fbLoginButtonView: FBSDKLoginButton!
    let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fbLoginButtonView.delegate = self
        fbLoginButtonView.readPermissions = ["public_profile", "email"]
        
        headerLabel.font = UIFont(name: "DINCond-Medium", size: 42)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            Analytics.setUserProperty(Auth.auth().currentUser?.uid, forName: "user_id")
            self.performSegue(withIdentifier: "ShowApplication", sender: nil)
        } else {
            Analytics.logEvent("screen_view", parameters: ["screen_name": "login"])
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension LoginViewController : FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error.localizedDescription)
            return
        }
        
        print(FBSDKAccessToken.current().tokenString)
        
        if !result.isCancelled {
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            loginViewModel.signInUser(withCredential: credential, completionHandler: { response in
                switch response {
                case let .success(responseData) :
                    print(responseData)
                    self.performSegue(withIdentifier: "ShowApplication", sender: nil)
                case let .error(errorMessage) :
                    print(errorMessage)
                }
            })
        } else {
            Analytics.logEvent("fb_cancel_login", parameters: nil)
        }
        
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User logged out from FB")
        let firebaseAuth = Auth.auth()
        Analytics.logEvent("fb_logout", parameters: nil)
        
        do {
            try firebaseAuth.signOut()
            
        }catch let signoutError as NSError {
            print(signoutError)
        }
    }
}

