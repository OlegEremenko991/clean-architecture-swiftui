//
//  RootViewModifier.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 09.11.2019.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//

import SwiftUI
import Combine

// MARK: - RootViewAppearance

struct RootViewAppearance: ViewModifier {
    internal let inspection = Inspection<Self>()
    
    func body(content: Content) -> some View {
        content.onReceive(inspection.notice) {
            inspection.visit(self, $0)
        }
    }
}
