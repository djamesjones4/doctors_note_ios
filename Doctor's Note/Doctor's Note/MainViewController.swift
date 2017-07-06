//
//  MainViewController.swift
//  Doctor's Note
//
//  Created by Derek Jones on 6/28/17.
//  Copyright © 2017 Derek. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barButton: UIButton!
    @IBOutlet weak var autoLogoutInfoLabel: UILabel!
    
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    fileprivate var model = MainDataModel()
    fileprivate var selectedPersonId: Int = 0
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view.
        setupObservers()
        model.delegate = self
        
        navigationController?.navigationBar.barTintColor = UIColor.orange
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "free_stethoscope_by_markbartle-d9b3h1z.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        // no lines where there aren't cells
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    fileprivate func setupObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .loginSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onLogout), name: .didLogout, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onLogout), name: .didAutoLogout, object: nil)
    }
    
    @objc fileprivate func loadData(notification: Notification) {
        
        // make the network call to load table data
        model.loadData()
        print("loading data")
        
        autoLogoutInfoLabel.isHidden = true
    }
    
    @objc fileprivate func onLogout(notification: Notification) {
        
        model.personData = nil
        tableView.reloadData()
        
        if notification.name == .didAutoLogout {
            autoLogoutInfoLabel.isHidden = false
            
            // make sure we're on the home screen
            navigationController?.popToRootViewController(animated: false)
            if let root = UIApplication.shared.windows[0].rootViewController {
                if let _ = root.presentedViewController {
                    root.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      return model.personData?.count ?? 0

    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Futura", size: 18)!
        header.textLabel?.textColor = UIColor.black
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if let num: NSNumber = UserDefaults.standard.object(forKey: UserDefaultsKeys.isPractitioner) as? NSNumber {
            let pract = num.boolValue
            
            if pract {
                return "Clients"
            } else {
                return "Practitioners"
            }
        }
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create cell inside this function which will contain the below
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") {
            cell.accessoryType = .disclosureIndicator
            let firstName = model.personData?[indexPath.row]["firstname"] as? String ?? ""
            let lastName = model.personData?[indexPath.row]["lastname"] as? String ?? ""
            
            let cellText = firstName + " " + lastName
            
            cell.textLabel?.text = cellText
            print(model.personData?[indexPath.section]["firstname"] as Any)
            // return UITableViewCell
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let id = model.personData?[indexPath.row]["id"] as? Int {
            selectedPersonId = id
            performSegue(withIdentifier: SegueIdentifiers.toNotes, sender: nil)
        }
    }

    
    @IBAction func menuButtonTapped(_ sender: Any) {
        
        let menuViewController = storyboard!.instantiateViewController(withIdentifier: Controllers.menu)
        menuViewController.modalPresentationStyle = .custom
        menuViewController.transitioningDelegate = self
        
        presentationAnimator.animationDelegate = menuViewController as? GuillotineAnimationDelegate
        presentationAnimator.supportView = navigationController!.navigationBar
        presentationAnimator.presentButton = sender as? UIView
        UIApplication.shared.windows[0].rootViewController?.present(menuViewController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.toNotes {
            // Get the new view controller using segue.destinationViewController.
            if let nextView = segue.destination as? NotesViewController {
                // Pass the selected object to the new view controller.
                nextView.requestedPersonID = selectedPersonId
            }
            
            selectedPersonId = 0
        }
    }
    
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
