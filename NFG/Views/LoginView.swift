import SwiftUI

struct LoginView: View {
    @State private var showingDriverLogin = false
    @State private var showingAdminLogin = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Logo
            Image(isDarkMode ? "nfg-logo-darkmode" : "nfg_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .padding(.bottom, 40)
            
            Spacer()
            
            // Driver Sign-In Button
            Button(action: {
                showingDriverLogin = true
            }) {
                Text("Sign In as Driver")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.nfgBlue)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 20)
            .fullScreenCover(isPresented: $showingDriverLogin) {
                DriverLoginView(isPresented: $showingDriverLogin)
            }
            
            // Admin Sign-In Button
            Button(action: {
                showingAdminLogin = true
            }) {
                HStack {
                    Image(systemName: "person.badge.key.fill")
                        .font(.system(size: 20, weight: .light))
                        .foregroundColor(Color.nfgBlue)
                    Text("Sign In as Admin")
                        .font(.headline.weight(.bold))
                        .foregroundColor(Color.nfgBlue)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.nfgBlue, lineWidth: 1)
                )
            }
            .padding(.horizontal, 20)
            .fullScreenCover(isPresented: $showingAdminLogin) {
                AdminLoginView(isPresented: $showingAdminLogin)
            }
            
            Spacer()
        }
        .background(Color(UIColor.systemBackground))
    }
}

