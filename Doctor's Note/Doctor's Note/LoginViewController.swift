//
//  LoginViewController.swift
//  Doctor's Note
//
//  Created by Derek Jones on 6/27/17.
//  Copyright © 2017 Derek. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dataLabel: UILabel!
    
    var dataObject: String = ""
    var isLoggedIn: Bool = false

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.dataLabel!.text = dataObject
//    }

    override func viewDidLoad() {
        
        let preferences = UserDefaults.standard
        
        if(preferences.object(forKey: "session") != nil) {
            doLogin()
        } else {
            // handle user not logged in
        }
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        
        if isLoggedIn {
            // do logout stuff here
            UserDefaults.standard.removeObject(forKey: "session")
            UserDefaults.standard.synchronize()
            
            isLoggedIn = false
            loginButton.setTitle("Log in", for: UIControlState.normal)
        } else {
            // do login stuff here
            doLogin()
        }
    }
    
    fileprivate func doLogin() {
        
        guard let uName = usernameField.text else { return }
        guard let pass = passwordField.text else { return }
        if(uName.isEmpty || pass.isEmpty) { return }
        
        // TODO: Show a spinner & keep user from touching anything until the request completes.
        
        Networking.doLogin(user: uName, pass: pass, completion: { response, error in
            if error != nil {
                // handle error
            } else {
                let statusCode = response.statusCode
                if statusCode >= 200 && statusCode < 300 {
                    // sucess!!
                    self.isLoggedIn = true
                    self.loginButton.setTitle("Log out", for: UIControlState.normal)
                    
                    // now navigate to the next screen
                    let storyboard = UIStoryboard(name: Storyboards.main, bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: Controllers.second)
//                    self.navigationController?.pushViewController(vc, animated: true)
                } else if statusCode >= 300 && statusCode < 400 {
                    
                }
            }
        })
    }
}

