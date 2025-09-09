//
//  TestHelper.swift
//  CityFinderTests
//
//  Created by Mateo Giarrocco on 04/09/2025.
//

import XCTest
import Combine

extension XCTestCase {
    /// Espera a que un publisher emita un valor que cumpla una condición.
    @discardableResult
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        satisfies predicate: @escaping (T.Output) -> Bool,
        description: String,
        timeout: TimeInterval = 2.0,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> T.Output? where T.Failure == Never {
        let exp = expectation(description: description)
        var cancellable: AnyCancellable?
        var result: T.Output?

        cancellable = publisher
            //.drop(while: { !predicate($0) })
            .first(where: predicate)
            //.prefix(1)
            .sink { value in
                result = value
                exp.fulfill()
                //cancellable?.cancel()
            }

        wait(for: [exp], timeout: timeout)
        return result
    }
}
