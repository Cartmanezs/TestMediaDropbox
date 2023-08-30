//
//  MediaNetworkManager.swift
//  TestMediaDropBox
//
//  Created by Igor Palyvoda on 27.08.2023.
//

import Foundation
import SwiftyDropbox


class MediaNetworkManager {
    static let shared = MediaNetworkManager()
    
    private let mediaFileCache = NSCache<NSString, CachableMediaFile>()
    private let cacheKey = "cachedMediaFiles"
    private let folderPath = "<YOUR_FOLDER>"
    
    func loadImage(for mediaFile: MediaFile, completion: @escaping (UIImage?) -> Void) {
        let photoPath = folderPath + (mediaFile.name ?? "")
        if let cachedImage = mediaFile.imageCache.object(forKey: photoPath as NSString) {
            completion(cachedImage)
        } else {
            loadImageFromDropbox(for: mediaFile, completion: completion)
        }
    }
    
    private func loadImageFromDropbox(for mediaFile: MediaFile, completion: @escaping (UIImage?) -> Void) {
        let photoPath = folderPath + (mediaFile.name ?? "")
        if let cachedImage = mediaFile.imageCache.object(forKey: photoPath as NSString) {
            completion(cachedImage)
            return
        }
        
        if let client = DropboxClientsManager.authorizedClient {
            client.files.download(path: photoPath).response { response, error in
                if let (_, data) = response {
                    if let image = UIImage(data: data) {
                        mediaFile.imageCache.setObject(image, forKey: photoPath as NSString)
                        completion(image)
                    } else {
                        completion(nil)
                    }
                } else if let error = error {
                    print("Failed to fetch image: \(error)")
                    completion(nil)
                }
            }
        }
    }
    
    func fetchMediaFiles( completion: @escaping ([MediaFile]) -> Void) {
        if let cachedMediaFiles = mediaFileCache.object(forKey: cacheKey as NSString)?.mediaFiles {
            completion(cachedMediaFiles)
            return
        }
        guard let client = DropboxClientsManager.authorizedClient else { return }
        
        client.files.listFolder(path: folderPath).response { response, error in
            if let result = response {
                let mediaFiles = result.entries.compactMap { entry -> MediaFile? in
                    if let fileMetadata = entry as? Files.FileMetadata {
                        let name = fileMetadata.name
                        let id = fileMetadata.id
                        let imagePath = fileMetadata.pathDisplay
                        let lastChanges = fileMetadata.clientModified
                        let mediaFile = MediaFile(id: id, name: name, path: imagePath, lastChanges: lastChanges)
                        
                        return mediaFile
                    }
                    if result.hasMore {
                        self.filesContinue(path: self.folderPath, result.cursor, completion)
                    }
                    return nil
                }
                
                completion(mediaFiles)
            } else if let error = error {
                print("Error fetching media files: \(error)")
                DropboxClientsManager.unlinkClients()
                completion([])
            }
        }
    }
    
    private func filesContinue(path: String, _ cursor: String, _ handler: @escaping ([MediaFile]) -> Void) {
        guard let client = DropboxClientsManager.authorizedClient else { return }
        client.files.listFolderContinue(cursor: cursor).response { result, error in
            result.map { result in
                let mediaFiles = result.entries.compactMap { entry -> MediaFile? in
                    if let fileMetadata = entry as? Files.FileMetadata {
                        let name = fileMetadata.name
                        let id = fileMetadata.id
                        let imagePath = fileMetadata.pathDisplay
                        let lastChanges = fileMetadata.clientModified
                        let mediaFile = MediaFile(id: id, name: name, path: imagePath, lastChanges: lastChanges)
                        
                        return mediaFile
                    }
                    if result.hasMore {
                        self.filesContinue(path: path, result.cursor, handler)
                    }
                    return nil
                }
                handler(mediaFiles)
                error.map { error in
                    fatalError("listFolderContinue failed. \(error.description)")
                }
            }
        }
    }
}
