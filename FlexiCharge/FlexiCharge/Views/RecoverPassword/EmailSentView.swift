//
//  EmailSentView.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-13.
//

import SwiftUI

struct EmailSentView: View {
    let screenWidth = UIScreen.main.bounds.size.width
    let inputHeight: CGFloat = 48
    let inputCornerRadius: CGFloat = 5
    let email: String
    
    init(email: String) {
        self.email = email
    }
    
    var body: some View {
        VStack {
            // Gray design at the top of the screen
            ZStack {
                Image("top-tilted-rectangle")
                    .resizable()
                    .scaledToFit()
                Text("Recover Email\nSent")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .font(Font.system(size: 36, weight: .bold, design: .default))
            }
            VStack {
                Text("An email with a link to reset your password,has been sent to the following address…")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .padding(.top)
                    .padding(.horizontal, 2)
                Text(email)
                    .underline()
                    .padding(.vertical)
                Spacer()
                Spacer()
                Button(action: {
                    // TODO: navigate back to login screen
                }, label: {
                    Text("Back to log in")
                        .font(Font.system(size: 20,weight: .bold, design: .default))
                })
                .frame(width: screenWidth * 0.8, height: 48)
                .background(Color(red: 0.47, green: 0.74, blue: 0.46))
                .foregroundColor(.white)
                .cornerRadius(5)
                .padding()
                HStack {
                    Text("I didn’t get my email :(")
                    Button(action: {
                        // TODO: send a new recover email
                    }, label: {
                        Text("Send Again")
                            .foregroundColor(Color(red: 0.47, green: 0.74, blue: 0.46))
                    })
                }
                .font(.subheadline)
                Spacer()
            }
            .frame(width: screenWidth * 0.8)
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
    }
}

struct EmailSentView_Previews: PreviewProvider {
    static var previews: some View {
        EmailSentView(email: "Jill.Valentine@starrs.gov")
    }
}
