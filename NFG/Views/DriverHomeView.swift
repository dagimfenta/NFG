import SwiftUI

struct DriverHomeView: View {
    @Binding var isPresented: Bool
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    HomeTabView()
                        .tag(Tab.home)
                    
                    NotificationsTabView()
                        .tag(Tab.notifications)
                    
                    ProfileTabView()
                        .tag(Tab.profile)
                }
                
                CustomTabBar(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct HomeTabView: View {
    @State private var showingReceiptTypes = false
    @State private var showingStatusTypes = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(isDarkMode ? "nfg-logo-darkmode" : "nfg_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
                .padding(.top, 40)
            
            Spacer()
            
            // Receipts Button
            Button(action: {
                showingReceiptTypes = true
            }) {
                HStack {
                    Image(systemName: "doc.text.fill")
                        .foregroundColor(.white)
                    Text("Receipts")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.4, green: 0.6, blue: 0.8))
                .cornerRadius(25)
            }
            .padding(.horizontal, 20)
            .sheet(isPresented: $showingReceiptTypes) {
                ReceiptTypeSelectionView()
            }
            
            // Status Button
            Button(action: {
                showingStatusTypes = true
            }) {
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(Color.nfgBlue)
                    Text("Status")
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
            .sheet(isPresented: $showingStatusTypes) {
                StatusTypeSelectionView()
            }
            
            Spacer()
        }
        .background(Color(UIColor.systemBackground))
    }
}

struct NotificationsTabView: View {
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

struct ReceiptTypeSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingFuelReceiptUpload = false
    @State private var showingRoadServiceReceiptUpload = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Select Receipt Type")
                    .font(.baskervilleMedium(size: 24))
                    .foregroundColor(.nfgBlue)
                    .padding(.top, 40)
                
                Spacer()
                
                // Fuel Receipt Button
                Button(action: {
                    showingFuelReceiptUpload = true
                }) {
                    HStack {
                        Image(systemName: "fuelpump.fill")
                            .foregroundColor(.white)
                        Text("Fuel Receipt")
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
                
                // Road Service Receipt Button
                Button(action: {
                    showingRoadServiceReceiptUpload = true
                }) {
                    HStack {
                        Image(systemName: "wrench.fill")
                            .foregroundColor(.nfgBlue)
                        Text("Road Service Receipt")
                            .foregroundColor(.nfgBlue)
                            .fontWeight(.bold)
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.nfgBlue, lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .background(Color(UIColor.systemBackground))
            .navigationBarItems(trailing: Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            })
            .sheet(isPresented: $showingFuelReceiptUpload) {
                ReceiptUploadView(receiptType: .fuel)
            }
            .sheet(isPresented: $showingRoadServiceReceiptUpload) {
                ReceiptUploadView(receiptType: .roadService)
            }
        }
    }
}

struct StatusTypeSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingPickUpOptions = false
    @State private var showingDropOffOptions = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Select Status Type")
                    .font(.baskervilleMedium(size: 24))
                    .foregroundColor(.nfgBlue)
                    .padding(.top, 40)
                
                Spacer()
                
                // Pick Up Button
                Button(action: {
                    showingPickUpOptions = true
                }) {
                    HStack {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(.white)
                        Text("Pick Up")
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
                
                // Drop Off Button
                Button(action: {
                    showingDropOffOptions = true
                }) {
                    HStack {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.nfgBlue)
                        Text("Drop Off")
                            .foregroundColor(.nfgBlue)
                            .fontWeight(.bold)
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.nfgBlue, lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .background(Color(UIColor.systemBackground))
            .navigationBarItems(trailing: Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            })
            .sheet(isPresented: $showingPickUpOptions) {
                PickUpOptionsView()
            }
            .sheet(isPresented: $showingDropOffOptions) {
                DropOffOptionsView()
            }
        }
    }
}

struct PickUpOptionsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Pick Up Status")
                    .font(.baskervilleMedium(size: 24))
                    .foregroundColor(.nfgBlue)
                    .padding(.top, 40)
                
                Spacer()
                
                // On Sight at Shipper Button
                Button(action: {
                    // Handle on sight at shipper
                }) {
                    HStack {
                        Image(systemName: "building.2.fill")
                            .foregroundColor(.white)
                        Text("On Sight at Shipper")
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
                
                // Loaded Button
                Button(action: {
                    // Handle loaded status
                }) {
                    HStack {
                        Image(systemName: "shippingbox.fill")
                            .foregroundColor(.nfgBlue)
                        Text("Loaded")
                            .foregroundColor(.nfgBlue)
                            .fontWeight(.bold)
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.nfgBlue, lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .background(Color(UIColor.systemBackground))
            .navigationBarItems(trailing: Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            })
        }
    }
}

struct DropOffOptionsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Drop Off Status")
                    .font(.baskervilleMedium(size: 24))
                    .foregroundColor(.nfgBlue)
                    .padding(.top, 40)
                
                Spacer()
                
                // On Sight at Receiver Button
                Button(action: {
                    // Handle on sight at receiver
                }) {
                    HStack {
                        Image(systemName: "building.2.fill")
                            .foregroundColor(.white)
                        Text("On Sight at Receiver")
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
                
                // Emptied Button
                Button(action: {
                    // Handle emptied status
                }) {
                    HStack {
                        Image(systemName: "cube.box.fill")
                            .foregroundColor(.nfgBlue)
                        Text("Emptied")
                            .foregroundColor(.nfgBlue)
                            .fontWeight(.bold)
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.nfgBlue, lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .background(Color(UIColor.systemBackground))
            .navigationBarItems(trailing: Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            })
        }
    }
}

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

struct ReceiptUploadView: View {
    @Environment(\.dismiss) var dismiss
    let receiptType: ReceiptType
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Upload \(receiptType.title)")
                    .font(.baskervilleMedium(size: 24))
                    .foregroundColor(.nfgBlue)
                    .padding(.top, 40)
                
                Spacer()
                
                // Camera Upload Button
                Button(action: {
                    // Handle camera upload
                }) {
                    HStack {
                        Image(systemName: "camera.fill")
                            .foregroundColor(.white)
                        Text("Upload from Camera")
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
                
                // Photo Library Upload Button
                Button(action: {
                    // Handle photo library upload
                }) {
                    HStack {
                        Image(systemName: "photo.fill")
                            .foregroundColor(.nfgBlue)
                        Text("Upload from Photos")
                            .foregroundColor(.nfgBlue)
                            .fontWeight(.bold)
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.nfgBlue, lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .background(Color(UIColor.systemBackground))
            .navigationBarItems(trailing: Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            })
        }
    }
}

#Preview {
    DriverHomeView(isPresented: .constant(true))
} 