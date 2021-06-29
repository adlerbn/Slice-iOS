//
//  UIImageView + Extension.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/27/21.
//

import UIKit
import ImageIO

class ImageDownloader {
    static func getData(from url: URL?, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let url = url else { return }
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
