//
//  HomeViewController.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 01.08.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {
    
    // MARK: - Variables

    @IBOutlet weak var imageViewUserProfile: UIImageView!
    @IBOutlet weak var backgroundAddPost: UIView!
    
    @IBOutlet weak var tableViewPosts: UITableView!
    @IBOutlet weak var tableViewPostsHeight: NSLayoutConstraint!
    
    var currentUser = Auth.auth().currentUser!
    var dbUsers = Database.database().reference().child("users")
    var dbPosts = Database.database().reference().child("posts")
    
    var arrayOfPosts = [Post]()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureDesign()
        loadUserImage()
        configureTableView()
        loadPosts()
        listenToAddPost()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableViewPosts.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        tableViewPosts.removeObserver(self, forKeyPath: "contentSize")
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "contentSize" {
            if object is UITableView {
                if let newValue = change?[.newKey] {
                    let newSize = newValue as! CGSize
                    self.tableViewPostsHeight.constant = newSize.height
                }
            }
        }

    }
    
    // MARK: - Initial Functions
    
    func configureDesign() {
        backgroundAddPost.layer.cornerRadius = 35
        imageViewUserProfile.layer.cornerRadius = imageViewUserProfile.frame.width / 2
        
    }
    
    func loadUserImage() {
        
        dbUsers.child(currentUser.uid).observe(.value) { snapshot in
            let value = snapshot.value as? NSDictionary
            
            let url = value?["profile"] as? String ?? ""

            self.imageViewUserProfile.sd_setImage(with: URL(string: url),
                                               placeholderImage: UIImage(named: "user"),
                                               options: .continueInBackground,
                                               completed: nil)
        }
    }
    
    func configureTableView() {
        tableViewPosts.delegate = self
        tableViewPosts.dataSource = self
        
        tableViewPosts.register(UINib(nibName: "TextPostCell", bundle: nil), forCellReuseIdentifier: "TextPostCell")
        tableViewPosts.register(UINib(nibName: "ImagePostCell", bundle: nil), forCellReuseIdentifier: "ImagePostCell")
        tableViewPosts.register(UINib(nibName: "PollCell", bundle: nil), forCellReuseIdentifier: "PollCell")
        
        tableViewPosts.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func loadPosts() {
        
        tableViewPosts.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        dbPosts.observe(.value) { snapshot in
            
            self.arrayOfPosts.removeAll()
            
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                
                let data = child.value as? [String : AnyObject] ?? [:]
                let type = data["type"] as? String ?? ""
                
                // Date
                
                let dateAsString = data["date"] as? String ?? ""
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .medium

                let dateObj = dateFormatter.date(from: dateAsString) ?? Date.now
                
                //
                
                if type == "text" {
                    
                    let post = TextPost(id: data["id"] as? String ?? "",
                                        author: data["author"] as? String ?? "",
                                        content: data["content"] as? String ?? "", date: dateObj)
                    self.arrayOfPosts.append(post)
                    
                } else if type == "image" {
                    
                    var post = ImagePost(id: data["id"] as? String ?? "",
                                         author: data["author"] as? String ?? "",
                                         imageUrl: data["image"] as? String ?? "", date: dateObj)
                    
                    if let content = data["content"] as? String {
                        post.text = content
                    }
                    
                    self.arrayOfPosts.append(post)
                    
                }
                
            }
            
            self.arrayOfPosts.sort { post1, post2 in
                post1.date > post2.date
            }
            
            self.tableViewPosts.reloadData()
        }

    }
    
    func listenToAddPost() {
        NotificationCenter.default.addObserver(self, selector: #selector(actionReloadPost), name: Notification.Name("postPublished"), object: nil)
    }

    // MARK: - Actions
    
    @IBAction func actionAddPost(_ sender: UIButton) {
        goToAddPostPage()
    }
    
    @objc func actionReloadPost() {
        loadPosts()
    }
    
    // MARK: Navigation Functions
    
    func goToAddPostPage() {
        let addPostVC = storyboard?.instantiateViewController(withIdentifier: "AddPostViewController") as? AddPostViewController
        guard let addPostVC = addPostVC else { return }
        
        let navigationController = UINavigationController(rootViewController: addPostVC)
        present(navigationController, animated: true)
    }
    
}
