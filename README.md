# CS193p-UIKit-Lecture 10

## Lecture Topic
Multithreading and Autolayout

## Objective
1. Fetch images from the network without blocking the UI (using URLSession and DispathQueue).
2. Make concentration UI adopt to portait and landscape orientation (using SizeClasses and varying constraints, vary for traits and viewDidLayoutSubviews) 

1. Top label at each tab ("Mars Awaits, Local Images, Server Images") is changing it's font size and top constraint when the orientation (portrait / landscape) changeds.
2. The buttons for previewing the images are displayed differently when in portrait (4 rows with 1 button) and landscape (2 rows with 2 buttons).
3. The "Curiosity Mission" app has two tabs that display images: Local and Network. The "Local" tab is presenting an image from the assets folder, the "Network" - asynchronously fetches the image data from the network (using the URLSession) and then dispatches to the main queue to update the UI.
4. A spinnig activity indicator was added to notify the user that the selected image is downloading.


## Demo



| Portrait | Landscape |
| :----:   |  :----:  |
|  <video src="https://user-images.githubusercontent.com/87092187/221931759-d81cb55d-af74-4c87-a60d-f8b4c3ba2eae.mov"> |   <video src="https://user-images.githubusercontent.com/87092187/221931685-5855f2bc-810e-45a8-89cc-df7805688c4b.mov"> |





