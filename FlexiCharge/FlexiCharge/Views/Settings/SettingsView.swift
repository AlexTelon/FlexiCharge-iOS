//
//  SettingsView.swift
//  FlexiCharge
//
//  Created by Daniel Göthe on 2021-09-13.
//

import SwiftUI

struct SettingsView: View {
    let screenHeight = UIScreen.main.bounds.size.height
    let screenWidth = UIScreen.main.bounds.size.width
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
                        .frame(width: screenWidth * 0.8, alignment: .center)
                    Spacer()
                }.frame(width: screenWidth * 0.95)
                .offset(y: -screenHeight * 0.03)
            }
            /*----------List of options----------*/
            VStack() {
                Group {
                    /*----------Charging History----------*/
                    // Change NavigationLink to correct page once it is created
                    NavigationLink(destination: LoginView()) {
                        HStack {
                            Text("Charging History")
                                .font(Font.system(size: 20, design: .default))
                                .foregroundColor(.black)
                            Spacer()
                            Image("menu-arrow-black")
                        }.frame(width: screenWidth * 0.8, height: screenHeight * 0.05, alignment: .bottom)
                    }
                    Divider()
                        .frame(height: 1)
                        .background(Color(red: 0.90, green: 0.90, blue: 0.90))
                    /*----------Invoices----------*/
                    // Change NavigationLink to correct page once it is created
                    NavigationLink(destination: ContentView()) {
                        HStack {
                            Text("Invoices")
                                .font(Font.system(size: 20, design: .default))
                                .foregroundColor(.black)
                            Spacer()
                            Image("menu-arrow-black")
                        }.frame(width: screenWidth * 0.8, height: screenHeight * 0.05, alignment: .bottom)
                    }
                    Divider()
                        .frame(height: 1)
                        .background(Color(red: 0.90, green: 0.90, blue: 0.90))
                    /*----------Account Settings----------*/
                    // Change NavigationLink to correct page once it is created
                    NavigationLink(destination: ContentView()) {
                        HStack {
                            Text("Account Settings")
                                .font(Font.system(size: 20, design: .default))
                                .foregroundColor(.black)
                            Spacer()
                            Image("menu-arrow-black")
                        }.frame(width: screenWidth * 0.8, height: screenHeight * 0.05, alignment: .bottom)
                    }
                    Divider()
                        .frame(height: 1)
                        .background(Color(red: 0.90, green: 0.90, blue: 0.90))
                    /*----------Name and Address----------*/
                    // Change NavigationLink to correct page once it is created
                    NavigationLink(destination: ContentView()) {
                        HStack {
                            Text("Name and Address")
                                .font(Font.system(size: 20, design: .default))
                                .foregroundColor(.black)
                            Spacer()
                            Image("menu-arrow-black")
                        }.frame(width: screenWidth * 0.8, height: screenHeight * 0.05, alignment: .bottom)
                    }
                    Divider()
                        .frame(height: 1)
                        .background(Color(red: 0.90, green: 0.90, blue: 0.90))
                    /*----------About----------*/
                    // Change NavigationLink to correct page once it is created
                    NavigationLink(destination: ContentView()) {
                        HStack {
                            Text("About")
                                .font(Font.system(size: 20, design: .default))
                                .foregroundColor(.black)
                            Spacer()
                            Image("menu-arrow-black")
                        }.frame(width: screenWidth * 0.8, height: screenHeight * 0.05, alignment: .bottom)
                    }
                    Divider()
                        .frame(height: 1)
                        .background(Color(red: 0.90, green: 0.90, blue: 0.90))
                }
                Spacer()
                /*----------Log out button----------*/
                Button(action: {
                    // TODO: add log out functionality
                }, label: {
                    Text("Log out")
                        .font(Font.system(size: 20, weight: .bold, design:.default))
                        .frame(width: screenWidth * 0.8, height: 48)
                })
                .background(Color(red: 0.94, green: 0.38, blue: 0.28))
                .foregroundColor(.white)
                .cornerRadius(5)
                Text("Spacing").hidden()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .frame(minHeight: 0, maxHeight: screenHeight, alignment: .bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
