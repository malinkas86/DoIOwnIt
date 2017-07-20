//
//  UIViewController+Shake.swift
//  DoIOwnIt
//
//  Created by Malinka S on 7/20/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit
import Firebase

extension UIViewController: UIActionSheetDelegate {
    open override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let actionSheetController: UIAlertController = UIAlertController(title: "Please select", message: nil, preferredStyle: .actionSheet)
            
            let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                print("Cancel")
            }
            actionSheetController.addAction(cancelActionButton)
            
            let logoutActionButton = UIAlertAction(title: "Logout", style: .destructive)
            { _ in
                let firebaseAuth = Auth.auth()
                analyticsManager.logEvent("logout", parameters: nil)
                
                do {
                    try firebaseAuth.signOut()
                    
                } catch let signoutError as NSError {
                    print(signoutError)
                }
                let appDelegate = UIApplication.shared.delegate
                let rootViewController = appDelegate?.window??.rootViewController
                let loginViewController = rootViewController?.storyboard?.instantiateViewController(withIdentifier: "loginViewController")
                self.present(loginViewController!, animated: true, completion: nil)
                /*
                 AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                 MainViewController *mvc = (MainViewController *)appDelegate.window.rootViewController;
                 LoginViewController *lvc = [mvc.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                 [currentVC presentModalViewController:lvc animated:YES];
                    */
            }
            actionSheetController.addAction(logoutActionButton)
            
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
}
