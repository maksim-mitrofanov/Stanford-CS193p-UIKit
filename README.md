# CS193p-UIKit-Asignment 3

## Objectective
Adding more functionality and refactoring an app that was made in [Assignment-2](https://github.com/maksim-mitrofanov/CS193p-UIKit/tree/Assignment-2).

1. Your application should continue to play a solo game of Set as required by Assignment 2.
2. In this version, however, you are not to limit the user-interface to a fixed number of cards. You should always be prepared to Deal 3 More Cards. The only time the Deal 3 More Cards button will be disabled is if there are no more cards left in the deck.
3. Do not “pre-allocate” space for all 81 possible cards. At any given time, cards should be as large as possible given the screen real estate available to cards and the number of cards currently in play. In other words, when the game starts (with only 12 cards), the cards will be pretty big, but as more and more cards appear on screen (due to Deal 3 More Cards), they will have to get smaller and smaller to fit.
4. Towards the end of the game, when 3 cards are matched and there are no more cards in the Set deck, the matching cards should be removed from the screen entirely and the remaining cards should “re-form up” to use the space freed up by these departing cards (i.e. getting a bit larger again if space allows).
5. Cards must have a “standard” look and feel (i.e. 1, 2 or 3 squiggles, diamonds or ovals that are solid, striped or unfilled and are either green, red or purple). You must draw them using UIBezierPath and/or CoreGraphics functions. You may not use attributed strings nor UIImages to draw your cards.
6. Whatever way you draw your cards must scale with the size of the card (obviously, to support Required Task 3).
7. On cards that have more than one symbol, you are allowed to draw the symbols on horizontally across or vertically down (or even have that depend on the aspect ratio of the card at the time it is being drawn).
8. A tap gesture on a card should select/deselect it.
9. A swipe down gesture in your game should Deal 3 More Cards.
10. Add a rotation gesture (two fingers rotating like turning a knob) to cause all of your cards to randomly reshuffle (it’s useful when the user is “stuck” and can’t find a Set). This might require a modification to your Model.
11. Your game must work properly and look good in both Landscape and Portrait orientations on all iPhones and iPads. It should efficiently use all the space available to it in all circumstances. 

## Things to Learn
1. Creating a custom UIView with a draw(CGRect) method
2. Gestures
3. Understanding the UIView hierarchy
4. Creating UIViews in code (rather than in Interface Builder)
5. Drawing with Core Graphics and UIBezierPath 

