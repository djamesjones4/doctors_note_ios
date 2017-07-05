//
//  SingleNoteViewController.swift
//  Doctor's Note
//
//  Created by Derek Jones on 7/4/17.
//  Copyright © 2017 Derek. All rights reserved.
//

import UIKit

class SingleNoteViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    fileprivate let model = SingleNoteDataModel()
    var requestedNote: [String: Any]? = nil {
        didSet {
            if let _ = viewIfLoaded {
                noteTitleLabel.text = requestedNote?["title"] as? String
                textView.text = requestedNote?["content"] as? String
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textView.text = requestedNote?["content"] as? String
        noteTitleLabel.text = requestedNote?["title"] as? String
        
        let editable = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isPractitioner)
        editButton.isHidden = !editable
        saveButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        textView.isEditable = false
    }
    
    @IBAction func editButton(_ sender: Any?) {
        if textView.isEditable == false {
            textView.isEditable = true
            saveButton.isHidden = false
            editButton.setTitle("Cancel", for: .normal)
            textView.becomeFirstResponder()
            print("you clicked the button")
        } else {
            textView.isEditable = false
            saveButton.isHidden = true
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if saveButton.isHidden == false {
            let updateNoteID = requestedNote?["id"] as! Int
            let updateNoteContent = textView.text as String
            model.updateNote(noteId: updateNoteID, noteContent: updateNoteContent)
            textView.resignFirstResponder()
            textView.isEditable = false
            saveButton.isHidden = true
            editButton.setTitle("Edit", for: .normal)
        }
    }
    

}
