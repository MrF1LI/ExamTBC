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

        FirebaseService.shared.fetchUserInfo(by: currentUserId) { user, userInfo in
            self.labelUserFullName.text = "\(user.name) \(user.surname)"
            self.labelUserEmail.text = "\(user.email)"
            
            self.arrayOfStudentInfo.append(contentsOf: userInfo)
            self.tableViewStudentInfo.reloadData()
            
            self.imageViewUserProfile.sd_setImage(with: URL(string: user.profilePicture ?? ""),
                                              placeholderImage: UIImage(named: "user"),
                                              options: .continueInBackground,
                                              completed: nil)
        }
    
    }

}
