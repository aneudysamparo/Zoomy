//
//  PageModel.swift
//  Zoomy
//
//  Created by Aneudys Amparo on 14/2/24.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

extension Page {
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}
