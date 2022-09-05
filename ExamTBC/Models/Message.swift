//
//  Message.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 10.08.22.
//

import Foundation
import FirebaseDatabase

struct Message {
    var id: String
    var sender: String
    var content: String
    var date: String
}

extension Message {
    init(with snapshot: DataSnapshot) {
        let value = snapshot.value as! NSDictionary
        self.id = value["id"] as! String
        self.sender = value["sender"] as! String
        self.content = value["content"] as! String
        self.date = value["date"] as! String
    }
}

