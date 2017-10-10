//
//  api.swift
//  Snake
//
//  Created by Brandon Price on 10/9/17.
//  Copyright © 2017 Brandon Price. All rights reserved.
//

import Foundation

class API {
    static let rootURLString = "http://127.0.0.1:8081/"
    
    class func createUser(firstName: String, lastName: String, fbToken: String, completionHandler: @escaping (URLResponse, User?) -> Void) {
        let json = ["first_name" : firstName, "last_name" : lastName, "fb_token" : fbToken]
        
        // Perform request.
        API.performRequest(requestType: "POST", urlPath: "users", json: json, token: nil, completionHandler: {
            (response, data) in
            
            handleResponse(response: response, data: data, completionHandler: {
                response, json in
                
                if response != URLResponse.Success {
                    return completionHandler(response, nil)
                }
                
                let userJson = json!["user"] as! [String : Any]
                let user = User.deserialize(json: userJson)
                
                completionHandler(URLResponse.Success, user)
            })
        })
    }
    
    class func findUserByFbToken(fbToken: String, completionHandler: @escaping (URLResponse, User?) -> Void) {
        // Perform request.
        API.performRequest(requestType: "GET", urlPath: "users/fb_token/\(fbToken)", json: nil, token: nil, completionHandler: {
            (response, data) in
            
            handleResponse(response: response, data: data, completionHandler: {
                response, json in
                
                if response != URLResponse.Success {
                    return completionHandler(response, nil)
                }
                
                let userJson = json!["user"] as! [String : Any]
                let user = User.deserialize(json: userJson)
                
                completionHandler(URLResponse.Success, user)
            })
        })
    }
    
    class func syncHighScores(fbToken: String, easyHighScores: [Int], hardHighScores: [Int], completionHandler: @escaping (URLResponse, [Int]?, [Int]?) -> Void) {
        
        let json : [String: [Int]] = ["easy_highscores" : easyHighScores, "hard_highscores" : hardHighScores]
        
        // Perform request.
        API.performRequest(requestType: "PATCH", urlPath: "users/fb_token/\(fbToken)/sync_highscores", json: json, token: nil, completionHandler: {
            (response, data) in
            
            handleResponse(response: response, data: data, completionHandler: {
                response, json in
                
                if response != URLResponse.Success {
                    return completionHandler(response, nil, nil)
                }
                
                let syncedEasyHighScores = json!["easy_highscores"] as! [Int]
                let syncedHardHighScores = json!["hard_highscores"] as! [Int]
                
                completionHandler(URLResponse.Success, syncedEasyHighScores, syncedHardHighScores)
            })
        })
    }
    
    class func getFriendsHighScores(userFBToken: String, fbTokens: [String], completionHandler: @escaping (URLResponse, [[String:Any]]?) -> Void) {
        let json = ["fb_tokens": fbTokens]
        
        API.performRequest(requestType: "POST", urlPath: "users/fb_token/\(userFBToken)/get_friends_highscores", json: json, token: nil) {
            (response, data) in
            handleResponse(response: response, data: data, completionHandler: {
                response, json in
                
                if response != URLResponse.Success {
                    return completionHandler(response, nil)
                }
                
                let friendList = json!["friends"] as! [[String: Any]]
                return completionHandler(URLResponse.Success, friendList)
            })
        }
    }
    
    class func clearHighScores(fbToken: String, mode: String,completionHandler: @escaping (URLResponse) -> Void) {
        API.performRequest(requestType: "DELETE", urlPath: "users/fb_token/\(fbToken)/clear_highscores/\(mode)", json: nil, token: nil) {
            (response, data) in
            handleResponse(response: response, data: data, completionHandler: {
                response, _ in
                
                if response != URLResponse.Success {
                    return completionHandler(response)
                }
                
                return completionHandler(URLResponse.Success)
            })
        }
    }

    
    // HELPERS
    
    private class func handleResponse(response: HTTPURLResponse?, data: Any?, completionHandler: (URLResponse, [String : Any]?) -> Void) {
        if response == nil {
            return completionHandler(URLResponse.Error, nil)
        }
        
        switch response!.statusCode {
        case 500:
            return completionHandler(URLResponse.ServerError, nil)
        case 400:
            return completionHandler(URLResponse.Error, nil)
        default:
            break
        }
        
        if let json = data as? [String : Any] {
            if json["error"] != nil {
                return completionHandler(URLResponse.Error, nil)
            }
            
            return completionHandler(URLResponse.Success, json)
        }
        
        completionHandler(URLResponse.Error, nil)
    }
    
    private class func performRequest(requestType: String, urlPath: String, json: [String: Any]?, token: String?, completionHandler: @escaping (HTTPURLResponse?, Any?) -> Void) {
        
        // Make url request.
        var request = URLRequest(url: URL(string: API.rootURLString + urlPath)!)
        request.httpMethod = requestType
        if requestType == "POST" {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        // If json is not nil add it to the request.
        if json != nil {
            let jsonData = try? JSONSerialization.data(withJSONObject: json!)
            request.httpBody = jsonData
        }
        
        // If token is not nil, add it to the request.
        if token != nil {
            request.setValue(token!, forHTTPHeaderField: "Session-Token")
        }
        
        // Perform request.
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) {
            
            (data, response, error) in
            
            DispatchQueue.main.async {
                
                // Handle errors.
                if (error != nil) {
                    return completionHandler(nil, nil)
                }
                
                if let http_response = response as? HTTPURLResponse {
                    
                    var json_response : Any?
                    
                    do {
                        json_response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    } catch {
                        json_response = nil
                    }
                    
                    return completionHandler(http_response, json_response)
                }
                
            }
        }
        task.resume()
    }

}

enum URLResponse {
    case Success
    case ServerDown
    case ServerError
    case Error
    case NotConnected
}
