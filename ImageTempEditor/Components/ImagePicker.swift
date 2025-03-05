//
//  ImagePicker.swift
//  HelloSwiftUI
//
//  Created by Ridho Kurniawan on 04/03/25.
//


import SwiftUI
import UIKit

// A wrapper for UIImagePickerController
struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image.normalize()
            }
            parent.isImagePickerPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isImagePickerPresented = false
        }
    }
    
    @Binding var isImagePickerPresented: Bool
    @Binding var selectedImage: UIImage?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

extension UIImage {
    func normalize() -> UIImage {
        // If the image is already in the correct orientation, return it
        if self.imageOrientation == .up {
            return self
        }

        // Define the drawing context
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        defer { UIGraphicsEndImageContext() }

        // Draw the image in the correct orientation
        self.draw(in: CGRect(origin: .zero, size: self.size))

        // Get the new image from context
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}
