//
//  PHPickerManager.swift
//  Combine&ConcurrentDemo
//
//  Created by alexander.ivanchenko on 26.03.2023.
//

import PhotosUI
import Combine

class PHPickerManager {
    static let shared = PHPickerManager()
    private init() {}
    
    private var passthroughSubject: PassthroughSubject<[PHPickerResult], Never>!
    
    func showPHPicker(with configuration: PHPickerConfiguration = .init()) -> AnyPublisher<[PHPickerResult], Never> {
        let picker = createPHPicker(configuration: configuration)
        passthroughSubject = PassthroughSubject<[PHPickerResult], Never>()
        if let vc = UIViewController.topViewController {
            vc.present(picker, animated: true)
        } else {
            passthroughSubject.send(completion: .finished)
        }
        return passthroughSubject.eraseToAnyPublisher()
    }
    
    private func createPHPicker(configuration: PHPickerConfiguration) -> PHPickerViewController {
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        return picker
    }
}

extension PHPickerManager: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        if !results.isEmpty {
            passthroughSubject.send(results)
        }
        passthroughSubject.send(completion: .finished)
    }
}
