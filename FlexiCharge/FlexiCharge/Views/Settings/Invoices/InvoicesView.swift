//
//  InvoicesView.swift
//  FlexiCharge
//
//  Created by Lucas Strand on 2021-09-21.
//

import SwiftUI

struct InvoicesView: View {
    let screenHeight = UIScreen.main.bounds.size.height
    let screenWidth = UIScreen.main.bounds.size.width
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var isInvoiceSetUp: Bool = true
    var isInvoiceEmpty: Bool = false
    @State private var invoices: Array<Any> = []
    @State private var showMore: Bool = false
    var easeOutAnimation: Animation {
        Animation.easeOut
    }
    
    var body: some View {
        VStack {
            ZStack {
                Image("top-tilted-rectangle")
                    .resizable()
                    .scaledToFit()
                HStack (alignment: .center) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("menu-arrow").rotationEffect(.degrees(90))
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("Invoices")
                        .foregroundColor(.white)
                        .font(Font.system(size: 40, weight: .bold, design: .default))
                        .scaledToFill()
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    Spacer()
                    //Very nice way to center text
                    Text("|||||||").hidden()
                }
                .frame(width: screenWidth * 0.8)
            }
            
            //User has not set up their invoicing
            if !isInvoiceSetUp {
            Image("black-logo")
                .frame(alignment: .top)
            Spacer()
            Text("You have not set up invoicing yet")
            NavigationLink(destination: SetUpInvoiceView()) {
                Text("Do it now")
                    .font(Font.system(size: 20,weight: .bold, design: .default))
            }
                .frame(width: screenWidth * 0.8, height: 48)
                .background(Color(red: 0.47, green: 0.74, blue: 0.46))
                .foregroundColor(.white)
                .cornerRadius(5)
                .padding()
            }
            //User has set up invoicing and can view payments to come
            else if isInvoiceSetUp && !isInvoiceEmpty {
                let invoice = getInvoice()
                let cost = String(invoice.cost)
                let invoiceInfo = getInvoiceInfo()
                Spacer()
                Text("View your charging history for each month,\n Delivered to you as a single invoice.")
                    .multilineTextAlignment(.center)
                ScrollView {
                    ForEach(0 ..< 1) {i in
                        VStack {
                            Group {
                                /*Invoices*/
                                HStack {
                                    Text(invoice.monthYear)
                                        .font(Font.system(size: 20, weight: .thin, design: .default))
                                        .foregroundColor(.black)
                                    Spacer()
                                    Button(action: {showMore.toggle()}, label: {
                                        Image("black-arrow")
                                            .padding(.leading)
                                            .rotationEffect(Angle.degrees(showMore ? 90 : 0), anchor: .center)
                                            .animation(easeOutAnimation)
                                    })
                                    .offset(y: 20)
                                }
                                .frame(width: screenWidth * 0.8, alignment: .top)
                                HStack {
                                    Text(cost + " kr")
                                        .font(Font.system(size: 20, design: .default))
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .frame(width: screenWidth * 0.8, height: screenHeight * 0.04, alignment: .bottom)
                                .offset(y: -20)
                                /*Invoice information*/
//                                if showMore {
                                    HStack {
                                        Text(invoiceInfo.location)
                                            .font(Font.system(size: 20, weight: .thin, design: .default))
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    .frame(width: screenWidth * 0.8, height: showMore ? screenHeight * 0.05 : 0, alignment: .bottom)
                                    .opacity(showMore ? 1 : 0)
                                    .offset(y: -20)
                                    .transition(.move(edge: .top))
                                    .animation(.easeInOut(duration: 0.25))
//                                }
                            }
                            Divider()
                            .frame(width: screenWidth * 0.8, height: 1)
                            .background(Color(red: 0.90, green: 0.90, blue: 0.90))
                                .offset(y: -20)
                                .transition(.move(edge: .top))
                                .animation(.easeInOut(duration: 0.25))
                        }
                    }
                }
            }
//            User has invoice set up, but there is no history yet
            else if isInvoiceSetUp && isInvoiceEmpty {
                Image("black-logo")
                    .frame(alignment: .top)
                Spacer()
                Text("Your invoice will become available after\n your first month of charging.")
                    .multilineTextAlignment(.center)
                    .frame(width: screenWidth * 0.8)
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .autocapitalization(.none)
        .disableAutocorrection(true)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct InvoicesView_Previews: PreviewProvider {
    static var previews: some View {
        InvoicesView()
    }
}
