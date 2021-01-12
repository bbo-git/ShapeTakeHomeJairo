//
//  DetailVC.swift
//  ShapeTakeHomeJairo
//
//  Created by Jairo Bambang Oetomo on 12/01/2021.
//

import UIKit
import SceneKit
import GLTFSceneKit

class DetailVC: UIViewController {

    @IBOutlet weak var scnview: SCNView!
    var model: ModelData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = model?.desc
        
        guard let model = model,
              let url = model.localUrl,
              FileManager.default.fileExists(atPath: url.path)
        else { return }
        let sceneSource = GLTFSceneSource(url: url)
        do {
            let scene = try sceneSource.scene()
            self.scnview.scene = scene
        } catch { print(error) }
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(back))
    }
    
    @objc func back() {
        UIView.transition(with: (self.navigationController?.view)!, duration: 0.75, options: .transitionFlipFromLeft, animations: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
