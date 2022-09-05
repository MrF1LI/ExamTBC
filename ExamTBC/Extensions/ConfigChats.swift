//
//  ConfigChats.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 14.08.22.
//

import Foundation
import UIKit

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatCell
        guard let cell = cell else { return UITableViewCell() }
        
        let currentChat = arrayOfChats[indexPath.row]
        cell.configure(with: currentChat)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentChat = arrayOfChats[indexPath.row]
        open(chat: currentChat)
    }
    
}

