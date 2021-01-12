//
//  MainCoordinator.swift
//  ShapeTakeHomeJairo
//
//  Created by Jairo Bambang Oetomo on 10/01/2021.
//

import UIKit

class MainCoordinator: NSObject {
    
    var navigationController: UINavigationController
    var sb: UIStoryboard
    
    init(nav: UINavigationController) {
        self.navigationController = nav
        self.sb = UIStoryboard(name: "Gallery", bundle: nil)
        super.init()
    }
    
    func start() {
        let mainVC = sb.instantiateViewController(identifier: "MainVC") as! MainVC
        mainVC.coordinator = self
        navigationController.pushViewController(mainVC, animated: false)
    }
    
    func didSelectItem(model: ModelData) {
        let detailVC = sb.instantiateViewController(identifier: "DetailVC") as! DetailVC
        detailVC.model = model
        UIView.transition(with: (self.navigationController.view)!, duration: 0.75, options: .transitionFlipFromRight, animations: {
            self.navigationController.pushViewController(detailVC, animated: true)
        })
    }
}
