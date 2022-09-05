//
//  ProfileViewController.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 01.08.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    @IBOutlet weak var tableViewStudentInfo: UITableView!
    @IBOutlet weak var tableViewStudentInfoHeight: NSLayoutConstraint!
    
    var arrayOfStudentInfo = [UserInfo]()
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUserProfile()
        configureNotificationCenter()
        configureTableViewStudentInfo()
    }
    
    // MARK: Initial Functions
    
    func configureUserProfile() {
        imageViewProfile.contentMode = .scaleAspectFill
        imageViewProfile.layer.cornerRadius = imageViewProfile.frame.width / 2
        loadUserInfo()
    }
    
    func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadUserInfo), name: NSNotification.Name("profileEdited"), object: nil)
    }
    
    func configureTableViewStudentInfo() {
        tableViewStudentInfo.delegate = self
        tableViewStudentInfo.dataSource = self
        tableViewStudentInfo.register(UINib(nibName: "StudentInfoCell", bundle: nil), forCellReuseIdentifier: "StudentInfoCell")
        
        tableViewStudentInfo.layer.cornerRadius = 35
    }
    
    // MARK: Actions

    @IBAction func actionEditProfile(_ sender: UIButton) {
        goToEditProfile()
    }
    
    @IBAction func actionSettings(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            goToLogInPage()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
    
    @objc func reloadUserInfo() {
        tableViewStudentInfo.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    // MARK: Functions
    
    func loadUserInfo() {
        
        tableViewStudentInfo.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        let currentUserId = FirebaseService.currentUser!.uid
        
        FirebaseService.shared.fetchUserInfo(by: currentUserId) { user, userInfo in
            self.labelFullName.text = "\(user.name) \(user.surname)"
            self.labelEmail.text = "\(user.email)"
            
            self.arrayOfStudentInfo.append(contentsOf: userInfo)
            self.tableViewStudentInfo.reloadData()
            
            self.imageViewProfile.sd_setImage(with: URL(string: user.profilePicture ?? ""),
                                              placeholderImage: UIImage(named: "user"),
                                              options: .continueInBackground,
                                              completed: nil)
        }
        
    }
        
    // MARK: Navigation Functions
    
    func goToEditProfile() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController
        guard let vc = vc else { return }
        
        vc.title = "Edit Profile"
        parent?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToLogInPage() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        guard let vc = vc else { return }
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
}
