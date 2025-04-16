import SwiftUI

struct ProfileTabView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @Environment(\.colorScheme) var systemColorScheme
    @State private var showingProfileDetails = false
    @State private var showingSupportHelp = false
    @State private var showingRoleSelection = false
    
    let userName = "Dagim Fenta"
    let userEmail = "dagimmfenta@gmail.com"
    
    var body: some View {
        VStack(spacing: 20) {
            // Header section
            VStack(spacing: 8) {
                Text(userName)
                    .font(.baskervilleMedium(size: 20))
                    .foregroundColor(.nfgBlue)
                
                Text(userEmail)
                    .font(.baskervilleMedium(size: 16))
                    .foregroundColor(.gray)
            }
            .padding(.top, 40)
            .padding(.bottom, 20)
            
            // Menu section
            VStack(spacing: 0) {
                // My Profile
                Button(action: { showingProfileDetails = true }) {
                    MenuRow(icon: "person", title: "My Profile")
                }
                
                VStack(spacing: 8) {
                    Divider()
                        .padding(.horizontal)
                        .background(isDarkMode ? Color.darkModeBg : Color.white)
                }
                
                // Notifications
                MenuRow(icon: "bell", title: "Notifications", showToggle: true, isToggled: $notificationsEnabled)
                
                VStack(spacing: 8) {
                    Divider()
                        .padding(.horizontal)
                        .background(isDarkMode ? Color.darkModeBg : Color.white)
                }
                
                // Dark Mode
                MenuRow(icon: "moon", title: "Dark Mode", showToggle: true, isToggled: $isDarkMode)
                
                VStack(spacing: 8) {
                    Divider()
                        .padding(.horizontal)
                        .background(isDarkMode ? Color.darkModeBg : Color.white)
                }
                
                // Support / Help
                Button(action: { showingSupportHelp = true }) {
                    MenuRow(icon: "questionmark.circle", title: "Support / Help")
                }
                
                VStack(spacing: 8) {
                    Divider()
                        .padding(.horizontal)
                        .background(isDarkMode ? Color.darkModeBg : Color.white)
                }
                
                // Log Out
                Button(action: { showingRoleSelection = true }) {
                    MenuRow(icon: "arrow.right.square", title: "Log Out", isDestructive: true)
                }
            }
            .padding(.horizontal)
            .cornerRadius(12)
            
            Spacer()
        }
        .background(Color.backgroundColor(for: systemColorScheme))
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .sheet(isPresented: $showingProfileDetails) {
            DriverProfileDetailsView()
        }
        .sheet(isPresented: $showingSupportHelp) {
            SupportHelpView()
        }
        .fullScreenCover(isPresented: $showingRoleSelection) {
            RoleSelectionView()
        }
    }
}

struct MenuRow: View {
    let icon: String
    let title: String
    var showToggle: Bool = false
    var isToggled: Binding<Bool>? = nil
    var isDestructive: Bool = false
    
    var body: some View {
        HStack(spacing: 24) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isDestructive ? .red : Color(red: 0.2, green: 0.4, blue: 0.8))
                .frame(width: 24)
            
            Text(title)
                .font(.baskervilleMedium(size: 17))
                .foregroundColor(isDestructive ? .red : .primary)
            
            Spacer()
            
            if showToggle, let isToggled = isToggled {
                Toggle("", isOn: isToggled)
                    .labelsHidden()
            } else {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray.opacity(0.5))
            }
        }
        .frame(height: 56)
        .padding(.horizontal, 16)
    }
}

struct DriverProfileDetailsView: View {
    @Environment(\.colorScheme) var systemColorScheme
    @Environment(\.dismiss) var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    let userName = "Dagim Fenta"
    let userEmail = "dagimmfenta@gmail.com"
    let userPhone = "(161) 596-74593"
    
