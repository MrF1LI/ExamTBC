//
//  CommentsViewController.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 04.08.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CommentsViewController: UIViewController {
    
    @IBOutlet weak var viewAddCommentBackground: UIView!
    @IBOutlet weak var tableViewComments: UITableView!
    
    @IBOutlet weak var textFieldComment: UITextField!
    @IBOutlet weak var textFieldCommentConstraint: NSLayoutConstraint!
    
    var arrayOfComments = [Comment]()
    
    var dbPosts = Database.database().reference().child("posts")
    var postId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureAddCommentDesign()
        configTableViewComments()
        loadComments()
        listenToKeyboard()
    }
    
    func loadComments() {
        dbPosts.child(postId).child("comments").observe(.value) { [self] snapshot in
            
            self.arrayOfComments.removeAll()
            
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let currentComment = Comment(with: child)
                self.arrayOfComments.append(currentComment)
            }
            
            self.tableViewComments.reloadData()
            
        }
    }
    
    func configureAddCommentDesign() {
        viewAddCommentBackground.layer.shadowOffset = CGSize(width: 0, height: -10)
        viewAddCommentBackground.layer.shadowRadius = 10
        viewAddCommentBackground.layer.shadowOpacity = 0.1
    }
    
    func configTableViewComments() {
        tableViewComments.delegate = self
        tableViewComments.dataSource = self
        tableViewComments.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
    }
    
    // MARK: Actions
    
    @IBAction func actionAddComment(_ sender: UIButton) {
        guard let comment = textFieldComment.text, !comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let commentsRef = dbPosts.child(postId).child("comments")
        let commentRef = commentsRef.childByAutoId()
            
        let date = String(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none))
        
        let data = [
            "id": commentRef.key,
            "author": Auth.auth().currentUser!.uid,
            "date": date,
            "content": comment
        ]
        
        commentRef.setValue(data)
        
        textFieldComment.text = ""
    }
    
    // MARK: Change Keyboard Constraints
    
    func listenToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        let keyboardHeight = keyboardSize?.height
        
        if #available(iOS 11.0, *){
            self.textFieldCommentConstraint.constant = -keyboardHeight! + view.safeAreaInsets.bottom
        }
        else {
            self.textFieldCommentConstraint.constant = view.safeAreaInsets.bottom
        }
        
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    
    @objc func keyboardWillHide(notification: Notification){
        
        self.textFieldCommentConstraint.constant =  0 // or change according to your logic
        
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
        
    }
    
}

