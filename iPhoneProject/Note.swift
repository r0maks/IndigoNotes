//
//  Note.swift
//  iPhoneProject
//
//  Created by Román Maksimov on 4/20/17.
//  Copyright © 2017 Román Maksimov. All rights reserved.
//

import Foundation


// each note has the plain text note contents, and 1 category for how it will be categorized

class Note {
 
    var Id : Int = 0;
    var Body : String = "";
    var Tag : String = "";
    var CreatedDate : Date = Date.distantPast;
    var Count : Int = 1;
    
}

