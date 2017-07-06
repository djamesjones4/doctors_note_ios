//
//  MainDataModel.swift
//  Doctor's Note
//
//  Created by Derek Jones on 7/1/17.
//  Copyright © 2017 Derek. All rights reserved.
//

import UIKit

protocol mainModelDelegate: class {
    
    func loadDataSucceded()
    func loadDataFailed()
}

class MainDataModel {
    
    var personData: [[String : Any]]? = nil
    weak var delegate: mainModelDelegate? = nil
    
    func loadData() {
        
        Networking.loadPersonData(completion: { (data, response, error) in
            if error != nil {
                // handle error
                self.delegate?.loadDataFailed()
            } else {
                if let data = data as? [[String : Any]] {
                    self.personData = data
                    if let personData = self.personData {
                        for dict in personData {
                            let personid = dict["id"]
                            print("personID: \(String(describing: personid)):", dict)
                            print("person for table: ", self.personData?[0]["firstname"] as Any, self.personData?[0]["lastname"] as Any)
                            self.delegate?.loadDataSucceded()
                        }
                    }
                } else {
                    self.delegate?.loadDataFailed()
                }
            }
        })
    }
    
}
