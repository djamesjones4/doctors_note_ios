//
//  Constants.swift
//  Doctor's Note
//
//  Created by Derek Jones on 6/28/17.
//  Copyright © 2017 Derek. All rights reserved.
//

import UIKit

struct Storyboards {
    static let main = "Main"
}

struct Controllers {
    static let login = "loginViewController"
    static let main = "main"
    static let menu = "menuController"
    static let singleNote = "singleNote"
}

struct UserDefaultsKeys {
    static let token = "session"
    static let isPractitioner = "isPractitioner"
    static let id = "id"
}

struct SegueIdentifiers {
    static let toNotes = "toNotes"
    static let toSingleNote = "toSingleNote"
}

struct networkingURLs {
    static let localBaseURL = "http://localhost:3000"
    static let serverBaseURL = "https://doctors-note.herokuapp.com"
    
    static let signIn = "\(serverBaseURL)/api/signIn"
    static let getPeople = "\(serverBaseURL)/api/persons"
    static let getNotes = "\(serverBaseURL)/api/notes"
    static let updateNotes = "\(serverBaseURL)/api/notes"
}
