//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Максим Митрофанов on 18.02.2023.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    
    let themes = [
        "Sports" : ["⚽️","🏀","🏈","⚾️","🥎","🎾","🏐","🏉","🥏","🎱","🪀","🏓"],
        "Animals" : ["🐶", "🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐻‍❄️","🐨","🐯","🦁"],
        "Helloween" : ["🦇","🕸️","🕷️","🧟‍♀️","🧙‍♂️","🧝‍♀️","🧌","🧛‍♀️","🧞‍♀️","🦹"]
    ]
    
    @IBAction func changeTheme(_ sender: Any) {
        performSegue(withIdentifier: "Choose Theme", sender: sender)
    }
    
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }

    override func awakeFromNib() {
        splitViewController?.delegate = self
        splitViewController?.preferredDisplayMode = .allVisible
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let buttonTitle = (sender as? UIButton)?.currentTitle, let theme = themes[buttonTitle] {
                if let navigationController = segue.destination as? UINavigationController,
                    let concentrationVC = navigationController.topViewController as? ConcentrationViewController {
                    concentrationVC.theme = theme
                }
            }
        }
    }
}
