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
    
    var personData: [String : Any]? = nil
    weak var delegate: mainModelDelegate? = nil
    
    func loadData() {
        
        Networking.loadPersonData(completion: { (data, response, error) in
            if error != nil {
                // handle error
                self.delegate?.loadDataFailed()
            } else {
                if let data = data {
                    self.personData = data as? [String : Any]
                    self.delegate?.loadDataSucceded()
                    print("persondata: ", self.personData)
                } else {
                    self.delegate?.loadDataFailed()
                }
            }
        })
    }
    
}
