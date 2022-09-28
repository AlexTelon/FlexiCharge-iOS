//
//  SetupInvoicingView.swift
//  FlexiCharge
//
//  Created by Sandra Nissan on 2022-09-28.
//

import SwiftUI

struct SetupInvoicingView: View {
    @State private var name: String = ""
    @State private var adress: String = ""
    @State private var postcode: String = ""
    @State private var town: String = ""
    @State private var inputCornerRadius: CGFloat = 5
    @State private var tosCheckBox: Bool = false
    @State private var validEmail: Bool = false
    @State private var validationText: String = ""
    @State private var registerValidationText: String = ""
    @State var selection: Int? = nil
    @State private var loading: Bool = false
    @State var isActive: Bool = false
    
    
    @StateObject var accountAPI = AccountAPI()
    
    var body: some View {
        NavigationView{
            ZStack {
                ScrollView {
                    VStack {
                        ZStack {
                            Image("topShapeRegister")
                                .resizable()
                                .scaledToFit()
                            HStack {
                                Spacer()
                                Text("Setup Invoicing")
                                    .foregroundColor(.white)
                                    .font(Font.system(size: 40, weight: .bold, design: .default))
                                    .scaledToFill()
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                    .frame(width: UsefulValues.screenWidth * 0.8, alignment: .center)
                                Spacer()
                            }
                            .offset(y: -UsefulValues.screenHeight * 0.03)
                        }
                        VStack{
                            Text("Invoices are the quickest way to start charging and manage your payments.")
                            Spacer()
                            Text("All your charging sessions are collected in a single invoice and delivered to you at the end of each month.")
                            /*----------Name----------*/
                            RegularTextField(input: $name, placeholder: "Name", keyboardType: .default)
                                .padding(.top)
                            /*----------Adress----------*/
                            RegularTextField(input: $adress, placeholder: "Adress", keyboardType: .default)
                                .padding(.top)
                            /*----------Postcode----------*/
                            RegularTextField(input: $postcode, placeholder: "Postcode", keyboardType: .default)
                                .padding(.top)
                            /*----------Town----------*/
                            RegularTextField(input: $town, placeholder: "Town", keyboardType: .emailAddress)
                                .padding(.top)
                            HStack{
                                RegularButton(action: {print("test")} ,text: "Continue", foregroundColor: Color.white, backgroundColor: Color.primaryGreen)
                            }.background(RoundedRectangle(cornerRadius: 5).fill(Color.primaryGreen))
                                Spacer()
                            Text("No thanks")
                                .font(Font.system(size: 13,weight: .bold, design: .default))
                                .foregroundColor(Color.primaryGreen)
                            }
                        Text("If you choose not to invoice \n you will be asked to pay each time using Swish")
                            .padding(.top)
                            Spacer()
                        }.frame(width: UsefulValues.screenWidth * 0.8)
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .navigationBarHidden(true)
                .onTapGesture {
                    hideKeyboard()
                }
                withAnimation(.easeInOut) {
                    BasicLoadingScreen(imageName: "flexi-charge-logo-color")
                        .opacity(loading ? 1 : 0)
                }
            }
            .autocapitalization(.none)
            .disableAutocorrection(true)
        
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

