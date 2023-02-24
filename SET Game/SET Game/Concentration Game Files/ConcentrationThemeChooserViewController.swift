//
//  ConcentrationThemeChooserViewController.swift
//  SET Game
//
//  Created by Максим Митрофанов on 24.02.2023.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController {
    let themes: [String:ConcentrationGameTheme] = ["Characters" : .characters, "Fruits" : .fruits, "Vegetables" : .vegetables, "Junk Food" : .junkFood, "Vehicles" : .vehicles]
        
    @IBOutlet var themeButtons: [UIButton]!
    
    @IBAction func chooseThemeButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "Choose Theme", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        themeButtons.forEach {
            $0.layer.cornerRadius = 12
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let button = sender as? UIButton, let buttonTitle = button.currentTitle, let theme = themes[buttonTitle] {
                if let cvc = segue.destination as? ConcentrationGameViewController {
                    cvc.chooseNewTheme(theme)
                }
            }
        }
    }
}
