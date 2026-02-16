//
//  ProfileAvatarsCard.swift
//  Together
//
//  Created by Samara Lima da Silva on 16/02/2026.
//
import SwiftUI

struct ProfileAvatarsCard: View {
    let partner1Initial: String
    let partner2Initial: String?
    let profileImage: UIImage?
    let onCameraClick: () -> Void
    let onAddPartnerClick: () -> Void
    
    var body: some View {
        ZStack {
            HStack(spacing: -10){
                
                // First avatar (current user)
                Circle()
                    .stroke(.lilas, lineWidth: 7)
                    .fill(.branco)
                    .frame(width: 100, height: 100)
                    .overlay(
                        Group {
                            if let image = profileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else {
                                Text(partner1Initial)
                                    .font(.system(size: 40, weight: .semibold))
                                    .foregroundColor(.lilas)
                            }
                        }
                    )
                    .zIndex(1)
                
                // Second avatar (partner or add button)
                    Circle()
                        .stroke(.verde, lineWidth: 7)
                        .fill(.branco)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Group {
                                if let initial = partner2Initial {
                                    Text(initial)
                                        .font(.system(size: 40, weight: .semibold))
                                        .foregroundColor(.verde)
                                } else {
                                    Button {
                                        onAddPartnerClick()
                                    } label: {
                                        Image(systemName: "person.badge.plus.fill")
                                            .font(.system(size: 35))
                                            .foregroundColor(.verde)
                                    }
                                }
                            }
                        )
            }
            .overlay(alignment: .bottomTrailing) {
                // Camera icon
                Button {
                    onCameraClick()
                } label: {
                    ZStack {
                        Circle()
                            .stroke(.lilas, lineWidth: 5)
                            .fill(.branco)
                            .frame(width: 35, height: 35)
                        
                        Image(systemName: "camera.fill")
                            .foregroundColor(.lilas)
                            .font(.system(size: 17))
                    }
                }
                .offset(x: -95, y: 10)
            }
        }
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
