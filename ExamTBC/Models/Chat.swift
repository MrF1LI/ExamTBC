//
//  Chat.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 10.08.22.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

struct Chat {
    enum ChatType: String {
        case personal
        case group
    }
    
    var id: String
    var title: String?
    var members: [String]
    var image: String?
    var type: ChatType
    var lastMessage: Message?
}

extension Chat {
    
    init(with snapshot: DataSnapshot) {
        let value = snapshot.value as! NSDictionary
        
        self.id = value["id"] as! String
        
        //
        
        let typeString = value["type"] as! String
        
        if typeString == ChatType.personal.rawValue {
            self.type = .personal
        } else {
            self.type = .group
        }
        
        //
        
        var chatMembers = [String]()
        
        for user in value["members"] as! [String:Bool] {
            chatMembers.append(user.key)
        }
        
        self.members = chatMembers
        
        if self.type == .group {
            self.title = value["title"] as? String
            self.image = value["image"] as? String
        }
        
    }
    
}
