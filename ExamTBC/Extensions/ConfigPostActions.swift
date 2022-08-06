//
//  ConfigPostActions.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 02.08.22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

extension HomeViewController: PostCellDelegate {
    
    func react(cell: UITableViewCell) {
        
        if let indexPath = tableViewPosts.indexPath(for: cell) {

            let post = arrayOfPosts[indexPath.row]
            let reactRef = dbPosts.child(post.id).child("reacts")
            
            reactRef.child(currentUser.uid).observeSingleEvent(of: .value) { snapshot in
                if snapshot.exists() {
//                    reactRef.updateChildValues([self.currentUser.uid: nil])
                    snapshot.ref.removeValue()
                } else {
                    let date = String(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none))
                    reactRef.updateChildValues([self.currentUser.uid: date])
                }
                self.tableViewPosts.reloadRows(at: [indexPath], with: .none)
            }
            
        }
        
    }
    
    func comment(cell: UITableViewCell) {
        if let indexPath = tableViewPosts.indexPath(for: cell) {
            let post = arrayOfPosts[indexPath.row]
            showComments(postId: post.id)
        }
    }
    
    func share(cell: UITableViewCell) {
        print(#function)
    }
    
    func save(cell: UITableViewCell) {
        print(#function)
    }
    
    func goToAuthorProfile(cell: UITableViewCell) {
        if let indexPath = tableViewPosts.indexPath(for: cell) {
            let post = arrayOfPosts[indexPath.row]
            goToUserProfile(authorID: post.author)
        }
    }
    
    // MARK: Navigation Functions
    
    func showComments(postId: String) {
        let commentsVC = self.storyboard?.instantiateViewController(withIdentifier: "CommentsViewController") as?
        CommentsViewController
        guard let commentsVC = commentsVC else { return }

        commentsVC.postId = postId
        present(commentsVC, animated: true)
    }
    
    func goToUserProfile(authorID: String) {
        let userProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController
        guard let userProfileVC = userProfileVC else { return }
        
        userProfileVC.currentUserId = authorID
        
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
}
