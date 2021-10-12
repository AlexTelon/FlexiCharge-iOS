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
    
    @State var results = [Charger]()
    @State var isShowingListOfChargers: Bool = false
    @State var isChargingInProgress: Bool = false
    @State var isKlarnaPresented: Bool = true
    @State var chargingInProgressID: Int = 0
    @State var isShowingDisconnentButton: Bool = false
    @State var klarnaMessage: String = ""
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @State var keyboardHeight: CGFloat = 0
    @State var update = false
    @State var result = [Charger]()

    
    @State private var isShowingScanner: Bool = false
    @State private var notUrl: Bool = false
    
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
                    MapView(chargers: $result)
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
                                CodeScannerView(codeTypes: [.qr], simulatedData: "QR scan", completion: self.handleScan).overlay(QROverlayView())
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
                                    Image("white")
                                }
                            }
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
                    IdentifyChargerView(isChargingInProgress: $isChargingInProgress, chargingInProgressID: $chargingInProgressID, chargers: $result, isShowingListOfChargers: $isShowingListOfChargers, offset: $offset, isKlarnaPresented: $isKlarnaPresented, klarnaMessage: $klarnaMessage)
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
                ViewController(isPresented: $isKlarnaPresented, klarnaMessage: $klarnaMessage)
            }
        }.navigationBarHidden(true)
        .onAppear(perform: loadData)
        .onChange(of: isChargingInProgress, perform: { _ in
            loadData()
        })
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
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        
        switch result {
        case .success(let details):
            //            let details = code
            if URL(string: details) != nil {
                openURL(URL(string: details)!)
            } else {
                notUrl = true
            }
            print("QR CODE DETAILS", details)
        case .failure(_):
            print("Scanning failed")
            notUrl = true
        }
    }
    
    func loadData() {
        // Fetches all chargers
        guard let url = URL(string: "http://54.220.194.65:8080/chargers") else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            let decodedData = try! JSONDecoder().decode([Charger].self, from: data)
            
            DispatchQueue.main.async {
                self.result = decodedData
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
