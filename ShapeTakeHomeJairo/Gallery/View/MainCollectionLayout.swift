//
//  MainCollectionLayout.swift
//  ShapeTakeHomeJairo
//
//  Created by Jairo Bambang Oetomo on 10/01/2021.
//

import UIKit

class MainCollectionLayout: UICollectionViewFlowLayout {
    
    func setLayout() {
        collectionView?.contentInset = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        minimumLineSpacing = 24
        minimumInteritemSpacing = 24
        let width = collectionView?.bounds.width ?? 0
        let cellWidth = (width - (3 * minimumInteritemSpacing)) / 2
        itemSize = CGSize(width: cellWidth, height: cellWidth)
    }

}
