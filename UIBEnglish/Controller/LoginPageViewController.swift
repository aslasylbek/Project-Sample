//
//  LoginPageViewController.swift
//  UIBEnglish
//
//  Created by Aslan on 26.09.2018.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit
import Reachability

class LoginPageViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var mBarcodeTextField: UITextField!
    @IBOutlet weak var mPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mBarcodeTextField.delegate = self
        mPasswordTextField.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if mBarcodeTextField.isFirstResponder{
            mPasswordTextField.becomeFirstResponder()
        }
        else {
            mPasswordTextField.resignFirstResponder()
        }
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func onSignInTouchUp(_ sender: UIButton) {
        //declare this property where it won't go out of scope relative to your listener

       
        
        let mBarcode = mBarcodeTextField.text!
        let mPassword = mPasswordTextField.text!
        
        //MARK: Check for empty fields
        
        if mBarcode.isEmpty || mPassword.isEmpty {
            displayAlertMessage(userMessage: "Its empty cabrone")
            return
        }
        
        //MARK: Check for internetConnection
        
        //MARK: Make Authentication
        
        guard let url = NSURL(string: "http://moodle.uib.kz/mobile/login.php") else{
            return
        }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = "username=\(mBarcode)&password=\(mPassword)".data(using: String.Encoding.utf8)

        let task = URLSession.shared.loginResponseTask(with: request as URLRequest) { loginResponse, response, error in
            if let resp = loginResponse {
                if (resp.success! == 0){
                    DispatchQueue.main.async {
                        self.displayAlertMessage(userMessage: "Password or barcode is incorrect")
                        self.mBarcodeTextField.text = ""
                        self.mPasswordTextField.text = ""
                    }
                }
                else{
                    let defaults = UserDefaults.standard
                    defaults.set(resp.userID, forKey: "user_id")
                    defaults.set(true, forKey: "loggedIn")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "loggedIn", sender: self)
                    }
                }
                
            }
        }
        task.resume()
        
        
        
    }
    
    func displayAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
        myAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(myAlert, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
