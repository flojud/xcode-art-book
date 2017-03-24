//
//  ViewController.swift
//  Art Book
//
//  Created by Florian Jud on 24.03.17.
//  Copyright © 2017 Florian Jud. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup table view
        tableView.dataSource = self
        tableView.delegate = self
    }


    @IBAction func addButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toCreateVC", sender: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "I've set table view"
        return cell
    }

    
}

