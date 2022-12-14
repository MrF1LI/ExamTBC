//
//  Review.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 01.08.22.
//

import Foundation
import FirebaseDatabase

struct Review {
    var id: String
    var author: String
    var text: String
    var date: String
    
    var lecturer: String?
}

extension Review {
    
    init(with snapshot: DataSnapshot) {
        let value = snapshot.value as! NSDictionary
        self.id = value["id"] as! String
        self.author = value["author"] as! String
        self.text = value["review"] as! String
        self.date = value["date"] as! String
    }
    
}
