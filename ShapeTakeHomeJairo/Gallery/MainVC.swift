//
//  MainVC.swift
//  ShapeTakeHomeJairo
//
//  Created by Jairo Bambang Oetomo on 10/01/2021.
//

import UIKit

class MainVC: UICollectionViewController {

    var coordinator: MainCoordinator?
    var models: [ModelData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        getData()
    }
    
    func setup() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "EmptyCell")
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(getData), for: .editingChanged)
        collectionView.refreshControl = refresh
        
        let layout = MainCollectionLayout()
        collectionView.setCollectionViewLayout(layout, animated: false)
        layout.setLayout()
    }
    
    @objc func getData() {
        DownloadManager.shared.getModelsJson { [weak self] (models, error) in
            guard models.count > 0 else {
                let alert = UIAlertController(title: "No models found", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                return
            }
            self?.models = models
            
            DownloadManager.shared.downloadAllModels() { (urls) in
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DownloadManager.shared.models.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ModelCell", for: indexPath) as? ModelCell {
            cell.model = DownloadManager.shared.models[indexPath.item]
            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath)
        }
    }

}
