//
//  PulsaraApp.swift
//  Pulsara
//
//  Created by Gautam Jha on 22/04/26.
//

import SwiftUI

@main
struct PulsaraApp: App {
    @StateObject private var store = AppDataStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
        }
    }
}

struct RootView: View {
    @EnvironmentObject private var store: AppDataStore

    var body: some View {
        Group {
            switch store.currentRole {
            case .patient:
                HomeView()
            case .inspector:
                PatientListView()
            case nil:
                RoleSelectionView()
            }
        }
    }
}
