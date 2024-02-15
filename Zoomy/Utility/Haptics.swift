//
//  Haptics.swift
//  Zoomy
//
//  Created by Aneudys Amparo on 15/2/24.
//

import SwiftUI

class Haptics {
    static let shared = Haptics()
    
    private init() {}
    
    func longPress(){
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    
    func tap() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}
