//
//  ConfigStudentInfo2.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 05.08.22.
//

import Foundation
import UIKit

extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfStudentInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentInfoCell", for: indexPath) as? StudentInfoCell
        guard let cell = cell else { return UITableViewCell() }
        
        let currentInfo = arrayOfStudentInfo[indexPath.row]
        
        cell.set(info: currentInfo.name, image: currentInfo.image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