struct DriverLoginView: View {
    @Binding var isPresented: Bool
    @StateObject private var authManager = AuthManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var showingDriverDashboard = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        VStack(spacing: 30) {
            // Close button
            HStack {
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
            Spacer()
            
            // Logo
            Image(isDarkMode ? "nfg-logo-darkmode" : "nfg_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
                .padding(.bottom, 20)
            
            // Email Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .font(.baskervilleMedium(size: 16))
                    .foregroundColor(.nfgBlue)
                TextField("Enter your email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color(.systemGray6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.nfgBlue, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 20)
            
            // Password Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .font(.baskervilleMedium(size: 16))
                    .foregroundColor(.nfgBlue)
                SecureField("Enter your password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color(.systemGray6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.nfgBlue, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Sign In Button
            Button(action: {
                signIn()
            }) {
                Text("Sign In as Driver")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.nfgBlue)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 20)
            .fullScreenCover(isPresented: $showingDriverDashboard) {
                DriverHomeView(isPresented: $showingDriverDashboard)
            }
            
            Spacer()
        }
        .background(Color(UIColor.systemBackground))
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password"
            showingError = true
            return
        }
        
        authManager.login(email: email, password: password) { result in
            switch result {
            case .success:
                if !authManager.isAdmin {
                    showingDriverDashboard = true
                } else {
                    errorMessage = "Please use the admin login for admin accounts"
                    showingError = true
                }
            case .failure(let error):
                errorMessage = error.localizedDescription
                showingError = true
            }
        }
    }
}

struct AdminLoginView: View {
    @Binding var isPresented: Bool
    @StateObject private var authManager = AuthManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var showingAdminDashboard = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        VStack(spacing: 30) {
            // Close button
            HStack {
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
            Spacer()
            
            // Logo
            Image(isDarkMode ? "nfg-logo-darkmode" : "nfg_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
                .padding(.bottom, 20)
            
            // Email Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .font(.baskervilleMedium(size: 16))
                    .foregroundColor(.nfgBlue)
                TextField("Enter your email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color(.systemGray6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.nfgBlue, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 20)
            
            // Password Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .font(.baskervilleMedium(size: 16))
                    .foregroundColor(.nfgBlue)
                SecureField("Enter your password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color(.systemGray6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.nfgBlue, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Sign In Button
            Button(action: {
                signIn()
            }) {
                HStack {
                    Image(systemName: "person.badge.key.fill")
                        .font(.system(size: 20, weight: .light))
                        .foregroundColor(.white)
                    Text("Sign In as Admin")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.nfgBlue)
                .cornerRadius(25)
            }
            .padding(.horizontal, 20)
            .fullScreenCover(isPresented: $showingAdminDashboard) {
                AdminHomeView(isPresented: $showingAdminDashboard)
            }
            
            Spacer()
        }
        .background(Color(UIColor.systemBackground))
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password"
            showingError = true
            return
        }
        
        authManager.login(email: email, password: password) { result in
            switch result {
            case .success:
                if authManager.isAdmin {
                    showingAdminDashboard = true
                } else {
                    errorMessage = "Please use the driver login for driver accounts"
                    showingError = true
                }
            case .failure(let error):
                errorMessage = error.localizedDescription
                showingError = true
            }
        }
    }
}

struct AdminHomeView: View {
    @Binding var isPresented: Bool
    @State private var selectedTab: AdminTab = .home
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    AdminHomeTabView()
                        .tag(AdminTab.home)
                    
                    AdminNotificationsTabView()
                        .tag(AdminTab.notifications)
                    
                    AdminProfileTabView()
                        .tag(AdminTab.profile)
                }
                
                AdminTabBar(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct AdminHomeTabView: View {
    @State private var showingManageDrivers = false
    @State private var showingReceiptViewer = false
    @State private var showingStatusUpdates = false
    @State private var showingReportsAnalytics = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.colorScheme) var systemColorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            Image(isDarkMode ? "nfg-logo-darkmode" : "nfg_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
                .padding(.top, 90)
            
            Spacer()
            
            // Manage Drivers Button
            Button(action: {
                showingManageDrivers = true
            }) {
                HStack {
                    Image(systemName: "person.2")
                        .foregroundColor(.white)
                    Text("Manage Drivers")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.nfgBlue)
                .cornerRadius(25)
            }
            .padding(.horizontal, 20)
            .sheet(isPresented: $showingManageDrivers) {
                ManageDriversView()
            }
            
            // Receipt Viewer Button
            Button(action: {
                showingReceiptViewer = true
            }) {
                HStack {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(Color.nfgBlue)
                    Text("Receipt Viewer")
                        .foregroundColor(Color.nfgBlue)
                        .fontWeight(.bold)
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isDarkMode ? Color(.systemBackground) : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.nfgBlue, lineWidth: 1)
                )
            }
            .padding(.horizontal, 20)
            .sheet(isPresented: $showingReceiptViewer) {
                ReceiptViewerView()
            }
            
            // Status Updates Button
            Button(action: {
                showingStatusUpdates = true
            }) {
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(.white)
                    Text("Status Updates")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.nfgBlue)
                .cornerRadius(25)
            }
            .padding(.horizontal, 20)
            .sheet(isPresented: $showingStatusUpdates) {
                StatusUpdatesView()
            }
            
            // Reports / Analytics Button
            Button(action: {
                showingReportsAnalytics = true
            }) {
                HStack {
                    Image(systemName: "chart.bar.doc.horizontal")
                        .foregroundColor(Color.nfgBlue)
                    Text("Reports / Analytics")
                        .foregroundColor(Color.nfgBlue)
                        .fontWeight(.bold)
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isDarkMode ? Color(.systemBackground) : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.nfgBlue, lineWidth: 1)
                )
            }
            .padding(.horizontal, 20)
            .sheet(isPresented: $showingReportsAnalytics) {
                ReportsAnalyticsView()
            }
            
            Spacer()
        }
        .background(Color.backgroundColor(for: systemColorScheme))
        .edgesIgnoringSafeArea(.all)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

struct AdminNotificationsTabView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.colorScheme) var systemColorScheme
    
    var body: some View {
        VStack {
            Text("Notifications")
                .font(.baskervilleMedium(size: 24))
                .foregroundColor(.nfgBlue)
                .padding(.top, 40)
            Spacer()
        }
        .background(Color.backgroundColor(for: systemColorScheme))
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

struct AdminProfileTabView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @Environment(\.colorScheme) var systemColorScheme
    @State private var showingProfileDetails = false
    @State private var showingRoleSelection = false
    
    let userName = "Napi"
    let userEmail = "admin@nfglogistics.net"
    
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
            AdminProfileDetailsView()
        }
        .fullScreenCover(isPresented: $showingRoleSelection) {
            RoleSelectionView()
        }
    }
}

