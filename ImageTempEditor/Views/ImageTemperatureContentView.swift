//
//  ImageTemperatureContentView.swift
//  HelloSwiftUI
//
//  Created by Ridho Kurniawan on 08/07/24.
//

import SwiftUI

struct ImageTemperatureContentView: View {
    @StateObject private var viewModel = ImageTemperatureViewModel()
    @State private var isImagePickerPresented = false

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
                            print("Save button tapped")
                        }) {
                            HStack {
                                Image(systemName: "externaldrive.fill")
                                Text("Save")
                                    .fontWeight(.bold)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                        }
                        .buttonStyle(.borderless)
                        .padding()
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
            .onAppear {
                print(OpenCV.getVersion())
            }
        }
    }
}

#Preview {
    ImageTemperatureContentView()
}
