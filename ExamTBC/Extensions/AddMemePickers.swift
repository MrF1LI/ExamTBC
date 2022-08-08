//
//  AddMemePickers.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 07.08.22.
//

import Foundation
import UIKit

extension AddMemeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
    
        guard let imageData = image.pngData() else {
            return
        }
        
        memeImageData = imageData
        imageViewMeme.image = image
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadMeme(imageData: Data) {
        
        let dbRef = dbMemes.childByAutoId()
        let storageRef = "images/memes/\(String(describing: dbRef.key)).png"
        
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
                let meme = Meme(author: self.currentUser.uid, imageUrl: urlString)
                
                let data = [
                    "author": meme.author,
                    "url": meme.imageUrl
                ]
                
                self.dbMemes.child(dbRef.key!).setValue(data) { _, _ in
                    self.dismiss(animated: true)
                }
            
            }
        }
        
    }
    
}
