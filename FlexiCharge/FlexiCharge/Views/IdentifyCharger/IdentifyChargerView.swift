//
//  IdentifyChargerView.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-06.
//

import SwiftUI

struct IdentifyChargerView: View {
    @Binding var isShowingListOfChargers: Bool
    @Binding var isChargingInProgress: Bool
    @Binding var chargingInProgressID: Int
    @Binding var chargers: ChargerAPI
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    @State private var chargerIdLength: Int = 6
    @State private var username: String = ""
    @State private var isEditing: Bool = false
    @State private var chargerIdInput: String = ""
    @State private var buttonText: String = ""
    @State private var buttonColor: Color = .white
    @State private var isButtonDisabled: Bool = true
    @State private var isButtonVisible: Double = 0
    @State private var buttonTextColor: Color = .clear
    @State var listOfChargersHeight: CGFloat = 0.0
    @State var value: CGFloat = 0
    @State var keyboardHeight: CGFloat = 0
    
    
    init(isChargingInProgress: Binding<Bool>, chargingInProgressID: Binding<Int>, chargers: Binding<ChargerAPI>, isShowingListOfChargers: Binding<Bool>) {
        UITableView.appearance().backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self._isShowingListOfChargers = isShowingListOfChargers
        self._isChargingInProgress = isChargingInProgress
        self._chargingInProgressID = chargingInProgressID
        self._chargers = chargers
    }

    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                .frame(minHeight: 0, maxHeight: .infinity)
            VStack {
                Button(action: {
                    isShowingListOfChargers.toggle()
                }) {
                    Image("menu-arrow").rotationEffect(.degrees(isShowingListOfChargers ? 0 : 180))
                }
                Text("Chargers Near Me")
                    .foregroundColor(.white)
                    .opacity(isShowingListOfChargers ? 0 : 1)
                ChargerList(isShowingListOfChargers: $isShowingListOfChargers)
                Text("Spacing").hidden()
                
                ZStack {
                    HStack {
                        ForEach(0 ..< chargerIdLength) {i in
                            ZStack(alignment: .bottom) {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.white)
                                    .frame(width: 34, height: 53)
                                    .padding(.horizontal, screenWidth * 0.01)
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
                ZStack {
                    Text("Enter the Code Written on the Charger")
                        .foregroundColor(.white)
                        .opacity(isButtonVisible == 1 ? 0 : 1)
                        .offset(y: -35)
                    Button(action: {
                        startCharging()
                    }){
                        Text(buttonText)
                            .font(Font.system(size: 20,weight: .bold, design: .default))
                            .foregroundColor(buttonTextColor)
                    }.frame(width: screenWidth * 0.8, height: 53, alignment: .center)
                    .background(buttonColor)
                    .cornerRadius(5)
                    .disabled(isButtonDisabled)
                    .opacity(isButtonVisible)
                    .offset(y: -25)
                }
            }
            .frame(width: screenWidth * 0.8)
            .padding(.vertical)
            .padding(.horizontal, 12)
        }
    }
    // Makes sure the entered charger id is not too long or is not all integers
    func validateChargerId() {
        let limit: Int = 6
        if isButtonVisible == 1 && chargerIdInput.count < limit {
            isButtonDisabled = true
            isButtonVisible = 0
        }
        if chargerIdInput.count > limit || Int(chargerIdInput) == nil && chargerIdInput.count > 0 {
            chargerIdInput.removeLast()
        } else if chargerIdInput.count == limit {
            let status = getChargerStatus(chargerId: Int(chargerIdInput)!)
            drawChargingButton(status: status)
        }
    }
    
    func drawChargingButton(status: Int) {
        let notIdentified: Int = 0
        let success: Int = 1
        let occupied: Int = 2
        let outOfOrder: Int = 3
        if status == notIdentified {
            buttonText = "Charger Not Identified"
            buttonColor = Color(red: 0.90, green: 0.90, blue: 0.90)
            isButtonDisabled = true
            isButtonVisible = 1
            buttonTextColor = Color(red: 0.30, green: 0.30, blue: 0.30)
        } else if status == success {
            buttonText = "Begin Charging"
            buttonColor = Color(red: 0.47, green: 0.74, blue: 0.46)
            isButtonDisabled = false
            isButtonVisible = 1
            buttonTextColor = Color(red: 1.00, green: 1.00, blue: 1.00)
        } else if status == occupied {
            buttonText = "Charger Occupied"
            buttonColor = Color(red: 0.94, green: 0.38, blue: 0.28)
            isButtonDisabled = true
            isButtonVisible = 1
            buttonTextColor = Color(red: 1.00, green: 1.00, blue: 1.00)
        } else if status == outOfOrder {
            buttonText = "Charger Out of Order"
            buttonColor = Color(red: 0.90, green: 0.90, blue: 0.90)
            isButtonDisabled = true
            isButtonVisible = 1
            buttonTextColor = Color(red: 0.30, green: 0.30, blue: 0.30)
        }
    }
}

func startCharging() {
    //Add functionality to startChargingButton
    //Send all selected options to API
}

struct IdentifyChargerView_Previews: PreviewProvider {
    @State var preview = false
    static var previews: some View {
        IdentifyChargerView()
        IdentifyChargerView(isChargingInProgress: .constant(true), chargingInProgressID: .constant(0), chargers: .constant(ChargerAPI()), isShowingListOfChargers: .constant(false))
    }
}

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}
