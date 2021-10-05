//
//  RegularButton.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-10-05.
//

import SwiftUI

struct RegularButton: View {
    var text: String
    var foregroundColor: Color
    var backgroundColor: Color
    
    let screenHeight = UIScreen.main.bounds.size.height
    let screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        Text(text)
            .frame(width: screenWidth * 0.8)
            .frame(maxHeight: 48)
            .foregroundColor(foregroundColor)
            .background(Rectangle().fill(backgroundColor))
            .font(Font.system(size: 20,weight: .bold, design: .default))
            .cornerRadius(5)
    }
}

struct RegularButton_Previews: PreviewProvider {
    static var previews: some View {
        RegularButton(text: "Placeholder", foregroundColor: Color.white, backgroundColor: Color.primaryGreen)
    }
}