struct AdminProfileDetailsView: View {
    @Environment(\.colorScheme) var systemColorScheme
    @Environment(\.dismiss) var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    let userName = "Napi"
    let userEmail = "admin@nfglogistics.net"
    let userPhone = "(629) 345-8606"
    
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

struct ManageDriversView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.colorScheme) var systemColorScheme
    @State private var showingCreateDriver = false
    @State private var showingDriverList = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Manage Drivers")
                    .font(.baskervilleMedium(size: 24))
                    .foregroundColor(.nfgBlue)
                    .padding(.top, 40)
                
                Spacer()
                
                // Create New Driver Account Button
                Button(action: {
                    showingCreateDriver = true
                }) {
                    HStack {
                        Image(systemName: "person.badge.plus")
                            .foregroundColor(.white)
                        Text("Create a New Driver Account")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.nfgBlue)
                    .cornerRadius(25)
                }
                .padding(.horizontal, 20)
                
                // List of all Drivers Button
                Button(action: {
                    showingDriverList = true
                }) {
                    HStack {
                        Image(systemName: "list.bullet")
                            .foregroundColor(.nfgBlue)
                        Text("List of all Drivers")
                            .foregroundColor(.nfgBlue)
                            .fontWeight(.bold)
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isDarkMode ? Color(.systemBackground) : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.nfgBlue, lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .background(Color.backgroundColor(for: systemColorScheme))
            .navigationBarItems(trailing: Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            })
            .sheet(isPresented: $showingCreateDriver) {
                // TODO: Implement CreateDriverView
                Text("Create Driver View Coming Soon")
            }
            .sheet(isPresented: $showingDriverList) {
                // TODO: Implement DriverListView
                Text("Driver List View Coming Soon")
            }
        }
    }
}

struct ReceiptViewerView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.colorScheme) var systemColorScheme
    @State private var searchText = ""
    @State private var selectedReceiptType: ReceiptTypeFilter = .all
    @State private var selectedDateRange: DateRangeFilter = .today
    @State private var selectedStatus: StatusFilter = .all
    @State private var showingCustomDateRange = false
    @State private var customStartDate = Date()
    @State private var customEndDate = Date()
    @State private var showingReceiptDetail = false
    @State private var selectedReceipt: Receipt?
    
    // Sample receipts data
    let sampleReceipts: [Receipt] = [
        Receipt(id: "1", driverName: "John Doe", email: "john@example.com", type: .fuel, submissionDate: Date(), status: .notReviewed, imageURL: nil),
        Receipt(id: "2", driverName: "Jane Smith", email: "jane@example.com", type: .roadService, submissionDate: Date().addingTimeInterval(-86400), status: .reviewed, imageURL: nil),
        Receipt(id: "3", driverName: "Mike Johnson", email: "mike@example.com", type: .fuel, submissionDate: Date().addingTimeInterval(-172800), status: .notReviewed, imageURL: nil),
        Receipt(id: "4", driverName: "Sarah Williams", email: "sarah@example.com", type: .roadService, submissionDate: Date().addingTimeInterval(-259200), status: .reviewed, imageURL: nil),
        Receipt(id: "5", driverName: "David Brown", email: "david@example.com", type: .fuel, submissionDate: Date().addingTimeInterval(-345600), status: .notReviewed, imageURL: nil)
    ]
    
    var filteredReceipts: [Receipt] {
        sampleReceipts.filter { receipt in
            let matchesSearch = searchText.isEmpty ||
                receipt.driverName.localizedCaseInsensitiveContains(searchText) ||
                receipt.email.localizedCaseInsensitiveContains(searchText)
            
            let matchesType = selectedReceiptType == .all || receipt.type == selectedReceiptType.receiptType
            
            let matchesStatus = selectedStatus == .all || receipt.status == selectedStatus.receiptStatus
            
            return matchesSearch && matchesType && matchesStatus
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search by driver name or email", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                
                // Filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        // Receipt Type Filter
                        Menu {
                            Picker("Receipt Type", selection: $selectedReceiptType) {
                                ForEach(ReceiptTypeFilter.allCases, id: \.self) { type in
                                    Text(type.title).tag(type)
                                }
                            }
                        } label: {
                            FilterButton(title: selectedReceiptType.title, icon: "doc.text")
                        }
                        
                        // Date Range Filter
                        Menu {
                            Picker("Date Range", selection: $selectedDateRange) {
                                ForEach(DateRangeFilter.allCases, id: \.self) { range in
                                    Text(range.title).tag(range)
                                }
                            }
                        } label: {
                            FilterButton(title: selectedDateRange.title, icon: "calendar")
                        }
                        
                        // Status Filter
                        Menu {
                            Picker("Status", selection: $selectedStatus) {
                                ForEach(StatusFilter.allCases, id: \.self) { status in
                                    Text(status.title).tag(status)
                                }
                            }
                        } label: {
                            FilterButton(title: selectedStatus.title, icon: "checkmark.circle")
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                // Receipt List
                List(filteredReceipts) { receipt in
                    ReceiptRow(receipt: receipt)
                        .onTapGesture {
                            selectedReceipt = receipt
                            showingReceiptDetail = true
                        }
                }
                .listStyle(PlainListStyle())
            }
            .background(Color.backgroundColor(for: systemColorScheme))
            .navigationBarTitle("Receipt Viewer", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            })
            .sheet(isPresented: $showingReceiptDetail) {
                if let receipt = selectedReceipt {
                    ReceiptDetailView(receipt: receipt)
                }
            }
        }
    }
}

