//
//  Meme.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 02.08.22.
//

import Foundation
import FirebaseDatabase

struct Meme {
    let author: String
    let imageUrl: String
}

extension Meme {
    init(with snapshot: DataSnapshot) {
        let value = snapshot.value as! NSDictionary
        self.author = value["author"] as! String
        self.imageUrl = value["url"] as! String
    }
}
