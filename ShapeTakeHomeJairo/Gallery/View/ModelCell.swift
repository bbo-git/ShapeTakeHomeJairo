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
    
    var model: ModelData? {
        didSet {
            guard let model = model,
                  let url = model.localUrl,
                  FileManager.default.fileExists(atPath: url.absoluteString)
                  else { return }
            activityIndicator.startAnimating()
            idLabel.text = "ID: " + model.id
            descriptionLabel.text = "DESC: " + model.desc
            let sceneSource = GLTFSceneSource(url: url)
            let scene = try? sceneSource.scene(options: [SCNSceneSource.LoadingOption.convertUnitsToMeters : true, SCNSceneSource.LoadingOption.checkConsistency:true])
            self.scnview.scene = scene
            self.activityIndicator.stopAnimating()
        }
    }
}
