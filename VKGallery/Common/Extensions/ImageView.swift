//
//  ImageView.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 21.04.2023.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(from urlString: String, placeHolder: UIImage? = nil) {
        if let url = URL(string: urlString) {
            self.kf.setImage(with: url, placeholder: placeHolder)
        }
    }

    func enableZoom() {
       let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
       isUserInteractionEnabled = true
       addGestureRecognizer(pinchGesture)
     }

     @objc
     private func startZooming(_ sender: UIPinchGestureRecognizer) {
       let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
       guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
       sender.view?.transform = scale
       sender.scale = 1
     }
}
