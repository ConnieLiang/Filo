import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "apple.logo")
                    .font(.system(size: 60))
                    .foregroundStyle(.primary)
                
                Text("Welcome to Filo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Running on \(platformName)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                // Add your content here
                
                Spacer()
            }
            .padding()
            .navigationTitle("Home")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
        }
    }
    
    private var platformName: String {
        #if os(iOS)
        return "iOS"
        #elseif os(macOS)
        return "macOS"
        #else
        return "Unknown Platform"
        #endif
    }
}

#Preview {
    ContentView()
}
