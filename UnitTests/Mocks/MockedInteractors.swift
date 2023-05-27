//
//  MockedInteractors.swift
//  UnitTests
//
//  Created by Alexey Naumov on 07.11.2019.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//

import Combine
@testable import CountriesSwiftUI
import SwiftUI
import ViewInspector
import XCTest

extension DIContainer.Interactors {
    static func mocked(
        countriesInteractor: [MockedCountriesInteractor.Action] = [],
        imagesInteractor: [MockedImagesInteractor.Action] = [],
        permissionsInteractor: [MockedUserPermissionsInteractor.Action] = []
    ) -> DIContainer.Interactors {
        .init(countriesInteractor: MockedCountriesInteractor(expected: countriesInteractor),
              imagesInteractor: MockedImagesInteractor(expected: imagesInteractor),
              userPermissionsInteractor: MockedUserPermissionsInteractor(expected: permissionsInteractor))
    }

    func verify(file: StaticString = #file, line: UInt = #line) {
        (countriesInteractor as? MockedCountriesInteractor)?
            .verify(file: file, line: line)
        (imagesInteractor as? MockedImagesInteractor)?
            .verify(file: file, line: line)
        (userPermissionsInteractor as? MockedUserPermissionsInteractor)?
            .verify(file: file, line: line)
    }
}

// MARK: - CountriesInteractor

struct MockedCountriesInteractor: Mock, CountriesInteractor {
    enum Action: Equatable {
        case refreshCountriesList
        case loadCountries(search: String, locale: Locale)
        case loadCountryDetails(Country)
    }

    let actions: MockActions<Action>

    init(expected: [Action]) {
        actions = .init(expected: expected)
    }

    func refreshCountriesList() -> AnyPublisher<Void, Error> {
        register(.refreshCountriesList)
        return Just<Void>.withErrorType(Error.self)
    }

    func load(countries _: LoadableSubject<LazyList<Country>>, search: String, locale: Locale) {
        register(.loadCountries(search: search, locale: locale))
    }

    func load(countryDetails _: LoadableSubject<Country.Details>, country: Country) {
        register(.loadCountryDetails(country))
    }
}

// MARK: - ImagesInteractor

struct MockedImagesInteractor: Mock, ImagesInteractor {
    enum Action: Equatable {
        case loadImage(URL?)
    }

    let actions: MockActions<Action>

    init(expected: [Action]) {
        actions = .init(expected: expected)
    }

    func load(image _: LoadableSubject<UIImage>, url: URL?) {
        register(.loadImage(url))
    }
}

// MARK: - ImagesInteractor

class MockedUserPermissionsInteractor: Mock, UserPermissionsInteractor {
    enum Action: Equatable {
        case resolveStatus(Permission)
        case request(Permission)
    }

    let actions: MockActions<Action>

    init(expected: [Action]) {
        actions = .init(expected: expected)
    }

    func resolveStatus(for permission: Permission) {
        register(.resolveStatus(permission))
    }

    func request(permission: Permission) {
        register(.request(permission))
    }
}
