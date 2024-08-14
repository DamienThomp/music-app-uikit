//
//  Environment.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-08-14.
//

import Foundation

enum EnvironmentKeys: String {

    case authBaseUrl = "AUTH_BASE_URL"

    var value: String {
        self.rawValue
    }
}

enum Environment {

    static func getValue(for key: EnvironmentKeys) -> String? {

        guard let dict = Bundle.main.infoDictionary,
              let value = dict[key.value] as? String 
        else {

            fatalError("can't resolve value for \(key.value)")
        }

        return value
    }
}
