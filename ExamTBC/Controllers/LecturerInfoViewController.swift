//
//  LecturerInfoViewController.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 01.08.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class LecturerInfoViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var imageViewLecturer: UIImageView!
    @IBOutlet weak var labelLecturerFullName: UILabel!
    @IBOutlet weak var labelLecturerEmail: UILabel!
    
    @IBOutlet weak var labelLecturerRating: UILabel!
    @IBOutlet weak var lecturerRating: CosmosView!
    @IBOutlet weak var labelRatesCount: UILabel!
    
    @IBOutlet weak var progressViewExcellent: UIProgressView!
    @IBOutlet weak var progressViewGood: UIProgressView!
    @IBOutlet weak var progressViewAverage: UIProgressView!
    @IBOutlet weak var progressViewBelowAverage: UIProgressView!
    @IBOutlet weak var progressViewPoor: UIProgressView!
    
    @IBOutlet weak var ratingViewBackground: UIView!
    @IBOutlet weak var tableViewReviews: UITableView!
    @IBOutlet weak var tableViewReviewsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var addReviewBackgroundConstant: NSLayoutConstraint!
    @IBOutlet weak var viewAddReviewBackground: UIView!
    @IBOutlet weak var textFieldReview: UITextField!
    @IBOutlet weak var labelReviewsTitle: UILabel!
        
    // MARK: Variables
    
    static var db = Database.database().reference()
    var dbLecturers = db.child("lecturers")
    
    var lecturer: Lecturer?
    
    var arrayOfReviews = [Review]()
    
    var activeField: UITextField?
    
    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configure()
        configureRatingView()
        configureLecturerInfo()
        configureTableViewReviews()
        loadReviews()
        viewAddReviewBackground.bindToKeyboard()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tableViewReviews.removeObserver(self, forKeyPath: "contentSize")
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "contentSize" {
            if object is UITableView {
                if let newValue = change?[.newKey] {
                    let newSize = newValue as! CGSize
                    self.tableViewReviewsHeight.constant = newSize.height
                }
            }
        }

    }
    
    // MARK: Init functions
    
    func configure() {
        ratingViewBackground.layer.cornerRadius = 35
        imageViewLecturer.layer.cornerRadius = imageViewLecturer.frame.width / 2
        
        labelReviewsTitle.isHidden = true
        
        // Add review shadow
        
        viewAddReviewBackground.layer.shadowOffset = CGSize(width: 0,
                                          height: -10)
        viewAddReviewBackground.layer.shadowRadius = 10
        viewAddReviewBackground.layer.shadowOpacity = 0.1
    }
    
    func configureRatingView() {
        
        lecturerRating.didFinishTouchingCosmos = { rating in
            guard let lecturer = self.lecturer else { return }

            let ratesRef = self.dbLecturers.child(lecturer.id).child("rates")
            
            ratesRef.child(Auth.auth().currentUser!.uid).setValue(Int(rating))
            self.getLecturerRating()
            
        }
        
    }
    
    func configureLecturerInfo() {
        
        guard let lecturer = lecturer else { return }

        labelLecturerFullName.text = "\(lecturer.name) \(lecturer.surname)"
        labelLecturerEmail.text = lecturer.email
        
        getLecturerRating()
        
        dbLecturers.child(lecturer.id).child("profile").observeSingleEvent(of: .value) { snapshot in
            let url = snapshot.value as? String ?? ""
            
            self.imageViewLecturer.sd_setImage(with: URL(string: url),
                                               placeholderImage: UIImage(named: "user"),
                                               options: .continueInBackground,
                                               completed: nil)
            
        }
        
    }
    
    func configureTableViewReviews() {
        tableViewReviews.delegate = self
        tableViewReviews.dataSource = self
        tableViewReviews.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        
        tableViewReviews.layer.cornerRadius = 35
    }
    
    func loadReviews() {

        dbLecturers.child(lecturer!.id).child("reviews").observe(.value) { [self] snapshot in

            self.arrayOfReviews.removeAll()

            for child in snapshot.children.allObjects as! [DataSnapshot] {

                let data = child.value as? [String:AnyObject] ?? [:]
                var currentReview = Review(id: data["id"] as? String ?? "",
                                           author: data["author"] as? String ?? "",
                                           text: data["review"] as? String ?? "",
                                           date: data["date"] as? String ?? "")
                
                currentReview.lecturer = lecturer!.id

                self.arrayOfReviews.append(currentReview)

            }

            labelReviewsTitle.isHidden = !(arrayOfReviews.count > 0)
            self.tableViewReviews.reloadData()

        }

        tableViewReviews.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

    }
    
    // MARK: Actions
    
    @IBAction func actionAddReview(_ sender: UIButton) {
        
        guard let lecturer = lecturer else { return }
        guard let review = textFieldReview.text, !review.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let reviewsRef = dbLecturers.child(lecturer.id).child("reviews")
        let reviewRef = reviewsRef.childByAutoId()
                
        let date = String(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none))
        
        let data = [
            "id": reviewRef.key,
            "author": Auth.auth().currentUser!.uid,
            "date": date,
            "review": review
        ]
        
        reviewRef.setValue(data)
        
        textFieldReview.text = ""
        
    }
    
    // MARK: Functions
    
    func configureRatingDesign(with rates: [String:Float]) {
        
        let arrayOfRates = rates.map { _, rate in rate }
        
        let excellent = (arrayOfRates.filter { $0 == 5 }.count * 100) / arrayOfRates.count
        let good = (arrayOfRates.filter { $0 == 4 }.count * 100) / arrayOfRates.count
        let average = (arrayOfRates.filter { $0 == 3 }.count * 100) / arrayOfRates.count
        let belowAverage = (arrayOfRates.filter { $0 == 2 }.count * 100) / arrayOfRates.count
        let poor = (arrayOfRates.filter { $0 == 1 }.count * 100) / arrayOfRates.count
        
        progressViewExcellent.setProgress(Float(excellent) / 100, animated: true)
        progressViewGood.setProgress(Float(good) / 100, animated: true)
        progressViewAverage.setProgress(Float(average) / 100, animated: true)
        progressViewBelowAverage.setProgress(Float(belowAverage) / 100, animated: true)
        progressViewPoor.setProgress(Float(poor) / 100, animated: true)
                
    }
    
    func getLecturerRating() {
        
        dbLecturers.child(lecturer!.id).child("rates").observeSingleEvent(of: .value) { snapshot in
            let data = snapshot.value as? [String : Float] ?? [:]
            
            let rates = data.map { _, rate in rate }
            let rating = Float(rates.reduce(0, +)) / Float(rates.count)

            self.labelLecturerRating.text = String(format: "%.1f", rating)
            self.lecturerRating.rating = Double(rating)
            self.configureRatingDesign(with: data)
            
            self.labelRatesCount.text = "Based on \(rates.count) rates"
        }
        
    }
    
}
