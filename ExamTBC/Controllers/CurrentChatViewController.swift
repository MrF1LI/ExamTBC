//
//  CurrentChatViewController.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 10.08.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CurrentChatViewController: UIViewController {
    
    // MARK: Variables
    
    @IBOutlet weak var textFieldMessage: UITextField!
    @IBOutlet weak var textFieldMessageConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewMessages: UITableView!
    
    var chat: Chat!
    
    var arrayOfMessages = [Message]()
    
    let currentUser = Auth.auth().currentUser!
    let dbChats = Database.database().reference().child("chats")
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableViewMessages.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        configureNavigationItem()
        listenToKeyboard()
        configureTableViewMessages()
        loadMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: Functions
    
    func configureNavigationItem() {
        navigationItem.title = chat.title
    }
    
    func configureTableViewMessages() {
        tableViewMessages.delegate = self
        tableViewMessages.dataSource = self
        tableViewMessages.register(UINib(nibName: "SentMessageCell", bundle: nil), forCellReuseIdentifier: "SentMessageCell")
        tableViewMessages.register(UINib(nibName: "ReceivedMessageCell", bundle: nil), forCellReuseIdentifier: "ReceivedMessageCell")
    }
    
    func loadMessages() {
        
        let messagesRef = dbChats.child(chat.id).child("messages")
        
        messagesRef.observe(.childAdded) { snapshot in
            let currentMessage = Message(with: snapshot)
            self.arrayOfMessages.append(currentMessage)
            
            self.tableViewMessages.reloadData()
        }
        
    }
    
    // MARK: Actions
    
    @IBAction func actionSendMessage(_ sender: UIButton) {
        
        guard let message = textFieldMessage.text, !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let messagesRef = dbChats.child(chat.id).child("messages")
        let messageKey = messagesRef.childByAutoId()
        let date = String(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none))
        
        let messageData = [
            "id": messageKey.key,
            "sender": currentUser.uid,
            "content": message,
            "date": date
        ]
        
        messageKey.setValue(messageData)
        textFieldMessage.text = ""
        
    }
    
}

// MARK: Change Keyboard Constraints

extension CurrentChatViewController {
    
    func listenToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        let keyboardHeight = keyboardSize?.height
        
        if #available(iOS 11.0, *){
            self.textFieldMessageConstraint.constant = keyboardHeight! - view.safeAreaInsets.bottom
        }
        else {
            self.textFieldMessageConstraint.constant = view.safeAreaInsets.bottom
        }
        
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    
    @objc func keyboardWillHide(notification: Notification){
        
        self.textFieldMessageConstraint.constant =  0 // or change according to your logic
        
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
        
    }
    
}
