//
//  ImageUploadingService.swift
//  Combine&ConcurrentDemo
//
//  Created by alexander.ivanchenko on 26.03.2023.
//

import Foundation
import Combine
import Firebase
import CombineFirebase

protocol ImageUploadingServiceType {
    func uploadImages(_ images: [UIImage], threadsCount: Int) -> AnyPublisher<[StorageTaskSnapshot?], Error>
    func cancelUploading()
}

class ImageUploadingService {
    private let imagesUploadingQueue = DispatchQueue(label: "images.uploading.queue", qos: .background, attributes: .concurrent)
    private var uploadingTasks = Set<AnyCancellable>()
    private var stop = false //kostul to prevent semaphore error - calcelling while in use
}

extension ImageUploadingService: ImageUploadingServiceType {
    func uploadImages(_ images: [UIImage], threadsCount: Int) -> AnyPublisher<[StorageTaskSnapshot?], Error> {
        stop = false
        
        let dispatchSemaphore = DispatchSemaphore(value: threadsCount)
        let uploadingSubject = CurrentValueSubject<[StorageTaskSnapshot?], Error>(images.replacingAllWithNil())
        
        let foulderName = "\(Date.now)"
        
        let dispatchGroup = DispatchGroup()
        images.forEach { _ in dispatchGroup.enter() }
        
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else { return }
            
            for (index, image) in images.enumerated() {
                dispatchSemaphore.wait()
                
                if self.stop {
                    dispatchSemaphore.signal()
                    return
                }
                
                self.imagesUploadingQueue.async {
                    let pngData = image.pngData()!
                    let imageName = UUID().uuidString + ".png"
                    
                    FirebaseManager.shared.upload(pngData, to: [foulderName], fileName: imageName)
                        .handleEvents(receiveCancel: { dispatchSemaphore.signal() })
                        .sink(receiveCompletion: { completion in
                            dispatchSemaphore.signal()
                            switch completion {
                            case .failure(let error):
                                uploadingSubject.send(completion: .failure(error))
                            case .finished:
                                dispatchGroup.leave()
                            }
                        }, receiveValue: { snapshot in
                            guard uploadingSubject.value.indices.contains(index) else { return }
                            uploadingSubject.value[index] = snapshot
                        })
                        .store(in: &self.uploadingTasks)
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            uploadingSubject.send(completion: .finished)
        }
        
        return uploadingSubject.eraseToAnyPublisher()
    }
    
    func cancelUploading() {
        stop = true
        uploadingTasks.forEach { $0.cancel() }
        uploadingTasks.removeAll()
    }
}
