//
//  MainTabBarViewController.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 01.08.22.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Actions

    @IBAction func actionChat(_ sender: UIBarButtonItem) {
        goToChats()
    }
    
    // MARK: Navigation Functions
    
    func goToChats() {
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatsViewController")
        guard let chatVC = chatVC else { return }
        
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
}
