//
//  NewNoteViewController.swift
//  Doctor's Note
//
//  Created by Derek Jones on 7/5/17.
//  Copyright © 2017 Derek. All rights reserved.
//

import UIKit

class NewNoteViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var newNoteTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        newNoteTextView.isEditable = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        newNoteTextView.becomeFirstResponder()
        newNoteTextView.isEditable = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        newNoteTextView.becomeFirstResponder()
    }

    


}
