//
//  LoginView.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-13.
//

import SwiftUI

struct LoginView: View {
    let screenHeight = UIScreen.main.bounds.size.height
    let screenWidth = UIScreen.main.bounds.size.width
    let inputHeight: CGFloat = 48
    let inputCornerRadius: CGFloat = 5
    let emailPlaceholder: String = "Email"
    let passwordPlaceholder: String = "Password"
    @State private var emailInput: String = ""
    @State private var passwordInput: String = ""
    @State var isActive: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    
    var body: some View {
        NavigationView {
            VStack {
                // Gray design at the top of the screen
                ZStack {
                    Image("top-tilted-rectangle")
                        .resizable()
                        .scaledToFit()
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image("menu-arrow").rotationEffect(.degrees(90))
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(alignment: .leading)
                        }
                        Spacer()
                        Text("Log In")
                            .foregroundColor(.white)
                            .font(Font.system(size: 44, weight: .bold, design: .default))
                            .scaledToFill()
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                        Spacer()
                        Image("menu-arrow")
                            .hidden()
                    }.frame(width: screenWidth * 0.95, alignment: .center)
                    .offset(y: -screenHeight * 0.03)
                }
                // Login "form"
                VStack {
                    // Email input field
                    ZStack(alignment: .topLeading) {
                        TextField(emailPlaceholder, text: $emailInput)
                            .frame(height: inputHeight)
                            .offset(x: 8)
                            .overlay(RoundedRectangle(cornerRadius: inputCornerRadius).stroke())
                        Text(emailPlaceholder)
                            .foregroundColor(.black)
                            .padding(.horizontal, 5)
                            .background(Color.white)
                            .offset(x: 10, y: -10)
                            .opacity(emailInput.count > 0 ? 1 : 0)
                    }.padding(.vertical)
                    // Password input field
                    ZStack(alignment: .topLeading) {
                        SecureField(passwordPlaceholder, text: $passwordInput)
                            .frame(height: inputHeight)
                            .offset(x: 8)
                            .overlay(RoundedRectangle(cornerRadius: inputCornerRadius).stroke())
                        Text(passwordPlaceholder)
                            .foregroundColor(.black)
                            .padding(.horizontal, 5)
                            .background(Color.white)
                            .offset(x: 10, y: -10)
                            .opacity(passwordInput.count > 0 ? 1 : 0)
                    }.padding(.vertical)
                    Spacer()
                    Spacer()
                    NavigationLink(destination: ContentView()) {
                        Text("Log in")
                            .font(Font.system(size: 20,weight: .bold, design: .default))
                    }
                    .frame(width: screenWidth * 0.8, height: 48)
                    .background(Color(red: 0.47, green: 0.74, blue: 0.46))
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .padding()
                    NavigationLink(destination: RecoverPasswordView(rootIsActive: $isActive), isActive: self.$isActive) {
                        Text("I forgot my password")
                            .font(Font.system(size: 13,weight: .bold, design: .default))
                            .foregroundColor(Color(red: 0.47, green: 0.74, blue: 0.46))
                    }
                    .isDetailLink(false)
                    Spacer()
                }
                .frame(width: screenWidth * 0.8)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
            .frame(minHeight: 0, maxHeight: .infinity)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .onTapGesture {
                hideKeyboard()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
