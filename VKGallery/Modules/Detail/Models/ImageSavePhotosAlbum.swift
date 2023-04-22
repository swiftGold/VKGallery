//
//  ImageSavePhotosAlbum.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 22.04.2023.
//

import UIKit

final class ImageSavePhotosAlbum: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}
