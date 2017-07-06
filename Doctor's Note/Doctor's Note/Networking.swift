//
//  Networking.swift
//  Doctor's Note
//
//  Created by Derek Jones on 6/28/17.
//  Copyright © 2017 Derek. All rights reserved.
//

import UIKit

class Networking: NSObject {
    
    static var sessionToken: String? = nil
    
    private override init() {}
    
    class func doAutoLogin() {
        
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: UserDefaultsKeys.token) {
            
        }
    }
    
    class func doLogin(user: String, pass: String, completion: @escaping (_ data : Data, _ response: HTTPURLResponse, _ error: NSError?) -> ()) {
        
        if user.isEmpty || pass.isEmpty {
            // message: must enter username and password
            return
        }
        
        let url = URL(string: networkingURLs.signIn)
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url!)
        
        request.httpMethod = "POST"
        
        let dictionary = ["username": user, "password": pass]

        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")

        request.httpBody = try! JSONSerialization.data(withJSONObject: dictionary)
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            ActivityManager.activityEnded()
            
            guard let _:Data = data else { return }
            
            let json:Any?
            
            do {
                json = try JSONSerialization.jsonObject(with: data!, options: [])
            }
            catch {
                return
            }
            
            guard let server_response = json as? NSDictionary else {
                return
            }
            
            if let token = server_response["token"] as? String {
                sessionToken = token
                    
                let preferences = UserDefaults.standard
                let id = server_response["personId"] as? Int
                let isPractitioner = server_response["ispractitioner"] as? Bool
                
                preferences.set(token, forKey: UserDefaultsKeys.token)
                preferences.set(id, forKey: UserDefaultsKeys.id)
                preferences.set(isPractitioner, forKey: UserDefaultsKeys.isPractitioner)
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
        
        ActivityManager.activityBegan()
        task.resume()
    }

    class func loadPersonData(completion: @escaping (_ data : [NSDictionary]?, _ response: HTTPURLResponse, _ error: NSError?) -> ()) {
        // gets clients of practitioner and practitioners of clients
        if sessionToken != nil {
            
            ActivityManager.activityEnded()
            
            let url = URL(string: networkingURLs.getPeople)
            let session = URLSession.shared
            let request = NSMutableURLRequest(url: url!)
            let dictionary = [ "token" : sessionToken ]
            print(dictionary)
            request.httpMethod = "POST"            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            }
            catch {
                print(dictionary)
                return
            }
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                
                ActivityManager.activityEnded()
                guard let _:Data = data else { return }
                
                let json:Any?
                
                do {
                    json = try JSONSerialization.jsonObject(with: data!, options: [])
                }
                catch {
                    return
                }
                
                guard let server_response = json as? [NSDictionary] else {
                    return
                }
                
                DispatchQueue.main.async {
                    if let response = response as? HTTPURLResponse {
                        completion(server_response, response, error as NSError?)
                    }
                }
            })
            
            ActivityManager.activityBegan()
            task.resume()
        } else {
            // TODO: handle error - need to log in before
            print("session token is nil")
        }
    }
    
    class func getNotes(requestedPersonID: Int, completion: @escaping (_ data : [NSDictionary]?, _ response: HTTPURLResponse, _ error: NSError?) -> ()) {
        // get individual note data when a practitioner clicks on a client
        if sessionToken != nil {
            
            let url = URL(string: networkingURLs.getNotes)
            let session = URLSession.shared
            let request = NSMutableURLRequest(url: url!)
            let dictionary = [ "token" : sessionToken!, "requestedPersonID": requestedPersonID ] as [String : Any]
            print(dictionary)
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            }
            catch {
                print(dictionary)
                return
            }
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                
                ActivityManager.activityEnded()
                guard let _:Data = data else { return }
                
                let json:Any?
                
                do {
                    json = try JSONSerialization.jsonObject(with: data!, options: [])
                }
                catch {
                    return
                }
                
                guard let server_response = json as? [NSDictionary] else {
                    return
                }
                
                DispatchQueue.main.async {
                    if let response = response as? HTTPURLResponse {
                        completion(server_response, response, error as NSError?)
                    }
                }
            })
            
            ActivityManager.activityBegan()
            task.resume()
        } else {
            // TODO: handle error - need to log in before
            print("session token is nil")
    }
}

    class func updateNote(noteId: Int, noteContent: String, completion: @escaping (_ data: [NSDictionary]?, _ response: HTTPURLResponse, _ error: NSError?) -> ()){
        if sessionToken != nil {
            
            let url = URL(string: networkingURLs.updateNotes)
            let session = URLSession.shared
            let request = NSMutableURLRequest(url: url!)
            let dictionary = [ "token" : sessionToken!, "noteId": noteId, "noteContent": noteContent] as [String : Any]
            print(dictionary)
            request.httpMethod = "PATCH"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            }
            catch {
                print(dictionary)
                return
            }
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                
                ActivityManager.activityEnded()
                guard let _:Data = data else { return }
                
                let json:Any?
                
                do {
                    json = try JSONSerialization.jsonObject(with: data!, options: [])
                }
                catch {
                    return
                }
                
                guard let server_response = json as? [NSDictionary] else {
                    return
                }
                
                DispatchQueue.main.async {
                    if let response = response as? HTTPURLResponse {
                        completion(server_response, response, error as NSError?)
                    }
                }
            })
            
            ActivityManager.activityBegan()
            task.resume()
        } else {
            // TODO: handle error - need to log in before
            print("session token is nil")
        }
    }
}
