//
//  SettingsView.swift
//  FlexiCharge
//
//  Created by Daniel Göthe on 2021-09-13.
//

import SwiftUI

struct SettingsView: View {
    @State private var selection: Int? = nil
    @StateObject var AccountApi = AccountAPI()
    @EnvironmentObject var accountModel: AccountDataModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    /*----------Header and custom back button----------*/
    
    var body: some View {
        VStack {
            // Gray design at the top of the screen
            ZStack {
                Image("top-tilted-rectangle")
                    .resizable()
                    .scaledToFit()
                /*----------Custom Backbutton----------*/
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
                    Text("Profile & Settings")
                        .foregroundColor(.white)
                        .font(Font.system(size: 40, weight: .bold, design: .default))
                        .scaledToFill()
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .frame(width: UsefulValues.screenWidth * 0.8, alignment: .center)
                    Spacer()
                }.frame(width: UsefulValues.screenWidth * 0.95)
                .offset(y: -UsefulValues.screenHeight * 0.03)
            }
            /*----------List of options----------*/
            VStack() {
                Group {
                    /*----------Charging History----------*/
                    // Change NavigationLink to correct page once it is created
                    NavigationLink(destination: InvoicesView()) {
                        HStack {
                            Text("Charging History")
                                .font(Font.system(size: 20, design: .default))
                                .foregroundColor(.black)
                            Spacer()
                            Image("menu-arrow-black")
                        }.frame(width: UsefulValues.screenWidth * 0.8, height: UsefulValues.screenHeight * 0.05, alignment: .bottom)
                    }
                    Divider()
                        .frame(height: 1)
                        .background(Color.primaryLightGray)
                    /*----------Invoices----------*/
                    // Change NavigationLink to correct page once it is created
                    NavigationLink(destination: InvoicesView()) {
                        HStack {
                            Text("Invoices")
                                .font(Font.system(size: 20, design: .default))
                                .foregroundColor(.black)
                            Spacer()
                            Image("menu-arrow-black")
                        }.frame(width: UsefulValues.screenWidth * 0.8, height: UsefulValues.screenHeight * 0.05, alignment: .bottom)
                    }
                    Divider()
                        .frame(height: 1)
                        .background(Color.primaryLightGray)
                    /*----------Account Settings----------*/
                    // Change NavigationLink to correct page once it is created
                    NavigationLink(destination: AccountSettingsView()) {
                        HStack {
                            Text("Account Settings")
                                .font(Font.system(size: 20, design: .default))
                                .foregroundColor(.black)
                            Spacer()
                            Image("menu-arrow-black")
                        }.frame(width: UsefulValues.screenWidth * 0.8, height: UsefulValues.screenHeight * 0.05, alignment: .bottom)
                    }
                    Divider()
                        .frame(height: 1)
                        .background(Color.primaryLightGray)
                    /*----------Name and Address----------*/
                    // Change NavigationLink to correct page once it is created
                    NavigationLink(destination: NameAndAdressView()) {
                        HStack {
                            Text("Name and Address")
                                .font(Font.system(size: 20, design: .default))
                                .foregroundColor(.black)
                            Spacer()
                            Image("menu-arrow-black")
                        }.frame(width: UsefulValues.screenWidth * 0.8, height: UsefulValues.screenHeight * 0.05, alignment: .bottom)
                    }
                    Divider()
                        .frame(height: 1)
                        .background(Color.primaryLightGray)
                    /*----------About----------*/
                    // Change NavigationLink to correct page once it is created
                    NavigationLink(destination: InvoicesView()) {
                        HStack {
                            Text("About")
                                .font(Font.system(size: 20, design: .default))
                                .foregroundColor(.black)
                            Spacer()
                            Image("menu-arrow-black")
                        }.frame(width: UsefulValues.screenWidth * 0.8, height: UsefulValues.screenHeight * 0.05, alignment: .bottom)
                    }
                    Divider()
                        .frame(height: 1)
                        .background(Color.primaryLightGray)
                }.frame(width: UsefulValues.screenWidth * 0.8)
                Spacer()
                /*----------Log out button----------*/
                NavigationLink(destination: RegisterAccountView(), tag: 1, selection: $selection) {
                    RegularButton(action: {
                        accountModel.setLoggedInToFalse()
                        self.selection = 1
                    },
                      text: UserDefaults.standard.bool(forKey: "isLoggedIn") ? "Log out" : "Not loged in",
                      foregroundColor: Color.white,
                      backgroundColor: UserDefaults.standard.bool(forKey: "isLoggedIn") ? Color.primaryRed : Color.primaryDarkGray)
                }
                .disabled(UserDefaults.standard.bool(forKey: "isLoggedIn") == false)
                .cornerRadius(5)
                Text("Spacing").hidden()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .frame(minHeight: 0, maxHeight: UsefulValues.screenHeight, alignment: .bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
