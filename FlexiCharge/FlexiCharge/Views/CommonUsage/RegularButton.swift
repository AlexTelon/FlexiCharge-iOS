//
//  RegularButton.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-10-05.
//

import SwiftUI

struct RegularButton: View {
    var action: () -> Void
    var text: String
    var foregroundColor: Color
    var backgroundColor: Color
    
    let screenHeight = UIScreen.main.bounds.size.height
    let screenWidth = UIScreen.main.bounds.size.width
    
    init(action: @escaping () -> Void, text: String, foregroundColor: Color, backgroundColor: Color) {
        self.action = action
        self.text =  text
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }
        
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(text)
                .frame(width: screenWidth * 0.8, alignment: .center)
                .frame(maxHeight: 48)
        })
        .foregroundColor(foregroundColor)
        .background(RoundedRectangle(cornerRadius: 5).fill(backgroundColor))
        .font(Font.system(size: 20,weight: .bold, design: .default))
    }
}

struct RegularButton_Previews: PreviewProvider {
    static var previews: some View {
        RegularButton(action: {print("Action")}, text: "Placeholder", foregroundColor: Color.white, backgroundColor: Color.primaryGreen)
    }
}
