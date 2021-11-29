//
//  RequestAuthorizationView.swift
//  ScreenPact
//
//  Created by David Powers on 11/29/21.
//

import SwiftUI
import FamilyControls

enum AuthState {
    case unknown
    case unauthorized(reason: String)
    case authorized
}

struct RequestAuthorizationView: View {
    @Binding var authState : AuthState
    
    private func requestAuthorization() {
        AuthorizationCenter.shared.requestAuthorization { result  in
            switch result {
            case .success():
                logger.debug("Authorization for Family Controls succeeded")
                authState = AuthState.authorized
            case .failure(let error):
                logger.error("Authorization for Family Controls failed: \(error.localizedDescription)")
                authState = AuthState.unauthorized(reason: error.localizedDescription)
            }
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            switch authState {
            case AuthState.authorized: Spacer()
            case AuthState.unknown:
                Text("Checking Authorization Status")
                    .onAppear { requestAuthorization() }
            case AuthState.unauthorized(let reason):
                VStack {
                    Text("Authorization Failed: \(reason)")
                    Button(action: { requestAuthorization() }) {
                        Text("Request Authorization")
                    }
                }
            }
            Spacer()
        }
    }
}

struct RequestAuthorizationView_Previews: PreviewProvider {
    @State private static var authState = AuthState.unknown
    
    static var previews: some View {
        RequestAuthorizationView(authState: $authState)
    }
}