struct FilterButton: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
        }
        .font(.headline)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.nfgBlue)
        .foregroundColor(.white)
        .cornerRadius(25)
    }
}

struct ReceiptRow: View {
    let receipt: Receipt
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: receipt.type == .fuel ? "fuelpump.fill" : "wrench.fill")
                    .foregroundColor(.nfgBlue)
                Text(receipt.type.title)
                    .font(.baskervilleMedium(size: 18))
                    .foregroundColor(.nfgBlue)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: receipt.status == .reviewed ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(receipt.status == .reviewed ? .green : .gray)
                    Text(receipt.status == .reviewed ? "Reviewed" : "Pending")
                        .font(.baskervilleMedium(size: 14))
                        .foregroundColor(receipt.status == .reviewed ? .green : .gray)
                }
            }
            
            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(.nfgBlue)
                Text(receipt.driverName)
                Spacer()
                Image(systemName: "calendar")
                    .foregroundColor(.nfgBlue)
                Text(receipt.formattedDate)
            }
            .font(.baskervilleMedium(size: 16))
            .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.nfgBlue)
                Text(receipt.formattedTime)
                Spacer()
            }
            .font(.baskervilleMedium(size: 16))
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct ReceiptDetailView: View {
    let receipt: Receipt
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Receipt Info
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Receipt Details")
                            .font(.baskervilleMedium(size: 24))
                            .foregroundColor(.nfgBlue)
                        
                        DetailRow(label: "Driver Name", value: receipt.driverName)
                        DetailRow(label: "Email", value: receipt.email)
                        DetailRow(label: "Type", value: receipt.type.title)
                        DetailRow(label: "Submission Date", value: receipt.formattedDate)
                        DetailRow(label: "Submission Time", value: receipt.formattedTime)
                        DetailRow(label: "Status", value: receipt.status.title)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Receipt Image Placeholder
                    if receipt.imageURL == nil {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 200)
                            .overlay(
                                Text("Receipt Image")
                                    .foregroundColor(.gray)
                            )
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationBarTitle("Receipt Details", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            })
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.baskervilleMedium(size: 16))
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.baskervilleMedium(size: 16))
                .foregroundColor(.primary)
        }
    }
}

// Enums and Models
enum ReceiptTypeFilter: String, CaseIterable {
    case all = "All Types"
    case fuel = "Fuel"
    case roadService = "Road Service"
    
    var title: String { rawValue }
    
    var receiptType: Receipt.ReceiptType? {
        switch self {
        case .all: return nil
        case .fuel: return .fuel
        case .roadService: return .roadService
        }
    }
}

enum DateRangeFilter: String, CaseIterable {
    case today = "Today"
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    case custom = "Custom Range"
    
    var title: String { rawValue }
}

enum StatusFilter: String, CaseIterable {
    case all = "All Statuses"
    case reviewed = "Reviewed"
    case notReviewed = "Not Reviewed"
    
