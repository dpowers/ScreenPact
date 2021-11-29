//
//  ContentView.swift
//  ScreenPact
//
//  Created by David Powers on 11/29/21.
//

import SwiftUI
import FamilyControls
import ManagedSettings
import DeviceActivity

struct ContentView: View {
    @State private var showSelectionPicker = false
    @State private var appSelection = FamilyActivitySelection()
    
    private func updateSchedule() {
        logger.debug("updating schedule")
        let center = DeviceActivityCenter()
        let activityName = DeviceActivityName("Bubbahotep")
        let inOneMinute = Date().addingTimeInterval(60.0)
        let components = Calendar.current.dateComponents([.hour, .minute], from: inOneMinute)
        let schedule =
            DeviceActivitySchedule(
                intervalStart: DateComponents(hour: components.hour!, minute: components.minute!),
                intervalEnd: DateComponents(hour: 23, minute: 59),
                repeats: true)
        let eventName = DeviceActivityEvent.Name("Wake Up")
        var events : [DeviceActivityEvent.Name: DeviceActivityEvent] = [:]
        events[eventName] =
            DeviceActivityEvent(
                applications: appSelection.applicationTokens,
                threshold: DateComponents(minute: 5))
        logger.debug("ScreenPactMonitorExtension should wake up at\(components.hour!):\(components.minute!)")
        
        do {
            center.stopMonitoring([activityName])
            try center.startMonitoring(activityName, during: schedule, events: events)
        } catch {
            logger.error("Error monitoring schedule: \(error.localizedDescription)")
        }
    }
    
    private func updateShields() {
        logger.debug("updating shields")
        let store = ManagedSettingsStore()
        let applications = appSelection.applicationTokens
        logger.debug("blocking \(applications.count) apps")
        store.shield.applications = applications.isEmpty ? nil : applications
    }

    var body: some View {
        Form {
            Section {
                Button(action: { showSelectionPicker = true }) {
                    Text("Edit Blocked Apps")
                }
                Button(action: {
                    updateSchedule()
                    updateShields()
                    
                }) {
                    Text("Update Shields")
                }
            }
        }
        .familyActivityPicker(isPresented: $showSelectionPicker, selection: $appSelection)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
