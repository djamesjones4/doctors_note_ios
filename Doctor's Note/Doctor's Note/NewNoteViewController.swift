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
        newNoteTextView.becomeFirstResponder()
        newNoteTextView.isEditable = true
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        newNoteTextView.becomeFirstResponder()
        newNoteTextView.isEditable = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
