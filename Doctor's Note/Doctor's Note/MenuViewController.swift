//
//  MenuViewController.swift
//  Doctor's Note
//
//  Created by Derek Jones on 6/28/17.
//  Copyright © 2017 Derek. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, GuillotineMenu {

    var titleLabel: UILabel?
    var dismissButton: UIButton?


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
            label.textColor = UIColor.white
            label.sizeToFit()
            return label
        }()
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
        
        presentingViewController!.dismiss(animated: true, completion: nil)
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

