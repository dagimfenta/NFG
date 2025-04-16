import SwiftUI

struct CreateDriverView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = DriverCreationViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.colorScheme) var systemColorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // First Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("First Name")
                            .font(.baskervilleMedium(size: 16))
                            .foregroundColor(.nfgBlue)
                        TextField("Enter first name", text: $viewModel.firstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.words)
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
                    
                    // Last Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Last Name")
                            .font(.baskervilleMedium(size: 16))
                            .foregroundColor(.nfgBlue)
                        TextField("Enter last name", text: $viewModel.lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.words)
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
                    
                    // Email
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.baskervilleMedium(size: 16))
                            .foregroundColor(.nfgBlue)
                        TextField("Enter email", text: $viewModel.email)
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
                    
                    // Phone Number
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Phone Number")
                            .font(.baskervilleMedium(size: 16))
                            .foregroundColor(.nfgBlue)
                        TextField("Enter phone number", text: $viewModel.phoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.phonePad)
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
                    
                    // Password
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.baskervilleMedium(size: 16))
                            .foregroundColor(.nfgBlue)
                        SecureField("Enter password", text: $viewModel.password)
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
                    
                    // Confirm Password
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Confirm Password")
                            .font(.baskervilleMedium(size: 16))
                            .foregroundColor(.nfgBlue)
                        SecureField("Confirm password", text: $viewModel.confirmPassword)
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
                    
                    // Create Account Button
                    Button(action: {
                        viewModel.createDriver { result in
                            switch result {
                            case .success:
                                dismiss()
                            case .failure(let error):
                                viewModel.errorMessage = error.localizedDescription
                                viewModel.showingError = true
                            }
                        }
                    }) {
                        Text("Create Driver Account")
                            .font(.headline.weight(.bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.nfgBlue)
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 20)
                    .disabled(viewModel.isCreating)
                }
                .padding(.vertical, 20)
            }
            .background(Color.backgroundColor(for: systemColorScheme))
            .navigationBarTitle("Create Driver Account", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            })
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
} 