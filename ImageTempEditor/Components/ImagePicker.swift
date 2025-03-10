//
//  ImagePicker.swift
//  HelloSwiftUI
//
//  Created by Ridho Kurniawan on 04/03/25.
//

import PhotosUI
import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func picker(
            _ picker: PHPickerViewController,
            didFinishPicking results: [PHPickerResult]
        ) {
            if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self = self, let image = image as? UIImage else { return }

                    Task {
                        await MainActor.run {
                            self.parent.selectedImage = image.normalize()
                        }
                    }
                }
            }

            parent.isImagePickerPresented = false
        }
    }

    @Binding var isImagePickerPresented: Bool
    @Binding var selectedImage: UIImage?

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator

        return picker
    }

    func updateUIViewController(
        _ uiViewController: PHPickerViewController, context: Context
    ) {}
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
