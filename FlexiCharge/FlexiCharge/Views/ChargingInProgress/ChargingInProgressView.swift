//
//  ChargingInProgressView.swift
//  FlexiCharge
//
//  Created by Daniel Göthe on 2021-09-20.
//

import SwiftUI

struct ChargingInProgressView: View {
    @Binding var isShowingDisconnentButton: Bool
    @Binding var isChargingInProgress: Bool
    @Binding var chargingInProgressID: Int
    let screenHeight = UIScreen.main.bounds.size.height
    let screenWidth = UIScreen.main.bounds.size.width
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var charge: Double = 36.0
    private let gradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 0.25, green: 0.61, blue: 0.41), Color(red: 0.76, green: 0.83, blue: 0.20)]),
        startPoint: .top,
        endPoint: .bottom)
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                    .frame(minHeight: 0, maxHeight: screenHeight * 0.4)
                VStack {
                    Text(charge == 100 ? "Fully Charged" : "Charging in Progress").foregroundColor(.white)
                        .font(Font.system(size: 20, weight: .bold, design: .default))
                        .padding()
                    HStack {
                        //Charging loading screen
                        ZStack {
                            Circle()
                                .trim(from: 0.02, to: CGFloat(charge * 0.01))
                                .stroke(gradient, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                                .rotationEffect(.degrees(-90))
                            VStack {
                                Image("charging-symbol").offset(y: 7)
                                HStack {
                                    Text("S").hidden()
                                        .font(Font.system(size: 10, design: .default))
                                    Text("\(charge, specifier: "%.f")")
                                        .foregroundColor(.white)
                                        .font(Font.system(size: 20, design: .default))
                                        .offset(y: -5)
                                        .onReceive(timer) { _ in
                                            if charge < 100 {
                                                charge += 1
                                            }
                                        }
                                    VStack(alignment: .leading) {
                                        Text("%").foregroundColor(.white)
                                            .font(Font.system(size: 10, design: .default))
                                            .offset(x: -10, y: -5)
                                        Text("S").hidden()
                                    }
                                }
                            }
                        }.frame(width: 70, height: 70)
                        Spacer()
                        //Charging information
                        VStack {
                            HStack {
                                Spacer()
                                Image("location-pin")
                                    .resizable()
                                    .frame(width: 15, height: 20)
                                Text("Kungsgatan 1a, Jönköping").foregroundColor(.white)
                            }
                            HStack {
                                Spacer()
                                Image(systemName: "stopwatch")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                Text(charge == 100 ? "Fully Charged" : "Time to Done").foregroundColor(.white)
                            }
                            HStack {
                                Spacer()
                                Image("charging-symbol")
                                    .resizable()
                                    .frame(width: 10, height: 20)
                                Text("8,99kwh at 3kwh").foregroundColor(.white)
                            }
                        }.frame(width: screenWidth * 0.65)
                    }
                    VStack{
                        VStack {
                            Text(isShowingDisconnentButton == true ? "" : "Pull down to disconnect").foregroundColor(.white)
                                .font(Font.system(size: 10, design: .default))
                            Button(action: {
                                isShowingDisconnentButton = true
                            }, label: {
                                Image("menu-arrow").frame(maxHeight: isShowingDisconnentButton == true ? 0: 20 )
                            }).animation(.none)
                        }
                        Button(action: {
                            isChargingInProgress = false
                            ChargerAPI().stopCharging(chargerID: chargingInProgressID)
                        }, label: {
                            Text(charge == 100 ? "Stop Charging" : "Disconnect").foregroundColor(.white)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .font(.system(size: 18))
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.white, lineWidth: 1)).frame(maxHeight: isShowingDisconnentButton == true ? 50: 0 )
                        }).zIndex(isShowingDisconnentButton == true ? 2: -1)
                    }
                }.frame(width: screenWidth * 0.85, height: screenHeight * 0.35)
            }
            
            //Loadingscreen Work in progress
//            ZStack(alignment: .center) {
//                RoundedRectangle(cornerRadius: 5)
//                    .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
//                    .frame(minHeight: 0, maxHeight: screenHeight * 0.3)
//                VStack {
//                    Text("Charging Started")
//                        .foregroundColor(.white)
//                        .font(Font.system(size: 20, weight: .bold, design: .default))
//                    HStack {
//                        Image("logoIconColor")
//                        Spacer()
//                        Image("arrow-white")
//                        Spacer()
//                        Image("chargeStarting")
//                    }.frame(width: screenWidth * 0.6)
//                }
//            }.animation(.easeInOut(duration: 1))
        }
    }
}

struct ChargingInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ChargingInProgressView(isShowingDisconnentButton: .constant(false), isChargingInProgress: .constant(true), chargingInProgressID: .constant(0))
    }
}
