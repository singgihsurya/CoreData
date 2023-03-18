//  
//  LoginView.swift
//  TechTestApp
//
//  Created by Singgih Surya Dharma on 18/03/23.
//

import UIKit

class LoginView: UIViewController {

    // OUTLETS HERE
    @IBOutlet weak var unameField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    // VARIABLES HERE
    var viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        unameField.text = ""
        pwdField.text = ""
        
        unameField.becomeFirstResponder()
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
        
        self.viewModel.didGetErrorStore = { [weak self] result in
            self?.showToast(message: result, font: .systemFont(ofSize: 14.0))
        }
        
        self.viewModel.didFetchSuccess = { [weak self] in
            self?.navigationController?.pushViewController(UpdateProfileView(), animated: true)
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        viewModel.fetchLogin(paramUname: unameField.text ?? "", paramPwd: pwdField.text ?? "")
    }
}


