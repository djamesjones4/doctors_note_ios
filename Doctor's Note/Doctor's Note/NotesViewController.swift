 //
//  NotesViewController.swift
//  Doctor's Note
//
//  Created by Derek Jones on 7/3/17.
//  Copyright © 2017 Derek. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {

    @IBOutlet weak var NotesTableView: UITableView!
    
    fileprivate let model = NotesDataModel()
    fileprivate var selectedNote: [String: Any] = [:]
    
    var requestedPersonID: Int = 0 {
        didSet {
            if requestedPersonID > 0 {
                model.getNotes(forId: requestedPersonID)
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        model.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return model.notes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create cell inside this function which will contain the below
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") {
            cell.accessoryType = .disclosureIndicator
            // TODO: reformat date for note
            let date = model.notes?[indexPath.row]["created_at"] as? String ?? ""
            let noteTitle = model.notes?[indexPath.row]["title"] as? String ?? ""
            
            let cellText = date + ": " + noteTitle
            
            cell.textLabel?.text = cellText
            print(model.notes?[indexPath.section]["title"] as Any)
            // return UITableViewCell
            return cell
        } else {
            return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let singleNote = model.notes?[indexPath.row] {
            selectedNote = singleNote
            
            let storyboard = UIStoryboard(name: Storyboards.main, bundle: nil)
            if let nextView = storyboard.instantiateViewController(withIdentifier: Controllers.singleNote) as? SingleNoteViewController {
                nextView.requestedNote = selectedNote
                navigationController?.pushViewController(nextView, animated: true)
            }
        }

    }
}

extension NotesViewController: NotesModelDelegate {
    
    func notesRetrievalFailed(error: NSError?) {
        
        let alert = UIAlertController(title: "Error", message: "There was an error retrieving the notes.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { action in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func notesRetrievalSucceeded() {
     
        // TODO: Populate the table
        NotesTableView.reloadData()
    }
}
