//
//  ViewController.swift
//  SET Game
//
//  Created by Максим Митрофанов on 06.02.2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var currentScoreLabel: UILabel!
    @IBOutlet private weak var showMoreCardsButton: UIButton!
    @IBOutlet private weak var startNewGameButton: UIButton!
    @IBOutlet private weak var extraButton: UIButton!
    @IBOutlet private var gameCards: [UIButton]!
    
    private var selectedCardIndex = 0
    
    @IBAction private func showMoreCardsTapped(_ sender: UIButton) {
    }
    @IBAction private func startNewGameTapped(_ sender: UIButton) {
        let game = SetGame()
    }
    @IBAction func gameCardTapped(_ sender: UIButton) {
        updateCards()
        if selectedCardIndex < gameCards.count - 1 {
            selectedCardIndex += 1
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideLastButton()
    }
}

extension ViewController {
    private func updateCards() {
        for cardIndex in 0...selectedCardIndex {
            gameCards[cardIndex].backgroundColor = .black
        }
    }
    
    private func hideLastButton() {
        extraButton.alpha = 0
    }
}

