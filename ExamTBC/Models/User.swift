//
//  User.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 01.08.22.
//

import Foundation

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
