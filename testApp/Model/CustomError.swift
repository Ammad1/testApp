//
//  CustomError.swift
//  testApp
//
//  Created by Ammad Tariq on 18/10/2021.
//

import Foundation

struct CustomError: Error {
    
    var errorCode: Int?
    var errorMessage: String = ""
    
    init(code: Int? = nil, message: String = "" ) {
        errorCode = code
        errorMessage = message
    }
}
