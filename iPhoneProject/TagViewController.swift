//
//  TagViewController.swift
//  iPhoneProject
//
//  Created by Román Maksimov on 4/22/17.
//  Copyright © 2017 Román Maksimov. All rights reserved.
//

import Foundation
import UIKit

class NoteTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var DateLabel: UILabel!
    
    
    @IBOutlet weak var TitleLabel: UILabel!
}

class TagViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var TagLabel: UILabel!;
    @IBOutlet weak var TableView: UITableView!
    
    public var TagName : String = "";
    public var Notes = [Note]();
    
    override func onInit(arg: Any) {
        TagName = arg as! String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        TagLabel.text = TagName;
        GetData();
        TableView?.dataSource = self
        TableView?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    func GetData(){
        let logic = NoteLogic();
        Notes = logic.GetNotesForTag(tag: TagName);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Notes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Getting the right element
        let element = Notes[indexPath.row];
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath) as! NoteTableViewCell
        
        // Adding the right information
        cell.TitleLabel?.text = element.Body;
        cell.DateLabel?.text = DisplayDateFormatter.string(for: element.CreatedDate);
        
        // Returning the cell
        return cell
    }
    
    // one of the rows selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row: \(indexPath.row)") // index of the data
        
        let storyBoard : UIStoryboard = self.storyboard!;
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController
        nextViewController.EditNote = Notes[indexPath.row];
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        // deleting single notes
        if(editingStyle == UITableViewCellEditingStyle.delete)
        {
            let logic = NoteLogic();
            let success = logic.DisableNote(noteId: Notes[indexPath.row].Id);
            
            if(success){
                
                Notes.remove(at: indexPath.row);
                
                if(Notes.count == 0){
                    let storyBoard : UIStoryboard = self.storyboard!;
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainVewController")
                    self.present(nextViewController, animated:true, completion:nil)
                    
                }else{
                    // reload the view if there is still more data to be shown
                    tableView.reloadData();
                }
            }
        }
    }
    
    // sets the cell height of the table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    @IBAction func NewButton(_ sender: Any) {
        
        let storyBoard : UIStoryboard = self.storyboard!;
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController
        nextViewController.PresetTag = TagName;
        self.present(nextViewController, animated:true, completion:nil)
        
        
        
    }
}
