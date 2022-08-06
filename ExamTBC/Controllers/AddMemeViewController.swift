//
//  AddMemeViewController.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 05.08.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AddMemeViewController: UIViewController {
    
    // MARK: Variables
    
    @IBOutlet weak var stackViewUploadMeme: UIStackView!
    @IBOutlet weak var imageViewMeme: UIImageView!
    
    var currentUser = Auth.auth().currentUser!
    var dbMemes = Database.database().reference().child("memes")
    
    var storage = Storage.storage().reference()
    
    var memeImageData: Data?
        
    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureNavigationItem()
        configureGestures()
    }
    
    func configureNavigationItem() {
        title = "Add Meme"
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        
        let buttonAdd = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(actionAdd))
        buttonAdd.tintColor = .systemPink
        navigationItem.rightBarButtonItem = buttonAdd
        
        let buttonCancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(actionCancel))
        navigationItem.leftBarButtonItem = buttonCancel
    }
    
    func configureGestures() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(actionShowImagePicker))
        stackViewUploadMeme.addGestureRecognizer(gesture)
    }
    
    // MARK: Actions
    
    @objc func actionCancel() {
        dismiss(animated: true)
    }
    
    @objc func actionAdd() {
        guard let memeImageData = memeImageData else { return }
        uploadMeme(imageData: memeImageData)
    }
    
    @objc func actionShowImagePicker() {
        showImagePicker()
    }
    
    // MARK: Functions

    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
}

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

