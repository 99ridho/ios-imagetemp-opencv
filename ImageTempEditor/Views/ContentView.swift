//
//  ContentView.swift
//  HelloSwiftUI
//
//  Created by Ridho Kurniawan on 08/07/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var temperature: Float = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if let selectedImage = self.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Image Temperature")
                        Slider(value: $temperature, in: -100...100, step: 1)
                            .tint(temperature == 0 ? .gray : temperature < 0 ? .blue : temperature > 0 && temperature <= 50 ? .orange : .red)
                        
                        Button(action: {
                            print("Save button tapped")
                        }) {
                            HStack {
                                Image(systemName: "externaldrive.fill") // Floppy disk icon alternative
                                Text("Save")
                                    .fontWeight(.bold)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                        }
                        .buttonStyle(.borderless) // Ensures no unwanted styling
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
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(
                    isImagePickerPresented: $isImagePickerPresented,
                    selectedImage: $selectedImage
                )
            }
            .onChange(of: temperature) { oldValue, newValue in
                print(newValue)
            }
            .onAppear {
                print(OpenCV.getVersion())
            }
        }
    }
}

#Preview {
    ContentView()
}
