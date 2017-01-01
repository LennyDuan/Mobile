//
//  ImageEditViewController.swift
//  ToDo
//
//  Created by 段鸿易 on 12/22/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit

class ImageEditViewController: CommonViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func saveTap(_ sender: Any) {
        saveImgToLibrary()
    }
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    
    // Select Image or Take a photo
    @IBAction func selectImageTap(_ sender: Any) {
        
        let alert = UIAlertController(title: "Related Image", message: "Take a photo or choose image from album library", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let actionAlbum = UIAlertAction(title: "Select From Album", style: UIAlertActionStyle.default, handler: selectAlbum)
        
        let actionCamera = UIAlertAction(title: "Use cemara", style: UIAlertActionStyle.default, handler: takeCamera)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
        self.present(alert, animated: true, completion: nil)
        alert.addAction(actionAlbum)
        alert.addAction(actionCamera)
        alert.addAction(actionCancel)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image  = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    func selectAlbum(action: UIAlertAction) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.photoLibrary)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func takeCamera(action: UIAlertAction) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func saveImgToLibrary() {
        if (imageView.image != nil) {
            let imagedata = UIImagePNGRepresentation(imageView.image!)
            let compressImage = UIImage(data: imagedata!)
            UIImageWriteToSavedPhotosAlbum(compressImage!, nil, nil, nil)
            
            let alert = UIAlertController(title: "Have Saved Image", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            
            let actionCancel = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: nil)
            self.present(alert, animated: true, completion: nil)
            alert.addAction(actionCancel)
        }
    }
}
