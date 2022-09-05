//
//  User.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 01.08.22.
//

import Foundation
import FirebaseDatabase

struct User {
    
    var id: String
    var name: String
    var surname: String
    var age: Int
    var email: String
    
    var course: String?
    var faculty: String?
    var minor: String?
    
    var profilePicture: String?
    var birthDate: String?
    
    var chats: [String]
    
}

extension User {
    
    init(with snapshot: DataSnapshot) {
        let value = snapshot.value as! NSDictionary
        self.id = value["id"] as! String
        self.name = value["name"] as! String
        self.surname = value["surname"] as! String
        self.age = value["age"] as! Int
        self.email = value["email"] as! String
        self.course = value["course"] as? String
        self.faculty = value["faculty"] as? String
        self.minor = value["minor"] as? String
        self.profilePicture = value["profile"] as? String
        self.birthDate = value["date"] as? String
        
        let chats = value["chats"] as? [String:Bool]
        if let chats = chats {
            self.chats = chats.map { key, value in key }
        } else {
            self.chats = []
        }
    }
    
}

struct UserInfo {
    var name: String
    var image: StudentInfoImage
}

enum StudentInfoImage: String {
    case age = "person.fill"
    case faculty = "book.fill"
    case minor = "graduationcap.circle"
    case course = "graduationcap.fill"
}