    var body: some View {
        VStack(spacing: 20) {
            // Close button
            HStack {
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
            // Header section - matching ProfileTabView
            VStack(spacing: 8) {
                Text(userName)
                    .font(.baskervilleMedium(size: 20))
                    .foregroundColor(.nfgBlue)
                
                Text(userEmail)
                    .font(.baskervilleMedium(size: 16))
                    .foregroundColor(.gray)
            }
            .padding(.top, 20)
            .padding(.bottom, 20)
            
            // Profile information section
            VStack(spacing: 0) {
                ProfileDetailRow(label: "Name", value: userName)
                ProfileDetailRow(label: "Email account", value: userEmail)
                ProfileDetailRow(label: "Mobile number", value: userPhone)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .background(Color.backgroundColor(for: systemColorScheme))
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

struct ProfileDetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(label)
                    .font(.baskervilleMedium(size: 17))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(value)
                    .font(.baskervilleMedium(size: 17))
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 12)
            
            Divider()
                .background(Color.gray.opacity(0.3))
        }
    }
}

struct SupportHelpView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var systemColorScheme
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showingReceiptGuide = false
    @State private var showingStatusGuide = false
    @State private var showingFAQ = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Close button
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Contact Section
                        VStack(alignment: .leading, spacing: 24) {
                            Text("Contact")
                                .font(.baskervilleMedium(size: 22))
                                .foregroundColor(.gray)
                                .padding(.bottom, 4)
                            
                            // Email Support
                            HStack {
                                Text("Email Support")
                                    .font(.baskervilleMedium(size: 16))
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Link("info@nfglogistics.net", destination: URL(string: "mailto:info@nfglogistics.net")!)
                                    .font(.baskervilleMedium(size: 16))
                            }
                            
                            Divider()
                                .background(Color.gray.opacity(0.3))
                            
                            // Phone Support
                            HStack {
                                Text("Phone Support")
                                    .font(.baskervilleMedium(size: 16))
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Link("+1 629-345-8606", destination: URL(string: "tel:+16293458606")!)
                                    .font(.baskervilleMedium(size: 16))
                            }
                        }
                        
                        // Help Topics Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Help Topics")
                                .font(.baskervilleMedium(size: 22))
                                .foregroundColor(.gray)
                            
                            VStack(spacing: 12) {
                                // How to Submit Receipts
                                Button(action: { showingReceiptGuide = true }) {
                                    HStack {
                                        Text("How to Submit Receipts")
                                            .font(.baskervilleMedium(size: 16))
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 44)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                }
                                
                                // Understanding Status Updates
                                Button(action: { showingStatusGuide = true }) {
                                    HStack {
                                        Text("Understanding Status Updates")
                                            .font(.baskervilleMedium(size: 16))
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 44)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                }
                                
                                // Frequently Asked Questions
                                Button(action: { showingFAQ = true }) {
                                    HStack {
                                        Text("Frequently Asked Questions")
                                            .font(.baskervilleMedium(size: 16))
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 44)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }
            }
            .background(Color.backgroundColor(for: systemColorScheme))
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .sheet(isPresented: $showingReceiptGuide) {
                ReceiptSubmissionGuideView()
            }
            .sheet(isPresented: $showingStatusGuide) {
                StatusUpdatesGuideView()
            }
            .sheet(isPresented: $showingFAQ) {
                FAQView()
            }
        }
    }
}

