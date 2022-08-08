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
