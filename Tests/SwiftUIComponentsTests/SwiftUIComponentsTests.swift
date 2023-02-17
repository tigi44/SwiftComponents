import XCTest
import SwiftUI
@testable import SwiftUIComponents

final class SwiftUIComponentsTests: XCTestCase {
    func testBinding() throws {
        let expectation = XCTestExpectation(description: self.description)
        
        var binding: Binding<String> = .constant("test")
        
        binding = binding.onChange { string in
            XCTAssertEqual(string, "test2")
            expectation.fulfill()
        }
        
        binding.wrappedValue = "test2"
        
        wait(for: [expectation], timeout: 10)
    }
}
