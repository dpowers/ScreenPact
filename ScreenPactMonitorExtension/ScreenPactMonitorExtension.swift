//
//  ScreenPactMonitorExtension.swift
//  ScreenPactMonitorExtension
//
//  Created by David Powers on 11/29/21.
//

import Foundation

import Foundation
import DeviceActivity
import ManagedSettings

class ScreenPactMonitorExtension : DeviceActivityMonitor {
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        logger.debug("runnning intervalDidStart and setting all shields to nil")
        let store = ManagedSettingsStore()
        store.shield.applications = nil
    }
}