struct ReceiptSubmissionGuideView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var systemColorScheme
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Title
                Text("How to Submit Receipts")
                    .font(.baskervilleMedium(size: 24))
                    .foregroundColor(.nfgBlue)
                    .padding(.top, 40)
                    .padding(.horizontal, 24)
                
                // Instructions
                VStack(alignment: .leading, spacing: 32) {
                    // Step 1
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Text("1")
                                .font(.baskervilleMedium(size: 16))
                                .foregroundColor(.white)
                                .frame(width: 28, height: 28)
                                .background(Circle().fill(Color.nfgBlue))
                            
                            HStack(spacing: 8) {
                                Image(systemName: "house")
                                    .foregroundColor(.nfgBlue)
                                Text("Go to the Home Screen")
                                    .font(.baskervilleMedium(size: 20))
                                    .foregroundColor(.nfgBlue)
                            }
                        }
                        
                        Text("Tap on the \"Receipts\" button from your home screen.")
                            .font(.baskervilleMedium(size: 16))
                            .foregroundColor(.black)
                            .padding(.leading, 40)
                    }
                    .padding(.horizontal, 24)
                    
                    // Step 2
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Text("2")
                                .font(.baskervilleMedium(size: 16))
                                .foregroundColor(.white)
                                .frame(width: 28, height: 28)
                                .background(Circle().fill(Color.nfgBlue))
                            
                            HStack(spacing: 8) {
                                Image(systemName: "list.bullet.rectangle")
                                    .foregroundColor(.nfgBlue)
                                Text("Select Receipt Type")
                                    .font(.baskervilleMedium(size: 20))
                                    .foregroundColor(.nfgBlue)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Choose the type of receipt you're submitting:")
                                .font(.baskervilleMedium(size: 16))
                                .foregroundColor(.black)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("• Fuel Receipt")
                                    .font(.baskervilleMedium(size: 16))
                                    .foregroundColor(.black)
                                Text("• Road Service Receipt")
                                    .font(.baskervilleMedium(size: 16))
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.leading, 40)
                    }
                    .padding(.horizontal, 24)
                    
                    // Step 3
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Text("3")
                                .font(.baskervilleMedium(size: 16))
                                .foregroundColor(.white)
                                .frame(width: 28, height: 28)
                                .background(Circle().fill(Color.nfgBlue))
                            
                            HStack(spacing: 8) {
                                Image(systemName: "camera")
                                    .foregroundColor(.nfgBlue)
                                Text("Upload the Receipt")
                                    .font(.baskervilleMedium(size: 20))
                                    .foregroundColor(.nfgBlue)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("You will be prompted to choose one of the following options:")
                                .font(.baskervilleMedium(size: 16))
                                .foregroundColor(.black)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 8) {
                                    Image(systemName: "camera.fill")
                                        .foregroundColor(.black)
                                    Text("Upload from Camera – Take a clear photo of the receipt.")
                                        .font(.baskervilleMedium(size: 16))
                                        .foregroundColor(.black)
                                }
                                HStack(spacing: 8) {
                                    Image(systemName: "photo.fill")
                                        .foregroundColor(.black)
                                    Text("Upload from Photos – Choose an existing photo from your gallery.")
                                        .font(.baskervilleMedium(size: 16))
                                        .foregroundColor(.black)
                                }
                            }
                            
                            // Tip Box
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.nfgBlue)
                                    Text("Make sure the entire receipt is visible and not blurry.")
                                        .font(.baskervilleMedium(size: 16))
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        .padding(.leading, 40)
                    }
                    .padding(.horizontal, 24)
                    
                    // Step 4
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Text("4")
                                .font(.baskervilleMedium(size: 16))
                                .foregroundColor(.white)
                                .frame(width: 28, height: 28)
                                .background(Circle().fill(Color.nfgBlue))
                            
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.up.circle")
                                    .foregroundColor(.nfgBlue)
                                Text("Submit")
                                    .font(.baskervilleMedium(size: 20))
                                    .foregroundColor(.nfgBlue)
                            }
                        }
                        
                        Text("After selecting the image, tap the Submit button to upload your receipt.")
                            .font(.baskervilleMedium(size: 16))
                            .foregroundColor(.black)
                            .padding(.leading, 40)
                    }
                    .padding(.horizontal, 24)
                    
                    // Step 5
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Text("5")
                                .font(.baskervilleMedium(size: 16))
                                .foregroundColor(.white)
                                .frame(width: 28, height: 28)
                                .background(Circle().fill(Color.nfgBlue))
                            
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.nfgBlue)
                                Text("Confirmation")
                                    .font(.baskervilleMedium(size: 20))
                                    .foregroundColor(.nfgBlue)
                            }
                        }
                        
                        Text("You will see a confirmation message once the receipt has been uploaded successfully.")
                            .font(.baskervilleMedium(size: 16))
                            .foregroundColor(.black)
                            .padding(.leading, 40)
                    }
                    .padding(.horizontal, 24)
                    
                    // Note
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Note:")
                            .font(.baskervilleMedium(size: 18))
                            .foregroundColor(.nfgBlue)
                        
                        Text("Admins will review submitted receipts.")
                            .font(.baskervilleMedium(size: 16))
                            .foregroundColor(.black)
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 24)
                }
            }
        }
        .background(Color.backgroundColor(for: systemColorScheme))
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .overlay(
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .padding()
            }
            .padding(.top, 8)
            .padding(.trailing, 8),
            alignment: .topTrailing
        )
    }
}

