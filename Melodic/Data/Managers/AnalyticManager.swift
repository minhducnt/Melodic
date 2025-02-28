//
//  AnalyticManager.swift
//  Melodic
//
//  Created by Admin on 28/2/25.
//

import FirebaseAnalytics
import Foundation

// MARK: - Analytics Manager

class AnalyticsManager {
    static let shared = AnalyticsManager()
    private init() {}

    // Log event

    func track(event: BaseEvent) {
        Analytics.logEvent(event.eventType, parameters: event.eventProperties)
    }

    // Log screen view

    static func logScreenView(screenName: String, screenClass: String? = nil) {
        let parameters: [String: Any] = [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: screenClass ?? screenName,
        ]
        Analytics.logEvent(AnalyticsEventScreenView, parameters: parameters)
    }
}

// MARK: - Properties

struct BaseEvent {
    let eventType: String
    let eventProperties: [String: Any]
}
