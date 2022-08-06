//
//  ConfigEditProfilePickers.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 03.08.22.
//

import Foundation
import UIKit

// MARK: Extension for image picker

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
    
        guard let imageData = image.pngData() else {
            return
        }
        
        profileImageData = imageData
        imageViewProfile.image = image

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadProfilePicture(imageData: Data) {
        
        let ref = "images/profile_images/\(currentUser.uid)/profile.png"
        
        storage.child(ref).putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                print("Failed to upload.")
                return
            }
            
            self.storage.child(ref).downloadURL { url, error in
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                
                self.dbUsers.child(self.currentUser.uid).child("profile").setValue(urlString)
                
            }
        }
        
    }
    
}

// MARK: Extension for course and faculty picker

extension EditProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return arrayOfCourses.count
        } else {
            return arrayOfFaculties.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return arrayOfCourses[row]
        } else {
            return arrayOfFaculties[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            textFieldCourse.text = arrayOfCourses[row]
            textFieldCourse.resignFirstResponder()
        } else if pickerView.tag == 2 {
            textFieldFaculty.text = arrayOfFaculties[row]
            textFieldFaculty.resignFirstResponder()
        } else {
            textFieldMinor.text = arrayOfFaculties[row]
            textFieldMinor.resignFirstResponder()
        }
    }

}
