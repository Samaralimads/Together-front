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
    @State private var isSaving = false

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

                Section {
                    Button(role: .destructive) {
                        showDeleteAccountAlert = true
                    } label: {
                        Text("Delete Account")
                    }
                    .alert("Delete Account", isPresented: $showDeleteAccountAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            // TODO: Handle account deletion
                        }
                    } message: {
                        Text("This action cannot be undone. All your data will be permanently deleted.")
                    }
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
                            isSaving = true
                            _ = try? await ProfileService.updateMe(
                                firstName: name.isEmpty ? nil : name,
                                email: email.isEmpty ? nil : email
                            )
                            isSaving = false
                        }
                    }
                    .disabled(isSaving)
                }
            }
        }
        .task {
            await viewModel.load()
            name = viewModel.user?.firstName ?? ""
            email = viewModel.user?.email ?? ""
        }
    }
}
#Preview {
    AboutYouView()
}
