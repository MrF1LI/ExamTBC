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
    
    var arrayOfComments = [Comment]()
    
    var dbPosts = Database.database().reference().child("posts")
    var postId: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureAddCommentDesign()
        configTableViewComments()
        loadComments()
    }
    
    func loadComments() {
        dbPosts.child(postId).child("comments").observe(.value) { [self] snapshot in

            self.arrayOfComments.removeAll()

            for child in snapshot.children.allObjects as! [DataSnapshot] {

                let data = child.value as? [String:AnyObject] ?? [:]
                
                let currentComment = Comment(id: data["id"] as? String ?? "",
                                             author: data["author"] as? String ?? "",
                                             content: data["content"] as? String ?? "")

                self.arrayOfComments.append(currentComment)

            }

            self.tableViewComments.reloadData()

        }
    }
    
    func configureAddCommentDesign() {
        viewAddCommentBackground.layer.shadowOffset = CGSize(width: 0, height: -10)
        viewAddCommentBackground.layer.shadowRadius = 10
        viewAddCommentBackground.layer.shadowOpacity = 0.1
        viewAddCommentBackground.bindToKeyboard()
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

}
