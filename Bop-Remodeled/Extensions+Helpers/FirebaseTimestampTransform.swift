//
//  FirebaseTimestampTransform.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-04-19.
//

import Foundation
import ObjectMapper
import Firebase

enum FirebaseDate {
    case date(Date)
    case serverTimestamp
    
    var date: Date {
        switch self {
            case .date (let date):
                return date
        case .serverTimestamp:
            return Date()
        }
    }
}

class FirebaseDateTransform: TransformType {

    public typealias Object = FirebaseDate
    public typealias JSON = Any
    
    open func transformFromJSON(_ value: Any?) -> FirebaseDate? {
        switch value {
        case is [AnyHashable: Any]?:
            return .serverTimestamp
        default:
            return nil
        }
    }
    
    open func transformToJSON(_ value: FirebaseDate?) -> Any? {
        switch value {
        case .serverTimestamp?:
            return ServerValue.timestamp()
        default:
            return nil
        }
    }
    
    func getFirebaseTimestamp() -> String {
        return String(transformFromJSON(ServerValue.timestamp())!.date.toMillis())
    }
}

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
