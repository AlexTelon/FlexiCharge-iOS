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
                    .fill(Color.primaryDarkGray)
                    .frame(minHeight: 0, maxHeight: UsefulValues.screenHeight * 0.4)
                VStack {
                    Text(charge == 100 ? "Fully Charged" : "Charging in Progress").foregroundColor(.white)
                        .font(Font.system(size: 20, weight: .bold, design: .default))
                        .padding()
                    HStack(alignment: .top) {
                        //Charging loading screen
                        ZStack {
                            Circle()
                                .trim(from: 0.01, to: CGFloat(charge * 0.01))
                                .stroke(gradient, style: StrokeStyle(lineWidth: 9, lineCap: .round, lineJoin: .round))
                                .rotationEffect(.degrees(-90))
                                .frame(width: 95, height: 95)
                            VStack(alignment: .center) {
                                Image("charging-symbol").offset(y: 5)
                                HStack {
                                    Text("S").hidden()
                                        .font(Font.system(size: 10, design: .default))
//                                    Text("\(charge, specifier: "%.f")")
                                        .foregroundColor(.white)
                                        .font(Font.system(size: 32, design: .default))
                                        .offset(y: -8)
                                        .onReceive(timer) { _ in
                                            if charge < 100 {
                                                charge += 1
                                            }
                                        }
                                    VStack(alignment: .leading) {
                                        Text("%").foregroundColor(.white)
                                            .font(Font.system(size: 13, design: .default))
                                            .offset(x: -10, y: -5)
                                        Text("S").hidden()
                                    }
                                }
                            }
                        }
                        .frame(width: 90, height: 90)
                        Spacer()
                        //Charging information
                        VStack(spacing: 8) {
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
                                Text(charge == 100 ? "Battery full" : "Time to Done").foregroundColor(.white)
                            }
                            HStack {
                                Spacer()
                                Image("charging-symbol")
                                    .resizable()
                                    .frame(width: 10, height: 20)
                                Text("8,99kwh at 3kwh").foregroundColor(.white)
                            }
                        }
                        .font(Font.system(size: 18, design: .default))
                        .frame(width: UsefulValues.screenWidth * 0.65)
                    }
                    VStack{
                        VStack {
                            Text("Pull down to disconnect")
                                .foregroundColor(.white)
                                .font(Font.system(size: 12, design: .default))
                            Button(action: {
                                isShowingDisconnentButton = true
                            }, label: {
                                Image("menu-arrow")
                            }).animation(.none)
                        }
                        .opacity(isShowingDisconnentButton ? 0 : 1)
                        // Spacer instead of using padding
                        Button(action: {
                            isChargingInProgress = false
                            ChargerAPI().stopCharging(chargerID: chargingInProgressID)
                        }, label: {
                            Text(charge == 100 ? "Stop Charging" : "Disconnect")
                                .foregroundColor(.white)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(height: isShowingDisconnentButton ? 50 : 0)
                                .background(RoundedRectangle(cornerRadius: 25).stroke(Color.white))
                                .font(.system(size: 18))
                        })
                        .zIndex(isShowingDisconnentButton ? 2: -1)
                        Text("Spacer").hidden()
                    }
                }.frame(width: UsefulValues.screenWidth * 0.85)
            }
            
            //Loadingscreen Work in progress
            //            ZStack(alignment: .center) {
            //                RoundedRectangle(cornerRadius: 5)
            //                    .fill(Color.primaryDarkGray)
            //                    .frame(minHeight: 0, maxHeight: UsefulValues.screenHeight * 0.3)
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
            //                    }.frame(width: UsefulValues.screenWidth * 0.6)
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
