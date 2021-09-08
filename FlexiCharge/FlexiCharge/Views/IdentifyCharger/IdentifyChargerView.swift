//
//  IdentifyChargerView.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-06.
//

import SwiftUI

struct IdentifyChargerView: View {
    let screenHeight = UIScreen.main.bounds.size.height
    @State private var chargerIdLength: Int = 6
    @State private var username: String = ""
    @State private var isEditing: Bool = false
    @State private var chargerIdInput: String = ""
    @State var value: CGFloat = 0
    @State var keyboardHeight: CGFloat = 0
    
    var body: some View {
        ZStack (alignment: .top){
            RoundedRectangle(cornerRadius: 5)
                .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                .frame(minHeight: 0, maxHeight: .infinity)
            VStack {
                Image("menu-arrow").rotationEffect(.degrees(180))
                
                Text("Chargers Near Me")
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
                ZStack {
                    HStack {
                        ForEach(0 ..< chargerIdLength) {i in
                            ZStack (alignment: .bottom){
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.white)
                                    .frame(width: 34, height: 53)
                                    .padding(.horizontal, 8)
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color(red: 0.90, green: 0.90, blue: 0.90))
                                    .frame(width: 24, height: 2)
                                    .padding(.bottom, 7)
                                Text(chargerIdInput.count > i ? chargerIdInput[i] : "")
                                    .foregroundColor(.black)
                                    .frame(width: 34, height: 53)
                                    .cornerRadius(10)
                                    .font(Font.system(size: 28, design: .default))
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }.padding(.bottom, 40)
                    TextField("", text: $chargerIdInput)
                        .foregroundColor(.clear)
                        .background(Color.clear)
                        .accentColor(.clear)
                        .font(Font.system(size: 44, design: .default))
                        .disableAutocorrection(true)
                        .keyboardType(.numberPad)
                        .padding(.bottom, 40)
                        .onChange(of: chargerIdInput ,perform: { value in
                            validateChargerId()
                        })
                }
                
                Text("Enter the Code Written on the Charger")
                    .foregroundColor(.white)
            }.padding()
        }
    }
    // Makes sure the entered charger id is not too long or is not all integers
    func validateChargerId() {
        let limit: Int = 6
        if chargerIdInput.count > limit || Int(chargerIdInput) == nil && chargerIdInput.count > 0 {
            chargerIdInput.removeLast()
        }
    }
}

struct IdentifyChargerView_Previews: PreviewProvider {
    static var previews: some View {
        IdentifyChargerView()
    }
}

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

