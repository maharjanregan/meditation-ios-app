import SwiftUI

enum AppTab: Hashable {
    case today, learn, practice, reflect
}

final class AppState: ObservableObject {
    @Published var selectedTab: AppTab = .today
}
