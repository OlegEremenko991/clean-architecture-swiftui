//
//  CountryDetails.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 25.10.2019.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//

import SwiftUI
import Combine

struct CountryDetails: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @Environment(\.locale) private var locale: Locale
    
    var body: some View {
        content
            .navigationBarTitle(viewModel.country.name(with: locale))
    }
    
    private var content: AnyView {
        switch viewModel.details {
        case .notRequested:
            return AnyView(notRequestedView)
        case .isLoading:
            return AnyView(loadingView)
        case let .loaded(details):
            return AnyView(loadedView(country: viewModel.country, details: details))
        case let .failed(error):
            return AnyView(failedView(error))
        }
    }
}

// MARK: - Loading Content
private extension CountryDetails {
    var notRequestedView: some View {
        Text("").onAppear {
            viewModel.loadCountryDetails()
        }
    }
    
    var loadingView: some View {
        VStack {
            ActivityIndicatorView()
            Button {
                viewModel.details.cancelLoading()
            } label: {
                Text("Cancel loading")
            }
        }
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error) {
            viewModel.loadCountryDetails()
        }
    }
}

// MARK: - Displaying Content
private extension CountryDetails {
    func loadedView(country: Country, details: Country.Details) -> some View {
        List {
            viewModel.country.flag.map { url in
                flagView(url: url)
            }
            basicInfoSectionView(country: country, details: details)
            if details.currencies.count > .zero {
                currenciesSectionView(currencies: details.currencies)
            }
            if details.neighbors.count > .zero {
                neighborsSectionView(neighbors: details.neighbors)
            }
        }
        .listStyle(GroupedListStyle())
        .sheet(
            isPresented: $viewModel.routingState.detailsSheet,
            content: { modalDetailsView() }
        )
    }
    
    func flagView(url: URL) -> some View {
        HStack {
            Spacer()
            SVGImageView(viewModel: .init(container: viewModel.container, imageURL: url))
                .frame(width: 120, height: 80)
                .onTapGesture {
                    viewModel.showCountryDetailsSheet()
                }
            Spacer()
        }
    }
    
    func basicInfoSectionView(country: Country, details: Country.Details) -> some View {
        Section(header: Text("Basic Info")) {
            DetailRow(
                leftLabel: Text(country.alpha3Code),
                rightLabel: "Code"
            )
            DetailRow(
                leftLabel: Text("\(country.population)"),
                rightLabel: "Population"
            )
            DetailRow(
                leftLabel: Text("\(details.capital)"),
                rightLabel: "Capital"
            )
        }
    }
    
    func currenciesSectionView(currencies: [Country.Currency]) -> some View {
        Section(header: Text("Currencies")) {
            ForEach(currencies) { currency in
                DetailRow(
                    leftLabel: Text(currency.title),
                    rightLabel: Text(currency.code)
                )
            }
        }
    }
    
    func neighborsSectionView(neighbors: [Country]) -> some View {
        Section(header: Text("Neighboring countries")) {
            ForEach(neighbors) { country in
                NavigationLink(destination: neighbourDetailsView(country: country)) {
                    DetailRow(
                        leftLabel: Text(country.name(with: locale)),
                        rightLabel: ""
                    )
                }
            }
        }
    }
    
    func neighbourDetailsView(country: Country) -> some View {
        CountryDetails(viewModel: .init(container: viewModel.container, country: country))
    }
    
    func modalDetailsView() -> some View {
        ModalDetailsView(viewModel: .init(
            container: viewModel.container, country: viewModel.country,
            isDisplayed: $viewModel.routingState.detailsSheet)
        )
    }
}

private extension Country.Currency {
    var title: String {
        name + (symbol.map {" " + $0} ?? "")
    }
}

// MARK: - Preview
#if DEBUG
struct CountryDetails_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetails(viewModel: .init(container: .preview, country: Country.mockedData[0]))
    }
}
#endif
