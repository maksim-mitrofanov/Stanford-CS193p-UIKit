//
//  SetGameViewController.swift
//  SET Game
//
//  Created by Максим Митрофанов on 06.02.2023.
//

import UIKit

class SetGameViewController: UIViewController {
    @IBOutlet private weak var currentScoreLabel: UILabel!
    @IBOutlet private weak var showMoreCardsButton: UIButton!
    @IBOutlet private weak var matchStatusLabel: UILabel!
    @IBOutlet private weak var cardsLeftLabel: UILabel!
    @IBOutlet private weak var startNewGameButton: UIButton!
    @IBOutlet private weak var cardsStackView: UIStackView!
    @IBOutlet private weak var bottomButtonsStackView: UIStackView!
    
    @IBAction private func showMoreCardsTapped(_ sender: UIButton) {
        game.addMoreCards()
        updateGameAppearance()
    }
    
    @IBAction private func startNewGameTapped(_ sender: UIButton) {
        game = SetGame()
        cardsStackView.subviews.forEach { $0.removeFromSuperview() }
        updateGameAppearance()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaultAppearance()
    }
    
    private var game = SetGame()
    private var canSelect: Bool = true
}

//Programmatic UI
extension SetGameViewController {
    private func setupDefaultAppearance() {
        showMoreCardsButton.layer.cornerRadius = 8
        startNewGameButton.layer.cornerRadius = 8
        
        matchStatusLabel.layer.cornerRadius = 8
        currentScoreLabel.layer.cornerRadius = 8
        
        cardsLeftLabel.layer.cornerRadius = 8
        cardsStackView.backgroundColor = .clear
        
        updateLabelsAndControlsAppearance()
        updateDisplayedCardsAppearance()
    }
    
    private func updateLabelsAndControlsAppearance() {
        cardsLeftLabel.text = "Cards: \(game.cardsLeftCount)"
        currentScoreLabel.text = "Score: \(game.currentGameScore)"
        
        showMoreCardsButton.isEnabled = game.canDealMoreCards
    }
    
    private func updateDisplayedCardsAppearance() {
        if cardsStackView.subviews.count == totalRowsOfCardsCount - 1 {
            if let indices = cardIndicesForEachRow.last {
                UIView.transition(with: cardsStackView, duration: 1, options: [.transitionFlipFromLeft]) {
                    self.addHorizontalStackViewOfCards(withIndices: indices)
                }
            }
            
        } else if cardsStackView.subviews.count == 0 {
            UIView.transition(with: cardsStackView, duration: 1, options: [.transitionFlipFromTop]) {
                for cardIndices in self.cardIndicesForEachRow {
                    self.addHorizontalStackViewOfCards(withIndices: cardIndices)
                }
            }
        }
        
        else if cardsStackView.subviews.count > totalRowsOfCardsCount {
            cardsStackView.subviews.forEach { $0.removeFromSuperview() }

            for cardIndices in self.cardIndicesForEachRow {
                self.addHorizontalStackViewOfCards(withIndices: cardIndices)
            }
        }
        
        else {
            updateSelectedAndReplacedCardsAppearance()
        }
    }
    
    private func updateMatchStatusLabelAppearance() {
        //Flip when state changes
        if matchStatusLabel.text != game.currentGameStatus.rawValue {
            if game.currentGameStatus != .unmatched {
                matchStatusLabel.text = game.currentGameStatus.rawValue
            } else {
                UIView.transition(with: matchStatusLabel, duration: 1, options: [.transitionFlipFromTop]) {
                    self.matchStatusLabel.text = self.game.currentGameStatus.rawValue
                }
            }
        }
        
        //Scaling and opacity
        if game.selectedCardIndices.count == 1 || game.selectedCardIndices.count == 3 {
            let isMatchLabelHidden: Bool = {
                return game.selectedCardIndices.count > 0 && game.selectedCardIndices.count < 3
            }()
            
            if game.currentGameStatus == .unmatched {
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
                    self.matchStatusLabel.alpha = isMatchLabelHidden ? 0 : 1
                    self.matchStatusLabel.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
                }
                
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
                    self.matchStatusLabel.isHidden = true
                }
                
            } else {
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
                    self.matchStatusLabel.alpha = isMatchLabelHidden ? 0 : 1
                    self.matchStatusLabel.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
                    self.matchStatusLabel.isHidden = false
                }
            }
        }
    }
    
    private func updateGameAppearance() {
        updateLabelsAndControlsAppearance()
        updateDisplayedCardsAppearance()
        updateMatchStatusLabelAppearance()
    }
}

//Cards UI
private extension SetGameViewController {
    var cardCountInOneRow: Int {
        return 3
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
        stackView.spacing = 10
        cardsStackView.spacing = 12
        cardsStackView.addArrangedSubview(stackView)

        //Adding cards to the stackView
        for cardIndex in cardIndices {
            let card = SetCardView()
            if game.displayedCards.indices.contains(cardIndex) {
                let cardData = game.displayedCards[cardIndex]
                card.setup(for: cardData, isSelected: self.game.selectedCardIndices.contains(cardIndex))
                
                //Adding tap gesture to card
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCard(_:)))
                card.addGestureRecognizer(tapGestureRecognizer)
            } else {
                card.alpha = 0
            }
            stackView.addArrangedSubview(card)
        }
    }
    
    func updateSelectedAndReplacedCardsAppearance() {
        let stackViewIndices = cardsStackView.subviews.indices
        let cardIndicesForEachRow = cardIndicesForEachRow
        
        for stackViewIndex in stackViewIndices {
            for subviewIndex in cardsStackView.subviews[stackViewIndex].subviews.indices {
                if let cardSubView = cardsStackView.subviews[stackViewIndex].subviews[subviewIndex] as? SetCardView {
                    if cardIndicesForEachRow.count > stackViewIndex {
                        if  cardIndicesForEachRow[stackViewIndex].count > subviewIndex {
                            let cardDataIndex = cardIndicesForEachRow[stackViewIndex][subviewIndex]
                            let cardDataFromModel = game.displayedCards[cardDataIndex]
                            let isCardSelected = game.selectedCardIndices.contains(cardDataIndex)
                            
                            if cardSubView.cardData != cardDataFromModel || cardSubView.isSelected != isCardSelected {
                                cardSubView.setup(for: game.displayedCards[cardDataIndex], isSelected: self.game.selectedCardIndices.contains(cardDataIndex))
                                
                                UIView.transition(with: cardsStackView.subviews[stackViewIndex].subviews[subviewIndex], duration: 0.5, options: [.transitionCrossDissolve], animations: {
                                    self.cardsStackView.subviews[stackViewIndex].insertSubview(cardSubView, at: subviewIndex)
                                })
                            }
                        }
                    }
                }
            }
        }
    }
}

//objc methods
extension SetGameViewController {
    @objc func didTapCard(_ sender: UITapGestureRecognizer) {
        guard let cardView = sender.view as? SetCardView else { return }
        if let cardData = cardView.getCardData() {
            guard let indexOfSender = game.displayedCards.firstIndex(of: cardData) else { return }
            self.game.selectCard(at: indexOfSender)
            
            //Timer
            if !(game.currentGameStatus == .unmatched) {
                canSelect = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.game.replaceSelectedCards()
                    self.updateGameAppearance()
                    self.canSelect = true
                }
            }
        }
        updateGameAppearance()
    }
}
