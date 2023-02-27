# CS193p-UIKit-Lecture 10

## Lecture Topic
Multithreading and Autolayout

## Objective
1. Fetch images from the network without blocking the UI (using URLSession and DispathQueue).
2. Make concentration UI adopt to portait and landscape orientation (using SizeClasses and varying constraints, vary for traits and viewDidLayoutSubviews) 

## Demo
In this homework, I decided to add the functionality from the lecture code to the "Curiosity Mission" app.

1. Top label at each tab ("Mars Awaits, Local Images, Server Images") is changing it's font size and top constraint when the orientation (portrait / landscape) changeds.
2. The buttons for previewing the images are displayed differently when in portrait (4 rows with 1 button) and landscape (2 rows with 2 buttons).
3. 
