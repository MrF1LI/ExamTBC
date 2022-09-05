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
    
    @IBOutlet weak var stackViewNameAndRecomend: UIStackView!
    @IBOutlet weak var imageViewRecomendation: UIImageView!
    
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
        
    var lecturer: Lecturer?
    var arrayOfReviews = [Review]()
    
    var activeField: UITextField?
    
    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
        configureRatingView()
        loadLecturerInfo()
        configureTableViewReviews()
        loadReviews()
        listenToKeyboard()
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
        guard let lecturer = lecturer else { return }

        lecturerRating.didFinishTouchingCosmos = { rate in
            FirebaseService.shared.rate(lecturer: lecturer, by: rate) {
                self.getLecturerRating()
            }
        }
    }
    
    func loadLecturerInfo() {
        
        guard let lecturer = lecturer else { return }

        labelLecturerFullName.text = "\(lecturer.name) \(lecturer.surname)"
        labelLecturerEmail.text = lecturer.email
        
        getLecturerRating()
        
        self.imageViewLecturer.sd_setImage(with: URL(string: lecturer.profileImage),
                                           placeholderImage: UIImage(named: "user"),
                                           options: .continueInBackground,
                                           completed: nil)
        
    }
    
    func configureTableViewReviews() {
        tableViewReviews.delegate = self
        tableViewReviews.dataSource = self
        tableViewReviews.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        
        tableViewReviews.layer.cornerRadius = 35
    }
    
    func loadReviews() {
        
        guard let lecturer = lecturer else { return }
        tableViewReviews.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        FirebaseService.shared.fetchReviews(of: lecturer) { arrayOfReviews in
            self.labelReviewsTitle.isHidden = !(arrayOfReviews.count > 0)
            self.arrayOfReviews = arrayOfReviews
            self.tableViewReviews.reloadData()
        }

    }
    
    // MARK: Actions
    
    @IBAction func actionAddReview(_ sender: UIButton) {
        
        guard let lecturer = lecturer else { return }
        guard let review = textFieldReview.text else { return }
        
        
        FirebaseService.shared.review(lecturer: lecturer, with: review) {
            self.textFieldReview.text = ""
        }
        
    }
    
    // MARK: Functions
    
    func getLecturerRating() {
        
        guard let lecturer = lecturer else { return }

        FirebaseService.shared.fetchRating(of: lecturer) { ratingData, arrayOfRates, rating in
            self.labelLecturerRating.text = String(format: "%.1f", rating)
            self.lecturerRating.rating = Double(rating)
            self.configureRatingDesign(with: ratingData)
            
            self.labelRatesCount.text = "Based on \(arrayOfRates.count) rates"
            self.imageViewRecomendation.isHidden = !(rating >= 4.8 && arrayOfRates.count > 5)
            
        }
        
    }
    
    func configureRatingDesign(with ratingData: [String:Float]) {
        
        let arrayOfRates = ratingData.map { _, rate in rate }
        
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
    
    // MARK: Change Keyboard Constraints
    
    func listenToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        let keyboardHeight = keyboardSize?.height
        
        if #available(iOS 11.0, *){
            self.addReviewBackgroundConstant.constant = keyboardHeight! - view.safeAreaInsets.bottom
        }
        else {
            self.addReviewBackgroundConstant.constant = view.safeAreaInsets.bottom
        }
        
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    
    @objc func keyboardWillHide(notification: Notification){
        
        self.addReviewBackgroundConstant.constant =  0 // or change according to your logic
        
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
        
    }
    
}
