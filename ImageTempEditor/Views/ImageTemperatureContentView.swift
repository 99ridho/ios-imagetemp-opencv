//
//  ImageTemperatureContentView.swift
//  HelloSwiftUI
//
//  Created by Ridho Kurniawan on 08/07/24.
//

import SwiftUI
import Photos

struct ImageTemperatureContentView: View {
    @StateObject private var viewModel = ImageTemperatureViewModel()
    @State private var isImagePickerPresented = false
    @State private var alertShown: Bool = false
    @State private var errorAlertShown: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if let selectedImage = viewModel.selectedImage {
                    Image(uiImage: viewModel.editedImage ?? selectedImage)
                        .resizable()
                        .scaledToFit()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Image Temperature")
                        Slider(value: $viewModel.temperature, in: -100...100, step: 0.1)
                            .tint(viewModel.sliderTintColor)
                        
                        Button(action: {
                            self.saveImage()
                        }) {
                            HStack {
                                Image(systemName: "externaldrive.fill")
                                Text("Save")
                                    .fontWeight(.bold)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(viewModel.temperature != 0 ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                        }
                        .buttonStyle(.borderless)
                        .padding()
                        .disabled(viewModel.temperature == 0)
                    }
                    
                } else {
                    Text("To start, select the photo first")
                }
            }
            .padding()
            .navigationTitle("Hot or Warm Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("add_image_button", systemImage: "plus") {
                        self.isImagePickerPresented = true
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    if self.viewModel.temperature != 0 {
                        Button {
                            self.viewModel.temperature = 0
                        } label: {
                            Text("Reset")
                        }
                    }
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(
                    isImagePickerPresented: $isImagePickerPresented,
                    selectedImage: $viewModel.selectedImage
                )
            }
            .alert("Save Image Success", isPresented: $alertShown) {
                Button("OK") {
                    self.alertShown = false
                }
            }
            .onAppear {
                print(OpenCV.getVersion())
            }
        }
    }
    
    private func saveImage() {
        let doSaveImage: () -> Void = { () in
            self.viewModel.saveImage()
            self.alertShown = true
        }
        
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        
        switch status {
        case .authorized:
            doSaveImage()
        case .denied, .restricted:
            self.errorAlertShown = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        doSaveImage()
                    case .denied, .restricted:
                        self.errorAlertShown = true
                    case .notDetermined:
                        break
                    case .limited:
                        break
                    @unknown default:
                        break
                    }
                }
            }
        case .limited:
            break
        @unknown default:
            break
        }
    }
}

#Preview {
    ImageTemperatureContentView()
}
