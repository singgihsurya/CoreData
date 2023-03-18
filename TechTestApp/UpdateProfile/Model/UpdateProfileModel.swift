//  
//  UpdateProfileModel.swift
//  TechTestApp
//
//  Created by Singgih Surya Dharma on 18/03/23.
//

import Foundation
import UIKit

struct UpdateProfileModel: Codable {
    var fullname: String = ""
    var birthdate: String = ""
    var avatar: String = ""
    
    init?(dict: [String: Any]?) {
        fullname = dict?["fullname"] as? String ?? ""
        birthdate = dict?["birthdate"] as? String ?? ""
        avatar = dict?["avatar"] as? String ?? ""
    }
    
    func dictionary() -> [String: Any]? {
        var params: [String: Any] = [:]
        params["fullname"] = fullname
        params["birthdate"] = birthdate
        params["avatar"] = avatar
        
        return params
    }
}

