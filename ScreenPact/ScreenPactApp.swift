//
//  ScreenPactApp.swift
//  ScreenPact
//
//  Created by David Powers on 11/29/21.
//

import SwiftUI

@main
struct ScreenPactApp: App {
    @State private var authState = AuthState.unknown
    
    var body: some Scene {
        WindowGroup {
            switch(authState) {
            case .unknown: RequestAuthorizationView(authState: $authState)
            case .unauthorized(let reason): Text("Unauthorized: \(reason)")
            case .authorized: ContentView()
            }
        }
    }
}
