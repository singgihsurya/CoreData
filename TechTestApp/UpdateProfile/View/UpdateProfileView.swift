//  
//  UpdateProfileView.swift
//  TechTestApp
//
//  Created by Singgih Surya Dharma on 18/03/23.
//

import UIKit

class UpdateProfileView: UIViewController {
    // OUTLETS HERE
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameField: UITextField!
    // VARIABLES HERE
    var viewModel = UpdateProfileViewModel()
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModel()
        viewModel.fetchLogin()
        setupView()
    }
    
    private func setupView() {
        datePicker.addTarget(self, action: #selector(handling(sender:)), for: .valueChanged)
        
    }
    
    @objc func handling(sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = DateFormatter.Style.short
        timeFormatter.dateStyle = DateFormatter.Style.short
        
        let strTime = timeFormatter.string(from: datePicker.date)
        viewModel.dateFromPicker = strTime
    }
    
    fileprivate func setupViewModel() {
        
        self.viewModel.showAlertClosure = {
            let alert = self.viewModel.alertMessage ?? ""
            print(alert)
        }
        
        self.viewModel.updateLoadingStatus = {
            if self.viewModel.isLoading {
                print("LOADING...")
            } else {
                print("DATA READY")
            }
        }
        
        self.viewModel.internetConnectionStatus = {
            print("Internet disconnected")
            // show UI Internet is disconnected
        }
        
        self.viewModel.serverErrorStatus = {
            print("Server Error / Unknown Error")
            // show UI Server is Error
        }
        
        self.viewModel.didGetData = {
            // update UI after get data
        }
        
        self.viewModel.didGetName = { [weak self] name in
            self?.nameField.text = name
        }
        
        self.viewModel.didGetBirthDate = { [weak self] birthdate in
            if birthdate == "" {
                // DO NOTHING
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yy, h:mm a"
                let date = dateFormatter.date(from: birthdate)
                self?.datePicker.date = date ?? Date()
            }
        }
        
        self.viewModel.didGetAvatar = { [weak self] avatar in
            if avatar == "" {
                // DO NOTHING
            } else {
                // LOAD IMAGE
                let img: UIImage? = self?.fetchAvatar(avatar: avatar)
                self?.imgView.image = img
            }
        }
        
        self.viewModel.didGetErrorFetch = { [weak self] error in
            self?.showToast(message: error, font: .systemFont(ofSize: 14.0))
        }
        
        self.viewModel.didUpdateSuccess = { [weak self] message in
            
            self?.showToast(message: message, font: .systemFont(ofSize: 14.0))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        self.viewModel.didGetUname = { [weak self] uname in
            self?.viewModel.username = uname
        }
    }
    
    private func fetchAvatar(avatar: String) -> UIImage? {
        
        let imagePath = documentsPath.appendingPathComponent(avatar).path
        guard fileManager.fileExists(atPath: imagePath) else {
            print("Image does not exist at path: \(imagePath)")
            return nil
        }
        if let imageData = UIImage(contentsOfFile: imagePath) {
            return imageData
        } else {
            print("UIImage could not be created.")
            return nil
        }
    }
    
    @IBAction func uploadTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        // TODO: save to coredata
        let img = saveImage(image: imgView.image ?? UIImage())
        viewModel.updateRecord(fullname: nameField.text ?? "", birthdate: viewModel.dateFromPicker ?? "", img: img ?? "", uname: viewModel.username ?? "")
    }
    
    func saveImage(image: UIImage) -> String? {
        let date = String( Date.timeIntervalSinceReferenceDate )
        let imageName = date.replacingOccurrences(of: ".", with: "-") + ".png"
        
        if let imageData = image.pngData() {
            do {
                let filePath = documentsPath.appendingPathComponent(imageName)
                try imageData.write(to: filePath)
                
                return imageName
            } catch let error as NSError {
                showToast(message: "\(error)", font: .systemFont(ofSize: 14.0))
                return nil
            }
            
        } else {
            showToast(message: "fail convert", font: .systemFont(ofSize: 14.0))
            return nil
        }
    }
}

extension UpdateProfileView:  UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let userPickedImage = info[.editedImage] as? UIImage else { return }
        
        imgView.image = userPickedImage
        picker.dismiss(animated: true)
        
    }
    
}

