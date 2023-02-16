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
    @IBOutlet private weak var matchStatusLabel: UILabel!
    @IBOutlet private weak var cardsLeftLabel: UILabel!
    @IBOutlet private weak var startNewGameButton: UIButton!
    @IBOutlet weak var cardsStackView: UIStackView!
    
    @IBAction private func showMoreCardsTapped(_ sender: UIButton) {
        game.addMoreCards()
        updateGameUIFromModel()
    }
    
    @IBAction private func startNewGameTapped(_ sender: UIButton) {
        game = SetGame()
        updateGameUIFromModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultAppearanceForUI()
        updateGameUIFromModel()
        cardsStackView.backgroundColor = .clear
    }
    
    private var game = SetGame()
    private var canSelect: Bool = true
}

//Programmatic UI
private extension ViewController {
    func setDefaultAppearanceForUI() {
        //Setting corner radius and shadow for bottom buttons
        showMoreCardsButton.layer.cornerRadius = 12
        startNewGameButton.layer.cornerRadius = 12
        
        //Setting corner radius for top labels
        matchStatusLabel.layer.cornerRadius = 8
        currentScoreLabel.layer.cornerRadius = 8
        
        //Setting corner radius for cards left label
        cardsLeftLabel.layer.cornerRadius = 8
    }
    
    func updateGameUIFromModel() {
        //Updating labels
        cardsLeftLabel.text = "Cards: \(game.cardsLeftCount)"
        currentScoreLabel.text = "Score: \(game.currentGameScore)"
        
        //Updating controls
        showMoreCardsButton.isEnabled = game.canDealMoreCards
        
        //Updating matchLabel
        matchStatusLabel.text = game.currentGameStatus.rawValue
        matchStatusLabel.isHidden = game.currentGameStatus == .unmatched
        if !game.hasStarted {
            matchStatusLabel.isHidden = false
        }
        
        //Updating cards
        updateDisplayedCardsFromModel()
    }
    
    func updateDisplayedCardsFromModel() {
        cardsStackView.subviews.forEach({ $0.removeFromSuperview() })
       
        for cardIndices in cardIndicesForEachRow {
            addHorizontalStackViewOfCards(withIndices: cardIndices)
        }
    }
    
    var cardCountInOneRow: Int {
        let displayedCardsCount = game.displayedCards.count
        
        if displayedCardsCount < 30 {
            let numberAsDouble = game.displayedCards.count / 5
            return Int(numberAsDouble)
        } else if displayedCardsCount < 50 {
            let numberAsDouble = game.displayedCards.count / 7
            return Int(numberAsDouble)
        } else {
            let numberAsDouble = game.displayedCards.count / 8
            return Int(numberAsDouble)
        }
    }
    
    var totalRowsOfCardsCount: Int {
        let displayedCardsCount = game.displayedCards.count
        let extraCardsCount = displayedCardsCount % cardCountInOneRow
        let fullRowsCount = game.displayedCards.count / cardCountInOneRow
        
        if extraCardsCount == 0 { return fullRowsCount }
        else { return fullRowsCount + 1 }
    }
    
    var cardIndicesForEachRow: [[Int]] {
        let allCardsCount = 0..<totalRowsOfCardsCount * cardCountInOneRow
        var rowsOfIndices = [[Int]]()
        
        for displayedCardIndex in allCardsCount.indices {
            if let lastRow = rowsOfIndices.last, lastRow.count < cardCountInOneRow, let lastRowIndex = rowsOfIndices.firstIndex(of: lastRow) {
                rowsOfIndices[lastRowIndex].append(displayedCardIndex)
            } else {
                rowsOfIndices.append([displayedCardIndex])
            }
        }
        
        return rowsOfIndices
    }
    
    func addHorizontalStackViewOfCards(withIndices cardIndices: [Int]) {
        //Stack View attributes
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        stackView.spacing = 6
        cardsStackView.spacing = 10
        cardsStackView.addArrangedSubview(stackView)

        //Adding cards to the stackView
        for cardIndex in cardIndices {
            let card = SetCardView()
            if game.displayedCards.indices.contains(cardIndex) {
                let cardData = game.displayedCards[cardIndex]
                card.setup(for: cardData, isSelected: game.selectedCardIndices.contains(cardIndex))
                
                //Adding tap gesture to card
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCard(_:)))
                card.addGestureRecognizer(tapGestureRecognizer)
            } else {
                card.alpha = 0
            }
            stackView.addArrangedSubview(card)
        }
    }
    
    @objc func didTapCard(_ sender: UITapGestureRecognizer) {
        guard let cardView = sender.view as? SetCardView else { return }
        if let cardData = cardView.getCardData() {
            guard let indexOfSender = game.displayedCards.firstIndex(of: cardData) else { return }
            game.selectCard(at: indexOfSender)
            updateGameUIFromModel()
            
            //Timer
            if !(game.currentGameStatus == .unmatched) {
                canSelect = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.game.replaceSelectedCards()
                    self.updateGameUIFromModel()
                    self.canSelect = true
                }
            }
        }
    }
}
