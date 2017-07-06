//
//  DoctorsNoteNotificationNames.swift
//  Doctor's Note
//
//  Created by Derek Jones on 6/28/17.
//  Copyright © 2017 Derek. All rights reserved.
//

import UIKit

extension Notification.Name {
    
    // MARK: - Networking
    static let loginSuccess = Notification.Name("loginSuccess")
    static let loginFailure = Notification.Name("loginFailure")
    static let didLogout = Notification.Name("didLogout")
    static let didAutoLogout = Notification.Name("didAutoLogout")
    static let noteUpdated = Notification.Name("noteUpdated")
}
