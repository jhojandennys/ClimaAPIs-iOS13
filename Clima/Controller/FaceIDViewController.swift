//
//  FaceIDViewController.swift
//  Clima
//
//  Created by Jhojan Sobrino on 5/11/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit

class FaceIDViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(FaceIDViewController.authenticationCompletionHandler(loginStatusNotification:)), name: .MTBiometricAuthenticationNotificationLoginStatus, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func authenticationCompletionHandler(loginStatusNotification: Notification) {
       if let _ = loginStatusNotification.object as? FaceIdAuth, let userInfo = loginStatusNotification.userInfo {
           if let authStatus = userInfo[FaceIdAuth.status] as? FaceIdAuthStatus {
               if authStatus.success {
                   print("Login Success")
                   DispatchQueue.main.async {
                       self.onLoginSuccess()
                   }
               } else {
                   if let errorCode = authStatus.errorCode {
                       print("Login Fail with code \(String(describing: errorCode)) reason \(authStatus.errorMessage)")
                       DispatchQueue.main.async {
                           self.onLoginFail()
                           }
                   
                   }
               }
           }
       }
   }
   
   @IBAction func Biometric(_ sender: Any) {
       authenticateWithBiometric()
   }
   
   public func authenticateWithBiometric() {
       let bioAuth = FaceIdAuth()
       bioAuth.reasonString = "To login into the app"
       bioAuth.authenticationWithBiometricID()
   }
    let WeatherViewController = "WeatherViewController"
   
   func onLoginSuccess() {
       let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
       let homeVC = mainStoryboard.instantiateViewController(withIdentifier: WeatherViewController)
       self.navigationController?.pushViewController(homeVC, animated: true)
   }
   
   func onLoginFail() {
       let alert = UIAlertController(title: "Login", message: "Login Failed", preferredStyle: UIAlertController.Style.alert)
       alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
       self.present(alert, animated: true, completion: nil)
   }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
