import XCTest
@testable import FoundationComponents

final class FoundationComponentsTests: XCTestCase {
    private var testDefaults: UserDefaults!

    override func setUp() {
        super.setUp()
        testDefaults = UserDefaults(suiteName: "UserDefaultTestSuite")
        testDefaults.removePersistentDomain(forName: "UserDefaultTestSuite")
    }
    
    override func tearDown() {
        testDefaults.removePersistentDomain(forName: "UserDefaultTestSuite")
        testDefaults = nil
        super.tearDown()
    }

    func test_UserDefault_SaveAndLoad() {
        // Given
        @UserDefault(key: "username", defaultValue: "Guest", userDefaults: testDefaults)
        var username: String

        // When
        username = "John"

        // Then
        XCTAssertEqual(username, "John")
        XCTAssertEqual(testDefaults.string(forKey: "username"), "John")
    }

    func test_UserDefault_DefaultValue_WhenKeyMissing() {
        // Given
        @UserDefault(key: "isPremium", defaultValue: false, userDefaults: testDefaults)
        var isPremium: Bool

        // When/Then
        XCTAssertFalse(isPremium)
    }

    func test_UserDefault_UpdateValue() {
        // Given
        @UserDefault(key: "count", defaultValue: 0, userDefaults: testDefaults)
        var count: Int

        // When
        count = 5
        count = 10

        // Then
        XCTAssertEqual(count, 10)
    }
    
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

