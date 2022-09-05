//
//  RegisterViewController.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 01.08.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RegisterViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldSurname: UITextField!
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var textFieldCourse: UITextField!
    @IBOutlet weak var textFieldFaculty: UITextField!
    
    // MARK: Variables
    
    var profileImageData: Data?
    
    var datePicker = UIDatePicker()
    var coursePicker = UIPickerView()
    var facultyPicker = UIPickerView()
    
    let arrayOfCourses = ["I Course", "II Course", "III Course", "IV Course"]
    let arrayOfFaculties = ["Information Technologies", "Management", "Finance", "Digital Marketing"]
    
    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureRegistrationForm()
        createDatePicker()
        configureCoursePicker()
        configureFacultyPicker()
        configureProfileImageView()
    }
    
    // MARK: Initial Functions
    
    func configureRegistrationForm() {
        
        let currentUserFullName = FirebaseService.currentUser!.displayName!.components(separatedBy: " ")
        
        textFieldName.text = currentUserFullName[0]
        textFieldSurname.text = currentUserFullName[1]
        
        imageViewProfile.layer.cornerRadius = imageViewProfile.frame.width / 2
        
        imageViewProfile.sd_setImage(with: URL(string: FirebaseService.currentUser!.photoURL!.absoluteString),
                                     placeholderImage: UIImage(named: "user"),
                                     options: .continueInBackground,
                                     completed: nil)
        
    }
    
    // MARK: Actions
    
    @IBAction func actionRegistration(_ sender: UIButton) {
        
        guard let name = textFieldName.text, !name.isEmpty,
              let surname = textFieldSurname.text, !surname.isEmpty,
              let dateText = textFieldDate.text, !dateText.isEmpty,
              let course = textFieldCourse.text, !course.isEmpty,
              let faculty = textFieldFaculty.text, !faculty.isEmpty
        else {
            print("Registration Failed.")
            return
        }
        
        let date = DateFormatter.localizedString(from: datePicker.date, dateStyle: .short, timeStyle: .none)
        
        registerUser(name: name, surname: surname, date: date, course: course, faculty: faculty)
        
    }
    
    @objc func actionDatePicker() {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        textFieldDate.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
        
    }
    
    @objc func actionImageViewProfile() {
        showImagePicker()
    }
    
    // MARK: Functions
    
    func registerUser(name: String, surname: String, date: String, course: String, faculty: String) {
        
        let userRef = FirebaseService.dbUsers.child(FirebaseService.currentUser!.uid)
        let age = datePicker.date.getAge()
        
        let userInfo: [String : Any] = [
            "id": FirebaseService.currentUser!.uid,
            "name": name,
            "surname": surname,
            "date": date,
            "course": course,
            "faculty": faculty,
            "email": FirebaseService.currentUser!.email ?? "",
            "age": age
        ]
        
        userRef.setValue(userInfo)
        
        if let profileImageData = profileImageData {
            uploadProfilePicture(imageData: profileImageData)
        } else {
            FirebaseService.dbUsers.child(FirebaseService.currentUser!.uid).child("profile").setValue(FirebaseService.currentUser!.photoURL?.absoluteString)
        }
        
        goToMainPage()
        
    }
    
    // MARK: Navigation Functions
    
    func goToMainPage() {
        let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "MainNavigationController")
        guard let navigationController = navigationController else { return }
                                
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }

}

