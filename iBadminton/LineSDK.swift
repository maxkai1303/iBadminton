//
//  LineSDK.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/24.
//

import Foundation
import UIKit
import LineSDK

class LineSDKClass: ViewController {
    
    func createButton() {
    // Create Login Button.
        let loginButton = LoginButton()
        loginButton.delegate = self
        
        // Configuration for permissions and presenting.
        loginButton.permissions = [.profile]
        loginButton.presentingViewController = self
        
        // Add button to view and layout it.
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func getProfile() {
        LoginManager.shared.login(permissions: [.profile], in: self) {
            result in
            switch result {
            case .success(let loginResult):
                if let profile = loginResult.userProfile {
                    print("User ID: \(profile.userID)")
                    print("User Display Name: \(profile.displayName)")
                    print("User Icon: \(String(describing: profile.pictureURL))")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func retrieve() {
        LoginManager.shared.login(permissions: [.profile], in: self) {
            result in
            switch result {
            case .success(let loginResult):
                let token = loginResult.accessToken.value
            // Send `token` to your server.
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController: LoginButtonDelegate {
    func loginButton(_ button: LoginButton, didSucceedLogin loginResult: LoginResult) {
        //        hideIndicator()
        print("Login Succeeded.")
    }
    
    func loginButton(_ button: LoginButton, didFailLogin error: LineSDKError) {
        //        hideIndicator()
        print("Error: \(error)")
    }
    
    func loginButtonDidStartLogin(_ button: LoginButton) {
        //        showIndicator()
        print("Login Started.")
    }
}
