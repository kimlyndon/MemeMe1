//
//  MemeMeViewController.swift
//  MemeMe1
//
//  Created by Kim Lyndon on 5/7/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
//Set outlets for imageView and text fields
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    

        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
//Enable buttons
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = imagePickerView.image != nil
            
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFields(textField: topTextField, defaultText: "TOP")
        setTextFields(textField: bottomTextField, defaultText: "BOTTOM")
    }
    
    func setTextFields(textField: UITextField, defaultText: String) {
//Setting the text fields' styles and fonts
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -3]
    
//Set default attributes
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        textField.textAlignment = .center
        textField.text = defaultText

    }
    
//Connect action for the ALBUM button and set delegate
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pick(sourceType: .photoLibrary)
    }
    
    //MARK: Meme Editor
//imagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
    }
        
//Dismiss picker after choice is made
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //Connect action for camera option
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pick(sourceType: .camera)
    }
    
//Initialize meme model object
    func save() {
        _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
//HIDE TOOL AND NAV BAR
        self.navigationController?.navigationBar.isHidden = true
        self.toolbar.isHidden = true
// Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
//SHOW TOOL AND NAV BAR
        self.navigationController?.navigationBar.isHidden = false
        self.toolbar.isHidden = false
        
        return memedImage
    }
    
    func pick(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func shareButtonPressed(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
//Define an instance of activityViewController and pass a memed image as an activity item
        activityViewController.completionWithItemsHandler = {activity, didComplete, items, error in if didComplete {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
    }
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
        
//Top text field would raise screen on occasion when engaged so I checked the forums (https://discussions.udacity.com/t/meme-keyboard-issue/510608/2) and found this solution. Screen only raises when bottom text field engaged now. 
        if textField == bottomTextField {
            subscribeToKeyboardNotifications()
        } else {
            unsubscribeFromKeyboardNotifications()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
    if textField.isEqual(bottomTextField) {
            self.unsubscribeFromKeyboardNotifications()
    }
        return true;
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWllShow(_notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_notification:)), name: .UIKeyboardDidHide, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWllShow(_notification: Notification) {
        view.frame.origin.y = -getKeyboardHeight(_notification: _notification)
    }
    
    func getKeyboardHeight(_notification: Notification) -> CGFloat {
        let userInfo = _notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_notification: Notification) {
        view.frame.origin.y = 0
}
    }

