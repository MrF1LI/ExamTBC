//
//  UserProfileViewController.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 05.08.22.
//

import UIKit
import FirebaseDatabase

class UserProfileViewController: UIViewController {
    
    // MARK: Variables
    
    @IBOutlet weak var imageViewUserProfile: UIImageView!
    @IBOutlet weak var labelUserFullName: UILabel!
    @IBOutlet weak var labelUserEmail: UILabel!
    @IBOutlet weak var tableViewStudentInfo: UITableView!
    @IBOutlet weak var tableViewStudentInfoHeight: NSLayoutConstraint!
    
    var arrayOfStudentInfo = [UserInfo]()
    
    var dbUsers = Database.database().reference().child("users")
    
    var currentUserId: String!
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureDesign()
        configureTableViewStudentInfo()
        loadUserInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableViewStudentInfo.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tableViewStudentInfo.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentSize" {
            if object is UITableView {
                if let newValue = change?[.newKey] {
                    let newSize = newValue as! CGSize
                    self.tableViewStudentInfoHeight.constant = newSize.height
                }
            }
        }
        
    }
    
    // MARK: Functions
    
    func configureDesign() {
        imageViewUserProfile.layer.cornerRadius = imageViewUserProfile.frame.width / 2
    }
    
    func configureTableViewStudentInfo() {
        tableViewStudentInfo.layer.cornerRadius = 35
        
        tableViewStudentInfo.delegate = self
        tableViewStudentInfo.dataSource = self
        tableViewStudentInfo.register(UINib(nibName: "StudentInfoCell", bundle: nil), forCellReuseIdentifier: "StudentInfoCell")
    }
    
    func loadUserInfo() {
        
        tableViewStudentInfo.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        dbUsers.child(currentUserId).observe(.value) { snapshot in
            
            self.arrayOfStudentInfo.removeAll()
            
            let value = snapshot.value as? NSDictionary
            let user = User(id: value?["id"] as? String ?? "",
                            name: value?["name"] as? String ?? "",
                            surname: value?["surname"] as? String ?? "",
                            age: value?["age"] as? Int ?? 0,
                            email: value?["email"] as? String ?? "")
            
            // load user info
            
            let faculty = value?["faculty"] as? String ?? ""
            let course = value?["course"] as? String ?? ""
            let minor = value?["minor"] as? String ?? ""
            
            self.labelUserFullName.text = "\(user.name) \(user.surname)"
            self.labelUserEmail.text = "\(user.email)"
            
            var userInfo = [
                UserInfo(name: "\(user.age)", image: .age),
                UserInfo(name: course, image: .course),
                UserInfo(name: faculty, image: .faculty)
            ]
            
            if !minor.isEmpty {
                userInfo.append(UserInfo(name: "Minor: \(minor)", image: .minor))
            }
                        
            self.arrayOfStudentInfo.append(contentsOf: userInfo)
            self.tableViewStudentInfo.reloadData()
            
            // Load Profile Picture
            
            let url = value?["profile"] as? String ?? ""
            
            self.imageViewUserProfile.sd_setImage(with: URL(string: url),
                                              placeholderImage: UIImage(named: "user"),
                                              options: .continueInBackground,
                                              completed: nil)
            
            //
            
        }
        
    }

}
