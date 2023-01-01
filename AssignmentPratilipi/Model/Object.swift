//
//  Object.swift
//  AssignmentPratilipi
//
//  Created by Aaditya Singh on 31/12/22.
//

import Foundation

struct Object2: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var tagline: String
    var imageUrl: String
}
