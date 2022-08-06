//
//  ConfigPosts.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 02.08.22.
//

import Foundation
import UIKit

protocol PostCellDelegate {
    func react(cell: UITableViewCell)
    func comment(cell: UITableViewCell)
    func share(cell: UITableViewCell)
    func save(cell: UITableViewCell)
    func goToAuthorProfile(cell: UITableViewCell)
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentPost = arrayOfPosts[indexPath.row]
        
        if currentPost is TextPost {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextPostCell", for: indexPath) as? TextPostCell
            guard let cell = cell else { return UITableViewCell() }
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            cell.selectionStyle = .none
            cell.delegate = self
            
            cell.configure(with: currentPost as! TextPost)
            return cell
            
        } else if currentPost is ImagePost {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImagePostCell", for: indexPath) as? ImagePostCell
            guard let cell = cell else { return UITableViewCell() }
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            cell.selectionStyle = .none
            cell.delegate = self
            
            cell.configure(with: currentPost as! ImagePost)
            return cell
            
        } else if currentPost is Poll {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PollCell", for: indexPath) as? PollCell
            guard let cell = cell else { return UITableViewCell() }
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            cell.selectionStyle = .none
            cell.delegate = self
            
            cell.configure(with: currentPost as! Poll)
            return cell
            
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

