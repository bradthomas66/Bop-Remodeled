//
//  UIApplication + endEditing .swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-04-12.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
