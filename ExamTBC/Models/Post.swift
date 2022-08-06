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

struct ImagePost: Post {
    var id: String
    var author: String
    var text: String?
    var imageUrl: String
    var date: Date
}

struct Poll: Post {
    
    struct Option {
        let id: String
        let content: String
    }
    
    var id: String
    var author: String
    var question: String
    var options: [Option]
    var date: Date
    
}
