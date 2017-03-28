//
//  createVC.swift
//  Art Book
//
//  Created by Florian Jud on 24.03.17.
//  Copyright © 2017 Florian Jud. All rights reserved.
//

import UIKit
import CoreData

class createVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    
    var chosenPainting = ""
    
    //Bei Klick auf das Bild soll ein Foto hochgeladen werden können
    override func viewDidLoad() {
        super.viewDidLoad()

        if chosenPainting != "" {
            //Abfrage nach ausgewählten Bild in der Datenbank
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            fetchRequest.predicate = NSPredicate(format: "name = %@", self.chosenPainting)
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(fetchRequest)
                if results.count > 0{
                    for result in results as! [NSManagedObject]{
                        if let name = result.value(forKey: "name") as? String{
                            nameText.text = name
                        }
                        
                        if let year = result.value(forKey: "year") as? Int{
                            yearText.text = String(year)
                        }
                        
                        if let artist = result.value(forKey: "artist") as? String{
                            artistText.text = artist
                        }
                        if let imageData = result.value(forKey: "image") as? Data{
                            let image = UIImage(data: imageData)
                            self.imageView.image = image
                        }
                    }
                }
                
            }catch{
                print("An error occoured")
            }
        }else{
            //Wenn man einfach nur auf Add klickt sollen alle Werte leer sein
            imageView.image = UIImage(named: "tapme.png")
            nameText.text = ""
            yearText.text = ""
            artistText.text = ""
        }
        
        
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
    
    //Wenn auf den Speichern Button geklickt wwurde in Datenbank speichern
    @IBAction func saveButtonClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newArt = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        newArt.setValue(nameText.text, forKey: "name")
        newArt.setValue(artistText.text, forKey: "artist")
        if let year = Int(yearText.text!) {
          newArt.setValue(year, forKey: "year")
        }
        else{
            newArt.setValue(0, forKey: "year")
        }
        
        let data = UIImageJPEGRepresentation(imageView.image!, 0.5)
        newArt.setValue(data, forKey: "image")
        
        do{
            try context.save()
            print("we managed  to save it successfully")
        }catch{
            print("error")
        }
        
        //Und dann zurück auf den Hauptbildschrim wechseln
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "paintingCreated"), object: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }

}
