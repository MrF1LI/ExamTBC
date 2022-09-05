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
            
            let referenceOfReacts = FirebaseService.dbPosts.child(post.id).child("reacts")
            let currentUserReacts = referenceOfReacts.child(FirebaseService.currentUser!.uid)
            
            currentUserReacts.observeSingleEvent(of: .value) { snapshot in
                
                if snapshot.exists() {
                
                    if let tCell = cell as? TextPostCell {
                        tCell.imageViewHeart.image = UIImage(systemName: "heart")
                        tCell.imageViewHeart.tintColor = .black
                    } else if let iCell = cell as? ImagePostCell {
                        iCell.imageViewHeart.image = UIImage(systemName: "heart")
                        iCell.imageViewHeart.tintColor = .black
                    }
                    
                    snapshot.ref.removeValue()
                    
                } else {
                    
                    if let iCell = cell as? ImagePostCell {
                        
                        iCell.imageViewHeart.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                        
                        UIView.animate(
                            withDuration: 1.2,
                            delay: 0.0,
                            usingSpringWithDamping: 0.2,
                            initialSpringVelocity: 0.2,
                            options: .curveEaseOut,
                            animations: {
                                iCell.imageViewHeart.transform = CGAffineTransform(scaleX: 1, y: 1)
                                iCell.imageViewHeart.image = UIImage(systemName: "heart.fill")
                                iCell.imageViewHeart.tintColor = .systemPink
                            },
                            completion: nil)
                        
                    } else if let tCell = cell as? TextPostCell {
                        
                        tCell.imageViewHeart.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                        
                        UIView.animate(
                            withDuration: 1.2,
                            delay: 0.0,
                            usingSpringWithDamping: 0.2,
                            initialSpringVelocity: 0.2,
                            options: .curveEaseOut,
                            animations: {
                                tCell.imageViewHeart.transform = CGAffineTransform(scaleX: 1, y: 1)
                                tCell.imageViewHeart.image = UIImage(systemName: "heart.fill")
                                tCell.imageViewHeart.tintColor = .systemPink
                            },
                            completion: nil)
                        
                    }
                    
                    let date = String(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none))
                    referenceOfReacts.updateChildValues([FirebaseService.currentUser!.uid: date])
                    
                }
                
//                self.tableViewPosts.reloadRows(at: [indexPath], with: .none)
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
        let commentsVC = self.storyboard?.instantiateViewController(withIdentifier: "CommentsarViewController") as?
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
