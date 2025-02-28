//
//  ErrorHandler.swift
//  Melodic
//
//  Created by Admin on 28/2/25.
//

import FirebaseCrashlytics

class ErrorHandler {
    static func logError(message: String, error: Error) {
        Crashlytics.crashlytics().log(message)

        let nsError = error as NSError
        Crashlytics.crashlytics().record(error: nsError)
    }
}
