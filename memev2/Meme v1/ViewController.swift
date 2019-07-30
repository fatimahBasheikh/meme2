//
//  ViewController.swift
//  Meme v1
//
//  Created by fatoom on 8/5/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate,  UITextFieldDelegate {
    
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var top: UITextField!
    @IBOutlet weak var bottom: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor:UIColor.black ,
        NSAttributedString.Key.foregroundColor:UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
 NSAttributedString.Key.strokeWidth:-4.5
    ]
    
    func setupTextFieldStyle(toTextField : UITextField, text: String, delegate: UITextFieldDelegate, attributes: [NSAttributedString.Key : Any], alignment: NSTextAlignment)  {
        toTextField.text = text
        toTextField.delegate = delegate
        toTextField.defaultTextAttributes = attributes
        toTextField.textAlignment = alignment
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFieldStyle(toTextField: top,text: "TOP", delegate: self, attributes: memeTextAttributes, alignment: NSTextAlignment.center)
         setupTextFieldStyle(toTextField: bottom,text: "BOTTOM", delegate: self, attributes: memeTextAttributes, alignment: NSTextAlignment.center)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

        
   
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        if textField == top{
            top.text = ""
        }
       else if (textField == bottom) {
      self.bottom.text = ""
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       
       subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        top.resignFirstResponder()
        bottom.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottom.isFirstResponder {
        view.frame.origin.y = -getKeyboardHeight(notification)
        }
        
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    
    @IBAction func share(_ sender: Any) {
        let memeImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activity, completed, items, error in
             if completed {
            self.save()
                self.dismiss(animated: true, completion: nil)}
            
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    
    func save() {
        // Create the meme
        let memeImage = generateMemedImage()
        let meme = Meme (top: top.text!, bottom: bottom.text!,image: imagePickerView.image!, memeImage: memeImage)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
       
    }
    
    

    func generateMemedImage() -> UIImage {

        // TODO: Hide toolbar and navbar
          hideToolbars(hide)
      

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()

        // TODO: Show toolbar and navbar
        hideToolbars(!hide)
        
        

        
        return memeImage
    }
    var hide = true
    func hideToolbars(_ hide: Bool) {
        toolBar.isHidden = hide
        navBar.isHidden = hide
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


    
    func openImagePicker(_ type: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        present(picker, animated: true, completion: nil)
    }
    
   
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        
        openImagePicker(.photoLibrary)
    }
    
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        
        openImagePicker(.camera)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        self.dismiss(animated: true, completion: nil)
}
    
}

