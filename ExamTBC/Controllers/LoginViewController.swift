//
//  LoginViewController.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 01.08.22.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    private let signInConfig = GIDConfiguration(clientID: "691614875256-3gj649l5boqu7chng7macirq25jcg5en.apps.googleusercontent.com")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Actions
    
    @IBAction func signIn(_ sender: Any) {
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            
            // If sign in succeeded, display the app's main content
            
            let auth = user.authentication
            guard let idToken = auth.idToken else { return }
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: auth.accessToken)
            
            Auth.auth().signIn(with: credentials) { authResult, error in
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                // If user is registered
                
                let referenceOfCurrentUser = FirebaseService.dbUsers.child(FirebaseService.currentUser!.uid)
                
                referenceOfCurrentUser.observeSingleEvent(of: .value) { snapshot in
                    print(snapshot.exists())
                    if snapshot.exists() {
                        self.goToMainPage()
                    } else {
                        self.goToRegistrationPage()
                    }
                }

                
            }
            
        }
        
    }
    
    // MARK: Navigation Functions
    
    func goToMainPage() {
        let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "MainNavigationController")
        guard let navigationController = navigationController else { return }
        
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    func goToRegistrationPage() {
        let registrationViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController")
        guard let registrationViewController = registrationViewController else { return }
        
        registrationViewController.modalPresentationStyle = .fullScreen
        present(registrationViewController, animated: true)
    }
    
}
