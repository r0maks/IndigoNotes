//
//  NoteRepository.swift
//  iPhoneProject
//
//  Created by Román Maksimov on 4/20/17.
//  Copyright © 2017 Román Maksimov. All rights reserved.
//

import Foundation
import SQLite


class NoteRepository{
    
    static let notes = Table("Notes");
    static let tags = Table("Tags")
    static let body = Expression<String>("Body")
    static let id = Expression<Int>("Id")
    static let tag = Expression<String>("Tag")
    static let date = Expression<Date>("Date")
    static let active = Expression<Int>("Active")
    
    
    static func CreateNote(tagText: String, bodyText: String) -> Bool {
        
        do {
            
            let path = getDBPath();
            let db = try Connection(path);
            try db.run(notes.insert(body <- bodyText, tag <- tagText, date <- Date(), active <- 1));
            
            return true;
            
        } catch {
            
//            let alert = UIAlertView();
//            alert.title = "Error";
//            alert.message = error.localizedDescription;
//            alert.show();
//            
            
            return false;
        }
    }
    
    static func EditNote(noteId: Int, tagText: String, bodyText: String) -> Bool {
        
        do {
            
            let path = getDBPath();
            let db = try Connection(path);
            
            let updateNote = notes.filter(id == noteId);
            try db.run(updateNote.update(tag <- tagText, body <- bodyText, date <- Date(), active <- 1));
            
            return true;
            
        } catch {
            return false;
        }
    }
    
    static func GetNotesForTag(searchTag: String) -> [Note]{
        
        let query = notes
            .order(id.desc, id).where(tag == searchTag && active > 0);
        return RunQueryAndGetNotes(query: query);
    }
    
    
    // returns a collection of Notes
    static func GetNotesPreview() -> [Note]{
        return RunQueryAndGetNotes(query: notes
            .order(id.desc, id).where(active > 0));
    }
    
    static func DisableNote(noteId : Int) -> Bool {
        
        
        do {
            let note = notes.filter(id == noteId);
            
            let path = getDBPath();
            let db = try Connection(path);
            try db.run(note.update(active <- 0));
            return true;
            
        } catch {
            return false;
        }
    
    }
    
    static func GetNote(noteId : Int) -> Note{
        let query = notes
            .order(id.desc, id).where(id == noteId);
        return RunQueryAndGetNotes(query: query).first!;
    }
    
    private static func RunQueryAndGetNotes(query : QueryType) -> [Note]{
        
        do {
            
            let path = getDBPath();
            let db = try Connection(path);
            
            var orderedNotes = [Note]();
            
            for note in try db.prepare(query) {
                
                let item = Note();
                item.Body = note[body];
                item.Tag = note[tag];
                item.Id = note[id];
                item.CreatedDate = note[date];
                
                orderedNotes.append(item);
            }
            
            return orderedNotes;
            
        } catch {
            return [Note]();
        }
    
    }
    
    
//    public static func GetAllTags()-> [Tag]{
//        
//        do {
//            
//            let path = getDBPath();
//            let db = try Connection(path);
//            
//            var orderedTags = [Tag]();
//            
//            for tag in try db.prepare(notes
//                .order(id.desc, id)) {
//                
//                let item = Tag();
//                item.Tag = tag[tag];
//                item.Id = tag[id];
//                
//                orderedTags.append(item);
//            }
//            
//            return orderedTags;
//            
//        } catch {
//            return [Tag]();
//        }
//        
//    }
    
    static func copyDatabase() -> String{
        
        let fileManager = FileManager.default;
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0];
        
        let databasePath = documentsDirectory.appendingPathComponent("LocalDatabase4.sqlite")
        
        let defaultDBPath = Bundle.main.path(forResource: "notes", ofType: "sqlite")
        
        do {
            let success = try fileManager.copyItem(atPath: defaultDBPath!, toPath: databasePath.path)
        } catch let error as Error {
//            let alert = UIAlertView();
//            alert.title = "Error";
//            alert.message = error.localizedDescription;
//            alert.show();
        }
        

        return databasePath.path;
    }
    
    
    static func getDBPath()->String
    {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0];
        
        let databasePath = documentsDirectory.appendingPathComponent("LocalDatabase3.sqlite")
        let fileManager = FileManager.default;

        
        if(!fileManager.fileExists(atPath: databasePath.path)){
            return copyDatabase();
        }
        
        return databasePath.path;
    }
    
    
    
}
