//
//  SecureTextField.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-10-05.
//

import SwiftUI

struct SecureTextField: View {
    @Binding var input: String
    var placeholder: String
    var keyboardType: UIKeyboardType
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            SecureField(placeholder, text: $input)
                .keyboardType(keyboardType)
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

struct SecureTextField_Previews: PreviewProvider {
    static var previews: some View {
        SecureTextField(input: .constant("Secure text"), placeholder: "Placeholder", keyboardType: .default)
    }
}
