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

extension UIView {
    
    func bindToKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func keyboardWillChange(_ notification: NSNotification){
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let beginningFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        let deltaY = endFrame.origin.y - beginningFrame.origin.y

        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: nil)
    }
    
}

extension DataSnapshot {

    func getValueAsUser() -> User {
        let value = self.value as? NSDictionary
        
        let user = User(id: value?["id"] as? String ?? "",
                        name: value?["name"] as? String ?? "",
                        surname: value?["surname"] as? String ?? "",
                        age: value?["age"] as? Int ?? 0,
                        email: value?["email"] as? String ?? "",
                        course: value?["course"] as? String ?? "",
                        faculty: value?["faculty"] as? String ?? "",
                        minor: value?["faculty"] as? String ?? "",
                        profilePicture: value?["profile"] as? String ?? "")
        
        return user
    }

}
