//
//  MemeViewController.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 02.08.22.
//

import UIKit

class MemeViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var imageViewMeme: UIImageView!
    @IBOutlet weak var buttonCount: UIButton!
    
    // MARK: Variables
    
    var selectedIndex: Int!
    var arrayOfMemes: [Meme]!
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
        configureGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: Initial Functions
    
    func loadImage() {
        
        let currentMeme = arrayOfMemes[selectedIndex]
        imageViewMeme.transform = CGAffineTransform.identity
        
        UIView.transition(with: imageViewMeme,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: {
            self.imageViewMeme.sd_setImage(with: URL(string: currentMeme.imageUrl),
                                      placeholderImage: UIImage(named: "photo"),
                                      options: .continueInBackground,
                                      completed: nil)
        },
                          completion: nil)
        
        let count = "\(selectedIndex + 1) / \(arrayOfMemes.count)"
        buttonCount.setTitle(count, for: .normal)
    }
    
    func configureGestures() {
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(actionSwipe))
        rightSwipeGesture.direction = .right
        view.addGestureRecognizer(rightSwipeGesture)
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(actionSwipe))
        leftSwipeGesture.direction = .left
        view.addGestureRecognizer(leftSwipeGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(actionPinch))
        imageViewMeme.addGestureRecognizer(pinchGesture)
        
        
    }
    
    // MARK: Actions
    
    @IBAction func actionClose(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func actionSwipe(gesture: UISwipeGestureRecognizer) {
        
        switch gesture.direction {
        case .right:
            self.selectedIndex -= 1
        case .left:
            self.selectedIndex += 1
        default:
            break
        }
        
        selectedIndex = (selectedIndex < 0) ? (arrayOfMemes.count - 1) : selectedIndex % arrayOfMemes.count
        loadImage()
        
    }
    
    @objc func actionPinch(gesture: UIPinchGestureRecognizer) {
        
        if gesture.state == .began || gesture.state == .changed {
            gesture.view?.transform = (gesture.view?.transform.scaledBy(x: gesture.scale, y: gesture.scale))!
            gesture.scale = 1
        } else {
            if imageViewMeme.frame.width < view.frame.width {
                imageViewMeme.transform = CGAffineTransform.identity
            }
        }
        
    }
    
}
