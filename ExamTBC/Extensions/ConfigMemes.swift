//
//  ConfigMemes.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 02.08.22.
//

import Foundation
import UIKit

extension MemesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayOfMemes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as? MemeCell
        guard let cell = cell else { return UICollectionViewCell() }
        
        let currentMeme = arrayOfMemes[indexPath.row]
        cell.configure(with: currentMeme)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGFloat = collectionViewMemes.frame.width / CGFloat(scale) - 1
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeVC = self.storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as? MemeViewController
        guard let memeVC = memeVC else { return }
        
        memeVC.selectedIndex = indexPath.row
        memeVC.arrayOfMemes = arrayOfMemes
        
        navigationController?.pushViewController(memeVC, animated: true)
    }
    
}
