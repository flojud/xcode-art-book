//
//  createVC.swift
//  Art Book
//
//  Created by Florian Jud on 24.03.17.
//  Copyright © 2017 Florian Jud. All rights reserved.
//

import UIKit

class createVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    
    //Bei Klick auf das Bild soll ein Foto hochgeladen werden können
    override func viewDidLoad() {
        super.viewDidLoad()

        //Bild Gestensteuereung Aktivierung
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(createVC.selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    //selecting Image from library
    func selectImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType =  .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }

    //Was soll passieren, wenn ein Photo ausgewählt wurde
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
    }

}
