//
//  SetUpInvoiceView.swift
//  FlexiCharge
//
//  Created by Lucas Strand on 2021-09-20.
//

import SwiftUI

struct SetUpInvoiceView: View {
    let screenWidth =  UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var postcode: String = ""
    @State private var town: String = ""
    @State private var inputHeight: CGFloat = 48
    @State private var inputCornerRadius: CGFloat = 5
    @State private var tosCheckBox: Bool = false
    @State private var validEmail: Bool = false
    @State private var validationText: String = ""
    
    var body: some View {
        //Limits the postcode to 5
        let postcodeLimit = Binding<String>(
            get: { postcode},
            set: { postcode =  String($0.prefix(5)) }
        )
        VStack() {
                ZStack(){
                    Image("topShapeRegister")
                        .resizable()
                        .scaledToFit()
                    Text("Setup invoice")
                        .foregroundColor(.white)
                        .font(.largeTitle.weight(.heavy))
                        .padding()
                }
                VStack{
                    /*----------Invoice information----------*/
                    Text("Invoices are the quickest way to start charging and manage your payments.\n\nAll of your charging sessions are collected in a single invoice and delivered to you at the end of each month.")
                        .multilineTextAlignment(.center)
                        .font(.footnote)
                    /*----------Name----------*/
                    ZStack(alignment: .leading){
                        TextField("Name", text: $name)
                        .frame(height: inputHeight)
                        .padding(.horizontal, 8)
                        .overlay(RoundedRectangle(cornerRadius: inputCornerRadius)
                                    .stroke()
                        )
                        .padding(.top)
                        Text("Name")
                            .foregroundColor(.black)
                            .padding(.horizontal, 5)
                            .background(Color.white)
                            .offset(x: 10, y: -15)
                            .opacity(name.count > 0 ? 1 : 0)
                    }
                    /*----------Address----------*/
                    ZStack(alignment: .leading){
                        TextField("Address", text: $address)
                        .frame(height: inputHeight)
                        .padding(.horizontal, 8)
                        .overlay(RoundedRectangle(cornerRadius: inputCornerRadius)
                                    .stroke()
                        )
                        .padding(.top)
                        Text("Address")
                            .foregroundColor(.black)
                            .padding(.horizontal, 5)
                            .background(Color.white)
                            .offset(x: 10, y: -15)
                            .opacity(address.count > 0 ? 1 : 0)
                            .keyboardType(.decimalPad)
                    }
                    /*----------Postcode----------*/
                    ZStack(alignment: .leading){
                        TextField("Postcode", text: postcodeLimit)
                            .frame(height: inputHeight)
                            .padding(.horizontal, 8)
                            .overlay(RoundedRectangle(cornerRadius: inputCornerRadius)
                                        .stroke()
                            )
                            .padding(.top)
                            Text("Postcode")
                                .foregroundColor(.black)
                                .padding(.horizontal, 5)
                                .background(Color.white)
                                .offset(x: 10, y: -15)
                                .opacity(postcode.count > 0 ? 1 : 0)
                                .keyboardType(.decimalPad)
                    }
                    /*----------Town----------*/
                    ZStack(alignment: .leading){
                        TextField("Town", text: $town)
                        .frame(height: inputHeight)
                        .padding(.horizontal, 8)
                        .overlay(RoundedRectangle(cornerRadius: inputCornerRadius)
                                    .stroke()
                        )
                        .padding(.top)
                        Text("Town")
                            .foregroundColor(.black)
                            .padding(.horizontal, 5)
                            .background(Color.white)
                            .offset(x: 10, y: -15)
                            .opacity(town.count > 0 ? 1 : 0)
                            .keyboardType(.decimalPad)
                    }
                    Spacer()
                    /*----------Register button and the following text----------*/
                    VStack{
                        Text(validationText)
                            .foregroundColor(.red)
                            .padding(.bottom)
                        Button(action: {
                            validationText = validateSetupInvoice(name: name, address: address, postcode: postcode, town: town)
                        }, label: {
                            NavigationLink(destination: SettingsView()) {
                                Text("Continue")
                                    .font(Font.system(size: 20,weight: .bold, design: .default))
                                    .frame(width: screenWidth * 0.8, height: inputHeight)
                                    .foregroundColor(.white)
                                    .background(RoundedRectangle(cornerRadius: inputCornerRadius)
                                                    .fill(Color(red: 0.47, green: 0.74, blue: 0.46)))
                                    .padding(.bottom)
                            }
                        })
                        
                        NavigationLink(destination: ContentView()) {
                            Text("No Thanks")
                                .font(Font.system(size: 15,weight: .bold, design: .default))
                                .foregroundColor(Color(red: 0.94, green: 0.38, blue: 0.28))
                        }
                    Text("If you chose not to invoice,\n you will be asked to pay each time using Swish.")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .font(.footnote)
                        .padding()
                }
                .padding(.bottom)
            }
            .frame(width: screenWidth * 0.8)
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct SetUpInvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        SetUpInvoiceView()
    }
}
