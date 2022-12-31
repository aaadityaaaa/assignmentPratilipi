//
//  Object.swift
//  AssignmentPratilipi
//
//  Created by Aaditya Singh on 31/12/22.
//

import Foundation

struct Object: Codable, Identifiable, Hashable {
    var id: String?
    var author: String?
    var width: Int?
    var height: Int?
    var url: String?
    var download_url: String?
}
