//
//  Comment.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 04.08.22.
//

import Foundation
import FirebaseDatabase

struct Comment {
    let id: String
    let author: String
    let content: String
}

extension Comment {
    init(with snapshot: DataSnapshot) {
        let value = snapshot.value as! NSDictionary
        self.id = value["id"] as! String
        self.author = value["author"] as! String
        self.content = value["content"] as! String
    }
}
