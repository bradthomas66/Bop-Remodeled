//
//  NavBarAccessor.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-02-07.
//

import Foundation
import SwiftUI
import UIKit

struct NavBarAccessor: UIViewControllerRepresentable {
    
    let callback: (UINavigationBar) -> Void
    
    private let proxyController = ViewController()
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavBarAccessor>) -> some UIViewController {
        proxyController.callback = callback
        return proxyController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<NavBarAccessor>) {}
    
    private class ViewController: UIViewController {
        var callback:  (UINavigationBar) -> Void = { _ in }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let navBar = self.navigationController {
                self.callback (navBar.navigationBar)
            }
        }
    }
    
}