    var title: String { rawValue }
    
    var receiptStatus: Receipt.ReceiptStatus? {
        switch self {
        case .all: return nil
        case .reviewed: return .reviewed
        case .notReviewed: return .notReviewed
        }
    }
}

struct Receipt: Identifiable {
    let id: String
    let driverName: String
    let email: String
    let type: ReceiptType
    let submissionDate: Date
    let status: ReceiptStatus
    let imageURL: URL?
    
    enum ReceiptType {
        case fuel
        case roadService
        
        var title: String {
            switch self {
            case .fuel: return "Fuel Receipt"
            case .roadService: return "Road Service Receipt"
            }
        }
    }
    
    enum ReceiptStatus {
        case reviewed
        case notReviewed
        
        var title: String {
            switch self {
            case .reviewed: return "Reviewed"
            case .notReviewed: return "Not Reviewed"
            }
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: submissionDate)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: submissionDate)
    }
}

enum AdminTab: String, CaseIterable {
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

struct AdminTabBar: View {
    @Binding var selectedTab: AdminTab
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.colorScheme) var systemColorScheme
    
    var body: some View {
        HStack {
            ForEach(AdminTab.allCases, id: \.self) { tab in
                Spacer()
                TabBarButton(
                    isSelected: selectedTab == tab,
                    icon: tab.icon,
                    label: tab.rawValue
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.bottom, 10)
        .background(Color.backgroundColor(for: systemColorScheme))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.gray.opacity(0.2)),
            alignment: .top
        )
    }
}

struct StatusUpdatesView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.colorScheme) var systemColorScheme
    @State private var searchText = ""
    @State private var selectedDate = Date()
    @State private var selectedStatusType: StatusTypeFilter = .all
    @State private var showingStatusDetail = false
    @State private var selectedStatus: StatusUpdate?
    
    // Sample status updates data
    let sampleStatusUpdates: [StatusUpdate] = [
        StatusUpdate(id: "1", driverName: "John Doe", email: "johndoe@gmail.com", type: .onSiteAtShipper, date: Date(), time: Date()),
        StatusUpdate(id: "2", driverName: "Jane Smith", email: "janesmith@gmail.com", type: .loaded, date: Date().addingTimeInterval(-3600), time: Date().addingTimeInterval(-3600)),
        StatusUpdate(id: "3", driverName: "Mike Johnson", email: "mikejohnson@gmail.com", type: .onSiteAtReceiver, date: Date().addingTimeInterval(-7200), time: Date().addingTimeInterval(-7200)),
        StatusUpdate(id: "4", driverName: "Sarah Williams", email: "sarahwilliams@gmail.com", type: .emptied, date: Date().addingTimeInterval(-10800), time: Date().addingTimeInterval(-10800)),
        StatusUpdate(id: "5", driverName: "David Brown", email: "davidbrown@gmail.com", type: .onSiteAtShipper, date: Date().addingTimeInterval(-14400), time: Date().addingTimeInterval(-14400))
    ]
    
    var filteredStatusUpdates: [StatusUpdate] {
        sampleStatusUpdates.filter { status in
            let matchesSearch = searchText.isEmpty ||
                status.driverName.localizedCaseInsensitiveContains(searchText)
            
            let matchesType = selectedStatusType == .all || status.type == selectedStatusType.statusType
            
            return matchesSearch && matchesType
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search by driver name", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                
                // Date Picker
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .padding(.horizontal)
                
                // Status Type Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(StatusTypeFilter.allCases, id: \.self) { type in
                            Button(action: {
                                selectedStatusType = type
                            }) {
                                StatusFilterButton(
                                    title: type.title,
                                    icon: type.icon,
                                    isSelected: selectedStatusType == type
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                // Status Updates List
                List(filteredStatusUpdates) { status in
                    StatusUpdateRow(status: status)
                        .onTapGesture {
                            selectedStatus = status
                            showingStatusDetail = true
                        }
                }
                .listStyle(PlainListStyle())
            }
            .background(Color.backgroundColor(for: systemColorScheme))
            .navigationBarTitle("Status Updates", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            })
            .sheet(isPresented: $showingStatusDetail) {
                if let status = selectedStatus {
                    StatusUpdateDetailView(status: status)
                }
            }
        }
    }
}

