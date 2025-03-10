//
//  ImageTemperatureViewModel.swift
//  ImageTempEditor
//
//  Created by Ridho Kurniawan on 04/03/25.
//

import Combine
import SwiftUI

@MainActor
class ImageTemperatureViewModel: ObservableObject {
    @Published var temperature: Float = 0
    @Published var selectedImage: UIImage?
    @Published var editedImage: UIImage?
    @Published var sliderTintColor: Color = .blue

    private var cancellables = Set<AnyCancellable>()

    init() {
        $selectedImage
            .sink { [weak self] _ in
                self?.editedImage = nil
                self?.temperature = 0
            }
            .store(in: &cancellables)

        // Throttling slider input to avoid excessive processing
        $temperature
            .handleEvents(receiveOutput: { [weak self] temperature in
                switch temperature {
                case 0: self?.sliderTintColor = .gray
                case ..<0: self?.sliderTintColor = .blue
                case 0...50: self?.sliderTintColor = .orange
                default: self?.sliderTintColor = .red
                }
            })
            .throttle(
                for: .milliseconds(200), scheduler: DispatchQueue.main,
                latest: true
            )
            .removeDuplicates()
            .sink { [weak self] newTemperature in
                Task {
                    await self?.applyTemperatureChange(newTemperature)
                }
            }
            .store(in: &cancellables)
    }

    func saveImage() {
        guard let editedImage = editedImage else { return }
        UIImageWriteToSavedPhotosAlbum(editedImage, nil, nil, nil)
    }

    /// Apply temperature changes in the background to avoid UI lag
    private func applyTemperatureChange(_ newValue: Float) async {
        guard let originalImage = self.selectedImage else { return }

        let newImage = await Task.detached(priority: .userInitiated) {
            return OpenCV.adjustTemperature(
                for: originalImage,
                withValue: newValue
            )
        }.value

        self.editedImage = newImage
    }
}
