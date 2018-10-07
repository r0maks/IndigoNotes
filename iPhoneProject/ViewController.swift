//
//  ViewController.swift
//  iPhoneProject
//
//  Created by Román Maksimov on 4/20/17.
//  Copyright © 2017 Román Maksimov. All rights reserved.
//

class MainTableCell: UITableViewCell {
    
    @IBOutlet weak var NoteCount: UILabel!
    
    @IBOutlet weak var TextLabel: UILabel!
    
    @IBOutlet weak var TagLabel: UILabel!
}

import UIKit

class ViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    var data = [Note]();
    
    @IBOutlet weak var NoteTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        NoteTable?.dataSource = self
        NoteTable?.delegate = self
        NoteTable.tableFooterView = UIView()
        
        activateAndGetData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    
    func activateAndGetData(){
        let logic = NoteLogic();
        data = logic.GetNotesForMainScreen();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Getting the right element
        let element = data[indexPath.row]
        
        // Instantiate a cell
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MainCell",
            for: indexPath) as! MainTableCell
        
        // Adding the right informations
        cell.TextLabel?.text = element.Body
        cell.TagLabel?.text = element.Tag
        cell.NoteCount?.text = element.Count.description
        
        // Returning the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentViewController(TagViewController.self, arg: data[indexPath.row].Tag)
        
    }
    
}


