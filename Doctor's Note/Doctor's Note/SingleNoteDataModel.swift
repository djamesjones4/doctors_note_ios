//
//  SingleNoteDataModel.swift
//  Doctor's Note
//
//  Created by Derek Jones on 7/4/17.
//  Copyright © 2017 Derek. All rights reserved.
//

import UIKit

protocol SingleNoteModelDelegate {
    func notesRetrievalSucceeded()
    func notesRetrievalFailed(error: NSError?)
}

class SingleNoteDataModel {
    var note: [[String : Any]]? = []
    var delegate: SingleNoteModelDelegate? = nil
    
    func updateNote(noteId: Int, noteContent: String) {
        Networking.updateNote(noteId: noteId, noteContent: noteContent, completion: { (data, response, error) in
            if error != nil {
                // handle error
                self.delegate?.notesRetrievalFailed(error: error)
            } else {
                if let data = data {
                    self.note = data as? [[String : Any]]
                    for dict in self.note! {
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
