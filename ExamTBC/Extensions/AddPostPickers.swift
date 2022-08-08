//
//  AddPostPickers.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 07.08.22.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage

extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
    
        guard let imageData = image.pngData() else {
            return
        }
        
        self.imageData = imageData
        imageViewAddImage.image = image
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadPostImage(imageData: Data, reference: DatabaseReference) {
        
        let storageRef = "images/post_images/\(String(describing: reference.key)).png"
        
        storage.child(storageRef).putData(imageData, metadata: nil) { _, error in
            
            guard error == nil else {
                print("Failed to upload.")
                return
            }
            
            self.storage.child(storageRef).downloadURL { url, error in
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                
                self.dbPosts.child(reference.key!).updateChildValues(["image": urlString]) { _, _ in
                    self.dismiss(animated: true)
                }

            
            }
        }
        
    }
    
}
