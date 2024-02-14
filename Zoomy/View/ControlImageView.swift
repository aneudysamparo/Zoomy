//
//  ControlImageView.swift
//  Zoomy
//
//  Created by Aneudys Amparo on 14/2/24.
//

import SwiftUI

struct ControlImageView: View {
    let icon: String
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 36))
    }
}

#Preview {
    ControlImageView(icon: "circle.circle")
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
        .padding()
}
