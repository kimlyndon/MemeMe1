# MemeMe1
## UIKit Fundamentals
### Udacity iOS Devoloper Nanodegree

MemeMe is a meme-generating app that enables a user to attach a caption to a picture from their phone. After adding text to an image chosen from the Photo Album or Camera, the user can share with others.

## Contents
EditorController - consists of an image view and two text fields. User pick photo from the camera or existing photo album.

TableController and CollectionController - displays recently sent memes. User can delete selected image in Table View Controller.

DetailController - displays the selected meme in an image view in the center of the page with the meme’s original image. User can edit the selected memed image as well. 

## Main Development Technique
MVC/Singleton Pattern
ImagePicker Controller
Delegate Pattern for UITextFieldDelegate Protocol


* Text fields need to be clear and have white text with black outline.
* Font needs to be similar to Impact.
* Image needs to raise when bottom text field is initiated for editing to accommodate the keyboard and lower when return key
  is pressed (also dismissing the keyboard). 
* Camera button needs to be disabled when used on a device without a camera. 

## License
MIT License
