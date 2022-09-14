//
//  FlexiChargeApp.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-06.
//

import SwiftUI

@main
struct FlexiChargeApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var AccountApi = AccountAPI()
    
    var body: some Scene {
        WindowGroup {
            startView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.light)
        }

    }
    func startView() -> some View{
        if (AccountApi.isLoggedIn){
            return AnyView(ContentView())
        }
        else{
            return AnyView(RegisterAccountView())
        }
    }
}

