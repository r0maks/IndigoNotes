//
//  NoteViewController.swift
//  iPhoneProject
//
//  Created by Román Maksimov on 4/20/17.
//  Copyright © 2017 Román Maksimov. All rights reserved.
//

import Foundation;
import UIKit;
import SQLite;
import SearchTextField;

class NoteViewController: BaseViewController, UITextViewDelegate {
    
    @IBOutlet weak var NoteContents: UITextView!
    @IBOutlet weak var NoteTag: SearchTextField!
    
    public var PresetTag : String = "";
    public var search : String = "";
    public var isEditMode : Bool = false;
    public var EditNote : Note? = nil;
    
    public let logic = NoteLogic();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.NoteContents.delegate = self;
        
        if(EditNote !== nil){
            isEditMode = true;
            
            NoteTag.text = EditNote?.Tag;
            NoteContents.text = EditNote?.Body;
            PresetTag = (EditNote?.Tag)!;
            self.NoteContents.becomeFirstResponder();
            
        }else {
            if(PresetTag == ""){
                NoteTag.text = "#";
                self.NoteTag.becomeFirstResponder();
            }else {
                NoteTag.text = PresetTag;
                self.NoteContents.becomeFirstResponder();
            }
        }
        
        
        // set up data for the dropdown
        let allTags = logic.GetDistinctTags();
        NoteTag.filterStrings(allTags);
        textViewDidChange(NoteContents);
    }
    
    
    @IBAction func NoteSave(_ sender: Any) {
        
        // call the repository to save the new notes file
        var success = false;
        
        if(isEditMode){
            success = logic.UpdateNote(noteId: (EditNote?.Id)!, tag: NoteTag.text!, text: NoteContents.text);
        }else {
            success = logic.CreateNote(tag: NoteTag.text!, text: NoteContents.text);
        }


        if(success == true){
            // go back to the list and refresh it
            let storyBoard : UIStoryboard = self.storyboard!;
            
            if(PresetTag != "" && NoteTag.text == PresetTag){
                presentViewController(TagViewController.self, arg: PresetTag)
            }
            else {
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainVewController")
                self.present(nextViewController, animated:true, completion:nil)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let inValidCharacterSet = NSCharacterSet.whitespaces;
        guard let firstChar = string.unicodeScalars.first else {return true}
        return !inValidCharacterSet.contains(firstChar)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.attributedText = resolveHashTags(text: textView.text)
        textView.linkTextAttributes = [NSForegroundColorAttributeName : UIColor.red]
    }
    
    func resolveHashTags(text : String) -> NSAttributedString{
        var length : Int = 0
        let text:String = text
        let words:[String] = text.separate(withChar: " ")
        let hashtagWords = words.flatMap({$0.separate(withChar: "#")})
        let attrs = [NSFontAttributeName : UIFont.systemFont(ofSize: 17.0)]
        let attrString = NSMutableAttributedString(string: text, attributes:attrs)
        for word in hashtagWords {
            if word.hasPrefix("#") {
                let matchRange:NSRange = NSMakeRange(length, word.characters.count)
                let stringifiedWord:String = word
                
                attrString.addAttribute(NSLinkAttributeName, value: "hash:\(stringifiedWord)", range: matchRange)
            }
            length += word.characters.count
        }
        return attrString
    }
}
