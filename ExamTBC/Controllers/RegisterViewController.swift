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
    
    var dbUsers = Database.database().reference().child("users")
    var currentUser = Auth.auth().currentUser!
    
    var storage = Storage.storage().reference()
    
    var profileImageData: Data?
    
    var datePicker = UIDatePicker()
    var coursePicker = UIPickerView()
    var facultyPicker = UIPickerView()
    
    var arrayOfCourses = ["I Course", "II Course", "III Course", "IV Course"]
    var arrayOfFaculties = ["Information Technologies", "Management", "Finance", "Digital Marketing"]
    
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
        
        let currentUserFullName = currentUser.displayName!.components(separatedBy: " ")
        
        textFieldName.text = currentUserFullName[0]
        textFieldSurname.text = currentUserFullName[1]
        
        if let data = try? Data(contentsOf: currentUser.photoURL!)
        {
            imageViewProfile.image = UIImage(data: data)
        }
        
        imageViewProfile.layer.cornerRadius = imageViewProfile.frame.width / 2
        
    }
    
    func createDatePicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let buttonDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(actionDatePicker))
        toolbar.setItems([buttonDone], animated: true)
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels

        textFieldDate.inputAccessoryView = toolbar
        textFieldDate.inputView = datePicker
        
    }
    
    func configureCoursePicker() {
        coursePicker.delegate = self
        coursePicker.dataSource = self
        textFieldCourse.inputView = coursePicker
        coursePicker.tag = 1
    }
    
    func configureFacultyPicker() {
        facultyPicker.delegate = self
        facultyPicker.dataSource = self
        textFieldFaculty.inputView = facultyPicker
        facultyPicker.tag = 2
    }
    
    func configureProfileImageView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(actionImageViewProfile))
        imageViewProfile.addGestureRecognizer(gesture)
        imageViewProfile.contentMode = .scaleAspectFill
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
    
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func registerUser(name: String, surname: String, date: String, course: String, faculty: String) {
        
        let userRef = dbUsers.child(currentUser.uid)
        let age = datePicker.date.getAge()
        
        let userInfo: [String : Any] = [
            "id": currentUser.uid,
            "name": name,
            "surname": surname,
            "date": date,
            "course": course,
            "faculty": faculty,
            "email": currentUser.email ?? "",
            "age": age
        ]
        
        userRef.setValue(userInfo)
        
        if let profileImageData = profileImageData {
            uploadProfilePicture(imageData: profileImageData)
        } else {
            dbUsers.child(currentUser.uid).child("profile").setValue(currentUser.photoURL?.absoluteString)
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
