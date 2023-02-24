//
//  SmoothTabBarController.swift
//  SET Game
//
//  Created by Максим Митрофанов on 24.02.2023.
//

import UIKit

class SmoothTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

extension SmoothTabBarController: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
          return false // Make sure you want this as false
        }

        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 1, options: [.transitionFlipFromLeft], completion: nil)
        }

        return true
    }
}
