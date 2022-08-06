//
//  RatesViewController.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 01.08.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RatesViewController: UIViewController {
    
    // MARK: Variables
    
    @IBOutlet weak var tableViewLecturers: UITableView!
    @IBOutlet weak var tableViewLecturersHeight: NSLayoutConstraint!
    
    var arrayOfLecturers = [Lecturer]()
    
    var currentUser = Auth.auth().currentUser!
    static var db = Database.database().reference()
    var dbUsers = db.child("users")
    var dbLecturers = db.child("lecturers")
    
    // MARK: LIfecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureTableView()
        loadLecturers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableViewLecturers.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        tableViewLecturers.removeObserver(self, forKeyPath: "contentSize")
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "contentSize" {
            if object is UITableView {
                if let newValue = change?[.newKey] {
                    let newSize = newValue as! CGSize
                    self.tableViewLecturersHeight.constant = newSize.height
                }
            }
        }

    }
    
    // MARK: Initial Functions
    
    func configureTableView() {
        
        tableViewLecturers.delegate = self
        tableViewLecturers.dataSource = self
        tableViewLecturers.register(UINib(nibName: "LecturerCell", bundle: nil), forCellReuseIdentifier: "LecturerCell")
        
        tableViewLecturers.layer.cornerRadius = 35

    }
    
    func loadLecturers() {
        
        tableViewLecturers.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        
        dbLecturers.observe(.value) { snapshot in
            
            self.arrayOfLecturers.removeAll()
            
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                
                let data = child.value as? [String : AnyObject] ?? [:]
                
                let ratesDict = data["rates"] as! [String: Float]
                let rates = ratesDict.map { _, rate in rate }
                let rating = Float(rates.reduce(0, +)) / Float(rates.count)
                
                let currentLecturer = Lecturer(id: data["id"] as? String ?? "",
                                               name: data["name"] as? String ?? "",
                                               surname: data["surname"] as? String ?? "",
                                               email: data["email"] as? String ?? "",
                                               subject: data["subject"] as? String ?? "",
                                               rating: rating,
                                               profileImage: data["profile"] as? String ?? "")
                
                                
                self.arrayOfLecturers.append(currentLecturer)
            }
                                    
            self.tableViewLecturers.reloadData()
        }
        
                
    }

}
