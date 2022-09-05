//
//  ConfigMessages.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 14.08.22.
//

import Foundation
import UIKit

extension CurrentChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentMessage = arrayOfMessages.reversed()[indexPath.row]
        
        if currentMessage.sender == currentUser.uid {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SentMessageCell", for: indexPath) as? SentMessageCell
            guard let cell = cell else { return UITableViewCell() }
            cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            
            cell.configure(with: currentMessage)
            configure(cell: cell)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceivedMessageCell", for: indexPath) as? ReceivedMessageCell
            guard let cell = cell else { return UITableViewCell() }
            cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))

            cell.configure(with: currentMessage)
            configure(cell: cell)
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func configure(cell: UITableViewCell) {
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        cell.selectionStyle = .none
    }
    
}
