//
//  ContentView.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 23.10.2019.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//

import SwiftUI
import Combine

// MARK: - View

struct ContentView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        Group {
            if viewModel.isRunningTests {
                Text("Running unit tests")
            } else {
                CountriesList(viewModel: .init(container: viewModel.container))
                    .modifier(RootViewAppearance())
            }
        }
    }
}

// MARK: - ViewModel

extension ContentView {
    class ViewModel: ObservableObject {
        
        let container: DIContainer
        let isRunningTests: Bool
        
        init(container: DIContainer, isRunningTests: Bool = ProcessInfo.processInfo.isRunningTests) {
            self.container = container
            self.isRunningTests = isRunningTests
        }
    }
}

// MARK: - Preview

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentView.ViewModel(container: .preview))
    }
}
#endif
