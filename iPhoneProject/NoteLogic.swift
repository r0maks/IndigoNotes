//
//  NoteLogic.swift
//  iPhoneProject
//
//  Created by Román Maksimov on 4/22/17.
//  Copyright © 2017 Román Maksimov. All rights reserved.
//

import Foundation


public class NoteLogic{

    
    func ApplySortingLogicForMainView(notes : [Note]) -> [Note]{
        
        // only get the distinct hashtags?
        return notes;
    }
    
    
    func GetNotesForMainScreen() -> [Note]{
    
        let orderedNotes = NoteRepository.GetNotesPreview();
        
        var distinctTagNotes = [Note]();
        
        for note in orderedNotes{
            
            if(distinctTagNotes.filter{n in n.Tag == note.Tag}.count < 1){
                distinctTagNotes.append(note);
            }else if(distinctTagNotes.filter{n in n.Tag == note.Tag}.count == 1){
                var noteWithThisTag = distinctTagNotes.filter{n in n.Tag == note.Tag}[0];
                noteWithThisTag.Count = noteWithThisTag.Count + 1;
                
            }
        }
        
        return distinctTagNotes;
       
    }
    
    func DisableNote(noteId : Int) -> Bool {
        return NoteRepository.DisableNote(noteId: noteId);
    }
    
    
    func GetNotesForTag(tag: String)-> [Note]{
        return NoteRepository.GetNotesForTag(searchTag:tag);
    }
    
    func GetDistinctTags()-> [String]{
        let orderedNotes = NoteRepository.GetNotesPreview();
        
        var distinctTags = [String]();
        
        for note in orderedNotes{
            
            if(distinctTags.filter{n in n == note.Tag}.count < 1){
                distinctTags.append(note.Tag);
            }
        }
        return distinctTags;
    }
    
    func CreateNote(tag: String, text: String) -> Bool {
        
        if(!ValidateNote(tag: tag, text: text)){
            return false;
        }
        
        let cleanedUpTag = CleanUpTagText(tag: tag);
        
        let tagsToNote = [Int]();
        
//        let allTags = NoteRepository.GetAllTags();
        
        let noteTags = GetAllUniqueHashtagsFromText(text: text);
        
//        for dbTag in allTags {
//            
////            if(allTags.filter{n in TagsMatch(tag1: n, tag2: noteTag)}.count > 0){
////                uniqueTags.append(tag);
////            }
//        
//        }
        
        
        let success = NoteRepository.CreateNote(tagText: cleanedUpTag, bodyText: text);
        
        return success;
    }
    
    func UpdateNote(noteId: Int, tag: String, text: String) -> Bool{
        if(!ValidateNote(tag: tag, text: text)){
            return false;
        }
        
        let cleanedUpTag = CleanUpTagText(tag: tag);
        
        let success = NoteRepository.EditNote(noteId: noteId, tagText: cleanedUpTag, bodyText: text);
        
        return success;
    }
    
    func GetNote(noteId : Int) -> Note{
        return NoteRepository.GetNote(noteId: noteId);
    }
    
    func CleanUpTagText(tag: String) -> String{
        
        //TODO remove special characters and such
        var text = tag.lowercased().trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines);
        
        if(text[0] != "#"){
            text = "#" + text;
        }
        
        return text;
    }
    
    func ValidateNote(tag: String, text: String) -> Bool{
    
        if(text.isEmpty || tag.isEmpty){
            return false;
        }
    
        return true;
    }
    
    
    // returns true for #super and #SuPer
    func TagsMatch(tag1: String, tag2: String) -> Bool{
        
        return (tag1.lowercased().trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == tag2.lowercased().trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines));
        
    }
    
    // get a list of all unique hastags that are in the body of a note
    // they must either be found or created in the database
    func GetAllUniqueHashtagsFromText(text: String) -> [String]{
        let words:[String] = text.separate(withChar: " ");
        let hashtagWords = words.flatMap({$0.separate(withChar: "#")});
        
        var uniqueTags = [String]();
        
        for tag in hashtagWords{
            if(uniqueTags.filter{n in TagsMatch(tag1: n, tag2: tag)}.count < 1){
                uniqueTags.append(tag);
            }
        }
        return uniqueTags;
    }
    
}
