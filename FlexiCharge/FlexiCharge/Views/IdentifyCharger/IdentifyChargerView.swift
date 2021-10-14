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
    @Binding var isKlarnaPresented: Bool
    @Binding var chargingInProgressID: Int
    @Binding var chargers: [Charger]
    @Binding var offset: CGFloat
    @Binding var chargerIdInput: String
    @Binding var klarnaStatus: String
    
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var chargerIdLength: Int = 6
    @State private var username: String = ""
    @State private var isEditing: Bool = false
    @State private var buttonText: String = ""
    @State private var buttonColor: Color = .white
    @State private var isButtonDisabled: Bool = true
    @State private var isButtonVisible: Double = 0
    @State private var buttonTextColor: Color = .clear
    @State var listOfChargersHeight: CGFloat = 0.0
    @State var value: CGFloat = 0
    @State var keyboardHeight: CGFloat = 0
    
    
    init(isChargingInProgress: Binding<Bool>, chargingInProgressID: Binding<Int>, chargers: Binding<[Charger]>, isShowingListOfChargers: Binding<Bool>, offset: Binding<CGFloat>, chargerIdInput: Binding<String>, isKlarnaPresented: Binding<Bool>, klarnaStatus: Binding<String>) {
        UITableView.appearance().backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self._isShowingListOfChargers = isShowingListOfChargers
        self._isChargingInProgress = isChargingInProgress
        self._chargingInProgressID = chargingInProgressID
        self._isKlarnaPresented = isKlarnaPresented
        self._chargers = chargers
        self._offset = offset
        self._chargerIdInput = chargerIdInput
        self._klarnaStatus = klarnaStatus
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.primaryDarkGray)
                .frame(minHeight: 0, maxHeight: .infinity)
            VStack {
                
                ChargerList(isShowingListOfChargers: $isShowingListOfChargers, chargers: chargers, chargerIdInput: $chargerIdInput)
                Text("Spacing").hidden()
                
                ZStack {
                    HStack {
                        ForEach(0 ..< chargerIdLength) {i in
                            ZStack(alignment: .bottom) {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.white)
                                    .frame(width: 34, height: 53)
                                    .padding(.horizontal, UsefulValues.screenWidth * 0.01)
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.primaryLightGray)
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
                    RegularButton(action: {
                        startCharging()
                    }, text: buttonText, foregroundColor: buttonTextColor, backgroundColor: buttonColor)
                        .disabled(isButtonDisabled)
                        .opacity(isButtonVisible)
                        .offset(y: -25)
                }
            }
            .frame(width: UsefulValues.screenWidth * 0.8)
            .padding(.vertical)
            .padding(.horizontal, 12)
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Dismiss")){showAlert = false})
            }
            .onChange(of: klarnaStatus, perform: { _ in
                if klarnaStatus != "Accepted" {
                    alertTitle = "Klarna error"
                    alertMessage = klarnaStatus
                    showAlert = true
                } else {
                    isChargingInProgress = true
                    chargingInProgressID = Int(chargerIdInput)!
                    offset = 0
                    isShowingListOfChargers = false
                    hideKeyboard()
                }
            })
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
            let status = getChargerStatus(chargers: chargers, chargerId: Int(chargerIdInput)!)
            drawChargingButton(status: status)
        }
    }
    
    func drawChargingButton(status: String) {
        if status == StatusConstants.AVAILABLE {
            buttonText = "Begin Charging"
            buttonColor = Color.primaryGreen
            isButtonDisabled = false
            isButtonVisible = 1
            buttonTextColor = Color(red: 1.00, green: 1.00, blue: 1.00)
        } else if status == StatusConstants.CHARGING || status == StatusConstants.RESERVED {
            buttonText = "Charger Occupied"
            buttonColor = Color.primaryRed
            isButtonDisabled = true
            isButtonVisible = 1
            buttonTextColor = Color(red: 1.00, green: 1.00, blue: 1.00)
        } else if status == StatusConstants.FAULTED {
            buttonText = "Charger Out of Order"
            buttonColor = Color.primaryLightGray
            isButtonDisabled = true
            isButtonVisible = 1
            buttonTextColor = Color.menuButtonGray
        } else {
            buttonText = "Charger Not Available"
            buttonColor = Color.primaryLightGray
            isButtonDisabled = true
            isButtonVisible = 1
            buttonTextColor = Color.menuButtonGray
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func startCharging() {
        ChargerAPI().beginCharging(chargerID: Int(chargerIdInput)!) { response in
            if response != "Accepted" {
                alertTitle = response
                alertMessage = "Something went wrong"
                showAlert = true
            } else {
                isKlarnaPresented = true
            }
        }
    }
}



struct IdentifyChargerView_Previews: PreviewProvider {
    @State var preview = false
    static var previews: some View {
        IdentifyChargerView(isChargingInProgress: .constant(true), chargingInProgressID: .constant(0), chargers: .constant([Charger(chargerID: 999999, location: [57.778568, 14.163727], chargePointID: 9, serialNumber: "%&(/K€OLC:VP", status: "Available")]), isShowingListOfChargers: .constant(false), offset: .constant(0), chargerIdInput: .constant("999999"), isKlarnaPresented: .constant(false), klarnaStatus: .constant(""))
    }
}

struct StatusConstants {
    static let AVAILABLE = "Available"
    static let PREPARING = "Preparing"
    static let CHARGING = "Charging"
    static let SUSPENDEDEVSE = "SuspendedEVSE"
    static let SUSPENDEDEV = "SuspendedEV"
    static let FINISHING = "Finishing"
    static let RESERVED = "Reserved"
    static let UNAVAILABLE = "Unavailable"
    static let FAULTED = "Faulted"
}

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}
