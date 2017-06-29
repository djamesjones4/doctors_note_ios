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
    
    class func doLogin(user: String, pass: String, completion: @escaping (_ response: HTTPURLResponse, _ error: NSError?) -> ()) {
        
        if user.isEmpty || pass.isEmpty {
            return
        }
        
        let url = URL(string: "http://www.kaleidosblog.com/tutorial/login/api/login")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let paramToSend = "username=" + user + "&password=" + pass
        
        request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        
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
            
            if let data_block = server_response["data"] as? NSDictionary
            {
                if let session_data = data_block["session"] as? String
                {
                    let preferences = UserDefaults.standard
                    preferences.set(session_data, forKey: "session")
                    preferences.synchronize()
                    
                    DispatchQueue.main.async () {
                        // Send login success notification
                        NotificationCenter.default.post(name: .loginSuccess, object: nil)
                        
                        if let response = response as? HTTPURLResponse {
                            completion(response, error as NSError?)
                        }
                    }
                }
            }
            
        })
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        task.resume()
    }

    class func loadPersonData() {
     // gets clients of practitioner
        
    }
    
    class func getNotes() {
        // gets individual note data when a practitioner clicks on a client
        
    }
}
