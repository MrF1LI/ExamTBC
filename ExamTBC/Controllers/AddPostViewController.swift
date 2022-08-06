//
//  AddPostViewController.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 05.08.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AddPostViewController: UIViewController {

    // MARK: Variables
    
    @IBOutlet weak var textViewPost: UITextView!
    
    var currentUser = Auth.auth().currentUser!
    static var db = Database.database().reference()
    var dbUsers = db.child("users")
    var dbPosts = db.child("posts")
    
    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureNavigationItem()
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
    
    // MARK: Actions
    
    @objc func actionCancel() {
        dismiss(animated: true)
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
            "type": "text",
            "date": date
        ]
        
        postRef.setValue(data) { error, databaseReference in
            NotificationCenter.default.post(name: Notification.Name("postPublished"), object: nil)
            self.dismiss(animated: true)
        }
    }

}
