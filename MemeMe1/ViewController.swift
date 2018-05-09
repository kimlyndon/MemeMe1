//
//  ViewController.swift
//  MemeMe1
//
//  Created by Kim Lyndon on 5/7/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
//Set outlet for imageView
    @IBOutlet weak var imagePickerView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let cameraButton = UIBarButtonItem()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
//imagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
//Dismiss picker after choice is made
    self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        
//Dismiss picker when user chooses CANCEL
     self.dismiss(animated: true, completion: nil)
        
    }
    
//Connect action for the ALBUM button and set delegate
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
//Distinguish betweeh album and camera
        imagePicker.sourceType = .photoLibrary
        
//Displays screen for user photo choice
        present(imagePicker, animated: true, completion: nil)
        
    }
//Connect action for camera option
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }

    }



