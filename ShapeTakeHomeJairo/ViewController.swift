//
//  ViewController.swift
//  ShapeTakeHomeJairo
//
//  Created by Jairo Bambang Oetomo on 10/01/2021.
//

import UIKit
import SceneKit
import GLTFSceneKit


class ViewController: UIViewController {
    
    @IBOutlet weak var scnview: SCNView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var scene: SCNScene
        do {
            let sceneSource = try GLTFSceneSource(path: Bundle.main.path(forResource: "test2", ofType: "glb")!)
          scene = try sceneSource.scene()
        } catch {
          print("\(error.localizedDescription)")
          return
        }
        
        scnview.autoenablesDefaultLighting = true
        
        scnview.scene = scene
    }

}

