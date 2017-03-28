//
//  ViewController.swift
//  Art Book
//
//  Created by Florian Jud on 24.03.17.
//  Copyright © 2017 Florian Jud. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = [String]()
    var yearArray = [Int]()
    var artistArray = [String]()
    var imageArray = [UIImage]()
    var selectedPainting = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //setup table view
        tableView.dataSource = self
        tableView.delegate = self
        
        
        //Hole die Daten aus der Datenbank
        retrieveInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.retrieveInfo), name: NSNotification.Name("paintingCreated"), object: nil)
    }
    
    //Hole die Daten aus der Datenbank
    func retrieveInfo(){
        
        self.nameArray.removeAll(keepingCapacity: false)
        self.yearArray.removeAll(keepingCapacity: false)
        self.artistArray.removeAll(keepingCapacity: false)
        self.imageArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(fetchRequest)
            if results.count > 0{
                for result in results as! [NSManagedObject]{
                    if let name = result.value(forKey: "name") as? String{
                        self.nameArray.append(name)
                    }
                    if let year = result.value(forKey: "year") as? Int{
                        self.yearArray.append(year)
                    }
                    if let artist = result.value(forKey: "artist") as? String{
                        self.artistArray.append(artist)
                    }
                    if let imageData = result.value(forKey: "image") as? Data{
                        let image = UIImage(data: imageData)
                        self.imageArray.append(image!)
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }catch{
            print("There was an error")
            
        }
    }


    //Anzahl der Zeilen in der Tabelle
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    //Fülle die Tabelle mit den Werten aus der Datenbank
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }

    
    //Prepare Segue - Übergebe Variablen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateVC"{
            let destinationVC =  segue.destination as! createVC
            destinationVC.chosenPainting =  selectedPainting
        }
    }
    
    //Perform Segue - Add Button
    @IBAction func addButtonClicked(_ sender: Any) {
        self.selectedPainting = ""
        performSegue(withIdentifier: "toCreateVC", sender: nil)
    }
    
    //Perform Segue - Bei Auswahl eines Elementes in der Liste
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPainting = nameArray[indexPath.row]
        performSegue(withIdentifier: "toCreateVC", sender: nil)
    }
    
    
    
}

