//
//  ContentView.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-06.
//

import SwiftUI
import CoreData
import MapKit

struct ContentView: View {
    let screenHeight = UIScreen.main.bounds.size.height
    let screenWidth = UIScreen.main.bounds.size.width
    let listHeight: CGFloat
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @State var keyboardHeight: CGFloat = 0
    @State var isShowingListOfChargers: Bool = false
    @GestureState private var gestureOffset: CGFloat = 0
    
    init() {
        UITableView.appearance().backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self.listHeight = screenHeight / 4
    }
    
    var body: some View {
        NavigationView {
            Group {
                ZStack(alignment: .bottom) {
                    MapView()
                        .frame(minHeight: 0, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            offset = 0
                            isShowingListOfChargers = false
                            hideKeyboard()
                        }
                    VStack {
                        HStack {
                            VStack {
                                Button(action: {
                                    findUserOnMap()
                                }, label: {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 0.30, green: 0.30, blue: 0.30))
                                            .frame(width: screenWidth * 0.15, height: screenWidth * 0.15)
                                        Image("location-pin")
                                            .resizable()
                                            .frame(width: screenWidth * 0.06, height: screenWidth * 0.08, alignment: .center)
                                    }
                                }).offset(x: screenWidth * -0.35)
                            }
                        }
                        HStack {
                            Button(action: {
                                cameraButton()
                            }, label: {
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 0.30, green: 0.30, blue: 0.30))
                                        .frame(width: screenWidth * 0.15, height: screenWidth * 0.15)
                                    Image(systemName: "camera.fill")
                                        .font(Font.system(.title2))
                                        .foregroundColor(.white)
                                }
                            }).offset(x: screenWidth * -0.15)
                            Button(action: {
                                let maxHeight = screenHeight / 2.5
                                offset = -maxHeight
                                lastOffset = offset
                            }){
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 0.30, green: 0.30, blue: 0.30))
                                        .frame(width: screenWidth * 0.20, height: screenWidth * 0.20)
                                    Image("white")
                                }
                            }
                            ZStack {
                                NavigationLink(destination: SettingsView()) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 0.30, green: 0.30, blue: 0.30))
                                            .frame(width: screenWidth * 0.15, height: screenWidth * 0.15)
                                        Image("person")
                                            .resizable()
                                            .frame(width: screenWidth * 0.07, height: screenWidth * 0.07, alignment: .center)
                                    }
                                }
                            }.offset(x:screenWidth * 0.15)
                        }.padding(.bottom, screenHeight * 0.05)
                        .padding(.horizontal, screenWidth * 0.1)
                    }
                    let conditionOffset = self.offset + screenHeight - self.keyboardHeight
                    IdentifyChargerView(isShowingListOfChargers: $isShowingListOfChargers)
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
                            let maxHeight = screenHeight / 2.5
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
            }.background(Color(red: 0.2, green: 0.2, blue: 0.2).ignoresSafeArea(.all))
        }.navigationBarHidden(true)
    }
    func onChange() {
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastOffset
        }
    }
    func cameraButton() {
        // Function to open camera and and scan qrcode and return a charer id
    }
    func findUserOnMap() {
        // Find the user on the map
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
