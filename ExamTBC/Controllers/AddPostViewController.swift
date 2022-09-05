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
    @IBOutlet weak var collectionViewImages: UICollectionView!
        
    var imageData: [Data?] = []
    var arrayOfImages = [UIImage]()
    
    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureNavigationItem()
        configureGestures()
        configureCollectionView()
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
    
    func configureCollectionView() {
        collectionViewImages.delegate = self
        collectionViewImages.dataSource = self
        collectionViewImages.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
    }
    
    // MARK: Actions
    
    @objc func actionCancel() {
        dismiss(animated: true)
    }
    
    @objc func actionAddImage(_ sender: UIButton) {
        showImagePicker()
    }
    
    @objc func actionPost() {
        
        showSpinner()
        
        guard let content = textViewPost.text, !content.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        let postRef = FirebaseService.dbPosts.childByAutoId()
        
        let date = String(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium))
        
        let data = [
            "id": postRef.key,
            "author": FirebaseService.currentUser!.uid,
            "content": content,
            "type": imageData.count < 1 ? "text" : "image",
            "date": date
        ]
        
        postRef.setValue(data) { error, databaseReference in
    
            var arrayOfImageData = [Data]()
            
            for each in self.imageData {
                if let currentImageData = each {
                    arrayOfImageData.append(currentImageData)
                }
            }
            
            if arrayOfImageData.count > 0 {
                self.uploadPostImages(arrayOfImageData: arrayOfImageData, reference: postRef)
            } else {
                NotificationCenter.default.post(name: Notification.Name("postPublished"), object: nil)
                self.dismiss(animated: true)
            }
            
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

