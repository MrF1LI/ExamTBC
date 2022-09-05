//
//  ConfigPickers.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 03.08.22.
//

import Foundation
import UIKit

// MARK: Extension for image picker

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        
        let ref = "images/profile_images/\(FirebaseService.currentUser!.uid)/profile.png"
        
        FirebaseService.storage.child(ref).putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                print("Failed to upload.")
                return
            }
            
            FirebaseService.storage.child(ref).downloadURL { url, error in
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                
                FirebaseService.dbUsers.child(FirebaseService.currentUser!.uid).child("profile").setValue(urlString)
                
            }
        }
        
    }
    
}

// MARK: Extension for course and faculty picker

extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        } else {
            textFieldFaculty.text = arrayOfFaculties[row]
            textFieldFaculty.resignFirstResponder()
        }
    }

}

// MARK: - Extension for configure pickers

extension RegisterViewController {
    
    func createDatePicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let buttonDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(actionDatePicker))
        toolbar.setItems([buttonDone], animated: true)
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels

        textFieldDate.inputAccessoryView = toolbar
        textFieldDate.inputView = datePicker
        
    }
    
    func configureCoursePicker() {
        coursePicker.delegate = self
        coursePicker.dataSource = self
        textFieldCourse.inputView = coursePicker
        coursePicker.tag = 1
    }
    
    func configureFacultyPicker() {
        facultyPicker.delegate = self
        facultyPicker.dataSource = self
        textFieldFaculty.inputView = facultyPicker
        facultyPicker.tag = 2
    }
    
    func configureProfileImageView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(actionImageViewProfile))
        imageViewProfile.addGestureRecognizer(gesture)
        imageViewProfile.contentMode = .scaleAspectFill
    }
    
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
}

//// MARK: - Extension for image picker
//
//extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        
//        picker.dismiss(animated: true, completion: nil)
//        
//        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
//            return
//        }
//    
//        guard let imageData = image.pngData() else {
//            return
//        }
//        
//        profileImageData = imageData
//        imageViewProfile.image = image
//        
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//    
//    func uploadProfilePicture(imageData: Data) {
//        
//        let ref = "images/profile_images/\(FirebaseService.currentUser!.uid)/profile.png"
//        
//        FirebaseService.storage.child(ref).putData(imageData, metadata: nil) { _, error in
//            guard error == nil else {
//                print("Failed to upload.")
//                return
//            }
//            
//            FirebaseService.storage.child(ref).downloadURL { url, error in
//                guard let url = url, error == nil else {
//                    return
//                }
//                
//                let urlString = url.absoluteString
//                
//                FirebaseService.dbUsers.child(FirebaseService.currentUser!.uid).child("profile").setValue(urlString)
//                
//            }
//        }
//        
//    }
//    
//}
