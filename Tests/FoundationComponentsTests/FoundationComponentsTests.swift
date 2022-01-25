import XCTest
@testable import FoundationComponents

final class FoundationComponentsTests: XCTestCase {
    func testDateToString() throws {
        let date = Date(timeIntervalSince1970: 1643098564)
        
        XCTAssertEqual(date.toString(), "2022. 01. 25.")
    }
    
    func testStringToDate() throws {
        let dateString = "2022-01-25 12:00:00"
        let date = dateString.toDate()
        
        XCTAssertEqual(Calendar.current.component(.day, from: date!), 25)
    }
}

