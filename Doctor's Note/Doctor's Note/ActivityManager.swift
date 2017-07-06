//
//  ActivityManager.swift
//  Doctor's Note
//
//  Created by Ian Jones on 7/6/17.
//  Copyright © 2017 Derek. All rights reserved.
//

import UIKit

class ActivityManager {
    
    private static let shared = ActivityManager()
    
    private let activityView = ActivityView.init(frame: UIScreen.main.bounds)
    private var activitycount: Int = 0 {
        didSet {
            if activitycount <= 0 {
                activitycount = 0
                ActivityManager.hideImmediately()
            } else if activityView.isHidden {
                showActivityView()
            }
        }
    }
    
    private init() {
        
        activityView.setup()
        
        let window = UIApplication.shared.windows[0]
        activityView.isHidden = true
        window.addSubview(activityView)
        window.sendSubview(toBack: activityView)
    }
    
    
    private func showActivityView() {
        
        let window = UIApplication.shared.windows[0]
        activityView.startAnimation()
        activityView.isHidden = false
        window.bringSubview(toFront: activityView)
    }
    
    class func activityBegan() {
        
        shared.activitycount += 1
    }
    
    class func activityEnded() {
        
        shared.activitycount -= 1
    }
    
    class func hideImmediately() {
        
        // show the activity indicator for a minimum amount of time
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4, execute: {
            let window = UIApplication.shared.windows[0]
            window.sendSubview(toBack: shared.activityView)
            shared.activityView.stopAnimation()
            shared.activityView.isHidden = true
            
            if shared.activitycount != 0 {
                shared.activitycount = 0
            }
        })
    }
    
}
