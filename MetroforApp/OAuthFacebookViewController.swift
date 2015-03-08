//
//  OAuthFacebookViewController.swift
//  MetroforApp
//
//  Created by Adolfho Athyla on 07/03/15.
//  Copyright (c) 2015 Adolfho Athyla. All rights reserved.
//

import UIKit

class OAuthFacebookViewController: UIViewController, FBLoginViewDelegate {

    @IBOutlet var profilePictureView: FBProfilePictureView!
    
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let permissions = ["public_profile", "email"]
        
        let loginView = FBLoginView()
        loginView.delegate = self
        loginView.center = self.view.center
        loginView.readPermissions = permissions
        self.view.addSubview(loginView)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if FBSession.activeSession().isOpen {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let mytabBar = appDelegate.window?.rootViewController as UITabBarController
        let myNavigation = mytabBar.viewControllers?[1] as UINavigationController
        
        let initialViewController = myNavigation.topViewController as InitialViewController
        
        initialViewController.nameLabel.text = self.nameLabel.text
        initialViewController.profilePictureView.profileID = self.profilePictureView.profileID
        initialViewController.statusLabel.text = self.statusLabel.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func buttonNotNow(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        self.profilePictureView.profileID = user.objectID
        self.nameLabel.text = user.name
        
    }
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        self.statusLabel.text = "Bem vindo"
    }
    
    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
        self.statusLabel.text = "Você não está logado"
        self.profilePictureView.profileID = nil
        self.nameLabel.text = ""
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
