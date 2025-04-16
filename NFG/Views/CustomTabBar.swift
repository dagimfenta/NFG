import SwiftUI

enum Tab: String, CaseIterable {
    case home = "Home"
    case notifications = "Notifications"
    case profile = "Profile"
    
    var icon: String {
        switch self {
        case .home: return "house"
        case .notifications: return "bell"
        case .profile: return "person"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.self) { tab in
                Spacer()
                TabBarButton(
                    isSelected: selectedTab == tab,
                    icon: tab.icon,
                    label: tab.rawValue
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.bottom, 10)
        .background(Color(UIColor.systemBackground))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.gray.opacity(0.2)),
            alignment: .top
        )
    }
}

struct TabBarButton: View {
    let isSelected: Bool
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .light))
                if isSelected {
                    Text(label)
                        .font(.caption.weight(.semibold))
                        .transition(.opacity.combined(with: .scale))
                }
            }
            .foregroundColor(isSelected ? Color(red: 0.4, green: 0.6, blue: 0.8) : .gray)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.home))
} 