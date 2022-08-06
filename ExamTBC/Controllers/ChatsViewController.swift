//
//  ChatsViewController.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 01.08.22.
//

import UIKit

class ChatsViewController: UIViewController {

    @IBOutlet weak var tableViewChats: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chats"
        // Do any additional setup after loading the view.
        configureTableViewChats()
    }
    

    func configureTableViewChats() {
        tableViewChats.layer.cornerRadius = 35
    }

}