struct StatusUpdateRow: View {
    let status: StatusUpdate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "truck")
                    .foregroundColor(.nfgBlue)
                Text(status.driverName)
                    .font(.baskervilleMedium(size: 18))
                    .foregroundColor(.nfgBlue)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Reviewed")
                        .font(.baskervilleMedium(size: 14))
                        .foregroundColor(.green)
                }
            }
            
            HStack {
                Image(systemName: "mappin")
                    .foregroundColor(.nfgBlue)
                Text(status.type.title)
                    .font(.baskervilleMedium(size: 16))
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.nfgBlue)
                Text("\(status.formattedDate) — \(status.formattedTime)")
                    .font(.baskervilleMedium(size: 16))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

struct StatusUpdateDetailView: View {
    let status: StatusUpdate
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Status Update Details")
                        .font(.baskervilleMedium(size: 24))
                        .foregroundColor(.nfgBlue)
                    
                    DetailRow(label: "Driver", value: status.driverName)
                    DetailRow(label: "Email", value: status.email)
                    DetailRow(label: "Status", value: status.type.title)
                    DetailRow(label: "Date", value: status.formattedDate)
                    DetailRow(label: "Time", value: status.formattedTime)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Status Details", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            })
        }
    }
}

struct StatusFilterButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
        }
        .font(.headline)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(isSelected ? Color.nfgBlue : Color.white)
        .foregroundColor(isSelected ? .white : .nfgBlue)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.nfgBlue, lineWidth: 1)
        )
        .cornerRadius(25)
    }
}

enum StatusTypeFilter: String, CaseIterable {
    case all = "All Statuses"
    case onSiteAtShipper = "On Site at Shipper"
    case loaded = "Loaded"
    case onSiteAtReceiver = "On Site at Receiver"
    case emptied = "Emptied"
    
    var title: String { rawValue }
    
    var icon: String {
        switch self {
        case .all: return "list.bullet"
        case .onSiteAtShipper: return "building.2"
        case .loaded: return "shippingbox"
        case .onSiteAtReceiver: return "building.2.fill"
        case .emptied: return "cube.box"
        }
    }
    
    var statusType: StatusUpdate.StatusType? {
        switch self {
        case .all: return nil
        case .onSiteAtShipper: return .onSiteAtShipper
        case .loaded: return .loaded
        case .onSiteAtReceiver: return .onSiteAtReceiver
        case .emptied: return .emptied
        }
    }
}

struct StatusUpdate: Identifiable {
    let id: String
    let driverName: String
    let email: String
    let type: StatusType
    let date: Date
    let time: Date
    
    enum StatusType {
        case onSiteAtShipper
        case loaded
        case onSiteAtReceiver
        case emptied
        
        var title: String {
            switch self {
            case .onSiteAtShipper: return "On Site at Shipper"
            case .loaded: return "Loaded"
            case .onSiteAtReceiver: return "On Site at Receiver"
            case .emptied: return "Emptied"
            }
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
}

struct ReportsAnalyticsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.colorScheme) var systemColorScheme
    @State private var showingSummaryCards = false
    @State private var showingCharts = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Reports & Analytics")
                    .font(.baskervilleMedium(size: 24))
                    .foregroundColor(.nfgBlue)
                    .padding(.top, 40)
                
                Spacer()
                
                // Summary Cards Button
                Button(action: {
                    showingSummaryCards = true
                }) {
                    HStack {
                        Image(systemName: "rectangle.grid.2x2")
                            .foregroundColor(.white)
                        Text("Summary Cards")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.nfgBlue)
                    .cornerRadius(25)
                }
                .padding(.horizontal, 20)
                
                // Charts Button
                Button(action: {
                    showingCharts = true
                }) {
                    HStack {
                        Image(systemName: "chart.bar.xaxis")
                            .foregroundColor(.nfgBlue)
                        Text("Charts")
                            .foregroundColor(.nfgBlue)
                            .fontWeight(.bold)
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isDarkMode ? Color(.systemBackground) : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.nfgBlue, lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .background(Color.backgroundColor(for: systemColorScheme))
            .navigationBarItems(trailing: Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            })
            .sheet(isPresented: $showingSummaryCards) {
                SummaryCardsView()
            }
            .sheet(isPresented: $showingCharts) {
                ChartsView()
            }
        }
    }
}

