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
import GoogleSignIn

class LoginViewController: UIViewController {

    @IBOutlet fileprivate var headerLabel: UILabel!
    @IBOutlet fileprivate weak var fbLoginButtonView: FBSDKLoginButton!
    
    @IBOutlet fileprivate weak var googleSignInButtonView: GIDSignInButton!
    
    fileprivate let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let currentUser = Auth.auth().currentUser {
            analyticsManager.setUserProperty(userProperty: currentUser.uid, userPropertyValue: "user_id")
            showApplication()
        } else {
            analyticsManager.logEvent("view_screen", parameters: ["screen_name": "login"])
        }
    }
    
    func showApplication() {
        self.performSegue(withIdentifier: "ShowApplication", sender: nil)
    }
    
    func configure() {
        fbLoginButtonView.delegate = self
        fbLoginButtonView.readPermissions = ["public_profile", "email"]
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let nc = NotificationCenter.default // Note that default is now a property, not a method call
        nc.addObserver(forName:Notification.Name(rawValue:"GoogleSignIn"),object:nil, queue:nil) {
            notification in
            // Handle notification
            self.showApplication()
        }
        
        headerLabel.font = UIFont(name: "DINCond-Medium", size: 42)
        
        for const in fbLoginButtonView.constraints {
            if const.firstAttribute == NSLayoutAttribute.height && const.constant == 28 {
                fbLoginButtonView.removeConstraint(const)
            }
        }
        
        for const in googleSignInButtonView.constraints {
            if const.firstAttribute == NSLayoutAttribute.height {
                googleSignInButtonView.removeConstraint(const)
            }
        }
    }
    
    
    @IBAction func didTapGoogleSignIn(_ sender: GIDSignInButton) {
        GIDSignIn.sharedInstance().signIn()
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
        
        if !result.isCancelled {
            fbLoginButtonView.isHidden = true
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            loginViewModel.signInUser(withCredential: credential, completionHandler: { response in
                switch response {
                case let .success(responseData) :
                    print(responseData)
                    self.showApplication()
                case let .error(errorMessage) :
                    print(errorMessage)
                }
            })
        } else {
            fbLoginButtonView.isHidden = false
            analyticsManager.logEvent("fb_cancel_login", parameters: nil)
        }
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User logged out from FB")
        let firebaseAuth = Auth.auth()
        analyticsManager.logEvent("fb_logout", parameters: nil)
        
        do {
            try firebaseAuth.signOut()
            
        } catch let signoutError as NSError {
            print(signoutError)
        }
    }
}

extension LoginViewController: GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        loginViewModel.signInUser(withCredential: credential, completionHandler: { response in
            switch response {
            case let .success(responseData) :
                print(responseData)
                self.showApplication()
            case let .error(errorMessage) :
                print(errorMessage)
            }
        })
    }
    
}
