//
//  RegularTextField.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-10-05.
//

import SwiftUI

struct RegularTextField: View {
    @Binding var input: String
    var placeholder: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextField(placeholder, text: $input)
                .keyboardType(.emailAddress)
                .frame(width: UsefulValues.screenWidth * 0.8, height: 48)
                .offset(x: 8)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke())
            Text(placeholder)
                .foregroundColor(.black)
                .padding(.horizontal, 5)
                .background(Color.white)
                .offset(x: 10, y: -10)
                .opacity(input.count > 0 ? 1 : 0)
        }
    }
}

struct RegularTextField_Previews: PreviewProvider {
    static var previews: some View {
        RegularTextField(input: .constant("Text"), placeholder: "Placeholder")
    }
}
