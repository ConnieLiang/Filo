import Foundation
import SwiftUI

/// A shared ViewModel that works on both iOS and macOS
@MainActor
class ItemViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init() {
        // Load sample data
        loadSampleData()
    }
    
    func loadSampleData() {
        items = [
            Item(title: "Welcome", description: "This is your first item"),
            Item(title: "Getting Started", description: "Add more items to your list"),
            Item(title: "Cross-Platform", description: "This app works on iOS and macOS")
        ]
    }
    
    func addItem(_ item: Item) {
        items.append(item)
    }
    
    func removeItem(at indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
    }
    
    func toggleCompleted(for item: Item) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
        }
    }
}
