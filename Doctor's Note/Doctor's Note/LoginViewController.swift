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
        
        Networking.doLogin(user: uName, pass: pass, completion: { data, response, error in
            
            let json:Any?
            
            do {
                json = try JSONSerialization.jsonObject(with: data, options: [])
            }
            catch {
                //TODO: possibly have an alert message here
                return
            }
            
            guard let server_response = json as? NSDictionary else {
                return
            }
            
            if error != nil {
                // handle error
            } else {
                let statusCode = response.statusCode
                if statusCode >= 200 && statusCode < 300 {
                    // sucess!!
                    self.isLoggedIn = true
                    self.loginButton.setTitle("Log out", for: UIControlState.normal)
                    self.dismiss(animated: true, completion: nil)
                } else if statusCode >= 300 && statusCode < 400 {
                    
                } else if statusCode >= 400 && statusCode < 500 {                
                    if let errorMsg = server_response["error"] as? String {
                        let alert = UIAlertController(title: nil, message: errorMsg, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                        alert.addAction(okAction)
                        
                        self.present(alert, animated: true, completion: {
                            self.usernameField.becomeFirstResponder()
                        })
                        self.isLoggedIn = false
                        self.loginButton.setTitle("Log in", for: UIControlState.normal)
                    }
                }
            }
        })
    }
}

