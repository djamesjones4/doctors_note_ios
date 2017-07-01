//
//  MainViewController.swift
//  Doctor's Note
//
//  Created by Derek Jones on 6/28/17.
//  Copyright © 2017 Derek. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barButton: UIButton!
    
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    fileprivate var model = MainDataModel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupObservers()
        model.delegate = self
        
        navigationController?.navigationBar.barTintColor = UIColor.orange
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }

    fileprivate func setupObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .loginSuccess, object: nil)
        
    }
    
    @objc fileprivate func loadData(notification: Notification) {
        
        // make the network call to load table data
        model.loadData()
        print("loading data")
        
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        
        let menuViewController = storyboard!.instantiateViewController(withIdentifier: Controllers.menu)
        menuViewController.modalPresentationStyle = .custom
        menuViewController.transitioningDelegate = self
        
        presentationAnimator.animationDelegate = menuViewController as? GuillotineAnimationDelegate
        presentationAnimator.supportView = navigationController!.navigationBar
        presentationAnimator.presentButton = sender as? UIView
        present(menuViewController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}

extension MainViewController: mainModelDelegate {
    
    func loadDataSucceded() {
        
        tableView.reloadData()
    }
    
    func loadDataFailed() {
        
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}
