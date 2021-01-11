//
//  MainCoordinator.swift
//  ShapeTakeHomeJairo
//
//  Created by Jairo Bambang Oetomo on 10/01/2021.
//

import UIKit

class MainCoordinator: NSObject {
    
    var navigationController: UINavigationController
    
    init(nav: UINavigationController) {
        self.navigationController = nav
        super.init()
    }
    
    func start() {
        let sb = UIStoryboard(name: "Gallery", bundle: nil)
        let mainVC = sb.instantiateViewController(identifier: "MainVC") as! MainVC
        navigationController.pushViewController(mainVC, animated: false)
    }
}
