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
        
//        for family: String in UIFont.familyNames
//        {
//            print("\(family)")
//            for names: String in UIFont.fontNames(forFamilyName: family)
//            {
//                print("== \(names)")
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if FIRAuth.auth()?.currentUser != nil {
            self.performSegue(withIdentifier: "ShowApplication", sender: nil)
            
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension LoginViewController : FBSDKLoginButtonDelegate {
    
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error.localizedDescription)
            return
        }
        
        print(FBSDKAccessToken.current().tokenString)
        
        if !result.isCancelled {
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            loginViewModel.signInUser(withCredential: credential, completionHandler: { response in
                switch response {
                case let .success(responseData) :
                    print(responseData)
                    self.performSegue(withIdentifier: "ShowApplication", sender: nil)
                case let .error(errorMessage) :
                    print(errorMessage)
                }
            })
        }
        
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User logged out from FB")
        let firebaseAuth = FIRAuth.auth()
        
        do {
            try firebaseAuth?.signOut()
            
        }catch let signoutError as NSError {
            print(signoutError)
        }
    }
}

