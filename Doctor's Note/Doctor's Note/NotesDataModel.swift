//
//  NotesDataModel.swift
//  Doctor's Note
//
//  Created by Derek Jones on 7/3/17.
//  Copyright © 2017 Derek. All rights reserved.
//

import UIKit

protocol NotesModelDelegate {
    func notesRetrievalSucceeded()
    func notesRetrievalFailed(error: NSError?)
}

class NotesDataModel {
    
    var notes: [[String : Any]]? = []
    var delegate: NotesModelDelegate? = nil
    
    func getNotes(forId requestedPersonID: Int) {
        
        if requestedPersonID > 0 {
            // make the call to get this persons notes
            Networking.getNotes(requestedPersonID: requestedPersonID, completion: { (data, response, error) in
                if error != nil {
                    // handle error
                    self.delegate?.notesRetrievalFailed(error: error)
                } else {
                    if let data = data {
                        self.notes = data as? [[String : Any]]
                        for dict in self.notes! {
                            if let noteid = dict["id"] as? Int {
                                print("noteID: \(noteid):", dict)
                            }
                        }
                        
                        self.delegate?.notesRetrievalSucceeded()
                    } else {
                        
                        let err = NSError(domain: "doctorsNoteErrorDomain", code: 404, userInfo: ["message" : "No data"])
                        self.delegate?.notesRetrievalFailed(error: err)
                    }
                }
            })
        }
    }
}
