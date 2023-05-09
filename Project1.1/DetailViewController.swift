//
//  DetailViewController.swift
//  Project1.1
//
//  Created by Maks Vogtman on 14/07/2022.
//

import UIKit

extension UIImage {
    func withOrientation(_ orientation: UIImage.Orientation) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        draw(in: rect)
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let image = normalizedImage else {
            return self
        }

        return UIImage(cgImage: image.cgImage!, scale: scale, orientation: orientation)
    }
}

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        
        if let imageLoad = selectedImage {
            imageView.image = UIImage(named: imageLoad)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    
    @objc func shareTapped() {
        guard let originalImage = imageView?.image, let imageData = originalImage.jpegData(compressionQuality: 1.0) else {
               print("No picture found")
               return
           }

           guard let image = UIImage(data: imageData) else {
               print("Unable to load image data")
               return
           }
        
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let sharedImage = renderer.image { ctx in
            image.withOrientation(.up).draw(in: CGRect(origin: .zero, size: image.size))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 20),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "From Storm Viewer"
            
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 32, y: 32, width: image.size.width - 20, height: image.size.height - 20), options: .usesLineFragmentOrigin, context: nil)
        }
        
        imageView.image = sharedImage
        
        let vc = UIActivityViewController(activityItems: [sharedImage], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
