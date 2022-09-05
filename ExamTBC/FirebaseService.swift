//
//  FirebaseService.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 15.08.22.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class FirebaseService {
    
    static let shared = FirebaseService()
    
    // MARK: - Variables
    
    static let currentUser = Auth.auth().currentUser
    
    static let db = Database.database().reference()
    static let dbUsers = db.child("users")
    static let dbLecturers = db.child("lecturers")
    static let dbChats = db.child("chats")
    static let dbMemes = db.child("memes")
    static let dbPosts = db.child("posts")
    
    static let storage = Storage.storage().reference()
    
    // MARK: - Meme Functions
    
    func fetchMemes(completion: @escaping ([Meme]) -> (Void)) {
        
        FirebaseService.dbMemes.observe(.value) { snapshot in
            
            var arrayOfMemes = [Meme]()
            
            for dataSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                let currentMeme = Meme(with: dataSnapshot)
                arrayOfMemes.append(currentMeme)
            }
            
            completion(arrayOfMemes)
            
        }
        
    }
    
    // MARK: - Lecturer Functions
    
    func fetchLecturers(completion: @escaping ([Lecturer]) -> (Void)) {
        
        FirebaseService.dbLecturers.observe(.value) { snapshot in
            var arrayOfLecturers = [Lecturer]()
            
            for dataSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                let currentLecturer = Lecturer(with: dataSnapshot)
                arrayOfLecturers.append(currentLecturer)
            }
            
            completion(arrayOfLecturers)
        }
        
    }
    
    func fetchReviews(of lecturer: Lecturer, completion: @escaping ([Review]) -> (Void)) {
        
        let referenceOfReviews = FirebaseService.dbLecturers.child(lecturer.id).child("reviews")
        
        referenceOfReviews.observe(.value) { snapshot in
            var arrayOfReviews = [Review]()
            
            for dataSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                var currentReview = Review(with: dataSnapshot)
                currentReview.lecturer = lecturer.id
                
                arrayOfReviews.append(currentReview)
            }
            
            completion(arrayOfReviews)
            
        }
        
    }
    
    func fetchRating(of lecturer: Lecturer, completion: @escaping ([String:Float], [Float], Float) -> (Void)) {
        
        let referenceOfRates = FirebaseService.dbLecturers.child(lecturer.id).child("rates")
        
        referenceOfRates.observeSingleEvent(of: .value) { snapshot in
            let ratingData = snapshot.value as? [String : Float] ?? [:]
            
            let arrayOfRates = ratingData.map { $1 }
            let rating = Float(arrayOfRates.reduce(0, +)) / Float(arrayOfRates.count)
            
            completion(ratingData, arrayOfRates, rating)
        }
        
    }
    
    func rate(lecturer: Lecturer, by rate: Double, completion: @escaping () -> (Void)) {
        let referenceOfRates = FirebaseService.dbLecturers.child(lecturer.id).child("rates")
        referenceOfRates.child(FirebaseService.currentUser!.uid).setValue(Int(rate))
        
        completion()
    }
    
    func review(lecturer: Lecturer, with review: String, completion: @escaping () -> (Void)) {
        
        guard !review.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let referenceOfReviews = FirebaseService.dbLecturers.child(lecturer.id).child("reviews")
        let referenceOfReview = referenceOfReviews.childByAutoId()
                
        let date = String(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none))
        
        let data = [
            "id": referenceOfReview.key,
            "author": Auth.auth().currentUser!.uid,
            "date": date,
            "review": review
        ]
        
        referenceOfReview.setValue(data)
        
        completion()
        
    }
    
    // MARK: - Profile Functions
    
    func fetchUserInfo(by id: String, completion: @escaping (User, [UserInfo]) -> (Void)) {
        
        let referenceOfCurrentUser = FirebaseService.dbUsers.child(id)
        
        referenceOfCurrentUser.observe(.value) { snapshot in
            let user = User(with: snapshot)
            
            var userInfo = [
                UserInfo(name: "\(user.age)", image: .age),
                UserInfo(name: user.course ?? "", image: .course),
                UserInfo(name: user.faculty ?? "", image: .faculty)
            ]
            
            if !(user.minor ?? "").isEmpty {
                userInfo.append(UserInfo(name: "Minor: \(user.minor ?? "")", image: .minor))
            }
            
            completion(user, userInfo)
            
        }
        
    }
        
}
