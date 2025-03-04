//
//  ImageTemperatureViewModel.swift
//  ImageTempEditor
//
//  Created by Ridho Kurniawan on 04/03/25.
//

import SwiftUI
import Combine

class ImageTemperatureViewModel: ObservableObject {
    @Published var temperature: Float = 0
    @Published var selectedImage: UIImage?
    @Published var editedImage: UIImage?
    @Published var sliderTintColor: Color = .blue
    
    private var cancellables = Set<AnyCancellable>()
    private let processingQueue = DispatchQueue(label: "image.processing", qos: .userInitiated)

    init() {
        // Debounce slider input to avoid excessive processing
        $selectedImage
            .sink { [weak self] _ in
                self?.editedImage = nil
                self?.temperature = 0
            }
            .store(in: &cancellables)
        
        $temperature
            .handleEvents(receiveOutput: { temperature in
                switch temperature {
                case 0: self.sliderTintColor = .gray
                case ..<0: self.sliderTintColor = .blue
                case 0...50: self.sliderTintColor = .orange
                default: self.sliderTintColor = .red
                }
            })
            .debounce(for: .milliseconds(150), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] newTemperature in
                self?.applyTemperatureChange(newTemperature)
            }
            .store(in: &cancellables)
    }
    
    func saveImage() {
        guard let editedImage = editedImage else { return }
        UIImageWriteToSavedPhotosAlbum(editedImage, nil, nil, nil)
    }

    /// Apply temperature changes in the background to avoid UI lag
    private func applyTemperatureChange(_ newValue: Float) {
        guard let originalImage = self.selectedImage else { return }

        processingQueue.async {
            autoreleasepool {
                let newImage = OpenCV.adjustTemperature(for: originalImage, withValue: newValue)
                
                DispatchQueue.main.async {
                    self.editedImage = newImage
                }
            }
        }
    }
}
