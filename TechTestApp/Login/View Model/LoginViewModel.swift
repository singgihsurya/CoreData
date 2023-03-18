//  
//  LoginViewModel.swift
//  TechTestApp
//
//  Created by Singgih Surya Dharma on 18/03/23.
//

import Foundation
import UIKit
import CoreData

class LoginViewModel {
    /// Count your data in model
    var count: Int = 0

    //MARK: -- Network checking

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

    //MARK: -- Closure Collection
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var internetConnectionStatus: (() -> ())?
    var serverErrorStatus: (() -> ())?
    var didGetErrorStore: ((String) -> ())?
    var didFetchSuccess: (() -> ())?

}

extension LoginViewModel {
    
    func fetchLogin(paramUname: String, paramPwd: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let manageObjContext = appDelegate.persistentContainer.viewContext
        
        let profileFetch = NSFetchRequest<NSManagedObject>(entityName: "Profile")
        
        do {
            let profileData = try manageObjContext.fetch(profileFetch)
            for data in profileData {
                if (paramPwd == data.value(forKey: "password") as! String) && (paramUname == data.value(forKey: "username") as! String)
                {
                    didFetchSuccess?()
                } else {
                    didGetErrorStore?("Unauthorized")
                }
            }
        } catch _ as NSError {
            didGetErrorStore?("Error when fetch data")
        }
    }

    
}
