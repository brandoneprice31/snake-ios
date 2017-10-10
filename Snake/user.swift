//
//  user.swift
//  Snake
//
//  Created by Brandon Price on 10/9/17.
//  Copyright © 2017 Brandon Price. All rights reserved.
//

import Foundation

class User {
    var firstName : String
    var lastName : String
    var id : String
    var fbToken : String
    
    init() {
        firstName = ""
        lastName = ""
        id = ""
        fbToken = ""
    }
    
    init(firstName: String, lastName: String, id: String, fbToken: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.fbToken = fbToken
    }
    
    func fullName() -> String {
        return firstName + " " + lastName
    }
    
    func stringID() -> String {
        return String(id)
    }
    
    class func deserialize(json: [String:Any]) -> User {
        var firstName = ""
        var lastName = ""
        var id = ""
        var fbToken = ""
        
        if let jsonFirstName = json["first_name"] as? String {
            firstName = jsonFirstName
        }
        
        if let jsonLastName = json["last_name"] as? String {
            lastName = jsonLastName
        }
        
        if let jsonId = json["_id"] as? String {
            id = jsonId
        }
        
        if let jsonFbToken = json["fb_token"] as? String {
            fbToken = jsonFbToken
        }
        
        return User(firstName: firstName, lastName: lastName, id: id, fbToken: fbToken)
    }
    
    func isEmpty() -> Bool {
        return id == ""
    }
}
