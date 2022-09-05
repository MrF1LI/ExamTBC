//
//  ConfigLecturers.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 01.08.22.
//

import Foundation
import UIKit

//extension RatesViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        arrayOfLecturers.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "LecturerCell", for: indexPath) as? LecturerCell
//        guard let cell = cell else { return UITableViewCell() }
//        
//        let currentLecturer = arrayOfLecturers[indexPath.row]
//        cell.setInformation(lecturer: currentLecturer)
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        UITableView.automaticDimension
//    }
//    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        let currentLecturer = arrayOfLecturers[indexPath.row]
//        
//        showLecturerReviews(lecturer: currentLecturer)
//        
//    }
//    
//    // MARK: Functions
//    
//    func showLecturerReviews(lecturer: Lecturer) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LecturerInfoViewController") as? LecturerInfoViewController
//        guard let vc = vc else { return }
//        
//        vc.lecturer = lecturer
//        parent?.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//}
