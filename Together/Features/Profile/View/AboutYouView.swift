//
//  AboutYouView.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/02/2026.
//

import SwiftUI

struct AboutYouView: View {
    @State private var viewModel = ProfileViewModel()
    @State private var name = ""
    @State private var email = ""
    @State private var showDeleteAccountAlert = false
    @Environment(AppState.self) private var appState

    var body: some View {
        Background {
            List {
                Section {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("Enter your name", text: $name)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 10)

                    HStack {
                        Text("Email")
                        Spacer()
                        TextField("Enter your email", text: $email)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(.secondary)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                    }
                    .padding(.vertical, 10)
                }
                .tint(.accent)

                Section {
                    NavigationLink("Reset password", destination: ForgotPasswordView())
                }
                .tint(.primary)
                .padding(.vertical, 10)

                if let error = viewModel.deleteError {
                    Section {
                        Text(error)
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                }

                Section {
                    Button(role: .destructive) {
                        showDeleteAccountAlert = true
                    } label: {
                        if viewModel.isDeleting {
                            HStack {
                                ProgressView()
                                Text("Deleting…")
                            }
                        } else {
                            Text("Delete Account")
                        }
                    }
                    .disabled(viewModel.isDeleting)
                }
                .padding(.vertical, 9)
            }
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("About You")
                        .font(.title.weight(.semibold))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await viewModel.saveProfile(firstName: name, email: email)
                        }
                    }
                    .disabled(viewModel.isSaving)
                }
            }
        }
        .task {
            await viewModel.load()
            name = viewModel.user?.firstName ?? ""
            email = viewModel.user?.email ?? ""
        }
        .alert("Delete Account", isPresented: $showDeleteAccountAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel.deleteAccount()
                    appState.logout()
                }
            }
        } message: {
            Text("This action cannot be undone. All your data will be permanently deleted.")
        }
    }
}

#Preview {
    AboutYouView()
        .environment(AppState())
}
