//
//  MemesViewController.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 01.08.22.
//

import UIKit
import FirebaseDatabase

class MemesViewController: UIViewController {
    
    // MARK: Variables
    
    @IBOutlet weak var collectionViewMemes: UICollectionView!
    
    var dbMemes = Database.database().reference().child("memes")
    
    var arrayOfMemes = [Meme]()
    
    var scale = 3
    
    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureCollectionView()
        loadMemes()
        configGestures()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UserDefaults.standard.setValue(scale, forKey: "scale")
    }
    
    // MARK: Initial functions
        
    func configureCollectionView() {
        
        collectionViewMemes.delegate = self
        collectionViewMemes.dataSource = self
        collectionViewMemes.register(UINib(nibName: "MemeCell", bundle: nil), forCellWithReuseIdentifier: "MemeCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        collectionViewMemes.collectionViewLayout = layout
        
        // columns
        
        scale = UserDefaults.standard.value(forKey: "scale") as? Int ?? 3
                
    }
    
    func loadMemes() {
        
        dbMemes.observe(.value) { [self] snapshot in
            
            self.arrayOfMemes.removeAll()
            
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                
                let data = child.value as? [String:AnyObject] ?? [:]
                
                let currentMeme = Meme(author: data["author"] as? String ?? "",
                                       imageUrl: data["url"] as? String ?? "")
                
                arrayOfMemes.append(currentMeme)
                
            }
            
            self.collectionViewMemes.reloadData()
            
        }
        
    }
    
    func configGestures() {
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(actionCollectionView))
        collectionViewMemes.addGestureRecognizer(gesture)
    }

    // MARK: Actions

    @IBAction func actionAddMeme(_ sender: UIButton) {
        let addMemeVC = storyboard?.instantiateViewController(withIdentifier: "AddMemeViewController") as? AddMemeViewController
        guard let addMemeVC = addMemeVC else { return }
        
        let navigationController = UINavigationController(rootViewController: addMemeVC)
        present(navigationController, animated: true)
    }
    
    @objc func actionCollectionView(gesture: UIPinchGestureRecognizer) {
        
        if gesture.state == .ended {
            if gesture.scale > 1 {
                if scale > 1 {
                    scale -= 1
                }
            } else {
                if scale < 5 {
                    scale += 1
                }
            }
            gesture.scale = 1
            collectionViewMemes.reloadData()
        }
        
    }
    
    
}
