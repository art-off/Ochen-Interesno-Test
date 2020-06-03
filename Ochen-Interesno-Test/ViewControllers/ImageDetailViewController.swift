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
        
        // Если есть оригинал - качаем из него
        if let original = imageInfo.original {
            print("original")
            ImagesManager.shared.loadImage(urlString: original) { image in
                print("original - \(image)")
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        // Если есть хотя бы thumbnail - качаем из него
        } else if let thumbnail = imageInfo.thumbnail {
            print("thumbnail")
            // Если в thumbnail был base64, то устанавливаем image
            if let imageFromBase64 = UIImage.fromBase64(base64: thumbnail) {
                print("thumbnail base64 - \(imageFromBase64)")
                imageView.image = imageFromBase64
            // Если в thumbnail не было base64 - пытаемся скачать по ссылке, которая лежит там
            } else {
                ImagesManager.shared.loadImage(urlString: thumbnail) { image in
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
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
            currIndex = previousImage.index
            imageInfo = previousImage.info
            setImage()
        } else {
            print("Нету больше")
        }
    }
    
    @IBAction func showNextImage(_ sender: UIBarButtonItem) {
        print("next")
        let nextImage = delegate?.nextImage(from: currIndex)
        
        if let nextImage = nextImage {
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
