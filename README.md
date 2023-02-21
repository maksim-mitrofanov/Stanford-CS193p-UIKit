# CS193p-UIKit-Asignment 4

## Objectective
Adding more functionality and refactoring an app that was made in [Assignment-3](https://github.com/maksim-mitrofanov/CS193p-UIKit/tree/Assignment-2).
In this assignment you will add animation to your Set game and combine your first three assignments into one.

1. Your application should continue to play a solo game of Set as required by Assignment 3 (with the caveats below).
2. You must animate the following actions in your set game:
  <br>  a. the rearrangement of cards. when cards are added or disappear from the game the cards should move smoothly (not jump instantly) to their new positions.
 <br>   b. the dealing of new cards. this includes both the initial 12 cards and any time 3 new cards are dealt. cards should fly across the screen from some “deck” somewhere on screen. the appearance of the deck is up to you. no two cards should be dealt at the same time though their animations can overlap a bit.
 <br>   c. the discovery of a match. matched cards should all fly away from where they were at the same time and bounce around on the screen for a couple of seconds before snapping to some “discard pile” somewhere on screen. the appearance of the discard pile is up to you.
 <br>   d. the flipping over of cards. cards should be dealt face down until they are in position, then they should be flipped over to reveal the set card contents and after cards have flown away to the discard pile, at least the top card on the discard pile should be flipped face down.
3. Your animation implementation must use UIViewPropertyAnimator, UIDynamicAnimator, and the UIView class method transition(with:...). You will probably also need a Timer, but it’s not strictly required.
4. Instead of using a swipe gesture to deal 3 more cards, allow users to deal 3 more cards by tapping on your deck.
5. Automatically perform a “deal 3 more cards” (i.e. simulate tapping on the deck) whenever a match is revealed.
6. You are not required to support your “rearrange cards” rotation gesture from the last assignment (see Extra Credit).
7. Add a theme-choosing MVC to your Concentration game in the same way that a theme chooser was added to Concentration in Lecture 7. This Required Task is essentially to reproduce Lecture 7, however, you’ll be using your own Concentration (not the demo one) including your theme code. You are allowed to modify your Assignment 1 code if necessary. The point of this Required Task is to show us that you can do what was done with Multiple MVCs in the Lecture 7 demo.
8. Combine the above Set and Concentration games into a single application using a tab bar controller. This is the application you will submit.

## Things to Learn
1. UIViewPropertyAnimator
2. UIDynamicAnimator
3. Timer
4. UIView.transition(with:duration:options:animations:completion:) 5. UINavigationController
6. UISplitViewController 7. UITabBarController
8. Segues
9. Autolayout 

## Demo
https://user-images.githubusercontent.com/87092187/219384076-c9c160b9-9742-4d70-bce3-c8fbd5daec37.mp4



