//
//  MediaFile.swift
//  TestMediaDropBox
//
//  Created by Igor Palyvoda on 29.08.2023.
//

import UIKit

struct MediaFile {
    let id: String?
    let name: String?
    let path: String?
    let lastChanges: Date?
    let imageCache = NSCache<NSString, UIImage>()
}
