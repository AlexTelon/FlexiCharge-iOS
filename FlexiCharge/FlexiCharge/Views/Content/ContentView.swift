//
//  ContentView.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-06.
//

import SwiftUI
import CoreData
import MapKit
import CodeScanner

struct ContentView: View {
    let listHeight: CGFloat
    @State var isShowingListOfChargers: Bool = false
    @State var chargerIdInput: String = ""
    @State var isChargingInProgress: Bool = false
    @State var isKlarnaPresented: Bool = false
    @State var chargingInProgressID: Int = 0
    @State var isShowingDisconnentButton: Bool = false
    @State var klarnaStatus: String = ""
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @State var keyboardHeight: CGFloat = 0
    @State var update = false
    @State var chargers = [Charger]()
    @State var chargePoints = [ChargerHub]()
    @State var chargePointsExt = [ChargerHubExt]()
    @State var centerUser: Bool = false
    @State var transactionID: Int = 0
    
    @State private var isShowingScanner: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @GestureState private var gestureOffset: CGFloat = 0
    @Environment(\.openURL) var openURL
    init() {
        UITableView.appearance().backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self.listHeight = UsefulValues.screenHeight / 4
    }
    
    var body: some View {
        NavigationView {
            Group {
                ZStack(alignment: .bottom) {
                    MapView(chargePoints: $chargePoints, centerUser: $centerUser)
                        .frame(minHeight: 0, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            offset = 0
                            isShowingListOfChargers = false
                            hideKeyboard()
                        }
                    ChargingInProgressView(isShowingDisconnentButton: $isShowingDisconnentButton, isChargingInProgress: $isChargingInProgress, chargingInProgressID: $chargingInProgressID)
                        .transition(.move(edge: .top))
                        .animation(.easeInOut(duration: 0.2))
                        .offset(y: isChargingInProgress ? -UsefulValues.screenHeight * 0.66 : -UsefulValues.screenHeight)
                        .offset(y: isShowingDisconnentButton && isChargingInProgress ? 50 : 0)
                    VStack {
                        HStack {
                            VStack {
                                Button(action: {
                                    findUserOnMap()
                                }, label: {
                                    ZStack {
                                        Circle()
                                            .fill(Color.menuButtonGray)
                                            .frame(width: UsefulValues.screenWidth * 0.15, height: UsefulValues.screenWidth * 0.15)
                                        Image("location-pin")
                                            .resizable()
                                            .frame(width: UsefulValues.screenWidth * 0.06, height: UsefulValues.screenWidth * 0.08, alignment: .center)
                                    }
                                }).offset(x: UsefulValues.screenWidth * -0.35)
                            }
                        }
                        HStack {
                            Button(action: {
                                cameraButton()
                            }, label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.menuButtonGray)
                                        .frame(width: UsefulValues.screenWidth * 0.15, height: UsefulValues.screenWidth * 0.15)
                                    Image(systemName: "camera.fill")
                                        .font(Font.system(.title2))
                                        .foregroundColor(.white)
                                }
                            }).offset(x: UsefulValues.screenWidth * -0.15)
                            .sheet(isPresented: $isShowingScanner) {
                                CodeScannerView(codeTypes: [.qr], simulatedData: "QR scan", completion: self.handleScan).overlay(QROverlayView(isShowingScanner: $isShowingScanner, alertTitle: $alertTitle, alertMessage: $alertMessage, showAlert: $showAlert))
                            }
                            Button(action: {
                                let maxHeight = UsefulValues.screenHeight / 2.5
                                offset = -maxHeight
                                lastOffset = offset
                            }){
                                ZStack {
                                    Circle()
                                        .fill(Color.menuButtonGray)
                                        .frame(width: UsefulValues.screenWidth * 0.20, height: UsefulValues.screenWidth * 0.20)
                                    Image("flexi-charge-logo-light")
                                }
                            }
                            .disabled(isChargingInProgress)
                            ZStack {
                                NavigationLink(destination: SettingsView()) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.menuButtonGray)
                                            .frame(width: UsefulValues.screenWidth * 0.15, height: UsefulValues.screenWidth * 0.15)
                                        Image("person")
                                            .resizable()
                                            .frame(width: UsefulValues.screenWidth * 0.07, height: UsefulValues.screenWidth * 0.07, alignment: .center)
                                    }
                                }
                            }.offset(x: UsefulValues.screenWidth * 0.15)
                        }.padding(.bottom, UsefulValues.screenHeight * 0.05)
                        .padding(.horizontal, UsefulValues.screenWidth * 0.1)
                    }
                    let conditionOffset = self.offset + UsefulValues.screenHeight - self.keyboardHeight
                    IdentifyChargerView(isChargingInProgress: $isChargingInProgress, chargingInProgressID: $chargingInProgressID, chargePoints: $chargePoints, chargers: $chargers, chargePointsExt: $chargePointsExt, isShowingListOfChargers: $isShowingListOfChargers, offset: $offset, chargerIdInput: $chargerIdInput, isKlarnaPresented: $isKlarnaPresented, klarnaStatus: $klarnaStatus)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut(duration: 0.2))
                        .offset(y: isShowingListOfChargers ? conditionOffset - listHeight  : conditionOffset)
                        .gesture(DragGesture().updating($gestureOffset, body: {
                            value, out, _ in
                            if value.translation.height > 0 {
                                out = value.translation.height
                            }
                            onChange()
                        })
                        .onEnded({value in
                            let maxHeight = UsefulValues.screenHeight / 2.5
                            withAnimation {
                                if -offset > maxHeight / 2 {
                                    offset = -maxHeight
                                } else {
                                    offset = 0
                                    isShowingListOfChargers = false
                                    hideKeyboard()
                                }
                            }
                            lastOffset = offset
                        }))
                        .onAppear {
                            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { data in
                                let height = data.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
                                self.keyboardHeight = height.cgRectValue.height
                            }
                            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                                self.keyboardHeight = 0
                            }
                        }
                }.edgesIgnoringSafeArea(.bottom)
                .navigationBarHidden(true)
            }.background(Color.primaryDarkGray.ignoresSafeArea(.all))
            .sheet(isPresented: $isKlarnaPresented) {
                InitializeKlarna(isPresented: $isKlarnaPresented, klarnaStatus: $klarnaStatus, chargerIdInput: $chargerIdInput, transactionID: $transactionID)
            }
        }.navigationBarHidden(true)
        .onAppear(perform: loadChargePoints)
    }
    
    func onChange() {
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastOffset
        }
    }
    func cameraButton() {
        // Function to open camera and and scan qrcode and return a charer id
        self.isShowingScanner = true
    }
    func findUserOnMap() {
        // Find the user on the map
        centerUser.toggle()
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        switch result {
        case .success(let details):
            let digitSet = CharacterSet.decimalDigits
            let id = String(details.unicodeScalars.filter { digitSet.contains($0) })
            if id.count != 6 {
                alertTitle = "Scanning failed"
                alertMessage = "Try entering the chargers id manually"
                showAlert = true
            } else {
                self.isShowingScanner = false
                self.chargerIdInput = id
                let maxHeight = UsefulValues.screenHeight / 2.5
                offset = -maxHeight
                lastOffset = offset
            }
        case .failure(_):
            alertTitle = "Scanning failed"
            alertMessage = "Something went wrong when scanning the QR code"
            showAlert = true
        }
    }
    
    func loadChargePoints() {
        //Fetches all chargePoints
        guard let url = URL(string: "http://54.220.194.65:8080/chargePoints") else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            let decodedData = try! JSONDecoder().decode([ChargerHub].self, from: data)
            
            DispatchQueue.main.async {
                self.chargePoints = decodedData
                loadChargers()
                print(decodedData)
            }
        }.resume()
    }
    
    func loadChargers() {
        // Fetches all chargers
        guard let url = URL(string: "http://54.220.194.65:8080/chargers") else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            let decodedData = try! JSONDecoder().decode([Charger].self, from: data)
            
            DispatchQueue.main.async {
                self.chargers = decodedData
                sortChargePointsExt()
            }
        }.resume()
    }
    
    func sortChargePointsExt() {
        for chargePoint in self.chargePoints {
            let chargePointExtChargers = self.chargers.filter( {$0.chargePointID == chargePoint.chargePointID} )
            self.chargePointsExt.append(ChargerHubExt(chargePointID: chargePoint.chargePointID, name: chargePoint.name, location: chargePoint.location, price: chargePoint.price, klarnaReservationAmount: chargePoint.klarnaReservationAmount, chargers: chargePointExtChargers))
        }
        print(self.chargePointsExt)
    }
    
    func updateChargers() {
        // Fetches chargers to update the map if a change has occured
        guard let url = URL(string: "http://54.220.194.65:8080/chargers") else { return }
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                guard let data = data else { return }
                let decodedData = try! JSONDecoder().decode([Charger].self, from: data)
                
                DispatchQueue.main.async {
                    if chargers != decodedData {
                        self.chargers = decodedData
                    }
                    updateChargers()
                }
            }.resume()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