struct StatusUpdatesGuideView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var systemColorScheme
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Title
                Text("Understanding Status Updates")
                    .font(.baskervilleMedium(size: 24))
                    .foregroundColor(.nfgBlue)
                    .padding(.top, 40)
                    .padding(.horizontal, 24)
                
                // Instructions
                VStack(alignment: .leading, spacing: 32) {
                    // Step 1
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Text("1")
                                .font(.baskervilleMedium(size: 16))
                                .foregroundColor(.white)
                                .frame(width: 28, height: 28)
                                .background(Circle().fill(Color.nfgBlue))
                            
                            HStack(spacing: 8) {
                                Image(systemName: "house")
                                    .foregroundColor(.nfgBlue)
                                Text("Go to the Home Screen")
                                    .font(.baskervilleMedium(size: 20))
                                    .foregroundColor(.nfgBlue)
                            }
                        }
                        
                        Text("Tap the \"Status\" button from the home screen.")
                            .font(.baskervilleMedium(size: 16))
                            .foregroundColor(.black)
                            .padding(.leading, 40)
                    }
                    .padding(.horizontal, 24)
                    
                    // Step 2
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Text("2")
                                .font(.baskervilleMedium(size: 16))
                                .foregroundColor(.white)
                                .frame(width: 28, height: 28)
                                .background(Circle().fill(Color.nfgBlue))
                            
                            HStack(spacing: 8) {
                                Image(systemName: "list.bullet.rectangle")
                                    .foregroundColor(.nfgBlue)
                                Text("Choose Your Status Type")
                                    .font(.baskervilleMedium(size: 20))
                                    .foregroundColor(.nfgBlue)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("You'll see two options:")
                                .font(.baskervilleMedium(size: 16))
                                .foregroundColor(.black)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("• Pick Up")
                                    .font(.baskervilleMedium(size: 16))
                                    .foregroundColor(.black)
                                Text("• Drop Off")
                                    .font(.baskervilleMedium(size: 16))
                                    .foregroundColor(.black)
                            }
                            
                            Text("If you are picking up a shipment, select 'Pick Up'. If you are dropping off a shipment, select 'Drop Off'.")
                                .font(.baskervilleMedium(size: 16))
                                .foregroundColor(.black)
                        }
                        .padding(.leading, 40)
                    }
                    .padding(.horizontal, 24)
                    
                    // Step 3
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Text("3")
                                .font(.baskervilleMedium(size: 16))
                                .foregroundColor(.white)
                                .frame(width: 28, height: 28)
                                .background(Circle().fill(Color.nfgBlue))
                            
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.up.circle")
                                    .foregroundColor(.nfgBlue)
                                Text("Submit Status")
                                    .font(.baskervilleMedium(size: 20))
                                    .foregroundColor(.nfgBlue)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            // Pick Up Options
                            VStack(alignment: .leading, spacing: 4) {
                                Text("If you are picking up a shipment and clicked 'Pick Up' in the previous step, you will see two options:")
                                    .font(.baskervilleMedium(size: 16))
                                    .foregroundColor(.black)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("• On Sight at Shipper")
                                        .font(.baskervilleMedium(size: 16))
                                        .foregroundColor(.black)
                                    Text("• Loaded")
                                        .font(.baskervilleMedium(size: 16))
                                        .foregroundColor(.black)
                                }
                                .padding(.leading, 16)
                                
                                Text("If you get to the shipper to pick up a load, click 'On Sight at Shipper'. Once the truck is filled up, click 'Loaded'.")
                                    .font(.baskervilleMedium(size: 16))
                                    .foregroundColor(.black)
                            }
                            
                            // Drop Off Options
                            VStack(alignment: .leading, spacing: 4) {
                                Text("If you are dropping off a shipment and clicked 'Drop Off' in the previous step, you will see two options:")
                                    .font(.baskervilleMedium(size: 16))
                                    .foregroundColor(.black)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("• On Sight at Receiver")
                                        .font(.baskervilleMedium(size: 16))
                                        .foregroundColor(.black)
                                    Text("• Emptied")
                                        .font(.baskervilleMedium(size: 16))
                                        .foregroundColor(.black)
                                }
                                .padding(.leading, 16)
                                
                                Text("When you get to the receiver to drop off a load, click 'On Sight at Receiver'. Once the truck has been unpacked, click 'Emptied'.")
                                    .font(.baskervilleMedium(size: 16))
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.leading, 40)
                    }
                    .padding(.horizontal, 24)
                    
                    // Step 4
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Text("4")
                                .font(.baskervilleMedium(size: 16))
                                .foregroundColor(.white)
                                .frame(width: 28, height: 28)
                                .background(Circle().fill(Color.nfgBlue))
                            
                            HStack(spacing: 8) {
                                Image(systemName: "bell")
                                    .foregroundColor(.nfgBlue)
                                Text("Notification Sent to Admins")
                                    .font(.baskervilleMedium(size: 20))
                                    .foregroundColor(.nfgBlue)
                            }
                        }
                        
                        Text("Your update will be sent to the admin team.")
                            .font(.baskervilleMedium(size: 16))
                            .foregroundColor(.black)
                            .padding(.leading, 40)
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .background(Color.backgroundColor(for: systemColorScheme))
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .overlay(
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .padding()
            }
            .padding(.top, 8)
            .padding(.trailing, 8),
            alignment: .topTrailing
        )
    }
}

struct FAQView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var systemColorScheme
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        VStack {
            // Close button
            HStack {
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
            Spacer()
            
            // Coming Soon Message
            Text("FAQs are coming soon!")
                .font(.baskervilleMedium(size: 20))
                .foregroundColor(.nfgBlue)
            
            Spacer()
        }
        .background(Color.backgroundColor(for: systemColorScheme))
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

struct RoleSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var authManager = AuthManager.shared
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        LoginView()
            .onAppear {
                isDarkMode = false
                authManager.logout()
            }
    }
}

// Color extensions for theme support
extension Color {
    static func backgroundColor(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(.systemBackground) : .white
    }
    
    static let nfgBlue = Color(red: 0.4, green: 0.6, blue: 0.8)
    
    static let darkModeBg = Color(.systemBackground)
}

// Font extension for Baskerville
extension Font {
    static func baskervilleMedium(size: CGFloat) -> Font {
        .custom("Baskerville", size: size)
    }
}

#Preview {
    ProfileTabView()
} 