//
//  AddPostViewController.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 05.08.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AddPostViewController: UIViewController {

    // MARK: Variables
    
    @IBOutlet weak var textViewPost: UITextView!
    @IBOutlet weak var imageViewAddImage: UIImageView!
    
    let currentUser = Auth.auth().currentUser!
    static let db = Database.database().reference()
    let dbUsers = db.child("users")
    let dbPosts = db.child("posts")
    let dbMemes = db.child("memes")
    
    var storage = Storage.storage().reference()
    
    var imageData: Data?
    
    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureNavigationItem()
        configureGestures()
    }
    
    func configureNavigationItem() {
        title = "Create Post"
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        
        let buttonPost = UIBarButtonItem(title: "POST", style: .done, target: self, action: #selector(actionPost))
        buttonPost.tintColor = .systemPink
        navigationItem.rightBarButtonItem = buttonPost
        
        let buttonCancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(actionCancel))
        navigationItem.leftBarButtonItem = buttonCancel
    }
    
    func configureGestures() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(actionAddImage))
        imageViewAddImage.addGestureRecognizer(gesture)
    }
    
    // MARK: Actions
    
    @objc func actionCancel() {
        dismiss(animated: true)
    }
    
    @objc func actionAddImage(_ sender: UIButton) {
        showImagePicker()
    }
    
    @objc func actionPost() {
        guard let content = textViewPost.text, !content.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        let postRef = dbPosts.childByAutoId()
        
        let date = String(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium))
        
        let data = [
            "id": postRef.key,
            "author": currentUser.uid,
            "content": content,
            "type": imageData == nil ? "text" : "image",
            "date": date
        ]
        
        postRef.setValue(data) { error, databaseReference in
            
            if let imageData = self.imageData {
                self.uploadPostImage(imageData: imageData, reference: postRef)
            }
            
            NotificationCenter.default.post(name: Notification.Name("postPublished"), object: nil)
            self.dismiss(animated: true)
        }
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
