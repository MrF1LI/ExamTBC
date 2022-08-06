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
    
    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureCollectionView()
        loadMemes()
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

    @IBAction func actionAddMeme(_ sender: UIButton) {
        let addMemeVC = storyboard?.instantiateViewController(withIdentifier: "AddMemeViewController") as? AddMemeViewController
        guard let addMemeVC = addMemeVC else { return }
        
        let navigationController = UINavigationController(rootViewController: addMemeVC)
        present(navigationController, animated: true)
    }
    
}
