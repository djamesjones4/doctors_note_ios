//
//  ActivityView.swift
//  Doctor's Note
//
//  Created by Derek Jones on 7/6/17.
//  Copyright © 2017 Derek. All rights reserved.
//

import UIKit

class ActivityView: UIView {

    private let spinner = UIActivityIndicatorView()
    
    func setup() {
        
        backgroundColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        
        spinner.activityIndicatorViewStyle = .whiteLarge
        addSubview(spinner)
        spinner.center = center
    }
    
    func startAnimation() {
        
        spinner.startAnimating()
    }
    
    func stopAnimation() {
        
        spinner.stopAnimating()
    }

}
