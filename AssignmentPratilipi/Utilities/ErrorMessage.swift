//
//  ErrorMessage.swift
//  AssignmentPratilipi
//
//  Created by Aaditya Singh on 31/12/22.
//

import Foundation


import Foundation

enum ErrorMessage: String, Error {
    
    case unableToCompleteRequest = "There was a problem with the request. check yout internet"
    case invalidResponse = "Invalid request"
    case invalidData = "The data received was invalid please try again"
   
    
}
