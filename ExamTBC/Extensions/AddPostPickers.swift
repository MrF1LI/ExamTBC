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
        
        self.imageData.append(imageData)
        arrayOfImages.append(image)
        collectionViewImages.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //
    
    func uploadPostImages(arrayOfImageData: [Data], reference: DatabaseReference) {
        
        for (imageIndex, imageData) in arrayOfImageData.enumerated() {
            
            let imageKey = FirebaseService.dbPosts.child(reference.key!).child("images").childByAutoId()
            let storageRef = "images/post_images/\(reference.key!)/\(imageKey.key!).png"
            
            FirebaseService.storage.child(storageRef).putData(imageData, metadata: nil) { _, error in
                
                guard error == nil else {
                    print("Failed to upload.")
                    return
                }
                
                FirebaseService.storage.child(storageRef).downloadURL { url, error in
                    guard let url = url, error == nil else {
                        return
                    }
                    
                    let urlString = url.absoluteString
                    
                    FirebaseService.dbPosts.child(reference.key!).child("images").updateChildValues(["\(imageKey.key!)": urlString]) { _, _ in
                        if imageIndex + 1 == arrayOfImageData.count {
                            NotificationCenter.default.post(name: Notification.Name("postPublished"), object: nil)
                            self.dismiss(animated: true)
                        }
                    }

                
                }
            }
            
        }
        
        
    }
    
    func uploadPostImage(imageData: Data, reference: DatabaseReference) {
        
        let imageKey = FirebaseService.dbPosts.child(reference.key!).child("images").childByAutoId()
        let storageRef = "images/post_images/\(reference.key!)/\(imageKey.key!).png"
        
        FirebaseService.storage.child(storageRef).putData(imageData, metadata: nil) { _, error in
            
            guard error == nil else {
                print("Failed to upload.")
                return
            }
            
            FirebaseService.storage.child(storageRef).downloadURL { url, error in
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                
                FirebaseService.dbPosts.child(reference.key!).child("images").updateChildValues(["\(imageKey.key!)": urlString]) { _, _ in
                    self.dismiss(animated: true)
                    print(#function)
                }

            
            }
        }
        
    }
    //
    
}

extension AddPostViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell
        guard let cell = cell else { return UICollectionViewCell() }
        
        let currentImage = arrayOfImages[indexPath.row]
        cell.configure(with: currentImage)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 120, height: 90)
    }
    
}
