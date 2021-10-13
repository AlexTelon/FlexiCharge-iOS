//
//  TestKlarnaView.swift
//  FlexiCharge
//
//  Created by Daniel Göthe on 2021-10-06.
//

import SwiftUI

struct TestKlarnaView: View {
    
    let screenHeight = UIScreen.main.bounds.size.height
    let screenWidth = UIScreen.main.bounds.size.width
    @State private var isPresented = false

    var body: some View {
        HStack{
            Button(action: {
                isPresented = true
            }, label: {
                Text("Button")
            })
        }.frame(width: screenWidth, height: screenHeight)
        .sheet(isPresented: $isPresented) {
//            ViewController(isPresented: $isPresented, klarnaStatus: $klarnaStatus)
        }
    }
}

struct TestKlarnaView_Previews: PreviewProvider {
    static var previews: some View {
        TestKlarnaView()
    }
}
