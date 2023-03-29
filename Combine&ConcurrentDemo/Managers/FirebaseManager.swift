//
//  FirebaseManager.swift
//  Combine&ConcurrentDemo
//
//  Created by alexander.ivanchenko on 26.03.2023.
//

import Foundation
import FirebaseStorage
import Combine

enum AppError: String, Error {
    case unknown
    case topViewControllerNotFound
    
    var localizedDescription: String? {
        self.rawValue.reduce("", { $0 + ($1.isUppercase ? " \($1)" : "\($1)") }).lowercased().capitalizedSentence
    }
}

class FirebaseManager {
    static let shared = FirebaseManager()
    private init() {}
    
    private let storageReference = Storage.storage().reference()
    
    func upload(_ data: Data,
                metadata: StorageMetadata? = nil,
                to fouldersPath: [String] = [],
                fileName: String = UUID().uuidString) -> AnyPublisher<StorageTaskSnapshot, Error> {

        let lastFoulderReference = fouldersPath.reduce(storageReference) { $0.child($1) }
        let fileReference = lastFoulderReference.child(fileName)
        
        let uploadTask: StorageUploadTask = fileReference.putData(data, metadata: metadata)
        
        let uploadingSubject = PassthroughSubject<StorageTaskSnapshot, Error>()
        
        uploadTask.observe(.progress) { snapshot in
            uploadingSubject.send(snapshot)
        }
        
        uploadTask.observe(.success) { snapshot in
            uploadingSubject.send(snapshot)
            uploadingSubject.send(completion: .finished)
        }
        
        uploadTask.observe(.failure) { snapshot in
            uploadingSubject.send(snapshot)
            uploadingSubject.send(completion: .failure(snapshot.error ?? AppError.unknown))
        }
        
        return uploadingSubject
            .handleEvents(receiveCancel: { uploadTask.cancel() })
            .eraseToAnyPublisher()
    }
}
