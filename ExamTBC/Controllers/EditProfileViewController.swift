//
//  EditProfileViewController.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 01.08.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class EditProfileViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldSurname: UITextField!
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var textFieldCourse: UITextField!
    @IBOutlet weak var textFieldFaculty: UITextField!
    @IBOutlet weak var switchMinor: UISwitch!
    @IBOutlet weak var textFieldMinor: UITextField!
    
    // MARK: Variables
        
    var datePicker = UIDatePicker()
    var coursePicker = UIPickerView()
    var facultyPicker = UIPickerView()
    var minorPicker = UIPickerView()
    
    var arrayOfCourses = ["I Course", "II Course", "III Course", "IV Course"]
    var arrayOfFaculties = ["Information Technologies", "Management", "Finance", "Digital Marketing"]
    
    var profileImageData: Data?
    
    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureForm()
        createDatePicker()
        configureCoursePicker()
        configureFacultyPicker()
        configureMinorPicker()
        configureProfileImageView()
    }
    
    // MARK: Initial Functions
    
    func configureForm() {
        imageViewProfile.layer.cornerRadius = imageViewProfile.frame.width / 2
        
        FirebaseService.dbUsers.child(FirebaseService.currentUser!.uid).observeSingleEvent(of: .value) { snapshot in
            
            let user = User(with: snapshot)
            
            // String to date
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short

            let dateObj = dateFormatter.date(from: user.birthDate ?? "")

            self.datePicker.date = dateObj ?? Date.now
            
            //
            
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
                        
            self.textFieldName.text = user.name
            self.textFieldSurname.text = user.surname
            self.textFieldCourse.text = user.course
            self.textFieldFaculty.text = user.faculty
            self.textFieldDate.text = formatter.string(from: self.datePicker.date)
            
            if !(user.minor ?? "").isEmpty {
                self.textFieldMinor.text = user.minor
                self.textFieldMinor.isEnabled = true
                self.switchMinor.isOn = true
            } else {
                self.textFieldMinor.isEnabled = false
                self.switchMinor.isOn = false
            }
            
            // Load Profile Picture
            
            self.imageViewProfile.sd_setImage(with: URL(string: user.profilePicture ?? ""),
                                              placeholderImage: UIImage(named: "user"),
                                              options: .continueInBackground,
                                              completed: nil)
            
            //
            
        }
        
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
    
    func configureMinorPicker() {
        minorPicker.delegate = self
        minorPicker.dataSource = self
        textFieldMinor.inputView = minorPicker
        minorPicker.tag = 3
    }
    
    func configureProfileImageView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(actionImageViewProfile))
        imageViewProfile.addGestureRecognizer(gesture)
        imageViewProfile.contentMode = .scaleAspectFill
    }
    
    // MARK: Actions
    
    @IBAction func actionSaveProfileInfo(_ sender: UIButton) {
        
        guard let name = textFieldName.text, !name.isEmpty,
              let surname = textFieldSurname.text, !surname.isEmpty,
              let dateText = textFieldDate.text, !dateText.isEmpty,
              let course = textFieldCourse.text, !course.isEmpty,
              let faculty = textFieldFaculty.text, !faculty.isEmpty
        else {
            print("Fill Form.")
            return
        }
        
        let date = DateFormatter.localizedString(from: datePicker.date, dateStyle: .short, timeStyle: .none)
        
        saveUserInfo(name: name, surname: surname, date: date, course: course, faculty: faculty)
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
    
    @IBAction func actionSwitch(_ sender: UISwitch) {
        textFieldMinor.isEnabled = sender.isOn
    }
    
    // MARK: Functions
    
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func saveUserInfo(name: String, surname: String, date: String, course: String, faculty: String) {
        
        let userRef = FirebaseService.dbUsers.child(FirebaseService.currentUser!.uid)
        
        let age = datePicker.date.getAge()
        
        var userInfo: [String : Any] = [
            "id": FirebaseService.currentUser!.uid,
            "name": name,
            "surname": surname,
            "date": date,
            "course": course,
            "faculty": faculty,
            "email": FirebaseService.currentUser!.email ?? "",
            "age": age
        ]
        
        if switchMinor.isOn {
            if let minor = textFieldMinor.text, !minor.isEmpty {
                userInfo["minor"] = minor
            }
        } else {
            userInfo["minor"] = ""
        }
        
        userRef.updateChildValues(userInfo)
        
        if let profileImageData = profileImageData {
            uploadProfilePicture(imageData: profileImageData)
        }
                
        NotificationCenter.default.post(name: NSNotification.Name("profileEdited"), object: nil, userInfo: nil)
        navigationController?.popViewController(animated: true)
    }

}
