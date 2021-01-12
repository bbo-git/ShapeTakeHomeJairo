//
//  ModelCell.swift
//  ShapeTakeHomeJairo
//
//  Created by Jairo Bambang Oetomo on 10/01/2021.
//

import UIKit
import GLTFSceneKit
import SceneKit

class ModelCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scnview: SCNView!
    @IBOutlet weak var button: UIButton!
    
    var coordinator: MainCoordinator?
    
    var model: ModelData? {
        didSet {
            guard let model = model,
                  let url = model.localUrl,
                  FileManager.default.fileExists(atPath: url.path)
                  else { return }
            idLabel.text = "ID: " + model.id
            descriptionLabel.text = "DESC: " + model.desc
            let sceneSource = GLTFSceneSource(url: url)
            do {
                let scene = try sceneSource.scene()
                self.scnview.scene = scene
                self.activityIndicator.stopAnimating()
            } catch { print(error) }
            
        }
    }
    @IBAction func showDetail(_ sender: UIButton) {
        coordinator?.didSelectItem(model: model!)
    }
}
