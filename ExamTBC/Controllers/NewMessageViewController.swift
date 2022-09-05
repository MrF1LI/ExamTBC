//
//  NewMessageViewController.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 09.08.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class NewMessageViewController: UIViewController {
    
    @IBOutlet weak var tableViewUsers: UITableView!
    
    let searchController = UISearchController()
    
    var arrayOfUsers = [User]()
    var filterdUsers: [User] = []
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadUsers()
        configureNavigationItem()
        configureTableViewUsers()
    }
    
    // MARK: Initial Functions
    
    func configureNavigationItem() {
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        
        let buttonCancel = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(actionCancel))
        navigationItem.leftBarButtonItem = buttonCancel
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        navigationItem.searchController = searchController
    }
    
    func configureTableViewUsers() {
        tableViewUsers.delegate = self
        tableViewUsers.dataSource = self
        tableViewUsers.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    }
    
    func loadUsers() {
        FirebaseService.dbUsers.observeSingleEvent(of: .value) { snapshot in

            self.arrayOfUsers.removeAll()

            for child in snapshot.children.allObjects as! [DataSnapshot] {

                let currentUser = User(with: child)
                if currentUser.id != FirebaseService.currentUser!.uid {
                    self.arrayOfUsers.append(currentUser)
                }

            }

            self.filterdUsers = self.arrayOfUsers
            self.tableViewUsers.reloadData()

        }
    }
    
    // MARK: Actions
    
    @objc func actionCancel() {
        dismiss(animated: true)
    }

}

extension NewMessageViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchText = (searchController.searchBar.text ?? "").lowercased()
        
        filterdUsers = []
        
        if searchText == "" {
            filterdUsers = arrayOfUsers
        }
        
        for user in arrayOfUsers {
            
            let fullName = "\(user.name) \(user.surname)"
            if user.email.lowercased().contains(searchText) || fullName.lowercased().contains(searchText) {
                filterdUsers.append(user)
            }
            
        }
        
        self.tableViewUsers.reloadData()
        
    }
        
}

extension NewMessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterdUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell
        guard let cell = cell else { return UITableViewCell() }
        
        let currentUser = filterdUsers[indexPath.row]
        cell.configure(with: currentUser)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)        
//        let currentChat = filterdUsers[indexPath.row]
        
        let myChat = Chat(id: "uEbjhX9YURY71EdGN7csjaYEvXs2B0sM2ON6jQMr7IVFdAzj4ll7h6v1", title: "Name Surname", members: ["uEbjhX9YURY71EdGN7csjaYEvXs2", "B0sM2ON6jQMr7IVFdAzj4ll7h6v1"], image: "https://firebasestorage.googleapis.com:443/v0/b/examtbc.appspot.com/o/images%2Fprofile_images%2FB0sM2ON6jQMr7IVFdAzj4ll7h6v1%2Fprofile.png?alt=media&token=d135d5f8-474d-45f3-8da9-fe328271fb2e", type: .personal)
        
        open(chat: myChat)
    }
    
    // MARK: Navigation Functions
    
    func open(chat: Chat) {
        let currentChatVC = storyboard?.instantiateViewController(withIdentifier: "CurrentChatViewController") as? CurrentChatViewController
        guard let currentChatVC = currentChatVC else { return }
        
        currentChatVC.chat = chat
        
        navigationController?.pushViewController(currentChatVC, animated: true)
    }
    
}
