//
//  Networking.swift
//  Doctor's Note
//
//  Created by Derek Jones on 6/28/17.
//  Copyright © 2017 Derek. All rights reserved.
//

import UIKit

class Networking: NSObject {
    
    private override init() {}
    
    class func doLogin(user: String, pass: String, completion: @escaping (_ data : Data, _ response: HTTPURLResponse, _ error: NSError?) -> ()) {
        
        if user.isEmpty || pass.isEmpty {
            // message: must enter username and password
            return
        }
        
        let url = URL(string: "https://doctors-note.herokuapp.com/api/signIn")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url!)
        
        request.httpMethod = "POST"
        
        let dictionary = ["username": user, "password": pass]

        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")

        request.httpBody = try! JSONSerialization.data(withJSONObject: dictionary)
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let _:Data = data else { return }
            
            let json:Any?
            
            do
            {
                json = try JSONSerialization.jsonObject(with: data!, options: [])
            }
            catch
            {
                return
            }
            
            
            guard let server_response = json as? NSDictionary else
            {
                return
            }
            
            if let token = server_response["token"] as? String
            {
                let preferences = UserDefaults.standard
                preferences.set(token, forKey: "session")
                preferences.synchronize()
                
                DispatchQueue.main.async () {
                    // Send login success notification
                    NotificationCenter.default.post(name: .loginSuccess, object: nil)
                }
            } else {
                DispatchQueue.main.async {
                    // Send login failure notification
                    var infoDict : [String : Any]? = nil
                    if let errorMsg = server_response["error"] as? String {
                        infoDict = ["message" : errorMsg]
                    }
                    
                    NotificationCenter.default.post(name: .loginFailure, object: infoDict)
                }
            }
            
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    if let data = data {
                        completion(data, response, error as NSError?)
                    }
                }
            }
            
            
        })
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        task.resume()
    }

    class func loadPersonData(token: String, completion: @escaping (_ data : Data, _ response: HTTPURLResponse, _ error: NSError?) -> ()) {
        // gets clients of practitioner and practitioners of clients
        let url = URL(string: "https://doctors-note.herokuapp.com/api/signIn")

        
    }
    
    class func getNotes() {
        // gets individual note data when a practitioner clicks on a client
        
    }
}
