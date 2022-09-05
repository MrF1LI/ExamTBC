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
//        tableViewLecturers.delegate = self
//        tableViewLecturers.dataSource = self
//        tableViewLecturers.register(UINib(nibName: "LecturerCell", bundle: nil), forCellReuseIdentifier: "LecturerCell")
        
        tableViewLecturers.layer.cornerRadius = 35
    }
    
    func loadLecturers() {
        tableViewLecturers.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        FirebaseService.shared.fetchLecturers { arrayOfLecturers in
            self.arrayOfLecturers = arrayOfLecturers
            self.tableViewLecturers.reloadData()
        }
    }

}

class RatesViewModel {
    
    let firebaseManager: FirebaseService
    
    required init(with firebaseManager: FirebaseService)  {
        self.firebaseManager = firebaseManager
    }
    
    func getLecturersList(completion: @escaping (([LecturerViewModel]) -> Void)) {
        firebaseManager.fetchLecturers { arrayOfLecturers in
            DispatchQueue.main.async {
                
                let countriesViewModels =  arrayOfLecturers.map { LecturerViewModel(lecturer: $0) }
                completion(countriesViewModels)
            }
        }
    }
    
}

class RatesDataSource: NSObject {
    
    private var tableView: UITableView
    private var viewModel: RatesViewModel
    private var arrayOfLecturers: [LecturerViewModel] = []
    
    init(tableView: UITableView, viewModel: RatesViewModel) {
        self.tableView = tableView
        self.viewModel = viewModel
        super.init()
        setUpDelegates()
    }
    
    private func setUpDelegates() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

}

extension RatesDataSource: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfLecturers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LecturerCell", for: indexPath) as? LecturerCell
        guard let cell = cell else { return UITableViewCell() }
        
        let currentLecturer = arrayOfLecturers[indexPath.row]
        cell.setInformation(lecturer: currentLecturer)
        
        return cell
    }
    
    
}
