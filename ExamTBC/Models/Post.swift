//
//  Post.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 02.08.22.
//

import Foundation
import FirebaseDatabase

protocol Post {
    var id: String { get }
    var author: String { get }
    var date: Date { get }
}

struct TextPost: Post {
    var id: String
    var author: String
    var content: String
    var date: Date
}

extension TextPost {
    
    init(with snapshot: DataSnapshot) {
        let value = snapshot.value as! NSDictionary
        self.id = value["id"] as! String
        self.author = value["author"] as! String
        self.content = value["content"] as! String
        
        let dateAsString = value["date"] as? String ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium

        let dateObj = dateFormatter.date(from: dateAsString) ?? Date.now
        
        self.date = dateObj
    }
    
}

struct ImagePost: Post {
    var id: String
    var author: String
    var text: String?
    var images: [String]
    var date: Date
}
