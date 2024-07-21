//
//  VKLoginView.swift
//  vkClient
//
//  Created by A Ch on 21.07.2024.
//

import SwiftUI

struct VKLoginView: UIViewControllerRepresentable {
    
    private let sheetViewController: UIViewController // TODO
    
    init(sheetViewController: UIViewController) {
        self.sheetViewController = sheetViewController
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return sheetViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    
}

struct VKLoginViewDetent: CustomPresentationDetent {
    static func height(in context: Context) -> CGFloat? {
        if context.verticalSizeClass == .regular { // TODO (height of screen)
            return context.maxDetentValue * 0.35
        } else {
            return context.maxDetentValue
        }
    }
}
