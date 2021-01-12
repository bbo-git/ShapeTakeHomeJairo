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
    var refresh: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Take Home Jairo"
        setup()
        getData()
    }
    
    func setup() {
        collectionView.allowsSelection = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "EmptyCell")
        
        refresh = UIRefreshControl()
        collectionView.refreshControl = refresh
        refresh?.addTarget(self, action: #selector(getData), for: .valueChanged)
        
        
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
                self?.refresh?.endRefreshing()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DownloadManager.shared.models.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ModelCell", for: indexPath) as? ModelCell {
            cell.model = DownloadManager.shared.models[indexPath.item]
            cell.coordinator = self.coordinator
            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath)
        }
    }
    
}
