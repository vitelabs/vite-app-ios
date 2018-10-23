//
//  AuthenticationDataManager.swift
//  Vite
//
//  Created by haoshenyang on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import LocalAuthentication

enum BiometryAuthenticationType: CustomStringConvertible {

    case none
    case touchID
    case faceID

    var description: String {
        switch self {
        case .none: return "None"
        case .touchID: return "Touch ID"
        case .faceID: return "Face ID"
        }
    }

    static var current: BiometryAuthenticationType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch authContext.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            }
        } else {
            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
        }
    }

}

final class BiometryAuthenticationManager {

    static let shared = BiometryAuthenticationManager()

    private init() {}

    func authenticate(reason: String, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let context = LAContext()
        context.localizedFallbackTitle = ""
        var authError: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                DispatchQueue.main.async {
                    completion(success, error)
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(false, authError)
            }
        }
    }
}
