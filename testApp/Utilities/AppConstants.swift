//
//  Constants.swift
//  testApp
//
//  Created by Ammad Tariq on 03/10/2021.
//

import Foundation

class AppConstants {
    
    struct Identifier {
        static let MainControllerCell = "UserListTableViewCell"
        static let UserDetailsViewController = "UserDetailsViewController"
        static let Main = "Main"
    }
    
    struct Message {
        static let unavailable = "-- Unavailable --"
        static let pleaseWait = "Please Wait..!!"
        static let somethingWrong = "Something Went Wrong"
        static let error = "Error"
        static let save = "Save"
        static let addNotesPlaceholder = "Add Notes Here..."
        static let success = "Success"
        static let notesUpdated = "Notes Updated Successfully"
    }
    
    struct Url {
        static let baseURL = "https://api.github.com"
        static let users = baseURL + "/users"
        
    }
}
