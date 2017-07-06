//
//  MenuViewController.swift
//  Doctor's Note
//
//  Created by Derek Jones on 6/28/17.
//  Copyright © 2017 Derek. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, GuillotineMenu {

    @IBOutlet weak var loginButton: UIButton!
    
    var titleLabel: UILabel?
    var dismissButton: UIButton?

    private var isLoggedIn: Bool = false

    override func viewDidLoad() {
        
        super.viewDidLoad()

        dismissButton = {
            let button = UIButton(frame: .zero)
            button.setImage(UIImage(named: "ic_menu"), for: .normal)
            button.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
            return button
        }()
        
        titleLabel = {
            let label = UILabel()
            label.numberOfLines = 1;
            label.text = "Doctors Note"
            label.font = UIFont.boldSystemFont(ofSize: 17)
            label.textColor = UIColor.black
            label.sizeToFit()
            return label
        }()
        
        setupLoginButton()
        setupObservers()
    }
    
    private func setupObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupLoginButton), name: .loginSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupLoginButton), name: .didLogout, object: nil)
    }
    
    @objc fileprivate func setupLoginButton() {
        
        // if token exists, assume we're logged in
        isLoggedIn = (UserDefaults.standard.object(forKey: UserDefaultsKeys.token) != nil)
        
        let title = (isLoggedIn) ? "Log Out" : "Log In"
        let oldFrame = loginButton.frame
        loginButton.setTitle(title, for: .normal)
        let frame = (isLoggedIn) ? CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y, width: 60.0, height: oldFrame.size.height) :
            CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y, width: 46.0, height: oldFrame.size.height)
        loginButton.frame = frame
    }

    func dismissButtonTapped(_ sender: UIButton) {
        
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        if isLoggedIn == false {
            presentingViewController?.dismiss(animated: true, completion: {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: Storyboards.main, bundle: nil)
                    let login = storyboard.instantiateViewController(withIdentifier: Controllers.login)
                    
                    UIApplication.shared.windows[0].rootViewController?.present(login, animated: true, completion: nil)
                }
            })
        } else {
            Networking.logout()
            
            ActivityManager.activityBegan()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.setupLoginButton()
                ActivityManager.activityEnded()
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}

extension MenuViewController: GuillotineAnimationDelegate {
    
    func animatorDidFinishPresentation(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishPresentation")
    }
    func animatorDidFinishDismissal(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishDismissal")
    }
    
    func animatorWillStartPresentation(_ animator: GuillotineTransitionAnimation) {
        print("willStartPresentation")
    }
    
    func animatorWillStartDismissal(_ animator: GuillotineTransitionAnimation) {
        print("willStartDismissal")
    }
}

