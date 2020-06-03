//
//  ImageDetailViewController.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 03.06.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // MARK: - Properties
    var delegate: ImageDetailViewProtocol?
    var imageInfo: ImageResult!
    var currIndex: Int!
    
    private var task: URLSessionDataTask?
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        addTapGestureToToggleHideToolBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setImage()
        
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    // MARK: - Methods
    private func setImage() {
        navigationItem.title = imageInfo.title
        
        // Пытаемся установить из Original,
        // Если что-то пойдет не так - оттуда вызовется setImageFromThumbnail
        setImageFromOriginal()
    }
    
    private func setImageFromOriginal() {
        print("original")
        if let original = imageInfo.original {
            print("original = \(original)")
            task = ImagesManager.shared.loadImage(urlString: original) { image in
                if let image = image {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                } else {
                    // Если что-то пошло не так с оригиналом - устанавливаем хотя бы thumbnail
                    self.setImageFromThumbnail()
                }
            }
            task?.resume()
        }
    }
    
    private func setImageFromThumbnail() {
        print("thumbnail")
        if let thumbnail = imageInfo.thumbnail {
            // Если в thumbnail был base64, то устанавливаем image
            if let imageFromBase64 = UIImage.fromBase64(base64: thumbnail) {
                DispatchQueue.main.async {
                    self.imageView.image = imageFromBase64
                }
            // Если в thumbnail не было base64 - пытаемся скачать по ссылке, которая лежит там
            } else {
                task = ImagesManager.shared.loadImage(urlString: thumbnail) { image in
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
                task?.resume()
            }
        }
    }
    
    // MARK: - Add Gesture Recognizer
    private func addTapGestureToToggleHideToolBar() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleHideToolBar))
        imageView.addGestureRecognizer(tapGesture)
    }

    @objc private func toggleHideToolBar() {
        toolBar.isHidden = !toolBar.isHidden
    }
    
    // MARK: - Actions
    @IBAction func showPreviousImage(_ sender: UIBarButtonItem) {
        print("prev")
        let previousImage = delegate?.previousImage(from: currIndex)
        
        if let previousImage = previousImage {
            // прекращаем скачивание прошлой картинки
            task?.cancel()
            currIndex = previousImage.index
            imageInfo = previousImage.info
            imageView.image = nil
            setImage()
        } else {
            print("Нету больше")
        }
    }
    
    @IBAction func showNextImage(_ sender: UIBarButtonItem) {
        print("next")
        let nextImage = delegate?.nextImage(from: currIndex)
        
        if let nextImage = nextImage {
            // прекращаем скачивание прошлой картинки
            task?.cancel()
            currIndex = nextImage.index
            imageInfo = nextImage.info
            imageView.image = nil
            setImage()
        } else {
            print("Нету больше")
        }
    }
    
    @IBAction func openLink(_ sender: UIBarButtonItem) {
    }
}
