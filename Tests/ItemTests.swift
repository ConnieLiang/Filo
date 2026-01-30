import XCTest
@testable import MyMultiplatformApp

final class ItemTests: XCTestCase {
    
    func testItemCreation() {
        let item = Item(title: "Test Item", description: "Test Description")
        
        XCTAssertEqual(item.title, "Test Item")
        XCTAssertEqual(item.description, "Test Description")
        XCTAssertFalse(item.isCompleted)
    }
    
    func testItemCompletion() {
        var item = Item(title: "Test", isCompleted: false)
        XCTAssertFalse(item.isCompleted)
        
        item.isCompleted = true
        XCTAssertTrue(item.isCompleted)
    }
    
    func testItemEquality() {
        let id = UUID()
        let item1 = Item(id: id, title: "Test")
        let item2 = Item(id: id, title: "Test")
        
        XCTAssertEqual(item1, item2)
    }
}
