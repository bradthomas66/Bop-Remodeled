//
//  StringProtocol+asciiValues.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-11-16.
//

import Foundation

extension StringProtocol {
    var asciiValues: [UInt8] { compactMap(\.asciiValue) }
}
