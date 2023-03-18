# Assignment 5 - Image Gallery
Table Views and Collection Views, Drag and Drop functionality, Multithreading, Scroll Views, Text Fields, Gesture Recognizers, Navigation Controllers, Segues, Split view controllers

## Objective 
The objective of the Assignment V is to create an iPad application centered on a Collection View that allows users to create, edit and delete "Image Galleries" made up of images dragged in via Drag and Drop. The app must meet certain requirements, such as multithreading, allowing users to rearrange items via Drag and Drop, and implementing swipe to delete and undelete Image Galleries. It must also have a Split View Controller with a Table View that lets users choose an Image Gallery by name, and a pinch gesture on the Collection View that scales the width of the cells. Additionally, when a user taps on a cell in the Collection View, they should be able to zoom in and out to examine the image in detail in a scroll view that fills the entire MVC.

## Required Tasks (short)
- Create an app that uses a Collection View to display an Image Gallery.
- Only allow dropping of items with a UIImage representation and a URL representation.
- Enable rearranging items in the Collection View with Drag and Drop.
- Fetching URLs must be done off the main thread.
- Display an activity indicator while fetching an image from its URL.
- Don't cache images, fetch them from their URL each time needed.
- Add a Split View Controller with a Table View that allows users to select an Image Gallery by name.
- Implement swipe to delete Image Galleries, move them to a "Recently Deleted" section, and permanently delete from there.
- Implement swipe in the other direction to undelete Image Galleries from the "Recently Deleted" section.
- Allow users to double-tap on an Image Gallery in the Table View to edit its name with a UITextField.
- Segue to a new MVC when a user taps on a cell in the Collection View to present the image in a scroll view that fills the entire MVC.
- Image Galleries don't have to persist between runs of the application.
- The Table View is allowed to have no selection even if editing an Image Gallery in the Collection View.

<br>

## TabView

https://user-images.githubusercontent.com/87092187/225937754-9a54954e-fb81-4bb3-ba3a-04a778d39087.mp4

<br>

## CollectionView

https://user-images.githubusercontent.com/87092187/225937814-b615acaf-8d07-4954-8ae1-283bae6f1874.mp4

<br>

## Drag & Drop

https://user-images.githubusercontent.com/87092187/225937834-c79af5da-41b0-413e-b101-be160d80da25.mp4

