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
            get: { postcode },
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
                    RegularTextField(input: $name, placeholder: "Name", keyboardType: .default)
                        .padding(.top)
                    /*----------Address----------*/
                    RegularTextField(input: $address, placeholder: "Address", keyboardType: .default)
                        .padding(.top)
                    /*----------Postcode----------*/
                    RegularTextField(input: postcodeLimit, placeholder: "Postcode", keyboardType: .numberPad)
                        .padding(.top)
                    /*----------Town----------*/
                    RegularTextField(input: $town, placeholder: "Town", keyboardType: .default)
                        .padding(.top)
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
                                                    .fill(Color.primaryGreen))
                                    .padding(.bottom)
                            }
                        })
                        
                        NavigationLink(destination: ContentView()) {
                            Text("No Thanks")
                                .font(Font.system(size: 15,weight: .bold, design: .default))
                                .foregroundColor(Color.primaryRed)
                        }
                    Text("If you choose not to invoice,\n you will be asked to pay each time using Swish.")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .font(.footnote)
                        
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
