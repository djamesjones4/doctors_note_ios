//
//  StartupSequence.swift
//  Doctor's Note
//
//  Created by Derek Jones on 7/6/17.
//  Copyright © 2017 Derek. All rights reserved.
//

import UIKit

class StartupSequence {
    
    class func onAppLaunch() {
        
        autoLogin()
    }
    
    class func autoLogin() {
        
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: UserDefaultsKeys.token) {
            // TODO: call auto-login on Networking
        } else {
            // Delete all UserDefaults
            Networking.logout()
        }
    }
}
