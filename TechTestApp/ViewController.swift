//
//  ViewController.swift
//  TechTestApp
//
//  Created by Singgih Surya Dharma on 18/03/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.setTitle("Start", for: .normal)
    }

    @IBAction func buttonTapped(_ sender: Any) {
        let vc = LoginView()
        let root = UINavigationController(rootViewController: vc)
        root.modalPresentationStyle = .fullScreen
        if checkData() {
            self.present(root, animated: true, completion: nil)
        } else {
            storeInitialData()
        }
    }
    
    private func storeInitialData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let manageObjContext = appDelegate.persistentContainer.viewContext
        let profileEntity = NSEntityDescription.entity(forEntityName: "Profile", in: manageObjContext)!
        let profile = NSManagedObject(entity: profileEntity, insertInto: manageObjContext)
        
        profile.setValue("123123", forKey: "password")
        profile.setValue("SSD123", forKey: "username")
        profile.setValue("Singgih Surya Dharma", forKey: "fullname")
        profile.setValue("3/30/23, 12:04 AM", forKey: "birthdate")
        
        do {
            try manageObjContext.save()
            showToast(message: "Success populate data", font: .systemFont(ofSize: 14.0))
        } catch _ as NSError{
            showToast(message: "error when populate data", font: .systemFont(ofSize: 14.0))
        }
    }
    
    private func getDate() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: date)
        return dateString
    }
    
    private func checkData() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return false}
        let manageObjContext = appDelegate.persistentContainer.viewContext
        let profileFetch = NSFetchRequest<NSManagedObject>(entityName: "Profile")
        
        do {
            let profileData = try manageObjContext.fetch(profileFetch)
            if (!profileData.isEmpty) {
                print("Data Available")
                return true
            }
        } catch _ as NSError {
            showToast(message: "error when fetch data", font: .systemFont(ofSize: 14.0))
        }
        return false
    }
    
}