struct SummaryCardsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.colorScheme) var systemColorScheme
    
    // Sample data - in a real app, this would come from your data source
    let totalReceipts = 42
    let totalStatusUpdates = 156
    let activeDrivers = 18
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Weekly Summary")
                        .font(.baskervilleMedium(size: 24))
                        .foregroundColor(.nfgBlue)
                        .padding(.top, 20)
                    
                    // Total Receipts Card
                    SummaryCard(
                        title: "Total Receipts Submitted",
                        value: "\(totalReceipts)",
                        suffix: "this week.",
                        icon: "doc.on.doc",
                        color: .nfgBlue
                    )
                    
                    // Total Status Updates Card
                    SummaryCard(
                        title: "Total Status Updates",
                        value: "\(totalStatusUpdates)",
                        suffix: "this week.",
                        icon: "clock.arrow.circlepath",
                        color: .nfgBlue
                    )
                    
                    // Active Drivers Card
                    SummaryCard(
                        title: "Active Drivers",
                        value: "\(activeDrivers)",
                        suffix: "active this week.",
                        icon: "person.2",
                        color: .nfgBlue
                    )
                }
                .padding()
            }
            .background(Color.backgroundColor(for: systemColorScheme))
            .navigationBarItems(trailing: Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            })
        }
    }
}

struct SummaryCard: View {
    let title: String
    let value: String
    let suffix: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                Text(title)
                    .font(.baskervilleMedium(size: 18))
                    .foregroundColor(.black)
            }
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.baskervilleMedium(size: 36))
                    .foregroundColor(color)
                    .fontWeight(.bold)
                Text(suffix)
                    .font(.baskervilleMedium(size: 18))
                    .foregroundColor(.black)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ChartsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.colorScheme) var systemColorScheme
    @State private var showingReceiptSubmissionChart = false
    @State private var showingReceiptTypeChart = false
    @State private var showingDriverComparisonChart = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Analytics Charts")
                    .font(.baskervilleMedium(size: 24))
                    .foregroundColor(.nfgBlue)
                    .padding(.top, 40)
                
                Spacer()
                
                // Receipt Submission Over Time Button
                Button(action: {
                    showingReceiptSubmissionChart = true
                }) {
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundColor(.white)
                        Text("Receipt Submission Over Time")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.nfgBlue)
                    .cornerRadius(25)
                }
                .padding(.horizontal, 20)
                
                // Receipt Type Distribution Button
                Button(action: {
                    showingReceiptTypeChart = true
                }) {
                    HStack {
                        Image(systemName: "chart.pie")
                            .foregroundColor(.nfgBlue)
                        Text("Receipt Type Distribution")
                            .foregroundColor(.nfgBlue)
                            .fontWeight(.bold)
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isDarkMode ? Color(.systemBackground) : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.nfgBlue, lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                
                // Driver Comparison Button
                Button(action: {
                    showingDriverComparisonChart = true
                }) {
                    HStack {
                        Image(systemName: "chart.bar.xaxis")
                            .foregroundColor(.white)
                        Text("Driver Comparison")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.nfgBlue)
                    .cornerRadius(25)
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .background(Color.backgroundColor(for: systemColorScheme))
            .navigationBarItems(trailing: Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            })
            .sheet(isPresented: $showingReceiptSubmissionChart) {
                // TODO: Implement ReceiptSubmissionChartView
                Text("Receipt Submission Chart Coming Soon")
            }
            .sheet(isPresented: $showingReceiptTypeChart) {
                // TODO: Implement ReceiptTypeChartView
                Text("Receipt Type Chart Coming Soon")
            }
            .sheet(isPresented: $showingDriverComparisonChart) {
                // TODO: Implement DriverComparisonChartView
                Text("Driver Comparison Chart Coming Soon")
            }
        }
    }
}

#Preview {
    LoginView()
} 
