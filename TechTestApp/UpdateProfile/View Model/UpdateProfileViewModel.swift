//  
//  UpdateProfileViewModel.swift
//  TechTestApp
//
//  Created by Singgih Surya Dharma on 18/03/23.
//

import Foundation
import CoreData
import UIKit

class UpdateProfileViewModel {
    
    private var model: [UpdateProfileModel] = [UpdateProfileModel]() {
        didSet {
            self.count = self.model.count
        }
    }
    
    /// Count your data in model
    var count: Int = 0
    var username: String?
    
    /// Define boolean for internet status, call when network disconnected
    var isDisconnected: Bool = false {
        didSet {
            self.alertMessage = "No network connection. Please connect to the internet"
            self.internetConnectionStatus?()
        }
    }
    
    //MARK: -- UI Status
    
    /// Update the loading status, use HUD or Activity Indicator UI
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    /// Showing alert message, use UIAlertController or other Library
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    /// Define selected model
    var selectedObject: UpdateProfileModel?
    var dateFromPicker: String?
    //MARK: -- Closure Collection
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var internetConnectionStatus: (() -> ())?
    var serverErrorStatus: (() -> ())?
    var didGetData: (() -> ())?
    var didGetErrorFetch: ((String) -> ())?
    var didGetName: ((String) -> ())?
    var didGetBirthDate: ((String) -> ())?
    var didGetAvatar: ((String) -> ())?
    var didUpdateSuccess:((String) -> ())?
    var didGetUname: ((String) -> ())?

    
}

extension UpdateProfileViewModel {
    func fetchLogin() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let manageObjContext = appDelegate.persistentContainer.viewContext
        
        let profileFetch = NSFetchRequest<NSManagedObject>(entityName: "Profile")
        
        do {
            let profileData = try manageObjContext.fetch(profileFetch)
            
            for data in profileData {
                didGetBirthDate?(data.value(forKey: "birthdate") as? String ?? "")
                didGetName?(data.value(forKey: "fullname") as? String ?? "")
                didGetAvatar?(data.value(forKey: "avatar") as? String ?? "")
                didGetUname?(data.value(forKey: "username") as? String ?? "")
            }
        } catch _ as NSError {
            didGetErrorFetch?("Error when fetch data")
        }
    }
    
    func updateRecord(fullname: String, birthdate: String, img: String, uname: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let manageObjContext = appDelegate.persistentContainer.viewContext
        let profileFetch = NSFetchRequest<NSManagedObject>(entityName: "Profile")
        profileFetch.predicate = NSPredicate(format: "username = %@", uname )
        
        do {
            let profileRes = try manageObjContext.fetch(profileFetch)
            if let profile = profileRes.first {
                if fullname != "" {
                    profile.setValue(fullname, forKey: "fullname")
                }
                if birthdate != "" {
                    profile.setValue(birthdate, forKey: "birthdate")
                }
                if img != "" {
                    profile.setValue(img, forKey: "avatar")
                }
                try manageObjContext.save()
                didUpdateSuccess?("Update Success")
            } else {
                didGetErrorFetch?("data not found")
            }
        }catch _ as NSError {
            didGetErrorFetch?("Error when fetch data")
        }
    }
}
