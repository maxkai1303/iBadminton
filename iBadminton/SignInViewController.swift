//
//  SignInViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/5.
//

import UIKit
import AuthenticationServices
import FirebaseAuth
import CryptoKit

@available(iOS 13.0, *)
class SignInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButton()
        
    }
    
    func setButton() {
        
        let authorizationAppleIDButton: ASAuthorizationAppleIDButton = ASAuthorizationAppleIDButton(type: .default, style: .black)
        authorizationAppleIDButton.addTarget(self, action: #selector(pressSignInWithAppleButton), for: UIControl.Event.touchUpInside)
        authorizationAppleIDButton.frame = self.appleLoginView.bounds
        self.appleLoginView.addSubview(authorizationAppleIDButton)
        
    }
    
    @IBOutlet weak var appleLoginView: UIView!
    @IBOutlet weak var privacyButton: UIButton!
    
    private func randomNonceString(length: Int = 32) -> String {
        
        precondition(length > 0)
        
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                
                if errorCode != errSecSuccess {
                    
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                    
                }
                
                return random
                
            }
            
            randoms.forEach { random in
                
                if remainingLength == 0 {
                    
                    return
                    
                }
                
                if random < charset.count {
                    
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                    
                }
            }
        }
        
        return result
    }
    
    fileprivate var currentNonce: String?
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            
            return String(format: "%02x", $0)
            
        }.joined()
        
        return hashString
    }
    
    // 點擊事件
    @objc func pressSignInWithAppleButton() {
        
        startSignInWithAppleFlow()
        
    }
}

@available(iOS 13.0, *)
extension SignInViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let nonce = currentNonce else {
                
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
                
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                
                print("Unable to fetch identity token")
                return
                
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
                
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { (signData, error) in
                
                if error != nil {
                    
                    print(error?.localizedDescription as Any)
                    return
                    
                }
                // 登入成功
                else {
                    
                    guard Auth.auth().currentUser != nil  else { return }
                    
                    guard signData?.user.uid != nil else { return }
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    FireBaseManager.shared.getCollection(name: .user).whereField(
                        
                        "userID", isEqualTo: signData!.user.uid).getDocuments { (querySnapshot, err) in
                            
                            if let err = err {
                                
                                print("Error getting documents: \(err)")
                                
                            } else {
                                
                                FireBaseManager.shared.decode(User.self, documents: querySnapshot!.documents) { (result) in
                                    
                                    switch result {
                                    
                                    case .success:
                                        FireBaseManager.shared.addUser(collectionName: .user, userId: (signData?.user.uid)!)
                                        
                                    case .failure(let error):
                                        print("SignIn decode fail \(error)")
                                    }
                                }
                            }
                        }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        print("Sign in with Apple errored: \(error)")
        
    }
    
}
// 授權成功
@available(iOS 13.0, *)
func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        
        print("user: \(appleIDCredential.user)")
        print("fullName: \(String(describing: appleIDCredential.fullName))")
        print("Email: \(String(describing: appleIDCredential.email))")
        print("realUserStatus: \(String(describing: appleIDCredential.realUserStatus))")
        
    }
}
// 授權失敗
@available(iOS 13.0, *)
func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    
    switch error {
    
    case ASAuthorizationError.canceled:
        break
    case ASAuthorizationError.failed:
        break
    case ASAuthorizationError.invalidResponse:
        break
    case ASAuthorizationError.notHandled:
        break
    case ASAuthorizationError.unknown:
        break
    default:
        break
        
    }
    
    print("didCompleteWithError: \(error.localizedDescription)")
    
}

@available(iOS 13.0, *)
extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    /// - Parameter controller: _
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return self.view.window!
        
    }
    
}
