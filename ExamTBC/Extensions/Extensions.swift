//
//  Extensions.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 01.08.22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

extension Date {
    func getAge() -> Int {
        return Int(Calendar.current.dateComponents([.year], from: self, to: Date()).year!)
    }
}

extension UIViewController {
    
    func showSpinner() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = UIScreen.main.bounds
        view.addSubview(blurredEffectView)
        
        let activityView = UIActivityIndicatorView()
        activityView.style = .large
        activityView.color = .systemPink
        activityView.hidesWhenStopped = true
        view.addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityView.startAnimating()
    }
    
}
