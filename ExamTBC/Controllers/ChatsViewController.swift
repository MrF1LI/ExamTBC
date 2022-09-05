//
//  ChatsViewController.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 01.08.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChatsViewController: UIViewController {
    
    @IBOutlet weak var tableViewChats: UITableView!
    @IBOutlet weak var tableViewChatsHeight: NSLayoutConstraint!
    
    var arrayOfChats = [Chat]()
    var arrayOfChatIds = [String]()
    
    let semaphore = DispatchSemaphore(value: 1)
    let queue = DispatchQueue(label: "queue", qos: .background)
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
        configureTableViewChats()
        
        queue.async {
            self.semaphore.wait()
            self.getUserChats()
        }
        
        queue.async {
            self.semaphore.wait()
            self.loadChats()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableViewChats.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tableViewChats.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentSize" {
            if object is UITableView {
                if let newValue = change?[.newKey] {
                    let newSize = newValue as! CGSize
                    self.tableViewChatsHeight.constant = newSize.height
                }
            }
        }
        
    }
    
    // MARK: Functions
    
    func configure() {
        title = "Chats"
        navigationItem.backButtonTitle = "Back"
    }
    
    func configureTableViewChats() {
        tableViewChats.layer.cornerRadius = 35
        
        tableViewChats.delegate = self
        tableViewChats.dataSource = self
        tableViewChats.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "ChatCell")
    }
    
    func getUserChats() {
        
        let referenceOfChats = FirebaseService.dbUsers.child(FirebaseService.currentUser!.uid).child("chats")
        
        referenceOfChats.observe(.value) { dataSnapshot in
            
            for snapshot in dataSnapshot.children {
                let currentChatId = (snapshot as AnyObject).key as String
                self.arrayOfChatIds.append(currentChatId)
            }
            
            self.semaphore.signal()
            
        }
        
    }
    
    func loadChats() {
        
        tableViewChats.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
                
        FirebaseService.dbChats.observe(.value) { dataSnapshot in
            
            self.arrayOfChats.removeAll()
            
            for snapshot in dataSnapshot.children.allObjects as! [DataSnapshot] {
                var currentChat = Chat(with: snapshot)
                                
                if self.arrayOfChatIds.contains(currentChat.id) {
                                        
                    snapshot.childSnapshot(forPath: "messages")
                        .ref.queryOrderedByKey().queryLimited(toLast: 1).observe(.childAdded) { snapshot in
                            let message = Message(with: snapshot)
                            currentChat.lastMessage = message
                        }
                    
                    //
                    
                    if currentChat.type == .personal {
                        
                        let receiverId = currentChat.members.first { $0 != FirebaseService.currentUser!.uid }
                        
                        FirebaseService.dbUsers.child(receiverId ?? "").observe(.value) { receiverSnapshot in
                            let receiver = User(with: receiverSnapshot)
                            
                            currentChat.title = "\(receiver.name) \(receiver.surname)"
                            currentChat.image = receiver.profilePicture
                            self.arrayOfChats.append(currentChat)
                            self.tableViewChats.reloadData()
                        }
                        
                    } else {
                        self.arrayOfChats.append(currentChat)
                        self.tableViewChats.reloadData()
                    }
                    
                    
                }
                
                //
                
            }
        }
        
    }
    
    @IBAction func actionNewMessage(_ sender: UIButton) {
        let newMessageVC = storyboard?.instantiateViewController(withIdentifier: "NewMessageViewController") as? NewMessageViewController
        guard let newMessageVC = newMessageVC else { return }
        
        let navigationController = UINavigationController(rootViewController: newMessageVC)
        present(navigationController, animated: true)
    }
    
    // MARK: Navigation functions
    
    func open(chat: Chat) {
        let currentChatVC = storyboard?.instantiateViewController(withIdentifier: "CurrentChatViewController") as? CurrentChatViewController
        guard let currentChatVC = currentChatVC else { return }
        
        currentChatVC.chat = chat
        
        navigationController?.pushViewController(currentChatVC, animated: true)
    }
    
}
